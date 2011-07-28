void zeroSteppers()
{
  while(yLimState != HIGH)
  {
    yLimState = digitalRead(yLimPin);
    yDex = STEP(-60,yDex,4,2);
  }
  while(yLimState == HIGH)
  {
    yLimState = digitalRead(yLimPin);
    yDex = STEP(10,yDex,4,2); 
  }
  Serial.print('Y', BYTE);
  Serial.print(yDex, HEX);
  Serial.print('\n', BYTE);
  //yDex = 0;
  while(xLimState != HIGH)
  {
    xLimState = digitalRead(xLimPin);
    xDex = STEP(-60,xDex,5,3);
  }
  while(xLimState == HIGH)
  {
    xLimState = digitalRead(xLimPin);
    xDex = STEP(10,xDex,5,3); 

  }
  Serial.print('X', BYTE);
  Serial.print(xDex, HEX);
  Serial.print('\n', BYTE);
  //xDex = 0;
  //Serial.println('#');
}





