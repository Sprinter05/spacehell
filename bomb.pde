class Bomb {
    float x;
    float y;
    float speed;
    float bspeed;
    float size;
    float triggerY;
    float delay;
    float repetitions;
    int rotated;
    float[] bullColor;
    PImage sprite = loadImage("bomb.png");

    Bomb(float x, float y, float speed, float bspeed, float size, float triggerY, float delay, float repetitions, int rotated, float[] bullColor){
        this.x = x;
        this.y = y;
        this.speed = speed;
        this.bspeed = bspeed;
        this.size = size;
        this.triggerY = triggerY;
        this.delay = delay;
        this.repetitions = repetitions;
        this.rotated = rotated;
        this.bullColor = bullColor;
    }

    // Returns whether the bomb has reached enough height to blow up
    boolean canTrigger(){
        if (y >= triggerY){
            return true;
        }
        return false;
    }

    // Moves the bomb down
    void update(){
        y+= speed;
    }

    // Blows up the bomb and spawns the bullets
    void triggerBomb(){
        for (int i = 0; i < 4; i++) {
            float startAng;
            if (rotated == 0) {startAng = 0;}
            else {startAng = 45;}
            XBullet b = new XBullet(x-size/2,y-size/2,bspeed,bspeed,startAng+90*i,size,20,bullColor);
            pattern4.add(b);
            pattern4Coll.add(new CollisionCircle(b.x + b.radius/2, b.y + b.radius/2, b.radius));
            repetitions -= 1;
        }
    }

    // Draws the bomb
    void draw(){
        fill(255,255,255);
        strokeWeight(0);
        stroke(255,255,0);
        if (rotated==1) {
            pushMatrix();
            translate(x, y);
            rotate(radians(45));
            image(sprite, 0, 0, 40, 40);
            popMatrix();
        } else {
            image(sprite,x,y,40,40);
        }   
    }
}