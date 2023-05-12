class HealthBall {
    float x;
    float y;
    float speed;
    float size;
    float hpRecover;
    float health;
    float maxHealth;
    float disappearAfter;
    int healthDelay = 50;
    int lastDamage = millis();
    float spawnTime = millis();
    int moveDelay = 50;
    int lastMove = millis();
    PImage sprite = loadImage("hpBall.png");

    HealthBall(float x, float y, float speed, float size, float hpRecover, float health, float maxHealth, float disappearAfter){
        this.x = x;
        this.y = y;
        this.speed = speed;
        this.size = size;
        this.hpRecover = hpRecover;
        this.health = health;
        this.maxHealth = maxHealth;
        this.disappearAfter = disappearAfter;
    }

    void display(){
        fill(0,200,0);
        strokeWeight(0);
        stroke(0,0,0);
        tint(255,map(health,0,maxHealth,50,255),255);
        image(sprite,x,y,size,size);
        noTint();
    }

    void move(){
        if ((millis() - lastMove) > moveDelay){
            x += random(-1,2)*speed;
            y += random(-1,2)*speed;
            lastMove = millis();
        }
    }

    boolean isDespawned(){
        if (millis() - spawnTime > disappearAfter){
            return true;
        }
        return false;
    }

    boolean isDead(){
        if (health <= 0) return true;
        return false;
    }
}