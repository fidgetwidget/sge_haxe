package examples;


class AnimationTest extends Scene
{

  var kit: Entity;


  override public function init() :Void
  {
    entities = new EntityGrid();
    transition = new Transition();
  }

  override private function onReady() :Void 
  {
    //Load Spritesheet Source
    var bitmap:BitmapData = Assets.getBitmapData("assets/kitTpArray.png");

    //Parse Spritesheet
    var jsonString:String  = tempJson;
    var tpParser = new TexturePackerImporter();
    tpParser.frameRate = 6;

    var exp:EReg = ~/.+(?=\/)/;
    
    var sheet:Spritesheet = tpParser.parse( jsonString, bitmap, exp );

    //tweak behaviors
    sheet.behaviors.get("idle").loop = true;

    animated = new AnimatedSprite(sheet, true);
    animated.showBehavior("idle");
    //animated.showBehaviors(["down","jump","hit","punch"]);

    addChild(animated);
  }

  override private function onUnload() :Void 
  {
    
  }

  override public function update() :Void
  {
    super.update();
    
    handleInput();
    kit.update();

  }

  private function handleInput() :Void
  {
    
  }

  override public function render() :Void
  {
    

  }


}
