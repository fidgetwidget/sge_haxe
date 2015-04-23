package sge.display;

import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;
import haxe.Log;


class Console extends Sprite
{

  public static inline var MAX_LINES :Int = 5;
  public static var instance :Console;
  public var console :TextField;
  public var bg :Shape;

  private static inline var TIME_ON_SCREEN :Float = 3.33;
  private var firstLine :Bool = true;
  private var timer :Dynamic = null;
  


  public function new()
  {
    super();
    x = 0;
    y = Game.stage.stageHeight;
    width = Game.stage.stageWidth;
    height = 60;
    y -= height;

    bg = new Shape();
    bg.width = width;
    bg.height = height;

    console = new TextField();
    console.defaultTextFormat = new TextFormat("_sans", 12, 1);
    console.autoSize = TextFieldAutoSize.CENTER;
    console.x = 10;
    console.textColor = 0x000000;
    console.selectable = false;
    console.multiline = true;

    addChild(bg);
    addChild(console);

    bg.graphics.clear();
    bg.graphics.beginFill(0x333333, 0.3);
    bg.graphics.drawRect(0, 0, width, height);
    bg.graphics.endFill();

    firstLine = true;
    Console.instance = this;
  }


  public function log( string :String ) :Void
  {
    _trace( string );
  }
  


  private function clearFirstLine() :Void
  {
    if (console.numLines > 1)
    {
      console.text = console.text.substring( console.getLineOffset(1) );  
      console.height = console.textHeight + 4;
    }
    else
    {
      console.text = ": ";
      firstLine = true;
      console.height = 20;
    }
    
  }


  private function drawBG()
  {
    bg.graphics.clear();
    bg.graphics.beginFill(0x333333, 0.3);
    bg.graphics.drawRect(0, 0, Game.stage.stageWidth, console.height + 4);
    bg.graphics.endFill();
  }


  private function _timerComplete() :Void
  {
    if (!firstLine)
    {
      clearFirstLine();
      y = Game.stage.stageHeight - (console.height + 2);
      drawBG();
      timer = motion.Actuate.timer(Console.TIME_ON_SCREEN).onComplete(_timerComplete);
    }
  }


  private function _trace( string :String ) :Void
  {
    if (console.numLines >= Console.MAX_LINES) { clearFirstLine(); }

    if (firstLine)
    {
      console.appendText(": "+string);
      firstLine = false;
    } 
    else
    {
      console.appendText("\n: "+string);  
    }
    y = Game.stage.stageHeight - (console.height + 2);
    drawBG();
    if (timer != null) { timer.stop(); }
    timer = motion.Actuate.timer(Console.TIME_ON_SCREEN).onComplete(_timerComplete);

  }
  private var _i :Int;

}