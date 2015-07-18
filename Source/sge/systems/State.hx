package sge.systems;


class State {

  public var name :String;
  public var namager :StateManager;

  public function new( manager :StateManager )
  {
    this.manager = manager;
  }

  public function ready() :Void {}

  public function unload() :Void {}

  public function update() :Void {}

  public function handleInput() :Void {}


}