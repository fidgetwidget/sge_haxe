package sge.systems;

import haxe.ds.StringMap;


class StateManager {


  private current :State;
  private states :StringMap<State>;


  public function new()
  {
    states = new StringMap();
    current = null;
  }

  public function update() :Void
  {
    if (current != null) {
      current.update();
    }
  }

  public function add( state :State ) :Void
  {
    states.set(state.name, state);
  }

  public function set( name :String ) :State
  {
    if (states.exists(name)) {

      if (current != null)
      {
        current.unload();
      }

      current = states.get(name);
      current.ready();

      return current;
    }

    return null;
  }

}