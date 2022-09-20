import oscP5.*;
import netP5.*;
OscP5 oscP5 = new OscP5(this, 1234);
NetAddress aqui = new NetAddress("127.0.0.1", 4321);

Noise noise = new Noise();
Population population;
ArrayList<Population> world = new ArrayList<Population>();
ArrayList <Plant> plants = new ArrayList <Plant>(); //population of plants
int Nfoods = 50; //number of plants when initialized
int Nblobs = 25; //same as plants, but for blobs
PImage noiseImage;


//plant and blob population are initialized in setup
void setup() {
  size (2560, 1440);
  surface.setResizable(true);
  surface.setSize(1300, 700);
  frameRate(60);
  noiseImage = noise.generateImage();
  OscMessage reset =  new OscMessage("/reset");
  reset.add(0);
  oscP5.send(reset, aqui);
  population = new Population(5);
  for (int i = 0; i < Nfoods; i++) {
    plants.add(new Plant());
  }
  OscMessage setup = new OscMessage("/setup");
  setup.add(1);
  oscP5.send(setup, aqui);
}


void draw() {
  noiseImage.resize(width,height);
  background(noiseImage);
  pushMatrix();
  grow();
  population.run();
  for(Population pop:world){
  pop.run();
  }
  for (int i = plants.size()-1; i >= 0; i--) { 
    Plant p = plants.get(i);
    p.run();
  }
  controls();
  OscControls();
  finished(); 
  popMatrix();
}

void controls() {
  switch(key) {
  case '1':
    rate();
    println("frame rate"); 
    break;
  case '2':
    dataMapping();
    println("data mapping"); 
    break;
  case '3':
    prints();
    println("prints");
    break;
  }
}

void rate() {
  float rate = frameRate;
  pushMatrix();
  fill(255);
  textMode(CENTER);
  text(int(rate) + " FPS", 100, 100);
  popMatrix();
}

void mousePressed() { //mouse produces new food with click
  //plants.add(new Plant(new PVector(mouseX, mouseY)));
  //saveFrame("frames/####.png");
  PVector mouse = new PVector(mouseX,mouseY);
  Population pop = new Population(mouse, 10);
  world.add(pop);
}

void prints() {
  println("frames = " + frameCount);
  println("plants = " + plants.size());
  println("blobs = " + population.blobs.size());
  println("overall change = "+ (population.blobs.size() - Nblobs));
  for (int i = population.blobs.size()-1; i>=0; i--) {
    Blob b = population.blobs.get(i);
    println("blob number = " + i); 
    println("sex = " + b.sex);
    println("size = " + b.r);
    println("sense = " + b.sense);
    println("force = " + b.maxforce);
    println("speed = " + b.maxspeed);
  }
}


void dataMapping() {
  OscMessage frames = new OscMessage("/frames");
  OscMessage foodsize = new OscMessage("/foodsize");
  OscMessage blobsize = new OscMessage("/blobsize");
  OscMessage delta = new OscMessage("/delta");
  frames.add(frameCount);
  foodsize.add(plants.size());
  blobsize.add(population.blobs.size());
  delta.add((population.blobs.size() - Nblobs));
  oscP5.send(foodsize, aqui);
  oscP5.send(blobsize, aqui);
  oscP5.send(frames, aqui);
  oscP5.send(delta, aqui);
}

void OscControls() {
  OscMessage populationOsc = new OscMessage("/population");
  populationOsc.add(population.blobs.size());
  oscP5.send(populationOsc, aqui);
  for (int i = 0; i < population.blobs.size(); i++) {
    Blob b = population.blobs.get(i);
    OscMessage blob =  new OscMessage("/blob");
    float[] params = {i, b.r, b.maxspeed, b.position.x, b.position.y, b.health};
    blob.add(params);
    oscP5.send(blob, aqui);
  }
}


//this was put here because we want a food to grow randomly at every frame, and not
//as a method for each individual plant.
void grow() {
  if (random(1) < 0.001) {
    plants.add(new Plant());
    println("plant grew!");
  }
}

void finished() {
  if (population.blobs.size() == 0) {
    fill(0);
    textAlign(CENTER);
    textSize(100);
    text("Finished", width/2, height/2);
    OscMessage done = new OscMessage("/blob");
    done.add("all");  
    done.add("bang");
    oscP5.send(done, aqui);
    println("finished");
    noLoop();
  }
}


//things to implement:
//playable blob
//plant dna and evolution
//collision avoidance //HAS BEEN DONE
//sexual reproduction //HAS BEEN DONE
//individual genes for each alele //HAS BEEN DONE
//gene crossover and mutation. //SORT OF DONE
//plant crossover and mutation
//carnivorous behaviour - bigger eating smaller
//diversification of aleles - color, endurance
//group behavior within a population based on aleles, or diferent populational bahaviour
//GRAPHICS FOR READABILITY!!!!!!!!
//OSC PROTOCOL
