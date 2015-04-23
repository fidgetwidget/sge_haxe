package sge.display;

import openfl.display.Bitmap;
import openfl.display.BitmapData;


class FrameSprite
{

  public var spritesheet :Spritesheet;
  public var bitmap :Bitmap;
  public var frame(get, never) :FrameData;
  public var frameIndex(get, set) :Int;



  public function new( spritesheet :Spritesheet, frameIndex :Int )
  {
    bitmap = new Bitmap();
  }



  private function get_frame() :FrameData { return spritesheet.getFrame(_frameIndex); }

  private inline function get_frameIndex() :Int { return _frameIndex; }
  private function set_frameIndex( value :Int ) :Int 
  { 
    _frameIndex = value;
    _setBitmapData();
    return _frameIndex;
  }
  
  private function _setBitmapData() :Void
  {
    bitmap.bitmapData = frame.bitmapData;
    bitmap.x = frame.center.x;
    bitmap.y = frame.center.y;
  }



  private var _frameIndex :Int;

}