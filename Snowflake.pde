import java.util.LinkedList;

public static final int NUM_PARTICLES = 50000;

LinkedList<Particle> particles;
Particle[][] pmap;

void setup() {
  size(800, 800);
  
  particles = new LinkedList<Particle>();
  pmap = new Particle[width * 2][height * 2];
  
  for (int x = 0; x < width * 2; x++) {
    for (int y = 0; y < height * 2; y++) {
      pmap[x][y] = null;
    }
  }
  
  for (int i = 0; i < NUM_PARTICLES; i++) {
    int x = (int) random(width) + width / 2;
    int y = (int) random(height) + height / 2;
    Particle p = new Particle(new PVector(x, y));
    
    pmap[x][y] = p;
    particles.add(p);
  }
}

void draw() {
  background(255);
  
  for (int i = 0; i < 100; i++) {
    for (Particle p : particles) {
      p.move(pmap);
    }
    coalesce();
  }
  
  for (Particle p : particles) {
    p.draw();
  }
}

void coalesce() {
  int count = 0;
  
  for (Particle p : particles) {
    int x = p.getX();
    int y = p.getY();
    int right = x + 1;
    int left  = x - 1;
    int top   = y - 1;
    int bot   = y + 1;
    
    if (right < width && pmap[right][y] != null) {
      Particle adj = pmap[right][y];
      p.combine(adj);
    }
    if (left >= 0 && pmap[left][y] != null) {
      Particle adj = pmap[left][y];
      p.combine(adj);
    }
    if (top >= 0 && pmap[x][top] != null) {
      Particle adj = pmap[x][top];
      p.combine(adj);
    }
    if (bot < height  && pmap[x][bot] != null) {
      Particle adj = pmap[x][bot];
      p.combine(adj);
    }
    
    if (!p.isSlave())
      count++;
  }
  println(count);
}