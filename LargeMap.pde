  class LargeMap {
    
    //size of squares in window
    float scale = 4f;
    
    boolean[][] map;
    Node[][] graph;
    boolean done = false;
    boolean done2 = false;
    
    Long startTime;
    Long endTime;
    
    GraphSearch<GridCell> search;
    Node start = null;
    Node goal = null;
    
    LargeMap(boolean[][] map, GraphSearch search) {
      this(map, search, false);
    }
    
    LargeMap(boolean[][] map, GraphSearch search, boolean diagonal) {
      this.map = map;
      this.search = search;
      
      // Initialize graph
      graph = new Node[map.length][map[0].length];
      
      //for(int y=0; y < map.length; ++y)
      //  for(int x=0; x < map[y].length; ++x)
      //    graph[y][x] = new Node<GridCell>(new GridCell(x,y));
      
      for(int i=0; i<10000; i++) {
        int y = getRandomNumber();
        int x = getRandomNumber();
        if(graph[y][x]==null) {
          graph[y][x] = new Node(new GridCell(x,y));
        }
      }
      
      for(int i=0; i<300; i++) {
        for(int j=0; j<300; j++) {
          if(graph[j][i]!=null) {
            findFourClose(j,i, graph[j][i]);
          }
        }
      }      
    }
    
    GridCell getRandomCell() {
      int randomX = getRandomNumber(299,0);
      int randomY = getRandomNumber(299,0);
      while(graph[randomY][randomX] == null) {
        randomX = getRandomNumber(299,0);
        randomY = getRandomNumber(299,0);
      }
      GridCell cell = new GridCell(randomX, randomY);
      return cell;
    }
    
    void findFourClose(int j,int i, Node node) {
      float max = 1;
      float min = -1;
      while(node.incoming.size() <= 3) {
        int random1 = getRandomNumber((int)max, (int)min);
        int composite1 = random1 + j;
        int random2 = getRandomNumber((int)max, (int)min);
        int composite2 = random2 + i;
        max += 0.1;
        min -= 0.1;
        if(composite1 < 0) {
          composite1 = 0;
        }
        if(composite2 < 0) {
          composite2 = 0;
        }
        if(composite1 > 299) {
          composite1 = 299;
        }
        if(composite2 > 299) {
          composite2 = 299;
        }
        if(composite1 == j && composite2 == i) {
          continue;
        }
        if(graph[composite1][composite2] != null) {
          graph[j][i].edgeToAndFrom(graph[composite1][composite2], (distance(graph[j][i].value, graph[composite1][composite2].value)));
        }
      }
      
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
    
    int getRandomNumber() {
      return (int) ((Math.random() * (299 - 0)));
    }
    
    int getRandomNumber(int max, int min) {
      return (int) ((Math.random() * (max - min)) + min);
    }
    
    void render() {
      
      if(startTime == null) {
        startTime = System.nanoTime();
      }
          
      // Draw path if available
      List<Edge> path = search.shortestPath();
      
      if(null != path) {
        endTime = System.nanoTime();
        System.out.println("Time elapsed " + (((long)endTime - (long)startTime) / (long)1000000000));
        if(done == true) {
          done2 = true;
        }
        done = true;
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
      
      int nodes = 0;
      if(null != path) {
        //Draw all nodes
      for(int y=0; y < map.length; ++y)
        for(int x=0; x < map[y].length; ++x)
          if(graph[y][x] != null) {
            nodes++;
            noStroke();
          fill(0,32,255);
          circle(x * scale + 0.5 * scale, 
          y * scale  + 0.5 * scale, 0.8 * scale);
          }
          
      System.out.println(nodes + " nodes");
          
      //Draw all edges
      int edges = 0;
      for(int y=0; y < map.length; ++y)
        for(int x=0; x < map[y].length; ++x)
          if(graph[y][x] != null) {
            for(int z=0; z < graph[y][x].outgoing.size(); z++) {
              edges++;
              strokeWeight(1);
              stroke(200, 200, 0);
              float sx = graph[y][x].outgoing.get(z).start.value.x * scale + 0.5 * scale;
              float sy = graph[y][x].outgoing.get(z).start.value.y * scale + 0.5 * scale;
              float ex = graph[y][x].outgoing.get(z).end.value.x * scale + 0.5 * scale;
              float ey = graph[y][x].outgoing.get(z).end.value.y * scale + 0.5 * scale;
              float midX = (sx + ex) / 2;
              float midY = (sy + ey) / 2;
              line(sx, sy, ex, ey);
            }
            strokeWeight(1);
          }
          System.out.println(edges + " edges");
      }
      
          
       //Draw open and closed sets if available
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
        if(path != null) {
          System.out.println("open size " + open.size());
        }
      }
      
      Collection<Node> closed = search.closedSet();
      
      if(null != closed) {
        noStroke();
        fill(100, 100, 100);
        
        for(Node node : closed)
          circle(node.value.x * scale + 0.5 * scale, 
            node.value.y * scale  + 0.5 * scale, 0.8 * scale);
            if(path != null) {
              System.out.println("closed size " + closed.size());
            }
      }
      
      
      // Draw start and goal
      if(null != start) {
        noStroke();
        fill(255,0,0);
        circle(start.value.x * scale + 0.5 * scale, 
          start.value.y * scale  + 0.5 * scale, 10.8 * scale);
      }
      
      if(null != goal) {
        noStroke();
        fill(0,255,0);
        circle(goal.value.x * scale + 0.5 * scale, 
          goal.value.y * scale + 0.5 * scale, 10.8 * scale);
      }   
      
    }
  }
