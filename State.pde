class State implements GMouseInteraction, GDrawable, GUpdatable
{
  int [][] A;
  int [] p = new int[3];
  int [] lastCheck =  new int[3];
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

    lastCheck[0]= 0;
    lastCheck[1]= i;
    lastCheck[2]= j;

    if (i < 6)
    {
      A[i][j] |= 4 <<player;
      if (getDeg(i, j) >= 4 )
        A[i][j] |= 256 <<player;
    }
    if (i >0)
    {
      A[i-1][j] |= 64 <<player;
      if (getDeg(i-1, j) >= 4 )
        A[i-1][j] |= 256 <<player;
    }
  }

  public void checkVertical(int i, int j, int player)
  {
    lastCheck[0]= 1;
    lastCheck[1]= i;
    lastCheck[2]= j;
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
    if (i<0) return false;
    if (i > 6) return false;
    if (j<0 || j>=9) return false;
    if (i < 6)
      return (A[i][j] & (4 <<player))>0;
    else
      return (A[i-1][j] & (64 <<player))>0;
  }
  public boolean isCheckedHorizontal(int i, int j)
  {
    return isCheckedHorizontal(i, j, 0)||isCheckedHorizontal(i, j, 1);
  }

  public boolean isCheckedVertical(int i, int j, int player)
  {
    if (i<0) return false;
    if (i >= 6) return false;
    if (j<0 || j>9) return false;
    if (j< 9)
      return (A[i][j] & (1 <<player)) > 0;
    else
      return   (A[i][j-1] &( 16 <<player))>0;
  }

  public boolean isCheckedVertical(int i, int j)
  {

    return  isCheckedVertical(i, j, 0)|| isCheckedVertical(i, j, 1) ;
  }

  public int getDeg(int i, int j)
  {
    int res = 0;
    int t = A[i][j];
    for (int k = 0; k < 4; ++k)
    {
      if (( t& 3) > 0) res++;
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

  int catchedcounting(int player)
  {
    int c = 0;
    for (int i = 0; i< 6; ++i)
      for (int j = 0; j< 9; ++j)
        if (playerCatched(i, j) == player) ++c;
    return c;
  }


  void pick(float x, float y, int []res)
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

  boolean mousePressed(float x, float y)
  {
    return false;
  }
  boolean  mouseReleased(float x, float y)
  {
    return false;
  }

  void mouseMoved(float x, float y, float relX, float relY)
  {
  }
  int [][]indx = mallocInt(6, 9);
  int [] count  = new int[55];
  boolean [] freedom  = new boolean[55];
  void draw()
  {
    if (DEBUG) trans2Graph(indx, count, freedom);
    for (int i = 0; i< 6; ++i)
      for (int j = 0; j < 9; ++j)
      {
        int p = playerCatched(i, j);
        if (p>=0)
          image(PLAYER_IM[p], SZZ + SZZ * j + (SZZ - 60)/2, SZZ + SZZ * i + (SZZ - 60)/2);
        if (DEBUG)
          if (indx[i][j]>=0)
          {
            textSize(15);
            text(" "+ count[indx[i][j]] +"("+indx[i][j]+")" + (freedom[indx[i][j]]?"+":"-"), SZZ + SZZ * j + (SZZ - 60)/2+5, SZZ + SZZ * i + (SZZ - 60)/2+20);
          }
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
          if (lastCheck[0] == 0 && lastCheck[1] == i&& lastCheck[2] == j)
            stroke(0, 255, 30);
          line(x, y, x + SZZ, y);
          stroke(30, 30, 255);
        }
    //player 0 v  
    for (int i = 0; i < 6; ++i)
      for (int j = 0; j <= 9; ++j)
        if (isCheckedVertical(i, j, 0))
        {
          float x = SZZ + j * SZZ;
          float y = SZZ + i * SZZ;
          if (lastCheck[0] == 1 && lastCheck[1] == i&& lastCheck[2] == j)
            stroke(0, 255, 30);
          line(x, y, x, y + SZZ );
          stroke(30, 30, 255);
        }

    stroke(255, 30, 30);
    //player 1 h
    for (int i = 0; i <= 6; ++i)
      for (int j = 0; j < 9; ++j)
        if (isCheckedHorizontal(i, j, 1))
        {
          float x = SZZ + j * SZZ;
          float y = SZZ + i * SZZ;
          if (lastCheck[0] == 0 && lastCheck[1] == i&& lastCheck[2] == j)
            stroke(255, 255, 30);
          line(x, y, x + SZZ, y);
          stroke(255, 30, 30);
        }
    //player 1 v  
    for (int i = 0; i < 6; ++i)
      for (int j = 0; j <= 9; ++j)
        if (isCheckedVertical(i, j, 1))
        {
          float x = SZZ + j * SZZ;
          float y = SZZ + i * SZZ;
          if (lastCheck[0] == 1 && lastCheck[1] == i&& lastCheck[2] == j)
            stroke(255, 255, 30);
          line(x, y, x, y + SZZ );
          stroke(255, 30, 30);
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

  void update()
  {
  }

  void visit(int i, int j, int [][] idx, int []count, boolean [] isOpen)
  {
    int id = idx[i][j];
    count[id] ++;
    //up
    if (!isCheckedHorizontal(i, j))
    {
      if (i<=0) isOpen[id] = true;
      else
      {
        if (idx[i-1][j]<0)
        {
          if (getDeg(i-1, j)>1 && getDeg(i-1, j)<4)
          {
            idx[i-1][j] = id;
            visit(i-1, j, idx, count, isOpen);
          } else
            if (getDeg(i -1, j)<2)
              isOpen[id] = true;
        }
      }
    }
    //down
    if (!isCheckedHorizontal(i+1, j))
    {
      if (i>=5) isOpen[id] = true;
      else
      {
        if (idx[i+1][j]<0)
        {
          if (getDeg(i+1, j)>1 && getDeg(i+1, j)<4)
          {
            idx[i+1][j] = id;
            visit(i+1, j, idx, count, isOpen);
          } else
            if (getDeg(i +1, j)<2)
              isOpen[id] = true;
        }
      }
    }

    //left

    if (!isCheckedVertical(i, j))
    {
      if (j<=0) isOpen[id] = true;
      else
      {
        if (idx[i][j-1]<0)
        {
          if (getDeg(i, j-1)>1 && getDeg(i, j-1)<4)
          {
            idx[i][j-1] = id;
            visit(i, j-1, idx, count, isOpen);
          } else
            if (getDeg(i, j-1)<2)
              isOpen[id] = true;
        }
      }
    }

    //right

    if (!isCheckedVertical(i, j+1))
    {
      if (j>=8) isOpen[id] = true;
      else
      {
        if (idx[i][j+1]<0)
        {
          if (getDeg(i, j+1)>1 && getDeg(i, j+1)<4)
          {
            idx[i][j+1] = id;
            visit(i, j+1, idx, count, isOpen);
          } else
            if (getDeg(i, j+1)<2)
              isOpen[id] = true;
        }
      }
    }
  }

  void trans2Graph(int [][] idx, int []count, boolean [] isOpen)
  {
    for (int i = 0; i< idx.length; ++i)
      for (int j = 0; j< idx[i].length; ++j)
      {
        idx[i][j] = -1;
      }
    for (int i = 0; i< count.length; ++i)
      count[i] = 0;

    for (int i = 0; i< isOpen.length; ++i)
      isOpen[i] = false;
    int id = 0;
    for (int i = 0; i< idx.length; ++i)
      for (int j = 0; j< idx[i].length; ++j)
      {
        if (getDeg(i, j)>=2 &&  getDeg(i, j)<4 &&idx[i][j] == -1)
        {
          idx[i][j] = id++;
          visit(i, j, idx, count, isOpen);
        }
      }
  }

  boolean isFreeLeft(int i, int j)
  {
    if (getDeg(i, j) <2)
    {
      if (!isCheckedVertical(i, j))
      {
        if (j>0) return getDeg(i, j-1)<2;
        else
          return true;
      }
      return false;
    } else
      return false;
  }

  boolean isFreeRight(int i, int j)
  {
    if (getDeg(i, j) <2)
    {
      if (!isCheckedVertical(i, j+1))
      {
        if (j<8) return getDeg(i, j+1)<2;
        else
          return true;
      }
      return false;
    } else
      return false;
  }


  boolean isFreeTop(int i, int j)
  {
    if (getDeg(i, j) <2)
    {
      if (!isCheckedHorizontal(i, j))
      {
        if (i>0) return getDeg(i-1, j)<2;
        else
          return true;
      }
      return false;
    } else
      return false;
  }


  boolean isFreeButtom(int i, int j)
  {
    if (getDeg(i, j) <2)
    {
      if (!isCheckedHorizontal(i+1, j))
      {
        if (i<5) return getDeg(i+1, j)<2;
        else
          return true;
      }
      return false;
    } else
      return false;
  }


  int  countfreeD()
  {
    int r = 0;
    for (int i = 0; i< 6; ++i)
      for (int j = 0; j < 9; ++j)
      {
        if (i==0 && isFreeTop(i, j)) ++r;
        if (j==0 && isFreeLeft(i, j)) ++r;
        if (isFreeRight(i, j)) ++r;
        if (isFreeButtom(i, j)) ++r;
      }
    return r;
  }

  int countFreeAngle()
  {
    int r = 0;
    for (int i = 0; i<= 6; ++i)
      for (int j = 0; j <= 9; ++j)
      {
        if (i<6)
        {
          if (!isCheckedVertical(i, j)) r++;
        }
        if (j< 9)
        {
          if (!isCheckedHorizontal(i, j)) r++;
        }
      }
    return r;
  }
}