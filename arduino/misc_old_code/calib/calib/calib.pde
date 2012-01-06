int xdp = 3;
int xsp = 2;
int ydp = 8;
int ysp =7;
int loo = 12;

void setup()
{
  pinMode(loo,OUTPUT);//laser on/off
  pinMode(ydp,OUTPUT);//x-axis dir control
  pinMode(xdp,OUTPUT);//y-axis dir control
  pinMode(ysp,OUTPUT);//x-axis step control
  pinMode(xsp,OUTPUT);//y-axis step control

  digitalWrite(ydp,HIGH);//set dir high (cw/ccw?)
  digitalWrite(xdp,HIGH);//set dir2 high (cw/ccw?)
  laserOff();
  Serial.begin(9600);
}

void loop()
{
  delay(3000);
  //insert calibration functions here
  doLines();
  delay(10000);
}

void doLines()
{
  int flip = 1;
  int state = 1;
  
  for(int i = 50; i >=10; i-=5)//mm/s
  {
    laserOn();
    stepMMX(40,i);
    laserOff();
    if(flip == 1)
    {
    digitalWrite(xdp, LOW);
    }
    else
    {
     digitalWrite(xdp, HIGH);
    }
    flip *= -1;
    stepMMY(1.5,10);

  }
}

void stepMMX(float dist, float feedrate)
{
//    if(dist < 0)
//  {
//     digitalWrite(xdp, LOW); 
//  }
//  else
//  {
//     digitalWrite(xdp, HIGH); 
//  }
  float steps = 12.323*dist;
  float feedDelay = (dist*60000000.0)/(feedrate*60*steps);
  
  float milDel = 0;
  if (feedDelay >= 16383)
    milDel = feedDelay / 1000;
  else
    milDel = 0;
  for(int i = 0; i < steps; i++)
  {
    takeStep(xsp);
    if (milDel > 0)
      delay(milDel);			
    else
      delayMicroseconds(feedDelay);
  }
}

void stepMMY(float dist, float feedrate)
{
//  if(dist < 0)
//  {
//     digitalWrite(ydp, LOW); 
//  }
//  else
//  {
//     digitalWrite(ydp, HIGH); 
//  }
  float steps = 12.424*dist;
  float feedDelay = (dist*60000000.0)/(feedrate*60*steps);
  
  float milDel = 0;
  if (feedDelay >= 16383)
    milDel = feedDelay / 1000;
  else
    milDel = 0;
  for(int i = 0; i < steps; i++)
  {
    takeStep(ysp);
    if (milDel > 0)
      delay(milDel);			
    else
      delayMicroseconds(feedDelay);
  }
}

void takeStep(int sp)
{
  digitalWrite(sp, HIGH);
  digitalWrite(sp, LOW);
}

void laserOn()
{
  digitalWrite(loo, LOW);
}

void laserOff()
{
  digitalWrite(loo, HIGH);
}

