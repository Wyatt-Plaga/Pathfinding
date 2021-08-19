class locationData {
  PVector position;
  float orientation;
  
  locationData() {
    this.position = new PVector(.0f, .0f);
    this.orientation = .0f;
  }     
  
  locationData(PVector position, float orientation) {
    this.position = position;
    this.orientation = orientation;
  }   
}

class movementData {
  PVector velocity;
  float rotation;

  movementData() {
    this.velocity = new PVector(.0f, .0f);
    this.rotation = .0f;
  }   
  
  movementData(PVector velocity, float rotation) {
    this.velocity = velocity;
    this.rotation = rotation;
  }   
}

abstract class KinematicMovement {
  movementData getmovementData(locationData locationData){ return null; }
}

class KinematicBoid {
  
  locationData character;
  KinematicMovement controller;
  ArrayList<PVector> points = new ArrayList<PVector>();
  Environment environment;
  
  KinematicBoid(KinematicMovement controller, float x, float y, Environment environment) {
    this.controller = controller;
    this.character = new locationData(new PVector(x, y), PI * .5f);
    this.environment = environment;
  }
  
  void generatePoints(locationData target) {
    Node startNode = environment.findClosestNode(character);
    PVector startNodeLocation = new PVector(startNode.value.x * 40, startNode.value.y * 40);
    Node endNode = environment.findClosestNode(target);
    PVector endNodeLocation = new PVector(endNode.value.x * 40, endNode.value.y * 40);
    environment.search.reset(endNode, startNode);
    points.clear();
    while(environment.search.shortestPath() == null) {
      environment.search.update();
    }
    ArrayList<Edge> path = environment.search.shortestPath();
    for(Edge edge : path) {
      if(edge.end != endNode) {
        PVector nodeLocation = new PVector(edge.end.value.x * 40, edge.end.value.y * 40);
        points.add(nodeLocation);
      }
    }
    points.add(endNodeLocation);
  }
  
  void update(float dt) {
    //System.out.println(controller);
    movementData currentmovementData = controller.getmovementData(character);
    
    if(null != currentmovementData) {
      character.position.add(PVector.mult(currentmovementData.velocity, dt));
      character.orientation += currentmovementData.rotation * dt;
      
      if(PI < character.orientation)
        character.orientation -= 2 * PI;
      else if(-PI > character.orientation)
        character.orientation += 2 * PI;
    }
  }
  
    void render() {
      pushMatrix();
      translate(boid.character.position.x, boid.character.position.y);
      rotate(-boid.character.orientation + PI/2);
      triangle(0, 0 - 80, 0 + 38, 0 - 10, 0 - 38, 0 - 10);
      ellipse(0, 0, 80, 80);
      fill(204, 0, 0);
      popMatrix();
  }
}

float getNewOrientation(float currentOrientation, PVector goalVelocity, float smoothing) {
  //if velocity is high enough to bother moving
  if(goalVelocity.magSq() >= .001f) {
    //calculates the required orientation needed to achieve the desired velocity
    float targetOrientation = atan2(-goalVelocity.y, goalVelocity.x);
    if(.0f < smoothing) {
      float delta = (targetOrientation - currentOrientation);
      
      if(PI < delta)
        delta -= 2 * PI;
      else if(-PI > delta)
        delta += 2 * PI;
        
      float intermediateOrientation = currentOrientation + delta * smoothing;
      return intermediateOrientation;
    }
    
    return targetOrientation;
  }
  
  return currentOrientation;
}

PVector getCurrentVelocity(float currentOrientation) {
  PVector currentVelocity = new PVector(cos(currentOrientation), -sin(currentOrientation));
  return currentVelocity;
}


float getCurrentOrientation(PVector currentVelocity) {
  float currentOrientation = atan2(-currentVelocity.y, currentVelocity.x);
  if(PI < currentOrientation)
      currentOrientation -= TWO_PI;
  else if(-PI > currentOrientation)
      currentOrientation += TWO_PI;
  return currentOrientation;
}

class KinematicSeek extends KinematicMovement {
   
  locationData targetLocation = null;
  //float maxSpeed = 250f;
  float smoothing = .0f;
  
  void updateTarget() {
    if(mousePressed) {
      targetLocation = new locationData(new PVector(mouseX, mouseY), .0f);
    }
  }
  
  movementData getmovementData(locationData character) {
    updateTarget();
    
    if(null == targetLocation)
      return null;
    
    //makes an empty movement data
    movementData result = new movementData();
    //sets the velocity of the movement data to be the velocity needed to reach the target location
    result.velocity = PVector.sub(targetLocation.position, character.position);
    //reduces this velocity so that it is the same magnitude as the max speed.
    result.velocity.normalize().mult(maxSpeed);
    //sets the characters orientation to be the new one through getNewOrientatoin to handle smoothing and bothering to change
    character.orientation = getNewOrientation(character.orientation, result.velocity, smoothing);
    
    return result;
  }
}

class KinematicFlee extends KinematicMovement { 
  
  locationData targetLocation = null;
  //float maxSpeed = 250f;
  float smoothing = .0f;
  
  void updateTarget() {
    if(mousePressed)
    //sets flee point to be where mouse is pressed
      targetLocation = new locationData(new PVector(mouseX, mouseY), .0f);
  }
  
