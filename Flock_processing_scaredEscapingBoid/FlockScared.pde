// The Flock (a list of Boid objects)
class FlockScared {
  ArrayList<BoidScared> boids; // An ArrayList for all the boids

  FlockScared() {
    boids = new ArrayList<BoidScared>(); // Initialize the ArrayList
  }

  
  void run() {
    int nBoids=1;
    for (BoidScared b : boids) {
      b.run(boids);  // Passing the entire list of boids to each boid individually
      if (b.isWithinPredatorInfluece() == true) {
         //println("*****************FlockScared.run > isWithin...");
         //printTrace(b,cycles,nBoids);
         printTrace(b,cycles);
         log.write("\n");
      }
      //nBoids++;
      
    }
  }
  
  /* original
  void run() {
    for (BoidScared b : boids) {
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
  }
  */

  void addBoid(BoidScared b) {
    boids.add(b);
  }

}
