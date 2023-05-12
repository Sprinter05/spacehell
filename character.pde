class Character {
    float x;
    float y;
    float speed;
    float concSpeed;
    float size;
    float maxHealth;
    float health;
    int healthDelay = 100;
    int lastDamage = millis();
    int animDelay = 150;
    int lastAnim = millis();
    boolean hitAnim = false;
    float hitAnimDelay = 500;
    float lasthitAnim = millis();
    float rotateConc = 0;
    PImage sprite = loadImage("nave.png");
    PImage concSprite = loadImage("focus.png");

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
        if (xPressed) { //concentration mode
            rotateConc += 1;
            fill(0,0,0,0);
            strokeWeight(2);
            stroke(0,0,255);
            imageMode(CENTER);
            pushMatrix();
            translate(x+size/2, y+size/2);
            rotate(radians(rotateConc));
            image(concSprite, 0, 0, size*1.5, size*1.5);
            popMatrix();
            imageMode(CORNER);
        }
        fill(0,0,0);
        strokeWeight(0);
        stroke(0,0,0);
        if (hitAnim) {
            tint(255,0,0);
            image(sprite,x,y,size,size);
            hitAnim = false;
        } else {
            noTint();
            image(sprite,x,y,size,size);
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
            x += random(-1,2);
            y += random(-1,2);
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
        rect(x - size/3, y + size*1.2, maxHealth / hbcd, 10, 20);
        stroke(250, 250, 250);
        fill(0, 255, 0);
        rect(x - size/3, y + size*1.2, health / hbcd, 10, 20);
    }
}