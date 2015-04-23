package sge.scene;

import openfl.geom.Point;
import sge.math.Random;
import sge.entity.Entity;


class Camera
{

  public var scene :Scene;
  public var following :Entity;
  
  public var target_x :Int;
  public var target_y :Int;
  public var target_duration :Float;
  public var target_delta :Float;
  public var hasTarget :Bool;
  
  public var shake_intensity :Float;
  public var shake_duration :Float;
  public var shake_frequency :Int;
  public var shake_delta :Float;
  public var hasShake :Bool;

  public var start_x :Int;
  public var start_y :Int;
  public var offset_x :Float;
  public var offset_y :Float;
  public var offset_duration :Float;
  public var offset_delta :Float;
  public var hasOffset :Bool;

  public var x(get, set) :Float;
  public var y(get, set) :Float;
  public var ix(get, set) :Int;
  public var iy(get, set) :Int;
  public var cx(get, set) :Float;
  public var cy(get, set) :Float;


  public function new( scene :Scene )
  {
    this.scene = scene;
    target_x = ix;
    target_y = iy;
    hasTarget = false;
    r = Random.getInstance(1);
  }
  private var r :Random;


  public function follow( target :Entity )
  {
    following = target;
  }


  public function moveTo( x :Int, y :Int, duration :Float = 0.3 ) :Void
  {
    target_x = x;
    target_y = y;
    target_delta = 0;
    target_duration = duration;
    hasTarget = true;
  }


  public function shake( intensity :Float = 7, frequency :Int = 3, duration :Float = 0.033 ) :Void
  {
    offset_x = 0;
    offset_y = 0;
    shake_intensity = intensity;
    shake_frequency = frequency;
    shake_duration = duration;
    hasShake = true;
    setShakeOffset();
  }

  private function setShakeOffset() :Void
  {
    shake_delta -= shake_duration;
    dir = r.randomDir( dir );

    if (following == null) {

      if (!hasShake) {
        start_x = ix;
        start_y = iy;  
      }
      target_x = Math.floor(dir.x * shake_intensity * 0.5);
      target_y = Math.floor(dir.y * shake_intensity * 0.5);
      target_delta = 0;
      target_duration = shake_duration;
      hasTarget = true; 

    } else {

      start_x = Math.floor(offset_x);
      start_y = Math.floor(offset_y);
      offset_x = dir.x * shake_intensity;
      offset_y = dir.y * shake_intensity;
      offset_delta = 0;
      offset_duration = shake_duration;
      hasOffset = true;  

    }
    
  }


  public function cancel() :Void
  {
    hasTarget = false;
    hasOffset = false;
    hasShake = false;
    start_x = 0;
    start_y = 0;
    offset_x = 0;
    offset_y = 0;
  }


  public function update() :Void
  {
    // Do Shake
    if (hasShake) {
      shake_delta += Game.delta;
      if (shake_delta >= shake_duration) 
      {
        shake_frequency -= 1;
        shake_delta = 0;
        if (shake_frequency <= 0) {
          
          if (following == null) {
            target_x = start_x;
            target_y = start_y;
            start_x = 0;
            start_y = 0;
            target_delta = 0;
            target_duration = shake_duration;
            hasTarget = true;
          } else {
            start_x = Math.floor(offset_x);
            start_y = Math.floor(offset_y);
            offset_x = 0;
            offset_y = 0;
            offset_delta = 0;
            offset_duration = shake_duration;
            hasOffset = true;
          }
          hasShake = false;
          
        } else {
          setShakeOffset();
        }
      }
    }

    if (following != null) {
      cx = following.x;
      cy = following.y;
    }

    // Do Move
    if (hasTarget) {
      target_delta += Game.delta; 
      delta = target_delta / target_duration;
      if (target_delta >= target_duration)
      {
        delta = 1;
        target_delta = 0;
        hasTarget = false;
      }
      x = lerp(x, target_x, delta);
      y = lerp(y, target_y, delta);
    }

    if (hasOffset) {
      offset_delta += Game.delta;
      delta = offset_delta / offset_duration;
      if (offset_delta >= offset_duration)
      {
        delta = 1;
        offset_delta = 0;
        hasOffset = false;
      }
      offset_x = lerp(start_x, offset_x, delta);
      offset_y = lerp(start_y, offset_y, delta);

      x += offset_x;
      y += offset_y;
    }
    
  }
  private var dir :Point;
  private var delta :Float;


  private function lerp( current :Float, target :Float, delta :Float ) :Float {
    return current + (target - current) * delta;
  }


  private function get_x() :Float { return scene.x; }
  private function set_x( value :Float ) :Float { return scene.x = value; }
  private function get_y() :Float { return scene.y; }
  private function set_y( value :Float ) :Float { return scene.y = value; }

  private function get_ix() :Int { return Math.floor(scene.x); }
  private function set_ix( value :Int ) :Int { 
    scene.x = value; 
    return value; 
  }
  private function get_iy() :Int { return Math.floor(scene.y); }
  private function set_iy( value :Int ) :Int { 
    scene.y = value; 
    return value; 
  }

  private function get_cx() :Float { return scene.x + (Game.stage.stageWidth * 0.5); }
  private function set_cx( value :Float ) :Float { 
    scene.x = (Game.stage.stageWidth * 0.5) - value; 
    return value; 
  }
  private function get_cy() :Float { return scene.y + (Game.stage.stageHeight * 0.5); }
  private function set_cy( value :Float ) :Float { 
    scene.y = (Game.stage.stageHeight * 0.5) - value; 
    return value; 
  }

}
