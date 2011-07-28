/*
checkLims() checks the state of the limit switches and signals if any are triggered.
 If a limit switch is triggered and the travel indices are below -6, the function 
 halts all travel activity by entering a loop that sinals the user's computer while
 occupying the arduino with a loop.
 */

void checkLims()
{
  boolean trip = true;

  //check y limit switch
  yLimState = digitalRead(yLimPin);
  if(yLimState == HIGH)
  {

    if(yDex < -6)
    {
      while(trip && yLimState == HIGH)
      {
        Serial.println('%');
        listen();//let user take control
      }
    }

    digitalWrite(13,HIGH);
    yDex = 0;
    Serial.println('@');
  }
  xLimState = digitalRead(xLimPin);


  //check x limit switch
  trip = true;
  if(xLimState == HIGH)
  {

    if(xDex < -6)
    {
      while(trip && xLimState == HIGH)
      {
        Serial.println('$');
        listen(); //let user take control
      }
    }

    digitalWrite(13,HIGH);
    xDex = 0;    
    Serial.println('!');
  }
  else
  {
    digitalWrite(13,LOW); 
  }
}

