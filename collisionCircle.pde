class CollisionCircle {
    float xpos;
    float ypos;
    float radius;

    CollisionCircle(float xpos, float ypos, float radius){
        this.xpos = xpos;
        this.ypos = ypos;
        this.radius = radius;
    }

    //DEBUG collisons with t key
    void display(){
        if (tPressed){
            strokeWeight(3);
            stroke(255,0,0,255);
        } else {
            strokeWeight(0);
            stroke(255,0,0,0);            
        }
        fill(255,255,255,0);        
        ellipse(xpos, ypos, radius, radius);
    }

}