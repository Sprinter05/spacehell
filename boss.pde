class Boss {
    float x;
    float y;
    float size;
    int health;
    int healthDelay = 0;
    int lastDamage = millis();

    Boss(float x, float y, float size, int health) {
        this.x = x;
        this.y = y;
        this.size = size;
        this.health = health;
    }

    void display(){
        fill(160,30,240);
        strokeWeight(0);
        stroke(0,0,0);
        square(x,y,size);
    }

    boolean isDead(){
        if (health <= 0) return true;
        return false;
    }
}