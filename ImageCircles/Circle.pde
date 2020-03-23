class Circle {
  float x, y;
  float radius;
  color col;
  Circle[] attached;
  boolean triggered;
  boolean triggerable;
  boolean animating;
  
  Circle(float x, float y, float radius) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    triggered = false;
    attached = new Circle[4];
    animating = false;
    
    this.col = image.get(int(x), int(y));
    this.col = (col & 0xffffff) | (0xcc << 24);
    
    if(dist(x, y, mouseX, mouseY) <= radius) triggerable = false;
    else triggerable = true;
  }
  
  Circle(final float x, final float y, final float radius, final float fromX, final float fromY, final float fr) {
    this(x, y, radius);
    Thread t = new Thread(new Runnable() {
      public void run() {
        animating = true;
        animate(fromX, fromY, x, y, fr, radius, 200);
        animating = false;
      }
    });
    t.start();
  }
  
  void animate(float fx, float fy, float tx, float ty, float fr, float tr, float time) {
    long delta = (long)(1f/frameRate * 1000);
    float timer = 0;
    while(timer <= time) {
      this.x = lerp(fx, tx, sin(timer / time * HALF_PI));
      this.y = lerp(fy, ty, sin(timer / time * HALF_PI));
      this.radius = lerp(fr, tr, sin(timer / time * HALF_PI));
      try {
        Thread.sleep(delta);
      } catch(Exception e) {
      }
      timer += delta;
    }
    this.x = tx;
    this.y = ty;
    this.radius = tr;
  }
  
  void show(float x, float y) {
    mouseTrigger(x, y);
    noStroke();
    fill(this.col);
    if(!triggered) {
      ellipse(this.x, this.y, 2*radius, 2*radius);
    } else {
      for(int i=0; i<4; i++) {
        attached[i].show(x, y);
      }
    }
  }
  
  void mouseTrigger(float x, float y) {
    if(animating) return;
    float d = dist(x, y, this.x, this.y);
    if(!triggerable) {
      triggerable = d > radius;
      return;
    }
    if(this.radius <= MIN_RADIUS) return;
    if(triggered) return;
    if(d <= this.radius) {
      triggered = true;
      attached[0] = new Circle(this.x-radius/2, this.y-radius/2, radius/2, this.x, this.y, this.radius);
      attached[1] = new Circle(this.x-radius/2, this.y+radius/2, radius/2, this.x, this.y, this.radius);
      attached[2] = new Circle(this.x+radius/2, this.y-radius/2, radius/2, this.x, this.y, this.radius);
      attached[3] = new Circle(this.x+radius/2, this.y+radius/2, radius/2, this.x, this.y, this.radius);
    }
  }
}
