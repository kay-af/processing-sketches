int n = 30;
float s;

int snakeX[], snakeY[];
int l;
int dir;

int foodX, foodY;
boolean foodSpawned;

float t;
int score;

void setup() {
   size(600, 600);
   s = width/n;
   snakeX = new int[30*30];
   snakeY = new int[30*30];
   gameOver();
}

void draw() {
  float delta = 1 / frameRate;
  background(0);
  
  if(!foodSpawned)
    spawnFood();
  
  drawSnake();
  drawFood();
  
  t += delta;
  if(t>0.2f) {
    t = t%0.2f;
    move();
  }
  drawWalls();
  fill(255, 0, 0);
  textAlign(LEFT, CENTER);
  text("Score: " + score, s, s/2);
}

void drawFood() {
  fill(0,255,0);
  noStroke();
  rect(foodX * s + 4, foodY * s + 4, s - 8, s - 8);
}

void drawSnake() {
  stroke(0);
  fill(255);
  for(int i=0; i<l; i++) {
    rect(snakeX[i]*s, snakeY[i]*s, s, s);
  }
}

void move() {
  for(int i=l-1; i>0; i--) {
    snakeX[i] = snakeX[i-1];
    snakeY[i] = snakeY[i-1];
  }
  switch(dir) {
    case 0:
      snakeX[0] -= 1;
      break;
    case 1:
      snakeY[0] -= 1;
      break;
    case 2:
      snakeX[0] += 1;
      break;
    case 3:
      snakeY[0] += 1;
  }
  
  for(int i=1; i<l; i++) {
    if(snakeX[i] == snakeX[0] && snakeY[i] == snakeY[0]) {
      gameOver();
      return;
    }
  }
  
  if(snakeX[0] == 0 || snakeX[0] == 29 || snakeY[0] == 0 || snakeY[0] == 29) {
    gameOver();
    return;
  }
  
  if(inSnake(foodX, foodY)) {
    grow();
    score += 1;
    foodSpawned = false;
  }
}

void gameOver() {
   foodSpawned = false;
   l = 4;
   dir = 2;
   score = 0;
   snakeX[0] = 15;
   snakeY[0] = 15;
   snakeX[1] = 14;
   snakeY[1] = 15;
   snakeX[2] = 13;
   snakeY[2] = 15;
   snakeX[3] = 12;
   snakeY[3] = 15;
   t = 0;
}

void grow() {
  l++;
  snakeX[l] = -10;
  snakeY[l] = -10;
}

void spawnFood() {
  foodX = int(random(1, 29));
  foodY = int(random(1, 29));
  
  while(inSnake(foodX, foodY)) {
    foodX = int(random(1, 29));
    foodY = int(random(1, 29));
  }
  foodSpawned = true;
}

boolean inSnake(int x, int y) {
  
  for(int i=0; i<l; i++) {
    if(snakeX[i] == x && snakeY[i] == y)
      return true;
  }
  return false;
}

void drawWalls() {
 noStroke();
 fill(255);
 rect(0,0,width,s);
 rect(0,0,s,height);
 rect(width-s,0,s,height);
 rect(0,height-s,width,s);
}

void keyPressed() {
  if(key == CODED) {
    switch(keyCode) {
      case UP:
        if(dir!=3)
          dir = 1;
        break;
      case DOWN:
        if(dir!=1)
          dir = 3;
        break;
      case LEFT:
        if(dir!=2)
          dir = 0;
        break;
      case RIGHT:
        if(dir!=0)
          dir = 2;
        break;   
    }
  }
}
