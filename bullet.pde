class Bullet {
    float x;
    float y;
    float yspeed;
    float radius;
    PImage sprite = loadImage("bullet.png");

    // Character bullets
    Bullet(float x, float y, float yspeed, float radius){
        this.x = x;
        this.y = y;
        this.yspeed = yspeed;
        this.radius = radius;
    }

    // Moves the bullet up and returns true when it goes out of bounds
    boolean update() {
        y-=yspeed;
        if (y >= height + 5 || y <= -5) return true;
        return false;
    }
  
    // Draws the bullet
    void draw() {
        fill(255,0,0);
        strokeWeight(0);
        stroke(255,255,0);
        image(sprite,x,y,radius,radius);
    }
}