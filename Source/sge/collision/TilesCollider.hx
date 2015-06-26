package sge.collision;

import openfl.display.Graphics;
import openfl.geom.Point;
import sge.collision.AABB;
import sge.entity.Entity;
import sge.scene.Scene;
import sge.tiles.Chunk;
import sge.tiles.TILES;
import sge.tiles.World;


class TilesCollider extends Collider
{

  public var chunk :Chunk;
  public var outerBounds :AABB;
  public var collisionAreas :Map<Int, TileCollider>;


  public function new( chunk :Chunk )
  {
    super(null);
    this.chunk = chunk;
    collisionAreas = new Map();
    outerBounds = AABB.make(x, y, TILES.CHUNK_WIDTH, TILES.CHUNK_HEIGHT);
  }

  // Get the index for the tile closest to the given position
  public function getClosest( x :Float, y :Float ) :TileCollider
  {
    _c = Math.floor( (x - this.x) / TILES.TILE_SIZE[0] ) + (Math.floor( (y - this.y) / TILES.TILE_SIZE[1]) * TILES.CHUNK_TILES_WIDE);
    if (collisionAreas.exists(_c)) {
      return collisionAreas.get(_c);
    }
    return null;
  }
  private var _c :Int;

  public function getTouching( x :Float, y :Float, width :Float, height :Float, ?results :Array<TileCollider> ) :Array<TileCollider>
  {

    if (results == null) {
      results = new Array();
    }

    _wide = Math.floor(TILES.TILE_SIZE[0] / width);
    _high = Math.floor(TILES.TILE_SIZE[1] / height);

    for (_h in 0..._high) {

      for (_w in 0..._wide) {

        xx = x + (_w * TILES.TILE_SIZE[0]);
        yy = y + (_h * TILES.TILE_SIZE[1]);

        _bounds = getClosest( xx, yy );
        if (_bounds != null) {
          results.push(_bounds);
        }

      }

    }
    return results;

  }
  private var xx :Float;
  private var yy :Float;
  private var _bounds :TileCollider;
  private var _w :Float;
  private var _h :Float;
  private var _wide :Int;
  private var _high :Int;

  override public function debug_render( g :Graphics, scene :Scene ) :Void 
  {

    g.lineStyle(1, 0x003399);
    outerBounds.debug_render(g, scene);

    g.lineStyle(1, 0xaf2233);
    for (_tc in collisionAreas.iterator()) {
      if (_tc != null) {
        _tc.debug_render(g, scene);  
      }
    }
  }
  private var _tc :TileCollider;
  
  override private function get_x() :Float { return chunk.x; }
  override private function get_y() :Float { return chunk.y; }
  override private function get_hw() :Float { return TILES.CHUNK_WIDTH * 0.5; }
  override private function get_hh() :Float { return TILES.CHUNK_HEIGHT * 0.5; }

}