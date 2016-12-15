class ScoreBoard implements GMouseInteraction, GDrawable, GUpdatable
{
  private int []playerScore = new int[]{0, 0}; 
  PVector  root;
  PVector [] plPos;
  PVector [] txPos;
  int turn = 0;
  public ScoreBoard()
  {
    root  = new PVector(SZZ*10.5f, 50);
    plPos =new PVector[]
      { new PVector(root.x+30, LOGO_IM.height+100), 
      new PVector(root.x+30, LOGO_IM.height+200)
    };
    txPos =new PVector[]
      { new PVector(plPos[0].x +13 + PLAYER_IM[0].width, plPos[0].y+PLAYER_IM[0].height/2+30), 
      new PVector(plPos[1].x + 13 + PLAYER_IM[1].width, plPos[1].y+PLAYER_IM[1].height/2+30)
    };
  }

  public void setTurn(int t)
  {
    turn = t;
  }
  
  public void setScore(int playerId, int score)
  {
    playerScore[playerId] = score;
    
  }
  
  
  void draw()
  {
    image(LOGO_IM, root.x, root.y);
    textSize(60);
    fill(0, 173, 196);
    text(""+ playerScore[0], txPos[0].x, txPos[0].y);
    fill(203, 60, 5);
    text(""+ playerScore[1], txPos[1].x, txPos[1].y);

    image(PLAYER_IM[0], plPos[0].x, plPos[0].y); 
    image(PLAYER_IM[1], plPos[1].x, plPos[1].y);
    int d = floor(frameCount/30)%4;
    if (d > 0)
    {
      noFill();
      stroke(255*d/4, 255- 255*(d-1)/4, 255* random(30,255));
      rect(plPos[turn].x, plPos[turn].y, PLAYER_IM[turn].width*3, PLAYER_IM[turn].height*1.1);
    }
    stroke(255, 128, 10);
    line(root.x, 0, root.x, width_M);
    line(root.x + 5, 0, root.x + 5, width_M);
  }
  
  

  void update()
  {
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
}