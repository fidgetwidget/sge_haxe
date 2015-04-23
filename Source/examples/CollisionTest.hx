package examples;

import sge.collision.AABB;
import sge.collision.BoxCollider;
import sge.collision.CircleCollider;
import sge.collision.Collision;
import sge.collision.CollisionMath;
import sge.display.Console;
import sge.entity.Entity;
import sge.entity.EntityGrid;
import sge.input.Key;
import sge.input.Keyboard;
import sge.input.Mouse;
import sge.math.Motion;
import sge.math.Transition;
import sge.scene.Camera;
import sge.scene.Scene;
import sge.Game;
import haxe.Log;
import openfl.display.Graphics;


class CollisionTest extends Scene
{

  var objects :Array<Entity>;
  var player :Entity;
  var camera :Camera;

  override public function init() :Void
  {
    entities = new EntityGrid();
    transition = new Transition();
    objects = new Array<Entity>();
    camera = new Camera(this);
    _start_x = _start_y = 0;
  }

  override private function onReady() :Void 
  {
    // Make a bunch of Circles
    for (i in 0...30)
    {
      xx = Game.random.between(60, Game.stage.stageWidth - 60);
      yy = Game.random.between(60, Game.stage.stageHeight - 60);
      roll = Game.random.rollSum();
      if (roll > 3) {
        addObject(xx, yy, "Box");
      } else {
        addObject(xx, yy, "Circle");
      }
    }

    player = new Entity();
    player.height = player.width = 30;
    player.x = Game.stage.stageWidth * 0.5 - player.width * 0.5;
    player.y = Game.stage.stageHeight * 0.5 - player.height * 0.5;
    player.motion = new Motion();
    player.motion.x_drag = 10;
    player.motion.y_drag = 10;
    player.collider = new CircleCollider(player, player.height * 0.5);
    player.set('color', 0x333333);
    addEntity(player);

    camera.follow(player);

    g = Game.graphics;
  }
  private var roll :Int;
  private var obj :Entity;
  private var g :Graphics;

  override private function onUnload() :Void 
  {
    while (objects.length > 0)
    {
      obj = objects.pop();
      removeEntity(obj);
    }

    removeEntity(player);
  }


  override public function update() :Void
  {
    super.update();
    handleCollisions();
    handleInput();
    camera.update();
  }


  private function handleCollisions() :Void 
  {
    var _bounds :AABB;
    // test for collisions, and reverse direction
    for (obj in objects)
    {
      _bounds = obj.getBounds();

      if ( (obj.motion.x_velocity > 0 && _bounds.r > Game.stage.stageWidth) ||
           (obj.motion.x_velocity < 0 && _bounds.l < 0) ) 
      {
        obj.motion.x_velocity *= -1;
        // camera.shake();
      } 
      if ( (obj.motion.y_velocity > 0 && _bounds.b > Game.stage.stageHeight) ||
           (obj.motion.y_velocity < 0 && _bounds.t < 0) )
      {
        obj.motion.y_velocity *= -1;
        // camera.shake();
      }
    }

    _bounds = player.getBounds();
    if (_bounds.r > Game.stage.stageWidth ||
        _bounds.l < 0) {
      player.motion.x_velocity *= -1;
    }
    if (_bounds.b > Game.stage.stageHeight ||
        _bounds.t < 0) {
      player.motion.y_velocity *= -1;
    }

    _objs = entities.near(player);
    while (_objs.length > 0)
    {
      obj = _objs.pop();
      if (obj == player) {
        continue;
      }
      if (hit == null) { hit = new Collision(); }
      if (player.collider.collide(obj.collider, hit))
      {
        obj.x -= hit.px;
        obj.y -= hit.py;
        obj.motion.x_velocity += -hit.nx * 8;
        obj.motion.y_velocity += -hit.ny * 8;
      }
    }
  }
  private var dx :Float;
  private var dy :Float;
  private var _objs :Array<Entity>;
  private var hit :Collision;


