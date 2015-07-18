package sge.geom;

import openfl.display.Graphics;
import openfl.geom.Point;
import sge.collision.IHasBounds;
import sge.scene.Scene;


class Shape implements IHasBounds
{
 
  public var vertices(get, never) :Vertices;
  public var edges(get, never) :Array<Edge>;
  public var midpoint :Point;
  public var width :Float;
  public var height :Float;

  private var points :Array<Point>;
  

  public function new( points :Array<Point> = null ) 
  {
    if (points == null) { this.points = new Array<Point>(); }
    this.points = points;

    calculateMidpoint();
  }

  private function calculateMidpoint() :Void
  {
    if (midpoint == null) { midpoint = new Point(); }
    var top :Float,
      left :Float,
      bottom :Float,
      right :Float;

    top = bottom = vertices[0].y;
    left = right = vertices[0].x;

    for (point in vertices)
    {
      top = point.y < top ? point.y : top;
      right = point.x > right ? point.x : right;
      bottom = point.y > bottom ? point.y : bottom;
      left = point.x < left ? point.x : left;
    }
    width = right - left;
    height = bottom - top;
    midpoint.x = left + (width * 0.5);
    midpoint.y = top + (height * 0.5);
  }


  public function debug_render( g :Graphics, scene :Scene ) :Void
  {
    var end_index = vertices.length - 1;
    g.moveTo(scene.x + vertices[end_index].x, scene.y + vertices[end_index].y);
    for (point in vertices)
    {
      g.lineTo(scene.x + point.x, scene.y + point.y);
    }
  }


  private function get_vertices() :Vertices
  {
    if (_vertices == null) { _vertices = new Vertices(points); }
    return _vertices;
  }
  private var _vertices :Vertices;


  private function get_edges() :Array<Edge>
  {
    if (edges == null) { 
      edges = new Array<Edge>(); 
      resetEdges = true;
    }
    if (resetEdges) {
      for (i in 0...vertices.length) {
        var n :Int,
          edge :Edge;

        var n = (i + 1 < vertices.length ? i + 1 : 0);
        var edge = new Edge();
        edge.setPoints(vertices[i], vertices[n])
        edges.push(edge);
      }  
      resetEdges = false;
    }
    return edges;
  }
  private var resetEdges :Bool;
  private var edges :Array<Edge>;


  // ------------------------------
  // IHasBounds
  // ------------------------------
  
  public function getBounds() :AABB
  {
    if (bounds == null) { bounds = new AABB(); }
    bounds.center.x = midpoint.x;
    bounds.center.y = midpoint.y;
    bounds.width = width;
    bounds.height = height;
    return bounds;
  }
  private var bounds :AABB;

  // ------------------------------

}
