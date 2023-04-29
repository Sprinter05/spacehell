import java.util.*;

PFont cambria;

Character character;

ArrayList<Bullet> bullets = new ArrayList<Bullet>();
int bulletDelay = 50;
int lastShot = millis();

boolean wPressed = false;
boolean dPressed = false;
boolean sPressed = false;
boolean aPressed = false;
boolean zPressed = false;

void setup(){
    size(1280,720);
    background(255,255,255);
    cambria = createFont("cambria.ttf", 24);

    character = new Character(150,150,6,6);
}
void draw(){
    //fps counter
    background(255,255,255);
    textFont(cambria);
    textSize(20);
    fill(0,255,0);
    text(str(frameRate),25,25);

    //placeholder character
    character.display();
    character.move();

    //haha funny
    if (zPressed && (millis() - lastShot) > bulletDelay){
        bullets.add(new Bullet(character.x +10, character.y -15, 15));
        lastShot = millis();
    }
    bulletStuff();
}

void bulletStuff() {
  Iterator<Bullet> i = bullets.listIterator();
  while (i.hasNext()) {
    Bullet b = i.next();
    b.draw();
    if (b.update()) i.remove();
  }
}

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