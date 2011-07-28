#include <SoftwareSerial.h>
//up to date with windows side code as of 3/16
int index = 0;
int stepSpeed = 0;
void setup()
{
  pinMode(8,OUTPUT);//dir control
  pinMode(9,OUTPUT);//step control
  digitalWrite(8,HIGH);  
  //Serial.begin(9600);

}

void loop()
{
  delay(2000);
  stepDistance(1.0, 3, 8, 9);
  delay(100);
  stepDistance(1.0, -20, 8, 9);
  delay(100);
}








void STEP(int stepDelay, int dirPin, int stepPin)
{
  if(stepDelay < 0)
  {
    digitalWrite(dirPin, LOW);
    stepDelay = -stepDelay;
  }
  digitalWrite(stepPin,HIGH);//
  delayMicroseconds(stepDelay);
  digitalWrite(stepPin,LOW);
  delayMicroseconds(stepDelay);
}

void stepDistance(float dist, float stepSpeed, int dirPin, int stepPin)
{
  float stepDelay = 1/(stepSpeed*400/.332/60*2)*1000000; //(in/min)*(steps/in)*(min/sec)*(2)
  // = #rising edges per second
  int steps = 400*dist/.332;
  if(stepDelay < 0)
  {
    digitalWrite(dirPin, LOW);
    stepDelay = -stepDelay;
  }
  else digitalWrite(dirPin, HIGH);
  Serial.println('steps:  '+steps+'\n');
  Serial.println('stepDelay:  '+stepDelay+'\n');

  while(steps > 0)
  {
    digitalWrite(stepPin,HIGH);
    delayMicroseconds(stepDelay);
    digitalWrite(stepPin,LOW);
    delayMicroseconds(stepDelay);
    steps -= 1;
  }
}
