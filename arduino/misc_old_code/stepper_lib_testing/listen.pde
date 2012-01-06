void listen()
{
  val = Serial.read(); // read it and store it in val
  float stepDist = 0.05;
  /*
  if(val == 'D') 
   { 
   digitalWrite(4, LOW);
   yDex = STEP(-travelSpeed,yDex,4,2);
   } 
   if(val == 'U') 
   { 
   digitalWrite(4, HIGH);
   yDex = STEP(travelSpeed,yDex,4,2);
   }  
   if(val == 'R') 
   {
   digitalWrite(5, LOW);
   xDex = STEP(travelSpeed,xDex,5,3);
   }  
   if(val == 'L') 
   {  
   digitalWrite(5, HIGH);  
   xDex = STEP(-travelSpeed,xDex,5,3);
   }
   */
  if(val == 'D') 
  { 
    digitalWrite(4, LOW);
    yDex = stepDistance(-travelSpeed,yDex,stepDist,4,2);
  } 
  if(val == 'U') 
  { 
    digitalWrite(4, HIGH);
    yDex = stepDistance(travelSpeed,yDex,stepDist,4,2);
  }  
  if(val == 'R') 
  {
    digitalWrite(5, LOW);
    xDex = stepDistance(travelSpeed,xDex,stepDist,5,3);
  }  
  if(val == 'L') 
  {  
    digitalWrite(5, HIGH);  
    xDex = stepDistance(-travelSpeed,xDex,stepDist,5,3);
  }

  //change speed--not currently implemented
  if(val == 'S')
  {
    Serial.println('R');//request data
  } 

  //laser control:
  if(val == 'Q') 
  {  
    laserOn();
  }
  if(val == 'W') 
  {  
    laserOff();
  }
}


int getInt()
{
  if(Serial.available() > 1)
  {
    int byte1 = Serial.read();
    //Serial.println(byte1);
    int byte2 = Serial.read();
    //Serial.println(byte2);
    //int out = byte1<<8|byte2;
    int out = byte1*255 + byte2;
    

    return out;
  }
  else
  {
    //trouble, didn't get bytes... 
  }
}



