class CollisionBox {
    float xpos;
    float ypos;
    float wid;
    float hei;

    CollisionBox(float xpos, float ypos, float wid, float hei){
        this.xpos = xpos;
        this.ypos = ypos;
        this.wid = wid;
        this.hei = hei;
    }

    // Displays the collision box is DEBUG enabled (t key)
    void display(){
        if (tPressed){
            strokeWeight(3);
            stroke(255,0,0,255);
        } else {
            strokeWeight(0);
            stroke(255,0,0,0);            
        }
        fill(255,255,255,0);        
        rect(xpos, ypos, wid, hei);
    }
}