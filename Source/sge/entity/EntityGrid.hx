package sge.entity;

import haxe.Log;
import openfl.display.Graphics;
import sge.collision.AABB;
import sge.collision.Collision;
import sge.scene.Scene;


// EntityGrid
// 
// A grid space entity manager
// allows for access to entity based on location
// 
class EntityGrid extends EntityManager {

  // TOOD: make the grid square width editable, 
  //       and only use these as the defaults
  public static inline var GRID_SQUARE_WIDTH = 128;
  public static inline var GRID_SQUARE_HEIGHT = 128;
  public static inline var COORD_DELIMITER = '_';

  // these values shouldn't change once the grid is made... 
  // so maybe make these private values instead
  public var grid_square_width :Int;
  public var grid_square_height :Int;

  // entity access helpers
  private var _entitiesById :Map<Int, Entity>;
  private var _entitiesByGrid :Map<String, Array<Entity>>;
  private var _allGridSquares :Array<String>;
  private var _gridSquaresById :Map<Int, Array<String>>;

  public function new() 
  {
    super();
    grid_square_width = GRID_SQUARE_WIDTH;
    grid_square_height = GRID_SQUARE_HEIGHT;

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
      var wasInMotion :Bool = e.inMotion;
      if (wasInMotion) { removeFromGrid(e); }
      e.update();
      if (wasInMotion) { addToGrid(e); }
    }
  }

  override public function debug_render( g :Graphics, scene: Scene, structure :Bool = false ) :Void
  {    
    if (structure)
    {
      for (coord in _allGridSquares)
      {
        var gridCoords :Array<String>,
          xi :Int,
          yi :Int,
          length :Int;

        gridCoords = coord.split(COORD_DELIMITER);
        xi = Std.parseInt(gridCoords[0]);
        yi = Std.parseInt(gridCoords[1]);
        length = _entitiesByGrid.get(coord).length;

        if (length > 0)
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
    var nearEntities :Array<Entity>,
      gridSquares :Array<String>;

    nearEntities = new Array<Entity>();
    gridSquares = _gridSquaresById.get(entity.id);

    for (coord in gridSquares)
    {
      var gridCoords :Array<String>,
        xi :Int,
        yi :Int,
        entitiesInCoord :Array<Entity>;

      gridCoords = coord.split(COORD_DELIMITER);
      xi = Std.parseInt(gridCoords[0]);
      yi = Std.parseInt(gridCoords[1]);
      entitiesInCoord = getAt(xi, yi);

      nearEntities = entitiesInCoord.concat(nearEntities);
      nearEntities.remove(entity);
    }
    return nearEntities;
  }

  override public function collision( entity :Entity, hits :Array<Collision> ) :Bool
  {
    // the entity in needs to have a collider
    if (entity.collider == null) { return false; }
    var hit :Collision,
      entitiesToCheck :Array<Entity>;

    hit = null;
    entitiesToCheck = near(entity);
    // test all the entities near the given entity
    while (entitiesToCheck.length > 0)
    {
      var entityToCheck :Entity = entitiesToCheck.pop();
      // ignore entities that don't have a collider
      if (entityToCheck.collider == null) { continue; }
      // if we need a new collision data
      if (hit == null) { hit = new Collision(); }
      // test for collision
      if (entity.collider.collide(entityToCheck.collider, hit))
      {
        hits.push(hit);
        hit = null;
      }
    }
    return hits.length > 0;
  }


  // ------------------------------
  // Helper Methods
  // ------------------------------

  private function addToGrid( entity :Entity ) :Void
  {
    var bounds :AABB,
      top :Int,
      left :Int,
      bottom :Int,
      right :Int;

    bounds = entity.getBounds();
    top = Math.floor(bounds.t / grid_square_height);
    left = Math.floor(bounds.l / grid_square_width);
    bottom = Math.floor(bounds.b / grid_square_height);
    right = Math.floor(bounds.r / grid_square_width);

    for (xi in left...right+1)
    {
      for (yi in top...bottom+1)
      {
        var gridCoord :String,
          gridSquares :Array<String>,
          entitiesInGrid :Array<Entity>;

        gridCoord = coords(xi, yi);
        if (!_gridSquaresById.exists(entity.id)) {
          _gridSquaresById.set( entity.id, new Array<String>() );
        }
        gridSquares = _gridSquaresById.get(entity.id);
        gridSquares.push(gridCoord);

        if (!_entitiesByGrid.exists(gridCoord)) { 
          _entitiesByGrid.set( gridCoord, new Array<Entity>() ); 
          _allGridSquares.push(gridCoord);
        }
        
        entitiesInGrid = _entitiesByGrid.get(gridCoord);
        entitiesInGrid.push(entity);
      }
    }
  }

  // Return the entities in a given entity grid square location
  private function getAt( x :Int, y :Int ) :Array<Entity>
  {
    return _entitiesByGrid.get(coords(x, y));
  }

  private function removeFromGrid( entity :Entity ) :Void
  {
    var bounds :AABB,
      top :Int,
      left :Int,
      bottom :Int,
      right :Int;

    bounds = entity.getBounds();
    top = Math.floor(bounds.t / grid_square_height);
    left = Math.floor(bounds.l / grid_square_width);
    bottom = Math.floor(bounds.b / grid_square_height);
    right = Math.floor(bounds.r / grid_square_width);

    for (xi in left...right+1)
    {
      for (yi in top...bottom+1)
      {
        var gridCoord :String,
          gridSquares :Array<String>,
          entitiesInGrid :Array<Entity>;

        gridCoord = coords(xi, yi);
        gridSquares = _gridSquaresById.get(entity.id);
        gridSquares.remove(gridCoord);

        if (!_entitiesByGrid.exists(gridCoord)) { continue; }
        entitiesInGrid = _entitiesByGrid.get(gridCoord);
        entitiesInGrid.remove(entity);
      }
    }
  }

  private function coords( xi :Int, yi :Int ) :String
  {
    return '${xi}${COORD_DELIMITER}${yi}';
  }

}