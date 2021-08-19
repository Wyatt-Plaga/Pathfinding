import java.util.List;
import java.util.Collection;
import java.util.PriorityQueue;
import java.util.HashSet;
import java.util.HashMap;


class Node {
  GridCell value;
  List<Edge> incoming;
  List<Edge> outgoing;
  
  Node(GridCell value) {
    this.value = value;
    this.incoming = new ArrayList<Edge>();
    this.outgoing = new ArrayList<Edge>();
  }
  
  void edgeTo(Node node, float weight) {
    //start, end, weight of edge
    Edge edge = new Edge(this, node, weight);
    this.outgoing.add(edge);
    node.incoming.add(edge);
  }
  
  boolean edgeToAndFrom(Node node, float weight) {
    //start, end, weight of edge
    for(Edge edge : incoming) {
      if(edge.start == node) {
        return false;
      }
    }
    for(Edge edge : outgoing) {
      if(edge.end == node) {
        return false;
      }
    }
    Edge edge1 = new Edge(this, node, weight);
    this.outgoing.add(edge1);
    node.incoming.add(edge1);
    
    Edge edge2 = new Edge(node, this, weight);
    node.outgoing.add(edge2);
    this.incoming.add(edge2);
    return true;
  }
}


class Edge {
  float weight;
  Node start;
  Node end;
  
  Edge(Node start, Node end, float weight) {
    this.start = start;
    this.end = end;
    this.weight = weight;
  }
}


interface GraphSearch<GridCell> {
  void reset(Node start, Node goal);
  void update();
  ArrayList<Edge> shortestPath();
  Collection<Node> openSet();
  Collection<Node> closedSet();
}


class GridCell {
  int x;
  int y;
  
  GridCell(int x, int y) {
    this.x = x;
    this.y = y;
  }
}


boolean[][] empty(int w, int h) {
  boolean[][] map = new boolean[h][w];
  
  for(int y=0; y < h; ++y)
    for(int x=0; x < w; ++x)
      map[y][x] = false;
      
  return map;
}



class GreedyTag implements Comparable<GreedyTag> {
  Node node;
  
  float ctg;
  Edge edge;
  
  GreedyTag(Node node, float ctg, Edge edge) {
    this.node = node;
    this.ctg = ctg;
    this.edge = edge;
  }
  
  int compareTo(GreedyTag o) {
    if(this.ctg < o.ctg)
      return -1;
    else if(this.ctg > o.ctg)
      return 1;
    else
      return 0;
  }
}

class GreedyBestFirst implements GraphSearch {
  Heuristic heuristic; 
  
  Node goal;
  
  HashMap<Node,GreedyTag> tags;
  
  PriorityQueue<GreedyTag> open;
  HashSet<Node> closed;
  
  GreedyBestFirst(Heuristic heuristic) {
    this.heuristic = heuristic;
  }
  
  void reset(Node start, Node goal) {
    this.goal = goal;
    
    tags = new HashMap<Node,GreedyTag>();
  
    open = new PriorityQueue<GreedyTag>();
    closed = new HashSet<Node>();
    
    GreedyTag tag = new GreedyTag(start, heuristic.value(start.value, goal.value), null);
    tags.put(start, tag);
    open.add(tag);
  }
  
  void update() {
    if(!tags.containsKey(goal)) {
       GreedyTag tag = open.poll();
       
       if(null != tag && !closed.contains(tag.node)) {
          for(Edge edge : tag.node.outgoing) {
            if(!tags.containsKey(edge.end)) {
              float ctg = heuristic.value(edge.end.value, goal.value);
              GreedyTag next_tag = new GreedyTag(edge.end, ctg, edge);
              
              tags.put(edge.end, next_tag);
              open.add(next_tag);
              //System.out.println(open.size());
            }
            
            if(edge.end == goal)
              break;
          }
          
          closed.add(tag.node);
       }
    }
  }
  
  ArrayList<Edge> shortestPath() {
    if(tags.containsKey(goal)) {
      ArrayList<Edge> path = new ArrayList<Edge>();
      
      GreedyTag tag = tags.get(goal);
      
      while(null != tag.edge) {
        path.add(tag.edge);
        tag = tags.get(tag.edge.start);
      }
      
      return path;
    } else {
      return null;
    }
  }
  