  private function handleInput() :Void
  {
    if (Keyboard.isDown(Key.W))
    {
      player.motion.y_acceleration = -5;
    }
    else if (Keyboard.isDown(Key.S))
    {
      player.motion.y_acceleration = 5;
    }
    else
    {
      player.motion.y_acceleration = 0;
    }

    if (Keyboard.isDown(Key.A))
    {
      player.motion.x_acceleration = -5;
    }
    else if (Keyboard.isDown(Key.D))
    {
      player.motion.x_acceleration = 5;
    }
    else
    {
      player.motion.x_acceleration = 0;
    }

    if (Keyboard.isDown(Key.ARROW_UP))
    {
      this.y += 5;
    }
    else if (Keyboard.isDown(Key.ARROW_DOWN))
    {
      this.y -= 5;
    }

    if (Keyboard.isDown(Key.ARROW_LEFT))
    {
      this.x += 5;
    }
    else if (Keyboard.isDown(Key.ARROW_RIGHT))
    {
      this.x -= 5;
    }

    if (Keyboard.pressed(Key.R))
    {
      this.x = 0;
      this.y = 0;
    }

    if (Keyboard.pressed(Key.F))
    {
      if (camera.following == null) {
        camera.follow(player);
      } else {
        camera.follow(null);
      }
    }

    if ( !Keyboard.isDown(Key.SPACE) && Keyboard.isDown(Key.SHIFT) && Mouse.isDown(Mouse.LEFT_MOUSE_BUTTON) ) {
      addObject( Mouse.x - camera.x, Mouse.y - camera.y );
    }

    if ( Keyboard.pressed(Key.SPACE) && Mouse.isDown(Mouse.LEFT_MOUSE_BUTTON) ) {
      _start_x = (Mouse.x - Game.stage.stageWidth * 0.5);
      _start_y = (Mouse.y - Game.stage.stageHeight * 0.5);
    }

    if ( Keyboard.isDown(Key.SPACE) && Mouse.isDown(Mouse.LEFT_MOUSE_BUTTON) ) {
      _target_x = Math.floor(_start_x + (Mouse.x - Game.stage.stageWidth * 0.5));
      _target_y = Math.floor(_start_y + (Mouse.y - Game.stage.stageHeight * 0.5));
      camera.moveTo( _target_x, _target_y );
    }
  }
  private var _target_x :Int;
  private var _target_y :Int;
  private var _start_x :Float;
  private var _start_y :Float;


  private function addObject( x:Float, y:Float, shape:String = "Box" ) :Void
  {
    obj = new Entity();
    obj.x = x;
    obj.y = y;
    obj.motion = new Motion();
    obj.motion.x_drag = 0;
    obj.motion.y_drag = 0;
    obj.motion.x_velocity = Game.random.between(0, 60) - 30;
    obj.motion.y_velocity = Game.random.between(0, 60) - 30;
    obj.set('color', Game.random.randomColor());
    switch (shape) {
      case "Circle":
        obj.height = obj.width = Game.random.between(10, 60);
        obj.collider = new CircleCollider(obj, obj.height * 0.5);  
        obj.set('shape', 'circle');
      case "Box":
        obj.width = Game.random.between(10, 20);
        obj.height = Game.random.between(10, 20);
        obj.collider = new BoxCollider(obj, obj.width, obj.height);  
        obj.set('shape', 'box');
    }
    objects.push(obj);
    addEntity(obj);
  }

  private function removeObject( object :Entity ) :Void
  {
    objects.remove(object);
    removeEntity(object);
  }


  override public function render() :Void
  {
    g.lineStyle(1, 0xff0000);
    g.drawRect(this.x, this.y, Game.stage.stageWidth, Game.stage.stageHeight);

    g.lineStyle(1, 0x00ff00);
    entities.debug_render(g, this, true);

    g.lineStyle(1, 0x0000ff);
    // entities.debug_render(g, this);

    for (obj in objects)
    {
      color = obj.get('color');
      g.beginFill(color);
      g.lineStyle(1, color, 0.5);
      obj.collider.debug_render(g, this);      
      g.endFill();
    }

    color = player.get('color');
    g.beginFill(color);
    g.lineStyle(1, color, 0.5);
    xx = (this.x + player.x + player.width * 0.5);
    yy = (this.y + player.y + player.height * 0.5);
    g.drawCircle(xx, yy, player.width * 0.5);
    g.endFill();
  }
  private var shape :String;
  private var color :UInt;
  private var xx :Float;
  private var yy :Float;

}