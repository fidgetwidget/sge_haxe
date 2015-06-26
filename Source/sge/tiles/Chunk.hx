package sge.tiles;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.geom.Point;
import haxe.Log;
import haxe.ds.Vector;
import sge.collision.TileCollider;
import sge.collision.TilesCollider;
import sge.scene.Scene;


class Chunk extends Sprite
{

  public var tiles :Vector<Int>;
  public var tileChanged :Vector<Bool>;
  public var autotiler :AutoTiler;
  public var world(get, set) :World;
  public var collider :TilesCollider;

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
    collider = new TilesCollider(this);
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
      _gtxx = (xi * TILES.CHUNK_SIZE[0]) + x;
      _gtyy = (yi * TILES.CHUNK_SIZE[1]) + y;

      if ( forceChunk || world.hasChunk(_gtxx, _gtyy) ) {

        // Log.trace('outOfRange getTileId @ ${_gtxx} ${_gtyy}');
        
        return world.getTile(_gtxx, _gtyy);
      } else {
        return -1;
      }
    }
    _gti_index = getTileIndex(x, y);
    return tiles[ _gti_index ];
  }
  private var _gtxx :Int;
  private var _gtyy :Int;
  private var _gti_index :Int;


  public function setTileId( x :Int, y :Int, value :Int ) :Int
  {
    _sti_index = getTileIndex(x, y);

    if (tiles[ _sti_index ] != value) {
      tiles[ _sti_index ] = value;
      updateCollider( x, y, _sti_index, value );
      touchTile( x, y, true );
      return value;
    }
    return value;
  }
  private var _sti_index :Int;


  public function touchTile( x :Int, y :Int, andNeighbors :Bool = false ) :Void 
  { 
    if ( outOfRange(x, y) ) { 
      // Get the id from the world
      _ttxx = (xi * TILES.CHUNK_SIZE[0]) + x;
      _ttyy = (yi * TILES.CHUNK_SIZE[1]) + y;
      return world.touchTile(_ttxx, _ttyy);
    }

    _tt_index = getTileIndex(x, y);
    tileChanged[ _tt_index ] = true;

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
  private var _ttxx :Int;
  private var _ttyy :Int;
  private var _tt_index :Int;
  

  public function getNeighborData( x :Int, y :Int, data :NeighborData = null ) :NeighborData
  {
    _type = getTileId(x, y);
    if (data == null) { data = new NeighborData(); }

    data.n  = ( getTileId(x  , y-1, false) == _type ) ? 1 : 0;
    data.ne = ( getTileId(x+1, y-1, false) == _type ) ? 1 : 0;
    data.e  = ( getTileId(x+1, y  , false) == _type ) ? 1 : 0;
    data.se = ( getTileId(x+1, y+1, false) == _type ) ? 1 : 0;
    data.s  = ( getTileId(x  , y+1, false) == _type ) ? 1 : 0;
    data.sw = ( getTileId(x-1, y+1, false) == _type ) ? 1 : 0;
    data.w  = ( getTileId(x-1, y  , false) == _type ) ? 1 : 0;
    data.nw = ( getTileId(x-1, y-1, false) == _type ) ? 1 : 0;

    return data;
  }
  private var _type :Int;
  

  public function drawTiles() :Void
  {
    // Only Draw the Tiles that have Changed.
    for (x in 0...TILES.CHUNK_SIZE[0]) 
    {
      for (y in 0...TILES.CHUNK_SIZE[1]) 
      {
        _dt_index = getTileIndex( x, y );

        if ( tileChanged[ _dt_index ] == true ) 
        {
          drawTile( x, y );
          tileChanged[ _dt_index ] = false;
        }
      }
    }
  }
  private var _dt_index :Int;


  // Copy the bitmap data for the given tile to the Chunks Bitmap
  private function drawTile( x :Int, y :Int ) :Void
  {
    if (autotiler == null) { return; }
    _dt_target = new Point(x * TILES.TILE_SIZE[0], y * TILES.TILE_SIZE[1]);
    _tile_id = getTileId(x, y);
    autotiler.drawTileTo( _tile_id, getNeighborData(x, y, _nData), _dt_target, bitmap.bitmapData );
  }
  private var _tile_id :Int;
  private var _dt_target: Point;
  private var _nData :NeighborData;


  public function debug_render( g :Graphics, scene :Scene ) :Void
  {
    collider.debug_render(g, scene);
  }


  public function updateCollider( x :Int, y :Int, index :Int, value :Int ) :Void
  {

    if (world.collisionTypeIds.exists(value) && world.collisionTypeIds.get(value)) {

      if (collider.collisionAreas.exists(index)) {
        tbounds = collider.collisionAreas.get(index);
      } else {
        tbounds = new TileCollider();
        tbounds.x = this.x + (TILES.TILE_WIDTH * x);
        tbounds.y = this.y + (TILES.TILE_HEIGHT * y);
        tbounds.width = TILES.TILE_WIDTH;
        tbounds.height = TILES.TILE_HEIGHT;
      }

      tvalue = TileCollider.NONE;
      
      tn = getTileId(x  , y-1, false);
      te = getTileId(x+1, y  , false);
      ts = getTileId(x  , y+1, false);
      tw = getTileId(x-1, y  , false);

      if (!collider.collisionAreas.exists(tn) || collider.collisionAreas.get(tn) == null) {
        tvalue &= TileCollider.DOWN;
      }
      if (!collider.collisionAreas.exists(te) || collider.collisionAreas.get(te) == null) {
        tvalue &= TileCollider.LEFT;
      }
      if (!collider.collisionAreas.exists(ts) || collider.collisionAreas.get(ts) == null) {
        tvalue &= TileCollider.UP;
      }
      if (!collider.collisionAreas.exists(tw) || collider.collisionAreas.get(tw) == null) {
        tvalue &= TileCollider.RIGHT;
      }
      tbounds.directions = tvalue;

      collider.collisionAreas.set( index, tbounds );

    } else {

      collider.collisionAreas.remove( index );

    }

  }
  private var tbounds :TileCollider;
  private var tvalue :Int;
  private var tn :Int;
  private var te :Int;
  private var ts :Int;
  private var tw :Int;

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

}
