class GameScene extends Scene {
  Player p;
  ArrayList<Bullet> bullets;
  ArrayList<Enemy> enemies;
  
  Timer pewTimer; // enemy spawn timer
  float pewTime = 0.5f;
  
  GameScene() {
    p = new Player(width/2, height/2, 250);
    objects.add(p);
    
    pewTimer = new Timer();
    pewTimer.start();
    
    tickTimer = new Timer();
    tickTimer.start();
    oldTickTime = tickTimer.currentTime();
    
    bullets = PoolManager.createPool("bullet", new Bullet(500, 150), 50);
    enemies = PoolManager.createPool("enemy", new Enemy(250, 20), 10);
  }
  
  void onEnter() {
    super.onEnter();
    
    objects.addAll(PoolManager.getPool("bullet"));
    objects.addAll(PoolManager.getPool("enemy"));
    
    HashSet hs = new HashSet(); //to prevent duplicates
                 hs.addAll(objects);
                 objects.clear();
                 objects.addAll(hs);
  }
  
  void input() {
    // scene actions
    if (Controls.keyDown(ESC)) SceneManager.setScene("menu");
    
    //player controools
    int inX = 0, inY = 0;
    if (Controls.keyPress(UP))    inY -= 1;
    if (Controls.keyPress(DOWN))  inY += 1;
    if (Controls.keyPress(LEFT))  inX -= 1;
    if (Controls.keyPress(RIGHT)) inX += 1;
    p.move(inX, inY);
    
    if (Controls.keyPress(' ')) p.shoot();
  }
  
  void update(float dt) {
    if (pewTimer.currentTime() >= pewTime) {
      ArrayList<PVector> waypoints = new ArrayList<PVector>();
      for (int i = 0; i < 5; i++) {
        waypoints.add(new PVector(random(width), random(height)));
      }
      
      Enemy someEnemy = (Enemy)PoolManager.reuseObject("enemy", random(width), random(height), 1, 0);
      someEnemy.make_waypoints(waypoints);
      pewTimer.restart();
    }
    
    for (int i = 0; i < objects.size(); i++) {
      GameObject go = objects.get(i);
      go.update(dt);
    }
    
    for (int i = 0; i < bullets.size(); i++) {
      Bullet b = bullets.get(i);
      if (b.active) {
        for (int j = 0; j < enemies.size(); j++) {
          Enemy e = enemies.get(j);
          if (e.active) {
            if (Physics.isCirclesTouch(b.pos, b.size/2, e.pos, e.size/2)) {
              b.destroy();
              e.destroy();
            }
          }
        }
      }
    }
  }
  
  void display() {
    background(0);
  
    for (int i = 0; i < objects.size(); i++) {
      GameObject go = objects.get(i);
      go.display();
    }
  }
}