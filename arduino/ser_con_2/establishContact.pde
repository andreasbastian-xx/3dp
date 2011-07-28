void establishContact() {
  while (Serial.available() <= 0) 
  {
    Serial.print('G', BYTE);   // send a capital G
    delay(300);
  }
}
