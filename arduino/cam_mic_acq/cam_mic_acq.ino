int pinState = 0;
String MyString = "0";
int camPin = 12;
int micPin1 = 10;
int micPin2 = 11;
int MyDelay = 9933;

void setup() {
  // put your setup code here, to run once:
  pinMode(camPin, OUTPUT);
  pinMode(micPin1, OUTPUT);
  pinMode(micPin2, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  if (Serial.available() > 0)
  {
    MyString = Serial.readString();
    pinState = MyString.toInt();
  }
  digitalWrite(micPin1,pinState);
  digitalWrite(micPin2,pinState);
  digitalWrite(camPin,pinState);
  delayMicroseconds(MyDelay);
  digitalWrite(camPin,LOW);
  delayMicroseconds(MyDelay);

}
