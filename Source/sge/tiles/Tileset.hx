package sge.tiles;

import openfl.display.BitmapData;
import openfl.display.Tilesheet;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import sge.display.AssetManager;
import sge.display.FrameData;


class Tileset
{

  public var name :String;
  public var source(get, set) :BitmapData;
  public var frames :Array<FrameData>;



  public function new( source :Dynamic, frames :Array<FrameData> = null )
  {
    if (frames == null) {
      frames = new Array<FrameData>();
    }
    this.frames = frames;

    if (Std.is(source, String)) { 
      this.source = AssetManager.getBitmap(source);
    } else {
      this.source = source;
    }
  }

  
  public function addFrameData( frame :FrameData ) :Void
  {  
    frames.push( frame );
  }
  
  
  public function addFrame( x : Int, y : Int, width : Int, height : Int, center : Point = null ) : Void 
  {
    rect = new Rectangle( x, y, width, height );
    addFrameRect( rect, center );
  } 

  
  public function addFrameRect( rect : Rectangle, center : Point = null ) : Void 
  {
    addFrameData( FrameData.make(rect, center) );
  }


  public function getFrame( id :Int, ensureBitmapData :Bool = true ) :FrameData
  {
    frame = frames[ id ];
    if (frame != null && frame.bitmapData == null && ensureBitmapData) {
      generateBitmapData( id );
    }
    return frames[ id ];
  }


  public function generateBitmaps() :Void 
  {
    for (i in 0...frames.length) {
      generateBitmapData(i);
    }
  }

  

  private function generateBitmapData( f :Dynamic ) :Void
  {
    if (Std.is(f, FrameData)) {
      frame = f;
    } else {
      frame = frames[ f ];
    }
    bitmapData = new BitmapData(frame.width, frame.height, true);
    rect = new Rectangle(frame.x, frame.y, frame.width, frame.height);
    target = new Point();
    bitmapData.copyPixels(source, rect, target);
    frame.bitmapData = bitmapData;
  }


  private function get_source() :BitmapData { return _source; }
  private function set_source( value :BitmapData ) :BitmapData
  {
    _source = value;
    // we need to reset the frames bitmapData if we change the source image...
    for (frame in frames) {
      if (frame.bitmapData != null) {
        frame.bitmapData = null;
      }
    }  
    return _source;
  }
  private var _source :BitmapData;


  private var bitmapData :BitmapData;
  private var frame :FrameData;
  private var rect :Rectangle;
  private var target :Point;

}
