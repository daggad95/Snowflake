import java.util.LinkedList;

class Particle {
  public static final int RIGHT = 0;
  public static final int LEFT = 1;
  public static final int UP = 2;
  public static final int DOWN = 3;
  
  private PVector pos;
  private LinkedList<Particle> slaves;
  private Particle master;
  
  public Particle(PVector pos) {
    this.pos = pos;
    master = null;
    slaves = new LinkedList<Particle>();
  }
  
  public void move(Particle[][] pmap, int dir) {
    int dx = 0;
    int dy = 0;
    int x = (int) pos.x;
    int y = (int) pos.y;
    
    switch (dir) {
      case RIGHT:
        dx = 1;
        break;
      case LEFT:
        dx = -1;
        break;
      case UP:
        dy = -1;
        break;
      case DOWN:
        dy = 1;
        break;
    }
    
    x += dx;
    y += dy;
    
    if (x >= 0 && x < width * 2 && y >= 0 && y < height * 2) {
      pmap[x - dx][y - dy] = null;
      pmap[x][y] = this;
      pos.x = x;
      pos.y = y;
    }
    
    if (slaves.size() > 0) {
      for (Particle p : slaves) {
        p.move(pmap, dir);
      }
    }
  }
  
  public void move(Particle[][] pmap) {
    if (master == null) {
      int dir = (int) random(4);
      move(pmap, dir);
      
      for (Particle p : slaves) {
        p.move(pmap, dir);
      }
    }
  }
  
  public void draw() {
    float z = 255 - dist(pos.x, pos.y, width, height) / dist(0, 0, width, height) * 255;
    colorMode(HSB, 255);
    stroke(z, z, z);
    strokeWeight(1);
    point(pos.x - width / 2, pos.y - height / 2);
  }
  
  public boolean isSlave() {
    return master != null;
  }
  
  public int getX() {
    return (int) pos.x;
  }
  
  public int getY() {
    return (int) pos.y;
  }
  
  public void combine(Particle other) {
    if (other.master == this || this.master == other)
      return;
    
    if (other.master == null) {
      if (master == null) {
        other.master = this;
        slaves.add(other);
      }
      else {
        if (master != other) {
          master.combine(other);
        }
      }
    }
    else if (other.master != this) {
      combine(other.master);
    }
  }
}