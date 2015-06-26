package sge.geom;

import openfl.geom.Point;


class Position implements IHasPosition
{

  public var x(get, set) :Float;
  public var y(get, set) :Float;
  public var point(get, set) :Point;
  public var anchor(get, set) :Point;
  public var rotation(get, set) :Float;
  // previous position values (readonly)
  public var px(get, null) :Float;
  public var py(get, null) :Float;
  public var pr(get, null) :Float;


  public function new()
  {
    _px = 0;
    _py = 0;
    _pr = 0;
    _point = new Point();
    _anchor = new Point();
    _r = 0;
  }


  public inline function get_x() :Float { return _point.x; }
  public inline function set_x( value :Float ) :Float { 
    _px = _point.x;
    return _point.x = value; 
  }

  public inline function get_y() :Float { return _point.y; }
  public inline function set_y( value :Float ) :Float { 
    _py = _point.y;
    return _point.y = value; 
  }

  public function get_point() :Point { return _point; }
  public function set_point( value :Point ) :Point { 
    _px = _point.x;
    _py = _point.y;
    return _point = value; 
  }
  private var _point :Point;

  public function get_anchor() :Point { return _anchor; }
  public function set_anchor( value :Point ) :Point { return _anchor = value; }
  private var _anchor :Point;

  public function get_rotation() :Float { return _r; }
  public function set_rotation( value :Float ) :Float { 
    _pr = _r;
    return _r = value; 
  }
  private var _r :Float;


  public function get_px() :Float { return _px; }
  private var _px :Float;

  public function get_py() :Float { return _py; }
  private var _py :Float;

  public function get_pr() :Float { return _pr; }
  private var _pr :Float;

}