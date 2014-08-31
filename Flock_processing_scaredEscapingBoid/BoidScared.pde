// The Boid class

class BoidScared {

  int     id;
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  Predator predator;
  boolean hasSeenPredator = false;

    BoidScared(float x, float y, int _id) {
    id = _id;
    acceleration = new PVector(0, 0);

    // This is a new PVector method not yet implemented in JS
    // velocity = PVector.random2D();

    // Leaving the code temporarily this way so that this example runs in JS
    float angle = boidStartAngle;//random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));

    location = new PVector(x, y);
    r = boidRadius;//2.0;
    //original
    //maxspeed = 2;
    //maxforce = 0.03;
    //BB-MOD
    //print("boidMaxSpeed: " + boidMaxSpeed +"\n");
    maxspeed = boidMaxSpeed;
    maxforce = boidMaxForce;
  }

  void run(ArrayList<BoidScared> boids) {
    flock(boids);
    update();
    borders();
    render();
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<BoidScared> boids/*, Predator predator*/) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    //println(id + " hasSeenPredator: " + hasSeenPredator); 
    //hasSeenPredator();
    //if(hasSeenPredator == true) {PVector esc = escape(); }
    //*
    if(hasSeenPredator() == true) {
        PVector esc = escape(); 
        //println(id + " CALCULATING PREDATOR  esc: " + esc);
        esc.mult(boidEscapeWeight);
        applyForce(esc);
      }
    //*/
    //hasSeenPredator();
    //Boolean pHit = isWithinPredatorInfluece();//(/*this.predator*/);
    /* Arbitrarily weight these forces
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    */
    sep.mult(boidSeparationWeight); //1.5
    ali.mult(boidAlignWeight);      //1.0
    coh.mult(boidCohesionWeight);   //1.0
    //if(hasSeenPredator == true) { esc.mult(boidEscapeWeight); }
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
    //if(hasSeenPredator == true) { applyForce(esc); }
    
  }

  //////////////////////////// PREDATOR AWARENESS //////////////////
  
   Boolean isWithinPredatorInfluece(/*Predator p*/) {
     float minDist = r/2 + predator.influceRadius/2;
     float distance = location.dist(predator.location);
     //println("minDist: " + minDist + "  predator.influceRadius: " + predator.influceRadius);
     if ( distance < minDist ) {
       return true;
     } else {
       return false;
     }
     
     /* HIT TEST THAT WORKS only on the Bounding BOX
     Predator p = predator;
     //print (id + " location.x: " + location.x + "  -  influceRadius: " + influceRadius + "\n");
     if ( (location.x > p.location.x - (p.influceRadius/2)) && (location.y < p.location.y + (p.influceRadius/2) )) {
       //print (id + " - HIT \n");
       return true; 
     } 
     return false;
     */
     
   }
   
    Boolean hasSeenPredator () {
     if(isWithinPredatorInfluece() == true ) {
       float randSeen = random(0,1);
       //print ("randSeen: " + randSeen);
       // boidBlindness is defined in the main pde it defines the threshold below wich it will see the predator
       if (randSeen >= boidBlindness) {
         hasSeenPredator = true;
         //println(id + "OJO HAY DEPREDADOR - randSeen: " + randSeen + "  hasSeenPredator: " + hasSeenPredator);
         return true;
       }
       return false;
     } 
     //is again outside of predator's influence
     hasSeenPredator = false;
     return false;
   }

    // Separation
  // Method checks for nearby boids and steers away
  PVector escape () {
    //float desiredseparation = 25.0f;
    // BB-MOD
    float desiredseparation = boidDesiredSeparation;
    PVector steer = new PVector(0, 0, 0);
    
    // Calculate vector pointing away from the Predator
    float d = PVector.dist(location, predator.location);
    PVector diff = PVector.sub(location, predator.location);
    diff.normalize();
    diff.div(d);        // Weight by distance
    steer.add(diff);
    
    /*int count = 0;
    For every boid in the system, check if it's too close
    for (BoidScared other : boids) {
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }
    */

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }
  
  
  ////////////////////////////////////////////////////////////////////

  // Method to update location
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  


  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);

    // Above two lines of code below could be condensed with new PVector setMag() method
    // Not using this method until Processing.js catches up
    // desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    
    if (hasSeenPredator == true) {
      fill(135, 0, 29);
    } else {
      fill(200, 100);
      //stroke(255);
    }
    noStroke();
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }

  // Wraparound
  void borders() {
    if(bordersLoop == true) {
      if (location.x < -r) location.x = width+r;
      if (location.y < -r) location.y = height+r;
      if (location.x > width+r) location.x = -r;
      if (location.y > height+r) location.y = -r;
    }  
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<BoidScared> boids) {
    //float desiredseparation = 25.0f;
    // BB-MOD
    float desiredseparation = boidDesiredSeparation;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (BoidScared other : boids) {
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<BoidScared> boids) {
    //float neighbordist = 50;
    //BB-MOD
    float neighbordist = boidNeigborDist;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (BoidScared other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // sum.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  PVector cohesion (ArrayList<BoidScared> boids) {
    //float neighbordist = 50;
    //BB-MOD
    float neighbordist = boidNeigborDist;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (BoidScared other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.location); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the location
    } 
    else {
      return new PVector(0, 0);
    }
  }
}
