package sge.input;

import openfl.events.MouseEvent;

 
class Mouse {

  // Static Button reference
  public static inline var LEFT_MOUSE_BUTTON = 0;
  public static inline var MIDDLE_MOUSE_BUTTON = 1;
  public static inline var RIGHT_MOUSE_BUTTON = 2;


  public static var buttons :Array<InputState>;
  public static var wheel :InputState;
  public static var wheelDelta(get, never) :Float;
  public static var x :Float;
  public static var y :Float;


  public static function init()
  {
    buttons = new Array<InputState>();
    buttons[Mouse.LEFT_MOUSE_BUTTON] = { current:0, last:0 };
    wheel = { current:0, last:0 };

    var stage = Game.stage;
    stage.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown_left );
    stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp_left );
    stage.addEventListener( MouseEvent.MOUSE_WHEEL, onMouseWheel );
#if !js
    buttons[Mouse.MIDDLE_MOUSE_BUTTON] = { current:0, last:0 };
    buttons[Mouse.RIGHT_MOUSE_BUTTON] = { current:0, last:0 };

    stage.addEventListener( MouseEvent.MIDDLE_MOUSE_DOWN, onMouseDown_middle );
    stage.addEventListener( MouseEvent.MIDDLE_MOUSE_UP, onMouseUp_middle );
    stage.addEventListener( MouseEvent.RIGHT_MOUSE_DOWN, onMouseDown_right );
    stage.addEventListener( MouseEvent.RIGHT_MOUSE_UP, onMouseUp_right );
#end
  }


  // -----------------------------------
  // Mouse Input State Check
  // -----------------------------------

  public static function isDown( ?button :Int ) :Bool
  {
    if (button == null) { button = Mouse.LEFT_MOUSE_BUTTON; }
    return buttons[button].current > 0;
  }

  public static function pressed( ?button :Int ) :Bool
  {
    if (button == null) { button = Mouse.LEFT_MOUSE_BUTTON; }
    return buttons[button].current == 2;
  }

  public static function released( ?button :Int ) :Bool
  {
    if (button == null) { button = Mouse.LEFT_MOUSE_BUTTON; }
    return buttons[button].current == -1;
  }

  // Property
  private static function get_wheelDelta() :Float
  {
    return wheel.current;
  }


  // -----------------------------------
  // Mouse State Update
  // -----------------------------------

  public static function update() :Void
  {
    for (i in 0...buttons.length) {
      _o = buttons[i];
      if (_o == null) continue;
      
      if ( _o.last == -1 && _o.current == -1 ) 
      {
        _o.current = 0;
      }
      else if ( _o.last == 2 && _o.current == 2 ) 
      {
        _o.current = 1;
      }
      
      _o.last = _o.current;
    }

    x = Game.stage.mouseX;
    y = Game.stage.mouseY;
    
    wheel.current = 0;
  }


  // -----------------------------------
  // Mouse Events
  // -----------------------------------

  private static function onMouseDown_left( e :MouseEvent ) :Void
  {
    _o = buttons[Mouse.LEFT_MOUSE_BUTTON];
    if ( _o.current > 0 ) {
      _o.current = 1; // is down
    }
    else {
      _o.current = 2; // just pressed
    }
  }

  private static function onMouseUp_left( e :MouseEvent ) :Void
  {
    _o = buttons[Mouse.LEFT_MOUSE_BUTTON];
    if ( _o.current > 0 ) {
      _o.current = -1; // just released
    }
    else {
      _o.current = 0; // is up
    }
  }

  private static function onMouseDown_middle( e :MouseEvent ) :Void
  {
    _o = buttons[Mouse.MIDDLE_MOUSE_BUTTON];
    if ( _o.current > 0 ) {
      _o.current = 1; // is down
    }
    else {
      _o.current = 2; // just pressed
    }
  }

  private static function onMouseUp_middle( e :MouseEvent ) :Void
  {
    _o = buttons[Mouse.MIDDLE_MOUSE_BUTTON];
    if ( _o.current > 0 ) {
      _o.current = -1; // just released
    }
    else {
      _o.current = 0; // is up
    }
  }

  private static function onMouseDown_right( e :MouseEvent ) :Void
  {
    _o = buttons[Mouse.RIGHT_MOUSE_BUTTON];
    if ( _o.current > 0 ) {
      _o.current = 1; // is down
    }
    else {
      _o.current = 2; // just pressed
    }
  }

  private static function onMouseUp_right( e :MouseEvent ) :Void
  {
    _o = buttons[Mouse.RIGHT_MOUSE_BUTTON];
    if ( _o.current > 0 ) {
      _o.current = -1; // just released
    }
    else {
      _o.current = 0; // is up
    }
  }

  private static function onMouseWheel( e :MouseEvent ) :Void
  {
    wheel.last = wheel.current;
    wheel.current = e.delta;
  }

  private static var _o :InputState;

  // -----------------------------------


}