class Character {
    float x;
    float y;
    float xspeed;
    float yspeed;
    float size;
    int health;
    int healthDelay = 100;
    int lastDamage = millis();

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
        square(x,y,size);
    }
    void move(){
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
    }

    boolean isDead(){
        if (health <= 0) return true;
        return false;
    }
}