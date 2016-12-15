 //define ANDROID_VS  false;

// if define (ANDROID_VS)
//import cassette.audiofiles.SoundFile;
//else define
boolean DEBUG = true;
import processing.sound.SoundFile;

String []MUSIC_PATH = new String[]{
  "easymode1.mp3",
  "easymode2.mp3",
  "easymode3.mp3",
  "medium1.mp3",
  "medium2.mp3",
  "medium3.mp3",
  "hardmode1.mp3",
  "hardmode2.mp3",
  "hardmode3.mp3",
  "openning.mp3",
  "endding.mp3",
  "canon.mp3"
};

SoundFile music = null;

GActivity []acts ;
int TOP_ACT;
GActivity  act;

PImage [] PLAYER_IM = new PImage[2];
PImage LOGO_IM;
float SZZ = 0;

float mouseX_M, pmouseX_M;
float mouseY_M, pmouseY_M;

float width_M = 1024;
float height_M = 600;
boolean portrait;
float scaleX;
float scaleY;
void startGActivity(GActivity act)
{
  acts[TOP_ACT++] = this.act;
  this.act = act;
}

void popGActivity()
{
  if (TOP_ACT<=0) exit();
  else
    this.act = acts[--TOP_ACT];
}

void loadingData()
{
  SZZ = height_M/ 8;
  PLAYER_IM[0] = loadImage("elephant.png");
  PLAYER_IM[1] = loadImage("tiger.png");
  LOGO_IM = loadImage("logo.png");
  playMusic(MUSIC_PATH[9]);
}

void setup()
{

  //size(1024, 600);
  fullScreen();
  if (width<height)
  {
    portrait = true;
    scaleX = height/width_M;
    scaleY = width/height_M;
  } else
  {
    portrait = false;
    scaleX = width/width_M;
    scaleY = height/height_M;
  }

  
  acts = new GActivity[30];
  TOP_ACT = 0;
  act = new GameMenu(this);

  loadingData();
}


void playMusic(String p)
{
  if (music != null) music.stop();
  music = new SoundFile(this, p);
  music.play();
  music.loop();
}
void draw()
{
  
  if (portrait)
  {

    translate(width, 0);
    rotate(PI/2);
    scale(scaleX, scaleY);
    mouseY_M = (width-mouseX)/scaleY;
    mouseX_M = mouseY/scaleX;
  } else
  {
    mouseX_M = mouseX/scaleX;
    mouseY_M = mouseY/scaleY;
    scale(scaleX, scaleY);
  }
  act.update();
  background(0);
  act.draw();
}

void mousePressed()
{
  if (portrait)
  {

    translate(width, 0);
    rotate(PI/2);
    scale(scaleX, scaleY);
    mouseY_M = (width-mouseX)/scaleY;
    mouseX_M = mouseY/scaleX;
  } else
  {
    mouseX_M = mouseX/scaleX;
    mouseY_M = mouseY/scaleY;
    scale(scaleX, scaleY);
  }
  act.mousePressed(mouseX_M, mouseY_M);
}

void mouseReleased()
{
 if (portrait)
  {

    translate(width, 0);
    rotate(PI/2);
    scale(scaleX, scaleY);
    mouseY_M = (width-mouseX)/scaleY;
    mouseX_M = mouseY/scaleX;
  } else
  {
    mouseX_M = mouseX/scaleX;
    mouseY_M = mouseY/scaleY;
    scale(scaleX, scaleY);
  }
  act.mouseReleased(mouseX_M, mouseY_M);
}

void mouseMoved()
{
  pmouseX_M = mouseX_M;
  pmouseY_M = mouseY_M;
 if (portrait)
  {

    translate(width, 0);
    rotate(PI/2);
    scale(scaleX, scaleY);
    mouseY_M = (width-mouseX)/scaleY;
    mouseX_M = mouseY/scaleX;
  } else
  {
    mouseX_M = mouseX/scaleX;
    mouseY_M = mouseY/scaleY;
    scale(scaleX, scaleY);
  }
  act.mouseMoved(mouseX_M, mouseY_M, mouseX_M - pmouseX_M, mouseY_M- pmouseY_M);
}


interface GMouseInteraction
{
  boolean mousePressed(float x, float y);
  boolean mouseReleased(float x, float y);
  void mouseMoved(float x, float y, float relX, float relY);
}


interface GDrawable
{
  void draw();
}

interface GUpdatable
{
  void update();
}



abstract class DBPlayer implements GUpdatable, GMouseInteraction
{
  String pName;
  DBPlayer(String pname)
  {
    pName  = pname;
  }
  abstract void requestMove(int playerId, State s, int [] resM);
  boolean mousePressed(float x, float y) {
    return false;
  }
  boolean mouseReleased(float x, float y) {
    return false;
  }
  void mouseMoved(float x, float y, float relX, float relY) {
  }
  
  String getPName()
  {
    return pName;
    
  }
  void update(){}
}


int [][] mallocInt(int m, int n)
{
  int [][] r = new int[m][];
  for (int i  = 0; i< m; ++i)
  r[i] = new int [n];
  return r;
}