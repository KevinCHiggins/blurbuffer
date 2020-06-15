import processing.video.*;

// flame element blended with screen, then thickness added with darkened version that feathers off with decreasing luma

Movie flame;
int buttonX = 400;
Control[] controls = new Control[]{
  new Button("Thickness", buttonX, 40, 100, 20),
  new Bar("Crush Opaque", buttonX, 80, 100, 20, byteToPercentage(150)),
  new Bar("Thickness Brightness", buttonX, 120, 100, 20, 70),
  new Bar("Thickness Alpha", buttonX, 160, 100, 20, 70),
  new Bar("Crush Transparent", buttonX, 200, 100, 20, byteToPercentage(50)),
  new Button("Main", buttonX, 240, 100, 20),
  new Button("Glow", buttonX, 280, 100, 20),
  new Bar("Glow Alpha", buttonX, 320, 100, 20, 100)};
Observer o = new Observer();
PImage bg;
PImage src;
boolean needToUpdate = false;
PGraphics thicknessBuffer;
PGraphics glowBuffer;
int pixelAmount = 180 * 180;
float thicknessBrightness = 0.7;
float thicknessAlpha = 0.6;
float thicknessOpaqueLuma = 150;
float thicknessTransparentLuma = 50;
void setup() {
  controls[0].addObserver(o);
  controls[1].addObserver(o);
  controls[2].addObserver(o);
  controls[3].addObserver(o);
  controls[4].addObserver(o);
  controls[5].addObserver(o);
  controls[6].addObserver(o);
  controls[7].addObserver(o);

  src = loadImage("Coltrane Crisp Exposure.png");
  bg = createImage(640, 360, RGB);
  bg.set(-105, -50, src);
  size(640, 360);
  background(0);
  
  thicknessBuffer = createGraphics(180, 180);
  glowBuffer = createGraphics(180, 180);
  flame = new Movie(this, "Candle Loop Shorter Tweaked Cropped No Shrinking.mp4");
  flame.loop();
}

void draw() {
  if (needToUpdate) {
    thicknessBuffer.beginDraw();
    thicknessBuffer.loadPixels(); // avoid null pointer exception
    thicknessBuffer.background(0, 0);
    float luma;
    float newAlpha;
    for (int i = 0; i < pixelAmount; i++) {
      /// thickness...
      luma = 0.2126 * red(flame.pixels[i]) + green(flame.pixels[i]) * 0.7152 + blue(flame.pixels[i]) * 0.0722;
      if (luma > o.thicknessOpaqueLuma) newAlpha = 255; else {
        
        float scale = (255 / (o.thicknessOpaqueLuma - o.thicknessTransparentLuma));
        if (luma < o.thicknessTransparentLuma) newAlpha = 0; else newAlpha = (luma - o.thicknessTransparentLuma) * scale + o.thicknessTransparentLuma;
      }
      newAlpha = newAlpha * o.thicknessAlpha;
      thicknessBuffer.pixels[i] = color(red(flame.pixels[i]) * o.thicknessBrightness, green(flame.pixels[i]) * o.thicknessBrightness, blue(flame.pixels[i]) * o.thicknessBrightness, newAlpha);
    }
    thicknessBuffer.updatePixels();
    thicknessBuffer.endDraw();
    glowBuffer.beginDraw();
    glowBuffer.loadPixels();
    for (int i = 0; i < pixelAmount; i++) { // copy flame image/frame data into glowBuffer
      glowBuffer.pixels[i] = color(red(flame.pixels[i]), green(flame.pixels[i]), blue(flame.pixels[i]), 255);
    }
    glowBuffer.updatePixels();
    glowBuffer.filter(BLUR, 10);               // apply blur
    for (int i = 0; i < pixelAmount; i++) {   // apply alpha channel falloff according to luma
      luma = 0.2126 * red(glowBuffer.pixels[i]) + green(glowBuffer.pixels[i]) * 0.7152 + blue(glowBuffer.pixels[i]) * 0.0722;
      luma = 255 - ((255 - luma)*(255 - luma) / 255);
      luma = luma * o.glowAlpha;
      glowBuffer.pixels[i] = color(red(glowBuffer.pixels[i]), green(glowBuffer.pixels[i]), blue(glowBuffer.pixels[i]), luma);
    }
    glowBuffer.updatePixels();
    glowBuffer.endDraw();

    needToUpdate = false;
  }
  blendMode(BLEND);
  background(bg);
  for (int i = 0; i < controls.length; i++) {
    controls[i].draw();
  }
  if (o.showThickness) image(thicknessBuffer, 230, 179);
  blendMode(SCREEN);
  if (o.showMain) image(flame, 230, 179);
  blendMode(SCREEN);
  if (o.showGlow) image(glowBuffer, 230, 179);
  //image(flame, 0, 80);

}

color invert(color c) {
  
  return(color(255 - red(c), 255 - green(c), 255 - blue(c)));
}

void mouseClicked() {
  for(int i = 0; i < controls.length; i++) {
    Control c = controls[i];
    
    if (mouseX >= c.x && mouseX <c.x + c.w && mouseY >= c.y && mouseY <c.y + c.h) {
      c.sendNotification(mouseX - c.x, mouseY - c.y); // send in relative mouse coordinates - not used by Button, but used by Bar
    }
  }
}

void movieEvent(Movie flame) {
  flame.read(); 
  needToUpdate = true;
}
int byteToPercentage(int byteValue) {
  return (int) (byteValue / 2.55); 
}
