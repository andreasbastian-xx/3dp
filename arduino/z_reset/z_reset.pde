#include <SoftwareSerial.h>
int zsp = 22;//Z-axis step pin
int zdp = 23;//Z-axis direction pin

int fsp = 27;//Reservoir step pin
int fdp = 28;//Reservoir direction pin

int zDex = 0;
int wDex = 0;

int flip = 1;
int zr, zrp, wr, wrp, wSwing, zsteps, wsteps = 0;
float zSwing = 1.0;


void setup() 
{
  //Z-AXIS STEPPER:  
  pinMode(zsp,OUTPUT);//step control
  pinMode(zdp,OUTPUT);//dir control
  pinMode(fsp,OUTPUT);//step control
  pinMode(fdp,OUTPUT);//dir control



  pinMode(13, OUTPUT);
  digitalWrite(zdp, HIGH);//set dir high (cw/ccw?)
  Serial.begin(9600);
  zDex = 0;
  wDex = 0;
  wSwing = 260;
  zSwing = 1.0;
}



void loop() 
{  

    for(int i = 0; i < 300; i++)
    {
      STEP(-10,0,zdp,zsp); 
    }
//  for(int i = 0; i < 300; i++)
//  {
//    STEP(10,0,fdp,fsp); 
//  }

}



//in this function, I think distance and speed can be hard-coded because the 
//stepper isn't doing anything but this.  Pins, however, might change.
void newLayer(int dirPin, int stepPin)
{
  stepByDex(-10,0,260,dirPin,stepPin);
  delay(50);
  stepByDex(10,0,260,dirPin,stepPin);
}

void zMove(float zdist, int dirPin, int stepPin)
{
  //negative zdist is piston up, positive zdist is piston down
  //100 steps/20 thou
  int stepSpeed = 10;
  if(zdist < 0)
  {
    stepSpeed *= -1;
    zdist *= -1;
  }
  int steps = (100.0/0.021)*zdist;
  zDex = stepByDex(stepSpeed,zDex,steps,dirPin,stepPin);
}















