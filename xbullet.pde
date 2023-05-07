class XBullet {
    float x;
    float y;
    float xspeed;
    float yspeed;
    float angle;
    float radius;

    XBullet(float x, float y, float xspeed, float yspeed, float angle, float radius){
        this.x = x;
        this.y = y;
        this.xspeed = xspeed;
        this.yspeed = yspeed;
        this.angle = angle;
        this.radius = radius;
    }

    boolean update() {
        x += cos(angle)*xspeed;
        y += sin(angle)*yspeed;
        if (y >= height + 5 || y <= -5) return true;
        return false;
    }
  
    void draw() {
        fill(255,0,0);
        strokeWeight(0);
        stroke(255,255,0);
        ellipse(x,y,radius,radius);
    }
}