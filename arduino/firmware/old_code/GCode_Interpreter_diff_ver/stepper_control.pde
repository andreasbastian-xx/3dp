/* -*- mode: c++; c-basic-offset: 8; indent-tabs-mode: t -*- */

#include "_init.h"
#include "utils.h"

//init our variables
long max_delta;
long counter[3];
int milli_delay;

#if INVERT_ENABLE_PINS == 1
#define ENABLE_ON LOW
#else
#define ENABLE_ON HIGH
#endif

void init_steppers()
{
	//turn them off to start.
	disable_steppers();
    
	for (uint8_t i=0;i<3;i++)
	{
		current_units.p[i] = 0.0;
		target_units.p[i] = 0.0;
    
		const AxisConfig &a = axes[i];
		pinMode(a.step_pin, OUTPUT);
		pinMode(a.dir_pin, OUTPUT);
		pinMode(a.enable_pin, OUTPUT);
    
		if (a.min_endstop_enabled) pinMode(a.min_pin, INPUT);
		if (a.max_endstop_enabled) pinMode(a.max_pin, INPUT);
	}

	//figure our stuff.
	calculate_deltas();
}

void dda_move(long micro_delay)
{
	//turn on steppers to start moving =)
	enable_steppers();
  
	//figure out our deltas
	max_delta = max(delta_steps.p[X_AXIS], delta_steps.p[Y_AXIS]);
	max_delta = max(delta_steps.p[Z_AXIS], max_delta);
  
	//init stuff.
	counter[0] = -max_delta/2;
	counter[1] = -max_delta/2;
	counter[2] = -max_delta/2;
  
	//our step flags
	bool can_step_flags[3] = {false, false, false};

	//how long do we delay for?
	// We subtract the expected overhead of the loop to make the real speed
	// closer to our target feedrate. FIXME: This is just a hack and should
	// be handled properly.
	micro_delay -= 100;
	if (micro_delay >= 16383) milli_delay = micro_delay / 1000;
	else milli_delay = 0;
  
	//do our DDA line!
	do
	{
		for (uint8_t i=0;i<3;i++)
		{
			const AxisConfig &a = axes[i]; 
			can_step_flags[i] = can_step(a.min_endstop_enabled, a.max_endstop_enabled, 
						     a.min_pin, a.max_pin, 
						     current_steps.p[i], target_steps.p[i], direction[i]);

			if (can_step_flags[i])
			{
				counter[i] += delta_steps.p[i];
        
				if (counter[i] > 0)
				{
					do_step(a.step_pin);
					counter[i] -= max_delta;
          
					if (direction[i]) current_steps.p[i]++;
					else current_steps.p[i]--;
				}
			}
		}
    
		//keep it hot =)
		extruder_manage_temperature();
    
		//wait for next step.
		if (milli_delay > 0)
			delay(milli_delay);			
		else
			delayMicrosecondsInterruptible(micro_delay);
	}
	while (can_step_flags[X_AXIS] || can_step_flags[Y_AXIS] || can_step_flags[Z_AXIS]);
  
	//set our points to be the same
	current_units.p[X_AXIS] = target_units.p[X_AXIS];
	current_units.p[Y_AXIS] = target_units.p[Y_AXIS];
	current_units.p[Z_AXIS] = target_units.p[Z_AXIS];
	calculate_deltas();
}

bool can_step(bool minenabled, bool maxenabled, byte min_pin, byte max_pin, 
              long current, long target, bool direction)
{
	//stop us if we're on target
	if (target == current) return false;
	//stop us if we're at home and still going 
	else if (minenabled && read_switch(min_pin) && !direction) return false;
	//stop us if we're at max and still going
	else if (maxenabled && read_switch(max_pin) && direction) return false;
  
	//default to being able to step
	return true;
}

void do_step(byte step_pin)
{
	digitalWrite(step_pin, HIGH);
	delayMicroseconds(5);
	digitalWrite(step_pin, LOW);
}

bool read_switch(byte pin)
{
	//dual read as crude debounce
#if ENDSTOPS_INVERTING == 1
	return !digitalRead(pin) && !digitalRead(pin);
#else
	return digitalRead(pin) && digitalRead(pin);
#endif
}

long to_steps(float steps_per_unit, float units)
{
	return steps_per_unit * units;
}

void set_target(float x, float y, float z)
{
	target_units.p[X_AXIS] = x;
	target_units.p[Y_AXIS] = y;
	target_units.p[Z_AXIS] = z;
  
	calculate_deltas();
}

void set_position(float x, float y, float z)
{
	current_units.p[X_AXIS] = x;
	current_units.p[Y_AXIS] = y;
	current_units.p[Z_AXIS] = z;
  
	calculate_deltas();
}

void calculate_deltas()
{
	for (uint8_t i=0;i<3;i++)
	{
		const AxisConfig &a = axes[i];

		//figure our deltas.
		delta_units.p[i] = abs(target_units.p[i] - current_units.p[i]);
				
		//set our steps current, target, and delta
		current_steps.p[i] = to_steps(units[i], current_units.p[i]);
  
		target_steps.p[i] = to_steps(units[i], target_units.p[i]);
  
		delta_steps.p[i] = abs(target_steps.p[i] - current_steps.p[i]);

		//what is our direction
		direction[i] = (target_units.p[i] >= current_units.p[i]);
  
		//set our direction pins as well
		digitalWrite(a.dir_pin, a.invert_dir ^ direction[i]);
	}
}


