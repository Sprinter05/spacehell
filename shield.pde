class Shield {
    float x;
    float y;
    float speed;
    float maxHealth;
    float health;
    float sizeX = 40;
    float sizeY = 80;
    int healthDelay = 0;
    int lastDamage = millis();
    int animDelay = 150;
    int lastAnim = millis();

    Shield(float x, float y, float speed, float maxHealth, float health){
        this.x = x;
        this.y = y;
        this.speed = speed;
        this.maxHealth = maxHealth;
        this.health = health;
    }

    boolean isDead(){
        if (health <= 0) return true;
        return false;
    }

    void draw(){
        fill(200,200,200);
        strokeWeight(0);
        stroke(0,0,0);
        rect(x,y,sizeX,sizeY);
        fill(190,150,215);
        rect(x+sizeX/4,y+sizeY/4,sizeX/2,sizeY/2);
    }

    void update(){
        //Animation thingy
        if ((millis() - lastAnim) > animDelay){
            x += random(-1,1);
            y += random(-1,1);
            lastAnim = millis();
        }
    }

    void displayHP(){
        float hbcd = maxHealth / 66.6;
        strokeWeight(3);
        stroke(250, 250, 250);
        fill(255, 255, 255);
        rect(x - sizeX/3, y + sizeY*1.2, maxHealth / hbcd, 10, 20);
        stroke(250, 250, 250);
        fill(140, 100, 0);
        rect(x - sizeX/3, y + sizeY*1.2, health / hbcd, 10, 20);
    }
}