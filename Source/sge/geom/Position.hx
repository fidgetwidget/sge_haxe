package sge.geom;

import openfl.geom.Point;


class Position implements IHasPosition
{

  public var x(get, set) :Float;
  public var y(get, set) :Float;
  public var point(get, set) :Point;
  public var anchor(get, set) :Point;
  public var rotation(get, set) :Float;


  public function new()
  {
    point = new Point();
    anchor = new Point();
    rotation = 0;
  }


  public inline function get_x() :Float { return _point.x; }
  public inline function set_x( value :Float ) :Float { return _point.x = value; }

  public inline function get_y() :Float { return _point.y; }
  public inline function set_y( value :Float ) :Float { return _point.y = value; }

  public function get_point() :Point { return _point; }
  public function set_point( value :Point ) :Point { return _point = value; }
  private var _point :Point;

  public function get_anchor() :Point { return _anchor; }
  public function set_anchor( value :Point ) :Point { return _anchor = value; }
  private var _anchor :Point;

  public function get_rotation() :Float { return _r; }
  public function set_rotation( value :Float ) :Float { return _r = value; }
  private var _r :Float;

}