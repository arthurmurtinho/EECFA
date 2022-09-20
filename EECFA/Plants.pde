class Plant {
  PVector position;
  DNA dna;

  Plant(PVector p) {
    position = p.copy();
    dna = new DNA();
  }
  
  Plant() {
    position = new PVector(random(width),random(height));
    dna = new DNA();
  }

  void run() {
    show();
  }
  
  void show() {
    noStroke();
    fill(0, 110, 51);
    circle(position.x, position.y, 8);
  }
}
