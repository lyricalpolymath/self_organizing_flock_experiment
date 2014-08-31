/**
*  this is a flocking experiment built on 2014.08.30 for the berrocal.net festum of self-organization
*  Code by Beltran Berrocal and José M Bernal
*  other team members: Juanjo Valderrama and Antonio Matas
*  this flocking algorithm is a modified version of the Flocking example by Daniel Shiffman
*  http://processing.org/examples/flocking.html 
*
*  The aim is to gather data on the behavior of flocking birds who will have to escape a preador
*  in order to see how fast the decision is propagated in a group 
*  and where's the critical point of phase transition in the decision making process.
*  The data is exported to a txt in the same folder of the running code after "maxCycles",
*  to be later analyzed by an R script by Antonio Matas.
*
*  other studies in COMPLEXITY AND EMERGENCE http://cmuems.com/2013/b/complexity-and-emergence/
*  
*/

Flock flock;
FlockScared flockScared;
Predator predator;
Log log;

// ---------- VARIABLES ---------------
int screenW = 1000;
int screenH = 640;
boolean bordersLoop = false; // true = comportamiento inicial > se materializan al otro lado de la pantalla, false = desaparecen

float predatorSize = 50;
float predatorInfluenceRadius = 600;
float predatorStartX = screenW-predatorSize; 
float predatorStartY = predatorSize;

int numBoids =  500;                 // orig 150
float boidRadius = 2.0;                  // orig 2.0
int boidStartX = 500;//int(predatorStartX - predatorInfluenceRadius/2 -50);//50; 
int boidStartY = screenH/4;            // orig 50
int boidStartAngle = 270;              // orig random(TWO_PI) > define la direccion inicial
int boidMaxSpeed = 2;                  // orig 2
float boidMaxForce = 0.03;             // orig: 0.03
float boidDesiredSeparation = 25.0f;   // orig: 25.0f  // SEPARACION
float boidNeigborDist = 100;           // orig: 50 // ALINEAZION + COHESION
float boidSeparationWeight = 1.5;      //1.5    // peso arbitrario del comportamiento de Separacion
float boidAlignWeight = 1.0;           //1.0    // peso arbitrario del comportamiento de Alineacion
float boidCohesionWeight = 1.0;        //1.0    // peso arbitrario del comportamiento de Cohesion
float boidEscapeWeight = 10;          //new    // peso arbitrario del comportamiento de Huida
float boidBlindness = 0.90;            // 0 = vision perfecta >> 1 = ciego (representa sensibilidad del random cuando vee el 
String NORMAL_BOID = "normal";
String SCARED_BOID = "scared";
String boidKind = SCARED_BOID;

int cycles = 1;
int maxCycles = 400;                  // ACHTUNG importante añadir en funcion de distancia inicial

  

void setup() {
  size(screenW, screenH);
  predator = new Predator(predatorStartX, predatorStartY);
  
  log = new Log("../Flock_Data/FlockData_"+numBoids+".txt");
  log.write("Iteracion;nBoids;Boid;Location X;Location Y;Velocity X; Velocity Y;Acceleration X; Acceleration Y"+"\n");
  
  ///*
  if (boidKind == SCARED_BOID ){
      flockScared = new FlockScared();
      // Add an initial set of boids into the system
      for (int i = 0; i < numBoids; i++) {
        BoidScared b = new BoidScared(boidStartX,boidStartY, i);
        b.predator = predator;
        flockScared.addBoid(b);
      }
  } else if (boidKind == NORMAL_BOID) {
      flock = new Flock();
      // Add an initial set of boids into the system
      for (int i = 0; i < numBoids; i++) {
        flock.addBoid(new Boid(boidStartX,boidStartY));
      }      
  } 
  //*/
  
}

void draw() {
  background(50);
  predator.run();
  if (boidKind == SCARED_BOID ){
      flockScared.run();
  } else if (boidKind == NORMAL_BOID) {
      flock.run(); 
  }
  // Controlamos el número de ciclos que ejecutamos la aplicación.
  if (cycles >= maxCycles){
    log.close();
    exit();
  }
  cycles ++;
}

// Add a new boid into the System
void mousePressed() {
  flock.addBoid(new Boid(mouseX,mouseY));
}

void printTrace(BoidScared b, int cycle){
      log.write(str(cycle));
      log.write(";");
      log.write(str(numBoids));
      log.write(";");
      log.write(str(b.id));
      log.write(";");
      log.write(str(b.location.x));
      log.write(";");
      log.write(str(b.location.y));
      log.write(";");
      log.write(str(b.velocity.x));
      log.write(";");
      log.write(str(b.velocity.y));
      log.write(";");
      log.write(str(b.acceleration.x));
      log.write(";");
      log.write(str(b.acceleration.y));   
}



