package examples;

import sge.collision.AABB;
import sge.collision.BoxCollider;
import sge.collision.CircleCollider;
import sge.collision.Collision;
import sge.collision.CollisionMath;
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


class SoccerGameTest extends Scene
{

  var ball :Entity;
  var lGoal :SoccerGameGoal;
  var rGoal :SoccerGameGoal;
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

    lGoal = new SoccerGameGoal(SoccerGameGoal.LEFT_SIDE);
    lGoal.x = 30;
    lGoal.y = Game.stage.stageHeight * 0.5 - lGoal.height * 0.5;

    rGoal = new SoccerGameGoal(SoccerGameGoal.RIGHT_SIDE);
    rGoal.x = Game.stage.stageWidth - 30 - rGoal.width;
    rGoal.y = Game.stage.stageHeight * 0.5 - rGoal.height * 0.5;
    
    addEntity(ball);
    addEntity(lGoal);
    addEntity(rGoal);

    g = Game.graphics;

    initBallPosition();
    initBallMotion();

    lGoal.drawShape();
    rGoal.drawShape();
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
    removeEntity(lGoal);
    removeEntity(rGoal);

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
      ball.motion.x_velocity *= -1 ;
    }

    if ( ball.collider.y < ball.collider.hh || 
         ball.collider.y + ball.collider.hh > Game.stage.stageHeight ) { 
      ball.motion.y_velocity *= -1 ;
    }
    
    // if ( ball.collider.collide(lGoal.collider, hit) ) {
    //   ball.motion.x_velocity *= -1;
    // }

    // if ( ball.collider.collide(rGoal.collider, hit) ) {
    //   ball.motion.x_velocity *= -1; 
    // }

    // if ( lGoal.collider.y < lGoal.collider.hh || 
    //      lGoal.collider.y + lGoal.collider.hh > Game.stage.stageHeight ) {
    //   lGoal.motion.y_velocity *= -1;
    // }

    // if ( rGoal.collider.y < rGoal.collider.hh || 
    //      rGoal.collider.y + rGoal.collider.hh > Game.stage.stageHeight ) {
    //   rGoal.motion.y_velocity *= -1;
    // }

  }
  private var dx :Float;
  private var dy :Float;
  private var hit :Collision;


  private function handleInput() :Void
  {


  }


  override public function render() :Void
  {
    g.lineStyle(1, 0xff0000);
    g.drawRect(this.x, this.y, Game.stage.stageWidth, Game.stage.stageHeight);

    g.lineStyle(1, 0x00ff00);
    entities.debug_render(g, this, true);

    g.lineStyle(1, 0x0000ff);
    entities.debug_render(g, this);

    color = ball.get('color');
    g.beginFill(color);
    g.lineStyle(1, color, 0.5);
    xx = (this.x + ball.x + ball.width * 0.5);
    yy = (this.y + ball.y + ball.height * 0.5);
    g.drawCircle(xx, yy, ball.width * 0.5);
    g.endFill();

  }
  private var color :UInt;
  private var xx :Float;
  private var yy :Float;

}