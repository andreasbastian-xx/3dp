
//functions for controlling the motion of the powder management hardware and 
//z-axis

void doZ(float layerThickness)
{
  //for debuggin purposes, layerThickness is hardcoded:
  layerThickness = 0.01;
  digitalWrite(Z_ENABLE_PIN, HIGH);
  digitalWrite(F_ENABLE_PIN, HIGH);
  digitalWrite(W_ENABLE_PIN, HIGH);

  //just use this func for printing, so only moving in one direction
  int steps = to_steps(z_units,layerThickness);
  float milDel = 0;
  long feedDelay = ((layerThickness * 60000000.0) / Z_FEEDRATE) / steps;
  //move z-Axis
  if (feedDelay >= 16383)
    milDel = feedDelay / 1000;
  else
    milDel = 0;
  for(int i = 0; i < steps; i++)
  {
    do_step(Z_STEP_PIN);
    if (milDel > 0)
      delay(milDel*200);			
    else
      delayMicroseconds(feedDelay*200);
  }
  //move feed piston:
  steps *= 1.1;//scale up by 10% to account for powder loses

  for(int i = 0; i < steps; i++)
  {
    do_step(F_STEP_PIN);
    if (milDel > 0)
      delay(milDel*200);			
    else
      delayMicroseconds(feedDelay*200);
  }

  //finally, distribute the powder with the wiper:
  feedDelay = fabs(0.18975/W_STEP_RATE)*1000000;
  if (feedDelay >= 16383)
    milDel = feedDelay / 1000;
  else
    milDel = 0;
  digitalWrite(W_DIR_PIN,HIGH);
  for(int i = 0; i < 300; i++)
  {
    do_step(W_STEP_PIN);
    if (milDel > 0)
      delay(milDel);			
    else
      delayMicroseconds(feedDelay);
  }
  digitalWrite(W_DIR_PIN,LOW);
  for(int i = 0; i < 300; i++)
  {
    do_step(W_STEP_PIN);
    if (milDel > 0)
      delay(milDel);			
    else
      delayMicroseconds(feedDelay);
  }


}

void laserOn()
{
  digitalWrite(LASER_PIN, LOW);
}

void laserOff()
{
  digitalWrite(LASER_PIN, HIGH);
}



