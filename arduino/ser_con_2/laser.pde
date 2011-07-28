//super simple laser control functions.
//They just DigitalWrite to the laser on/off (loo)
//pin.

void laserOn()
{
  digitalWrite(loo,LOW);
  Serial.print('T', BYTE);
  Serial.print(1, HEX);
  Serial.print('\n', BYTE);
}

void laserOff()
{
  digitalWrite(loo,HIGH);
  Serial.print('T', BYTE);
  Serial.print(0, HEX);
  Serial.print('\n', BYTE);
}

void laser(int i)
{
  if(i == 1)
  {
    laserOn();
  }
  else
  {
    laserOff(); 
  }
}

void laserRaster()
{
  /*
  for(int j = 0; j < slice.; j++)
   {
   for(int i = 0; i < img.width; i++)
   {
   laser(slice[i][j]);
   }
   }
   */
}


