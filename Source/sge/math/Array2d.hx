package sge.math;

// 
// Array2d:
// 
// a simple array with 2d access options
// 
class Array2d<T>
{

  private var _array :Array<T>;
  private var _width :Int;


  public function new( width :Int )
  {
    _array = new Array<T>;
    _width = width;
  }

  public function get( x :Int, y :Int ) :T
  {
    return _array[getIndex(x, y)];
  }

  public function set( x :Int, y :Int, value :T ) :Void
  {
    _array[getIndex(x, y)] = value;
    return;
  }

  private inline function getIndex( x :Int, y :Int ) :Int
  {
    return (x + (y * _width));
  }

}