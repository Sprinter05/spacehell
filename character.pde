class Character {
    float x;
    float y;
    float xspeed;
    float yspeed;
    float size;
    int health;
    int healthDelay = 100;
    int lastDamage = millis();
    int animDelay = 150;
    int lastAnim = millis();
    PImage sprite = loadImage("nave.png");

    Character(float x, float y, float xspeed, float yspeed, float size, int health) {
        this.x = x;
        this.y = y;
        this.xspeed = xspeed;
        this.yspeed = yspeed;
        this.size = size;
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
        textFont(cambria);
        textSize(20);
        fill(255,0,0);
        text(str(health),width-50, 20);
    }
}