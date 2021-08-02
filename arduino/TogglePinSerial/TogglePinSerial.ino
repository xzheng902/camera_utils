int pinState = 0;
String MyString = "0";
int MyPin = 12;
int MyDelay = 10;

void setup() {
  // put your setup code here, to run once:
  pinMode(MyPin, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  if (Serial.available() > 0)
  {
    MyString = Serial.readString();
    pinState = MyString.toInt();
  }
  digitalWrite(MyPin,pinState);
  delay(MyDelay);
  digitalWrite(MyPin,LOW);
  delay(MyDelay);
}
