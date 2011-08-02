
//functions for controlling the motion of the powder management hardware and 
//z-axis

void doZ(float layerThickness)
{
  //enable motors here
  digitalWrite(W_ENABLE_PIN, HIGH);
  //    digitalWrite(F_ENABLE_PIN, LOW);
  //      digitalWrite(Z_ENABLE_PIN, LOW);
  delay(2);//wait for driver to wake up

  //  digitalWrite(Z_ENABLE_PIN, HIGH);
  //  digitalWrite(F_ENABLE_PIN, HIGH);
  //  digitalWrite(W_ENABLE_PIN, HIGH);

  //just use this func for printing, so only moving in one direction
  int steps = Z_STEPS_PER_MM*layerThickness;
  float milDel = 0;
  long feedDelay = (layerThickness * 60000000.0) / (SLOW_Z_FEEDRATE*steps);
  //move z-Axis
  if (feedDelay >= 16383)
    milDel = feedDelay / 1000;
  else
    milDel = 0;
  digitalWrite(Z_DIR_PIN, HIGH);
  for(int i = 0; i < steps; i++)
  {
    takeStep(Z_STEP_PIN);
    if (milDel > 0)
      delay(milDel);			
    else
      delayMicroseconds(feedDelay);
  }

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

  //finally, distribute the powder with the wiper:
  steps = 11*25.4*W_STEPS_PER_MM;
  feedDelay = (11*25.4*60000000.0) / (W_FEEDRATE*steps);
  if (feedDelay >= 16383)
    milDel = feedDelay / 1000;
  else
    milDel = 0;
  digitalWrite(W_DIR_PIN,HIGH);
  for(int i = 0; i < 500; i++)
  {
    takeStep(W_STEP_PIN);
    if (milDel > 0)
      delay(milDel);			
    else
      delayMicroseconds(feedDelay);
  }



  digitalWrite(W_DIR_PIN,LOW);
  for(int i = 0; i < 500; i++)
  {
    takeStep(W_STEP_PIN);
    if (milDel > 0)
      delay(milDel);			
    else
      delayMicroseconds(feedDelay);
  }



  //disable motors here
  digitalWrite(W_ENABLE_PIN, LOW);
  //    digitalWrite(F_ENABLE_PIN, LOW);
  //      digitalWrite(Z_ENABLE_PIN, LOW);

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




