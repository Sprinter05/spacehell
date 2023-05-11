import java.util.*;

//create objects
PFont cambria;
Character character;
Boss bossOne;

//check game start
boolean gameStart = false;

//bullet stuff
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<CollisionBox> bulletsColl = new ArrayList<CollisionBox>();
int bulletDelay = 100;
int lastShot = millis();

//health ball stuff
ArrayList<HealthBall> hpballs = new ArrayList<HealthBall>();
float hpballDelay;
float lasthpBall = millis();

//pattern stuff
ArrayList<XBullet> pattern1 = new ArrayList<XBullet>();
ArrayList<CollisionCircle> pattern1Coll = new ArrayList<CollisionCircle>();
ArrayList<XBullet> pattern2 = new ArrayList<XBullet>();
ArrayList<CollisionCircle> pattern2Coll = new ArrayList<CollisionCircle>();
ArrayList<XBullet> pattern3 = new ArrayList<XBullet>();
ArrayList<CollisionCircle> pattern3Coll = new ArrayList<CollisionCircle>();
ArrayList<XBullet> pattern4 = new ArrayList<XBullet>();
ArrayList<CollisionCircle> pattern4Coll = new ArrayList<CollisionCircle>();
ArrayList<Bomb> pattern4Bomb = new ArrayList<Bomb>();
ArrayList<Shield> pattern5Shield = new ArrayList<Shield>();
ArrayList<XBullet> pattern6 = new ArrayList<XBullet>();
ArrayList<CollisionCircle> pattern6Coll = new ArrayList<CollisionCircle>();
float p1Delay, p2Delay, p3Delay, p4Delay, p5Delay, p6Delay;
float p2Duration, p3Duration;
float lastP1, lastP2, lastP3, lastP4, lastP5, lastP6 = millis();
boolean canP2, canP3, canP5 = false;
float[] p2colors = new float[3];
float[] p3colors = new float[3];
float[] p4colors = new float[3];
float delay3, size3, speed3, angDiff3, startAng3, p3AngLoop;

//keypress detections
boolean wPressed = false;
boolean dPressed = false;
boolean sPressed = false;
boolean aPressed = false;
boolean zPressed = false;
boolean xPressed = false;
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
  character = new Character(width/2,height/2,6,4,35,100,100);
  int[] patterns = {1,1,1};
  bossOne = new Boss(width/2,60,70,200,200,patterns);

  //load background images
  for (int i = 0; i < 16; i += 1){
    images[i] = loadImage("f"+i+".gif");
  }
}

void draw(){
  background(0); //cls

  //Animation stuff
  currentFrame = (currentFrame+1) % numFrames;  // Use % to cycle through frames
  int offset = 0;
  for (int x = -100; x < width; x += images[0].width) { 
    image(images[(currentFrame+offset) % numFrames], x, 0);
    offset+=2;
  }

  //game over if character dead
  if (character.isDead()) {
    noLoop();
    gameOver();
  }

  //summon character
  if (!character.isDead()) summonCharacter(character);

  //summon boss
  if (!bossOne.isDead() && gameStart) summonBoss(bossOne);
  
  //bullet activation and bullet functions
  if (zPressed && (millis() - lastShot) > bulletDelay){
    Bullet b = new Bullet(character.x + character.size/3, character.y -15,15,15);
    bullets.add(b);
    bulletsColl.add(new CollisionBox(b.x, b.y, b.radius,b.radius));
    lastShot = millis();
  }

  //health ball
  hpballDelay = random(25000,35000);
  if (millis() - lasthpBall > hpballDelay && hpballs.isEmpty()){
    HealthBall hpb = new HealthBall(random(0,width-150),random(0, height/2),2,50,random(15,25),random(40,60),random(15000,20000));
    hpballs.add(hpb);
  }
  if (!hpballs.isEmpty()) {handlehpBalls();}

  //handle some functions
  if (!bullets.isEmpty()) {bulletStuff();}
  if (!pattern1.isEmpty()) {handlePattern(pattern1, pattern1Coll);}
  if (!pattern2.isEmpty()) {handlePattern(pattern2, pattern2Coll);}
  if (!pattern3.isEmpty()) {handlePattern(pattern3, pattern3Coll);}
  if (!pattern4Bomb.isEmpty()) {pattern4(pattern4Bomb);}
  if (!pattern4.isEmpty()) {handlePattern(pattern4, pattern4Coll);}
  if (!pattern5Shield.isEmpty()) {pattern5(pattern5Shield);}
  if (!pattern6.isEmpty()) {handlePattern(pattern6, pattern6Coll);}

  //activate other functions
  if (!gameStart) {startText();}
  if (tPressed) {debugText();}
  fps();
}

