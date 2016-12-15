package processing.test.dotandbox;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import cassette.audiofiles.SoundFile; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class DotAndBox extends PApplet {

//define ANDROID_VS  false;

// if define (ANDROID_VS)
  
  //else define
 //import processing.sound.SoundFile;


SoundFile music;

GActivity []acts ;
int TOP_ACT;
GActivity  act;

PImage [] PLAYER_IM = new PImage[2];
float SZZ = 0;

float mouseX_M, pmouseX_M;
float mouseY_M, pmouseY_M;

float width_M = 1024;
float height_M = 600;
boolean portrait;
float scaleX;
float scaleY;
public void startGActivity(GActivity act)
{
  acts[TOP_ACT++] = this.act;
  this.act = act;
}

public void popGActivity()
{
  if (TOP_ACT<=0) exit();
  else
    this.act = acts[--TOP_ACT];
}

public void loadingData()
{
  SZZ = height_M/ 8;
  PLAYER_IM[0] = loadImage("elephant.png");
  PLAYER_IM[1] = loadImage("tiger.png");
}

public void setup()
{
  
  //size(500, 700);
  
  if (width<height)
  {
    portrait = true;
    scaleX = height/width_M;
    scaleY = width/height_M;
  }
  else
  {
    portrait = false;
    scaleX = width/width_M;
    scaleY = height/height_M;
  }
  
   music = new SoundFile(this, "canon.mp3");
   music.play();
   music.loop();
  acts = new GActivity[30];
  TOP_ACT = 0;
  act = new GameMenu(this);
  
  loadingData();
}

public void draw()
{
  background(0);
  if (portrait)
  {
    
    translate(width, 0);
    rotate(PI/2);
    scale(scaleX, scaleY);
    mouseY_M = (width-mouseX)/scaleY;
    mouseX_M = mouseY/scaleX;
  }
  else
  {
    mouseX_M = mouseX/scaleX;
    mouseY_M = mouseY/scaleY;
    scale(scaleX, scaleY);
  }
  act.update();
  act.draw();
}

public void mousePressed()
{
  if (portrait)
  {
    
    mouseY_M = (width-mouseX)*scaleY;
    mouseX_M = mouseX*scaleX;
  }
  else
  {
    mouseX_M = mouseX*scaleX;
    mouseY_M = mouseY*scaleY;
  }
    act.mousePressed(mouseX_M, mouseY_M);
}

public void mouseReleased()
{
  if (portrait)
  {
    
    mouseY_M = (width-mouseX)*scaleY;
    mouseX_M = mouseX*scaleX;
  }
  else
  {
    mouseX_M = mouseX*scaleX;
    mouseY_M = mouseY*scaleY;
  }

  act.mouseReleased(mouseX_M, mouseY_M);
}

public void mouseMoved()
{
  pmouseX_M = mouseX_M;
  pmouseY_M = mouseY_M;
  if (portrait)
  {
    
    mouseY_M = (width-mouseX)*scaleY;
    mouseX_M = mouseX*scaleX;
  }
  else
  {
    mouseX_M = mouseX*scaleX;
    mouseY_M = mouseY*scaleY;
  }
  act.mouseMoved(mouseX_M, mouseY_M, mouseX_M - pmouseX_M, mouseY_M- pmouseY_M);
}
class GMainActivity extends GActivity
{
    State s;
    public GMainActivity(DotAndBox context)
    {
      super(context);
      s = new State();
      //for (int i = 0; i<= 6; ++i)
      //s.checkHorizontal(i,8,i%2);
      //for (int i = 0; i< 6; ++i)
      //s.checkVertical(i,8,i%2);
      
      //for (int i = 0; i< 6; ++i)
      //s.checkVertical(i,9,i%2);
    }
  
    
    public boolean mousePressed(float x, float y)
    {
     
      return false;
    }
    public boolean mouseReleased(float x, float y)
    {
      return false;
    }
    public void mouseMoved(float x, float y, float relX, float relY)
    {
     
    }
    
    public void update()
    {
      s.draw();
    }
    
    public void draw()
    {
    }
}
class GameHelp extends GActivity
{

  PImage helpBackground;

  BackHelpButton BackButton;

  PImage newgame = loadImage("image/back.png");
  PImage newgame2 = loadImage("image/back2.png");
  public GameHelp(DotAndBox context)
  {
    super(context);
    helpBackground = loadImage("image/background.jpg");
    int newgame_X = 20;
    int newgame_Y = 20; 

     BackButton= new BackHelpButton(context, newgame_X, newgame_Y, newgame, newgame2);
  }



  public boolean mousePressed(float x, float y)
  {
    return false;
  }
  public boolean mouseReleased(float x, float y)
  {
    return false;
  }
  public void mouseMoved(float x, float y, float relX, float relY)
  {
  }

  public void update()
  {
    BackButton.update();
  }

  public void draw()
  {
    image(helpBackground, 0, 0);
    BackButton.display();
  }
}

class BackHelpButton extends Button {
  DotAndBox context;
  BackHelpButton(DotAndBox context, int ix, int iy, PImage ibase, PImage iroll) 

  {
    super(ix, iy, ibase, iroll);
    this.context=context;
  }
  public void onClick(){
    context.popGActivity();
  }
  
}
class Button
{
  private boolean lastM;
  int x, y;
  int w, h;
  PImage i,i1, i2;
  
  boolean pressed = false;   

  public Button(int x,int y,PImage i1, PImage i2)
  {
   
    i = i1;
    this.i1 = i1;
    this.i2 = i2;
    w = i.width;
    h = i.height;
    this.x =x;
    this.y=y;
  }


  public boolean overRect(int x, int y, int width, int height) {
    if (mouseX_M >= x && mouseX_M <= x+width && 
      mouseY_M >= y && mouseY_M <= y+height) {
      return true;
    } else {
      return false;
    }
  }
  
  
  public void update() 
  {
    
   if (pressed && !mousePressed )
   {
     if (over())
     onClick();
     pressed = false;
     i = i1;
   }
   if (over() && mousePressed && !lastM)
   {
       pressed = true;
       i = i2;
   }
   lastM = mousePressed;
  }

  public boolean over() 
  {
    if ( overRect(x, y, w, h) ) {
      return true;
    } else {
      return false;
    }
  }

  public void display() 
  {
    image(i, x, y);
  }
  
  public void onClick()
  {
  }
}
class GameMenu extends GActivity
{

  PImage menuBackground;

  NewgameButton buttonNewgame;
  HelpButton buttonHelp;
  ExitButton buttonExit;

  PImage newgame = loadImage("image/newgame.png");
  PImage newgame2 = loadImage("image/newgame2.png");
  PImage help = loadImage("image/help.png");
  PImage help2 = loadImage("image/help2.png");
  PImage exit = loadImage("image/exit.png");
  PImage exit2 = loadImage("image/exit2.png");
  public GameMenu(DotAndBox context)
  {
    super(context);
    menuBackground = loadImage("image/background.jpg");
    int newgame_X = 600;
    int newgame_Y = 300; 

    int help_X = 600;
    int help_Y = 380; 

    int exit_X = 600;
    int exit_Y = 460; 

    buttonNewgame = new NewgameButton(context, newgame_X, newgame_Y, newgame, newgame2);
    buttonHelp = new HelpButton(context,help_X, help_Y,  help, help2);
    buttonExit = new ExitButton(context,exit_X, exit_Y,  exit, exit2);
  }



  public boolean mousePressed(float x, float y)
  {
    return false;
  }
  public boolean mouseReleased(float x, float y)
  {
    return false;
  }
  public void mouseMoved(float x, float y, float relX, float relY)
  {
  }


  public void update()
  {
    buttonNewgame.update();
    buttonHelp.update();
    buttonExit.update();
  }

  public void draw()
  {
    image(menuBackground, 0, 0);
    buttonNewgame.display();
    buttonHelp.display();
    buttonExit.display();
  }
}

class NewgameButton extends Button {
  DotAndBox context;
  NewgameButton(DotAndBox context, int ix, int iy, PImage ibase, PImage iroll) 

  {
    super(ix, iy, ibase, iroll);
    this.context=context;
  }
  public void onClick(){
    context.startGActivity(new GMainActivity(context));
  }
  
}

class HelpButton extends Button {
  DotAndBox context;
  HelpButton(DotAndBox context, int ix, int iy, PImage ibase, PImage iroll) 

  {
    super(ix, iy, ibase, iroll);
    this.context=context;
  }
  public void onClick(){
    context.startGActivity(new GameHelp(context));
  }
  
}

class ExitButton extends Button {
  DotAndBox context;
  ExitButton(DotAndBox context, int ix, int iy, PImage ibase, PImage iroll) 

  {
    super(ix, iy, ibase, iroll);
    this.context=context;
  }
  public void onClick(){
    exit();
  }
  
}
class State implements GMouseInteraction, GDrawable, GUpdatable
{
  int [][] A;
  int [] p = new int[3];
  public State()
  {
    A = new int[6][];
    for (int i = 0; i < 6; ++i)
    {
      A[i] = new int[9];
      for (int j = 0; j < 9; ++j)
        A[i][j] = 0;
    }
  }


  public State clone()
  {
    State res = new State();
    res.cloneFrom(this);
    return res;
  }

  public void cloneFrom(State s)
  {
    for (int i = 0; i < 6; ++i)
    {
      for (int j = 0; j < 9; ++j)
        A[i][j] = s.A[i][j];
    }
  }
  public void checkHorizontal(int i, int j, int player)
  { 
    if (i < 6)
      A[i][j] |= 4 <<player;
    if (i >0)
      A[i-1][j] |= 64 <<player;
  }

  public void checkVertical(int i, int j, int player)
  {
    if (j< 9)
    {
      A[i][j] |= 1 <<player;
      if (getDeg(i, j) >= 4 )
        A[i][j] |= 256 <<player;
    }
    if (j > 0) 
    {
      A[i][j-1] |= 16 <<player;
      if (getDeg(i, j-1) >= 4 )
        A[i][j-1] |= 256 <<player;
    }
  }

  public boolean isCheckedHorizontal(int i, int j, int player)
  {
    if (i < 6)
      return (A[i][j] & (4 <<player))>0;
    else
      return (A[i-1][j] & (64 <<player))>0;
  }

  public boolean isCheckedVertical(int i, int j, int player)
  {
    if (j< 9)
      return (A[i][j] & (1 <<player)) > 0;
    else
      return   (A[i][j-1] &( 16 <<player))>0;
  }

  public int getDeg(int i, int j)
  {
    int res = 0;
    int t = A[i][j];
    for (int k = 0; k < 4; ++k)
    {
      if ((t& 3) > 0) res++;
      t = t >>2;
    }
    return res;
  }

  public int playerCatched(int i, int j)
  {
    int c = A[i][j]>>8;
    if (c == 1) return 0;
    if (c == 2) return 1;
    return -1;
  }

  public void pick(float x, float y, int []res)
  {
    float i = (y - SZZ)/SZZ;
    float j = (x - SZZ)/SZZ;
    int ip = (int)i;
    int jp =  (int)j;
    i -= ip;
    j -= jp;
    if (i>j)
    {
      if (i+j<1)
      {
        res[0] = 1;
        res[1] = ip;
        res[2] = jp;
      } else
      {
        res[0] = 0;
        res[1] = ip+1;
        res[2] = jp;
      }
    } else
    {
      if (i+j<1)
      {
        res[0] = 0;
        res[1] = ip;
        res[2] = jp;
      } else
      {
        res[0] = 1;
        res[1] = ip;
        res[2] = jp+1;
      }
    }
    if (res[1]<0 
      || res[2] < 0
      ||(res[0] == 0 &&(res[1]>6 || res[2] > 8))
      ||(res[0] == 1 &&(res[1]>5 || res[2] > 9))
      )
      res[0] = -1;
  }

  public boolean mousePressed(float x, float y)
  {
    return false;
  }
  public boolean  mouseReleased(float x, float y)
  {
    return false;
  }

  public void mouseMoved(float x, float y, float relX, float relY)
  {
    
  }

  public void draw()
  {

    for (int i = 0; i< 6; ++i)
      for (int j = 0; j < 9; ++j)
      {
        int p = playerCatched(i, j);
        if (p>=0)
          image(PLAYER_IM[p], SZZ + SZZ * j + (SZZ - 60)/2, SZZ + SZZ * i + (SZZ - 60)/2);
      }
    strokeWeight(5);
    stroke(30, 30, 255);
    //player 0 h
    for (int i = 0; i <= 6; ++i)
      for (int j = 0; j < 9; ++j)
        if (isCheckedHorizontal(i, j, 0))
        {
          float x = SZZ + j * SZZ;
          float y = SZZ + i * SZZ;
          line(x, y, x + SZZ, y);
        }
    //player 0 v  
    for (int i = 0; i < 6; ++i)
      for (int j = 0; j <= 9; ++j)
        if (isCheckedVertical(i, j, 0))
        {
          float x = SZZ + j * SZZ;
          float y = SZZ + i * SZZ;
          line(x, y, x, y + SZZ );
        }

    stroke(255, 30, 30);
    //player 1 h
    for (int i = 0; i <= 6; ++i)
      for (int j = 0; j < 9; ++j)
        if (isCheckedHorizontal(i, j, 1))
        {
          float x = SZZ + j * SZZ;
          float y = SZZ + i * SZZ;
          line(x, y, x + SZZ, y);
        }
    //player 1 v  
    for (int i = 0; i < 6; ++i)
      for (int j = 0; j <= 9; ++j)
        if (isCheckedVertical(i, j, 1))
        {
          float x = SZZ + j * SZZ;
          float y = SZZ + i * SZZ;
          line(x, y, x, y + SZZ );
        }
    if (mousePressed)
    {
      pick(mouseX_M, mouseY_M, p);
      
      float x = p[2] * SZZ + SZZ;
      float y = p[1] * SZZ + SZZ;
      stroke(150, 150, 250);
      strokeWeight(7);
      if (p[0] == 0)
      {
        line(x, y, x + SZZ, y);
      } else
        if (p[0] ==1)
        {
          line(x, y, x, y+ SZZ);
        }
    }

    fill(255, 255, 255);
    stroke(150, 150, 150);
    strokeWeight(3);
    for (int i = 0; i<=6; ++i)
      for (int j = 0; j <= 9; ++j)
      {
        ellipse(SZZ + SZZ * j, SZZ + SZZ * i, 10, 10);
      }
  }

  public void update()
  {
  }
}
interface GMouseInteraction
{
  public boolean mousePressed(float x, float y);
  public boolean mouseReleased(float x, float y);
  public void mouseMoved(float x, float y, float relX, float relY);
}


interface GDrawable
{
  public void draw();
}

interface GUpdatable
{
  public void update();
}

abstract class GActivity implements  GMouseInteraction, GDrawable, GUpdatable
{
  protected final DotAndBox context;
  public GActivity(DotAndBox context)
  {
    this.context = context;
  }
  
  public void draw()
  {
  }
  
  public void update()
  {
    
  }
  
  public void finish()
  {
    this.context.popGActivity();
  }
  
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "DotAndBox" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
