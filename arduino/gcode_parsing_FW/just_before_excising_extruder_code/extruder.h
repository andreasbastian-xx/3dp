//
//// Class for controlling each extruder
////
//// Adrian Bowyer 14 May 2009
//
//#ifndef EXTRUDER_H
//#define EXTRUDER_H
//
//
//
//void manageAllExtruders();
//
//void newExtruder(byte e);
//
///**********************************************************************************************
//
//* Sanguino/RepRap Motherboard v 1.0
//
//*/
//
//
///**********************************************************************************************
//*
//* RepRap Motherboard with extruder is on RS485
//*
//*/
//
//
///**********************************************************************************************
//*
//* RepRap Arduino Mega Motherboard
//*
//*/
//
//#if MOTHERBOARD == 3
//
////******************************************************************************************************
//
//
//
//class extruder
//{
//  
//public:
//   extruder(byte step, byte dir, byte en, byte heat, byte temp, float spm, byte fan);
//   void waitForTemperature();
//   
//   void setDirection(bool direction);
//   void setCooler(byte e_speed);
//   void setTemperature(int temp);
//   int getTemperature();
//   int getTarget();
//   void slowManage();
//   void manage();
//   void sStep();
//   void enableStep();
//   void disableStep();
//   void shutdown();
//   float stepsPerMM();
//   void controlTemperature();   
//   void valveSet(bool open, int dTime); 
// 
//private:
//
//   int targetTemperature;
//   int count;
//   int oldT, newT;
//   float sPerMM;
//   long manageCount;
//   
//   PIDcontrol* extruderPID;    // Temperature control - extruder...
//   
//   int sampleTemperature();
//
//   void temperatureError(); 
//
//// The pins we control
//   byte motor_step_pin, motor_dir_pin, heater_pin,  temp_pin,  motor_en_pin;
//   byte fan_pin;
//
//   //byte fan_pin;
//    
//#ifdef PASTE_EXTRUDER
//   byte valve_dir_pin, valve_en_pin;
//   bool valve_open;
//#endif
//    
// 
//};
//
//inline void extruder::sStep()
//{
//	digitalWrite(motor_step_pin, HIGH);
//	digitalWrite(motor_step_pin, LOW);  
//}
//
//
//#endif
//
////*********************************************************************************************************
//
//extern extruder* ex[ ];
//extern byte extruder_in_use;
//
//inline float extruder::stepsPerMM()
//{
//  return sPerMM;
//}
//
//#endif
