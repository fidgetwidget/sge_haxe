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

  public function new( points :Array<Point> = null ) 
  {
    if (points == null) { this.points = new Array<Point>(); }
    this.points = points;
    calculateMidpoint();
  }

  private function calculateMidpoint() :Void
  {
    if (midpoint == null) { midpoint = new Point(); }
    _t = _b = vertices[0].y;
    _l = _r = vertices[0].x;
    for (point in vertices)
    {
      _t = point.y < _t ? point.y : _t;
      _r = point.x > _r ? point.x : _r;
      _b = point.y > _b ? point.y : _b;
      _l = point.x < _l ? point.x : _l;
    }
    width = _r - _l;
    height = _b - _t;
    midpoint.x = _l + (width * 0.5);
    midpoint.y = _t + (height * 0.5);
  }
  private var _t :Float;
  private var _r :Float;
  private var _b :Float;
  private var _l :Float;


  public function debug_render( g :Graphics, scene :Scene ) :Void
  {
    end_index = vertices.length - 1;
    g.moveTo(scene.x + vertices[end_index].x, scene.y + vertices[end_index].y);
    for (point in vertices)
    {
      g.lineTo(scene.x + point.x, scene.y + point.y);
    }
  }
  private var end_index :Int;


  private function get_vertices() :Vertices
  {
    if (_vertices == null) { _vertices = new Vertices(points); }
    return _vertices;
  }
  private var points :Array<Point>;
  private var _vertices :Vertices;


  private function get_edges() :Array<Edge>
  {
    if (_edges == null) { 
      _edges = new Array<Edge>(); 
      resetEdges = true;
    }
    if (resetEdges) {
      for (i in 0...vertices.length) {
        n = (i + 1 < vertices.length ? i + 1 : 0);
        edge = new Edge();
        edge.setPoints(vertices[i], vertices[n])
        _edges.push(edge);
      }  
      resetEdges = false;
    }
    return _edges;
  }
  private var n :Int;
  private var resetEdges :Bool;
  private var edge :Edge;
  private var _edges :Array<Edge>;


  // ------------------------------
  // IHasBounds
  // ------------------------------
  
  public function getBounds() :AABB
  {
    if (_aabb == null) { _aabb = new AABB(); }
    _aabb.center.x = midpoint.x;
    _aabb.center.y = midpoint.y;
    _aabb.width = width;
    _aabb.height = height;
    return _aabb;
  }
  private var _aabb :AABB;

  // ------------------------------

}
