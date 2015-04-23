package sge.math;

import openfl.geom.Point;

// 
// Motion:
// 
// a simple physical body not concerned with mass or forces 
// with position, rotation, velocity, acceleration, drag and max
// for simple movement that feels good in a game.
// 
class Motion
{

  public var x_velocity(get, set) :Float;
  public var y_velocity(get, set) :Float;
  public var a_velocity :Float;

  public var x_acceleration :Float;
  public var y_acceleration :Float;
  public var a_acceleration :Float;

  public var x_drag :Null<Float>;
  public var y_drag :Null<Float>;
  public var a_drag :Null<Float>;

  public var x_max :Null<Float>;
  public var y_max :Null<Float>;
  public var a_max :Null<Float>;
  
  public var x_gravity :Null<Float>;
  public var y_gravity :Null<Float>;


  public function new()
  {
    v = new Point();
    x_acceleration = 0;
    y_acceleration = 0;
    x_drag = 0;
    y_drag = 0;
    a_velocity = 0;
    a_acceleration = 0;
    a_drag = 0;
  }

  public function update( t:Float ) :Void
  {
    l = 1 / v.length;
    a_velocity = updateVelocity(a_velocity, a_acceleration, a_drag, a_max, t);
    x_velocity = updateVelocity(x_velocity, x_acceleration, x_drag * Math.abs(v.x * l), x_max, t);
    y_velocity = updateVelocity(y_velocity, y_acceleration, y_drag * Math.abs(v.y * l), y_max, t);
    if (x_gravity != null) { x_velocity += updateVelocity(x_velocity, x_gravity, x_drag * Math.abs(v.x * l), x_max, t); }
    if (y_gravity != null) { y_velocity += updateVelocity(y_velocity, y_gravity, y_drag * Math.abs(v.y * l), y_max, t); }
  }

  private inline function updateVelocity( velocity :Float, acceleration :Float, ?drag :Float, ?max :Float, t :Float ) :Float
  {
    if (acceleration != 0) 
    {
      velocity += acceleration;  
    } 
    else if (drag != null)
    {
      _drag = drag;
      if (velocity > 0 && velocity - _drag > 0) {
        velocity -= _drag;
      } else if (velocity < 0 && velocity + _drag < 0) {
        velocity += _drag;
      } else {
        velocity = 0;
      }
    }
    if (max != null)
    {
      if (velocity > max) {
        velocity = max;
      }
      if (velocity < -max) {
        velocity = -max;
      }
    }
    return velocity;
  }

  private function get_x_velocity() :Float { return v.x; }
  private function set_x_velocity( value :Float ) :Float { return v.x = value; }
  private function get_y_velocity() :Float { return v.y; }
  private function set_y_velocity( value :Float ) :Float { return v.y = value; }
  private var v :Point;
  private var l :Float;
  private var _drag :Float;

}