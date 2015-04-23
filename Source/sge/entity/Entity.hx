package sge.entity;

import sge.collision.AABB;
import sge.collision.Collider;
import sge.collision.IHasBounds;
import sge.geom.IHasPosition;
import sge.geom.Position;
import sge.math.Motion;
import sge.scene.Scene;
import sge.IHasProperties;
import sge.Properties;
import openfl.geom.Point;
import openfl.display.Graphics;
import openfl.display.DisplayObject;


class Entity implements IHasBounds implements IHasProperties implements IHasPosition {

  private static var unique_id :Int = 0;
  public static function getNextId() :Int 
  {
    return Entity.unique_id++;
  }

  public var id :Int;
  public var name :String;
  
  public var isVisible :Bool;
  public var sprite :DisplayObject;
  
  public var position :Position;
  public var x(get, set) :Float;
  public var y(get, set) :Float;
  public var point(get, set) :Point;
  public var anchor(get, set) :Point;
  public var rotation(get, set) :Float;

  public var motion :Motion;
  public var inMotion(get, never) :Bool;

  public var collider(get, set) :Collider;

  public var width(get, set) :Float;
  public var height(get, set) :Float;
  public var scale_x(get, set) :Float;
  public var scale_y(get, set) :Float;
  public var cx(get, never) :Float;
  public var cy(get, never) :Float;


  public function new()
  {
    id = Entity.getNextId();

    position = new Position();
    width = 0;
    height = 0;
    scale_x = 1;
    scale_y = 1;

    properties = new Properties();

    // set the name from the class
    name = Type.getClassName(Type.getClass(this));
  }


  public function update() :Void
  {
    if (motion != null)
    {
      var t:Float = Game.delta;
      motion.update(t);
      x += motion.x_velocity * t;
      y += motion.y_velocity * t;
    }    
  }

  public function debug_render( g :Graphics, scene :Scene ) :Void 
  {
    g.drawRect(scene.x + x, scene.y + y, width, height);
  }

  // ------------------------------
  // Properties
  // ------------------------------  
  
  public function get_x()                     :Float { return position.x; }
  public function set_x( value:Float )        :Float { return position.x = value; }

  public function get_y()                     :Float { return position.y; }
  public function set_y( value:Float )        :Float { return position.y = value; }

  public function get_point()                 :Point { return position.point; }
  public function set_point( value :Point )   :Point { return position.point = value; }

  public function get_anchor()                :Point { return position.anchor; }
  public function set_anchor( value :Point )  :Point { return position.anchor = value; }

  public function get_rotation()              :Float { return position.rotation; }
  public function set_rotation( value :Float ):Float { return position.rotation = value; }

  public function get_inMotion() :Bool 
  {
    if (motion == null) return false;
    return (motion.x_velocity != 0 || motion.y_velocity != 0);
  }

  public function get_collider()                  :Collider { return _collider; }
  public function set_collider( value:Collider )  :Collider { return _collider = value; }

  private var _collider :Collider;

  public function get_width()                 :Float { return _width; }
  public function set_width( value :Float )   :Float { return _width = value; }

  private var _width :Float;

  public function get_height()                :Float { return _height; }
  public function set_height( value :Float )  :Float { return _height = value; }

  private var _height :Float;

  public function get_scale_x()               :Float { return _scale_x; }
  public function set_scale_x( value:Float )  :Float { return _scale_x = value; }

  private var _scale_x :Float;

  public function get_scale_y()               :Float { return _scale_y; }
  public function set_scale_y( value:Float )  :Float { return _scale_y = value; }

  private var _scale_y :Float;

  public function get_cx()                    :Float { return x + ((0.5 - anchor.x) * width * scale_x); }
  public function get_cy()                    :Float { return y + ((0.5 - anchor.y) * height * scale_y); }

  // ------------------------------
  // IHasBounds
  // ------------------------------

  public function set( name :String, value :Dynamic ) :Void { properties.set(name, value); }
  public function get( name :String ) :Dynamic { return properties.get(name); }
  public function has( name :String ) :Bool { return properties.has(name); }
  private var properties :Properties;

  // ------------------------------
  // IHasBounds
  // ------------------------------
  
  private var _aabb :AABB;
  private var _w :Float;
  private var _h :Float;
  
  public function getBounds() :AABB
  {
    if (_aabb == null) { _aabb = new AABB(); }
    _aabb.center.x  = cx;
    _aabb.center.y  = cy;
    _aabb.width     = width * scale_x;
    _aabb.height    = height * scale_y;
    return _aabb;
  }
  // ------------------------------

}
