# Arduino Radar Scanner (Arduino + Processing)

## What this is
A small radar-style scanner made with an **Arduino Uno**, a **servo**, and an **ultrasonic sensor**.  
The servo sweeps side to side, the sensor measures distance at each angle, and a **Processing (PDE)** sketch turns that live serial data into a radar-like display on your PC.

## Highlights
- **Sweep + Scan:** Servo continuously scans a set angle range.
- **Distance Readings:** Ultrasonic sensor measures object distance in cm.
- **Real-Time Display:** Processing visualizes the sweep line + detected points.
- **Tunable:** Change scan range, scan speed, and degree step size (ex: 1° or 5°).

## Parts Used
- Arduino Uno R3  
- Servo (SG90 or similar)  
- Ultrasonic sensor (HC-SR04 or compatible)  
- Breadboard + jumper wires  
- USB cable

## Repo Layout
- `arduino/Arduino_Radar/Arduino_Radar.ino`  
  Controls the servo sweep, reads distance, and prints `angle,distance.` over Serial.
- `processing/RadarGUI/RadarGUI.pde`  
  Reads the serial stream and draws the radar interface.

## Getting Started
1. **Wire it up**
   - Servo signal → **D12**
   - Ultrasonic TRIG → **D10**, ECHO → **D11**
   - Share **5V** and **GND** (common ground)
2. **Upload Arduino code**
   - Open the `.ino` in Arduino IDE → select Uno + correct port → Upload
3. **Run the GUI**
   - Open the `.pde` in Processing → set the correct serial port (ex: `COM5`) → Run

## Notes / Tips
- If readings look noisy, try slowing the sweep delay a bit or powering the servo separately (still share GND).
- Want readings every 5 degrees? Change the step size in the Arduino sketch (ex: `STEP_DEG = 5`).

## Author
Abraham Khan
