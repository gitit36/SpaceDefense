// Main

import ddf.minim.*;

/************* Serial **************/
import processing.serial.*;
Serial myPort;
int xPos=0;
int left, right, b, reset;
/************* Serial **************/

Player player; 
Item item;
PFont font, font2;
PImage starship, earth, galaxy;
ArrayList<Asteroid> asteroids;
ArrayList <Laser> laser; 
ArrayList<Item> items;
boolean instruction = true;
boolean [] keys = new boolean[128];
String message;
int[] land;
int health, asteroidCount, itemCount;
int asteroid_ = 0;
int item_ = 0;
int level = 1;
int count = 1;

//sound effect
Minim minim;
AudioPlayer soundtrack, sound, sound2, sound3, sound4;

void setup() {
  size(480, 640);
  
  if (count == 1){
    /************* Serial **************/
    printArray(Serial.list());
    String portname = Serial.list()[5];
    println(portname);
    myPort = new Serial(this,portname,9600);
    myPort.clear();
    myPort.bufferUntil('\n');
    /***********************************/
    }
  
  // Sound effect processing
  minim = new Minim(this);
  soundtrack = minim.loadFile("soundtrack.mp3");
  sound = minim.loadFile("laser.mp3");
  sound2 = minim.loadFile("crash.mp3");
  sound3 = minim.loadFile("ouch.mp3");
  sound4 = minim.loadFile("life.mp3");
  sound2.setGain(-10);

  // Images
  starship = loadImage("starship.png");
  earth = loadImage("earth.png");
  
  // Font
  font2 = createFont("Cambria-bold",60);
  font = createFont("Phosphate-Inline",60);
  
  // asteroid_ ==  0 means when you start the game
  // else meanse after Level 1
  health = 100;
  if (asteroid_ == 0 && count == 1){
    asteroidCount = 10;
    itemCount = 5;
    soundtrack.rewind();
    soundtrack.play();
  }
  else {
    asteroidCount = 10 + asteroid_;
    itemCount = 5 + item_;}

  /********** Initiating Objects ***********/
  // Player
  player = new Player();
  // Meteor
  asteroids = new ArrayList<Asteroid>();
  for (int i=0; i < asteroidCount; i++) { 
    asteroids.add(new Asteroid());}
  // Bullet
  laser = new ArrayList();
  // Earth item
  items = new ArrayList<Item>();
  for (int i=0; i < itemCount; i++) { 
    items.add(new Item());}
 /*******************************************/

  // Background
  land = new int [width/10+1];
  for (int i = 0; i < land.length; i++) { 
    land[i] = int(random(10));}
    
  message = "Level ";
  
}

void draw() {
  
  
  if (instruction){
    galaxy = loadImage("instruction_background.jpg");
    //Using the width and height of the photo for the screen size
    galaxy.resize(width,height); 
    image(galaxy,0,0);
    textAlign(CENTER);
    textFont(font);
    fill(#FFFF00);
    text("SPACE DEFENSE",width/2,height/2-120);
    textFont(font2);
    textSize(20);
    fill(255);
    text("Protect the planet from falling asteroids!\n* * *\nPress YELLOW to move left\nPress BLUE to move right\nPress RED to shoot\nPress GREEN to restart\n* * *\nClick anywhere to proceed",width/2,height/2);
    return;
  }
  
  background(0);
  fill(255);
  noStroke();
  ellipse(random(width), random(height-50), 3, 3);

  textSize(32);
  fill(255);
  text(message+level, width/2, 100);

  drawEarth();

  for (int i= asteroids.size()-1; i >= 0; i--) {
    Asteroid p = asteroids.get(i);
    p.update();
    p.display();
    if (player.checkCollision(p)) {
      if (health > 0) {
        health -= 2;
      }
      sound3.rewind();
      sound3.play();
    }
    for (int j= laser.size()-1; j >= 0; j--) {
      Laser b = laser.get(j);
      // If an asteroid appears on screen and collides with a bullet
      if ((p.pos.y + p.r > 0) && (p.checkCollision(b))) {
        if (asteroids.size() > 0){
          asteroids.remove(i);
          laser.remove(j);
          asteroidCount = asteroids.size();
        }
        sound2.rewind();
        sound2.play();
      }
    }
  }

  for (int i= items.size()-1; i >= 0; i--) {
    Item it = items.get(i);
    it.update();
    it.display();
    for (int j= laser.size()-1; j >= 0; j--) {
      Laser b = laser.get(j);
      // If an item appears on screen and collides with a bullet
      if ((it.po.y + 25) > 0 && (it.checkCollision(b))) {
        if (items.size() > 0){
          laser.remove(j);
          items.remove(i);
          if (health >= 100) {
            continue;
          }
          health += 10;
          sound4.rewind();
          sound4.play();
        }
      }
    }
  }

  if (asteroids.size() <= 0) {
    delay(1000);
    count = 0;
    asteroid_ += 2;
    item_ -= 1;
    setup();
    level += 1;
    
  }

  player.display();
  player.move();

  for (int i= laser.size()-1; i >= 0; i--) {
    Laser b = laser.get(i);
    b.move();
    b.display();
  }
  
  if (b == 1) {
    Laser temp = new Laser(player.pos.x+16, player.posy);
    laser.add(temp);
    sound.rewind();
    sound.play();
  }
  
  if (reset == 0) {
    count = 0;
    asteroid_ = 0;
    item_= 0;
    level = 1;
    setup();
  }

  textSize(32);
  if (health > 0) {
    text(health, width - 100, 50);
  } else {
    text(0, width - 100, 50);
  }

  if (health <= 0) {
    String over = "Game Over";
    textSize(60);
    text(over, width/2, height/2);
  }
  textSize(32);
  fill(255, 0, 0);
  text(asteroidCount, 100, 50);
}


void asteroidShape(float a, float b, float r, int vertices) {
  float x = map(r, 0, 40, 50, 255);
  float degree = TWO_PI / vertices;
  color col = color(x/2, x/3, 100);
  beginShape();
  for (float i = 0; i < TWO_PI; i += degree) {
    float sx = a + cos(i) * r;
    float sy = b + sin(i) * r;
    fill(col);
    noStroke();
    //curveVertex(sx, sy);
    vertex(sx, sy);
  }
  endShape(CLOSE);
}


void drawEarth() {

  fill(250, 150, 0, 60); 
  noStroke();
  beginShape();
  vertex(0, 640);
  for ( int i=0; i < land.length; i++) {
    vertex( i * 11, 640 - 40 - land[i] );
  } 
  vertex(480, 640);
  endShape(CLOSE);
}


void mousePressed() {
  if (instruction) {
    instruction = false;
  }
  //level = 1;
}


void keyPressed() {
  keys[keyCode] = true;
}


void keyReleased() {
  keys[keyCode] = false;
}



/************* Serial **************/
void serialEvent(Serial myPort){
  String s = myPort.readStringUntil('\n');
  s = trim(s);
  if (s != null){
    int values[] = int(split(s,','));
    if (values.length == 4){
      left = int(values[0]);
      right = int(values[1]);
      b = int(values[2]);
      reset = int(values[3]);
    }
  }
  myPort.write('0');
  
  // For key board use:
  //float xPos = myPort.read();
  //player.pos.x = map(xPos, 0.0, 225.0, 0.0, 390.0)
  //myPort.write(0);
}
/************* Serial **************/
