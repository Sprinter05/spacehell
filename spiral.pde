class Spiral {
    float x;
    float y;
    float speed;
    float angDiff;
    float size;
    float startAng;
    float delay;
    float repetitions;
    float[] bullColor;
    int lastLoop = 0;
    float lastDelay = millis();

    Spiral(float x, float y, float speed, float angDiff, float size, float startAng, float delay, float repetitions, float[] bullColor){
        this.x = x;
        this.y = y;
        this.speed = speed;
        this.angDiff = angDiff;
        this.size = size;
        this.startAng = startAng;
        this.delay = delay;
        this.repetitions = repetitions;
        this.bullColor = bullColor;
    }

    // Spawns the bullets when the spiral pattern is triggered
    void draw(){
        if (((millis() - lastDelay) > delay) && repetitions > 0) {
            XBullet b = new XBullet(x,y,speed,speed,startAng+(angDiff*lastLoop),size,20,bullColor);
            pattern3.add(b);
            pattern3Coll.add(new CollisionCircle(b.x, b.y, b.radius));
            lastDelay = millis();
            lastLoop += 1;
            repetitions -= 1;
        }
    }
}
