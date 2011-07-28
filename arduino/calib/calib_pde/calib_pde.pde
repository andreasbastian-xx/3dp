//#include <SoftwareSerial.h>
//up to date with windows side code as of 3/16
int index = 0;
int stepSpeed = 0;
float dist = .2;
void setup()
{
  pinMode(4,OUTPUT);//dir control
  pinMode(5,OUTPUT);//dir control
  pinMode(2,OUTPUT);//step control
  pinMode(3,OUTPUT);//step control

  digitalWrite(4,HIGH);//set dir high (cw/ccw?)
  digitalWrite(5,HIGH);//set dir2 high (cw/ccw?)
}

void loop()
{
  delay(3000);
  for(int i = 0; i < 5; i++)
  {
    stepSteps(100, 20, 4, 2);
    stepDistance(0.04, 20, 5, 3);
    stepSteps(100, -20, 4, 2);
    stepDistance(0.04, 20, 5, 3);
  }





  /////////////////////////////
  //Test one: squares
  //Draws 100 squares on top of each other, which allows you to 
  //look for play in two directions at once.
  /*
  for(int i = 0; i < 100; i++)
   {
   stepDistance(0.25, 20, 4, 2);
   stepDistance(0.25, 20, 5, 3);
   stepDistance(0.25, -20, 4, 2);
   stepDistance(0.25, -20, 5, 3);
   }
   delay(10000);
   */

  //line back and forth in one direction
  /*
  for(int i = 0; i < 100; i++)
   {
   stepDistance(1, 20, 4, 2);
   stepDistance(1, -20, 4, 2);
   }
   //then the other:
   for(int i = 0; i < 100; i++)
   {
   stepDistance(1, 20, 5, 3);
   stepDistance(1, -20, 5, 3);
   }
   delay(10000);
   */

  //////////////////////////////
  //Raster pattern:
  /*
  for(int i = 0; i < 100; i++)
   {
   stepDistance(1.5, 20, 4, 2);
   stepDistance(0.01, 20, 5, 3);
   stepDistance(1.5, -20, 4, 2);
   stepDistance(0.01, 20, 5, 3);
   }
   */
  //////////////////////////
  //SPIRAL 

  //  dist = 1.5;
  //  while(dist > 0)
  //  {
  //    stepDistance(dist, 20, 4, 2);
  //    dist -= 0.01;
  //    stepDistance(dist, 20, 5, 3);
  //    stepDistance(dist, -20, 4, 2);
  //    dist -= 0.01;
  //    stepDistance(dist, -20, 5, 3);
  //  }


  //  stepDistance(float(1.0/random(5,10)), 20, 4, 2);
  //  stepDistance(float(1.0/random(5,10)), 20, 5, 3);
  //  stepDistance(float(1.0/random(5,10)), -20, 4, 2);
  //  stepDistance(float(1.0/random(5,10)), -20, 5, 3);
  delay(10000);
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
  //Serial.println('steps:  '+steps+'\n');
  //Serial.println('stepDelay:  '+stepDelay+'\n');

  while(steps > 0)
  {
    digitalWrite(stepPin,HIGH);
    delayMicroseconds(stepDelay);
    digitalWrite(stepPin,LOW);
    delayMicroseconds(stepDelay);
    steps -= 1;
  }
}

void stepSteps(int numSteps, int stepSpeed, int dirPin, int stepPin)
{
  float stepDelay = abs(1/(stepSpeed*400/.332/60*2)*1000000); //(in/min)*(steps/in)*(min/sec)*(2)
  // = #rising edges per second
  //=1245 if stepSpeed = 20.
  if(stepSpeed < 0)
  {
    digitalWrite(dirPin, LOW);
  }
  else digitalWrite(dirPin, HIGH);
  for(int i = 0; i < numSteps; i++)
  {
    digitalWrite(stepPin,HIGH);//
    delayMicroseconds(stepDelay);
    digitalWrite(stepPin,LOW);
    delayMicroseconds(stepDelay);
  }
}





