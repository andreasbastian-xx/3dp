int xsp = 2;
int xdp = 3;
int ysp = 7;
int ydp = 8;
int zsp = 22;//Z-axis step pin
int zdp =23;//Z-axis direction pin
int wsp = 33;//Wiper step pin
int wdp = 34;//Wiper direction pin
int fsp = 28;//Reservoir step pin
int fdp = 29;//Reservoir direction pin

int zDex = 0;
int wDex = 0;

int zr, zrp, wr, wrp, wSwing, zsteps, wsteps = 0;



void setup() 
{
  //Z-AXIS STEPPER:  
  pinMode(zsp,OUTPUT);//step control
  pinMode(zdp,OUTPUT);//dir control
  pinMode(wsp,OUTPUT);//step control
  pinMode(wdp,OUTPUT);//dir control
  pinMode(xsp,OUTPUT);
  pinMode(xdp,OUTPUT);
  pinMode(ysp,OUTPUT);
  pinMode(ydp,OUTPUT);
  pinMode(fsp,OUTPUT);
  pinMode(fdp,OUTPUT);

  pinMode(13, OUTPUT);
  digitalWrite(zdp, HIGH);//set dir high (cw/ccw?)
  Serial.begin(9600);
  zDex = 0;
  wDex = 0;
  delay(3000);
}



void loop() 
{  

  for(int i = 0; i < 500; i++)
  {
    STEP(-10,0,fdp,fsp); 
  }
  delay(15000);
//  for(int i = 0; i < 1000; i++)
//  {
//    STEP(-20,0,zdp,zsp); 
//  }
  //delay(10000);

}


