
// define the parameters of our machine.
#define X_STEPS_PER_INCH 316.2//accurate as of 7/22
#define X_STEPS_PER_MM   12.45//ditto
#define X_MOTOR_STEPS    400

#define Y_STEPS_PER_INCH 316.2//acurate as of 7/22
#define Y_STEPS_PER_MM   12.45//ditto
#define Y_MOTOR_STEPS    400

//need to calibrate
#define Z_STEPS_PER_INCH 16256.0
#define Z_STEPS_PER_MM   640.0
#define Z_MOTOR_STEPS    400

//my additional powder management hardware:
//feed stepper:
//need to calibrate
#define F_STEPS_PER_INCH 16256.0
#define F_STEPS_PER_MM   640.0
#define F_MOTOR_STEPS    400

//wiper stepper:
//need to calibrate
#define W_STEPS_PER_INCH 16256.0
#define W_STEPS_PER_MM   640.0
#define W_MOTOR_STEPS    400

//maximum feedrates
#define FAST_XY_FEEDRATE 1500.0
#define FAST_Z_FEEDRATE  500.0
#define Z_FEEDRATE 2.0
#define W_STEP_RATE 20.0


// Units in curve section
#define CURVE_SECTION_INCHES 0.019685
#define CURVE_SECTION_MM 0.5

// Set to one if sensor outputs inverting (ie: 1 means open, 0 means closed)
// RepRap opto endstops are *not* inverting.
#define SENSORS_INVERTING 0

// How many temperature samples to take.  each sample takes about 100 usecs.
//#define TEMPERATURE_SAMPLES 5

/****************************************************************************************
 * digital i/o pin assignment
 *
 * this uses the undocumented feature of Arduino - pins 14-19 correspond to analog 0-5
 ****************************************************************************************/

//cartesian bot pins
#define X_STEP_PIN 2
#define X_DIR_PIN 3
#define X_MIN_PIN 4
#define X_MAX_PIN 5
#define X_ENABLE_PIN 6

#define Y_STEP_PIN 7
#define Y_DIR_PIN 8
#define Y_MIN_PIN 9
#define Y_MAX_PIN 10
#define Y_ENABLE_PIN 11

#define Z_STEP_PIN 22
#define Z_DIR_PIN 23
#define Z_MIN_PIN 24
#define Z_MAX_PIN 25
#define Z_ENABLE_PIN 26

//powder management hardware:
#define F_STEP_PIN 27
#define F_DIR_PIN 28
#define F_MIN_PIN 29
#define F_MAX_PIN 30
#define F_ENABLE_PIN 31

#define W_STEP_PIN 32
#define W_DIR_PIN 33
#define W_MIN_PIN 34
#define W_MAX_PIN 35
#define W_ENABLE_PIN 36



//extruder pins
/*
#define EXTRUDER_MOTOR_SPEED_PIN   11
#define EXTRUDER_MOTOR_DIR_PIN     12
#define EXTRUDER_HEATER_PIN        6
#define EXTRUDER_FAN_PIN           5
#define EXTRUDER_THERMISTOR_PIN    0  //a -1 disables thermistor readings
#define EXTRUDER_THERMOCOUPLE_PIN  -1 //a -1 disables thermocouple readings
*/
