package sge.geom;


// 
// Simple 4 side values 
// 
// useful for things like margin/padding storage
// has a set function that works similar to css setter for margin/padding
class Thickness
{

  public var top :Float;
  public var right :Float;
  public var bottom :Float;
  public var left :Float;
  

  public function new()
  {
    top = right = bottom = left = 0;
  }

  public inline function set( top :Float = 0, ?right :Float, ?bottom :Float, ?left :Float ) :Void
  {
    if (right == null) { right = top; }
    if (bottom == null) { bottom = top; }
    if (left == null) { left = right; }

    this.top = top;
    this.right = right;
    this.bottom = bottom;
    this.left = left;
  }

}