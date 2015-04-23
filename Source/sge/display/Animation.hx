package sge.display;


class Animation
{

  private static var unique_id :Int = 0;
  public static function getNextId() :Int 
  {
    return Animation.unique_id++;
  }

  public var name :String;
  public var frames :Array<Int>;
  public var frameRate :Int;
  public var loop :Bool;
  public var center_x :Float = 0;
  public var center_y :Float = 0;

  public var frameData :Array<Dynamic>;


  public function new( name:String = "", frames:Array <Int> = null, loop:Bool = false, frameRate:Int = 30 )
  {
    if (name == "") { name = "anim_" + getNextId(); }
    if (frames == null) { frames = []; }

    this.name = name;
    this.frames = frames;
    this.loop = loop;
    this.frameRate = frameRate;
    
    frameData = new Array<Dynamic>();
    for (i in 0...this.frames.length) {
      frameData.push(null);
    }
  }

}
