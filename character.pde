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

    // Draws the character
    void display(){
        if (xPressed) { // show the focus mode sprite
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
        image(sprite,x,y,size,size);
    }

    // Moves the character when arrow keys are pressed and changes speed if focus mode is on
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
        //Move a bit around the screen to give an "im in space" effect.
        if (x == currx && y == curry && (millis() - lastAnim) > animDelay){
            x += random(-1,2);
            y += random(-1,2);
            lastAnim = millis();
        }
    }

    // Returns whether the character is dead or not
    boolean isDead(){
        if (health <= 0) return true;
        return false;
    }

    // Displays the character's health bar
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