  movementData getmovementData(locationData character) {
    updateTarget();
    
    if(null == targetLocation)
      return null;
    
    //creates an empty movement data
    movementData result = new movementData();
    //sets the velocity to be where it needs to go to reach the target
    result.velocity = PVector.sub(targetLocation.position, character.position);
    //sets the volocity to be the oposite of what it just set
    result.velocity = PVector.sub(character.position, targetLocation.position);
    //reduces this velocity so that it is the same magnitude as the max speed.
    result.velocity.normalize().mult(maxSpeed);
    //sets the characters orientation to be the new one through getNewOrientatoin to handle smoothing and bothering to change
    character.orientation = getNewOrientation(character.orientation, result.velocity, smoothing);
    
    return result;
  }
}

class KinematicArrive extends KinematicMovement {
   
  locationData targetLocation = null;
  float timeToTarget = .0005f;
  float stopRadius = 10;
  
  //float maxSpeed = .5f;
  float smoothing = .1f;
  
  void updateTarget() {
    if(mousePressed)
      targetLocation = new locationData(new PVector(mouseX, mouseY), .0f);
  }
  
  movementData getmovementData(locationData character) {
    //updateTarget();
    
    if(null == targetLocation)
      return null;
    
    //creates an empty movement data
    movementData result = new movementData();
    //sets the velocity to be that to land at the target osition
    result.velocity = PVector.sub(targetLocation.position, character.position);
    
    //if the velocity is larger than the stop radius, returns nothing
    if(result.velocity.mag() <= stopRadius)
      return null;
    
    //divides the velocity by the time to reach the target
    result.velocity.div(timeToTarget);
    
    //if the velocity is still higher than the max allowed speed, set to the magnitude to the max allowed spped.
    if(result.velocity.mag() > maxSpeed)
      result.velocity.normalize().mult(maxSpeed);
    //sets the characters orientation to be the new one through getNewOrientatoin to handle smoothing and bothering to change
    character.orientation = getNewOrientation(character.orientation, result.velocity, smoothing);
    
    return result;
  }
}

class KinematicAlign extends KinematicMovement {
   
  locationData target = null;
  float smoothing = .0f;
  
  void updateTarget() {
    if(mousePressed)
      target = new locationData(new PVector(mouseX, mouseY), .0f);
  }
  
  movementData getmovementData(locationData character) {
    updateTarget();
    
    if(null == target)
      return null;
    
    //sets a vector to the velocity to reach the target location
    PVector direction = PVector.sub(target.position, character.position);
    //passes to getNewOrientation to handle bothering to move and smothing
    character.orientation = getNewOrientation(character.orientation, direction, smoothing);
    
    return null;
  }
}

class KinematicWander extends KinematicMovement {
  
  float rotation = .0f;
  int framesSinceSample = 0;
  
  int turner = 0;
  
  int samplingInterval = 4;
  float maxRotation = PI/400;
  //float maxSpeed = .25f;
  
  float sampleDifference() {
    return random(1.0f) - random(1.0f);
  }
  
  movementData getmovementData(locationData character) {
    if(0 == framesSinceSample)
      rotation = sampleDifference() * maxRotation;
      
    framesSinceSample = (framesSinceSample + 1) % samplingInterval;
    
    //create an empty movement data object
    movementData result = new movementData();
    result.velocity.x = cos(character.orientation) * maxSpeed;
    result.velocity.y = -sin(character.orientation) * maxSpeed;
    //if(distanceToEdge(character) < 100 && turner <= 10) {
    //  System.out.println(turner);
    //  result.rotation = result.rotation + 0.02;
    //  turner++;
    //} else {
    //  result.rotation = rotation;
    //  turner = 0;
    //}

    
    return result;
  }
}

class KinematicWander2 extends KinematicMovement {
  
  float rotation = .0f;
  int framesSinceSample = 0;
  
  int turner = 0;
  
  int samplingInterval = 4;
  float maxRotation = PI/400;
  //float maxSpeed = .25f;
  
  float sampleDifference() {
    return random(1.0f) - random(1.0f);
  }
  
  movementData getmovementData(locationData character) {
    if(0 == framesSinceSample)
      rotation = sampleDifference() * maxRotation;
      
    framesSinceSample = (framesSinceSample + 1) % samplingInterval;
    
    //create an empty movement data object
    movementData result = new movementData();
    result.velocity.x = cos(character.orientation) * maxSpeed;
    result.velocity.y = -sin(character.orientation) * maxSpeed;
    result.rotation = rotation;

    
    return result;
  }
}

class DoubleData {
  PVector position;
  float orientation;
  PVector velocity;
  float rotation;
  
  DoubleData() {
    this.position = new PVector(.0f, .0f);
    this.orientation = .0f;
    this.velocity = new PVector(.0f, .0f);
    this.rotation = .0f;
  }     

  DoubleData(PVector position, float orientation) {
    this.position = position;
    this.orientation = orientation;
    this.velocity = new PVector(.0f, .0f);
    this.rotation = .0f;
  }   
  
  DoubleData(PVector position, float orientation, PVector velocity, float rotation) {
    this.position = position;
    this.orientation = orientation;
    this.velocity = velocity;
    this.rotation = rotation;
  }   
}