long calculate_feedrate_delay(float feedrate)
{
	//how long is our line length?
	float distance = sqrt(delta_units.p[X_AXIS]*delta_units.p[X_AXIS] + 
			      delta_units.p[Y_AXIS]*delta_units.p[Y_AXIS] + 
			      delta_units.p[Z_AXIS]*delta_units.p[Z_AXIS]);
	long master_steps = 0;
  
	//find the dominant axis.
	if (delta_steps.p[X_AXIS] > delta_steps.p[Y_AXIS])
	{
		if (delta_steps.p[Z_AXIS] > delta_steps.p[X_AXIS])
			master_steps = delta_steps.p[Z_AXIS];
		else
			master_steps = delta_steps.p[X_AXIS];
	}
	else
	{
		if (delta_steps.p[Z_AXIS] > delta_steps.p[Y_AXIS])
			master_steps = delta_steps.p[Z_AXIS];
		else
			master_steps = delta_steps.p[Y_AXIS];
	}
  
	//calculate delay between steps in microseconds.  this is sort of tricky, but not too bad.
	//the formula has been condensed to save space.  here it is in english:
	// (feedrate is in mm/minute)
	// distance / feedrate * 60000000.0 = move duration in microseconds
	// move duration / master_steps = time between steps for master axis.
  
	return ((distance * 60000000.0) / feedrate) / master_steps;	
}

long getMaxSpeed()
{
	if (delta_steps.p[Z_AXIS] > 0)
		return calculate_feedrate_delay(FAST_Z_FEEDRATE);
	else
		return calculate_feedrate_delay(FAST_XY_FEEDRATE);
}

void enable_steppers()
{
	// Enable steppers only for axes which are moving
	// taking account of the fact that some or all axes
	// may share an enable line (check using macros at
	// compile time to avoid needless code)
	if (target_units.p[X_AXIS] == current_units.p[X_AXIS]
#if X_ENABLE_PIN == Y_ENABLE_PIN
	    && target_units.p[Y_AXIS] == current_units.p[Y_AXIS]
#endif
#if X_ENABLE_PIN == Z_ENABLE_PIN
	    && target_units.p[Z_AXIS] == current_units.p[Z_AXIS]
#endif
	    )
		digitalWrite(X_ENABLE_PIN, !ENABLE_ON);
	else
		digitalWrite(X_ENABLE_PIN, ENABLE_ON);
	if (target_units.p[Y_AXIS] == current_units.p[Y_AXIS]
#if Y_ENABLE_PIN == X_ENABLE_PIN
	    && target_units.p[X_AXIS] == current_units.p[X_AXIS]
#endif
#if Y_ENABLE_PIN == Z_ENABLE_PIN
	    && target_units.p[Z_AXIS] == current_units.p[Z_AXIS]
#endif
	    )
		digitalWrite(Y_ENABLE_PIN, !ENABLE_ON);
	else
		digitalWrite(Y_ENABLE_PIN, ENABLE_ON);
	if (target_units.p[Z_AXIS] == current_units.p[Z_AXIS]
#if Z_ENABLE_PIN == X_ENABLE_PIN
	    && target_units.p[X_AXIS] == current_units.p[X_AXIS]
#endif
#if Z_ENABLE_PIN == Y_ENABLE_PIN
	    && target_units.p[Y_AXIS] == current_units.p[Y_AXIS]
#endif
	    )
		digitalWrite(Z_ENABLE_PIN, !ENABLE_ON);
	else
		digitalWrite(Z_ENABLE_PIN, ENABLE_ON);
}

void disable_steppers()
{
	//disable our steppers
	digitalWrite(X_ENABLE_PIN, !ENABLE_ON);
#if Y_ENABLE_PIN != X_ENABLE_PIN
	digitalWrite(Y_ENABLE_PIN, !ENABLE_ON);
#endif
#if (Z_ENABLE_PIN != X_ENABLE_PIN && Z_ENABLE_PIN != Y_ENABLE_PIN)
	digitalWrite(Z_ENABLE_PIN, !ENABLE_ON);
#endif
}


void home_axis(Axis axis)
{
	const AxisConfig &a = axes[axis];

	// Seek to home
	FloatPoint fp = {current_units.p[X_AXIS], current_units.p[Y_AXIS], current_units.p[Z_AXIS]};
	// Go to a position guaranteed to be outside the axis
	fp.p[axis] = 1000.0*(a.reference_dir?1.0:-1.0);
	set_target(fp.p[X_AXIS], fp.p[Y_AXIS], fp.p[Z_AXIS]);
	feedrate_micros = calculate_feedrate_delay(feedrate);
	dda_move(feedrate_micros);

	// Move slowly until reference switch is off again, to move to the exact reference
	enable_steppers();
	digitalWrite(a.dir_pin, !(a.reference_dir ^ a.invert_dir));
	while (read_switch(a.reference_dir?a.max_pin:a.min_pin))
	{
		do_step(a.step_pin); 
		delay(10); // Really slow. FIXME: This machine dependant
	}
}
