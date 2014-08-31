class Predator {
     PVector location;
     float size = predatorSize;
     float influceRadius = predatorInfluenceRadius;
     
     Predator (float x, float y) {
       location = new PVector(x, y);
     }
     
     void run () {
       render();
     }
     
     void render() {
       //print("rendering Predator");
       // Draw the predator's influence radius
       fill(255, 100, 100);
       noStroke();
       ellipseMode(CENTER);
       ellipse(location.x, location.y, influceRadius, influceRadius);
       
       // Draw the predator - red
       fill(255, 0, 0);
       noStroke();
       ellipseMode(CENTER);
       ellipse(location.x, location.y, size, size);
       
       
     }
}
