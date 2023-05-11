class Character {
    float x;
    float y;
    float speed;
    float concSpeed;
    float size;
    float maxHealth;
    float health;
    float hbcd;
    int healthDelay = 50;
    int lastDamage = millis();
    int animDelay = 150;
    int lastAnim = millis();
    PImage sprite = loadImage("nave.png");

    Character(float x, float y, float speed, float concSpeed, float size, float maxHealth, float health) {
        this.x = x;
        this.y = y;
        this.speed = speed;
        this.concSpeed = concSpeed;
        this.size = size;
        this.maxHealth = maxHealth;
        this.health = health;
    }

    void display(){
        fill(0,0,0);
        strokeWeight(0);
        stroke(0,0,0);
        image(sprite,x,y,size,size);
        if (xPressed) { //concentration mode
            fill(0,0,0,0);
            strokeWeight(2);
            stroke(0,0,255);
            ellipse(x+size/2, y+size/2, size, size);
        }
    }

    void move(){
        float speedtoUse;
        if (xPressed){
            speedtoUse = concSpeed;
        } else {
            speedtoUse = speed;
        }
        float currx = x;
        float curry = y;
        if (aPressed){
            x -= speedtoUse;
        }
        if (dPressed){
            x += speedtoUse;
        }
        if (wPressed){
            y -= speedtoUse;
        }
        if (sPressed){
            y += speedtoUse;
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
        float hbcd = maxHealth / 66.6;
        strokeWeight(3);
        stroke(250, 250, 250);
        fill(255, 255, 255);
        rect(character.x - 12, character.y + 55, maxHealth / hbcd, 10, 20);
        stroke(250, 250, 250);
        fill(0, 255, 0);
        rect(character.x - 12, character.y + 55, health / hbcd, 10, 20);
    }
}