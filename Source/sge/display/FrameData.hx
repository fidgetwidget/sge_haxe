package sge.display;

import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;


class FrameData
{

  public var name :String;
  public var bitmapData :BitmapData;
  public var rectangle :Rectangle;
  public var x(get, set) :Int;
  public var y(get, set) :Int;
  public var width(get, set) :Int;
  public var height(get, set) :Int;
  public var center :Point;



  public function new( x :Int = 0, y :Int = 0, width :Int = 0, height :Int = 0, center_x :Int = 0, center_y :Int = 0 )
  {
    rectangle = new Rectangle(x, y, width, height);
    center = new Point(center_x, center_y);
    bitmapData = null;
  }



  public inline function get_x() :Int { return Math.round(rectangle.x); }
  public inline function set_x( value :Int ) :Int { return Math.round(rectangle.x = value); }

  public inline function get_y() :Int { return Math.round(rectangle.y); }
  public inline function set_y( value :Int ) :Int { return Math.round(rectangle.y = value); }

  public inline function get_width() :Int { return Math.round(rectangle.width); }
  public inline function set_width( value :Int ) :Int { return Math.round(rectangle.width = value); }

  public inline function get_height() :Int { return Math.round(rectangle.height); }
  public inline function set_height( value :Int ) :Int { return Math.round(rectangle.height = value); }



  public static function make( rectangle :Rectangle, center :Point ) :FrameData
  {
    var frame :FrameData = new FrameData();
    frame.rectangle = rectangle;
    frame.center = center;
    return frame;
  }

}
