abstract class GameObject {
  void update(float dt) {};
  void render() {};
  PVector getPosition() { 
    return null; 
  }
  PVector getVelocity() { 
    return null; 
  }
}

abstract class Path extends GameObject {
  abstract PVector getPosition(float param);
  abstract float getParam(PVector position, float lastParam);
}


class PointPath extends Path {
  
  ArrayList<PVector> points = new ArrayList<PVector>();
  float scale = 2.0;
  float range = 20;
 
  void addPoint(PVector point) {
    points.add(point);
  }
  
  PVector getPosition(float param) {
    int index = round(param / scale);
    
    if(index < points.size())
      return points.get(index);
    else
      return points.get(points.size() - 1);
  }
  
  float getParam(PVector position, float lastParam) {
    int minIndex = round((lastParam - range) / scale);
    minIndex = max(minIndex, 0);
    
    int maxIndex = round((lastParam + range) / scale) + 1;
    maxIndex = min(maxIndex, points.size());
    
    float minDistance = Float.POSITIVE_INFINITY;
    float param = 0.0;
    
    for(int i=minIndex; i < maxIndex; ++i){
       float distance = PVector.sub(points.get(i), position).mag();
       
       if(distance < minDistance){
         minDistance = distance;
         param = scale * (float) i;
       }
    }
    
    return param;
  }
  
  void render() {
    fill(0,180,255);
    stroke(0,180,255);
    
    for(PVector point : points) {
      circle(point.x, point.y, 10);
    }
  }
}


class KinematicFollowing extends KinematicArrive {
 
  PointPath path;
  float epsilon = 1.0;
  float currentParam = 0.0;
  KinematicBoid boid;
  
  KinematicFollowing(PointPath path, KinematicBoid boid) {
    this.path = path; 
    this.boid = boid;
  }
  
  void addBoid(KinematicBoid boid) {
    this.boid = boid;
  }
  
  void updateTarget() {
    if(mousePressed) {
      path = new PointPath();
      locationData target = new locationData(new PVector(mouseX, mouseY), .0f);
      boid.generatePoints(target);
      for(PVector point : boid.points) {
        path.addPoint(point);
      }
 
    }
  }
  
    movementData getmovementData(locationData character) {
    
    updateTarget();
    
    if(path.points.size() > 0) {
      currentParam = path.getParam(character.position , currentParam);
      PVector target = path.getPosition(currentParam + epsilon);
      super.targetLocation = new locationData(target, 0.);
    }
    return super.getmovementData(character);
  }
}
