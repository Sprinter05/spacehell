import java.util.*;

// Import fonts and sprites
PFont pixel_art;
PFont cambria;
PImage game_over;
PImage logo;
PImage winI;

// Create objects
Character character;
Boss bossOne;

// Declare game state variables
boolean gameStart = false;
boolean gameOver = false;
boolean win = false;

// Declare character's bullets variables
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<CollisionBox> bulletsColl = new ArrayList<CollisionBox>();
int bulletDelay = 100;
int lastShot = millis();

// Declare health ball variables
ArrayList<HealthBall> hpballs = new ArrayList<HealthBall>();
float hpballDelay;
float lasthpBall = millis();

// Declare pattern's variables
ArrayList<XBullet> pattern1 = new ArrayList<XBullet>();
ArrayList<CollisionCircle> pattern1Coll = new ArrayList<CollisionCircle>();
ArrayList<XBullet> pattern2 = new ArrayList<XBullet>();
ArrayList<CollisionCircle> pattern2Coll = new ArrayList<CollisionCircle>();
ArrayList<XBullet> pattern3 = new ArrayList<XBullet>();
ArrayList<CollisionCircle> pattern3Coll = new ArrayList<CollisionCircle>();
ArrayList<Spiral> pattern3Spiral = new ArrayList<Spiral>();
ArrayList<XBullet> pattern4 = new ArrayList<XBullet>();
ArrayList<CollisionCircle> pattern4Coll = new ArrayList<CollisionCircle>();
ArrayList<Bomb> pattern4Bomb = new ArrayList<Bomb>();
ArrayList<Shield> pattern5Shield = new ArrayList<Shield>();
ArrayList<XBullet> pattern6 = new ArrayList<XBullet>();
ArrayList<CollisionCircle> pattern6Coll = new ArrayList<CollisionCircle>();
float p1Delay, p2Delay, p3Delay, p4Delay, p5Delay, p6Delay;
float lastP1, lastP2, lastP3, lastP4, lastP5, lastP6 = millis();
boolean canP2, canP3, canP5 = false;
float p2Duration;
boolean p3Ended = true;
float[] p2colors = new float[3];
float[] p3colors = new float[3];
float delayMult;

// Declare key press variables
boolean wPressed = false;
boolean dPressed = false;
boolean sPressed = false;
boolean aPressed = false;
boolean zPressed = false;
boolean xPressed = false;
boolean tPressed = false;
boolean spcPressed = false;

// Import background animation
int numFrames = 16;  // The number of frames in the animation
int currentFrame = 0;
PImage[] images = new PImage[numFrames];

void setup(){
  // Setup canvas and parameters
  size(1280,720);
  background(0,0,0);
  frameRate(60);
  pixel_art = createFont("pixel_art.ttf", 24);
  cambria = createFont("cambria.ttf", 24);

  // Setup character and boss objects
  character = new Character(width/2-100,height/2,6,4,35,100,100);
  bossOne = new Boss(width/2-100,height/8,1,130,1000,1000);

  // Load background images
  for (int i = 0; i < 16; i += 1){
    images[i] = loadImage("f"+i+".gif");
  }
  game_over = loadImage("game_over.png");
  logo = loadImage("logo2.png");
  winI = loadImage("win.png");
}

