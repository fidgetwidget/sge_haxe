package examples;

import openfl.display.Shape;
import sge.entity.Entity;


class SoccerGameGoal extends Entity {


  public static inline var LEFT_SIDE : Int = 0;
  public static inline var RIGHT_SIDE : Int = 1;

  private var shape :Shape;
  private var side :Int;

  public function new(side :Int)
  {
    super();
    this.side = side;
    width = 60;
    height = 120;
    shape = new Shape();
    this.sprite = shape;
  }

  override public function update() :Void
  {
    super.update();
    drawShape();
  }

  public function drawShape() :Void
  {

    shape.graphics.clear();
    shape.graphics.lineStyle(10, 0x333333);

    if (side == SoccerGameGoal.LEFT_SIDE)
    {
      shape.graphics.moveTo(x + width, y);
      shape.graphics.lineTo(x, y);
      shape.graphics.lineTo(x, y + height);
      shape.graphics.lineTo(x + width, y + height);
    }
    
    if (side == SoccerGameGoal.RIGHT_SIDE)
    {
      shape.graphics.moveTo(x, y);
      shape.graphics.lineTo(x + width, y);
      shape.graphics.lineTo(x + width, y + height);
      shape.graphics.lineTo(x, y + height);
    }

  }

}