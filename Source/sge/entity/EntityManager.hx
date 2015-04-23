package sge.entity;

import openfl.display.Graphics;
import openfl.geom.Point;
import sge.collision.Collision;
import sge.scene.Scene;



// Abstract/Psudo Class
class EntityManager {

  // Properties
  public var offset_x :Float = 0;
  public var offset_y :Float = 0;


  public function new() {}

  // Update all of the entities in the manager
  public function update() :Void {}

  public function debug_render( g :Graphics, scene :Scene, structure :Bool = false ) :Void {}
  
  // Add an entity to the manager
  public function add( entity :Entity ) :Void {}

  // Remove an entity from the Entity Manager
  public function remove( entity :Entity ) :Void {}

  // Quickly get at all the entities near the given one - for collision checks, etc
  public function near( entity :Entity ) :Array<Entity> { return null; }

  public function collision( entity :Entity, hits :Array<Collision> ) :Bool { return false; }

}