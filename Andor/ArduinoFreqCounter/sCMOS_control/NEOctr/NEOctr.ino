/* FreqMeasure - Example with serial output
 * http://www.pjrc.com/teensy/td_libs_FreqMeasure.html
 *
 * This example code is in the public domain.
 */
#include <FreqMeasure.h>

const int LedPin =  13;      // the number of the LED pin
const int CamPin =  12;      // the number of the Camera pin
const int StimPin =  11;      // the number of the Stimulator pin
const int ResetPin =  10;
int PulseStart=1000;
int PulseInt=100;
int PulseNo =10;

// Variables will change:
int ledState = LOW;             // ledState used to set the LED
long previousMillis = 0;
boolean StartRoutine=false;
int LedTime=8000;
int CamDelay=100;
boolean NotStarted = true;
unsigned long startMills=0;
unsigned long currentMills=0;
boolean StartPulse = true;

void setup() {
  Serial.begin(57600);
  FreqMeasure.begin();
  pinMode(LedPin, OUTPUT);
  pinMode(CamPin, OUTPUT); 
  pinMode(StimPin, OUTPUT);
  pinMode(ResetPin, OUTPUT);  
  
  digitalWrite(LedPin, LOW);
  digitalWrite(CamPin, LOW);
  digitalWrite(StimPin, LOW);
  digitalWrite(ResetPin, LOW);
}

double sum=0;
int count=0;

void loop() {
  
  if (Serial.available() > 0)
  {
    if (Serial.read()=='s') StartRoutine=true;
  } 
  
  if (StartRoutine) {
    
    if (NotStarted) {
     startMills = millis();
     currentMills=millis()-startMills;
     NotStarted=false;
     Serial.print(currentMills);
     Serial.print(", ");
     Serial.println(0);
     digitalWrite(LedPin, HIGH);
     delay(CamDelay);
     digitalWrite(CamPin, HIGH);
     currentMills=millis()-startMills;
     Serial.print(currentMills);
     Serial.print(", ");
     Serial.print(0);
     Serial.print(", ");
     Serial.println(0);
    }
 
  currentMills=millis()-startMills;
  
  if (currentMills>PulseStart & StartPulse)
  {
    for(int i=0;i<(PulseNo-1);i++)
    {
      digitalWrite(CamPin, HIGH);
      currentMills=millis()-startMills;
     Serial.print(currentMills);
     Serial.print(", ");
     Serial.print(0);
     Serial.print(", ");
     Serial.println(2);
      delay(5);
      digitalWrite(CamPin, LOW);
      delay(PulseInt-5);
    }
    StartPulse = false;
  }
  
  if (FreqMeasure.available()) {
    // average several reading together
    sum = sum + FreqMeasure.read();
    count = count + 1;
    if (count > 30) {
      double frequency = F_CPU / (sum / count);
      Serial.print(currentMills);
      Serial.print(", ");
      Serial.print(frequency);
      Serial.print(", ");
      Serial.println(1);
      sum = 0;
      count = 0;
    }
    if (currentMills > LedTime) {
      StartRoutine=false;
      NotStarted=true;
      previousMillis = 0;
      StartRoutine=false;
      startMills=0;
      currentMills=0;
      digitalWrite(LedPin, LOW);
      digitalWrite(CamPin, LOW);
      digitalWrite(StimPin, LOW);
      digitalWrite(ResetPin, LOW);
      StartPulse = true;
    }
  }
}
}