//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//void stepSteps(int numSteps, int stepSpeed, int dirPin, int stepPin)
//{
//  float stepDelay = abs(1/(stepSpeed*400/1.265/60*2)*1000000); //(in/min)*(steps/in)*(min/sec)*(2)
//  //  if(stepSpeed < 0)
//  //  {
//  //    digitalWrite(dirPin, LOW);
//  //  }
//  //  else digitalWrite(dirPin, HIGH);
//
//  for(int i = 0; i < numSteps; i++)
//  {
//    digitalWrite(stepPin,HIGH);
//    delayMicroseconds(stepDelay);
//    digitalWrite(stepPin,LOW);
//    delayMicroseconds(stepDelay);
//  }
//}
//
//void STEP(int stepDelay, int dirPin, int stepPin)
//{
//  if(stepDelay < 0)
//  {
//    digitalWrite(dirPin, LOW);
//    stepDelay = -stepDelay;
//  }
//  else digitalWrite(dirPin, HIGH);
//
//  digitalWrite(stepPin,HIGH);//
//  delayMicroseconds(stepDelay);
//  digitalWrite(stepPin,LOW);
//  delayMicroseconds(stepDelay);
//}
//
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
//void stepDistance(float dist, float stepSpeed, int dirPin, int stepPin)
//{
//  float stepDelay = abs(1/(stepSpeed*400/1.265/60*2)*1000000); //(in/min)*(steps/in)*(min/sec)*(2)
//  // = #rising edges per second
//  int steps = 400*dist/1.265;
//  if(stepSpeed < 0)
//  {
//    digitalWrite(dirPin, LOW);
//  }
//  else digitalWrite(dirPin, HIGH);
//
//  while(steps > 0)
//  {
//    digitalWrite(stepPin,HIGH);//
//    delayMicroseconds(stepDelay);
//    digitalWrite(stepPin,LOW);
//    delayMicroseconds(stepDelay);
//    steps -= 1;
//  }
//}
//
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
///*
//void stepSteps(int numSteps, int stepSpeed, int dirPin, int stepPin)
// {
// float stepDelay = 1/(stepSpeed*400/1.265/60*2)*1000000; //(in/min)*(steps/in)*(min/sec)*(2)
// // = #rising edges per second
// if(stepSpeed < 0)
// {
// digitalWrite(dirPin, LOW);
// }
// else digitalWrite(dirPin, HIGH);
// for(int i = 0; i < numSteps; i ++)
// {
// STEP(stepDelay, dirPin, stepPin);
// }
// }
// */
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
//void raster(int dist, int spacing, int reps, int stepSpeed)
//{
//  float stepDelay = abs(1/(stepSpeed*400/1.265/60*2)*1000000); //(in/min)*(steps/in)*(min/sec)*(2)
//  // = #rising edges per second
//
//  for(int i =0; i < reps; i++)
//  {
//    stepDistance(dist, stepSpeed, xdir, xstep);
//    stepDistance(spacing, stepSpeed, ydir, ystep);
//    stepDistance(dist, -stepSpeed, xdir, xstep);
//    stepDistance(spacing, stepSpeed, ydir, ystep);
//  }
//}
//
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
//void spiral(int dist, int spacing, int stepSpeed, int dirPin, int stepPin)
//{
//  float stepDelay = abs(1/(stepSpeed*400/1.265/60*2)*1000000); //(in/min)*(steps/in)*(min/sec)*(2)
//  while(dist > 0)
//  {
//    stepDistance(dist, stepSpeed, xdir, xstep);
//    stepDistance(dist, stepSpeed, ydir, ystep);
//    dist -= spacing;
//    stepDistance(dist, -stepSpeed, xdir, xstep);
//    stepDistance(dist, stepSpeed, ydir, ystep);
//    dist -= spacing;
//  }
//}
//
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
//void square(int dist, int stepSpeed, int reps)
//{
//  float stepDelay = abs(1/(stepSpeed*400/.332/60*2)*1000000); //(in/min)*(steps/in)*(min/sec)*(2)
//  // = #rising edges per second
//
//  for(int i = 0; i < reps; i++)
//  {
//    stepDistance(dist, stepSpeed, xdir, xstep);
//    stepDistance(dist, stepSpeed, ydir, ystep);
//    stepDistance(dist, -1*stepSpeed, xdir, xstep);
//    stepDistance(dist, -1*stepSpeed, ydir, ystep);
//  }
//}
//
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
//void scribble()
//{
//  stepDistance(float(1.0/random(5,10)), 20, 4, 2);
//  stepDistance(float(1.0/random(5,10)), 20, 5, 3);
//  stepDistance(float(1.0/random(5,10)), -20, 4, 2);
//  stepDistance(float(1.0/random(5,10)), -20, 5, 3); 
//}
//
//
//void test1(float length)
//{
//  float steps = 316.2*length;
//  int xstep = 0;
//  int ystep = 0;
//  int toggle,toggle2 = 1;
////  for(int q = 0; q < steps; q += 0.1)
//  for(int x = 0; x < steps; x += 60)
//  {
//    for(int y = 0; y < steps; y += 60)
//    {
//      stepDistance(.1,toggle*100,xdir,xstep);
//      stepDistance(.1,toggle2*100,ydir,ystep);
//      toggle *= -1;
//    }  //one line of zig zags
//    toggle2 *= -1;
//    
//  }
//
//}
//
//
//
//
//
//
//
//
//
//
//
//
//

