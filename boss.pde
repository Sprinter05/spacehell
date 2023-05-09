class Boss {
    float x;
    float y;
    float size;
    float maxHealth;
    float health;
    int healthDelay = 0;
    int lastDamage = millis();
    int bulletDelay = 50;
    int lastShot = millis();

    Boss(float x, float y, float size, float maxHealth, float health) {
        this.x = x;
        this.y = y;
        this.size = size;
        this.maxHealth = maxHealth;
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

    void displayHP(){
        fill(160,30,240);
        strokeWeight(5);
        stroke(255, 255, 255);
        rect(1200, 700, 20, -health * 3.2, 20);
    }
}