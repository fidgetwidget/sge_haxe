package sge.scene;

import openfl.display.Sprite;
import sge.IHasProperties;
import sge.Properties;
import sge.entity.Entity;
import sge.entity.EntityManager;
import sge.entity.EntityList;
import sge.math.Transition;
import sge.tiles.AutoTiler;
import sge.tiles.Chunk;
import sge.tiles.TILES;
import sge.tiles.World;



class WorldScene extends Scene
{

  public var world :World;
  

  // Make sure you add this to your init
  // world = new World();
  // world.autotiler = <an AutoTiler>


  public function getTileAt( x :Float, y :Float ) :Int
  {
    return world.getTile( getWorldX(x), getWorldY(y) );
  }


  public function setTileAt( x:Float, y :Float, typeId :Int ) :Void
  {
    world.setTile( getWorldX(x), getWorldY(y), typeId );
  }
  


  private function getChunk( world_x :Int, world_y :Int ) :Chunk
  {
    return world.getChunk( world_x, world_y );
  }


  private function loadChunk( world_x :Int, world_y :Int ) :Void
  {
    world.loadChunk( world_x, world_y );
  }


  private function unloadChunk( world_x :Int, world_y :Int, saveFirst :Bool = true ) :Void
  {
    world.unloadChunk( world_x, world_y, saveFirst );
  }


  private function saveChunk( world_x :Int, world_y :Int ) :Void
  {
    world.saveChunk( world_x, world_y );
  }


  private inline function getWorldX( x :Float ) :Int { return Math.floor( (x - this.x) / TILES.TILE_SIZE[0] ); }
  private inline function getWorldY( y :Float ) :Int { return Math.floor( (y - this.y) / TILES.TILE_SIZE[1] ); }



  private var chunk :Chunk;

}
