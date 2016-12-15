class GMainActivity extends GActivity
{
  State s;
  ScoreBoard scoreBoard;
  DBPlayer []players;
  int playerIndex;
  int []resM = new int[3];
  boolean finished = false;
  BackButton backBt;
  public GMainActivity(DotAndBox context, DBPlayer player1, DBPlayer player2)
  {
    super(context);
    backBt = new BackButton(context, 900, 500);
    s = new State();
    scoreBoard = new ScoreBoard();
    this.players = new  DBPlayer[]{player1, player2};
    playerIndex = 0;
    //for (int i = 0; i<= 6; ++i)
    //s.checkHorizontal(i,8,i%2);
    //for (int i = 0; i< 6; ++i)
    //s.checkVertical(i,8,i%2);

    //for (int i = 0; i< 6; ++i)
    //s.checkVertical(i,9,i%2);
  }


  boolean mousePressed(float x, float y)
  {
    players[playerIndex].mousePressed(x, y);
    return false;
  }
  boolean mouseReleased(float x, float y)
  {
    players[playerIndex].mouseReleased(x, y);
    return false;
  }
  void mouseMoved(float x, float y, float relX, float relY)
  {
    players[playerIndex].mouseMoved(x, y, relX, relY);
  }
  
  void checkFinish()
  {
    int p0 = s.catchedcounting(0);
    int p1 = s.catchedcounting(1);
    String s = "";
    if (p0>p1) s = players[0].getPName()+" wins!";
    else
    if (p0<p1) s = players[1].getPName()+" wins!";
    else
    s = "DRAW";
    
    if (p0+p1>=54)
    {
      background(0);
      draw();
      popGActivity();
      startGActivity(new OKPopUp(this, "Congratulations", s, 600, 300));
    }
  }

  void getMove()
  {
    resM[0] = -1;
    players[playerIndex].requestMove(playerIndex, s, resM);
    if (resM[0]<0) return;
    if (resM[0] ==0)
    {
      if (!s.isCheckedHorizontal(resM[1], resM[2], playerIndex))
      {
        int lastR = s.catchedcounting(playerIndex);
        s.checkHorizontal(resM[1], resM[2], playerIndex);
        int newR = s.catchedcounting(playerIndex);
        scoreBoard.setScore(playerIndex, newR);
        if (newR == lastR)
        {
          playerIndex = 1- playerIndex;
          scoreBoard.setTurn(playerIndex);
          
        }
        checkFinish();
      }
    } else
      if (resM[0] == 1)
      {

        if (!s.isCheckedVertical(resM[1], resM[2], playerIndex))
        {
          int lastR = s.catchedcounting(playerIndex);
          s.checkVertical(resM[1], resM[2], playerIndex);
          int newR = s.catchedcounting(playerIndex);
          scoreBoard.setScore(playerIndex, newR);
          if (newR == lastR)
          {
            playerIndex = 1- playerIndex;
            scoreBoard.setTurn(playerIndex);
          }
          checkFinish();
        }
      }
  }

  void update()
  {
    if (finished) return;
    getMove();
    backBt.update();
  }

  void draw()
  {
    scoreBoard.draw();
    s.draw();
    backBt.display();
  }
}


class BackButton extends Button {
  DotAndBox context;
  BackButton(DotAndBox context, int ix, int iy ) 

  {
    super(ix, iy, loadImage("image/back.png"), loadImage("image/back2.png"));
    this.context=context;
  }
  void onClick(){
    startGActivity(new YesNoPopUpExit(act, "WARNING", "Do you want to return to menu?", 600, 400));
  }
  
}