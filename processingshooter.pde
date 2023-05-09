import java.util.*;

//create objects
PFont cambria;
Character character;
Boss testBoss;

//bullet stuff
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<CollisionBox> bulletsColl = new ArrayList<CollisionBox>();
int bulletDelay = 50;
int lastShot = millis();

//boss bullet stuff
ArrayList<XBullet> xbullets = new ArrayList<XBullet>();
ArrayList<CollisionCircle> xbulletsColl = new ArrayList<CollisionCircle>();
int xbulletDelay = 50;
int xlastShot = millis();

//keypress detections
boolean wPressed = false;
boolean dPressed = false;
boolean sPressed = false;
boolean aPressed = false;
boolean zPressed = false;
boolean tPressed = false;
boolean spcPressed = false;

//background
int numFrames = 16;  // The number of frames in the animation
int currentFrame = 0;
PImage[] images = new PImage[numFrames];

void setup(){
  //setup canvas and parameters
  size(1280,720);
  background(0,0,0);
  frameRate(60);
  cambria = createFont("cambria.ttf", 24);

  //summon objects
  character = new Character(150,150,6,6,50,100);
  testBoss = new Boss(width/2, 50, 40, 200);

  //background
  images[0]  = loadImage("frame_00_delay-0.1s.gif");
  images[1]  = loadImage("frame_01_delay-0.1s.gif"); 
  images[2]  = loadImage("frame_02_delay-0.1s.gif");
  images[3]  = loadImage("frame_03_delay-0.1s.gif"); 
  images[4]  = loadImage("frame_04_delay-0.1s.gif");
  images[5]  = loadImage("frame_05_delay-0.1s.gif"); 
  images[6]  = loadImage("frame_06_delay-0.1s.gif");
  images[7]  = loadImage("frame_07_delay-0.1s.gif"); 
  images[8]  = loadImage("frame_08_delay-0.1s.gif");
  images[9]  = loadImage("frame_09_delay-0.1s.gif"); 
  images[10] = loadImage("frame_10_delay-0.1s.gif");
  images[11] = loadImage("frame_11_delay-0.1s.gif");
  images[12]  = loadImage("frame_12_delay-0.1s.gif");
  images[13]  = loadImage("frame_13_delay-0.1s.gif"); 
  images[14] = loadImage("frame_14_delay-0.1s.gif");
  images[15] = loadImage("frame_15_delay-0.1s.gif");
}

void draw(){
  //cls
  
  background(0);
  currentFrame = (currentFrame+1) % numFrames;  // Use % to cycle through frames
  int offset = 0;
  for (int x = -100; x < width; x += images[0].width) { 
    image(images[(currentFrame+offset) % numFrames], x, 0);
    offset+=2;
  }
  //game over if character dead
  if (character.isDead()) {
    noLoop();
    textFont(cambria);
    textSize(30);
    fill(0,0,0);
    text("> GAME OVER <",width/2-200,30);
  }

  //summon character
  if (!character.isDead()) summonCharacter(character);

  //summon test boss
  if (!testBoss.isDead()) summonBoss(testBoss);
  
  //bullet activation and bullet functions
  if (zPressed && (millis() - lastShot) > bulletDelay){
    Bullet b = new Bullet(character.x + character.size/2, character.y -15,15,5);
    bullets.add(b);
    bulletsColl.add(new CollisionBox(b.x - b.radius/2, b.y - b.radius/2, b.radius,b.radius));
    lastShot = millis();
  }
  // println(str(bulletsColl.size()) + ", " + str(bullets.size())); //DEBUG
  bulletStuff();

  //activate other functions
  fps();
}

