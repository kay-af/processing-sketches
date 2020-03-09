int h,m,s;

void setup()
{
  size(600,600);
}

void draw()
{
  background(0);
  stroke(30);
  strokeWeight(10);
  fill(60);
  translate(width/2,height/2);
  ellipse(0,0,500,500);
  
  h = hour();
  m = minute();
  s = second();
  
  // Guides
  pushMatrix();
  stroke(255);
  for(float i=1;i<=60;i++)
  {
    float rot = PI/30;
    rotate(rot);
    if(i%5==0)
    {
      strokeWeight(5);
      stroke(0);
      line(0,-180,0,-230);
    }
    else
    {
      strokeWeight(3);
      stroke(255);
      line(0,-200,0,-220);
    }
  }
  popMatrix();
  
  // second
  pushMatrix();
  rotate((PI/30)*s);
  stroke(255,0,0);
  strokeWeight(3);
  line(0,0,0,-200);
  popMatrix();
  
  // minute
  pushMatrix();
  rotate((PI/30)*m);
  stroke(0,255,0);
  strokeWeight(6);
  line(0,0,0,-180);
  popMatrix();
  
  // hour
  pushMatrix();
  rotate((PI/6)*h);
  stroke(0,0,255);
  strokeWeight(6);
  line(0,0,0,-140);
  popMatrix();
  
  strokeWeight(15);
  stroke(255);
  point(0,0);
  
  fill(255,255,255,20);
  noStroke();
  arc(0,0,480,480,-PI/3,2*PI/3,OPEN);
}
