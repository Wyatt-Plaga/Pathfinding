class Environment {
  
  float scale = 40f;
    
    boolean[][] map;
    Node[][] graph;
    
    GraphSearch search;
    Node start = null;
    Node goal = null;
  
  Environment(boolean[][] map, GraphSearch search) {
      this.map = map;
      this.search = search;
      
      // Initialize graph
    graph = new Node[map.length][map[0].length];
    
    for(int i=0; i<map.length;i++) {
      for(int j=0; j<map.length;j++) {
        if((i==13 || i == 12 || i == 11) && j<11) {
        } else if((j==13 || j==14 || j == 15) && (i<16 || i>17)) {
        } else if((i >= 6 && i <= 10) && (j >= 19 && j <= 24)) {
        } else if((i >= 19 && i <= 26) && (j == 7 || j ==8)) {
        } else if((j >= 4 && j <= 11) && (i == 22 || i ==23)) {
        } else if((i >= 20 && i <= 27) && (j >= 25 && j <= 27)) {
        } else if((i == 23 || i == 24) && (j >= 22 && j <= 27)) {
        } else if((i >= 7 && i <= 11) && (j >= 29)) {
        } else if((i >= 11 && i <= 13) && (j >= 26 && j <= 29)) {
        } else if((i >= 13 && i <= 15) && (j >= 23 && j <= 26)) {
        } else if((i >= 16 && i <= 18) && (j >= 20 && j <= 23)) {
        } else if((i >= 18 && i <= 20) && (j >= 18 && j <= 20)) {
        } else {
          graph[j][i] = new Node(new GridCell(i,j));
        }
      }
    }
    
        // Construct UP edges
    for(int y=0; y < map.length - 1; ++y)
      for(int x=0; x < map[y].length; ++x)
        if(graph[y + 1][x] != null && graph[y][x] != null)
          graph[y][x].edgeTo(graph[y + 1][x], 1.0f);
    
    // Construct DOWN edges
    for(int y=1; y < map.length; ++y)
      for(int x=0; x < map[y].length; ++x)
        if(graph[y - 1][x] != null && graph[y][x] != null)
          graph[y][x].edgeTo(graph[y - 1][x], 1.0f);
        
    // Construct LEFT edges
    for(int y=0; y < map.length; ++y)
      for(int x=1; x < map[y].length; ++x)
        if(graph[y][x - 1] != null && graph[y][x] != null)
          graph[y][x].edgeTo(graph[y][x - 1], 1.0f);
        
    // Construct RIGHT edges
    for(int y=0; y < map.length; ++y)
      for(int x=0; x < map[y].length - 1; ++x)
        if(graph[y][x + 1] != null && graph[y][x] != null)
          graph[y][x].edgeTo(graph[y][x + 1], 1.0f);
        
    if(true) {
      float root = sqrt(2.0f);
      
      // Construct UP-LEFT edges
      for(int y=0; y < map.length - 1; ++y)
        for(int x=1; x < map[y].length; ++x)
          if(graph[y + 1][x - 1] != null && graph[y][x] != null)
            graph[y][x].edgeTo(graph[y + 1][x - 1], root);
      
      // Construct UP-RIGHT edges
      for(int y=0; y < map.length - 1; ++y)
        for(int x=0; x < map[y].length - 1; ++x)
          if(graph[y + 1][x + 1] != null && graph[y][x] != null)
            graph[y][x].edgeTo(graph[y + 1][x + 1], root);

      // Construct DOWN-LEFT edges
      for(int y=1; y < map.length; ++y)
        for(int x=1; x < map[y].length; ++x)
          if(graph[y - 1][x - 1] != null && graph[y][x] != null)
            graph[y][x].edgeTo(graph[y - 1][x - 1], root);
      
      // Construct DOWN-RIGHT edges
      for(int y=1; y < map.length; ++y)
        for(int x=0; x < map[y].length - 1; ++x)
          if(graph[y - 1][x + 1] != null && graph[y][x] != null)
            graph[y][x].edgeTo(graph[y - 1][x + 1], root);
    }
 
   


    
    }
    
  float distance(GridCell start, GridCell goal) {
    float distanceSquared = (float) (Math.pow((goal.x - start.x),2) + Math.pow((goal.y - start.y),2));
    return sqrt(distanceSquared);
  }
  
  float distanceGeneric(int startX, int startY, int endX, int endY) {
    float distanceSquared = (float) (Math.pow((endX - startX),2) + Math.pow((endY - startY),2));
    return sqrt(distanceSquared);
  }
  
  Node findClosestNode(locationData location) {
    float leastDistance = 10000;
    Node closestNode = null;
    for(int y=0; y < map.length; ++y)
      for(int x=0; x < map[y].length; ++x)
        if(graph[y][x] != null) {
          if(distanceGeneric((int) graph[y][x].value.x, (int) graph[y][x].value.y, (int) (location.position.x / scale), (int) (location.position.y / scale)) < leastDistance) {
            leastDistance = distanceGeneric((int) graph[y][x].value.x, (int) graph[y][x].value.y, (int) (location.position.x / scale), (int) (location.position.y / scale));
            closestNode = graph[y][x];
          }
        }
    return closestNode;
  }
  
  void render() {
    
    // Draw map
    stroke(0,0,0);
    
    //for(int y=0; y < 40; ++y) {
    //  for(int x=0; x < 40; ++x) {
    //      fill(255,255,255);
    //      square(x * scale, y * scale, scale);
    //      stroke(50,50,50);
    //      fill(50);
    //      text((x + "," + y), x * scale, y * scale);
    //  }
    //}
    
    stroke(0,0,0);
    fill(0,0,0);
    rect(0, 14 * scale, 14 * scale, scale);
    rect(20 * scale, 14 * scale, 20 * scale, scale);
    rect(13 * scale, 0, scale,  10 * scale);
    
    quad(20 * scale, 19 * scale, 21 * scale, 20 * scale, 10 * scale, 31 * scale, 8 * scale, 31 * scale);
    
    square(7 * scale, 20 * scale, 3 * scale);
    
    quad(23 * scale, 11 * scale, 26 * scale, 8 * scale, 23 * scale, 5 * scale, 20 * scale, 8 * scale);
    
    triangle(21 * scale, 26 * scale, 24 * scale, 23 * scale, 27 * scale, 26 * scale);
    
    
    
    //stroke(0,0,0);
    //fill(100,0,0, 127);
    //quad(0, 0, 0 * scale, 14 * scale, 13 * scale, 14 * scale, 13 * scale, 0);
    
    //fill(0,100,0, 127);
    //quad(13 * scale, 10 * scale, 13 * scale, 14 * scale, 14 * scale, 14 * scale, 14 * scale, 10 * scale);
    
    //fill(100,0,0, 127);
    //quad(14 * scale, 14 * scale, 14 * scale, 0 * scale, 20 * scale, 0 * scale, 20 * scale, 14 * scale);
    
    //fill(0,100,0, 127);
    //quad(20 * scale, 5 * scale, 20 * scale, 0 * scale, 31 * scale, 0 * scale, 31 * scale, 5 * scale);
    
    //fill(100,0,0, 127);
    //quad(26 * scale, 5 * scale, 31 * scale, 5 * scale, 31 * scale, 14 * scale, 26 * scale, 14 * scale);
    
    //fill(0,100,0, 127);
    //quad(20 * scale, 11 * scale, 20 * scale, 14 * scale, 26 * scale, 14 * scale, 26 * scale, 11 * scale);
    
    //fill(0,100,0, 127);
    //quad(14 * scale, 14 * scale, 20 * scale, 14 * scale, 20 * scale, 15 * scale, 14 * scale, 15 * scale);
    
    //fill(100,0,0, 127);
    //quad(0 * scale, 15 * scale, 31 * scale, 15 * scale, 31 * scale, 19 * scale, 0 * scale, 19 * scale);  
    
    //fill(0,0,100, 127);
    //triangle(10 * scale, 29 * scale, 10 * scale, 19 * scale, 20 * scale, 19 * scale);
      
    //fill(0,0,100, 127);
    //triangle(20 * scale, 11 * scale, 20 * scale, 8 * scale, 23 * scale, 11 * scale);
    
    //fill(0,0,100, 127);
    //triangle(20 * scale, 5 * scale, 20 * scale, 8 * scale, 23 * scale, 5 * scale);
    
    //fill(0,0,100, 127);
    //triangle(26 * scale, 5 * scale, 26 * scale, 8 * scale, 23 * scale, 5 * scale);
      
    //fill(0,0,100, 127);
    //triangle(23 * scale, 11 * scale, 26 * scale, 11 * scale, 26 * scale, 8 * scale);
      
    //fill(0,100,0, 127);
    //quad(0 * scale, 19 * scale, 0 * scale, 20 * scale, 10 * scale, 20 * scale, 10 * scale, 19 * scale);    
      
    //fill(100,0,0, 127);
    //quad(0 * scale, 20 * scale, 7 * scale, 20 * scale, 7 * scale, 31 * scale, 0 * scale, 31 * scale);    
      
    //fill(0,100,0, 127);
    //quad(7 * scale, 23 * scale, 10 * scale, 23 * scale, 10 * scale, 29 * scale, 7 * scale, 29 * scale);  
    
    //fill(0,0,100, 127);
    //quad(7 * scale, 31 * scale, 7 * scale, 29 * scale, 8 * scale, 29 * scale, 8 * scale, 32 * scale);  
      
    //fill(100,0,0, 127);
    //triangle(8 * scale, 31 * scale, 8 * scale, 29 * scale, 10 * scale, 29 * scale);  
    
    //fill(0,0,100, 127);
    //triangle(10 * scale, 31 * scale, 21 * scale, 31 * scale, 21 * scale, 20 * scale);  
      
    //fill(0,100,0, 127);
    //quad(27 * scale, 19 * scale, 31 * scale, 19 * scale, 31 * scale, 31 * scale, 27 * scale, 31 * scale);
    
    //fill(100,0,0, 127);
    //quad(21 * scale, 26 * scale, 21 * scale, 31 * scale, 27 * scale, 31 * scale, 27 * scale, 26 * scale);
    
    //fill(50,50,50, 127);
    //quad(21 * scale, 19 * scale, 27 * scale, 19 * scale, 27 * scale, 23 * scale, 21 * scale, 23 * scale);    
      
    //fill(0,100,0, 127);
    //triangle(20 * scale, 19 * scale, 21 * scale, 19 * scale, 21 * scale, 20 * scale);  
    
    //fill(100,0,0, 127);
    //triangle(21 * scale, 23 * scale, 24 * scale, 23 * scale, 21 * scale, 26 * scale);
    
    //fill(0,0,100, 127);
    //triangle(24 * scale, 23 * scale, 27 * scale, 23 * scale, 27 * scale, 26 * scale);  
      
    //Draw all nodes
    //for(int y=0; y < map.length; ++y)
    //  for(int x=0; x < map[y].length; ++x)
    //    if(graph[y][x] != null) {
    //      noStroke();
    //    fill(0,32,255);
    //    circle(x * scale + 0.5 * scale, 
    //    y * scale  + 0.5 * scale, 0.8 * scale);
    //    text("x " + x,x * scale,y * scale);
    //    text("y " + y,x * scale + 20,y * scale);
    //    }
        
    ////Draw all edges
    //for(int y=0; y < map.length; ++y)
    //  for(int x=0; x < map[y].length; ++x)
    //    if(graph[y][x] != null) {
    //      for(int z=0; z < graph[y][x].outgoing.size(); z++) {
    //        strokeWeight(1);
    //        stroke(200, 200, 0);
    //        float sx = graph[y][x].outgoing.get(z).start.value.x * scale + 0.5 * scale;
    //        float sy = graph[y][x].outgoing.get(z).start.value.y * scale + 0.5 * scale;
    //        float ex = graph[y][x].outgoing.get(z).end.value.x * scale + 0.5 * scale;
    //        float ey = graph[y][x].outgoing.get(z).end.value.y * scale + 0.5 * scale;
    //        float midX = (sx + ex) / 2;
    //        float midY = (sy + ey) / 2;
    //        line(sx, sy, ex, ey);
    //        fill(50);
    //        text("weight: " + graph[y][x].outgoing.get(z).weight,midX,midY);
    //      }
    //      strokeWeight(1);
    //    }  
      
      
    }
}
