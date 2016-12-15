class Button
{
  private boolean lastM;
  int x, y;
  int w, h;
  PImage i, i1, i2;

  boolean pressed = false; 

  public Button(int x, int y, PImage i1, PImage i2)
  {

    i = i1;
    this.i1 = i1;
    this.i2 = i2;
    w = i.width;
    h = i.height;
    this.x =x;
    this.y=y;
  }


  boolean overRect(int x, int y, int width, int height) {
    if (mouseX_M >= x && mouseX_M <= x + width && 
      mouseY_M >= y && mouseY_M <= y + height) {
      return true;
    } else {
      return false;
    }
  }


  void update() 
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

  boolean over() 
  {
    if ( overRect(x, y, w, h) ) {
      return true;
    } else {
      return false;
    }
  }

  void display() 
  {
    image(i, x, y);
  }

  void onClick()
  {
  }
}