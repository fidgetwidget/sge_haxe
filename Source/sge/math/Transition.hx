package sge.math;

/**
 * Transition
 *
 * like a tween... but different.
 */
class Transition {

  public var inDuration :Float;
  public var outDuration :Float;
  public var current :Float;
  public var active :Bool;
  public var paused :Bool;
  public var direction :Int;
  public var callback :Void -> Void;
  public var position(get, never) :Float;
  
  public function new( duration :Float = 0, ?callback :Void -> Void = null ) {
    inDuration = duration;
    outDuration = duration;
    current = 0;
    active = false;
    paused = true;
    direction = 1;

    this.callback = callback;
  }

  // Ready the transition with an optional delay
  public function start( delay :Float = 0 ) :Void 
  {
    active = true;
    paused = false;
    current = -delay * direction;
  }

  // 
  public function update( delta :Float ) :Void 
  {
    if (direction == 0 || !active || paused) { return; }
    current += delta * direction;

    if (direction > 0 ? current >= inDuration : current <= outDuration) {
      this.callback();
      active = false;
    }
  }

  // Toggle the Paused State
  public function pause() :Void { paused = !paused; }

  // Stop the transition
  public function cancel() :Void 
  { 
    active = false;
    // NOTE: not sure yet if I want to reset all the values, 
    //       or move it to a recycle pool or something...
  }

  // Get the current position (0 - 1 value) of the transition
  private inline function get_position() :Float {
    return (direction == 0 ? 0 : current / direction > 0 ? inDuration : outDuration);
  }

}