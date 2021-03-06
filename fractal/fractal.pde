/**
 * Original sketch:
 * http://processing.org/examples/mandelbrot.html
 */

/** Constants **/
String address = "localhost";
int incoming_port = 9003;

/** Imports **/
import oscP5.*;
import netP5.*;

/** Variables **/
OscP5 oscP5;
float red = 0.00;
float green = 0.00;
float blue = 0.00;
// Establish a range of values on the complex plane
// A different range will allow us to "zoom" in or out on the fractal
// float xmin = -1.5; float ymin = -.1; float wh = 0.15;
float w = 5;
float h = 2.5;
float xmin = -3;
float ymin = -1.25;

void setup() {
  size(640, 360);
  background(255);
  frameRate(60);

  oscP5 = new OscP5(this, incoming_port);
}

void oscEvent(OscMessage msg) {
  msg.print();
  if (msg.addrPattern().equals("/green")) {
    green = msg.get(0).floatValue();
  } 
  else if (msg.addrPattern().equals("/red")) {
    red = msg.get(0).floatValue();
  } 
  else if (msg.addrPattern().equals("/blue")) {
    blue = msg.get(0).floatValue();
  } 
  else if (msg.addrPattern().equals("/xmin")) {
    xmin = msg.get(0).floatValue();
  } 
  else if (msg.addrPattern().equals("/ymin")) {
    ymin = msg.get(0).floatValue();
  }else if (msg.addrPattern().equals("/width")) {
    w = msg.get(0).floatValue();
  }else if (msg.addrPattern().equals("/height")) {
    h = msg.get(0).floatValue();
  }
}

void draw() {
  // Make sure we can write to the pixels[] array.
  // Only need to do this once since we don't do any other drawing.
  loadPixels();

  // Maximum number of iterations for each point on the complex plane
  int maxiterations = 100;

  // x goes from xmin to xmax
  float xmax = xmin + w;
  // y goes from ymin to ymax
  float ymax = ymin + h;

  // Calculate amount we increment x,y for each pixel
  float dx = (xmax - xmin) / (width);
  float dy = (ymax - ymin) / (height);

  // Start y
  float y = ymin;
  for (int j = 0; j < height; j++) {
    // Start x
    float x = xmin;
    for (int i = 0;  i < width; i++) {

      // Now we test, as we iterate z = z^2 + cm does z tend towards infinity?
      float a = x;
      float b = y;
      int n = 0;
      while (n < maxiterations) {
        float aa = a * a;
        float bb = b * b;
        float twoab = 2.0 * a * b;
        a = aa - bb + x;
        b = twoab + y;
        // Infinty in our finite world is simple, let's just consider it 16
        if (aa + bb > 16.0) {
          break;  // Bail
        }
        n++;
      }

      // We color each pixel based on how long it takes to get to infinity
      // If we never got there, let's pick the color black
      if (n == maxiterations) {
        pixels[i+j*width] = color(0);
      }
      else {
        // Gosh, we could make fancy colors here if we wanted
        pixels[i+j*width] = color(n * red % 255, n * green % 255, n * blue % 255);
      }
      x += dx;
    }
    y += dy;
  }
  updatePixels();
}

