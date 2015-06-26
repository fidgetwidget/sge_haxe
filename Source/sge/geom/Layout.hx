package sge.geom;

import openfl.geom.Point;


class Layout
{

  public static var ALIGN_TOP     :Int = 0;
  public static var ALIGN_MIDDLE  :Int = 1;
  public static var ALIGN_BOTTOM  :Int = 2;

  public static var ALIGN_LEFT    :Int = 0;
  public static var ALIGN_CENTER  :Int = 1;
  public static var ALIGN_RIGHT   :Int = 2;

  public static var ALIGN_STRETCH :Int = 3;

  public var parent :Dynamic;
  public var x(get, never) :Float;
  public var y(get, never) :Float;
  public var width(get, never) :Float;
  public var height(get, never) :Float;
  public var vAlign(get, set) :Int;
  public var hAlign(get, set) :Int;
  

  public function new( parent :Dynamic )
  {
    this.parent = parent;
    _padding = new Thickness();
    _margin = new Thickness();
    _vAlign = Layout.ALIGN_TOP;
    _hAlign = Layout.ALIGN_LEFT;
  }

  public function padding( top :Float = 0, ?right :Float, ?bottom :Float, ?left :Float ) :Void
  {
    _padding.set(top, right, bottom, left);
    _padding_changed = true;
  }

  public function margin( top :Float = 0, ?right :Float, ?bottom :Float, ?left :Float ) :Void
  {
    _margin.set(top, right, bottom, left);
    _margin_changed = true;
  }

  public inline function get_x() :Float { 
    if (_margin_changed || _align_changed) {
      switch (hAlign) {
        case ALIGN_LEFT:
          _x = parent.x + _margin.left;
        case ALIGN_STRETCH:
          _x = parent.x + _margin.left;
        case ALIGN_RIGHT:
          _x = (parent.x + parent.width) - width - _margin.right;
      }
    }
    return _x; 
  }
  public inline function get_y() :Float { 
    if (_margin_changed || _align_changed) {
      switch (vAlign) {
        case ALIGN_TOP:
          _y = parent.y + _margin.top;
        case ALIGN_STRETCH:
          _y = parent.y + _margin.top;
        case ALIGN_BOTTOM:
          _y = (parent.y + parent.height) - height - _margin.bottom;
      }
    }
    return _y; 
  }

  public inline function get_vAlign() :Int { return _vAlign; }
  public inline function set_vAlign( value :Int ) :Int { 
    _vAlign = value; 
    _align_changed = true; 
    return _vAlign; 
  }
  public inline function get_hAlign() :Int { return _hAlign; }
  public inline function set_hAlign( value :Int ) :Int { 
    _hAlign = value; 
    _align_changed = true; 
    return _hAlign; 
  }

  private var _x :Float;
  private var _y :Float;
  private var _padding :Thickness;
  private var _padding_changed :Bool;
  private var _margin :Thickness;
  private var _margin_changed :Bool;
  private var _vAlign :Int;
  private var _hAlign :Int;
  private var _align_changed :Bool;

}