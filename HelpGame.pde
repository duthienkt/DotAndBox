class GameHelp extends GActivity
{

  PImage helpBackground;

  BackHelpButton BackButton;

  PImage newgame = loadImage("image/back.png");
  PImage newgame2 = loadImage("image/back2.png");
  public GameHelp(DotAndBox context)
  {
    super(context);
    playMusic(MUSIC_PATH[11]);
    helpBackground = loadImage("image/helpbg.jpg");
    int newgame_X = 20;
    int newgame_Y = 20; 
    DEBUG = true;
     BackButton= new BackHelpButton(context, newgame_X, newgame_Y, newgame, newgame2);
  }



  boolean mousePressed(float x, float y)
  {
    return false;
  }
  boolean mouseReleased(float x, float y)
  {
    return false;
  }
  void mouseMoved(float x, float y, float relX, float relY)
  {
    
  }

  void update()
  {
    BackButton.update();
  }

  void draw()
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
  void onClick(){
    context.popGActivity();
  }
  
}