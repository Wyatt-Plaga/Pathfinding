class SimpleMap {
  
  //size of squares in window
  float scale = 30f;
  
  boolean[][] map;
  Node[][] graph;
  
  GraphSearch<GridCell> search;
  Node start = null;
  Node goal = null;
  
  SimpleMap(boolean[][] map, GraphSearch search) {
    this(map, search, false);
  }
  
  SimpleMap(boolean[][] map, GraphSearch search, boolean diagonal) {
    this.map = map;
    this.search = search;
    
    // Initialize graph
    graph = new Node[map.length][map[0].length];
    
    //for(int y=0; y < map.length; ++y)
    //  for(int x=0; x < map[y].length; ++x)
    //    graph[y][x] = new Node(new GridCell(x,y));
    
    graph[2][3] = new Node(new GridCell(3,2));
    graph[31][28] = new Node(new GridCell(28,31));
    
     
    graph[4][6] = new Node(new GridCell(6,4)); 
    graph[1][27] = new Node(new GridCell(27,1));
    graph[31][24] = new Node(new GridCell(24,31)); 
    graph[13][8] = new Node(new GridCell(8,13));
    graph[31][23] = new Node(new GridCell(23,31));
    graph[2][33] = new Node(new GridCell(33,2));
    graph[13][28] = new Node(new GridCell(28,13));
    graph[32][4] = new Node(new GridCell(4,32));
    graph[19][26] = new Node(new GridCell(26,19));
    graph[4][24] = new Node(new GridCell(24,4));
    graph[29][23] = new Node(new GridCell(23,29));
    graph[37][18] = new Node(new GridCell(18,37));
    graph[13][34] = new Node(new GridCell(34,13));
    graph[31][8] = new Node(new GridCell(8,31));
    graph[28][11] = new Node(new GridCell(11,28));
    graph[26][27] = new Node(new GridCell(27,26));
    graph[31][37] = new Node(new GridCell(37,31));
    graph[24][34] = new Node(new GridCell(34,24));
    graph[10][35] = new Node(new GridCell(35,10));    
    graph[38][37] = new Node(new GridCell(37,38));
    graph[4][37] = new Node(new GridCell(37,4));
    graph[27][10] = new Node(new GridCell(10,27));
    graph[12][1] = new Node(new GridCell(1,12));
    graph[23][1] = new Node(new GridCell(1,23));
    graph[34][2] = new Node(new GridCell(2,34));
    graph[9][3] = new Node(new GridCell(3,9));
    graph[23][10] = new Node(new GridCell(10,23));
    graph[16][24] = new Node(new GridCell(24,16));
    graph[28][23] = new Node(new GridCell(23,28));
    
    graph[4][6].edgeToAndFrom(graph[2][3], (distance(graph[4][6].value, graph[2][3].value)));
    graph[4][6].edgeToAndFrom(graph[9][3], (distance(graph[4][6].value, graph[9][3].value)));
    graph[4][6].edgeToAndFrom(graph[13][8], (distance(graph[4][6].value, graph[13][8].value)));
    
    graph[2][3].edgeToAndFrom(graph[9][3], (distance(graph[2][3].value, graph[9][3].value)));
    graph[2][3].edgeToAndFrom(graph[12][1], (distance(graph[2][3].value, graph[12][1].value)));
    graph[2][3].edgeToAndFrom(graph[13][8], (distance(graph[2][3].value, graph[13][8].value)));
    
    graph[9][3].edgeToAndFrom(graph[12][1], (distance(graph[9][3].value, graph[12][1].value)));
    graph[9][3].edgeToAndFrom(graph[13][8], (distance(graph[9][3].value, graph[13][8].value)));
    graph[9][3].edgeToAndFrom(graph[23][1], (distance(graph[9][3].value, graph[23][1].value)));
    graph[9][3].edgeToAndFrom(graph[23][10], (distance(graph[9][3].value, graph[23][10].value)));
    
    graph[12][1].edgeToAndFrom(graph[13][8], (distance(graph[12][1].value, graph[13][8].value)));
    graph[12][1].edgeToAndFrom(graph[23][1], (distance(graph[12][1].value, graph[23][1].value)));
    graph[12][1].edgeToAndFrom(graph[23][10], (distance(graph[12][1].value, graph[23][10].value)));
    
    graph[13][8].edgeToAndFrom(graph[23][1], (distance(graph[13][8].value, graph[23][1].value)));
    graph[13][8].edgeToAndFrom(graph[23][10], (distance(graph[13][8].value, graph[23][10].value)));
    
    graph[23][1].edgeToAndFrom(graph[23][10], (distance(graph[23][1].value, graph[23][10].value)));
    graph[23][1].edgeToAndFrom(graph[27][10], (distance(graph[23][1].value, graph[27][10].value)));
    graph[23][1].edgeToAndFrom(graph[31][8], (distance(graph[23][1].value, graph[31][8].value)));
    graph[23][1].edgeToAndFrom(graph[32][4], (distance(graph[23][1].value, graph[32][4].value)));
    
    graph[23][10].edgeToAndFrom(graph[27][10], (distance(graph[23][10].value, graph[27][10].value)));
    graph[23][10].edgeToAndFrom(graph[28][11], (distance(graph[23][10].value, graph[28][11].value)));
    graph[23][10].edgeToAndFrom(graph[31][8], (distance(graph[23][10].value, graph[31][8].value)));
    
    graph[27][10].edgeToAndFrom(graph[28][11], (distance(graph[27][10].value, graph[28][11].value)));
    graph[27][10].edgeToAndFrom(graph[31][8], (distance(graph[27][10].value, graph[31][8].value)));
    
    graph[31][8].edgeToAndFrom(graph[28][11], (distance(graph[31][8].value, graph[28][11].value)));
    graph[31][8].edgeToAndFrom(graph[32][4], (distance(graph[31][8].value, graph[32][4].value)));
    
    graph[34][2].edgeToAndFrom(graph[31][8], (distance(graph[34][2].value, graph[31][8].value)));
    graph[34][2].edgeToAndFrom(graph[23][1], (distance(graph[34][2].value, graph[23][1].value)));
    
    graph[28][11].edgeToAndFrom(graph[28][23], (distance(graph[28][11].value, graph[28][23].value)));
    graph[28][11].edgeToAndFrom(graph[29][23], (distance(graph[28][11].value, graph[29][23].value)));
    graph[28][11].edgeToAndFrom(graph[31][23], (distance(graph[28][11].value, graph[31][23].value)));
    
    graph[31][23].edgeToAndFrom(graph[37][18], (distance(graph[31][23].value, graph[37][18].value)));
    graph[31][23].edgeToAndFrom(graph[31][24], (distance(graph[31][23].value, graph[31][24].value)));
    graph[31][23].edgeToAndFrom(graph[29][23], (distance(graph[31][23].value, graph[29][23].value)));
    
    graph[31][24].edgeToAndFrom(graph[29][23], (distance(graph[31][24].value, graph[29][23].value)));
    graph[31][24].edgeToAndFrom(graph[31][28], (distance(graph[31][24].value, graph[31][28].value)));    
    
    graph[31][28].edgeToAndFrom(graph[26][27], (distance(graph[31][28].value, graph[26][27].value))); 
    graph[31][28].edgeToAndFrom(graph[24][34], (distance(graph[31][28].value, graph[24][34].value))); 
    graph[31][28].edgeToAndFrom(graph[31][37], (distance(graph[31][28].value, graph[31][37].value))); 
    graph[31][28].edgeToAndFrom(graph[38][37], (distance(graph[31][28].value, graph[38][37].value))); 
    
    graph[31][37].edgeToAndFrom(graph[38][37], (distance(graph[31][37].value, graph[38][37].value))); 
    graph[31][37].edgeToAndFrom(graph[24][34], (distance(graph[31][37].value, graph[24][34].value))); 
    graph[31][37].edgeToAndFrom(graph[26][27], (distance(graph[31][37].value, graph[26][27].value))); 
    
    graph[24][34].edgeToAndFrom(graph[26][27], (distance(graph[24][34].value, graph[26][27].value))); 
    graph[24][34].edgeToAndFrom(graph[19][26], (distance(graph[24][34].value, graph[19][26].value)));
    graph[24][34].edgeToAndFrom(graph[13][34], (distance(graph[24][34].value, graph[13][34].value))); 
    
    graph[19][26].edgeToAndFrom(graph[26][27], (distance(graph[19][26].value, graph[26][27].value)));
    graph[19][26].edgeToAndFrom(graph[16][24], (distance(graph[19][26].value, graph[16][24].value)));
    graph[19][26].edgeToAndFrom(graph[13][28], (distance(graph[19][26].value, graph[13][28].value)));
    
    graph[13][28].edgeToAndFrom(graph[16][24], (distance(graph[13][28].value, graph[16][24].value)));
    graph[13][28].edgeToAndFrom(graph[13][34], (distance(graph[13][28].value, graph[13][34].value)));
    graph[13][28].edgeToAndFrom(graph[10][35], (distance(graph[13][28].value, graph[10][35].value)));
    
    graph[13][34].edgeToAndFrom(graph[19][26], (distance(graph[13][34].value, graph[19][26].value)));
    graph[13][34].edgeToAndFrom(graph[10][35], (distance(graph[13][34].value, graph[10][35].value)));
    
    graph[4][37].edgeToAndFrom(graph[10][35], (distance(graph[4][37].value, graph[10][35].value)));
    graph[4][37].edgeToAndFrom(graph[2][33], (distance(graph[4][37].value, graph[2][33].value)));
    
    graph[2][33].edgeToAndFrom(graph[10][35], (distance(graph[2][33].value, graph[10][35].value)));
    graph[2][33].edgeToAndFrom(graph[1][27], (distance(graph[2][33].value, graph[1][27].value)));
    graph[2][33].edgeToAndFrom(graph[4][24], (distance(graph[2][33].value, graph[4][24].value)));
    
    graph[1][27].edgeToAndFrom(graph[4][24], (distance(graph[1][27].value, graph[4][24].value)));
  }
  
  float distance(GridCell start, GridCell goal) {
    float distanceSquared = (float) (Math.pow((goal.x - start.x),2) + Math.pow((goal.y - start.y),2));
    return sqrt(distanceSquared);
  }
   
  void reset(int startX, int startY, int goalX, int goalY) {
    start = graph[startY][startX];
    goal = graph[goalY][goalX];
    
    search.reset(start, goal);
  }
  
  void update() {
    search.update();
  }
  
  void render() {
    
    // Draw map
    stroke(0,0,0);
    
    for(int y=0; y < map.length; ++y) {
      for(int x=0; x < map[y].length; ++x) {
        if(map[y][x]) {
          fill(0,0,0);
        } else {
          fill(255,255,255);
          square(x * scale, y * scale, scale);
        }
      }
    }
        
    // Draw path if available
    List<Edge> path = search.shortestPath();
    
    if(null != path) {
      strokeWeight(10);
      stroke(200, 200, 0);
      
      for(Edge edge : path) {
        float sx = edge.start.value.x * scale + 0.5 * scale;
        float sy = edge.start.value.y * scale + 0.5 * scale;
        float ex = edge.end.value.x * scale + 0.5 * scale;
        float ey = edge.end.value.y * scale + 0.5 * scale; 
        line(sx, sy, ex, ey);
      }
      
      strokeWeight(1);
    }
    
    //Draw all nodes
    for(int y=0; y < map.length; ++y)
      for(int x=0; x < map[y].length; ++x)
        if(graph[y][x] != null) {
          noStroke();
        fill(0,32,255);
        circle(x * scale + 0.5 * scale, 
        y * scale  + 0.5 * scale, 0.8 * scale);
        text("x " + x,x * scale,y * scale);
        text("y " + y,x * scale + 20,y * scale);
        }
        
    //Draw all edges
    for(int y=0; y < map.length; ++y)
      for(int x=0; x < map[y].length; ++x)
        if(graph[y][x] != null) {
          for(int z=0; z < graph[y][x].outgoing.size(); z++) {
            strokeWeight(1);
            stroke(200, 200, 0);
            float sx = graph[y][x].outgoing.get(z).start.value.x * scale + 0.5 * scale;
            float sy = graph[y][x].outgoing.get(z).start.value.y * scale + 0.5 * scale;
            float ex = graph[y][x].outgoing.get(z).end.value.x * scale + 0.5 * scale;
            float ey = graph[y][x].outgoing.get(z).end.value.y * scale + 0.5 * scale;
            line(sx, sy, ex, ey);
          }
          strokeWeight(1);
        }
    // Draw open and closed sets if available
    Collection<Node> open = search.openSet();
    
    if(null != open) {
      noStroke();
      fill(0, 180, 255);
      
      //int number = 0;
      for(Node node : open) {
        //System.out.println("Hello " + number);
        circle(node.value.x * scale + 0.5 * scale, 
          node.value.y * scale  + 0.5 * scale, 0.8 * scale);
          //number++;
      }
    }
    
    Collection<Node> closed = search.closedSet();
    
    if(null != closed) {
      noStroke();
      fill(100, 100, 100);
      
      for(Node node : closed)
        circle(node.value.x * scale + 0.5 * scale, 
          node.value.y * scale  + 0.5 * scale, 0.8 * scale);
    }
    
    // Draw start and goal
    if(null != start) {
      noStroke();
      fill(255,0,0);
      circle(start.value.x * scale + 0.5 * scale, 
        start.value.y * scale  + 0.5 * scale, 0.8 * scale);
    }
    
    if(null != goal) {
      noStroke();
      fill(0,255,0);
      circle(goal.value.x * scale + 0.5 * scale, 
        goal.value.y * scale + 0.5 * scale, 0.8 * scale);
    }   
    
  }
}
