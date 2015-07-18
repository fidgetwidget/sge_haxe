package examples;

import sge.collision.AABB;
import sge.display.Console;
import sge.entity.Entity;
import sge.entity.EntityGrid;
import sge.input.Keyboard;
import sge.input.Key;
import sge.math.Motion;
import sge.math.Transition;
import sge.scene.Scene;
import sge.Game;
import haxe.Log;
import openfl.display.Graphics;


class PlatformTest extends Scene
{

  
  override public function init() :Void
  {
    entities = new EntityGrid();
    transition = new Transition();
    
  }

  override private function onReady() :Void 
  {
    
  }

  override private function onUnload() :Void 
  {
    
  }

  override public function update() :Void
  {
    super.update();
    
    handleInput();
    handleCollisions();
    updateCamera();

  }

  private function handleInput() :Void
  {
    
  }

  private function handleCollisions() :Void
  {

  }

  private function updateCamera() :Void
  {
    
  }

  override public function render() :Void
  {
    
  }

}