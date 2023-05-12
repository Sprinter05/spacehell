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

    Boss(float x, float y, float speed, float size, float maxHealth, float health) {
        this.x = x;
        this.y = y;
        this.speed = speed;
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

    void move(){
        if (factor == 1) {factor = -1;}
        else {factor = 1;}
        if ((millis() - lastMove) > moveDelay){
            x += factor*speed*random(1,3);
            y += factor*speed*random(1,3);
            lastMove = millis();
        }
    }

    int stage(){
        if (health >= (maxHealth*2)/3 && health <= maxHealth){return 1;}
        else if (health >= maxHealth/3 && health < (maxHealth*2)/3){return 2;}
        else if (health >= 0 && health < maxHealth/3){return 3;}
        else return 0;
    }

    boolean isDead(){
        if (health <= 0) return true;
        return false;
    }

    void displayHP(){
        float hbbd = maxHealth / 650;
        strokeWeight(3);
        fill(255,255,255);
        stroke(255, 255, 255);
        rect(1200, 700, 20, -maxHealth / hbbd, 20);
        if (pattern5Shield.isEmpty()) {fill(160,30,240);}
        else {fill(200,200,200);}
        stroke(255, 255, 255);
        rect(1200, 700, 20, -health / hbbd, 20);
    }
}