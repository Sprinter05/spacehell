class XBullet {
    float x;
    float y;
    float xspeed;
    float yspeed;
    float angle;
    float radius;
    float delay;
    float lastDelay = millis();
    float[] bullColor;
    PImage sprite = loadImage("bossBullet.png");

    XBullet(float x, float y, float xspeed, float yspeed, float angle, float radius, float delay, float[] bullColor){
        this.x = x;
        this.y = y;
        this.xspeed = xspeed;
        this.yspeed = yspeed;
        this.angle = angle;
        this.radius = radius;
        this.delay = delay;
        this.bullColor = bullColor;
    }

    boolean update() {
        x += cos(radians(angle))*xspeed;
        y += sin(radians(angle))*yspeed;
        if (y >= height + 5 || y <= -5 || x >= width + 5 || x <= -5) return true;
        return false;
    }
  
    void draw() {
        if(millis() - lastDelay > delay) {
            fill(0,0,0);
            strokeWeight(0);
            stroke(255,255,0);
            tint(bullColor[0],bullColor[1],bullColor[2]);
            image(sprite,x,y,radius,radius);
            noTint();
        }
    }
}