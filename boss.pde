class Boss {
    float x;
    float y;
    float speed;
    float size;
    float maxHealth;
    float health;
    int healthDelay = 20;
    int lastDamage = millis();
    int moveDelay = 200;
    int lastMove = millis();
    float factor = 1;
    PImage sprite1 = loadImage("Boss1.png");
    PImage sprite2 = loadImage("Boss2.png");

    Boss(float x, float y, float speed, float size, float maxHealth, float health) {
        this.x = x;
        this.y = y;
        this.speed = speed;
        this.size = size;
        this.maxHealth = maxHealth;
        this.health = health;
    }

    // Draws the boss
    void display(){
        PImage sprite;
        if (stage() >= 1 && stage() < 3) {sprite = sprite1;}
        else {sprite = sprite2;}
        fill(160,30,240);
        strokeWeight(0);
        stroke(0,0,0);
        image(sprite,x,y,size,size);
    }

    // Moves randomly around the top part of the screen
    void move(){
        if (factor == 1) {factor = -1;}
        else {factor = 1;}
        if ((millis() - lastMove) > moveDelay){
            x += factor*speed*random(1,3);
            y += factor*speed*random(1,3);
            lastMove = millis();
        }
    }

    // Returns the stage the boss is at based on its health
    int stage(){
        if (health >= (maxHealth*2)/3 && health <= maxHealth){return 1;}
        else if (health >= maxHealth/3 && health < (maxHealth*2)/3){return 2;}
        else if (health >= 0 && health < maxHealth/3){return 3;}
        else return 0;
    }

    // Returns whether the boss is dead or not
    boolean isDead(){
        if (health <= 0) return true;
        return false;
    }

    // Displays the boss' health bar
    void displayHP(){
        float hbbd = maxHealth / 650;
        strokeWeight(3);
        fill(255,255,255);
        stroke(255, 255, 255);
        rect(1200, 700, 20, -maxHealth / hbbd, 20);
        if (pattern5Shield.isEmpty()) {fill(160,30,240);}
        else {fill(55,55,55);}
        stroke(255, 255, 255);
        rect(1200, 700, 20, -health / hbbd, 20);
    }
}