void draw(){
  background(0); // Clear screen (cls)

  // Play the animation
  currentFrame = (currentFrame+1) % numFrames;  // Use % to cycle through frames
  int offset = 0;
  for (int x = -100; x < width; x += images[0].width) { 
    image(images[(currentFrame+offset) % numFrames], x, 0);
    offset+=2;
  }

  // Set game over to true if character is dead
  if (character.isDead()) {
    gameOver = true;
  }
  // Set victory to true if boss is dead
  if (bossOne.isDead()) {
    win = true;
  }

  // Call method to summon character unless its dead
  if (!character.isDead()) summonCharacter(character);

  // Call method to summon boss unless its dead
  if (!bossOne.isDead() && gameStart) summonBoss(bossOne);
  
  // Add bullets to the ArrayList when z is pressed according to the delay per bullet
  if (zPressed && (millis() - lastShot) > bulletDelay){
    Bullet b = new Bullet(character.x + character.size/3, character.y -15,15,15);
    bullets.add(b);
    bulletsColl.add(new CollisionBox(b.x, b.y, b.radius,b.radius));
    lastShot = millis();
  }

  // Add a health ball to the ArrayList every x time
  hpballDelay = random(25000,35000);
  if (millis() - lasthpBall > hpballDelay && hpballs.isEmpty() && bossOne.stage() >= 2 && gameStart){
    float hp = random(20,40);
    HealthBall hpb = new HealthBall(random(0,width-150),random(0, height/2),2,50,random(25,30),hp,hp,random(15000,20000));
    hpballs.add(hpb);
  }

  // Call method to handle HP balls if ArrayList not empty
  if (!hpballs.isEmpty()) {handlehpBalls();}

  // Call method to handle character's bullets and pattern functions if ArrayList not empty
  if (!bullets.isEmpty()) {bulletStuff();}
  if (!pattern1.isEmpty()) {handlePattern(pattern1, pattern1Coll);}
  if (!pattern2.isEmpty()) {handlePattern(pattern2, pattern2Coll);}
  if (!pattern3.isEmpty()) {handlePattern(pattern3, pattern3Coll);}
  if (!pattern3Spiral.isEmpty()) {pattern3(pattern3Spiral, bossOne);}
  if (!pattern4Bomb.isEmpty()) {pattern4(pattern4Bomb);}
  if (!pattern4.isEmpty()) {handlePattern(pattern4, pattern4Coll);}
  if (!pattern5Shield.isEmpty()) {pattern5(pattern5Shield);}
  if (!pattern6.isEmpty()) {handlePattern(pattern6, pattern6Coll);}

  // Call method to display instructions, debug and FPS texts if needed
  if (!gameStart) {
    startText();
    tutoText();
  }
  if (tPressed) {debugText();}
  fps();

  // Call methods to trigger game over or victory screens if needed
  if(gameOver) {
    noLoop();
    gameOver();
  }
  if(win) {
    noLoop();
    image(winI, 350, 50, 600, 600);
  }
}

// Handle character
void summonCharacter(Character character){
  // Appear and move
  character.display();
  character.move();
  // Create own collision
  float sizeMult = -2;
  CollisionBox charCollision = new CollisionBox(character.x - (sizeMult/2), character.y - (sizeMult/2), character.size + sizeMult, character.size + sizeMult);
  charCollision.display();
  // Call method to handle character collision with boss bullets
  handleCharacterCollisions(charCollision, pattern1, pattern1Coll);
  handleCharacterCollisions(charCollision, pattern2, pattern2Coll);
  handleCharacterCollisions(charCollision, pattern3, pattern3Coll);
  handleCharacterCollisions(charCollision, pattern4, pattern4Coll);
  handleCharacterCollisions(charCollision, pattern6, pattern6Coll);
  // Handle collision with edges
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
  // Display health bar
  character.displayHP();
}

// Handle collisions between character and boss bullets
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
        character.hitAnim = true;
      }
      i.remove();
      j.remove();
    }
  }
}

