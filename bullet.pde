class Bullet {
    float x;
    float y;
    float yspeed;
    float radius;

    Bullet(float x, float y, float yspeed, float radius){
        this.x = x;
        this.y = y;
        this.yspeed = yspeed;
        this.radius = radius;
    }

    boolean update() {
        y-=yspeed;
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