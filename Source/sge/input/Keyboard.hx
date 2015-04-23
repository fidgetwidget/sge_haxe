package sge.input;

import openfl.events.KeyboardEvent;


class Keyboard {


  public static var keys :Array<InputState>;


  public static function init()
  {
    keys = new Array<InputState>();
    initKeys();
    var stage = Game.stage;
    stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
    stage.addEventListener( KeyboardEvent.KEY_UP,   onKeyUp );
  }

  private static function initKeys()
  {

    addKey(Key.ARROW_LEFT);   // 37
    addKey(Key.ARROW_UP);     // 38
    addKey(Key.ARROW_RIGHT);  // 39
    addKey(Key.ARROW_DOWN);   // 40

    addKey(Key.ENTER);      // 13
    addKey(Key.COMMAND);    // 15
    addKey(Key.CONTROL);    // 17
    addKey(Key.ALT);        // 18
    addKey(Key.SPACE);      // 32
    addKey(Key.SHIFT);      // 16 
    addKey(Key.BACKSPACE);  // 8
    addKey(Key.CAPS_LOCK);  // 20  
    addKey(Key.DELETE);     // 46
    addKey(Key.END);        // 35
    addKey(Key.ESCAPE);     // 27 
    addKey(Key.HOME);       // 36
    addKey(Key.INSERT);     // 45
    addKey(Key.TAB);        // 9
    addKey(Key.PAGE_DOWN);  // 34
    addKey(Key.PAGE_UP);    // 33  
    addKey(Key.LEFT_SQUARE_BRACKET); // 219
    addKey(Key.RIGHT_SQUARE_BRACKET); // 221
    addKey(Key.TILDE); // 192

    addKey(Key.A); // 65
    addKey(Key.B); // 66
    addKey(Key.C); // 67
    addKey(Key.D); // 68
    addKey(Key.E); // 69
    addKey(Key.F); // 70
    addKey(Key.G); // 71
    addKey(Key.H); // 72
    addKey(Key.I); // 73
    addKey(Key.J); // 74
    addKey(Key.K); // 75
    addKey(Key.L); // 76
    addKey(Key.M); // 77
    addKey(Key.N); // 78
    addKey(Key.O); // 79
    addKey(Key.P); // 80
    addKey(Key.Q); // 81
    addKey(Key.R); // 82
    addKey(Key.S); // 83
    addKey(Key.T); // 84
    addKey(Key.U); // 85
    addKey(Key.V); // 86
    addKey(Key.W); // 87
    addKey(Key.X); // 88
    addKey(Key.Y); // 89
    addKey(Key.Z); // 90
    
    addKey(Key.F1); // 112
    addKey(Key.F2); // 113
    addKey(Key.F3); // 114
    addKey(Key.F4); // 115
    addKey(Key.F5); // 116
    addKey(Key.F6); // 117
    addKey(Key.F7); // 118
    addKey(Key.F8); // 119
    addKey(Key.F9); // 120
    addKey(Key.F10); // 121
    addKey(Key.F11); // 122
    addKey(Key.F12); // 123
    addKey(Key.F13); // 124
    addKey(Key.F14); // 125
    addKey(Key.F15); // 126

    addKey(Key.NUMBER_0); // 48
    addKey(Key.NUMBER_1); // 49
    addKey(Key.NUMBER_2); // 50
    addKey(Key.NUMBER_3); // 51
    addKey(Key.NUMBER_4); // 52
    addKey(Key.NUMBER_5); // 53
    addKey(Key.NUMBER_6); // 54
    addKey(Key.NUMBER_7); // 55
    addKey(Key.NUMBER_8); // 56
    addKey(Key.NUMBER_9); // 57
    
    addKey(Key.NUMPAD_0); // 96
    addKey(Key.NUMPAD_1); // 97
    addKey(Key.NUMPAD_2); // 98
    addKey(Key.NUMPAD_3); // 99
    addKey(Key.NUMPAD_4); // 100
    addKey(Key.NUMPAD_5); // 101
    addKey(Key.NUMPAD_6); // 102
    addKey(Key.NUMPAD_7); // 103
    addKey(Key.NUMPAD_8); // 104
    addKey(Key.NUMPAD_9); // 105
    addKey(Key.NUMPAD_ADD); // 107
    addKey(Key.NUMPAD_DECIMAL); // 110
    addKey(Key.NUMPAD_DIVIDE); // 111
    addKey(Key.NUMPAD_ENTER); // 108
    addKey(Key.NUMPAD_MULTIPLY); // 106
    addKey(Key.NUMPAD_SUBTRACT); // 109

    addKey(Key.EQUAL); // 187
    addKey(Key.MINUS); // 189
    addKey(Key.BACKSLASH); // 220
    addKey(Key.COMMA); // 188
    addKey(Key.SEMICOLON); // 186
    addKey(Key.PERIOD); // 190
    addKey(Key.QUOTE); // 222
    addKey(Key.SLASH); // 191  
    
  }

  private static function addKey( key :UInt ) :Void
  {
    keys[key] = { current:0, last:0 };
  }

  // -----------------------------------
  // Keyboard Input State Check
  // -----------------------------------

  public static function isDown( key :UInt ) :Bool
  {
    return keys[key].current > 0;
  }

  public static function pressed( key :UInt ) :Bool
  {
    return keys[key].current == 2;
  }

  public static function released( key :UInt ) :Bool
  {
    return keys[key].current == -1;
  }


  // -----------------------------------
  // Keyboard State Update
  // -----------------------------------

  public static function update() :Void
  {
    for (i in 0...keys.length) {
      _o = keys[i];
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
  }


  // -----------------------------------
  // Keyboard Events
  // -----------------------------------

  private static function onKeyDown( e :KeyboardEvent ) :Void
  {
    _keyCode = e.keyCode;
    _o = keys[_keyCode];
    if ( _o == null ) return;
    
    if ( _o.current > 0 ) {
      _o.current = 1; // is down
    }
    else {
      _o.current = 2; // just pressed
    }
  }

  private static function onKeyUp( e :KeyboardEvent ) :Void
  {
    _keyCode = e.keyCode;
    _o = keys[_keyCode];
    if ( _o == null ) return;
    
    if ( _o.current > 0 ) {
      _o.current = -1; // just released
    }
    else {
      _o.current = 0; // is up
    }
  }

  private static var _keyCode :UInt;
  private static var _o :InputState;

  // -----------------------------------


}