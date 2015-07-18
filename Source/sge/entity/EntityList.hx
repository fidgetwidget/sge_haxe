package sge.entity;

import openfl.display.Graphics;
import sge.collision.Collision;
import sge.scene.Scene;

// EntityList
// 
// The most basic type of EntityManager
// Has no physics or position helpers
// 
class EntityList extends EntityManager {


  private var _entities :Array<Entity>;


  public function new() 
  {
    super();
    _entities = new Array<Entity>();
  }


  override public function update() :Void
  {
    // basic loop through and update all...
    for (e in _entities)
    {
      e.update();
    }
  }

  override public function debug_render( g :Graphics, scene :Scene, structure :Bool = false ) :Void 
  {
    for (e in _entities)
    {
      e.debug_render(g, scene);
    }
  }

  override public function add( entity :Entity ) :Void 
  {
    _entities.push(entity);
  }

  override public function remove( entity :Entity ) :Void 
  {
    _entities.remove(entity);
  }

  override public function near( entity :Entity ) :Array<Entity>
  {
    return _entities;
  }

  override public function collision( entity :Entity, hits :Array<Collision> ) :Bool
  {
    return false;
  }

}