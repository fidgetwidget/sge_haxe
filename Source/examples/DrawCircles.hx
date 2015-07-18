package examples;

import sge.collision.AABB;
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


class DrawCircles extends Scene
{

  var circles :Array<Entity>;


  override public function init() :Void
  {
    entities = new EntityGrid();
    transition = new Transition();
    circles = new Array<Entity>();
  }

  override private function onReady() :Void 
  {
    // Make a bunch of Circles
    var circle :Entity;
    var d :Float;
    for (i in 0...30)
    {
      circle = new Entity();
      circle.height = circle.width = Game.random.between(30, 60);
      circle.x = Game.random.between(circle.width, Game.stage.stageWidth - circle.width);
      circle.y = Game.random.between(circle.width, Game.stage.stageHeight - circle.width);
      circle.motion = new Motion();
      circle.motion.x_velocity = Game.random.between(0, 60) - 30;
      circle.motion.y_velocity = Game.random.between(0, 60) - 30;
      circle.set('color', Game.random.randomColor());
      circles.push(circle);
      addEntity(circle);
    }
  }

  override private function onUnload() :Void 
  {
    // Get rid of the circles
    var circle :Entity;
    while (circles.length > 0)
    {
      circle = circles.pop();
      removeEntity(circle);
    }
  }

  override public function update() :Void
  {
    super.update();
    updateCamera();

    var _bounds :AABB;
    // test for collisions, and reverse direction
    for (c in circles)
    {
      _bounds = c.getBounds();

      if ( (c.motion.x_velocity > 0 && _bounds.r > Game.stage.stageWidth) ||
           (c.motion.x_velocity < 0 && _bounds.l < 0) ) 
      {
        c.motion.x_velocity *= -1;
      } 
      if ( (c.motion.y_velocity > 0 && _bounds.b > Game.stage.stageHeight) ||
           (c.motion.y_velocity < 0 && _bounds.t < 0) )
      {
        c.motion.y_velocity *= -1;
      }
    }
  }

  private function updateCamera() :Void
  {
    if (Keyboard.isDown(Key.ARROW_UP) || Keyboard.isDown(Key.W))
    {
      this.y += 5;
    }
    else if (Keyboard.isDown(Key.ARROW_DOWN) || Keyboard.isDown(Key.S))
    {
      this.y -= 5;
    }

    if (Keyboard.isDown(Key.ARROW_LEFT) || Keyboard.isDown(Key.A))
    {
      this.x += 5;
    }
    else if (Keyboard.isDown(Key.ARROW_RIGHT) || Keyboard.isDown(Key.D))
    {
      this.x -= 5;
    }

    if (Keyboard.pressed(Key.R))
    {
      this.x = 0;
      this.y = 0;
    }
  }

  override public function render() :Void
  {
    var g :Graphics = Game.graphics;
    var circle :Entity;
    var depth :Float;
    var color :UInt;
    var xx :Float;
    var yy :Float;

    g.lineStyle( 1, 0xff0000 );
    g.drawRect( this.x, this.y, Game.stage.stageWidth, Game.stage.stageHeight );

    g.lineStyle( 1, 0x00ff00 );
    entities.debug_render( g, this, true );

    g.lineStyle( 1, 0x0000ff );
    entities.debug_render( g, this );

    for (c in circles)
    {
      color = c.get('color');
      g.beginFill(color);
      g.lineStyle(1, color, 0.5);
      xx = (this.x + c.x + c.width * 0.5);
      yy = (this.y + c.y + c.height * 0.5);
      g.drawCircle(xx, yy, c.width * 0.5);
      g.endFill();
    }
  }

}