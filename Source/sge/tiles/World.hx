package sge.tiles;

import sge.scene.Scene;
import openfl.display.Sprite;


class World
{

  public var chunks :Map<String, Chunk>;
  public var autotiler :AutoTiler;
  public var scene :Scene;
  public var layer :Sprite;



  public function new( scene :Scene ) 
  {
    chunks = new Map<String, Chunk>();
    layer = new Sprite();
    this.scene = scene;
    this.scene.addChild(layer);
  }


  public function getTile( world_x :Int, world_y :Int ) :Int
  {
    tile_x = getTileX( world_x );
    tile_y = getTileY( world_y );
    chunk = getChunk( world_x, world_y );
    if (chunk == null) {
      throw new openfl.errors.Error('chunk: ${world_x} ${world_y} returned null.');
      return 0;
    }
    return chunk.getTileId( tile_x, tile_y );
  }


  public function setTile( world_x :Int, world_y :Int, typeId :Int ) :Void 
  {
    tile_x = getTileX( world_x );
    tile_y = getTileY( world_y );
    chunk_x = getChunkX( world_x );
    chunk_y = getChunkY( world_y );
    chunk = getChunk( world_x, world_y );
    if (chunk == null) {
      throw new openfl.errors.Error('chunk: ${world_x} ${world_y} returned null.');
      return;
    }
    chunk.setTileId( tile_x, tile_y, typeId );
  }


  public function touchTile( world_x :Int, world_y :Int ) :Void
  {
    tile_x = getTileX( world_x );
    tile_y = getTileY( world_y );
    chunk_x = getChunkX( world_x );
    chunk_y = getChunkY( world_y );
    chunk = getChunk( world_x, world_y );
    if (chunk == null) {
      throw new openfl.errors.Error('chunk: ${world_x} ${world_y} returned null.');
      return;
    }
    chunk.touchTile( tile_x, tile_y );
  }


  public function hasChunk( world_x :Int, world_y :Int ) :Bool 
  {
    return chunks.exists( getChunkId( getChunkX(world_x), getChunkY(world_y) ) );
  }

  public function getChunk( world_x :Int, world_y :Int ) :Chunk
  {
    if ( ! hasChunk( world_x, world_y) ) {
      loadChunk( world_x, world_y );
    }
    return chunks.get( getChunkId( getChunkX(world_x), getChunkY(world_y) ) );
  }

  public function setChunk( world_x :Int, world_y :Int, chunk :Chunk ) :Void 
  {
    chunk_x = getChunkX(world_x);
    chunk_y = getChunkY(world_y);
    // NOTE: It's important that we set the chunk's x, and y before we set the world
    chunk.x = chunk_x * TILES.CHUNK_WIDTH;
    chunk.y = chunk_y * TILES.CHUNK_HEIGHT;
    chunk.world = this;
    chunk.autotiler = autotiler;
    chunks.set( getChunkId(chunk_x, chunk_y), chunk );
  }

  public function removeChunk( world_x :Int, world_y :Int ) :Void
  {
    chunk = getChunk( world_x, world_y );
    layer.removeChild(chunk);
    chunks.remove( getChunkId( getChunkX(world_x), getChunkY(world_x) ) );
  }


  public function loadChunk( world_x :Int, world_y :Int ) :Void
  {
    chunk = new Chunk(); // TODO: load the chunk from some storage
    chunk.init();
    setChunk( world_x, world_y, chunk );
    layer.addChild( chunk );
  }

  public function unloadChunk( world_x :Int, world_y :Int, saveFirst :Bool = true ) :Void
  {
    if ( ! hasChunk( world_x, world_y ) ) { return; }

    if (saveFirst) {
      saveChunk( world_x, world_y );
    }
    removeChunk( world_x, world_y );
  }

  public function saveChunk( world_x :Int, world_y :Int ) :Void
  {
    // TODO: save the chunk to some storage
  }


  public function drawChunks() :Void 
  {
    for (chunk in chunks) {
      chunk.drawTiles();
    }
  }



  private inline function getChunkId( chunk_x :Int, chunk_y :Int ) :String 
  {
    return '${chunk_x}_${chunk_y}';
  }

  public inline function getChunkX( world_x :Int ) :Int { return Math.floor( world_x / TILES.CHUNK_SIZE[0] ); }
  public inline function getChunkY( world_y :Int ) :Int { return Math.floor( world_y / TILES.CHUNK_SIZE[1] ); }

  public inline function getTileX( world_x :Int ) :Int { return world_x % TILES.CHUNK_SIZE[0]; }
  public inline function getTileY( world_y :Int ) :Int { return world_y % TILES.CHUNK_SIZE[1]; }

  private var chunk :Chunk;
  private var chunkId :String;
  private var chunk_x :Int;
  private var chunk_y :Int;
  private var tile_x :Int;
  private var tile_y :Int;

}
