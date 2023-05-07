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

float xangle = 90.0;

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
  // println(str(bulletsColl.size()) + ", " + str(bullets.size())); //DEBUG
  bulletStuff();
  xbulletStuff();

  //activate other functions
  fps();
}

//handle character
void summonCharacter(Character character){
  //appear and move
  character.display();
  character.move();
  //create own collision
  CollisionBox charCollision = new CollisionBox(character.x - character.size/8, character.y - character.size/8, character.size + 5, character.size + 5);
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
  CollisionBox bossCollision = new CollisionBox(boss.x - boss.size/16, boss.y - boss.size/16, boss.size + 5, boss.size + 5);
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
    XBullet b = new XBullet(boss.x + boss.size /2, boss.y + boss.size /2, 15, 15, radians(xangle), 5);
    xbullets.add(b);
    xbulletsColl.add(new CollisionCircle(b.x - b.radius/2, b.y - b.radius/2, b.radius +1));
    xlastShot = millis();
    xangle += 5;
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

//handle amount of bossbullets and drawing boss bullets on screen (collisions included)
void xbulletStuff() {
  Iterator<XBullet> i = xbullets.listIterator();
  Iterator<CollisionCircle> j = xbulletsColl.listIterator();
  while (i.hasNext() && j.hasNext()) {
    XBullet b = i.next();
    CollisionCircle c = j.next();
    b.draw();
    c.ypos = b.y + b.radius/8;
    c.xpos = b.x + b.radius/8;
    c.display();
    if (b.update()) {
      i.remove();
      j.remove();
    }
  }
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