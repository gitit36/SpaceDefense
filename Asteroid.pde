class Asteroid{
  PVector pos;
  PVector acc;
  PVector vel;
  int vertices;
  float r;
  color c;

  Asteroid(){
    pos = new PVector(random(width), random(-height, 0));
    acc = new PVector(random(-0.1, 0.1), random(0.1, 0.7));
    vel = new PVector(0, 0);
    vertices = int(random(3, 15)); // what type of polygon? triangle ~ 15-gon
    r = random(10, 45);
  }
  
  void update(){
    vel.add(acc);
    vel.limit(2);
    pos.add(vel);
    
    // Readjust location if the player goes off screen on the side
    if((pos.x + r < 0) || (pos.x - r > width)){
      pos.x = random(0, width);
      pos.y = random(-height, 0);
    }
    if (pos.y + r > height){
      if (health > 0){
        health -= 10; // reduce health
      }
      pos.y = random(-height,0);
      pos.x = random(0, width);
      // meteor crash
      sound2.rewind();
      sound2.play();
    }
  }
  
  void display(){
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(frameCount / 50.0);
    asteroidShape(0, 0, r, vertices);
    popMatrix();
  }
  
  boolean checkCollision(Laser b){
    if((b.p.y + 6) <= pos.y + r && b.p.x >= pos.x - r && b.p.x <= pos.x + r){
      sound.rewind();
      sound.play();
      return true;
    } 
    else {
      return false;
    }
  }
}
