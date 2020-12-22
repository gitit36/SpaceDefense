class Item{
  PVector po;
  PVector ac;
  PVector ve;

  Item(){
    po = new PVector(random(width), random(-height, 0));
    ac = new PVector(0, 0.001);
    ve = new PVector(0, 0);
  }
  
  void update(){
    ve.add(ac);
    ve.limit(1);
    po.add(ve);
 
    // Readjust location if the player goes off screen on the side
    if((po.x < -25) || (po.x > width + 25)){
      po.x = random(width);
      po.y = random(-height+100, 0);
    }
    if (po.y > height - 25){
      po.y = random(-height+100,0);
      po.x = random(width);
      // meteor crash
      sound2.rewind();
      sound2.play();
    }
  }
  
  void display(){
    pushMatrix();
    translate(po.x, po.y);
    image(earth, 0, 0);
    popMatrix();
  }
  
  
  boolean checkCollision(Laser b){
    if((b.p.y + 6) <= po.y + 25 && b.p.x >= po.x - 10 && b.p.x <= po.x + 50){
      sound.rewind();
      sound.play();
      return true;
    } 
    else {
      return false;
    }
  }
}
