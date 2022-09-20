class Noise {
  float increment;
  float xoff;
  float detail;
  PImage noise;

  Noise() {
    increment = 0.02;
    xoff = 0.0;
    detail = 0.58;
  }

  void setBrightness(PImage i) {
    noiseDetail(8, detail);
    for (int x = 0; x < width; x++) {
      xoff += increment;
      float yoff = 0.0;
      for (int y = 0; y < height; y++) {
        yoff += increment;
        float bright = noise(xoff, yoff) * 133;
        i.pixels[x+y*width] = color(0, bright/2, bright);
      }
    }
  }

  PImage generateImage() {
    noise = createImage(width, height, RGB);
    noise.loadPixels();
    setBrightness(noise);
    noise.updatePixels();
    return noise;
  }
}
