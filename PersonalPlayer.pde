class HumanPlayer extends DBPlayer
{
  HumanPlayer(String pname)
  {
    super(pname);
  }
  int [] res = new int[]{-1, 0, 0};
  boolean handup = false;
  State  s;
  int id;
  void requestMove(int playerId, State s, int [] resM)
  {
    if (res[0]>=0 && handup)
    {
      for (int i = 0; i< 3; ++i) resM[i] = res[i];
      handup = false;
      return;
    }
    res[0] = -1;
    handup = true;
    this.s = s;
    this.id = playerId;
  }

  boolean mousePressed(float x, float y)
  {
    return handup;
  }
  boolean mouseReleased(float x, float y)
  {
    if (handup)
    {
      s.pick(x, y, res);
      //println(res);
      if (res[0]== 0)
      {
        if (s.isCheckedHorizontal(res[1], res[2], 0) ||s.isCheckedHorizontal(res[1], res[2], 1))
        {
          res[0]= -1;
          //println("invalid");
        } else return true;
      } else
        if (res[0] == 1)
        {
          if (s.isCheckedVertical(res[1], res[2], 0) ||s.isCheckedVertical(res[1], res[2], 0))
          {
            res[0]= -1; 
            // println("invalid");
          }
          return true;
        }
    }
    return false;
  }
  void mouseMoved(float x, float y, float relX, float relY)
  {
  }
  void update() {
  }
}




class ComputerEasy extends DBPlayer
{
  int topC ;
  ComputerEasy(String pname, int delay)
  {
    super(pname);
    topC= delay;
    countd = topC;
  }
  int countd;

  void requestMove(int playerId, State s, int [] resM)
  {
    if (countd<=0)
    {
      findMove(playerId, s, resM);
    }
    countd--;
  }

  boolean checkResult(State s, int [] resM)
  {
    if (resM[0] == 0)
    {
      if (resM[2]<9)  
        if (!s.isCheckedHorizontal(resM[1], resM[2]))
          return true;
    }
    if (resM[0] == 1)
    {
      if (resM[1]<6)  
        if (!s.isCheckedVertical(resM[1], resM[2]))
          return true;
    }
    resM[0] = -1;
    return false;
  }

  void findMove(int playerId, State s, int [] resM)
  {
    resM[0] = -1;
    find3(s, resM);
    if (checkResult(s, resM))
      countd = topC;
    if (resM[0]>=0) return;

    findFreeCell(s, resM);
    if (checkResult(s, resM))
      countd = topC;
    if (resM[0]>=0) return;
    else
      println("free cell not found");
    findFree(s, resM);
    if (checkResult(s, resM))
      countd = topC;
    if (resM[0]>=0) return;
    else
      println("bug found");
  }

  void findFree(State s, int [] resM)
  {
    resM[0] = -1;
    int id = s.countFreeAngle();
    for (int i = 0; i<= 6; ++i)
      for (int j = 0; j <= 9; ++j)
      {
        if (i< 6)
        {
          if (!s.isCheckedVertical(i, j))
          {
            id-= random(1, 3);
            resM[0] = 1;
            resM[1] = i;
            resM[2] = j;
          }
        }
        if (id<0) return;

        if (j< 9)
        {
          if (!s.isCheckedHorizontal(i, j)) 
          {
            id-= random(1, 3);
            resM[0] = 0;
            resM[1] = i;
            resM[2] = j;
          }
          if (id<0) return;
        }
      }
  }

  void find3(State s, int [] resM)
  {
    resM[0] = -1;
    for (int i = 0; i< 6; ++i)
      for (int j = 0; j< 9; ++j)
      {
        if (s.getDeg(i, j) == 3)
        {
          //top
          if (!s.isCheckedHorizontal(i, j, 0) &&!s.isCheckedHorizontal(i, j, 1))
          {
            resM[0] = 0;
            resM[1] = i;
            resM[2] = j;
          }
          //buttom
          if (!s.isCheckedHorizontal(i+1, j, 0) &&!s.isCheckedHorizontal(i+1, j, 1))
          {
            resM[0] = 0;
            resM[1] = i+1;
            resM[2] = j;
          }

          //left
          if (!s.isCheckedVertical(i, j, 0) &&!s.isCheckedVertical(i, j, 1))
          {
            resM[0] = 1;
            resM[1] = i;
            resM[2] = j;
          }

          //right
          if (!s.isCheckedVertical(i, j+1, 0) &&!s.isCheckedVertical(i, j+1, 1))
          {
            resM[0] = 1;
            resM[1] = i;
            resM[2] = j+1;
          }
          return;
        }
      }
  }

