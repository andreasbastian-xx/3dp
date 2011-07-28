/*
raster() 
 */
//ABSOLUTE INDEXING IMPLEMENTED HERE
void raster()
{
  int c = Serial.read();
  //////////////////////////////////////////////
  //if command for movement:
  if (c == '(' || c == '*') 
  {
    // turn on or off and move
    int targetDex = getInt();//reads Serial to get destination
    if (c == '*') 
    {
      // turn laser on at destination
      laserOff();//just to be sure//tradtional
      xDex = stepToDex(travelSpeed,xDex,targetDex,xdp,xsp);
      laserOn(); //necessary/dangerous?
    } 
    else 
    {
      // turn off laser at destination
      laserOn();//traditional
      xDex = stepToDex(printSpeed,xDex,targetDex,xdp,xsp);
      laserOff();
    }

    Serial.println('R');//ask for more data
  }

  //if info about the next line:
  else if (c == '&')
  {
    yDex = STEP(travelSpeed, yDex, ydp, ysp);
    //laserOff();//again, just to be sure
    rasterDex = 0;
    Serial.println('R');
  } 


  else if (c == '^') 
  {
    // done
    Serial.println('R');
  }
  else if (c == 'S') 
  {
    // start asking for data
    Serial.println('R');
  } 
  else 
  {
    //    Serial.println('X');
    //    Serial.print(xDex, HEX);
    //    Serial.print('\n', BYTE);
    // discard the byte
  }
}

void oldRaster() {

  //set up to deal with imgs of diff size later...
  int imgWidth = 0;
  int steps = 0;
  int oo = 0;//on/off

  //while the computer is sending the arduino image info...
  while(oo != '^')
  {
    oo = Serial.read();
    while(oo != '&')//while receving a row's info...
    {
      Serial.println('R');//ask for some data
      delay(10);
      oo = Serial.read();
      if(oo == '(')//at destination, turn laser off
      {
        steps = getInt();
        laserOn();
        imgWidth += steps;
        xDex += steps;
        //xDex = stepByDex(printSpeed,xDex,steps,xdp,xsp);
        laserOff();//just to be safe
      }

      else if(oo == '*')//at destination, turn laser on
      {
        laserOff();
        steps = getInt();
        imgWidth += steps;
        xDex += steps;
        //xDex = stepByDex(travelSpeed,xDex,steps,xdp,xsp);
      }//end else if
    }//end while--working on row

    //step down a row
    //come back to x=0
    //eventually make into a "real" raster and flip 
    //next row of info.
    yDex = STEP(-travelSpeed,yDex,ydp,ysp);
    for(int i = 0; i < imgWidth; i++)
    {
      xDex = STEP(-travelSpeed,xDex,xdp,xsp);
    }
    imgWidth = 0;
  }



  //old code:
  /*
  for(int j = 0; j < imgHeight; j++)
   {
   for(int i = 0; i < imgWidth; i++)
   {
   oo = Serial.read();
   if(oo == 'R')//if computer is waiting for response
   {
   Serial.write('R');//ask for more commands
   delay(10);//give some communication time
   }
   else if( oo == 1 || oo == 0)//if laser command
   {
   STEP(5,xDex,xdp,xsp);
   laser(oo);
   }
   
   Serial.print('T', BYTE);
   Serial.print(oo, HEX);
   Serial.print('\n', BYTE);
   
   }
   STEP(-60,yDex,ydp,ysp);
   
   for(int i = 0; i < imgWidth; i++)
   {
   STEP(-60,xDex,xdp,xsp);
   }
   }  
   */

}
































