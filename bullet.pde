class Bullet {
    float x;
    float y;
    float yspeed;
    float radius;
    PImage sprite = loadImage("bullet.png");

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
        image(sprite,x,y,radius,radius);
    }
}