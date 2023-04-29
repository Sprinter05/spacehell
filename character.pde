class Character {
    float x;
    float y;
    float xspeed;
    float yspeed;

    Character(float x, float y, float xspeed, float yspeed) {
        this.x = x;
        this.y = y;
        this.xspeed = xspeed;
        this.yspeed = yspeed;
    }

    void display(){
        fill(0,0,0);
        stroke(0,0,0);
        square(x,y,20);
    }
    void move(){
        if (aPressed){
            x -= xspeed;
        }
        if (dPressed){
            x += xspeed;
        }
        if (wPressed){
            y -= yspeed;
        }
        if (sPressed){
            y += yspeed;
        }
    }
}