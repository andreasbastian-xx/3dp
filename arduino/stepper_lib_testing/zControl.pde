void newLayer(int dirPin, int stepPin)
{
  stepByDex(-10,0,260,dirPin,stepPin);
  delay(50);
  stepByDex(10,0,260,dirPin,stepPin);
}

int advanceZ(float zdist, int dex, int dirPin, int stepPin)
{
  //negative zdist is piston up, positive zdist is piston down
  //100 steps/20 thou
  int stepSpeed = 10;
  int steps = (100.0/0.021)*zdist;
  dex = stepByDex(stepSpeed,dex,steps,dirPin,stepPin);
  return dex;
}

int advanceFeed(float dist, int dex, int dirPin, int stepPin)
{
  float stepSpeed = 10;
  int steps = (100.0/0.077)*dist;
  dex = stepByDex(-stepSpeed,dex,steps,dirPin,stepPin);
  return dex;
}

void spreadNewLayer(int dirPin, int stepPin)
{
  stepByDex(-10,0,265,dirPin,stepPin);
  delay(100);
  stepByDex(10,0,265,dirPin,stepPin);
}

void newLayer()
{
  zDex = advanceZ(0.02,zDex,zdp,zsp);
  fDex = advanceFeed(0.04,fDex,fdp,fsp);
  spreadNewLayer(wdp,wsp);
  //lay down a new layer for printing:
  //take print piston down a level
  //advance feed piston
  //swep wiper forward and back

}


