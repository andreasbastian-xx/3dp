
void setup()
{
 Serial.begin(9600); 
 pinMode(A2, INPUT);
}

void loop()
{
 Serial.println(digitalRead(A2),DEC); 
}
