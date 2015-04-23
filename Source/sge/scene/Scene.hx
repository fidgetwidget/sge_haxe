package sge.scene;

import sge.math.Transition;
import sge.IHasProperties;
import sge.Properties;
import sge.entity.Entity;
import sge.entity.EntityManager;
import sge.entity.EntityList;
import openfl.display.Sprite;
import haxe.Log;


class Scene extends Sprite implements IHasProperties
{

  public var parentScene :Scene;
  public var childScenes :Array<Scene>;
  public var offset_x :Int;
  public var offset_y :Int;
  public var scale_x(get, set) :Float;
  public var scale_y(get, set) :Float;

  public var entities :EntityManager;
  public var transition :Transition;

  public var isVisible :Bool;
  public var isActive :Bool;
  public var isReady :Bool;

  
  public function new( ?parent :Scene )
  {
    super();
    parentScene = parent;
    offset_x = 0;
    offset_y = 0;
    properties = new Properties();
    
    isVisible = false;
    isActive = false;
    isReady = false;
    
    // set the name from the class
    name = Type.getClassName(Type.getClass(this));
  }

  public function init() :Void
  {
    // customize these in your scene
    entities = new EntityList();
    transition = new Transition();
  }

  // ------------------------------
  // Ready
  // ------------------------------
  // Called when the scene is entering the game
  public function ready()
  {
    // Ready it
    onReady();
    Game.stage.addChildAt(this, 0);
    isReady = true;
    isActive = true;
    // Then transition in
    transition.callback = this.transitionInComplete;
    transition.direction = 1;
    transition.start();
  }

  private function onReady() 
  {
    // put the custom behaviour of ready here
  }

  public function transitionInComplete() :Void
  {
    transition.callback = null;
    transition.direction = 0;
    dispatchEvent(new SceneEvent(SceneEvent.READIED));
  }

  // ------------------------------
  // Unload
  // ------------------------------
  // Called when the scene is leaving the game
  public function unload()
  {
    // Transition out
    transition.callback = this.transitionOutComplete;
    transition.direction = -1;
    transition.start();
    // ... THEN unload it
  }

  public function transitionOutComplete() :Void
  {
    transition.callback = null;
    transition.direction = 0;
    // we want to remove stuff AFTER it's transition is over...
    onUnload();
    Game.stage.removeChild(this);
    isReady = false;
    isActive = false;
    dispatchEvent(new SceneEvent(SceneEvent.UNLOADED));
  }

  private function onUnload() 
  {
    // put the custom behaviour of unload here
  }

  
  // == Update ==
  public function update()
  {
    if (!isActive) { return; }
    if (transition.direction != 0) 
    {
      transition.update(Game.delta);
    }
    entities.update();
  }

  // == Render ==
  public function render()
  {

  }


  // ------------------------------
  // Entities
  // ------------------------------
  
  public function addEntity( entity :Entity ) :Void
  {
    // add the sprite to the scene if there is one
    if (entity.sprite != null) { addChild(entity.sprite); }
    entities.add(entity);
  }

  public function removeEntity( entity :Entity ) :Void
  {
    // remove the sprite from the scene if there is one
    if (entity.sprite != null) { removeChild(entity.sprite); }
    entities.remove(entity);
  }

  // ------------------------------
  // IHasProperties
  // ------------------------------
  
  public inline function set( name :String, value :Dynamic ) :Void { properties.set(name, value); }
  public inline function get( name :String ) :Dynamic { return properties.get(name); }
  public inline function has( name :String ) :Bool { return properties.has(name); }

  private var properties :Properties;

  // ------------------------------
  // Properties
  // ------------------------------
  
  private inline function get_scale_x() :Float               { return scaleX; }
  private inline function set_scale_x( value :Float ) :Float { return scaleX = value; }

  private inline function get_scale_y() :Float               { return scaleY; }
  private inline function set_scale_y( value :Float ) :Float { return scaleY = value; }

  // ------------------------------

}
