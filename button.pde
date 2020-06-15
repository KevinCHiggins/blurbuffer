class Button extends Control {
  boolean on = true;
  Button(String tempCommand, int tempX1, int tempY1, int tempX2, int tempY2) {
    x = tempX1;
    y = tempY1;
    w = tempX2;
    h = tempY2;
    param = tempCommand;  
    
  }
  void draw() {
    fill(230, 200, 5);
    if (!on) fill(140, 140, 140);
    rect(x, y, w, h);
    fill(0);
    text(param, x + 10, y + 15);
  }
  void sendNotification(int relX, int relY) {
    for (int i = 0; i < observersAmount; i++) {
      on = !on;
      observers[i].onNotify(param);
    }
  }

  
}
