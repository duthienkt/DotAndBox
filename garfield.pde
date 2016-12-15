
abstract class GActivity implements  GMouseInteraction, GDrawable, GUpdatable
{
  protected final DotAndBox context;
  public GActivity(DotAndBox context)
  {
    this.context = context;
  }
  
  void draw()
  {
  }
  
  void update()
  {
    
  }
  
  void finish()
  {
    this.context.popGActivity();
  }
  
  
  PImage capScr()
  {
    return get(0, 0, width, height);
  }
  
}