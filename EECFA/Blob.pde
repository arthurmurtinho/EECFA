class Blob {
  DNA dna;
  PVector position;
  PVector acceleration;
  PVector velocity;
  PVector walk; //random walking force
  float maxspeed; //speed.
  float maxforce; //maximum steering force.
  float sense; //perception of it's near space
  float r; //size of creature
  float health; //self explanatory i hope
  color female = color(129, 97, 62);
  color male = color(255, 153, 19);
  color sex;
  int ageCount = 0;
  float xoff; //this are for the noise walk 
  float yoff;
  FloatList steerMed; 

  Blob(PVector p, DNA dna_) {
    steerMed = new FloatList();
    dna = dna_;
    health = 200;
    position = p.copy();
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    sense = map(dna.genes[0], 0, 1, 20, 80);
    maxspeed = map(dna.genes[1], 0, 1, 5, 0.1);
    maxforce = map(dna.genes[2], 0, 1, 0.01, 0.1);
    r = map(dna.genes[3], 0, 1, 50, 1);
    sense += r/2;
    if (dna.genes[4] > 0.5) {
      sex = female;
    } else {
      sex = male;
    }
    xoff = random(1000);
    yoff = random(1000);
  }
  
  Blob(DNA dna_) {
    steerMed = new FloatList();
    dna = dna_;
    health = 200;
    position = new PVector(random(width),random(height));
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    sense = map(dna.genes[0], 0, 1, 20, 80);
    maxspeed = map(dna.genes[1], 0, 1, 5, 0.1);
    maxforce = map(dna.genes[2], 0, 1, 0.01, 0.1);
    r = map(dna.genes[3], 0, 1, 50, 1);
    sense += r/2;
    if (dna.genes[4] > 0.5) {
      sex = female;
    } else {
      sex = male;
    }
    xoff = random(1000);
    yoff = random(1000);
  }

  //method that puts everything in motion
  void run(ArrayList<Plant> list, ArrayList<Blob> blobs, int i) {
    display(i);
    borders();
    update(list, blobs);
    eat(list);
    replicate(blobs);
    health -= 0.2; //death always looming\
    ageCount++;
  }

  //this solves a problem with having multiple acceleration additions and multiplications,
  //by collapsing them in one method, with the wander and steering bahavior inside of it.
  void update(ArrayList<Plant> list, ArrayList<Blob> blobs) {
    steer(list);
    wander(list);
    separate(blobs);
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    position.add(velocity);
    acceleration.mult(0);
  }

  void display(int i) {
    pushMatrix();
    body();
    pushMatrix();
    if ((key == CODED) && (keyCode == CONTROL)) {
      sense();
      direction();
      pushMatrix();
      index(i);
      popMatrix();
    }
    popMatrix();
    popMatrix();
  } 

  void body() {
    fill(sex, health);
    noStroke();
    ellipse(position.x, position.y, r,r);
  }

  void sense() {
    noFill();
    stroke(0);
    circle(position.x, position.y, sense*2);
  }

  void direction() {
    float theta = velocity.heading() + PI/2; //shows the heading of blob
    fill(127);
    stroke(0);
    strokeWeight(1);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape();
    vertex(0, -r/5);
    vertex(-r/10, r/5);
    vertex(r/10, r/5);
    endShape(CLOSE);
    popMatrix();
  }

  void index(int i) {
    String index = "" + i;
    fill(0);
    textAlign(CENTER);
    textSize(10);
    text(index, position.x, position.y);
  }

  //this method directs blobs to a plant if it's near enough;
  void steer(ArrayList<Plant> plist) {
    for (int i = plist.size()-1; i>=0; i--) {
      Plant p = plist.get(i);
      PVector desired = PVector.sub(p.position, position);
      float d = desired.mag();
      if (d < sense) {
        float m = map(d, 0, sense, 0, maxspeed);
        desired.setMag(m);
      } else {
        desired.setMag(maxspeed);
      }
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxforce);
      if (d < sense) {
        applyForce(steer);
      }
    }
  }

  //this method makes blobs wander aimlessly until they encounter a plant
  void wander(ArrayList<Plant> plist) {
    for (int i = plist.size()-1; i >= 0; i--) {
      Plant p = plist.get(i);
      PVector desired = PVector.sub(p.position, position);
      float d = desired.mag();
      steerMed.append(d);
    }
    float vx = map(noise(xoff), 0, 1, -maxspeed, maxspeed);
    float vy = map(noise(yoff), 0, 1, -maxspeed, maxspeed);
    walk = new PVector(vx, vy);
    xoff += 0.01;
    yoff += 0.01;
    walk.limit(maxforce);
    if ((plist.size()-1 == -1) || ( steerMed.min() > sense)) {
      applyForce(walk);
    } else {
      walk.mult(0);
    }
    steerMed.clear();
  }

  void separate (ArrayList<Blob> blobs) {
    float desiredseparation = r*2;
    PVector sum = new PVector();
    int count = 0;
    // For every blob in the system, check if it's too close 
    for (Blob other : blobs) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        sum.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(maxspeed);
      sum.sub(velocity);
      sum.limit(maxforce);
    }
    //return sum;
    PVector separate = sum;
    separate.mult(1.5);
    applyForce(separate);
  }

  //this is a method for adding forces to a acceleration PVector
  void applyForce(PVector f) {
    acceleration.add(f);
  }

  //wraparound
  void borders() {
    wrap();
    //wall();
  }

  void wrap() {
    if (position.x > width) { 
      position.x = 0;
    }
    if (position.x < 0) {
      position.x = width;
    }
    if (position.y > height) { 
      position.y = 0;
    }
    if (position.y < 0) {
      position.y = height;
    }
  }
  void wall() {
    if (position.x > width) { 
      position.x = width;
    }
    if (position.x < 0) {
      position.x = 0;
    }
    if (position.y + r/2 > height) { 
      position.y = height - r/2;
    }
    if (position.y - r/2 < 0) {
      position.y = 0 + r/2;
    }
  }


  //this makes blobs eat and get health, while eliminating the plant from the 
  //food array
  void eat(ArrayList<Plant> plist) {
    for (int i = plist.size()-1; i>=0; i--) {
      Plant p = plist.get(i);
      PVector desired = PVector.sub(p.position, position);
      float d = desired.mag();
      if (d <= r/2) {
        plants.remove(i);
        health = health + (100-age());
      }
    }
  }

  //says if the blob died and removes it
  boolean dead() {
    if (health < 0.0) {
      return true;
    } else {
      return false;
    }
  }
  
  float age(){
    float ageMapped = map(float(ageCount), 0, 600, 0, 50);
    if (ageMapped > 50){
      ageMapped = 50;
      return ageMapped;
    } else {
      return ageMapped;
    }
  }

  //sexual reproduction, with a small random mutation chance
  void replicate(ArrayList<Blob> blobs) {
    float desiredseparation = r*2;
    for (int i = blobs.size()-1; i >= 0; i--) {
      Blob other = blobs.get(i);
      float d = PVector.dist(position, other.position);
      if ((d < desiredseparation) && (sex != other.sex)) {
        if ((random(1) < 0.00075)) {
          DNA parentADNA = dna.copy();
          DNA parentBDNA = other.dna.copy();
          DNA childDNA = parentADNA.crossover(parentBDNA);
          childDNA.mutate(0.01); //1% mutation chance
          PVector childPosition = new PVector(position.x, position.y);
          childPosition.add(new PVector(r, r));
          Blob child = new Blob(childPosition, childDNA);
          blobs.add(child);
          println("a child is born");
        }
      }
    }
  }
}
