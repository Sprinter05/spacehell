import java.util.*;

//create objects
PFont cambria;
Character character;
CollisionBox testCollision;
Boss testBoss;

//bullet stuff
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<CollisionBox> bulletsColl = new ArrayList<CollisionBox>();
int bulletDelay = 50;
int lastShot = millis();

//keypress detections
boolean wPressed = false;
boolean dPressed = false;
boolean sPressed = false;
boolean aPressed = false;
boolean zPressed = false;
boolean tPressed = false;
boolean spcPressed = false;

void setup(){
  //setup canvas and parameters
  size(1280,720);
  background(255,255,255);
  frameRate(60);
  cambria = createFont("cambria.ttf", 24);

  //summon objects
  character = new Character(150,150,6,6,20,100);
  testBoss = new Boss(width/2, 50, 40, 200);
}

void draw(){
  //cls
  background(255,255,255);

  //game over if character dead
  if (character.isDead()) {
    noLoop();
    textFont(cambria);
    textSize(30);
    fill(0,0,0);
    text("> GAME OVER <",width/2-200,30);
  }

  //summon test collision
  testCollision = new CollisionBox(300, 200, 25,25);
  testCollision.display();

  //summon character
  if (!character.isDead()) summonCharacter(character);

  //summon test boss
  if (!testBoss.isDead()) summonBoss(testBoss);
  
  //bullet activation and bullet functions
  if (zPressed && (millis() - lastShot) > bulletDelay){
    Bullet b = new Bullet(character.x +10, character.y -15,15,5);
    bullets.add(b);
    bulletsColl.add(new CollisionBox(b.x - b.radius/2, b.y - b.radius/2, b.radius,b.radius));
    lastShot = millis();
  }
  println(str(bulletsColl.size()) + ", " + str(bullets.size())); //DEBUG
  bulletStuff();

  //activate other functions
  fps();
}

//handle character
void summonCharacter(Character character){
  //appear and move
  character.display();
  character.move();
  //collision with testCollision
  CollisionBox charCollision = new CollisionBox(character.x - character.size/8, character.y - character.size/8, character.size + 5, character.size + 5);
  charCollision.display();
  if (
  charCollision.xpos + charCollision.wid > testCollision.xpos && 
  charCollision.xpos < testCollision.xpos + testCollision.wid &&
  charCollision.ypos + charCollision.hei > testCollision.ypos &&
  charCollision.ypos < testCollision.ypos + testCollision.hei
  ) {
    if (millis() - character.lastDamage > character.healthDelay) {
      character.health -= 1;
      character.lastDamage = millis();
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
  textFont(cambria);
  textSize(20);
  fill(255,0,0);
  text(str(character.health),width-50, 20);
}

//handle boss
void summonBoss(Boss boss){
  //appear
  boss.display();
  //collision with bullets
  CollisionBox bossCollision = new CollisionBox(boss.x - boss.size/16, boss.y - boss.size/16, boss.size + 5, boss.size + 5);
  bossCollision.display();
  Iterator<Bullet> i = bullets.listIterator();
  Iterator<CollisionBox> j = bulletsColl.listIterator();
  while (i.hasNext()){
    Bullet b = i.next();
    CollisionBox c = j.next();
    if (
      bossCollision.xpos + bossCollision.wid > c.xpos && 
      bossCollision.xpos < c.xpos + c.wid &&
      bossCollision.ypos + bossCollision.hei > c.ypos &&
      bossCollision.ypos < c.ypos + testCollision.hei
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
  //display health
  textFont(cambria);
  textSize(20);
  fill(160,30,240);
  text(str(boss.health),width-50, 40);
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