package sge.collision;

import openfl.geom.Point;


class AABB
{

  // rectangle values 
  public var x(get, set)      :Float; // left
  public var y(get, set)      :Float; // top
  public var width(get, set)  :Float;
  public var height(get, set) :Float;

  public var t(get, never)    :Float;
  public var r(get, never)    :Float; // right
  public var b(get, never)    :Float; // bottom
  public var l(get, never)    :Float;

  public var cx(get, never)   :Float; // center
  public var cy(get, never)   :Float; 

  public var center:Point;
  public var hw:Float; // half width
  public var hh:Float; // half height
  

  public function new() { center = new Point(); }


  public function contains( x:Float, y:Float ) :Bool 
  {
    return (x > l && x < r) && (y > t && y < b);
  }
  public function containsPoint( point :Point ) :Bool
  {
    return contains(point.x, point.y);
  }

  public function collide_aabb( aabb :AABB, ?collision :Collision ) :Bool
  {
    return CollisionMath.aabb_aabb(this, aabb, collision);
  }


  public static function make(x, y, width, height) :AABB
  {
    var aabb = new AABB();
    aabb.hw = width * 0.5;
    aabb.hh = height * 0.5;
    aabb.center.x = x + aabb.hw;
    aabb.center.y = y + aabb.hh;
    return aabb;
  }
  public static function makeCenter(centerX, centerY, halfWidth, halfHeight) :AABB
  {
    var aabb = new AABB();
    aabb.hw = halfWidth;
    aabb.hh = halfHeight;
    aabb.center.x = centerX;
    aabb.center.y = centerY;
    return aabb;
  }

  private inline function get_x() :Float                  { return center.x - hw; }
  private inline function set_x(value:Float) :Float       { return center.x = value + hw; }

  private inline function get_y() :Float                  { return center.y - hh; }
  private inline function set_y(value:Float) :Float       { return center.y = value + hh; }

  private inline function get_height() :Float             { return hh * 2; }
  private inline function set_height(value:Float) :Float  { return hh = value * 0.5; }

  private inline function get_width():Float               { return hw * 2; }
  private inline function set_width(value:Float):Float    { return hw = value * 0.5; }

  private inline function get_t():Float                   { return center.y - hh; }
  private inline function get_r():Float                   { return center.x + hw; }
  private inline function get_b():Float                   { return center.y + hh; }
  private inline function get_l():Float                   { return center.x - hw; }

  private inline function get_cx() :Float                 { return center.x; }
  private inline function get_cy() :Float                 { return center.y; }

}
