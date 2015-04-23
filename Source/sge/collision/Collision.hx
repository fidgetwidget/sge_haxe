package sge.collision;


class Collision
{
  
  // Penetration Vector Values
  public var px :Float;
  public var py :Float;
  // Penetration Normal Vector
  public var nx :Float;
  public var ny :Float;
  // The other collider
  public var collider :Collider;

  public function new()
  {
    clear();
  }

  public function clear() :Void
  {
    px = 0;
    py = 0;
    nx = 0;
    ny = 0;
    collider = null;
  }

  public function toString() :String
  {
    return 'px:${px} py:${py} nx:${nx} ny:${ny} c:${collider}';
  }

}
