

void setup()
{
 Serial.begin(9600); 
 pinMode(A8, INPUT);
}

void loop()
{
 Serial.println(analogRead(A8),DEC); 
}
