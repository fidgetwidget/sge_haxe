package examples;

import sge.display.AssetManager;
import sge.display.Console;
import sge.display.FrameData;
import sge.entity.EntityList;
import sge.input.Keyboard;
import sge.input.Key;
import sge.input.Mouse;
import sge.math.Transition;
import sge.scene.WorldScene;
import sge.tiles.AutoTiler;
import sge.tiles.Chunk;
import sge.tiles.TILES;
import sge.tiles.World;
import sge.Game;
import haxe.Log;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;


class AutotileTest extends WorldScene
{

  private var currentTileType(get, set) :Int;
  private var xx :Int;
  private var yy :Int;
  private var cursor :Bitmap;
  private var coords :TextField;
  private var tileSelector :Sprite;
  private var selectors :Map<String, Sprite>;


  override public function init() :Void
  {
    entities = new EntityList();
    transition = new Transition();
    world = new World(this);

    coords = new TextField();
    var format = new TextFormat("_sans", 12, 1);
    format.align = openfl.text.TextFormatAlign.RIGHT;
    coords.defaultTextFormat = format;
    coords.width = Game.stage.stageWidth - 64;
    coords.x = 32;
    coords.y = 16;

    initAutoTiler();
    initCursor();
    initTileSelector();
  }

  private function initAutoTiler() :Void
  {
    AssetManager.saveBitmap('assets/images/autotiles.png');
    world.autotiler = new AutoTiler('assets/images/autotiles.png');

    world.autotiler.addAutoTileFrames(0,  'dirt',       0,   0  );
    world.autotiler.addAutoTileFrames(1,  'grass',      64,  0  );
    world.autotiler.addAutoTileFrames(2,  'sand',       128, 0  );
    world.autotiler.addAutoTileFrames(4,  'mud',        256, 0  );
    world.autotiler.addAutoTileFrames(8,  'dirt_wall',  0,   96 );
    world.autotiler.addAutoTileFrames(13, 'stone_wall', 320, 96 );
    world.autotiler.addAutoTileFrames(16, 'dirt_hole',  0,   192);
    world.autotiler.addAutoTileFrames(20, 'water',      256, 192);
  }

  // TODO: make this a new display type 'panel' that would allow for layouts
  // padding, margin, etc
  private function initTileSelector() :Void 
  {
    selectors = new Map<String, Sprite>();

    tileSelector = new Sprite();
    tileSelector.x = 0;
    tileSelector.y = Game.stage.stageHeight - 96;

    var bg = new Bitmap( new BitmapData(Game.stage.stageWidth, 96, false, 0xcccccc) );
    var dirt = new Sprite();
    var grass = new Sprite();
    var sand = new Sprite();
    var mud = new Sprite();

    var frame :FrameData;
    selectors.set('dirt', dirt);
    frame = world.autotiler.getCursorFrame(0);
    dirt.addChild( new Bitmap(frame.bitmapData) );
    dirt.x = tileSelector_getXOffset(0);
    dirt.y = 16;
    dirt.addEventListener(MouseEvent.CLICK, onTileSelectorClick_dirt);

    selectors.set('grass', grass);
    frame = world.autotiler.getCursorFrame(1);
    grass.addChild( new Bitmap(frame.bitmapData) );
    grass.x = tileSelector_getXOffset(1);
    grass.y = 16;
    grass.addEventListener(MouseEvent.CLICK, onTileSelectorClick_grass);
    
    selectors.set('sand', sand);
    frame = world.autotiler.getCursorFrame(2);
    sand.addChild( new Bitmap(frame.bitmapData) );
    sand.x = tileSelector_getXOffset(2);
    sand.y = 16;
    sand.addEventListener(MouseEvent.CLICK, onTileSelectorClick_sand);
        
    selectors.set('mud', mud);
    frame = world.autotiler.getCursorFrame(4);
    mud.addChild( new Bitmap(frame.bitmapData) );
    mud.x = tileSelector_getXOffset(3);
    mud.y = 16;
    mud.addEventListener(MouseEvent.CLICK, onTileSelectorClick_mud);

    tileSelector.addChild(bg);
    tileSelector.addChild(dirt);
    tileSelector.addChild(sand);
    tileSelector.addChild(grass);
    tileSelector.addChild(mud);
    
  }

  private inline function tileSelector_getXOffset( i :Int ) :Int {
    // 32 px wide tile
    // 16 px gutter
    // 16 px padding
    return (32 * i) + (16 * (i + 1));
  }

  private function onTileSelectorClick_dirt( e :MouseEvent ) :Void {
    currentTileType = 0;
  }
  private function onTileSelectorClick_grass( e :MouseEvent ) :Void {
    currentTileType = 1;
  }
  private function onTileSelectorClick_sand( e :MouseEvent ) :Void {
    currentTileType = 2;
  }
  private function onTileSelectorClick_mud( e :MouseEvent ) :Void {
    currentTileType = 4;
  }

  private function onTileSelectorClick( event :MouseEvent ) :Void
  {
    if (event.relatedObject == null) { return; }
    var target = event.relatedObject;
    haxe.Log.trace(event.toString());
    currentTileType = world.autotiler.ids.get(target.name);
  }

  private function initCursor() :Void
  {
    var frame = world.autotiler.getCursorFrame(0);
    cursor = new Bitmap( frame.bitmapData );
  }


  override private function onReady() :Void 
  {
    currentTileType = 1;
    loadChunk(0, 0);
    addChild(cursor);

    Game.stage.addChild(coords);
    Game.stage.addChild(tileSelector);
  }


  override private function onUnload() :Void 
  {
    // TODO: unload stuff...
  }


  override public function update() :Void
  {
    super.update();
    updateCamera();

    if (Mouse.isDown(Mouse.LEFT_MOUSE_BUTTON)) {

      if ( ! tileSelector.hitTestPoint(Mouse.x, Mouse.y) ) {

        tileId = getTileAt( Mouse.x, Mouse.y );
        if (tileId != currentTileType) { setTileAt(Mouse.x, Mouse.y, currentTileType); }  

      }

    }
  }

  private function updateCamera() :Void
  {
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
  }


  override public function render() :Void
  {
    world.drawChunks();

    xx = getWorldX( Mouse.x );
    yy = getWorldY( Mouse.y );
    cursor.x = xx * TILES.TILE_SIZE[0];
    cursor.y = yy * TILES.TILE_SIZE[1];
    tile_type = 0;
    tile_index = 0;

    coords.text = 'x: ${xx} y: ${yy} id: ${tile_index} type: ${tile_type}';
  }

  private function get_currentTileType() :Int { return _currentTileType; }
  private function set_currentTileType( value :Int ) :Int { 
    if (_currentTileType != value) {
      _currentTileType = value;
      var frame = world.autotiler.getCursorFrame(_currentTileType);
      cursor.bitmapData = frame.bitmapData;
    }
    return _currentTileType;
  }
  private var _currentTileType :Int;

  private var c :Chunk;
  private var tx :Int;
  private var ty :Int;
  private var tileId :Int;
  private var tile_type :Int;
  private var tile_index :Int;

}