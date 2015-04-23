package sge.display;

import sge.tiles.Tileset;


/**
 * Spritesheet 
 * 
 * A Simple Tilset with Animations and get Frame by Name
 */
class Spritesheet extends Tileset
{

  public var animations :Map<String, Animation>;



  public function new( source :Dynamic, frames :Array<FrameData> = null, animations :Map<String, Animation> = null )
  {
    super( source, frames );
    
    if (animations == null) {
      this.animations = new Map<String, Animation>();
    } else {
      this.animations = animations;
    }
  }


  public function addAnimation( anim :Animation ) :Void 
  {  
    animations.set(anim.name, anim); 
  }


  public function getFrameByName( name :String, ensureBitmapData :Bool = true ) :FrameData 
  {
      for (i in 0...frames.length) {
        if (frames[i].name == name) {
          return getFrame( i, ensureBitmapData );
        }
      }

      return null;
  }

}
