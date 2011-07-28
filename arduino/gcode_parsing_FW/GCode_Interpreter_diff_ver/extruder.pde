/* -*- mode: c++; c-basic-offset: 8; indent-tabs-mode: t -*- */

#include "ThermistorTable.h"

#define EXTRUDER_FORWARD true
#define EXTRUDER_REVERSE false

//these our the default values for the extruder.
int extruder_speed = 128;
int extruder_target_celsius = 0;
int extruder_max_celsius = 0;
byte extruder_heater_low = 64;
byte extruder_heater_high = 255;
byte extruder_heater_current = 0;

//this is for doing encoder based extruder control
int extruder_rpm = 0;
long extruder_delay = 0;
int extruder_error = 0;
int last_extruder_error = 0;
int extruder_error_delta = 0;
bool extruder_direction = EXTRUDER_FORWARD;

void init_extruder()
{
	//default to room temp.
	extruder_set_temperature(21);
	
	//setup our pins
	pinMode(EXTRUDER_MOTOR_DIR_PIN, OUTPUT);
	pinMode(EXTRUDER_MOTOR_SPEED_PIN, OUTPUT);
	pinMode(EXTRUDER_HEATER_PIN, OUTPUT);
	pinMode(EXTRUDER_FAN_PIN, OUTPUT);
	
	//initialize values
	digitalWrite(EXTRUDER_MOTOR_DIR_PIN, EXTRUDER_FORWARD);
	analogWrite(EXTRUDER_FAN_PIN, 0);
	analogWrite(EXTRUDER_HEATER_PIN, 0);
	analogWrite(EXTRUDER_MOTOR_SPEED_PIN, 0);
}

void extruder_set_direction(bool direction)
{
	extruder_direction = direction;
	digitalWrite(EXTRUDER_MOTOR_DIR_PIN, direction);
}

void extruder_set_speed(byte speed)
{
	analogWrite(EXTRUDER_MOTOR_SPEED_PIN, speed);
}

void extruder_set_cooler(byte speed)
{
	analogWrite(EXTRUDER_FAN_PIN, speed);
}

void extruder_set_temperature(int temp)
{
	extruder_target_celsius = temp;
	extruder_max_celsius = (int)((float)temp * 1.1);
}

/**
 *  Samples the temperature and converts it to degrees celsius.
 *  Returns degrees celsius.
 */
int extruder_get_temperature()
{
#if EXTRUDER_THERMISTOR_PIN >= 0
	return extruder_read_thermistor();
#elif EXTRUDER_THERMOCOUPLE_PIN >= 0
	return extruder_read_thermocouple();
#endif
}

/*
 * This function gives us the temperature from the thermistor in Celsius
 */
int extruder_read_thermistor()
{
	int raw = extruder_sample_temperature(EXTRUDER_THERMISTOR_PIN);

	int celsius = 0;
	byte i;

	for (i=1; i<NUMTEMPS; i++)
	{
			if (TempTable[i][0] > raw)
			{
					celsius  = TempTable[i-1][1] + 
						(raw - TempTable[i-1][0]) * 
						(TempTable[i][1] - TempTable[i-1][1]) /
						(TempTable[i][0] - TempTable[i-1][0]);

					break;
			}
	}

	// Overflow: Set to last value in the table
	if (i == NUMTEMPS) celsius = TempTable[i-1][1];
	// Clamp to byte
	if (celsius > 255) celsius = 255; 
	else if (celsius < 0) celsius = 0; 

	return celsius;
}


#if EXTRUDER_THERMOCOUPLE_PIN >= 0
/*
 * This function gives us the temperature from the thermocouple in Celsius
 */
int extruder_read_thermocouple()
{
	return ( 5.0 * extruder_sample_temperature(EXTRUDER_THERMOCOUPLE_PIN) * 100.0) / 1024.0;
}
#endif

/*
 * This function gives us an averaged sample of the analog temperature pin.
 */
int extruder_sample_temperature(byte pin)
{
	int raw = 0;
	
	//read in a certain number of samples
	for (byte i=0; i<TEMPERATURE_SAMPLES; i++)
		raw += analogRead(pin);
		
	//average the samples
	raw = raw/TEMPERATURE_SAMPLES;

	//send it back.
	return raw;
}

/*!
  Manages motor and heater based on measured temperature:
  o If temp is too low, don't start the motor
  o Adjust the heater power to keep the temperature at the target
*/
void extruder_manage_temperature()
{
	static long lastread = 0;

	if (millis() - lastread > 200)
	{
		lastread = millis();

		//make sure we know what our temp is.
		int current_celsius = extruder_get_temperature();
		byte newheat = 0;
    
		//put the heater into high mode if we're not at our target.
		if (current_celsius < extruder_target_celsius)
			newheat = extruder_heater_high;
		//put the heater on low if we're at our target.
		else if (current_celsius < extruder_max_celsius)
			newheat = extruder_heater_low;
    
		// Only update heat if it changed
		if (extruder_heater_current != newheat)
		{
			extruder_heater_current = newheat;
			analogWrite(EXTRUDER_HEATER_PIN, extruder_heater_current);
		}
	}
}
