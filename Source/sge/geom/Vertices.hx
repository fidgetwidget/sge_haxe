package sge.geom;

import openfl.display.Graphics;
import openfl.geom.Point;
import sge.scene.Scene;

class Vertices
{

  public var points :Array<Point>;
  public var first(get, never) :Point;
  public var last(get, never) :Point;

  public function new( points :Array<Point> = null ) 
  {
    if (points == null) { points = new Array<Point>(); }
    this.points = points;
  }

  public inline function iterator() :Iterator<Point> {
    return points.iterator();
  }

  public inline function get_first() :Point {
    return points[0];
  }

  public inline function get_last() :Point {
    return points[points.length - 1];
  }

}