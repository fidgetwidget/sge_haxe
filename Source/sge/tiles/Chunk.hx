package sge.tiles;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Point;
import haxe.ds.Vector;


class Chunk extends Sprite
{

  public var tiles :Vector<Int>;
  public var tileChanged :Vector<Bool>;
  public var autotiler :AutoTiler;
  public var world(get, set) :World;


  public function new()
  {
    super();
    tiles = new Vector<Int>( TILES.CHUNK_WIDTH*TILES.CHUNK_HEIGHT );
    tileChanged = new Vector<Bool>( TILES.CHUNK_WIDTH*TILES.CHUNK_HEIGHT );
    bitmap = new Bitmap( new BitmapData(TILES.CHUNK_WIDTH, TILES.CHUNK_HEIGHT, false) );
    addChild(bitmap);
  }

  public function init()
  {
    for (index in 0...tileChanged.length) {
      tileChanged[index] = true;
    }
  }

  public function getTileId( x :Int, y :Int, forceChunk :Bool = true ) :Int
  {
    if ( outOfRange(x, y) ) {
      if (world == null) {
        throw new openfl.errors.Error("Chunk world not set.");
      }
      // Get the id from the world
      xx = (xi * TILES.CHUNK_SIZE[0]) + x;
      yy = (yi * TILES.CHUNK_SIZE[1]) + y;

      if ( forceChunk || world.hasChunk(xx, yy) ) {
        return world.getTile(xx, yy);  
      } else {
        return -1;
      }
    }
    gti_index = getTileIndex(x, y);
    return tiles[ gti_index ];
  }


  public function setTileId( x :Int, y :Int, value :Int ) :Int
  {
    sti_index = getTileIndex(x, y);

    if (tiles[ sti_index ] != value) {
      tiles[ sti_index ] = value;
      touchTile( x, y, true );
      return value;
    }
    return value;
  }


  public function touchTile( x :Int, y :Int, andNeighbors :Bool = false ) :Void 
  { 
    if ( outOfRange(x, y) ) { 
      // Get the id from the world
      xx = (xi * TILES.CHUNK_SIZE[0]) + x;
      yy = (yi * TILES.CHUNK_SIZE[1]) + y;
      return world.touchTile(xx, yy);
    }

    tt_index = getTileIndex(x, y);
    tileChanged[ tt_index ] = true;

    if (andNeighbors) {
      touchTile(x  , y-1);
      touchTile(x+1, y-1);
      touchTile(x+1, y  );
      touchTile(x+1, y+1);
      touchTile(x  , y+1);
      touchTile(x-1, y+1);
      touchTile(x-1, y  );
      touchTile(x-1, y-1);
    }
  }
  

  public function getNeighborData( x :Int, y :Int, data :NeighborData = null ) :NeighborData
  {
    type = getTileId(x, y);
    if (data == null) { data = new NeighborData(); }

    data.n  = ( getTileId(x  , y-1, false) == type ) ? 1 : 0;
    data.ne = ( getTileId(x+1, y-1, false) == type ) ? 1 : 0;
    data.e  = ( getTileId(x+1, y  , false) == type ) ? 1 : 0;
    data.se = ( getTileId(x+1, y+1, false) == type ) ? 1 : 0;
    data.s  = ( getTileId(x  , y+1, false) == type ) ? 1 : 0;
    data.sw = ( getTileId(x-1, y+1, false) == type ) ? 1 : 0;
    data.w  = ( getTileId(x-1, y  , false) == type ) ? 1 : 0;
    data.nw = ( getTileId(x-1, y-1, false) == type ) ? 1 : 0;

    return data;
  }
  

  public function drawTiles() :Void
  {
    // Only Draw the Tiles that have Changed.
    for (x in 0...TILES.CHUNK_SIZE[0]) 
    {
      for (y in 0...TILES.CHUNK_SIZE[1]) 
      {
        dt_index = getTileIndex( x, y );

        if ( tileChanged[ dt_index ] == true ) 
        {
          drawTile( x, y );
          tileChanged[ dt_index ] = false;
        }
      }
    }
  }


  // Copy the bitmap data for the given tile to the Chunks Bitmap
  private function drawTile( x :Int, y :Int ) :Void
  {
    if (autotiler == null) { return; }
    target = new Point(x * TILES.TILE_SIZE[0], y * TILES.TILE_SIZE[1]);
    tile_id = getTileId(x, y);
    autotiler.drawTileTo( tile_id, getNeighborData(x, y, nData), target, bitmap.bitmapData );
  }
  private var tile_id :Int;


  public inline function getTileIndex( x :Int, y :Int ) :Int
  {
    if (x < 0 || y < 0 || x >= TILES.CHUNK_SIZE[0] || y >= TILES.CHUNK_SIZE[1]) { 
      throw new openfl.errors.Error('Index out of Range - Chunk[ x: $x y: $y ]');
    }
    return x + (y * TILES.CHUNK_SIZE[0]);
  }

  private inline function outOfRange( x :Int, y :Int ) {
    return (x < 0 || y < 0 || x >= TILES.CHUNK_SIZE[0] || y >= TILES.CHUNK_SIZE[1]);
  }

  private function get_world() :World { return _world; }

  private function set_world( value :World ) :World {
    _world = value;
    // TODO: improve the way we set/get these values to ensure we always get the right ones
    xi = Math.floor(x / TILES.CHUNK_WIDTH);
    yi = Math.floor(y / TILES.CHUNK_HEIGHT);
    return _world;
  }
  private var _world :World;

  // chunk world coords
  private var xi :Int;
  private var yi :Int;

  private var bitmap :Bitmap;
  // Memory Saving
  private var dt_index :Int;
  private var tt_index :Int;
  private var gti_index :Int;
  private var sti_index :Int;
  private var type :Int;
  private var xx :Int;
  private var yy :Int;
  private var target :Point;
  private var nData :NeighborData;

}
