class KinematicBreadcrumbs {
  
  int counter = 0;
 
  ArrayList<PVector> breadcrumbs = new ArrayList<PVector>();
  
  KinematicBoid boid;
  PVector lastPosition;
  float distance;
  
  float interval = 40f;
  float size = 30f;
  
  KinematicBreadcrumbs(KinematicBoid boid) {
    this.boid = boid;
    //sets the last position to be the current position of the boid
    lastPosition = boid.character.position;
    //sets distance to 0
    distance = 0.0f;
  }
  
  void update(float dt) {
    //adds the distance between the boid and its last reported position to distance
    distance += PVector.sub(lastPosition, boid.character.position).mag();
    //sets the current position to be the last reported position
    lastPosition = boid.character.position.copy();
    
    //if the distance gets too high and another breadcrumb should be put down...
    if(distance >= interval) {
      //System.out.println("run " + counter);
      counter++;
      //adds the last reported position to the breadcrumb set for it to be drawn
       breadcrumbs.add(lastPosition);
       distance = 0.0f;
    }
  }
  
  void render() {
    fill(204, 0, 0);
    stroke(255,255,255);
    strokeWeight(2);
    
    for(PVector crumb : breadcrumbs) {
      //System.out.println(breadcrumbs.size());
      circle(crumb.x, crumb.y, size);
    }
  }
}