//handle character
void summonCharacter(Character character){
  //appear and move
  character.display();
  character.move();
  //create own collision
  float sizeMult = -2;
  CollisionBox charCollision = new CollisionBox(character.x - (sizeMult/2), character.y - (sizeMult/2), character.size + sizeMult, character.size + sizeMult);
  charCollision.display();
  //call method for collision with boss bullets
  handleCharacterCollisions(charCollision, pattern1, pattern1Coll);
  handleCharacterCollisions(charCollision, pattern2, pattern2Coll);
  handleCharacterCollisions(charCollision, pattern3, pattern3Coll);
  handleCharacterCollisions(charCollision, pattern4, pattern4Coll);
  handleCharacterCollisions(charCollision, pattern6, pattern6Coll);
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

//collision with boss bullets
void handleCharacterCollisions(CollisionBox charCollision, ArrayList<XBullet> pattern, ArrayList<CollisionCircle> coll){
  Iterator<XBullet> i = pattern.listIterator();
  Iterator<CollisionCircle> j = coll.listIterator();
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
      }
      i.remove();
      j.remove();
    }
  }
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
      if (millis() - boss.lastDamage > boss.healthDelay && pattern5Shield.isEmpty()) {
        boss.health -= 1;
        boss.lastDamage = millis();
      }
      i.remove();
      j.remove();
    }
  }
  //summon patterns
  //pattern 1
  p1Delay = random(600,1000);
  if ((millis() - lastP1) > p1Delay && !canP2){
    float[] p1colors = {random(100,256),random(100,256),random(100,256)};
    pattern1(boss,random(10,16),15*random(1,5),10*random(2,4),360,15*random(0,4),p1colors);
    lastP1 = millis();
  }
  //pattern 2
  p2Duration = random(5000,10000);
  p2Delay = random(6000,12000);
  if (canP2 && (millis() - lastP2) > p2Duration) {
    canP2 = false;
    lastP2 = millis();
  }
  if (!canP2 && (millis() - lastP2) > p2Delay) {
    canP2 = true;
    lastP2 = millis();
    p2colors[0] = random(100,256);
    p2colors[1] = random(100,256);
    p2colors[1] = random(100,256);
  }
  if (canP2) {pattern2(random(10,16),10*random(2,4),random(50,100),p2colors);}
  //pattern 3
  p3Duration = random(4000,8000);
  p3Delay = random(5000,7000);
  if (canP3 && (millis() - lastP3) > p3Duration) {
    canP3 = false;
    lastP3 = millis();
  }
  if (!canP3 && (millis() - lastP3) > p3Delay) {
    canP3 = true;
    lastP3 = millis();
    p3AngLoop = 0;
    speed3 = random(10,16);
    size3 = 10*random(2,4);
    angDiff3 = 15*random(1,5);
    startAng3 = 15*random(0,4);
    delay3 = random(50,200);
    p3colors[0] = random(100,256);
    p3colors[1] = random(100,256);
    p3colors[1] = random(100,256);
  }
  if(canP3) {pattern3(boss,speed3,angDiff3,size3,startAng3,delay3,p3colors);}
  //pattern 4
  p4Delay = random(3000,5000);
  if((millis() - lastP4) > p4Delay && !canP2){
    float[] p4colors = {random(100,256),random(100,256),random(100,256)};
    Bomb bomb = new Bomb(random(100,width-150),0,random(8,14),random(12,18),10*random(2,4),random(height/3,height-100),random(50,200),random(15,60),int(random(0,2)),p4colors);
    pattern4Bomb.add(bomb);
    lastP4 = millis();
  }
  //pattern 5
  p5Delay = random(30000,70000);
  if((millis() - lastP5) > p5Delay && !canP5){
    Shield shield1 = new Shield(boss.x - 200, boss.y, 3, 50, 50);
    Shield shield2 = new Shield(boss.x + 200, boss.y, 3, 50, 50);
    pattern5Shield.add(shield1);
    pattern5Shield.add(shield2);
    canP5 = true;
  }
  if (pattern5Shield.isEmpty()) {canP5 = false;}
  //pattern 6
  //display health
  boss.displayHP();
}

