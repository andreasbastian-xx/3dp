#ifndef PINS_H
#define PINS_H

#define MOTHERBOARD 3

// Set this to 0, 1, x for board versions v1.0, v1.1 or v1.x, etc.
#define ULTIMAKER_BOARD_MINOR_VERSION 5

#if MOTHERBOARD == 3

#ifndef __AVR_ATmega1280__
#ifndef __AVR_ATmega2560__
#error Oops!  Make sure you have 'Arduino Mega' selected from the 'Tools -> Boards' menu.
#endif
#endif

/*********************************************************************************************
*  _   _ _ _   _                 _
* | | | | | |_(_)_ __ ___   __ _| | _____ _ __
* | | | | | __| | '_ ` _ \ / _` | |/ / _ \ '__|
* | |_| | | |_| | | | | | | (_| |   <  __/ |
*  \___/|_|\__|_|_| |_| |_|\__,_|_|\_\___|_|
* 
* Valid for versions: 1.0 and 1.1
* For documentation, see http://www.ultimaker.com/
*
* NOTE: Configure ULTIMAKER_BOARD to the version you have!
* 
*********************************************************************************************/

// SELECT THE VERSION OF THE MOTHERBOARD THAT YOU HAVE.
#if ULTIMAKER_BOARD_MINOR_VERSION == 5

#define DEBUG_PIN        50

#define X_STEP_PIN (byte)2
#define X_DIR_PIN (byte)3
#define X_MIN_PIN (byte)4
#define X_MAX_PIN (byte)5
#define X_ENABLE_PIN (byte)6

#define Y_STEP_PIN (byte)7
#define Y_DIR_PIN (byte)8
#define Y_MIN_PIN (byte)9
#define Y_MAX_PIN (byte)10
#define Y_ENABLE_PIN (byte)11

#define Z_STEP_PIN (byte)22 
#define Z_DIR_PIN (byte)23
#define Z_MIN_PIN (byte)24
#define Z_MAX_PIN (byte)25
#define Z_ENABLE_PIN (byte)26

#define F_STEP_PIN (byte)27 
#define F_DIR_PIN (byte)28
#define F_MIN_PIN (byte)29
#define F_MAX_PIN (byte)30
#define F_ENABLE_PIN (byte)31

#define W_STEP_PIN (byte)32
#define W_DIR_PIN (byte)33
#define W_MIN_PIN (byte)34
#define W_MAX_PIN (byte)35
#define W_ENABLE_PIN (byte)36

#define LASER_PIN (byte)12



#endif //ULTIMAKER_BOARD=="1.5.3"


#else
#error Unknown MOTHERBOARD value in configuration.h

#endif

#endif
