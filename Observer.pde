class Observer {
  boolean showMain = true;
  boolean showGlow = true;
  boolean showThickness = true;
  int thicknessOpaqueLuma;
  int thicknessTransparentLuma;
  float thicknessBrightness;
  float thicknessAlpha;
  float glowAlpha;
 void onNotify(String command) {
   switch(command)
   {
     case "Main":  showMain = !showMain;
                   break;
     case "Glow":  showGlow = !showGlow;
                   break;
     case "Thickness":  showThickness = !showThickness;
                   break;
   }
 }
 void onNotify(String command, int argument) {
   switch(command)
   {
     case "Thickness Brightness":  thicknessBrightness = (float) argument / 100;
     println("Brightness" + thicknessBrightness);
                   break;     
     case "Thickness Alpha":  thicknessAlpha = (float) argument / 100;
                   break;
     case "Crush Opaque":  thicknessOpaqueLuma = (int) (argument * 2.55);
                   break;
     case "Crush Transparent":  thicknessTransparentLuma = (int) (argument * 2.55);
                   break;
     case "Glow Alpha":  glowAlpha = (float) argument / 100;
     break;
   }

 }
}
