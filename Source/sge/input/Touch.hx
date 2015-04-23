package sge.input;

import openfl.events.TouchEvent;

 
class Touch {

  public static var touchs :Array<TouchState>;
  public static var touchOrder :Array<Int>;


  public static function init()
  {
    touchs = new Array<TouchState>();
    touchOrder = new Array<Int>();

    var stage = Game.stage;
    stage.addEventListener( TouchEvent.TOUCH_BEGIN, onTouchBegin );
    stage.addEventListener( TouchEvent.TOUCH_MOVE, onTouchMove );
    stage.addEventListener( TouchEvent.TOUCH_END, onTouchEnd );
  }


  // -----------------------------------
  // Touch Input State Check
  // -----------------------------------

  public static function getTouchPoints( ?results :Array<TouchState> ) :Array<TouchState>
  {
    if (results == null) { results = new Array<TouchState>(); }
    for (id in touchOrder)
    {
      results.push( touchs[id] );
    }
    return results;
  }

  // -----------------------------------
  // Touch State Update
  // -----------------------------------

  public static function update() :Void
  {
    for (i in 0...touchs.length) {
      _o = touchs[i];
      if (_o == null) continue;
      
      _o.time += Game.delta;
    }
  }

  // -----------------------------------
  // Mouse Events
  // -----------------------------------

  private static function onTouchBegin( e :TouchEvent ) :Void
  {
    _o = { id:e.touchPointID, x: e.stageX, y: e.stageY, startX: e.stageX, startY: e.stageY, time: 0 };
    touchs[e.touchPointID] = _o;
  }

  private static function onTouchMove( e :TouchEvent ) :Void
  {
    _o = touchs[e.touchPointID];
    _o.x = e.stageX;
    _o.y = e.stageY;
  }

  private static function onTouchEnd( e :TouchEvent ) :Void
  {
    _o = touchs[e.touchPointID];
    touchs.remove( _o );
  }

  private static var _o :TouchState;

  // -----------------------------------


}