/*
Andreas Bastian 
 June 8, 2011
 
 serial_controller allows for user control of a simple XY translator by listening
 for commands from a sister Processing program that captures user keyboard input
 (the four arrrow keys) and uses this information to control the driving stepper 
 motors.  
 
 IMPORTANT LESSON LEARNED:  Don't use pins 0 and 1 for anything if you are sending
 or receiving information over serial to the arduino.  0 and 1 are the TX and RX 
 lines, so digitalWrite() commands are lost if written to these pins.
 
 
 */

#include <SoftwareSerial.h>
int val = 0;

float travelSpeed = 100;
float printSpeed = 10;
int flip = 1;



int xAbs, yAbs = 0;
//pins:
int xsp = 2;//X-axis step pin
int xdp = 3;//X-axis direction pin
int ysp = 4;//Y-axis step pin
int ydp = 5;//Y-axis direction pin
int zsp = 6;//Z-axis step pin
int zdp = 7;//Z-axis direction pin
int fsp = 8;//Feed step pin
int fdp = 9;//Feed direction pin
int wsp = 10;//Wiper step pin
int wdp = 11;//Wiper direction pin
int loo = 12;//laser control pin
int xLimPin = 0;//X-axis limit switch
int yLimPin = 0;//Y-axis limt switch

//indexing:
int xDex = 0;
int yDex = 0;
int zDex = 0;
int wDex = 0;//wiper position index
int fDex = 0;//feed position index
int rasterDex = 0;
int xLimState = 0;
int yLimState = 0;
int rasterFlip = 1;

void setup() 
{
  //X-AXIS STEPPER:
  pinMode(xsp,OUTPUT);//step control
  pinMode(xdp,OUTPUT);//dir control
  //Y-AXIS STEPPER:  
  pinMode(ysp,OUTPUT);//step control
  pinMode(ydp,OUTPUT);//dir control
  //Z-AXIS STEPPER:  
  pinMode(zsp,OUTPUT);//step control
  pinMode(zdp,OUTPUT);//dir control
  //WIPER STEPPER:
  pinMode(wsp,OUTPUT);
  pinMode(wdp,OUTPUT);
  //FEED STEPPER:
  pinMode(fsp,OUTPUT);
  pinMode(fdp,OUTPUT);

  //pinMode(xLimPin,INPUT);//x-axis limit switch
  //pinMode(yLimPin,INPUT);//y-axis limit switch

  pinMode(loo, OUTPUT);//laser shutter control

  pinMode(13, OUTPUT);

  digitalWrite(xsp, HIGH);//set dir high (cw/ccw?)
  digitalWrite(ydp, HIGH);//set dir high (cw/ccw?)
  digitalWrite(zdp, HIGH);//set dir high (cw/ccw?)
  digitalWrite(fdp, HIGH);
  digitalWrite(wdp, HIGH);
  digitalWrite(loo, HIGH);//make sure that laser is off
  laserOff();//make sure again.
  Serial.begin(9600);
  //establishContact();//wait for go from user
  //zeroSteppers();
  xDex = 0;
  yDex = 0;
  delay(3000);
  
}



void loop() { 
  //delay(3000);

/*
  laserOn();
  yDex = stepDistance(3, yDex, 1, ydp, ysp);
  xDex = stepDistance(3, xDex, 1, xdp, xsp);
  yDex = stepDistance(-3, yDex, 1, ydp, ysp);
  xDex = stepDistance(-3, xDex, 1, xdp, xsp);
  laserOff();
*/  
advanceFeed(0.02,0,fdp,fsp);
advanceZ(0.02,0,zdp,zsp);
delay(100000);
//newLayer();

}









//calibration/zeroing testing:
/*
//listen();
 zeroSteppers();//prints out Dex's when reed switches turn off
 //backTalk();
 int num = 1800;
 for(int i = 0; i < num; i++)
 {
 xDex = STEP(100,xDex,xdp,xsp);
 yDex = STEP(100,yDex,ydp,ysp);
 }
 //backTalk();
 delay(500);
 for(int i = 0; i < num; i++)
 {
 xDex = STEP(-100,xDex,xdp,xsp);
 yDex = STEP(-100,yDex,ydp,ysp);
 }
 //backTalk();
 delay(500);
 //zeroSteppers();
 */



















