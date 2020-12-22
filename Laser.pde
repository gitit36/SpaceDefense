class Laser{
  PVector p;
  PVector a;
  PVector v;
  int w, h;
  
  Laser(float tx, float ty){
     p = new PVector(tx, ty);
     a = new PVector(0,-0.2);
     v = new PVector(0, -2.5);
  }
  
  void display(){
     noStroke();
     fill(random(255), random(255), random(255));
     rect(p.x, p.y, 5, 12);
  }
  
  void move(){
    v.add(a);
    p.add(v);
  }
}
