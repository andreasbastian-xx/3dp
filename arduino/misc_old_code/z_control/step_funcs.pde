

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



void delayMicros(unsigned int usec) {
  while (usec > 16000) {
    delayMicroseconds(16000);
    usec -= 16000;
  }
  delayMicroseconds(usec);
}

