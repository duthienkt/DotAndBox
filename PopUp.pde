abstract class PopUp extends GActivity
{
  float scaleXY;
  boolean ok;
  GActivity act;
  PImage gr;
  PopUp (GActivity act)
  {
    super(act.context);
    gr = act.capScr();
    this.act = act;
    scaleXY = 0.1f;
    ok = false;
  }
  boolean mousePressed(float x, float y) {
    return false;
  }
  boolean mouseReleased(float x, float y) {
    return false;
  }
  void mouseMoved(float x, float y, float relX, float relY) {
  }

  void drawWindows()
  {
  }

  void draw() {
    image(gr, 0, 0, width_M, height_M);
    if (!ok)
    {
      pushMatrix();
      translate(width_M/2, height_M/2);
      scale(scaleXY, scaleXY);
      translate(-width_M/2, -height_M/2);
      drawWindows();
      popMatrix();
    } else
    {
      drawWindows();
    }
  }
  void update() {
    if (!ok)
    {
      scaleXY *=1.1;
      if (scaleXY>1)
      {
        scaleXY = 1;
        ok = true;
      }
    }
  }
}


class YesNoPopUpExit extends PopUp
{
  int w, h;
  float l, t;
  String title, mess; 
  Button Y, N;
  YesNoPopUpExit(GActivity act, String title, String mess, int w, int h)
  {
    super(act);
    this.title = title;
    this.mess = mess;
    this.w = w;
    this.h = h;
    l = width_M/2-w/2;
    t = height_M/2-h/2;
    Y = new Yes_Exit((int)(l+5), (int)( t+ h-70));
    N = new No_Back((int)(l+300), (int)( t+ h-70));
  }
  void drawWindows()
  {
    Y.update();
    N.update();
    fill(20, 50, 255, 100);
    stroke(255, 255, 200);
    rect(l, t, w, h);
    fill(255, 0, 0);
    textSize(50);
    text(title, l+50, t+50);
    fill(255, 255, 0);
    textSize(30);
    text(mess, l+70, t+150);
    Y.display();
    N.display();
  }
}



class Yes_Exit extends Button {
  DotAndBox context;
  Yes_Exit(int x, int y) 
  {
    super(x, y, loadImage("image/Yes.png"), loadImage("image/Yes2.png"));
  }
  void onClick() {
    popGActivity();
    popGActivity();
    
  }
}

class No_Back extends Button 
{
  DotAndBox context;
  No_Back(int x, int y) 
  {
    super(x, y, loadImage("image/No.png"), loadImage("image/No2.png"));
  }
  void onClick() {
    popGActivity();
  }
}




class OKBack extends Button {
  DotAndBox context;
  OKBack(int x, int y) 
  {
    super(x, y, loadImage("image/OK.png"), loadImage("image/OK2.png"));
  }
  void onClick() {
    popGActivity();
  }
}

class OKPopUp extends PopUp
{
  int w, h;
  float l, t;
  String title, mess; 
  Button O;
  OKPopUp(GActivity act, String title, String mess, int w, int h)
  {
    super(act);
    this.title = title;
    this.mess = mess;
    this.w = w;
    this.h = h;
    l = width_M/2-w/2;
    t = height_M/2-h/2;
    O = new OKBack((int)(l+5), (int)( t+ h-70));
  }
  void drawWindows()
  {
    O.update();
    fill(20, 50, 255, 100);
    stroke(255, 255, 200);
    rect(l, t, w, h);
    fill(255, 0, 0);
    textSize(50);
    text(title, l+50, t+50);
    fill(255, 255, 0);
    textSize(30);
    text(mess, l+70, t+150);
    O.display();
  }
}





class PvsP extends Button {
  PvsP(int x, int y) 
  {
    super(x, y, loadImage("image/option1.png"), loadImage("image/option1_2.png"));
  }
  void onClick() {
    popGActivity();
    startGActivity(new GMainActivity(DotAndBox.this, new HumanPlayer("Player 1"), new HumanPlayer("Player 2")));
  }
}



class PvsCE extends Button {
  PvsCE(int x, int y) 
  {
    super(x, y, loadImage("image/option2.png"), loadImage("image/option2_2.png"));
  }
  void onClick() {
    popGActivity();
    playMusic(MUSIC_PATH[((int)random(0,100))%3]);
    startGActivity(new GMainActivity(DotAndBox.this, new HumanPlayer("Player 1"), new ComputerEasy("Computer Easy", (int)frameRate/3+1)));
  }
}



class PvsCN extends Button {
  PvsCN(int x, int y) 
  {
    super(x, y, loadImage("image/option3.png"), loadImage("image/option3_2.png"));
  }
  void onClick() {
    popGActivity();
    playMusic(MUSIC_PATH[((int)random(0,100))%3+3]);
    startGActivity(new GMainActivity(DotAndBox.this,  new HumanPlayer("Player 1"), new ComputerNormal("Computer Normal 2", (int)frameRate/3+1)));
  }
}



class PvsCH extends Button {
  PvsCH(int x, int y) 
  {
    super(x, y, loadImage("image/option4.png"), loadImage("image/option4_2.png"));
  }
  void onClick() {
    popGActivity();
    playMusic(MUSIC_PATH[((int)random(0,100))%3+6]);
    startGActivity(new GMainActivity(DotAndBox.this,
    new HumanPlayer("Player 1"),
    //new ComputerNormal("Computer Easy 2", (int)frameRate/3+1),
    new HardComputer("Computer Hard 2", (int)frameRate/3+1)));
  }
}




class CancelBack extends Button {
  DotAndBox context;
  CancelBack(int x, int y) 
  {
    super(x, y, loadImage("image/option5.png"), loadImage("image/option5_2.png"));
  }
  void onClick() {
    popGActivity();
  }
}

class LevelPopUp extends PopUp
{
  int w, h;
  float l, t;
  Button PP, PE, PN, PH, CL ;
  LevelPopUp(GActivity act)
  {
    super(act);
    
    this.w = 450;
    this.h = 400;
    l = width_M/2-w/2;
    t = height_M/2-h/2;
    PP = new PvsP((int)(l+50), (int)( t+ 30));
    PE = new PvsCE((int)(l+50), (int)( t+ 30 +80));
    PN = new PvsCN((int)(l+50), (int)( t+ 30+ +80*2));
    PH = new PvsCH((int)(l+50), (int)( t+ 30+80*3));
    CL = new CancelBack((int)(l+50), (int)( t+ 30+80*4));
  }
  void drawWindows()
  {
    PP.update();
    PE.update();
    PN.update();
    PH.update();
    CL.update();
    fill(20, 50, 255, 100);
    stroke(255, 255, 200);
    rect(l, t, w, h);
    PP.display();
    PE.display();
    PN.display();
    PH.display();
    CL.display();
  }
}