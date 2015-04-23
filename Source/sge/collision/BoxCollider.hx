package sge.collision;

import openfl.display.Graphics;
import openfl.geom.Point;
import sge.entity.Entity;
import sge.geom.Edge;
import sge.scene.Scene;


class BoxCollider extends Collider
{

  public var width(get, never) :Float;
  public var height(get, never) :Float;


  public function new( body :Entity, width :Float, height :Float )
  {
    _width = width;
    _height = height;
    super(body);
  }

  override public function debug_render( g :Graphics, scene :Scene ) :Void 
  {
    g.drawRect(scene.x + x - hw, scene.y + y - hh, _width, _height);
  }


  private function get_width() :Float { return _width; }
  private var _width :Float;

  private function get_height() :Float { return _height; }
  private var _height :Float;

  override private function get_hw() :Float { return _width * 0.5; }
  override private function get_hh() :Float { return _height * 0.5; }

}