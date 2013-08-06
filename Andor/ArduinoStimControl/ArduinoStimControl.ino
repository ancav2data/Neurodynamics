/* Simple Serial ECHO script : Written by ScottC 03/07/2012 */

/* Use a variable called byteRead to temporarily store
   the data coming from the computer */
int NPulses;
int PulseInt;
int Delay;
char a;
int led = 12;
int stim = 13;
int PulseTime=5;
int LEDTime=1000;

void setup() {                
// Turn the Serial Protocol ON
  Serial.begin(9600);
  Delay=0;
  PulseInt=0;
  NPulses=0;
  pinMode(stim, OUTPUT);
  pinMode(led, OUTPUT);
  digitalWrite(stim, LOW);
  digitalWrite(led, LOW);
}

void loop() {
  int i;
   /*  check if data has been sent from the computer: */
  if (Serial.available()>=2) {
    a=Serial.read();
     if(a=='D'){
       Delay=Serial.parseInt();
       Serial.println(Delay);
     }
     
     if(a=='I'){
       PulseInt=Serial.parseInt();
       Serial.println(PulseInt);
      }
      
      if(a=='O'){
       LEDTime=Serial.parseInt();
       Serial.println(LEDTime);
      }
      
     if(a=='P'){
       NPulses=Serial.parseInt();
       Serial.println(NPulses);
      }
      
      if(a=='S'){
        digitalWrite(led, HIGH);
        digitalWrite(stim, LOW);   // turn the LED on (HIGH is the voltage level)
        delay(Delay);
        for(i=0;i<NPulses;i++){
        digitalWrite(stim, HIGH);
        delay(PulseTime);
        digitalWrite(stim, LOW);
        delay(PulseInt-PulseTime);
        }
        delay(LEDTime-(Delay+NPulses*PulseInt));
        digitalWrite(led, LOW);
        //Serial.println("Stim and light done");
      }
        if(a=='L'){
        digitalWrite(led, HIGH);
        delay(LEDTime);
        digitalWrite(led, LOW);
        }
        
        if(a=='V'){
          if (Delay>0 && NPulses>0 && PulseInt>0) {
            Serial.println("All set.");
          } else {
            Serial.println("Not all values are set.");
          }
      }

}
}
