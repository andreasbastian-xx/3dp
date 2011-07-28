/*
class stepper
{
  
};
*/

int STEP(float stepSpeed, int stepDex, int dirPin, int stepPin)
{
  float stepDelay = fabs(0.18975/stepSpeed)*1000000;
  if(stepSpeed < 0)
  {
    digitalWrite(dirPin, LOW);
    stepDex--;
  }
  else 
  {
    digitalWrite(dirPin, HIGH);
    stepDex++;
  }
  digitalWrite(stepPin,HIGH);
  delayMicros(0.5*stepDelay);
  digitalWrite(stepPin,LOW);
  delayMicros(0.5*stepDelay);
  return stepDex;
}

//////////////////////////////////////////////////////
int stepDistance(float stepSpeed, int stepDex, float dist, int dirPin, int stepPin)
{
  int steps = dist*(400/1.265);
  for(int i = 0; i < steps; i++)
  {
    stepDex = STEP(stepSpeed,stepDex,dirPin,stepPin);
  }
  return stepDex;
}

//////////////////////////////////////////////////////
int stepByDex(float stepSpeed, int stepDex, int steps, int dirPin, int stepPin)
{
  for(int i = 0; i < steps; i++)
  {
    stepDex = STEP(stepSpeed,stepDex,dirPin,stepPin);
  }
  return stepDex;
}

//////////////////////////////////////////////////////
int stepToDex(float stepSpeed, int stepDex, int targetDex, int dirPin, int stepPin)
{
  while(stepDex != targetDex)
  {

    if(stepDex < targetDex)
    {
      //advance
      stepDex = STEP(stepSpeed,stepDex,dirPin,stepPin);
    }
    else
    {
      //retreat
      stepDex = STEP(-stepSpeed,stepDex,dirPin,stepPin);
    }
  }
  /*
  if(stepDex < targetDex)
   {
   while(targetDex != stepDex)
   {
   stepDex = STEP(stepSpeed,stepDex,dirPin,stepPin);
   }
   }
   
   else if(stepDex > targetDex)
   {
   while(stepDex != targetDex)
   {
   stepDex = STEP(-stepSpeed,stepDex,dirPin,stepPin);
   }
   }
   */
  return stepDex;
}

void delayMicros(unsigned int usec) {
  while (usec > 16000) {
    delayMicroseconds(16000);
    usec -= 16000;
  }
  delayMicroseconds(usec);
}













