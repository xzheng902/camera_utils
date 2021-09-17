/*
 * 50hz trigger
 * w/ another pin
 */

void setup() {
  // put your setup code here, to run once:
  pinMode(12, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  digitalWrite(12, HIGH);   // turn the LED on (HIGH is the voltage level)
  delayMicroseconds(10000);
  digitalWrite(12, LOW);    // turn the LED off by making the voltage LOW
  delayMicroseconds(10000);

}
