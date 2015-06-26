package examples;

import openfl.display.Shape;
import sge.math.Motion;
import sge.entity.Entity;


class AdventurePlayer extends Entity {

  private var shape :Shape;

  public function new()
  {
    super();
    width = 28;
    height = 28;
    motion = new Motion();
    motion.x_drag = 1;
    motion.y_drag = 1;
    shape = new Shape();
    shape.graphics.beginFill(0x0f678a);
    shape.graphics.drawRect(x + 2, y + 2, width, height);
    shape.graphics.endFill();
    this.sprite = shape;
  }

  override public function update() :Void
  {
    super.update();
    shape.graphics.clear();
    shape.graphics.beginFill(0x0f678a);
    shape.graphics.drawRect(x + 2, y + 2, width, height);
    shape.graphics.endFill();
  }

}
