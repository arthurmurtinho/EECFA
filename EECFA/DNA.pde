class DNA {

  float[] genes;

  DNA() {
    genes = new float[8];
    for (int i = 0; i < genes.length; i++) {
      genes[i] = random(0, 1);
    }
  }

  DNA(float[] newgenes) {
    genes = newgenes;
  }

  DNA copy() {
    float[] newgenes = new float[genes.length];
    for (int i = 0; i < genes.length; i++) {
      newgenes[i] = genes[i];
    }

    return new DNA(newgenes);
  }
  
  //sexual crossover, which picks one of the two parents gene, for every gene in the array
  DNA crossover(DNA other) {
    float[] genesA = new float[genes.length];
    for (int i = 0; i < genes.length; i++) {
      genesA[i] = genes[i];
    }
    float[] genesB = new float[other.genes.length];
    for (int i = 0; i < other.genes.length; i++) {
      genesB[i] = other.genes[i];
    }
    float[] newgenes = new float[genes.length];
    for (int i = newgenes.length-1; i >= 0; i--) {
      if (random(1) < 0.5) {
        newgenes[i] = genesA[i];
      } else {
        newgenes[i] = genesB[i];
      }
    }
    return new DNA(newgenes);
  }

  void mutate(float m) {
    for (int i = 0; i < genes.length; i++) {
      if (random(1) < m) {
        genes[i] = random(0, 1);
      }
    }
  }
}