// Handle boss
void summonBoss(Boss boss){
  // Appear and move
  boss.display();
  boss.move();
  // Create own collision
  float sizeMult = 5;
  CollisionBox bossCollision = new CollisionBox(boss.x - (sizeMult/2), boss.y - (sizeMult/2), boss.size + sizeMult, boss.size + sizeMult);
  bossCollision.display();
  // Handle collision with character bullets
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
  // Handle collision with edges
  if (bossCollision.xpos < 0) {
    boss.x = 0;
  }
  if (bossCollision.ypos < 0) {
    boss.y = 0;
  }
  if (bossCollision.xpos > width - boss.size) {
    boss.x = width - boss.size;
  }
  if (bossCollision.ypos > height - boss.size) {
    boss.y = height - boss.size;
  }
  // Check stage depending on HP
  if (boss.stage() == 1){delayMult=1.5;}
  if (boss.stage() == 2){delayMult=1;}
  if (boss.stage() == 3){delayMult=0.5;}

  // Summon patterns
  // Pattern 1 (full circle bullets)
  if(boss.stage() >= 1){
    p1Delay = random(800,1200)*delayMult;
    if ((millis() - lastP1) > p1Delay && !canP2){
      float[] p1colors = {random(100,256),random(100,256),random(100,256)};
      pattern1(boss,random(10,16),15*random(1,5),10*random(2,4),360,15*random(0,4),p1colors);
      lastP1 = millis();
    }
  }
  // Pattern 2 (bullet rain)
  if(boss.stage() >= 3){
    p2Duration = random(8000,14000)/delayMult;
    p2Delay = random(5000,11000)*delayMult;
    if (canP2 && (millis() - lastP2) > p2Duration) {
      canP2 = false;
      lastP2 = millis();
    }
    if (!canP2 && (millis() - lastP2) > p2Delay) {
      canP2 = true;
      lastP2 = millis();
      p2colors[0] = random(100,256);
      p2colors[1] = random(100,256);
      p2colors[2] = random(100,256);
    }
    if (canP2) {
      pattern2(random(10,16),10*random(2,4),random(50,100),p2colors);
    }
  }
  // Pattern 3 (bullet spirals)
  if(boss.stage() >= 1){
    p3Delay = random(3000,5000);
    if (p3Ended && !canP3 && (millis() - lastP3) > p3Delay) {
      canP3 = true;
      lastP3 = millis();
    }
    if(canP3) {
      float[] p3colors = {random(100,256),random(100,256),random(100,256)};
      Spiral spiral = new Spiral(boss.x+boss.size/2,boss.y+boss.size/2, random(10,16), 15*random(1,5), 10*random(2,4), 15*random(0,4), random(50,200), random(30,40), p3colors);
      pattern3Spiral.add(spiral);
      canP3 = false;
      p3Ended = false;
    }
  }
  // Pattern 4 (bombs)
  if(boss.stage() >= 2){
    p4Delay = random(2000,4000)*delayMult;
    if((millis() - lastP4) > p4Delay && !canP2){
      float[] p4colors = {random(100,256),random(100,256),random(100,256)};
      Bomb bomb = new Bomb(random(100,width-150),0,random(8,14),random(12,18),10*random(2,4),random(height/3,height-100),random(50,200),random(15,60),int(random(0,2)),p4colors);
      pattern4Bomb.add(bomb);
      lastP4 = millis();
    }
  }
  
  // Pattern 5 (shields)
  if(boss.stage() >= 3){
    p5Delay = random(70000,90000)*delayMult;
    if((millis() - lastP5) > p5Delay && !canP5){
      Shield shield1 = new Shield(boss.x - 200, boss.y, 3, 50, 50);
      Shield shield2 = new Shield(boss.x + 200, boss.y, 3, 50, 50);
      pattern5Shield.add(shield1);
      pattern5Shield.add(shield2);
      canP5 = true;
    }
    if (pattern5Shield.isEmpty()) {canP5 = false;}
  }
  // Display health bar
  boss.displayHP();
}

// Handle boss bullet patterns
// Pattern 1
void pattern1(Boss boss, float speed, float angleDiff, float size, float maxAngle, float startingAngle, float[] bullColor){
  for (int i = 0; i <= maxAngle/angleDiff; i = i + 1) {
    XBullet b = new XBullet(boss.x + boss.size/2, boss.y + boss.size/2,speed,speed,startingAngle + (angleDiff*i),size,20,bullColor);
    pattern1.add(b);
    pattern1Coll.add(new CollisionCircle(b.x + b.radius/2, b.y + b.radius/2, b.radius));
    
  }   
}

