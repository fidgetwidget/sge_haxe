package sge;

import sge.display.Console;
import sge.entity.Entity;
import sge.input.Joystick;
import sge.input.Keyboard;
import sge.input.Mouse;
import sge.input.Touch;
import sge.math.Random;
import sge.scene.Scene;
import sge.scene.SceneEvent;
import haxe.ds.StringMap;
import haxe.Timer;
import haxe.Log;
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.display.Shape;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.Assets;
import motion.Actuate;


class Game {

  // 
  // Static Access
  // 
  private static var instance :Game;
  public static var root(get, never) :DisplayObject;
  public static var graphics(get, never) :Graphics;
  public static var stage(get, never) :Stage;
  public static var delta(get, never) :Float;
  public static var random(get, never) :Random;
  public static var console(get, never) :Console;
  
  // Members
  public var _root :DisplayObject;
  public var _shape :Shape;
  public var _graphics :Graphics;
  public var _stage :Stage;
  public var _random :Random;

  public var _start   :Float;
  public var _last    :Float;
  public var _current :Float;
  public var _delta   :Float;

  public var isInit :Bool;
  public var isPaused :Bool;

  public var sceneCache :StringMap<Scene>;
  public var activeScene :Scene;


  public function new()
  {
    sceneCache = new StringMap<Scene>();
    activeScene = null;
    isInit = false;
    isPaused = false;

    _random = Random.getInstance( Math.floor(Timer.stamp()) );
    Game.instance = this;
  }

  public function init( root :DisplayObject ) :Void
  {
    _root = root;
    _stage = root.stage;
    _shape = new Shape();
    _graphics = _shape.graphics;
    _stage.addChild(_shape);
    isInit = true;

    _start = _current = Timer.stamp();
    _stage.addEventListener( Event.ACTIVATE,     function(_) resume() );
    _stage.addEventListener( Event.DEACTIVATE,   function(_) pause() );
    _stage.addEventListener( Event.ENTER_FRAME,  function(_) update() );    

    Keyboard.init();
    Mouse.init();
    Touch.init();

#if !js
    Joystick.init();
#end

  }


  public function pause() :Void
  {
    isPaused = true;
    Actuate.pauseAll();
  }

  public function resume() :Void
  {
    isPaused = false;
    Actuate.resumeAll();
  }

  public function update() :Void
  {
    // calculate the delta 
    updateDelta();

    // update state, input, etc
    preUpdate();

    // update logic
    doUpdate();

    // render logic
    doRender();

    // post update/render logic
    postUpdate();

  }

  private function updateDelta() :Void
  {
    _last = _current;
    _current = Timer.stamp();
    _delta = (_current - _last);
  }

  private function preUpdate() :Void
  {
    // Update all of the input managers
    Keyboard.update();
    Mouse.update();
    Touch.update();
#if !js
    Joystick.update();
#end

  }

  private function doUpdate() :Void
  {
    if (activeScene != null && !isPaused)
    {
      activeScene.update();
    }
  }

  private function doRender() :Void
  {
    if (activeScene != null && !isPaused)
    {
      graphics.clear();
      activeScene.render();
    }
  }

  private function postUpdate() :Void
  {

  }

  // ------------------------------
  // Scene Manager
  // ------------------------------

  public function addScene( scene :Scene ) :Void
  {
    scene.init();
    sceneCache.set(scene.name, scene);
  }

  public function pushScene( name :String ) :Scene
  {
    if (!sceneCache.exists(name)) { return null; }

    _scene = sceneCache.get(name);
    _scene.ready();
    return activeScene = _scene;
  }

  public function popScene() :Void
  {
    activeScene.unload();
  }

  public function nextSceen( name: String ) :Void
  {
    if (!sceneCache.exists(name)) { return; }
    _nextScene = name;
    activeScene.addEventListener('unloaded', this.currentSceneUnloaded);
    activeScene.unload();
  }

  public function currentSceneUnloaded( ?e :SceneEvent ) :Void
  {
    activeScene.removeEventListener('unloaded', this.currentSceneUnloaded);
    popScene();
    pushScene( _nextScene );
  }

  private var _nextScene :String; // the name of the next scene to ready
  private var _scene :Scene;

  // ------------------------------
  // Static Properties
  // ------------------------------

  private static function get_root() :DisplayObject 
  {
    if (Game.instance != null && Game.instance.isInit)
    {
      return Game.instance._root;
    }
    else 
    {
      return null;
    }
  }

  private static function get_graphics() :Graphics 
  { 
    if (Game.instance != null && Game.instance.isInit)
    {
      return Game.instance._graphics;
    }
    else 
    {
      return null;
    }
  }

  private static function get_stage() :Stage 
  {
    if (Game.instance != null && Game.instance.isInit)
    {
      return Game.instance._stage;
    }
    else 
    {
      return null;
    }
  }

  private static function get_delta() :Float 
  {
    if (Game.instance != null && Game.instance.isInit)
    {
      return Game.instance._delta;
    }
    else 
    {
      return 0;
    }
  }

  private static function get_random() :Random 
  {
    if (Game.instance != null)
    {
      return Game.instance._random;
    }
    else 
    {
      return null;
    }
  }

  private static function get_console() :Console
  {
    if (Console.instance != null)
    {
      return Console.instance;
    }
    else
    {
      return null;
    }
  }

  // ------------------------------  

}
