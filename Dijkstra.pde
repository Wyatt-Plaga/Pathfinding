class DijkstraTag implements Comparable<DijkstraTag> {
  Node node;
  
  float ctg;
  float dfs;
  float totalScore;
  Edge edge;
  
  DijkstraTag(Node node, float ctg, float dfs, Edge edge) {
    this.node = node;
    this.ctg = ctg;
    this.dfs = dfs;
    this.edge = edge;
    this.totalScore = ctg + dfs;
  }
  
  int compareTo(DijkstraTag o) {
    if(this.dfs < o.dfs) {
      return -1;
    }
    else if(this.dfs > o.dfs) {
      return 1;
    }
    else
      return 0;
  }
}

class Dijkstra implements GraphSearch {
  Heuristic heuristic; 
  
  Node goal;
  
  HashMap<Node,DijkstraTag> tags;
  
  PriorityQueue<DijkstraTag> open;
  HashSet<Node> closed;
  
  Dijkstra(Heuristic heuristic) {
    this.heuristic = heuristic;
  }
  
  void reset(Node start, Node goal) {
    this.goal = goal;
    
    tags = new HashMap<Node,DijkstraTag>();
  
    open = new PriorityQueue<DijkstraTag>();
    closed = new HashSet<Node>();
    
    DijkstraTag tag = new DijkstraTag(start, heuristic.value(start.value, goal.value), 0, null);
    tags.put(start, tag);
    open.add(tag);
  }
  
  void update() {
    if(!tags.containsKey(goal)) {
       DijkstraTag tag = open.poll();
       
       if(null != tag && !closed.contains(tag.node)) {
          for(Edge edge : tag.node.outgoing) {
            if(!tags.containsKey(edge.end)) {
              float ctg = heuristic.value(edge.end.value, goal.value);
              DijkstraTag next_tag = new DijkstraTag(edge.end, ctg, (tag.dfs + edge.weight), edge);
              //System.out.println("Total score of " + next_tag.totalScore);
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
      
      DijkstraTag tag = tags.get(goal);
      
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
    
      for(DijkstraTag tag : open)
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
