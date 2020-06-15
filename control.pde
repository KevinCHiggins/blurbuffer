abstract class Control {
  int x;
  int y;
  int w;
  int h;
  String param;
  abstract void sendNotification(int relX, int relY);
  Observer[] observers = new Observer[10]; 
  int observersAmount;
  void addObserver(Observer o) {
    println("Attempting to add observer...");
    observers[observersAmount] = o;
    println("Added observer at index " + observersAmount);
    observersAmount++;
  }
  // let controls draw themselves... this is typically overridden
  void draw() {
    fill(230, 200, 5);
    rect(x, y, w, h);
    fill(0);
    text(param, x + 10, y + 15);
  }

  void removeObserver(Observer o) {
    println("Attempting to remove observer...");
    for (int i = 0; i < observersAmount; i++) {
      if (observers[i].equals(o)) {
        println("Removed observer from index " + i);
        observers[i] = observers[observersAmount];
        observersAmount--;
        continue;
      }
    }
  }
}
