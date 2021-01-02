// *** Physical Map Generator (phmg_a2x1) by Atoro 
color[] cp = {
  color(0, 126, 192), 
  color(24, 154, 208), 
  color(58, 168, 214), 
  color(94, 186, 220),
  color(234, 136, 70), 
  color(209, 104, 47), 
  color(187, 76, 15), 
  color(148, 56, 0)
}; 

PImage map;
void createMap() {
  map = new PImage(2*width, 2*height);
  float d0 = random(100, 200);   
  float d1 = random(25, 75);
  map.loadPixels(); 
  for (int j = 0; j < map.height; j++) {
    for (int i = 0; i < map.width; i++) {
      float n0 = noise(i/d0, j/d0, 0); 
      float n1 = noise(i/d1, j/d1, 10); 
      float n = 1 - (n0*0.75 + n1*0.25); 
      int k = int(n*cp.length); 
      map.pixels[j*map.width + i] = cp[k];
    }
  } 
  map.updatePixels();
}
