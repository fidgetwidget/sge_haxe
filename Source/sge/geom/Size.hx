package sge.geom;


class Size
{

  public var width :Float;
  public var height :Float;

  public function new()
  {
    clear();
  }

  public inline function set( width :Float, height :Float ) :Void
  {
    this.width = width;
    this.height = height;
  }

  public inline function clear() :Void
  {
    width = 0;
    height = 0;
  }

}