//Boss bullet patterns
//pattern 1
void pattern1(Boss boss, float speed, float angleDiff, float size, float maxAngle, float startingAngle, float[] bullColor){
  for (int i = 0; i <= maxAngle/angleDiff; i = i + 1) {
    XBullet b = new XBullet(boss.x + boss.size/2, boss.y + boss.size/2,speed,speed,startingAngle + (angleDiff*i),size,20,bullColor);
    pattern1.add(b);
    pattern1Coll.add(new CollisionCircle(b.x + b.radius/2, b.y + b.radius/2, b.radius));
  }   
}

//pattern 2
float p2IntDelay = millis();
void pattern2(float speed, float size, float delay, float[] bullColor){
 if ((millis() - p2IntDelay) > delay) {
    XBullet b = new XBullet(random(0,width),0,speed*-1,speed*-1,-90,size,0,bullColor);
    pattern2.add(b);
    pattern2Coll.add(new CollisionCircle(b.x + b.radius/2, b.y + b.radius/2, b.radius));
    p2IntDelay = millis();
  }
}

//pattern 3
float p3IntDelay = millis();
void pattern3(Boss boss, float speed, float angleDiff, float size, float startingAngle, float delay, float[] bullColor){
 if ((millis() - p3IntDelay) > delay) {
    XBullet b = new XBullet(boss.x-boss.size/2,boss.y-boss.size/2,speed,speed,startingAngle+(angleDiff*p3AngLoop),size,20,bullColor);
    pattern3.add(b);
    pattern3Coll.add(new CollisionCircle(b.x + b.radius/2, b.y + b.radius/2, b.radius));
    p3IntDelay = millis();
    p3AngLoop += 1;
  }
}

//pattern 4
float p4IntDelay = millis();
void pattern4(ArrayList<Bomb> bombs){
  Iterator<Bomb> i = bombs.listIterator();
  while(i.hasNext()){
    Bomb bomb = i.next();
    if (!bomb.canTrigger()){
      bomb.draw();
      bomb.update();
    } else {
      if (bomb.repetitions > 0 && millis() - p4IntDelay > bomb.delay){
        bomb.triggerBomb();
        p4IntDelay = millis();
      }    
    }
    if (bomb.repetitions <= 0){
      i.remove();
    }
  }
}

//pattern 5
void pattern5(ArrayList<Shield> shields){
  Iterator<Shield> i = shields.listIterator();
  while(i.hasNext()){
    Shield s = i.next();
    CollisionBox c = new CollisionBox(s.x,s.y,s.sizeX,s.sizeY);
    handleShieldCollision(s,c);
    s.draw();
    s.update();
    c.display();
    s.displayHP();
    if (s.isDead()){
      i.remove();
      lastP5 = millis();
    }
  }
}

//handle boss bullets for patterns
void handlePattern(ArrayList<XBullet> pattern, ArrayList<CollisionCircle> collisions) {
  Iterator<XBullet> i = pattern.listIterator();
  Iterator<CollisionCircle> j = collisions.listIterator();
  while (i.hasNext() && j.hasNext()) {
    XBullet b = i.next();
    CollisionCircle c = j.next();
    b.draw();
    c.ypos = b.y + b.radius/2;
    c.xpos = b.x + b.radius/2;
    c.display();
    if (b.update()) {
      i.remove();
      j.remove();
    }
  }
}

