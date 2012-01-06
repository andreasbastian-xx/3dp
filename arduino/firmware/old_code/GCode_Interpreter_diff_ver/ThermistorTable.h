#ifndef THERMISTORTABLE_H_
#define THERMISTORTABLE_H_

// Thermistor lookup table for RepRap Temperature Sensor Boards (http://make.rrrf.org/ts)
// Made with createTemperatureLookup.py (http://svn.reprap.org/trunk/reprap/firmware/Arduino/utilities/createTemperatureLookup.py)
// ./createTemperatureLookup.py --r0=100000 --t0=25 --r1=0 --r2=4700 --beta=4066 --max-adc=1023
// r0: 100000
// t0: 25
// r1: 0
// r2: 4700
// beta: 4066
// max adc: 1023
#if 0
#define NUMTEMPS 20
short TempTable[NUMTEMPS][2] = {
   {1, 841},
   {54, 255},
   {107, 209},
   {160, 184},
   {213, 166},
   {266, 153},
   {319, 142},
   {372, 132},
   {425, 124},
   {478, 116},
   {531, 108},
   {584, 101},
   {637, 93},
   {690, 86},
   {743, 78},
   {796, 70},
   {849, 61},
   {902, 50},
   {955, 34},
   {1008, 3}
};
#endif

#define NUMTEMPS 32
short TempTable[NUMTEMPS][2] = {
   {210, -10},
   {224, 0},
   {238, 10},
   {252, 20},
   {266, 30},
   {281, 40},
   {296, 50},
   {310, 60},
   {325, 70},
   {339, 80},
   {354, 90},
   {368, 100},
   {383, 110},
   {397, 120},
   {411, 130},
   {425, 140},
   {439, 150},
   {452, 160},
   {465, 170},
   {478, 180},
   {491, 190},
   {503, 200},
   {516, 210},
   {528, 220},
   {539, 230},
   {551, 240},
   {562, 250},
   {573, 260},
   {583, 270},
   {593, 280},
   {602, 290},
   {610, 300},
};
#endif