  Collection<Node> openSet() {
    if(null != open) {
      ArrayList<Node> list = new ArrayList<Node>();
    
      for(GreedyTag tag : open)
        list.add(tag.node);
    
      return list;
    } else {
      return null;
    }
  }
  
  Collection<Node> closedSet() {
    return closed; 
  }
}


interface Heuristic {
  float value(GridCell start, GridCell goal);
}


class Manhattan implements Heuristic {
  float value(GridCell start, GridCell goal) {
    return abs(goal.x - start.x) + abs(goal.y - start.y);
  }
}

class Linear implements Heuristic {
  float value(GridCell start, GridCell goal) {
    float distanceSquared = (float) (Math.pow((goal.x - start.x),2) + Math.pow((goal.y - start.y),2));
    return sqrt(distanceSquared);
  }
}

class Constant implements Heuristic {
  float value(GridCell start, GridCell goal) {
    return (float) (Math.pow((goal.x - start.x),2) + Math.pow((goal.y - start.y),2));
  }
}

int FRAME_RATE = 60;
SimpleMap simpleMap;
LargeMap largeMap;
Environment environment;
GridCell start;
GridCell finish;

PVector position = new PVector(500, 500);
float maxSpeed =  0.5f;
PointPath path = new PointPath();
KinematicBoid boid;
KinematicFollowing following;
int latestTime;
KinematicBreadcrumbs bread;

public void settings() {
  size(1240,1240);
  smooth(2);
}


void setup() {
  
  // Confugure search
  GraphSearch search = null;
  if(Manhattan) {
      if(GreedySearch) {
      search = new GreedyBestFirst(new Manhattan());
    } else if(AStarSearch) {
      search = new AStar(new Manhattan());
    } else {
      search = new Dijkstra(new Manhattan());
    }
  } else if(Linear){
      if(GreedySearch) {
      search = new GreedyBestFirst(new Linear());
    } else if(AStarSearch) {
      search = new AStar(new Linear());
    } else {
      search = new Dijkstra(new Linear());
    }
  } else {
      search = new AStar(new Constant());
  }
  
  // Build map
  boolean[][] map = empty(300, 300);
  
  // Build grid
  if(smallMapDemo) {
    simpleMap = new SimpleMap(map, search, true);
    simpleMap.reset(28, 31, 6, 4);
  }
  
  if(largeMapDemo) {
    largeMap = new LargeMap(map, search, true);
    start = largeMap.getRandomCell();
    finish = largeMap.getRandomCell();
    while(largeMap.distance(start, finish) < 150) {
      start = largeMap.getRandomCell();
      finish = largeMap.getRandomCell();
      }
    System.out.println("distance " + largeMap.distance(start, finish));
    largeMap.reset(start.x, start.y, finish.x, finish.y);
  }
  
  if(pathfindingDemo) {
    environment = new Environment(map, search);
    following = new KinematicFollowing(path, boid);
    boid = new KinematicBoid(following, position.x, position.y, environment);
    following.addBoid(boid);
    bread = new KinematicBreadcrumbs(boid);
  }
  
  // Configure processing
  frameRate(FRAME_RATE);
}

void draw(){
  
  int dt = millis() - latestTime;
  latestTime += dt;
  
  // Do planning update
  if(smallMapDemo) {
    simpleMap.update();
  } else if(largeMapDemo) {
     largeMap.update();
  }
  
  // Fill background
  background(255);
  
  // Draw grid
  if(smallMapDemo) {
    translate(simpleMap.scale, simpleMap.scale);
    simpleMap.render();
  } else if(largeMapDemo) {
     translate(largeMap.scale, largeMap.scale);
    largeMap.render();
  } else if(pathfindingDemo) {
     bread.update(dt);
    bread.render();
    boid.update(dt);
    pushMatrix();
    translate(boid.character.position.x, boid.character.position.y);
    rotate(-boid.character.orientation + PI/2);
    triangle(0, 0 - 80, 0 + 38, 0 - 10, 0 - 38, 0 - 10);
    ellipse(0, 0, 80, 80);
    fill(204, 0, 0);
    popMatrix();
    environment.render();
    boid.render();
  }
}
