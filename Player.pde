class Player{
  PVector acc;
  PVector vel;
  PVector pos;
  float posy = height-100;
  
  Player(){
    pos = new PVector(width, height - 100);
    acc = new PVector(0.2, 0.2);
    vel = new PVector(0,0);
  }
  
  void display(){
    image(starship, pos.x, posy); 
  }
  
  void move(){
    acc.normalize();
    vel.mult(5);
    vel.limit(10); 
    vel = vel.add(acc);
    
    if(left == 1){
      pos.x -= vel.x;}
    if(right == 1){
      pos.x += vel.x;}
    
    /* Un-comment for keyboard use
    
    if(keys[LEFT]){
      pos.x -= vel.x;}
    if(keys[RIGHT]){
      pos.x += vel.x;}
    if(keys[UP]){
      pos.y -= vel.y;}
    if(keys[DOWN]){
      pos.y += vel.y;}
    if(pos.y >= height - 50){
      pos.y = height - 82.5;}
    _____________________________*/
    
    if(pos.x < -19){
      pos.x = width -19; 
    }
    if(pos.x > width - 19){
      pos.x = -19;  
    }

  }
  
  boolean checkCollision(Asteroid p){
    if (dist(pos.x, posy, p.pos.x, p.pos.y) <= p.r) {
      textSize(24);
      text("Collision!", width - 60, height - 12);
      return true;
    } 
    else {
      return false;
    }
  }
}
