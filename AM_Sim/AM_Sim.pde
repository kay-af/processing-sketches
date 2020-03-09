float ac, am, f1, f2;
float t, ka;

void setup()
{
  size(640, 640);
  ac = 40;
  am = 40;
  f1 = 0.1;
  f2 = 0.01;
  t=0;
  ka = 1/am;
}

void draw()
{
  background(30);
  
  fill(255);
  float mew = ka * am;
  
  textAlign(RIGHT, CENTER);
  text("Modulation Index = " + mew, width-10, 20);
  
  stroke(255,80);
  line(120, height/4, width, height/4);
  line(120, 2*height/4, width, 2*height/4);
  line(120, 3*height/4, width, 3*height/4);
  line(120, 35, 120, height-35);
  
  noFill();
  strokeWeight(1);
  stroke(255);
  translate(0, height/4);
  
  textAlign(LEFT, CENTER);
  text("Modulating:", 10, 0);
  
  beginShape();
  for(int i=120; i<width; i += 1)
  {
    float y = modulating((i+t)/1.2);
    vertex(i,-y);
  }
  endShape();
  
  translate(0, height/4);
  
  text("Carrier:", 10, 0);
  beginShape();
  for(int i=120; i<width; i += 1)
  {
    float y = carrier((i+t)/1.2);
    vertex(i,-y);
  }
  endShape();
  
  if(mew > 1)
    stroke(255, 0, 0);
  else
    stroke(0, 255, 0);
  translate(0, width/4);
  
  text("Modulated:", 10, 0);
  beginShape();
  for(int i=120; i<width; i += 1)
  {
    float y = carrier((i+t)/1.2) * (1 + ka * modulating((i+t)/1.2));
    vertex(i,-y);
  }
  endShape();
  
  if(mousePressed)
    ka = map(mouseX, 0, width, 0.5, 1.5) / am;
  
  t+=0.5;
}

float carrier(float t)
{
  return ac*sin(2*PI*f1*t);
}

float modulating(float t)
{
  return am*sin(2*PI*f2*t);
}
