package examples;

import sge.collision.AABB;
import sge.collision.BoxCollider;
import sge.collision.CircleCollider;
import sge.collision.Collision;
import sge.collision.CollisionMath;
import sge.display.Console;
import sge.entity.Entity;
import sge.entity.EntityList;
import sge.input.Key;
import sge.input.Keyboard;
import sge.input.Mouse;
import sge.math.Motion;
import sge.math.Transition;
import sge.math.Random;
import sge.scene.Camera;
import sge.scene.Scene;
import sge.Game;
import haxe.Log;
import openfl.geom.Point;
import openfl.display.Graphics;


class PongTest extends Scene
{

  var ball :Entity;
  var lpaddle :Entity;
  var rpaddle :Entity;
  var BASE_BALL_SPEED :Int = 200;
  var speed :Int = 0;

  override public function init() :Void
  {
    entities = new EntityList();
    transition = new Transition();
    speed = 0;
  }

  override private function onReady() :Void 
  {
    ball = new Entity();
    ball.height = ball.width = 30;
    ball.x = Game.stage.stageWidth * 0.5 - ball.width * 0.5;
    ball.y = Game.stage.stageHeight * 0.5 - ball.height * 0.5;
    ball.motion = new Motion();
    ball.motion.x_drag = 0;
    ball.motion.y_drag = 0;
    ball.collider = new CircleCollider(ball, ball.height * 0.5);
    ball.set('color', 0x333333);

    lpaddle = new Entity();
    lpaddle.height = 160;
    lpaddle.width = 20;
    lpaddle.x = 30;
    lpaddle.y = Game.stage.stageHeight * 0.5 - lpaddle.height * 0.5;
    lpaddle.motion = new Motion();
    lpaddle.motion.x_drag = 10;
    lpaddle.motion.y_drag = 10;
    lpaddle.collider = new BoxCollider(lpaddle, lpaddle.width, lpaddle.height);
    lpaddle.set('color', 0x333333);

    rpaddle = new Entity();
    rpaddle.height = 160;
    rpaddle.width = 20;
    rpaddle.x = Game.stage.stageWidth - 30;
    rpaddle.y = Game.stage.stageHeight * 0.5 - rpaddle.height * 0.5;
    rpaddle.motion = new Motion();
    rpaddle.motion.x_drag = 10;
    rpaddle.motion.y_drag = 10;
    rpaddle.collider = new BoxCollider(rpaddle, rpaddle.width, rpaddle.height);
    rpaddle.set('color', 0x333333);

    addEntity(ball);
    addEntity(lpaddle);
    addEntity(rpaddle);

    g = Game.graphics;

    initBallPosition();
    initBallMotion();
  }
  private var g :Graphics;


  private function initBallPosition() :Void
  {

    ball.x = Game.stage.stageWidth * 0.5 - ball.width * 0.5;
    ball.y = Game.stage.stageHeight * 0.5 - ball.height * 0.5;

  }

  private function initBallMotion() :Void 
  {
    if (dir == null) { dir = new Point(); }
    if (r == null) { r = Random.getInstance(1); }
    r.randomDir( dir );
    speed = r.rollSum(10, 3, speed);

    ball.motion.x_velocity = (BASE_BALL_SPEED + speed) * dir.x;
    ball.motion.y_velocity = (BASE_BALL_SPEED + speed) * dir.y;

  }
  private var r :Random;
  private var dir :Point;

  override private function onUnload() :Void 
  {

    removeEntity(ball);
    removeEntity(lpaddle);
    removeEntity(rpaddle);

  }


  override public function update() :Void
  {
    super.update();
    handleCollisions();
    handleInput();
  }


  private function handleCollisions() :Void 
  {
    
    if (hit == null) { hit = new Collision(); }

    if ( ball.collider.x < ball.collider.hw || 
         ball.collider.x + ball.collider.hw > Game.stage.stageWidth ) {
      initBallPosition();
      initBallMotion();
    }

    if ( ball.collider.y < ball.collider.hh || 
         ball.collider.y + ball.collider.hh > Game.stage.stageHeight ) { 
      ball.motion.y_velocity *= -1 ;
    }
    
    if ( ball.collider.collide(lpaddle.collider, hit) ) {
      ball.motion.x_velocity *= -1;
    }

    if ( ball.collider.collide(rpaddle.collider, hit) ) {
      ball.motion.x_velocity *= -1; 
    }

    if ( lpaddle.collider.y < lpaddle.collider.hh || 
         lpaddle.collider.y + lpaddle.collider.hh > Game.stage.stageHeight ) {
      lpaddle.motion.y_velocity *= -1;
    }

    if ( rpaddle.collider.y < rpaddle.collider.hh || 
         rpaddle.collider.y + rpaddle.collider.hh > Game.stage.stageHeight ) {
      rpaddle.motion.y_velocity *= -1;
    }

  }
  private var dx :Float;
  private var dy :Float;
  private var hit :Collision;


  private function handleInput() :Void
  {
    if (Keyboard.isDown(Key.W))
    {
      lpaddle.motion.y_acceleration = -5;
    }
    else if (Keyboard.isDown(Key.S))
    {
      lpaddle.motion.y_acceleration = 5;
    }
    else
    {
      lpaddle.motion.y_acceleration = 0;
    }

    if (Keyboard.isDown(Key.ARROW_UP))
    {
      rpaddle.motion.y_acceleration = -5;
    }
    else if (Keyboard.isDown(Key.ARROW_DOWN))
    {
      rpaddle.motion.y_acceleration = 5;
    }
    else 
    {
      rpaddle.motion.y_acceleration = 0;
    } 

  }
  private var _target_x :Int;
  private var _target_y :Int;
  private var _start_x :Float;
  private var _start_y :Float;


  override public function render() :Void
  {
    g.lineStyle(1, 0xff0000);
    g.drawRect(this.x, this.y, Game.stage.stageWidth, Game.stage.stageHeight);

    g.lineStyle(1, 0x00ff00);
    entities.debug_render(g, this, true);

    g.lineStyle(1, 0x0000ff);
    // entities.debug_render(g, this);
    // 

    color = ball.get('color');
    g.beginFill(color);
    g.lineStyle(1, color, 0.5);
    xx = (this.x + ball.x + ball.width * 0.5);
    yy = (this.y + ball.y + ball.height * 0.5);
    g.drawCircle(xx, yy, ball.width * 0.5);
    g.endFill();

    color = lpaddle.get('color');
    g.beginFill(color);
    g.lineStyle(1, color, 0.5);
    g.drawRect(this.x + lpaddle.x, this.y + lpaddle.y, lpaddle.width, lpaddle.height);
    g.endFill();

    color = rpaddle.get('color');
    g.beginFill(color);
    g.lineStyle(1, color, 0.5);
    g.drawRect(this.x + rpaddle.x, this.y + rpaddle.y, rpaddle.width, rpaddle.height);
    g.endFill();

  }
  private var color :UInt;
  private var xx :Float;
  private var yy :Float;

}