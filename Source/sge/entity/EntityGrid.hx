package sge.entity;

import haxe.Log;
import openfl.display.Graphics;
import sge.collision.AABB;
import sge.collision.Collision;
import sge.scene.Scene;


// EntityGrid
// 
// A grid space entity manager
// allows for access to entitiy based on location
// 
class EntityGrid extends EntityManager {

  public static inline var GRID_SQUARE_WIDTH = 128;
  public static inline var GRID_SQUARE_HEIGHT = 128;

  public var grid_square_width :Int;
  public var grid_square_height :Int;


  public function new() 
  {
    super();
    grid_square_width = EntityGrid.GRID_SQUARE_WIDTH;
    grid_square_height = EntityGrid.GRID_SQUARE_HEIGHT;

    _entitiesById = new Map<Int, Entity>();
    _entitiesByGrid = new Map<String, Array<Entity>>();
    _gridSquaresById = new Map<Int, Array<String>>();
    _allGridSquares = new Array<String>();
  }


  override public function update() :Void
  {
    // basic loop through and update all...
    for (e in _entitiesById)
    {
      _wasInMotion = e.inMotion;
      if (_wasInMotion) { removeFromGrid(e); }
      e.update();
      if (_wasInMotion) { addToGrid(e); }
    }
  }

  override public function debug_render( g :Graphics, scene: Scene, structure :Bool = false ) :Void
  {    
    if (structure)
    {
      for (coord in _allGridSquares)
      {
        _gc = coord.split('_');
        xi = Std.parseInt(_gc[0]);
        yi = Std.parseInt(_gc[1]);

        _length = _entitiesByGrid.get(coord).length;
        if (_length > 0)
        {
          g.drawRect(scene.x + xi * grid_square_width, scene.y + yi * grid_square_height, grid_square_width, grid_square_height);  
        }
      }  
    }
    else
    {
      for (e in _entitiesById)
      {
        e.debug_render(g, scene);
      }  
    }

  }

  override public function add( entity :Entity ) :Void 
  {
    _entitiesById.set(entity.id, entity);
    addToGrid(entity);
  }

  override public function remove( entity :Entity ) :Void 
  {
    _entitiesById.remove(entity.id);
    removeFromGrid(entity);
  }

  override public function near( entity :Entity ) :Array<Entity>
  {
    var results = new Array<Entity>();
    _gridSquares = _gridSquaresById.get(entity.id);

    for (coord in _gridSquares)
    {
      _gc = coord.split('_');
      xi = Std.parseInt(_gc[0]);
      yi = Std.parseInt(_gc[1]);

      _array = getAt(xi, yi);
      results = _array.concat(results);
      results.remove(entity);
    }
    return results;
  }

  override public function collision( entity :Entity, hits :Array<Collision> ) :Bool
  {
    // the entity in needs to have a collider
    if (entity.collider == null) { return false; }

    _hit = null;
    _results = near(entity);
    Game.console.log('near ${_results.length}');
    // test all the entities near the given entity
    while (_results.length > 0)
    {
      _entity = _results.pop();
      // ignore entities that don't have a collider
      if (_entity.collider == null) { continue; }
      // if we need a new collision data
      if (_hit == null) { _hit = new Collision(); }
      // test for collision
      if (entity.collider.collide(_entity.collider, _hit))
      {
        hits.push(_hit);
        _hit = null;
      }
    }
    return hits.length > 0;
  }
  private var _hit :Collision;
  private var _entity :Entity;
  private var _results :Array<Entity>;




  // ------------------------------
  // Helper Methods
  // ------------------------------

  private function addToGrid( entity :Entity ) :Void
  {
    _aabb = entity.getBounds();
    _t = Math.floor(_aabb.t / grid_square_height);
    _l = Math.floor(_aabb.l / grid_square_width);
    _b = Math.floor(_aabb.b / grid_square_height);
    _r = Math.floor(_aabb.r / grid_square_width);

    for (xi in _l..._r+1)
    {
      for (yi in _t..._b+1)
      {
        _str = '${xi}_${yi}';
        if (!_gridSquaresById.exists(entity.id)) {
          _gridSquaresById.set( entity.id, new Array<String>() );
        }
        _gridSquares = _gridSquaresById.get(entity.id);
        _gridSquares.push(_str);

        if (!_entitiesByGrid.exists(_str)) { 
          _entitiesByGrid.set( _str, new Array<Entity>() ); 
          _allGridSquares.push(_str);
        }
        _array = _entitiesByGrid.get(_str);
        _array.push(entity);
      }
    }
  }

  // Return the entities in a given entitiy grid square location
  private function getAt( x :Int, y :Int ) :Array<Entity>
  {
    return _entitiesByGrid.get('${xi}_${yi}');
  }

  private function removeFromGrid( entity :Entity ) :Void
  {
    _aabb = entity.getBounds();
    _t = Math.floor(_aabb.t / grid_square_height);
    _l = Math.floor(_aabb.l / grid_square_width);
    _b = Math.floor(_aabb.b / grid_square_height);
    _r = Math.floor(_aabb.r / grid_square_width);

    for (xi in _l..._r+1)
    {
      for (yi in _t..._b+1)
      {
        _str = '${xi}_${yi}';
        _gridSquares = _gridSquaresById.get(entity.id);
        _gridSquares.remove(_str);

        if (!_entitiesByGrid.exists(_str)) { continue; }
        _array = _entitiesByGrid.get(_str);
        _array.remove(entity);
      }
    }
  }

  private var _entitiesById :Map<Int, Entity>;
  private var _entitiesByGrid :Map<String, Array<Entity>>;
  private var _allGridSquares :Array<String>;
  private var _gridSquares :Array<String>;
  private var _gridSquaresById :Map<Int, Array<String>>;
  private var _str :String;
  private var _aabb :AABB;
  private var _array :Array<Entity>;
  private var _wasInMotion :Bool;
  private var _t :Int;
  private var _r :Int;
  private var _b :Int;
  private var _l :Int;
  private var xi :Int;
  private var yi :Int;
  private var _gc :Array<String>;
  private var _length :Int;

}