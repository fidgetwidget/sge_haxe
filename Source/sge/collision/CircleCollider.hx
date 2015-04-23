package sge.collision;

import openfl.display.Graphics;
import openfl.geom.Point;
import sge.entity.Entity;
import sge.scene.Scene;


class CircleCollider extends Collider
{

  public var radius :Float;


  public function new( body :Entity, radius :Float )
  {
    this.radius = radius;
    super(body);
  }

  override public function debug_render( g :Graphics, scene :Scene ) :Void 
  {
    g.drawCircle(scene.x + x, scene.y + y, radius);
  }
  

  override private function get_hw() :Float { return radius; }
  override private function get_hh() :Float { return radius; }

}