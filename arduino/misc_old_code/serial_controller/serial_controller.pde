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
float stepSpd0 = 5;
float stepSpd = 0;
int flip = 1;

void setup() 
{
  pinMode(4,OUTPUT);//dir control
  pinMode(5,OUTPUT);//dir control
  pinMode(2,OUTPUT);//step control
  pinMode(3,OUTPUT);//step control

  digitalWrite(4,HIGH);//set dir high (cw/ccw?)
  digitalWrite(5,HIGH);//set dir2 high (cw/ccw?)
  Serial.begin(9600);
  stepSpd = stepSpd0;
}

void delayMicros(unsigned int usec) {
  while (usec > 16000) {
    delayMicroseconds(16000);
    usec -= 16000;
  }
  delayMicroseconds(usec);
}

void loop() {
  
  if (Serial.available()) 
  { // If data is available to read,
    val = Serial.read(); // read it and store it in val
  }
  if (val == 'L') 
  { 
    digitalWrite(4, LOW);
    STEP(-stepSpd,4,2);
  } 
  if (val == 'R') 
  { 
    digitalWrite(4, HIGH);
    STEP(stepSpd,4,2);
  }  
  if (val == 'U') 
  {
    digitalWrite(5, LOW);
    STEP(-stepSpd,5,3);
  }  
  if (val == 'D') 
  {  
    digitalWrite(5, HIGH);  
    STEP(stepSpd,5,3);
  }
  if(val == 'S')
  {
   flip = -1*flip;
   if(flip > 0)
   {
     stepSpd = stepSpd0;
   }
   else stepSpd = 80;
  }

}

void STEP(float stepSpeed, int dirPin, int stepPin)
{
  float stepDelay = fabs(0.18975/stepSpeed)*1000000;
  if(stepSpeed < 0)
  {
    digitalWrite(dirPin, LOW);
  }
  else digitalWrite(dirPin, HIGH);
  digitalWrite(stepPin,HIGH);
  delayMicros(0.5*stepDelay);
  digitalWrite(stepPin,LOW);
  delayMicros(0.5*stepDelay);
}



////PROCESSING CODE TO RUN THIS ARDUINO CODE:
/*

import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port

void setup() 
{
  size(100,100);
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
}

void draw() {
  background(0);
}

void keyPressed()
{
  if (key == CODED) 
  {
    if (keyCode == UP) 
    {
      myPort.write('U');
    } 
    if (keyCode == DOWN) 
    {
      myPort.write('D');
    } 
    if (keyCode == LEFT) 
    {
      myPort.write('L');
    } 
    if (keyCode == RIGHT) 
    {
      myPort.write('R');
    }
  }
}

void keyReleased()
{
  myPort.write('X');
}



*/
