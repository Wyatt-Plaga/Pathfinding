class AStarTag implements Comparable<AStarTag> {
  Node node;
  
  float ctg;
  float dfs;
  float totalScore;
  Edge edge;
  
  AStarTag(Node node, float ctg, float dfs, Edge edge) {
    this.node = node;
    this.ctg = ctg;
    this.dfs = dfs;
    this.edge = edge;
    this.totalScore = ctg + dfs;
  }
  
  int compareTo(AStarTag o) {
    if((this.ctg + this.dfs) < (o.ctg + o.dfs)) {
      return -1;
    }
    else if((this.ctg + this.dfs) > (o.ctg + o.dfs)) {
      return 1;
    }
    else
      return 0;
  }
}

class AStar implements GraphSearch {
  Heuristic heuristic; 
  
  Node goal;
  
  HashMap<Node,AStarTag> tags;
  
  PriorityQueue<AStarTag> open;
  HashSet<Node> closed;
  
  AStar(Heuristic heuristic) {
    this.heuristic = heuristic;
  }
  
  void reset(Node start, Node goal) {
    this.goal = goal;
    
    tags = new HashMap<Node,AStarTag>();
  
    open = new PriorityQueue<AStarTag>();
    closed = new HashSet<Node>();
    
    AStarTag tag = new AStarTag(start, heuristic.value(start.value, goal.value), 0, null);
    tags.put(start, tag);
    open.add(tag);
  }
  
  void update() {
    if(!tags.containsKey(goal)) {
       AStarTag tag = open.poll();
       
       if(null != tag && !closed.contains(tag.node)) {
          for(Edge edge : tag.node.outgoing) {
            if(!tags.containsKey(edge.end)) {
              float ctg = heuristic.value(edge.end.value, goal.value);
              AStarTag next_tag = new AStarTag(edge.end, ctg, (tag.dfs + edge.weight), edge);
              tags.put(edge.end, next_tag);
              open.add(next_tag);
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
      
      AStarTag tag = tags.get(goal);
      
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
    
      for(AStarTag tag : open)
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
