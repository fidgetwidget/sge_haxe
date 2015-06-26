package sge.collision;

import openfl.display.Graphics;
import openfl.geom.Point;
import sge.entity.Entity;
import sge.scene.Scene;


class Collider
{

  public var type :String;
  public var body :Entity;

  public var x(get, never) :Float;
  public var y(get, never) :Float;
  public var hw(get, never) :Float;
  public var hh(get, never) :Float;


  public function new( body :Entity )
  {
    this.body = body;
    type = Type.getClassName(Type.getClass(this));
  }

  public function debug_render( g :Graphics, scene :Scene  ) :Void 
  {
    g.moveTo(scene.x + x - 3, scene.y + y);
    g.lineTo(scene.x + x + 3, scene.y + y);
    g.moveTo(scene.x + x, scene.y + y - 3);
    g.lineTo(scene.x + x, scene.y + y + 3);
  }

  public function contains( x :Float, y:Float ) :Bool 
  { 
    return CollisionMath.contains( this, x, y );
  }

  public function containsPoint( point :Point ) :Bool 
  { 
    return CollisionMath.containsPoint( this, point );
  }

  public function collide( collider :Collider, ?collision :Collision ) :Bool 
  { 
    return CollisionMath.collide( this, collider, collision );
  }

  public function collideGroup( group :Array<Collider>, ?results :Array<Collision> ) :Bool 
  {
    return CollisionMath.collideGroup( this, group, results );
  }


  private function get_x() :Float { return body.cx; }
  private function get_y() :Float { return body.cy; }

  private function get_hw() :Float { return 0; }
  private function get_hh() :Float { return 0; }

}