// Pattern 2
float p2IntDelay = millis();
void pattern2(float speed, float size, float delay, float[] bullColor){
 if ((millis() - p2IntDelay) > delay) {
    XBullet b = new XBullet(random(0,width),0,speed*-1,speed*-1,-90,size,0,bullColor);
    pattern2.add(b);
    pattern2Coll.add(new CollisionCircle(b.x + b.radius/2, b.y + b.radius/2, b.radius));
    p2IntDelay = millis();
  }
}

// Pattern 3
float p3IntDelay = millis();
void pattern3(ArrayList<Spiral> spirals, Boss boss){
  Iterator<Spiral> i = spirals.listIterator();
  while(i.hasNext()){
    Spiral spiral = i.next();
    spiral.x = boss.x + boss.size/2;
    spiral.y = boss.y + boss.size/2;
    spiral.draw();
    if (spiral.repetitions <= 0) {
      i.remove();
      p3Ended = true;
      lastP3 = millis();
    }
  }
}

// Pattern 4
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

// Pattern 5
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

// Handle displaying boss bullets contained in ArrayLists for each pattern
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

// Handle collisions between character bullets and shields
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

// Handle HP balls
void handlehpBalls(){
  Iterator<HealthBall> i = hpballs.listIterator();
  if (i.hasNext()){
    HealthBall hpb = i.next();
    CollisionCircle c = new CollisionCircle(hpb.x+hpb.size/2,hpb.y+hpb.size/2,hpb.size);
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

// Handle collisions between character bullets and HP balls
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

// Handle character bullets
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

// Show FPS counter (top left)
void fps() {
  textFont(cambria);
  textSize(20);
  fill(0,255,0);
  float roundedfps = (round(frameRate * 1000));
  text(str(roundedfps/1000),25,25);
}

// Display start game text
void startText(){
  textFont(pixel_art);
  textSize(60);
  fill(31,131,19);
  image(logo, 400, -135, 600, 600);
  textSize(20);
  fill(34,103,14);
  text(">>>Press enter to start the game<<<",width/2-270,height-100);
}

// Display tutorial text
void tutoText(){
  textFont(pixel_art);
  textSize(15);
  fill(82,182,68);
  text("Move with arrows",width/2-400,height/2+20);
  fill(115,198,103);
  text("Press z to shoot",width/2-400,height/2+40);
  fill(149,212,140);
  text("Press x to focus",width/2-400,height/2+60);
  fill(183,226,177);
  text("Press space to pause",width/2-400,height/2+80);
}

// Display DEBUG collisions text
void debugText(){
  textFont(cambria);
  textSize(15);
  fill(255,0,0);
  text("DEBUG COLLISIONS",width-150,30);
}

// Display game over text
void gameOver(){
  image(game_over, 325, 125, 640, 360);
}

// Handle key presses
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
  if (key == 'z' || key == 'Z') {
    zPressed = true;
  }
  if (key == 'x' || key == 'X') {
    xPressed = true;
  }
  if (key == 't' || key == 'T') {
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
      textFont(pixel_art);
      textSize(30);
      fill(255,0,50);
      text("> PAUSE <",width/2-100,30);
    }
  }
  if (!gameStart && key == ENTER) {
    gameStart = true;
    lastP1 = lastP2 = lastP3 = lastP4 = lastP5 = millis();
  }
}
// Handle key releases
void keyReleased () {
  if (keyCode == LEFT) {
    aPressed = false;
  } else if (keyCode == RIGHT) {
    dPressed = false;
  } else if (keyCode == UP) {
    wPressed = false;
  } else if (keyCode == DOWN) {
    sPressed = false;
  }
  if (key == 'z' || key == 'Z') {
    zPressed = false;
  }
  if (key == 'x' || key == 'X') {
    xPressed = false;
  }
}