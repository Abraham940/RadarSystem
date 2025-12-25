#include <Servo.h>

Servo radarServo;

// ------------------ Pins ------------------
const int SERVO_PIN = 12;
const int TRIG_PIN  = 10;
const int ECHO_PIN  = 11;

// ------------------ Settings ------------------
const int MIN_DEG = 15;
const int MAX_DEG = 165;

// Change to 5 if you want a reading every 5 degrees:
const int STEP_DEG = 1;

const int SERVO_DELAY_MS = 30;

// Clamp far/invalid readings:
const int MAX_CM = 200;

// Measure distance in centimeters (HC-SR04 style)
long measureDistanceCm() {
  // Trigger pulse
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);

  // Read echo (timeout prevents freezing if no echo)
  long duration = pulseIn(ECHO_PIN, HIGH, 30000); // 30ms timeout

  if (duration == 0) return MAX_CM;

  long cm = (long)(duration * 0.034 / 2.0);

  if (cm < 0) cm = 0;
  if (cm > MAX_CM) cm = MAX_CM;

  return cm;
}

void setup() {
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);

  Serial.begin(9600);

  radarServo.attach(SERVO_PIN);
  radarServo.write(90); // center
  delay(300);
}

void loop() {
  // Sweep forward
  for (int deg = MIN_DEG; deg <= MAX_DEG; deg += STEP_DEG) {
    radarServo.write(deg);
    delay(SERVO_DELAY_MS);

    long cm = measureDistanceCm();

    // IMPORTANT: keep this format for Processing parsing: angle,distance.
    Serial.print(deg);
    Serial.print(",");
    Serial.print(cm);
    Serial.print(".");
  }

  // Sweep backward
  for (int deg = MAX_DEG; deg >= MIN_DEG; deg -= STEP_DEG) {
    radarServo.write(deg);
    delay(SERVO_DELAY_MS);

    long cm = measureDistanceCm();

    Serial.print(deg);
    Serial.print(",");
    Serial.print(cm);
    Serial.print(".");
  }
}
