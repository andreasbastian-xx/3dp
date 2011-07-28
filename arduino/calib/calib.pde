int xdir = 5;
int ydir = 4;
int xstep = 3;
int ystep =2;

void setup()
{
  pinMode(ydir,OUTPUT);//x-axis dir control
  pinMode(xdir,OUTPUT);//y-axis dir control
  pinMode(ystep,OUTPUT);//x-axis step control
  pinMode(xstep,OUTPUT);//y-axis step control

  digitalWrite(ydir,HIGH);//set dir high (cw/ccw?)
  digitalWrite(xdir,HIGH);//set dir2 high (cw/ccw?)
}

void loop()
{
  delay(3000);
  //insert calibration functions here
  test1(1.0);

  delay(10000);
}


void stepSteps(int numSteps, int stepSpeed, int dirPin, int stepPin)
{
  float stepDelay = abs(1/(stepSpeed*400/1.265/60*2)*1000000); //(in/min)*(steps/in)*(min/sec)*(2)
  //  if(stepSpeed < 0)
  //  {
  //    digitalWrite(dirPin, LOW);
  //  }
  //  else digitalWrite(dirPin, HIGH);

  for(int i = 0; i < numSteps; i++)
  {
    digitalWrite(stepPin,HIGH);
    delayMicroseconds(stepDelay);
    digitalWrite(stepPin,LOW);
    delayMicroseconds(stepDelay);
  }
}

void STEP(int stepDelay, int dirPin, int stepPin)
{
  if(stepDelay < 0)
  {
    digitalWrite(dirPin, LOW);
    stepDelay = -stepDelay;
  }
  else digitalWrite(dirPin, HIGH);

  digitalWrite(stepPin,HIGH);//
  delayMicroseconds(stepDelay);
  digitalWrite(stepPin,LOW);
  delayMicroseconds(stepDelay);
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

void stepDistance(float dist, float stepSpeed, int dirPin, int stepPin)
{
  float stepDelay = abs(1/(stepSpeed*400/1.265/60*2)*1000000); //(in/min)*(steps/in)*(min/sec)*(2)
  // = #rising edges per second
  int steps = 400*dist/1.265;
  if(stepSpeed < 0)
  {
    digitalWrite(dirPin, LOW);
  }
  else digitalWrite(dirPin, HIGH);

  while(steps > 0)
  {
    digitalWrite(stepPin,HIGH);//
    delayMicroseconds(stepDelay);
    digitalWrite(stepPin,LOW);
    delayMicroseconds(stepDelay);
    steps -= 1;
  }
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
/*
void stepSteps(int numSteps, int stepSpeed, int dirPin, int stepPin)
 {
 float stepDelay = 1/(stepSpeed*400/1.265/60*2)*1000000; //(in/min)*(steps/in)*(min/sec)*(2)
 // = #rising edges per second
 if(stepSpeed < 0)
 {
 digitalWrite(dirPin, LOW);
 }
 else digitalWrite(dirPin, HIGH);
 for(int i = 0; i < numSteps; i ++)
 {
 STEP(stepDelay, dirPin, stepPin);
 }
 }
 */
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

void raster(int dist, int spacing, int reps, int stepSpeed)
{
  float stepDelay = abs(1/(stepSpeed*400/1.265/60*2)*1000000); //(in/min)*(steps/in)*(min/sec)*(2)
  // = #rising edges per second

  for(int i =0; i < reps; i++)
  {
    stepDistance(dist, stepSpeed, xdir, xstep);
    stepDistance(spacing, stepSpeed, ydir, ystep);
    stepDistance(dist, -stepSpeed, xdir, xstep);
    stepDistance(spacing, stepSpeed, ydir, ystep);
  }
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

void spiral(int dist, int spacing, int stepSpeed, int dirPin, int stepPin)
{
  float stepDelay = abs(1/(stepSpeed*400/1.265/60*2)*1000000); //(in/min)*(steps/in)*(min/sec)*(2)
  while(dist > 0)
  {
    stepDistance(dist, stepSpeed, xdir, xstep);
    stepDistance(dist, stepSpeed, ydir, ystep);
    dist -= spacing;
    stepDistance(dist, -stepSpeed, xdir, xstep);
    stepDistance(dist, stepSpeed, ydir, ystep);
    dist -= spacing;
  }
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

void square(int dist, int stepSpeed, int reps)
{
  float stepDelay = abs(1/(stepSpeed*400/.332/60*2)*1000000); //(in/min)*(steps/in)*(min/sec)*(2)
  // = #rising edges per second

  for(int i = 0; i < reps; i++)
  {
    stepDistance(dist, stepSpeed, xdir, xstep);
    stepDistance(dist, stepSpeed, ydir, ystep);
    stepDistance(dist, -1*stepSpeed, xdir, xstep);
    stepDistance(dist, -1*stepSpeed, ydir, ystep);
  }
}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

void scribble()
{
  stepDistance(float(1.0/random(5,10)), 20, 4, 2);
  stepDistance(float(1.0/random(5,10)), 20, 5, 3);
  stepDistance(float(1.0/random(5,10)), -20, 4, 2);
  stepDistance(float(1.0/random(5,10)), -20, 5, 3); 
}


void test1(float length)
{
  float steps = 316.2*length;
  int xstep = 0;
  int ystep = 0;
  int toggle,toggle2 = 1;
//  for(int q = 0; q < steps; q += 0.1)
  for(int x = 0; x < steps; x += 60)
  {
    for(int y = 0; y < steps; y += 60)
    {
      stepDistance(.1,toggle*100,xdir,xstep);
      stepDistance(.1,toggle2*100,ydir,ystep);
      toggle *= -1;
    }  //one line of zig zags
    toggle2 *= -1;
    
  }

}














