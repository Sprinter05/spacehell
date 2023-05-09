class Character {
    float x;
    float y;
    float xspeed;
    float yspeed;
    float size;
    float maxHealth;
    float health;
    int healthDelay = 100;
    int lastDamage = millis();
    int animDelay = 150;
    int lastAnim = millis();
    PImage sprite = loadImage("nave.png");

    Character(float x, float y, float xspeed, float yspeed, float size, float maxHealth, float health) {
        this.x = x;
        this.y = y;
        this.xspeed = xspeed;
        this.yspeed = yspeed;
        this.size = size;
        this.maxHealth = maxHealth;
        this.health = health;
    }

    void display(){
        fill(0,0,0);
        strokeWeight(0);
        stroke(0,0,0);
        image(sprite,x,y,size,size);
    }
    void move(){
        float currx = x;
        float curry = y;
        if (aPressed){
            x -= xspeed;
        }
        if (dPressed){
            x += xspeed;
        }
        if (wPressed){
            y -= yspeed;
        }
        if (sPressed){
            y += yspeed;
        }
        //Animation thingy
        if (x == currx && y == curry && (millis() - lastAnim) > animDelay){
            x += random(-1,1);
            y += random(-1,1);
            lastAnim = millis();
        }
    }

    boolean isDead(){
        if (health <= 0) return true;
        return false;
    }

    void displayHP(){
        strokeWeight(3);
        stroke(250, 250, 250);
        fill(255, 255, 255);
        rect(character.x - 10, character.y + 55, maxHealth / 1.5, 10, 20);
        stroke(250, 250, 250);
        fill(0, 255, 0);
        rect(character.x - 10, character.y + 55, health / 1.5, 10, 20);
    }
}