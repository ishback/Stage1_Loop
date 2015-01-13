/**
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */
import com.jonwohl.*;
import processing.video.*;
import gab.opencv.*;
import processing.serial.*;
//import cc.arduino.*;
//Arduino arduino;

Capture cam;
OpenCV opencv;
PImage out;
boolean addBall = false;
int countdown = 0;
int counter = 0;
Attention attention;
PImage src, dst;
boolean debug;
int fillColor = 0;

int camW = 160;
int camH = 120;

void setup() {
  size(1024, 768);
  frameRate(30);
//  println(Arduino.list());
//  arduino = new Arduino(this, "/dev/tty.usbmodem1411", 57600);
//  arduino.pinMode(4, Arduino.INPUT);
//  String[] cameras = Capture.list();
//
//  if (cameras == null) {
//    println("Failed to retrieve the list of available cameras, will try the default...");
//    cam = new Capture(this, 640, 480);
//  } if (cameras.length == 0) {
//    println("There are no cameras available for capture.");
//    exit();
//  } else {
//    println("Available cameras:");
//    for (int i = 0; i < cameras.length; i++) {
//      println(cameras[i]);
//    }
//
//    cam = new Capture(this, 320, 240, "/dev/video0", 15);
//    cam.start();
//    // instantiate focus passing an initial input image
//    attention = new Attention(this, cam);
//    out = attention.focus(cam, width, height);
//  }

  cam = new Capture(this, camW, camH, "/dev/video0", 30);
  cam.start();
  attention = new Attention(this, cam);
}

public PImage getCopy(PImage image) {
  PImage newImage = createImage(image.width, image.height, image.format);
  newImage.loadPixels();
  System.arraycopy(image.pixels, 0, newImage.pixels, 0, image.pixels.length);
  newImage.updatePixels();
  return newImage;
}

void draw() {
  if (cam.available() == true) {
    cam.read();
//    loadImageAlpha(cam, 255);
//    out = attention.focus(cam, camW, camH);
//    out.resize(width, height);
//    PImage resized = loadImageAlpha(out, 255);
//    image(out, 0, 0);
    
    PImage resized = getCopy(cam);
    resized.resize(width, height);
    resized.filter(THRESHOLD, .5);
    loadImageAlpha(resized, 255);
    set(0, 0, resized);
  }
 
//  out = attention.focus(cam, camW, camH);
  
  
//  image(out, 0, 0, width, height);
  //println(frameCount);
  //image(out, 0, 0);
  //filter(BLUR, 1);
//  filter(THRESHOLD, map(arduino.analogRead(0), 0, 1024, 0, 1));
  
  // create balls with a pushbutton
//  if (arduino.digitalRead(4) == Arduino.HIGH){
//    // create new ball
//    noStroke();
//    fill(fillColor);
//    ellipse(width/2, height/2, counter*2, counter*2);
//    counter++;
//    println(fillColor);
//  } else {
//    counter = 0;
//    // test: change the color from black to white
//    if (fillColor == 0){
//      fillColor = 255;
//    } else {
//      fillColor = 0;
//    }
//  }
   
  // to use with the key C
  if (addBall && countdown > 0){
    noStroke();
    fill(0);
    ellipse(500+countdown*3, 300+countdown, 50, 50);
    countdown--;
  }
  if (debug){
    showUI();
  }
}

int[] rgbComponents(int argb) {
  int[] comp = new int[3];
  comp[0] = (argb >> 16) & 0xFF;
  comp[0] = (argb >> 8) & 0xFF;
  comp[0] = argb & 0xFF;
  return comp;
}

PImage loadImageAlpha(PImage image, int alpha) {
  int i = 0;
  image.loadPixels();
  for (i = 0; i < image.pixels.length; i++) {
    image.pixels[i] = alpha << 24 | image.pixels[i];
//    int[] rgb = rgbComponents(image.pixels[i]);
//    image.pixels[i] = alpha << 24 | rgb[0] << 16 | rgb[1] < 8 | rgb[2];
  }
  image.updatePixels();
  return image;
}

void showUI(){
  noFill();
  stroke(219, 255, 0);
  rect(10, 10, 100, 20);
  fill(219, 255, 0);
//  rect(10, 10, map(arduino.analogRead(0), 0, 1024, 0, 100), 20);
}

void keyPressed() {
  if (key == 'C' || key == 'c') {
    countdown = 60;
    addBall = true;
  } else if (key == 'D' || key == 'd'){
    debug = !debug;
  }
}
