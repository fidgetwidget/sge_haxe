package sge.collision;

import openfl.display.Graphics;
import sge.scene.Scene;


class TileCollider extends AABB
{

  inline public static var NONE       :Int = 0;
  inline public static var UP         :Int = 1 << 00; // 1 << 00 (0x00000001) 
  inline public static var DOWN       :Int = 1 << 01; // 1 << 01 (0x00000002) 
  inline public static var LEFT       :Int = 1 << 02; // 1 << 02 (0x00000004) 
  inline public static var RIGHT      :Int = 1 << 03; // 1 << 03 (0x00000008) 
  inline public static var HORIZONTAL :Int = LEFT | RIGHT;
  inline public static var VERTICAL   :Int = UP | DOWN;
  inline public static var ALL        :Int = UP | DOWN | LEFT | RIGHT;

  public var directions :Int;

  public function new()
  {
    super();
    directions = ALL;
  }

  override public function debug_render( g :Graphics, scene :Scene ) :Void
  {

    switch (directions) {

      case NONE:
        return;

      case ALL: 
        g.drawRect( scene.x + l, scene.y + t, width, height );
        return;

      case HORIZONTAL:
        g.moveTo( scene.x + l,         scene.y + t );
        g.lineTo( scene.x + l,         scene.y + t + height );
        g.moveTo( scene.x + l + width, scene.y + t );
        g.lineTo( scene.x + l + width, scene.y + t + height );
        return;

      case VERTICAL:
        g.moveTo( scene.x + l,         scene.y + t );
        g.lineTo( scene.x + l + width, scene.y + t );
        g.moveTo( scene.x + l,         scene.y + t + height );
        g.lineTo( scene.x + l + width, scene.y + t + height );
        return;

      case UP:
        g.moveTo( scene.x + l,         scene.y + t );
        g.lineTo( scene.x + l + width, scene.y + t );
        return;

      case DOWN:
        g.moveTo( scene.x + l,         scene.y + t + height );
        g.lineTo( scene.x + l + width, scene.y + t + height );
        return;

      case LEFT:
        g.moveTo( scene.x + l,         scene.y + t );
        g.lineTo( scene.x + l,         scene.y + t + height );
        return;

      case RIGHT:
        g.moveTo( scene.x + l + width, scene.y + t );
        g.lineTo( scene.x + l + width, scene.y + t + height );
        return;

    }

  }

}