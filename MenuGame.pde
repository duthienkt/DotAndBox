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
    buttonNewgame.update();
    buttonHelp.update();
    buttonExit.update();
  }

  void draw()
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
  void onClick(){
    context.startGActivity(new LevelPopUp(act));
  }
  
}

class HelpButton extends Button {
  DotAndBox context;
  HelpButton(DotAndBox context, int ix, int iy, PImage ibase, PImage iroll) 

  {
    super(ix, iy, ibase, iroll);
    this.context=context;
  }
  void onClick(){
    //context.startGActivity(new GameHelp(context));
    startGActivity(new GMainActivity(DotAndBox.this,
    //new HumanPlayer("Player 1"),
    new HardComputer("Computer Hard 1", (int)frameRate/2+1),
    new HardComputer("Computer Hard 2", (int)frameRate/2+1)));
  }
  
}

class ExitButton extends Button {
  DotAndBox context;
  ExitButton(DotAndBox context, int ix, int iy, PImage ibase, PImage iroll) 
  {
    super(ix, iy, ibase, iroll);
    this.context=context;
  }
  void onClick(){
    startGActivity(new YesNoPopUpExit(act, "WARNING" , "Do you really want to exit?", 650, 300));
  }
  
}