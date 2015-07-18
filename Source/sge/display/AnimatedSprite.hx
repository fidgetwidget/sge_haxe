package sge.display;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.Event;


class AnimatedSprite extends FrameSprite
{

  public var current :Animation;
  public var onComplete :Dynamic; // callback function

  private var animQueue :Array<Animation>;
  private var animation :Animation;
  private var animComplete :Bool;

  private var timeElapsed :Int;
  private var loopTime :Int;
  private var ratio :Float;
  private var frameCount :Int;
  private var frameDuration :Int;
  private var timeInAnim :Int;
  private var rawFrameIndex :Int;
  

  public function getFrameData( index :Int ) :Dynamic
  {
    if (current != null && current.frameData.length > index) {
      
      return current.frameData[index];
      
    } else {
      
      return null;
      
    }
  }


  public function queueAnimation( anim :Dynamic ) :Void
  {
    animation = resolveAnimation( anim );
    if (current == null) {

      updateAnimation(animation);

    } else {

      animQueue.push(animation);

    }
  }


  public function resolveAnimation( anim :Dynamic ) :Animation
  {
    if ( Std.is(anim, Animation) ) {
      
      return cast( anim, Animation );
      
    } else if ( Std.is(anim, String) ) {
      
      if (spritesheet != null) {
        
        return spritesheet.animations.get( cast( anim, String ) );
        
      }
      
    }
    
    return null;
  }


  public function showAnimation( anim :Dynamic, restart :Bool = true ) :Void 
  {
    animQueue = new Array<Animation>();

    updateAnimation( resolveAnimation(anim), restart );
  }
  
  
  public function showAnimations( animations :Array<Dynamic> ) :Void 
  {
    animQueue = new Array<Animation>();
    
    for (anim in animations) {
      
      animQueue.push( resolveAnimation(anim) );
      
    }
    
    if (animQueue.length > 0) {
      
      updateAnimation( animQueue.shift() );
      
    }
  }


  public function update( elpasedTime :Int ) :Void
  {
    if ( ! animComplete ) 
    {
      
      timeElapsed += elpasedTime;
      ratio = timeElapsed / loopTime;
      
      if ( ratio >= 1 ) {
        
        if ( current.loop ) {
          
          ratio -= Math.floor( ratio );
          
        } else {
          
          animComplete = true;
          ratio = 1;
          
        }
        
      }
      
      frameCount = current.frames.length;
      frameDuration = Math.round( loopTime / frameCount );
      timeInAnim = timeElapsed % loopTime;
      rawFrameIndex = Math.round( timeInAnim / frameDuration );

      // changing the frameIndex will update the frame and bitmap
      frameIndex = rawFrameIndex % frameCount;
      
      if ( animComplete ) 
      {
        
        if ( animQueue.length > 0 ) {
          updateAnimation( animQueue.shift() );
        } else if ( onComplete ) {  
          onComplete();
        }   
        
      }
      
    }
  }

  

  private function updateAnimation( anim :Animation, restart :Bool = true ) :Void 
  {
    if ( anim != null ) {
      
      if ( restart || anim != current ) {
        
        current = anim;
        timeElapsed = 0;
        animComplete = false;
        
        loopTime = Math.round( (anim.frames.length / anim.frameRate) * 1000 );
        
        if ( bitmap.bitmapData == null ) {
          
          update(0);
          
        }
        
      }
      
    } else {
      
      bitmap.bitmapData = null;
      current = null;
      frameIndex = -1;
      animComplete = true;
      
    }
  }


  override private function get_frame() :FrameData 
  { 
    return spritesheet.getFrame( current.frames[frameIndex] ); 
  }

  override private function _setBitmapData() :Void
  {
    bitmap.bitmapData = frame.bitmapData;
    bitmap.x = frame.center.x - current.center_x;
    bitmap.y = frame.center.y - current.center_x;
  }

}
