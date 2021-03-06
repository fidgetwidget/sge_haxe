package;

import sge.Game;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import haxe.Log;
import examples.SoccerGameTest in ExampleScene;


class Main extends Sprite {
  
  var game :sge.Game;
  var inited :Bool;
  var debug :Bool = true;
  var _fps :FPS;

  /**
   *  ENTRY POINT 
   */
  function resize(e) 
  {
    if (!inited) init();
    // else (resize or orientation change)
  }
  
  function init() 
  {
    if (inited) return;
    inited = true;
    
    game = new Game();
    game.init(Lib.current);

    if (debug)
    {
      _fps = new FPS(10, 10, 0x000000);
      Game.stage.addChild(_fps);
    }

    var scene = new ExampleScene(null, 'example');
    game.addScene( scene );
    game.pushScene("example");

  }

  /**
   *  SETUP 
   */
  public function new() 
  {
    super();  
    addEventListener(Event.ADDED_TO_STAGE, added);
  }

  function added(e) 
  {
    removeEventListener(Event.ADDED_TO_STAGE, added);

    // setup a resize handler in case we want/need it...
    stage.addEventListener(Event.RESIZE, resize);

    #if ios
    haxe.Timer.delay(init, 100); // iOS 6
    #else
    init();
    #end
  }
  
  public static function main() 
  {
    // static entry point
    Lib.current.stage.align = openfl.display.StageAlign.TOP_LEFT;
    Lib.current.stage.scaleMode = openfl.display.StageScaleMode.NO_SCALE;
    Lib.current.addChild(new Main());
    //
  }
  
}