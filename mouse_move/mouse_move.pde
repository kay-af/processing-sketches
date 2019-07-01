// created by Md. Afridi

import processing.video.*;
import java.awt.Robot;
import java.awt.AWTException;

// A bright light such as mobile flash will do
int threshold = 254;

// A robot to control the mouse
Robot robot;

// Capture live video
Capture capture;

// Initialization
void setup()
{
  size(640, 480);
  
  // Get available cameras
  String[] cameras = Capture.list();
  println("Available Cameras");
  for(int i=0;i<cameras.length; i++)
    println(cameras[i]);
  
  //Initialize robot
  try
  {
    robot = new Robot();
  }
  catch(AWTException exp)
  {
    println("Error initializing robot");
    exit();
  }
  
  // Capture initialization
  // Use available camera list to set a desired camera
  capture = new Capture(this, cameras[1]);
  
  // Start capturing :D
  capture.start();
}

void draw()
{
  // Only draw a new frame on screen when its available
  if(capture.available())
  {
    capture.read();
    
    // Some handy vars
   int x = -1, y = -1, s = 0;
   
   capture.loadPixels(); // load the capture pixels
   
   loadPixels(); // load the screen pixels
   
   // Capture frames are by default flipped so we need to flip them again
   // Reading pixels from right to left row-wise
   for(int i=0; i<capture.pixels.length; i++)
   {
      // Right to left extraction based on pixel number
      // Basically, this pixel should belong to ith position in the pixel array for flipped image
      // Note (i/width) * width != i as i/width is integer division
      // Here (i/width) = the row the pixel belongs to and (i%width) = the same for column
      // Muliplying width with (i/width), we get to the exact row's first pixel
      // width - (i%width) - 1 because we are scanning from right to left
      // Adding these two, we get the pixel index in the current array which should belong to ith position in flipped image's pixel array
      color currCol = capture.pixels[(i/width)*width + width-(i%width)-1];
      
      // Get the current brightness of this pixel
      int currG = (int)brightness(currCol);
      
      // If the pixel is bright enough
      if(currG > threshold)
      {
        x += (i % width); // Add up the x coordinates of such pixels
        y += (i / width); // Add up the y coordinates of such pixels
        s++; // Number of such pixels // We will use it later to approximate the light source's position
      }
      
      // Copy flipped pixels
      // Now the image is flipped horizontally
      // This image will be showed on screen
      pixels[i] = currCol;
    }
    updatePixels(); // Commit changes to the screen's pixels
    
    // If there was atleast one pixel in the current frame whose brightness exceeded threshold
    if(x != -1)
    {
      // Some styling for a visual indicator of the position calculated
      stroke(0,255,0,120);
      strokeWeight(2);
      fill(120);
      
      // The average position vector denotes the center of all the bright pixels
      // For a bright white light in a dark environment, this is a fast way to calculate approximate location of the source of light
      x=x/s;
      y=y/s;
      
      // Draw an ellipse to visually show the light's position as calculated
      ellipse(x, y, 20, 20);
      
      // Map the calculated values horizontally and vertically with some padding to fit the display size
      float mouseMoveX = map(x, 100, width-100, 0, displayWidth);
      float mouseMoveY = map(y, 100, height-100, 0, displayHeight);
      
      // Move the mouse to that postion on screen using the calculated values
      robot.mouseMove(int(mouseMoveX), int(mouseMoveY));
    }
  }
}

// Yay !! :D
