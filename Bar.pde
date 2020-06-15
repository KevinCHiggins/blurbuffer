class Bar extends Control {
  int val;
  Bar(String tempCommand, int tempX1, int tempY1, int tempX2, int tempY2, int tempVal) {
    x = tempX1;
    y = tempY1;
    w = tempX2;
    h = tempY2;
    val = tempVal;
    param = tempCommand;  
  }
  @Override // because in the case of a Bar, we want it to report its initial value to the Observer!!
  void addObserver(Observer o) {
    println("Attempting to add observer...");
    observers[observersAmount] = o;
    println("Added observer at index " + observersAmount);
    observersAmount++;
    sendNotification(val, 0); // kinda silly - send in the current value so it can be saved again
  }  
  @Override
  void draw() {
    fill(140, 230, 130);
    rect(x, y, val, h);
    fill(0);
    text(param + ": " + (int) (val * 2.55), x + 10, y + 15);
  }
  void sendNotification(int relX, int relY) {
    for (int i = 0; i < observersAmount; i++) {
      val = relX;
      observers[i].onNotify(param, val);
    }
  }

  
}
