#include <Ultrasonic.h>
#include <SoftwareSerial.h>
SoftwareSerial nodemcu(12,11);
#include <Wire.h>
/*
 * Create three Ultrasonic objects for the three sensors.
 * Pass as parameters the trigger and echo pins for each sensor.
 */
Ultrasonic ultrasonic1(2, 3);
Ultrasonic ultrasonic2(4, 5);
Ultrasonic ultrasonic3(6, 7);

int distance1;
int distance2;
int distance3;

// Define RGB LED pins
const int greenPin = 8;
const int redPin = 9;
const int bluePin = 10;

void setup() {
  Serial.begin(9600);
nodemcu.begin(115200);
  // Set RGB LED pins as OUTPUT
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
}

void loop() {
  distance1 = ultrasonic1.read();
  distance2 = ultrasonic2.read();
  distance3 = ultrasonic3.read();
  
  // Print distances
  Serial.print("Distance Sensor 1 in CM: ");
  Serial.println(distance1);

  Serial.print("Distance Sensor 2 in CM: ");
  Serial.println(distance2);

  Serial.print("Distance Sensor 3 in CM: ");
  Serial.println(distance3);

  
int avgdist = ( ultrasonic1.read() + ultrasonic2.read() + ultrasonic3.read()) / 3;

if (avgdist<=15)
{setColor(HIGH, LOW,LOW);//r g b RED
  nodemcu.println("4");
}
 if (40<=avgdist || avgdist >15) // YEllow 
{setColor(HIGH, HIGH,LOW);
  nodemcu.println("3");
}
if (avgdist>40) // Green
{setColor(LOW, HIGH,LOW);
  nodemcu.println("1");
}

//setColor(HIGH,HIGH,LOW);
}
void setColor(int redValue, int greenValue, int blueValue) {
  digitalWrite(redPin, redValue);
  digitalWrite(greenPin, greenValue);
  digitalWrite(bluePin, blueValue);
}


