package sge.tiles;

import openfl.display.Graphics;
import openfl.display.Sprite;
import haxe.Log;
import sge.scene.Scene;

class World
{

  public var chunks :Map<String, Chunk>;
  public var autotiler :AutoTiler;
  public var scene :Scene;
  public var layer :Sprite;
  public var collisionTypeIds :Map<Int, Bool>;


  public function new( scene :Scene ) 
  {
    chunks = new Map<String, Chunk>();
    layer = new Sprite();
    collisionTypeIds = new Map<Int, Bool>();
    this.scene = scene;
    this.scene.addChild(layer);
  }


  public function getTile( world_x :Int, world_y :Int ) :Int
  {
    // Log.trace('getTile @ ${world_x} ${world_y}');
    _gtchunk = getChunk( world_x, world_y, 'getTile' );

    if (_gtchunk == null) {
      throw new openfl.errors.Error('chunk: ${world_x} ${world_y} returned null.');
      return 0;
    }
    _gttx = getTileX( world_x );
    _gtty = getTileY( world_y );

    // Log.trace('getTile tileXY: ${_gttx} ${_gtty}');

    return _gtchunk.getTileId( _gttx, _gtty );
  }
  private var _gttx :Int;
  private var _gtty :Int;
  private var _gtchunk :Chunk;


  public function setTile( world_x :Int, world_y :Int, typeId :Int ) :Void 
  {
    _stchunk = getChunk( world_x, world_y, 'setTile' );

    if (_stchunk == null) {
      throw new openfl.errors.Error('chunk: ${world_x} ${world_y} returned null.');
      return;
    }
    
    _sttx = getTileX( world_x );
    _stty = getTileY( world_y );

    // Log.trace('setTile tileXY: ${_sttx} ${_stty}');
    // Log.trace('setTile @ ${world_x}_${world_y} id: ${typeId}');

    _stchunk.setTileId( _sttx, _stty, typeId );
  }
  private var _sttx :Int;
  private var _stty :Int;
  private var _stchunk :Chunk;


  public function touchTile( world_x :Int, world_y :Int ) :Void
  {
    _ttchunk = getChunk( world_x, world_y, 'touchTile' );

    if (_ttchunk == null) {
      throw new openfl.errors.Error('chunk: ${world_x} ${world_y} returned null.');
      return;
    }

    _tttx = getTileX( world_x );
    _ttty = getTileY( world_y );

    // Log.trace('touchTile tileXY: ${_tttx} ${_ttty}');

    _ttchunk.touchTile( _tttx, _ttty );
  }
  private var _tttx :Int;
  private var _ttty :Int;
  private var _ttchunk :Chunk;


  public function hasChunk( world_x :Int, world_y :Int ) :Bool 
  {
    return chunks.exists( getChunkId( getChunkX(world_x), getChunkY(world_y) ) );
  }

  public function getChunk( world_x :Int, world_y :Int, from :String = '' ) :Chunk
  {
    if ( ! hasChunk( world_x, world_y) ) {

      // Log.trace('loadChunk @ ${world_x}_${world_y} in getChunk from ${from}');
      
      loadChunk( world_x, world_y );

    }
    return chunks.get( getChunkId( getChunkX(world_x), getChunkY(world_y) ) );
  }

  public function setChunk( world_x :Int, world_y :Int, chunk :Chunk ) :Void 
  {
    // Log.trace('setChunk @ ${world_x}_${world_y}');

    chunk_x = getChunkX(world_x);
    chunk_y = getChunkY(world_y);
    // NOTE: It's important that we set the chunk's x, and y before we set the world
    chunk.x = chunk_x * TILES.CHUNK_WIDTH;
    chunk.y = chunk_y * TILES.CHUNK_HEIGHT;

    chunk.world = this;
    chunk.autotiler = autotiler;
    chunks.set( getChunkId(chunk_x, chunk_y), chunk );
  }
  private var chunk_x :Int;
  private var chunk_y :Int;

  public function removeChunk( world_x :Int, world_y :Int ) :Void
  {
    _rchunk = getChunk( world_x, world_y, 'removeChunk' );
    layer.removeChild(_rchunk);
    chunks.remove( getChunkId( getChunkX(world_x), getChunkY(world_x) ) );
  }
  private var _rchunk :Chunk;


  public function loadChunk( world_x :Int, world_y :Int ) :Void
  {
    _lchunk = new Chunk(); // TODO: load the chunk from some storage
    _lchunk.init();
    setChunk( world_x, world_y, _lchunk );
    layer.addChild( _lchunk );
  }
  private var _lchunk :Chunk;

  public function unloadChunk( world_x :Int, world_y :Int, saveFirst :Bool = true ) :Void
  {
    if ( ! hasChunk( world_x, world_y ) ) { return; }

    if (saveFirst) { saveChunk( world_x, world_y ); }
    
    removeChunk( world_x, world_y );
  }

  public function saveChunk( world_x :Int, world_y :Int ) :Void
  {
    // TODO: save the chunk to some storage
  }


  public function drawChunks() :Void 
  {
    for (chunk in chunks) { chunk.drawTiles(); }
  }

  public function debug_render( g :Graphics, scene :Scene ) :Void
  {
    for (chunk in chunks) { chunk.debug_render(g, scene); } 
  }

  public inline function getChunkId( chunk_x :Int, chunk_y :Int ) :String 
  {
    return '${chunk_x}_${chunk_y}';
  }

  public inline function getChunkX( world_x :Int ) :Int { return Math.floor( world_x / TILES.CHUNK_SIZE[0] ); }
  public inline function getChunkY( world_y :Int ) :Int { return Math.floor( world_y / TILES.CHUNK_SIZE[1] ); }

  public inline function getTileX( world_x :Int ) :Int { return sge.math.MathExt.remainder_int(world_x, TILES.CHUNK_SIZE[0]); }
  public inline function getTileY( world_y :Int ) :Int { return sge.math.MathExt.remainder_int(world_y, TILES.CHUNK_SIZE[0]); }


}
