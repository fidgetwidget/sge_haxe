package sge.display;

import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.display.Tilesheet;
import openfl.geom.Point;
import openfl.geom.Rectangle;


/**
 * A Simple Wrapper for the openfl Tilesheet
 * 
 * - Allows nicer access to adding/changing the tilesheet tiledata
 * - Currently limited to allowing SCALE & ROTATION, not TRANS_2x2, RGB or ALPHA
 */
class Tileframes
{

  public var tilesheet :Tilesheet;
  public var smooth(get, set) :Bool;
  public var flags(get, set) :Int;
  public var tileData(get, never) :Array<Float>;

  

  public function new( tilesheet :Tilesheet ) 
  {
    this.tilesheet = tilesheet;
    _tileData = new Array<Float>();
  }


  public function addTile( x :Float, y :Float, frame: Int, scale :Float = 0, rotation :Float = 0 ) :Void 
  { 
    // convert to int so that we don't draw off pixel
    x = Std.int(x);
    y = Std.int(y);
    _tileData.push(x);
    _tileData.push(y);
    _tileData.push(frame);
    if ( _useScale )  { _tileData.push(scale); }
    if ( _useRotate ) { _tileData.push(rotation); }
  }
  

  public function clear() :Void 
  {
    while (_tileData.length > 0) {
      _tileData.pop();
    }
  }
  

  public function drawTiles( graphics :Graphics ) :Void 
  {
    if (tilesheet == null) { return; } // throw "drawTiles requires a tilesheet to be set.";    
    tilesheet.drawTiles( graphics, _tileData, _smooth, _flags );
  }



  private inline function get_tileData() :Array<Float> { return _tileData; }

  private inline function get_smooth() :Bool        { return _smooth; }
  private inline function set_smooth( value :Bool ) { return _smooth = value; }

  private inline function get_flags() :Int { return _flags; }
  private inline function set_flags( value :Int ) :Int {
    _flags = value;
    setUseScale();
    setUseRotation();
    return _flags;
  }

  private inline function setUseScale() :Void {
    _useScale = _flags & Tilesheet.TILE_SCALE > 0;
  }
  
  private inline function setUseRotation() :Void {
    _useRotate = _flags & Tilesheet.TILE_ROTATION > 0;
  }



  private var _tileData   :Array<Float>;
  private var _smooth     :Bool = false;
  private var _flags      :Int = 0;
  private var _useScale   :Bool = false;
  private var _useRotate  :Bool = false;

}
