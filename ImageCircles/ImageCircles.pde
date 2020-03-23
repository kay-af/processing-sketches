PImage image;
float MIN_RADIUS = 2f;

Circle c;

void setup() {
  size(600, 600);
  image = loadImage("girl.jpg");
  image.resize(600,600);
  c = new Circle(300, 300, 300, 300, 300, 0);
}

void draw() {
  background(255);
  c.show(mouseX, mouseY);
}