  void findFreeCell(State s, int [] resM)
  {
    resM[0] = -1;
    int id = s.countfreeD();
    for (int i = 0; i< 6; ++i)
      for (int j = 0; j < 9; ++j)
      {

        if (s.isFreeLeft(i, j))
        {
          resM[0] = 1;
          resM[1] = i;
          resM[2] = j;
          id-= random(1, 3);
        }
        if (id < 0)
          return;

        if (s.isFreeRight(i, j))
        {
          resM[0] = 1;
          resM[1] = i;
          resM[2] = j+1;
          id-= random(1, 3);
        }

        if (id < 0)
          return;

        if (s.isFreeTop(i, j))
        {
          resM[0] = 0;
          resM[1] = i;
          resM[2] = j;
          id-= random(1, 3);
        }

        if (id < 0)
          return;

        if (s.isFreeButtom(i, j))
        {
          resM[0] = 0;
          resM[1] = i+1;
          resM[2] = j;
          id-= random(1, 3);
        }

        if (id < 0)
          return;
      }
  }
}



class ComputerNormal extends DBPlayer
{
  int topC ;
  ComputerNormal(String pname, int delay)
  {
    super(pname);
    topC= delay;
    countd = topC;
  }
  int countd;

  void requestMove(int playerId, State s, int [] resM)
  {
    if (countd<=0)
    {
      findMove(playerId, s, resM);
    }
    countd--;
  }

  boolean checkResult(State s, int [] resM)
  {
    if (resM[0] == 0)
    {
      if (resM[2]<9)  
        if (!s.isCheckedHorizontal(resM[1], resM[2]))
          return true;
    }
    if (resM[0] == 1)
    {
      if (resM[1]<6)  
        if (!s.isCheckedVertical(resM[1], resM[2]))
          return true;
    }
    resM[0] = -1;
    return false;
  }

  void findMove(int playerId, State s, int [] resM)
  {
    resM[0] = -1;
    find3(s, resM);
    if (checkResult(s, resM))
      countd = topC;
    if (resM[0]>=0) return;

    findFreeCell(s, resM);
    if (checkResult(s, resM))
      countd = topC;
    if (resM[0]>=0) return;
    else
      println("free cell not found");
    findFree(s, resM);
    if (checkResult(s, resM))
      countd = topC;
    if (resM[0]>=0) return;
    else
      println("bug found");
  }
  int [][]indx = mallocInt(6, 9);
  int [] count  = new int[55];
  boolean [] freedom  = new boolean[55];

  void findFree(State s, int [] resM)
  {
    resM[0] = -1;
    //int [] temp =new int[]{-1, 0, 0}; 
    int canLost = 100;
    int mId = 0;
    s.trans2Graph(indx, count, freedom);
    for (int i = 0; i<= 6; ++i)
      for (int j = 0; j <= 9; ++j)
      {
        if (i< 6)
        {
          if (!s.isCheckedVertical(i, j))
          {
            int l= 0;
            if (j>0) 
              if (indx[i][j-1]>=0)
                if (s.getDeg(i, j-1) == 2)
                  l+= count[indx[i][j-1]];
            if (j<9 && indx[i][j]>=0) l+= count[indx[i][j]];
            if (l< canLost)
            {
              resM[0] = 1;
              resM[1] = i;
              resM[2] = j;
              canLost = l;
            }
          }
        }


        if (j< 9)
        {
          if (!s.isCheckedHorizontal(i, j)) 
          {
            int l= 0;
            if (i>0) 
              if (indx[i-1][j]>=0)
                if (s.getDeg(i-1, j) == 2)
                  l+= count[indx[i-1][j]];
            if (i<6&& indx[i][j]>=0) l+= count[indx[i][j]];
            if (l< canLost)
            {
              resM[0] = 0;
              resM[1] = i;
              resM[2] = j;
              canLost = l;
            }
          }
        }
      }
    //for (int i = 0; i< 3; ++i) resM[i] = temp[i];
  }

  void find3(State s, int [] resM)
  {
    resM[0] = -1;
    for (int i = 0; i< 6; ++i)
      for (int j = 0; j< 9; ++j)
      {
        if (s.getDeg(i, j) == 3)
        {
          //top
          if (!s.isCheckedHorizontal(i, j, 0) &&!s.isCheckedHorizontal(i, j, 1))
          {
            resM[0] = 0;
            resM[1] = i;
            resM[2] = j;
          }
          //buttom
          if (!s.isCheckedHorizontal(i+1, j, 0) &&!s.isCheckedHorizontal(i+1, j, 1))
          {
            resM[0] = 0;
            resM[1] = i+1;
            resM[2] = j;
          }

          //left
          if (!s.isCheckedVertical(i, j, 0) &&!s.isCheckedVertical(i, j, 1))
          {
            resM[0] = 1;
            resM[1] = i;
            resM[2] = j;
          }

          //right
          if (!s.isCheckedVertical(i, j+1, 0) &&!s.isCheckedVertical(i, j+1, 1))
          {
            resM[0] = 1;
            resM[1] = i;
            resM[2] = j+1;
          }
          return;
        }
      }
  }