//handle character
void summonCharacter(Character character){
  //appear and move
  character.display();
  character.move();
  //create own collision
  float sizeMult = 5;
  CollisionBox charCollision = new CollisionBox(character.x - (sizeMult/2), character.y - (sizeMult/2), character.size + sizeMult, character.size + sizeMult);
  charCollision.display();
  //collision with boss bullets
  Iterator<XBullet> i = xbullets.listIterator();
  Iterator<CollisionCircle> j = xbulletsColl.listIterator();
  while (i.hasNext()){
    XBullet b = i.next();
    CollisionCircle c = j.next();
    float checkX = c.xpos;
    float checkY = c.ypos;
    if (c.xpos < charCollision.xpos) {checkX = charCollision.xpos;}
    else if (c.xpos > charCollision.xpos + charCollision.wid) {checkX = charCollision.xpos + charCollision.wid;}
    if (c.ypos < charCollision.ypos) {checkY = charCollision.ypos;}
    else if (c.ypos > charCollision.ypos + charCollision.hei) {checkY = charCollision.ypos + charCollision.hei;}
    float distX = c.xpos - checkX;
    float distY = c.ypos - checkY;
    float distance = sqrt((distX*distX) + (distY*distY));
    if (distance <= c.radius) {
      if (millis() - character.lastDamage > character.healthDelay) {
        character.health -= 1;
        character.lastDamage = millis();
        if (character.isDead()){

        }
      }
      i.remove();
      j.remove();
    }
  }
  //collision with edges
  if (charCollision.xpos < 0) {
    character.x = 0;
  }
  if (charCollision.ypos < 0) {
    character.y = 0;
  }
  if (charCollision.xpos > width - character.size) {
    character.x = width - character.size;
  }
  if (charCollision.ypos > height - character.size) {
    character.y = height - character.size;
  }
  //display health
  character.displayHP();
}

//handle boss
void summonBoss(Boss boss){
  //appear
  boss.display();
  //create own collision
  float sizeMult = 5;
  CollisionBox bossCollision = new CollisionBox(boss.x - (sizeMult/2), boss.y - (sizeMult/2), boss.size + sizeMult, boss.size + sizeMult);
  bossCollision.display();
  //collision with bullets
  Iterator<Bullet> i = bullets.listIterator();
  Iterator<CollisionBox> j = bulletsColl.listIterator();
  while (i.hasNext()){
    Bullet b = i.next();
    CollisionBox c = j.next();
    if (
      bossCollision.xpos + bossCollision.wid > c.xpos && 
      bossCollision.xpos < c.xpos + c.wid &&
      bossCollision.ypos + bossCollision.hei > c.ypos &&
      bossCollision.ypos < c.ypos + bossCollision.hei
    ) {
      if (millis() - boss.lastDamage > boss.healthDelay) {
        boss.health -= 1;
        boss.lastDamage = millis();
        if (boss.isDead()){

        }
      }
      i.remove();
      j.remove();
    }
  }
  //test bullet summon
  if ((millis() - xlastShot) > xbulletDelay){

  }
  //display health
  boss.displayHP();
}

//fps counter (top left)
void fps() {
  textFont(cambria);
  textSize(20);
  fill(0,255,0);
  text(str(frameRate),25,25);
}

//handle amount of bullets and drawing bullets on screen (collisions included)
void bulletStuff() {
  Iterator<Bullet> i = bullets.listIterator();
  Iterator<CollisionBox> j = bulletsColl.listIterator();
  while (i.hasNext() && j.hasNext()) {
    Bullet b = i.next();
    CollisionBox c = j.next();
    b.draw();
    c.ypos = b.y - b.radius/2;
    c.xpos = b.x - b.radius/2;
    c.display();
    if (b.update()) {
      i.remove();
      j.remove();
    }
  }
}

//handle key press and release
void keyPressed() {
  if (keyCode == LEFT) {
    aPressed = true;
  } else if (keyCode == RIGHT) {
    dPressed = true;
  } else if (keyCode == UP) {
    wPressed = true;
  } else if (keyCode == DOWN) {
    sPressed = true;
  }
  if (key == 'z') {
    zPressed = true;
  }
  if (key == 't') {
    if (tPressed) {
      tPressed = false;
    } else {
      tPressed = true;
    }
  }
  if (key == ' ') {
    if (spcPressed) {
      spcPressed = false;
      loop();
    } else {
      spcPressed = true;
      noLoop();
      textFont(cambria);
      textSize(30);
      fill(0,0,0);
      text("> PAUSE <",width/2-100,30);
    }
  }
}
void  keyReleased () {
  if (keyCode == LEFT) {
    aPressed = false;
  } else if (keyCode == RIGHT) {
    dPressed = false;
  } else if (keyCode == UP) {
    wPressed = false;
  } else if (keyCode == DOWN) {
    sPressed = false;
  }
  if (key == 'z') {
    zPressed = false;
  }
}