void backTalk()
{
  //send x-coordinate
  Serial.print('X', BYTE);
  Serial.print(xDex, HEX);
  Serial.print('\n', BYTE);
  //send y-coordinate
  Serial.print('Y', BYTE);
  Serial.print(yDex, HEX);
  Serial.print('\n', BYTE);
}
