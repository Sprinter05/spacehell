class Bullet {
    float x;
    float y;
    float yspeed;

    Bullet(float x, float y, float yspeed){
        this.x = x;
        this.y = y;
        this.yspeed = yspeed;
    }

    boolean update() {
        y-=yspeed;
        if (x >= width + 5 || x<= -5) return true;
        return false;
    }
  
    void draw() {
        fill(255,0,0);
        stroke(255,0,0);
        ellipse(x,y,5,5);
    }
}