void handleShieldCollision(Shield shield, CollisionBox sc){
  Iterator<Bullet> i = bullets.listIterator();
  Iterator<CollisionBox> j = bulletsColl.listIterator();
  while (i.hasNext()){
    Bullet b = i.next();
    CollisionBox c = j.next();
    if (
      sc.xpos + sc.wid > c.xpos && 
      sc.xpos < c.xpos + c.wid &&
      sc.ypos + sc.hei > c.ypos &&
      sc.ypos < c.ypos + sc.hei
    ) {
      if (millis() - shield.lastDamage > shield.healthDelay) {
        shield.health -= 1;
        shield.lastDamage = millis();
      }
      i.remove();
      j.remove();
    }
  }
}

void handlehpBalls(){
  Iterator<HealthBall> i = hpballs.listIterator();
  if (i.hasNext()){
    HealthBall hpb = i.next();
    CollisionCircle c = new CollisionCircle(hpb.x,hpb.y,hpb.size);
    handlehpBallCollision(hpb,c);
    hpb.display();
    c.display();
    hpb.move();
    if (hpb.isDespawned() || hpb.isDead()){
      i.remove();
      lasthpBall = millis();
    }
  }
}

void handlehpBallCollision(HealthBall hpb, CollisionCircle hpbc){
  Iterator<Bullet> i = bullets.listIterator();
  Iterator<CollisionBox> j = bulletsColl.listIterator();
  while (i.hasNext()){
    Bullet b = i.next();
    CollisionBox c = j.next();
    float checkX = hpbc.xpos;
    float checkY = hpbc.ypos;
    if (hpbc.xpos < c.xpos) {checkX = c.xpos;}
    else if (hpbc.xpos > c.xpos + c.wid) {checkX = c.xpos + c.wid;}
    if (hpbc.ypos < c.ypos) {checkY = c.ypos;}
    else if (hpbc.ypos > c.ypos + c.hei) {checkY = c.ypos + c.hei;}
    float distX = hpbc.xpos - checkX;
    float distY = hpbc.ypos - checkY;
    float distance = sqrt((distX*distX) + (distY*distY));
    if (distance <= hpbc.radius) {
      if (millis() - hpb.lastDamage > hpb.healthDelay) {
        hpb.health -= 1;
        hpb.lastDamage = millis();
        if (hpb.isDead()){
          if (character.health + hpb.hpRecover >= character.maxHealth){
            character.health = character.maxHealth;
          } else {
            character.health += hpb.hpRecover;
          }
        }
      }
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
    c.ypos = b.y;
    c.xpos = b.x;
    c.display();
    if (b.update()) {
      i.remove();
      j.remove();
    }
  }
}

//fps counter (top left)
void fps() {
  textFont(cambria);
  textSize(20);
  fill(0,255,0);
  float roundedfps = (round(frameRate * 1000));
  text(str(roundedfps/1000),25,25);
}

//start game text
void startText(){
  textFont(cambria);
  textSize(20);
  fill(255,255,255);
  text("Press enter to start the game",width/2-100,height-100);
}

//DEBUG collisions text
void debugText(){
  textFont(cambria);
  textSize(15);
  fill(255,0,0);
  text("DEBUG COLLISIONS",width-150,30);
}

//game over text
void gameOver(){
  textFont(cambria);
  textSize(30);
  fill(255,255,255);
  text("> GAME OVER <",width/2-200,30);
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
  if (key == 'x') {
    xPressed = true;
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
      lastP1 = lastP2 = lastP3 = lastP4 = lastP5 = millis();
      loop();
    } else {
      spcPressed = true;
      noLoop();
      textFont(cambria);
      textSize(30);
      fill(255,255,255);
      text("> PAUSE <",width/2-100,30);
    }
  }
  if (!gameStart && key == ENTER) {
    gameStart = true;
    lastP1 = lastP2 = lastP3 = lastP4 = lastP5 = millis();
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
  if (key == 'x') {
    xPressed = false;
  }
}