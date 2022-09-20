class Population {
  ArrayList<Blob> blobs = new ArrayList<Blob>();
  int init;
  PVector position;

  Population(PVector p, int init) {
    position = p.copy();
    for (int i = 0; i < init; i++) {
      DNA dna = new DNA();
      blobs.add(new Blob(position, dna));
    }
  }
  
  Population(int init) {
    for (int i = 0; i < init; i++) {
      DNA dna = new DNA();
      blobs.add(new Blob(dna));
    }
  }

  void run() {
    for (int i = blobs.size()-1; i >=0; i--) { //running backwards through list for iteration
      Blob blob = blobs.get(i);
      blob.run(plants, blobs, i);
      if (blob.dead() == true) {
        blobs.remove(i);
        println("a blob has passed");
        plants.add(new Plant(blob.position));
      }
    }
  }
}