  void findFreeCell(State s, int [] resM)
  {
    resM[0] = -1;
    int id = s.countfreeD();
    for (int i = 0; i< 6; ++i)
      for (int j = 0; j < 9; ++j)
      {

        if (s.isFreeLeft(i, j))
        {
          resM[0] = 1;
          resM[1] = i;
          resM[2] = j;
          id-= random(1, 3);
        }
        if (id < 0)
          return;

        if (s.isFreeRight(i, j))
        {
          resM[0] = 1;
          resM[1] = i;
          resM[2] = j+1;
          id-= random(1, 3);
        }

        if (id < 0)
          return;

        if (s.isFreeTop(i, j))
        {
          resM[0] = 0;
          resM[1] = i;
          resM[2] = j;
          id-= random(1, 3);
        }

        if (id < 0)
          return;

        if (s.isFreeButtom(i, j))
        {
          resM[0] = 0;
          resM[1] = i+1;
          resM[2] = j;
          id-= random(1, 3);
        }

        if (id < 0)
          return;
      }
  }
}

class HardComputer extends DBPlayer
{
  int topC ;
  HardComputer(String pname, int delay)
  {
    super(pname);
    topC= delay;
    countd = topC;
  }
  int countd;

  void requestMove(int playerId, State s, int [] resM)
  {
    if (countd<=0)
    {
      findMove(playerId, s, resM);
    }
    countd--;
  }

  boolean checkResult(State s, int [] resM)
  {
    if (resM[0] == 0)
    {
      if (resM[2]<9)  
        if (!s.isCheckedHorizontal(resM[1], resM[2]))
          return true;
    }
    if (resM[0] == 1)
    {
      if (resM[1]<6)  
        if (!s.isCheckedVertical(resM[1], resM[2]))
          return true;
    }
    resM[0] = -1;
    return false;
  }

  void findMove(int playerId, State s, int [] resM)
  {
    resM[0] = -1;
    find3(s, resM);
    if (checkResult(s, resM))
      countd = topC;
    if (resM[0]>=0) return;

    findFreeCell(s, resM);
    if (checkResult(s, resM))
      countd = topC;
    if (resM[0]>=0) return;
    else
      println("free cell not found");
    findFree(s, resM);
    if (checkResult(s, resM))
      countd = topC;
    if (resM[0]>=0) return;
    else
      println("bug found");
  }
  int [][]indx = mallocInt(6, 9);
  int [] count  = new int[55];
  boolean [] freedom  = new boolean[55];

  void findFree(State s, int [] resM)
  {
    resM[0] = -1;
    //int [] temp =new int[]{-1, 0, 0}; 
    int canLost = 100;
    int mId = 0;
    s.trans2Graph(indx, count, freedom);
    for (int i = 0; i<= 6; ++i)
      for (int j = 0; j <= 9; ++j)
      {
        if (i< 6)
        {
          if (!s.isCheckedVertical(i, j))
          {
            int dk = 0;
            int l= 0;
            if (j>0) 
              if (indx[i][j-1]>=0)
                if (s.getDeg(i, j-1) == 2)
                {
                  l+= count[indx[i][j-1]];
                  dk++;
                }
            if (j<9 && indx[i][j]>=0) 
            {
              l+= count[indx[i][j]];
              dk++;
            }
            if (l< canLost||(l<= canLost&& dk ==2))
            {
              resM[0] = 1;
              resM[1] = i;
              resM[2] = j;
              canLost = l;
            }
          }
        }


        if (j< 9)
        {
          if (!s.isCheckedHorizontal(i, j)) 
          {
            int l= 0;
            if (i>0) 
              if (indx[i-1][j]>=0)
                if (s.getDeg(i-1, j) == 2)
                  l+= count[indx[i-1][j]];
            if (i<6&& indx[i][j]>=0) l+= count[indx[i][j]];
            if (l< canLost)
            {
              resM[0] = 0;
              resM[1] = i;
              resM[2] = j;
              canLost = l;
            }
          }
        }
      }
    //for (int i = 0; i< 3; ++i) resM[i] = temp[i];
  }

