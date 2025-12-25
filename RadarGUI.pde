import processing.serial.*;

Serial myPort;

// Latest values from Arduino
int angleDeg = 90;
float distanceCm = 0;

// ------------------ Settings ------------------
final String PORT_NAME = "COM7";  
final int BAUD_RATE = 9600;

float maxRangeCm = 40;            // only draw targets up to this range
float radarRadius;                // pixels

PFont uiFont;

void setup() {
  size(1200, 700);
  smooth();

  // If you don't know the port name, uncomment this to print ports:
  // println(Serial.list());

  myPort = new Serial(this, PORT_NAME, BAUD_RATE);
  myPort.bufferUntil('.'); // read until the dot terminator

  uiFont = createFont("Arial", 18);
  textFont(uiFont);

  radarRadius = min(width, height) * 0.42;
}

void draw() {
  background(10);

  // Radar origin (bottom center)
  pushMatrix();
  translate(width/2, height * 0.9);

  drawGrid();
  drawSweep(angleDeg);
  drawTarget(angleDeg, distanceCm);

  popMatrix();

  drawHUD();
}

// ------------------ Drawing ------------------

void drawGrid() {
  stroke(0, 255, 0, 70);
  noFill();

  // Range rings (4 rings)
  for (int i = 1; i <= 4; i++) {
    float r = (radarRadius * i) / 4.0;
    arc(0, 0, r*2, r*2, PI, TWO_PI);
  }

  // Angle rays
  for (int a = 0; a <= 180; a += 30) {
    float rad = radians(180 - a);
    float x = cos(rad) * radarRadius;
    float y = -sin(rad) * radarRadius;
    line(0, 0, x, y);
  }

  // Base line
  line(-radarRadius, 0, radarRadius, 0);
}

void drawSweep(int deg) {
  stroke(0, 255, 0, 180);
  float rad = radians(180 - deg);

  float x = cos(rad) * radarRadius;
  float y = -sin(rad) * radarRadius;
  line(0, 0, x, y);
}

void drawTarget(int deg, float cm) {
  if (cm <= 0 || cm > maxRangeCm) return;

  float rad = radians(180 - deg);

  float r = map(cm, 0, maxRangeCm, 0, radarRadius);
  float x = cos(rad) * r;
  float y = -sin(rad) * r;

  stroke(0, 255, 0, 255);
  strokeWeight(7);
  point(x, y);
  strokeWeight(1);
}

void drawHUD() {
  fill(220);
  text("Arduino Radar Scanner", 20, 30);
  text("Port: " + PORT_NAME + " @ " + BAUD_RATE, 20, 55);
  text("Angle: " + angleDeg + "°", 20, 80);
  text("Distance: " + nf(distanceCm, 0, 1) + " cm", 20, 105);
  text("Max display range: " + maxRangeCm + " cm", 20, 130);

  fill(140);
  text("Tip: If nothing shows, check PORT_NAME and make sure Arduino IDE Serial Monitor is closed.", 20, height - 20);
}

// ------------------ Serial ------------------

void serialEvent(Serial p) {
  String packet = p.readStringUntil('.');
  if (packet == null) return;

  packet = trim(packet);
  packet = packet.replace(".", "");  // remove terminator

  // expected: angle,distance
  String[] parts = split(packet, ',');
  if (parts.length != 2) return;

  try {
    angleDeg = int(parts[0]);
    distanceCm = float(parts[1]);
  } catch (Exception e) {
    // ignore bad packets
  }
}
