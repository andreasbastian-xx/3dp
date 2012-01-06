import processing.serial.*;

Serial myPort;  // Create object from Serial class

void setup()
{
   String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
}

void draw()
{
  
}

void keyPressed()
{
  //laser on/off control:
  if (key == 'q')
  {
    //laser on
    myPort.write('Q');
  }
  if (key == 'w')
  {
    //laser off
    myPort.write('W');
  }  
}

void keyReleased()
{
 myPort.write('X'); 
}

