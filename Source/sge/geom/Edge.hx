package sge.geom;

import openfl.geom.Point;


class Edge
{

  public var start_x :Float;
  public var start_y :Float;

  public var end_x :Float;
  public var end_y :Float;

  public function new()
  {
    clear();
  }

  public inline function set( start_x :Float, start_y :Float, end_x :Float, end_y :Float ) :Void
  {
    this.start_x = start_x;
    this.start_y = start_y;
    this.end_x = end_x;
    this.end_y = end_y;
  }

  public inline function setPoints( start :Point, end :Point ) :Void
  {
    start_x = start.x;
    start_y = start.y;
    end_x = end.x;
    end_y = end.y;
  }

  public inline function clear() :Void
  {
    start_x = 0;
    start_y = 0;
    end_x = 0;
    end_y = 0;
  }

}