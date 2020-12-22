int turnOn = 1;
int prevButtonState = 0;

void setup(){
  Serial.begin(9600);
  Serial.println("0,0,0,0");
  pinMode(2, INPUT);
  pinMode(3, INPUT);
  pinMode(4, INPUT);
  pinMode(5, INPUT);
  }

void loop(){
  if(Serial.available()>0){
    char incoming = Serial.read();
    int a1 = digitalRead(2);
    delay(1);
    int a2 = digitalRead(3);
    delay(1);
    int a3 = digitalRead(4);
    delay(1);
    int a4 = digitalRead(5);
    delay(1);

    Serial.print(a1);
    Serial.print(",");
    Serial.print(a2);
    Serial.print(",");
    if (a3 == 0 && prevButtonState == 1) {
      Serial.print(turnOn);
    }
    prevButtonState = a3;
    Serial.print(",");
    Serial.print(a4);
    Serial.println();
    }
  }
