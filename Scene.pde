abstract class Scene {
  void onEnter() {}
  void onExit() {}
  
  abstract void input();
  abstract void update();
  abstract void display();
  
  void loop() {
    input();
    update();
    display();
  }
}