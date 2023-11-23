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
const int redPin = 8;
const int greenPin = 9;
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
  
  // Read distances for each sensor
  distance1 = ultrasonic1.read();
  distance2 = ultrasonic2.read();
  distance3 = ultrasonic3.read();
  int avgdist = ( ultrasonic1.read() + ultrasonic2.read() + ultrasonic3.read()) / 3;
  // Print distances
  Serial.print("Distance Sensor 1 in CM: ");
  Serial.println(distance1);

  Serial.print("Distance Sensor 2 in CM: ");
  Serial.println(distance2);

  Serial.print("Distance Sensor 3 in CM: ");
  Serial.println(distance3);

  // Example: Turn on the RGB LEDs based on the distance of Sensor 1
  // You can customize this logic for your application
  

if((distance1>20)&&(distance2>20)&&(distance3>20))
{setColor(HIGH, LOW, LOW); //blue empty
nodemcu.println("1");
  }
  if((distance1>20)&&(distance2>20)&&(distance3<=20))//less than 50percent
{setColor(LOW, HIGH, LOW);//yellow
  nodemcu.println("2");
  }
  if((distance1>20)&&(distance2<=20)&&(distance3<=20))//half full
{
  setColor(LOW, HIGH, LOW);//blue
  nodemcu.println("3");
  }
  if (avgdist<=15)//full
{ setColor(LOW, LOW, HIGH);//red on
//setColor(HIGH, LOW, LOW);
 nodemcu.println("4");
 }
  delay(1000);
}

// Function to set RGB LED color
void setColor(int blueValue, int greenValue, int redValue) {
  digitalWrite(redPin, redValue);
  digitalWrite(greenPin, greenValue);
  digitalWrite(bluePin, blueValue);
}