  void find3(State s, int [] resM)
  {

    resM[0] = -1;
    int canLost = 100;
    int mId = 0;
    s.trans2Graph(indx, count, freedom);
    int lastId = -1;
    int countId = 0;
    int minDid = -1;
    int minS = 1000;
    for (int i = 0; i< 6; ++i)
      for (int j = 0; j< 9; ++j)
      {
        if (s.getDeg(i, j) == 3 && lastId!= indx[i][j] && indx[i][j]>=0 )
        {
          countId ++;
          lastId =indx[i][j]; 
          
          if (count[indx[i][j]]< minS)
          {
            minS = count[indx[i][j]];
            minDid = indx[i][j];
          }
        }
      }
      
    if (countId == 1 && count[1]>0) 
    {
      //println(minDid +" "+ minS);
      if ((freedom[minDid] && minS==2)||(!freedom[minDid] && minS==4))
      {
       // println(minDid +" "+ minS+"---------");
        int ct = s.catchedcounting(0)+s.catchedcounting(1);
        for (int i = 0; i< 6; ++i)
          for (int j = 0; j< 9; ++j)
          {
            if (indx[i][j]== minDid)
            {
              //top
              if (!s.isCheckedHorizontal(i, j))
              {
                State t = s.clone();
                t.checkHorizontal(i, j, 0);
                if (ct == t.catchedcounting(0)+ t.catchedcounting(1) )
                {
                  resM[0] = 0; 
                  resM[1] = i; 
                  resM[2] = j;
                  //println("found");
                  return;
                }
              }
              //buttom
              if (!s.isCheckedHorizontal(i+1, j))
              {
                State t = s.clone();
                t.checkHorizontal(i+1, j, 0);
                if (ct == t.catchedcounting(0)+ t.catchedcounting(1))
                {
                  resM[0] = 0; 
                  resM[1] = i+1; 
                  resM[2] = j;
                 // println("found");
                  return;
                }
              }

              //left
              if (!s.isCheckedVertical(i, j, 0) &&!s.isCheckedVertical(i, j, 1))
              {
                State t = s.clone();
                t.checkVertical(i, j, 0);
                if (ct == t.catchedcounting(0)+ t.catchedcounting(1))
                {
                  resM[0] = 1; 
                  resM[1] = i; 
                  resM[2] = j;
                 // println("found");
                  return;
                }
              }

              //right
              if (!s.isCheckedVertical(i, j+1, 0) &&!s.isCheckedVertical(i, j+1, 1))
              {
                State t = s.clone();
                t.checkVertical(i, j+1, 0);
                if (ct == t.catchedcounting(0)+ t.catchedcounting(1))
                {
                  resM[0] = 1; 
                  resM[1] = i; 
                  resM[2] = j+1;
                 // println("found");
                  return;
                }
              }
            }
          }
      }
      minDid = -1;
    }
    for (int i = 0; i< 6; ++i)
      for (int j = 0; j< 9; ++j)
      {
        if (s.getDeg(i, j) == 3 &&(minDid==-1 || indx[i][j] == minDid))
        {
          //top
          if (!s.isCheckedHorizontal(i, j, 0) &&!s.isCheckedHorizontal(i, j, 1))
          {
            resM[0] = 0; 
            resM[1] = i; 
            resM[2] = j;
          }
          //buttom
          if (!s.isCheckedHorizontal(i+1, j, 0) &&!s.isCheckedHorizontal(i+1, j, 1))
          {
            resM[0] = 0; 
            resM[1] = i+1; 
            resM[2] = j;
          }

          //left
          if (!s.isCheckedVertical(i, j, 0) &&!s.isCheckedVertical(i, j, 1))
          {
            resM[0] = 1; 
            resM[1] = i; 
            resM[2] = j;
          }

          //right
          if (!s.isCheckedVertical(i, j+1, 0) &&!s.isCheckedVertical(i, j+1, 1))
          {
            resM[0] = 1; 
            resM[1] = i; 
            resM[2] = j+1;
          }
          return;
        }
      }
  }

  void findFreeCell(State s, int [] resM)
  {
    resM[0] = -1; 
    int id = s.countfreeD(); 
    for (int i = 0; i< 6; ++i)
      for (int j = 0; j < 9; ++j)
      {

        if (s.isFreeLeft(i, j))
        {
          resM[0] = 1; 
          resM[1] = i; 
          resM[2] = j; 
          id-= random(1, 3);
        }
        if (id < 0)
          return; 

        if (s.isFreeRight(i, j))
        {
          resM[0] = 1; 
          resM[1] = i; 
          resM[2] = j+1; 
          id-= random(1, 3);
        }

        if (id < 0)
          return; 

        if (s.isFreeTop(i, j))
        {
          resM[0] = 0; 
          resM[1] = i; 
          resM[2] = j; 
          id-= random(1, 3);
        }

        if (id < 0)
          return; 

        if (s.isFreeButtom(i, j))
        {
          resM[0] = 0; 
          resM[1] = i+1; 
          resM[2] = j; 
          id-= random(1, 3);
        }

        if (id < 0)
          return;
      }
  }
}