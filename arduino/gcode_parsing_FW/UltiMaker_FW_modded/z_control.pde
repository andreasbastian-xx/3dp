
//functions for controlling the motion of the powder management hardware and 
//z-axis

void doZ(float layerThickness)
{
  
  
  //for debuggin purposes, layerThickness is hardcoded:
  layerThickness = 0.01;
//  digitalWrite(Z_ENABLE_PIN, HIGH);
//  digitalWrite(F_ENABLE_PIN, HIGH);
//  digitalWrite(W_ENABLE_PIN, HIGH);

  //just use this func for printing, so only moving in one direction
  int steps = Z_STEPS_PER_MM*layerThickness;
  Serial.println(1,DEC);
  float milDel = 0;
  long feedDelay = (layerThickness * 60000000.0) / (SLOW_Z_FEEDRATE*steps);
  //move z-Axis
  if (feedDelay >= 16383)
    milDel = feedDelay / 1000;
  else
    milDel = 0;
  for(int i = 0; i < steps; i++)
  {
    takeStep(Z_STEP_PIN);
    if (milDel > 0)
      delay(milDel);			
    else
      delayMicroseconds(feedDelay);
  }
    Serial.println(2,DEC);
  //move feed piston:
  steps = F_STEPS_PER_MM*layerThickness*1.1;//scale up by 10% to account for powder loses

  for(int i = 0; i < steps; i++)
  {
    takeStep(F_STEP_PIN);
    if (milDel > 0)
      delay(milDel);			
    else
      delayMicroseconds(feedDelay);
  }
  Serial.println(3,DEC);
  //finally, distribute the powder with the wiper:
  steps = 7.5*25.4*W_STEPS_PER_MM;//recalibrate
  feedDelay = (7.5*25.4*60000000.0) / (W_FEEDRATE*steps);
  if (feedDelay >= 16383)
    milDel = feedDelay / 1000;
  else
    milDel = 0;
  digitalWrite(W_DIR_PIN,HIGH);
  for(int i = 0; i < 300; i++)
  {
    takeStep(W_STEP_PIN);
    if (milDel > 0)
      delay(milDel);			
    else
      delayMicroseconds(feedDelay);
  }
    Serial.println(4,DEC);
  digitalWrite(W_DIR_PIN,LOW);
  for(int i = 0; i < 300; i++)
  {
    takeStep(W_STEP_PIN);
    if (milDel > 0)
      delay(milDel);			
    else
      delayMicroseconds(feedDelay);
  }
  Serial.println(5,DEC);

}

void laserOn()
{
  digitalWrite(LASER_PIN, LOW);
}

void laserOff()
{
  digitalWrite(LASER_PIN, HIGH);
}

void takeStep(int sp)
{
 digitalWrite(sp, HIGH);
 digitalWrite(sp, LOW);
}



