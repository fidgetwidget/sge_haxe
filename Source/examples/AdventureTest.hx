package examples;

import sge.display.AssetManager;
import sge.display.FrameData;
import sge.entity.Entity;
import sge.entity.EntityList;
import sge.input.Keyboard;
import sge.input.Key;
import sge.input.Mouse;
import sge.math.Transition;
import sge.scene.Camera;
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
import openfl.geom.Point;


class AdventureTest extends WorldScene
{

  private var player :AdventurePlayer;
  private var camera :Camera;
  private var currentTileType(get, set) :Int;
  private var coords :TextField;

  
  override public function init() :Void
  {
    entities = new EntityList();
    transition = new Transition();
    world = new World(this);
    camera = new Camera(this);

    initCoords();
    initAutoTiler();
    initPlayer();
  }

  private function initCoords() :Void
  {
    coords = new TextField();
    var format = new TextFormat("_sans", 12, 1);
    format.align = openfl.text.TextFormatAlign.RIGHT;
    coords.defaultTextFormat = format;
    coords.width = Game.stage.stageWidth - 64;
    coords.x = 32;
    coords.y = 16;
  }

  private function initAutoTiler() :Void
  {
    AssetManager.saveBitmap('assets/images/autotiles.png');
    world.autotiler = new AutoTiler('assets/images/autotiles.png');

    // Setup the tiles based on the autotiles.png file
    world.autotiler.addAutoTileFrames(0,  'dirt',       0,   0  );
    world.autotiler.addAutoTileFrames(1,  'grass',      64,  0  );
    world.autotiler.addAutoTileFrames(2,  'sand',       128, 0  );
    world.autotiler.addAutoTileFrames(4,  'mud',        256, 0  );
    world.autotiler.addAutoTileFrames(8,  'dirt_wall',  0,   96 );
    world.autotiler.addAutoTileFrames(13, 'stone_wall', 320, 96 );
    world.autotiler.addAutoTileFrames(16, 'dirt_hole',  0,   192);
    world.autotiler.addAutoTileFrames(20, 'water',      256, 192);

    // setup the collisions for each tile type defined above
    world.collisionTypeIds.set(0,  false);
    world.collisionTypeIds.set(1,  false);
    world.collisionTypeIds.set(2,  false);
    world.collisionTypeIds.set(4,  false);
    world.collisionTypeIds.set(8,  true);
    world.collisionTypeIds.set(13, true);
    world.collisionTypeIds.set(16, true);
    world.collisionTypeIds.set(20, true);
  }

  private function initPlayer() :Void
  {
    player = new AdventurePlayer();
  }

  override private function onReady() :Void 
  {
    currentTileType = 1;
    loadChunk(0, 0);
    addChild(player.sprite);
    camera.follow(player);
    Game.stage.addChild(coords);
  }

  override private function onUnload() :Void 
  {
    
  }

  override public function update() :Void
  {
    super.update();
    
    handleInput();
    handleCollisions();
    updateCamera();

    player.update();
  }

  private function handleInput() :Void
  {
    desty = player.y;
    destx = player.x;

    if (Keyboard.isDown(Key.ARROW_UP) || Keyboard.isDown(Key.W))
    {
      desty -= 4;
    }
    else if (Keyboard.isDown(Key.ARROW_DOWN)  || Keyboard.isDown(Key.S))
    {
      desty += 4;
    }

    if (Keyboard.isDown(Key.ARROW_LEFT) || Keyboard.isDown(Key.A))
    {
      destx -= 4;
    }
    else if (Keyboard.isDown(Key.ARROW_RIGHT) || Keyboard.isDown(Key.D))
    {
      destx += 4;
    }

    if (Keyboard.isDown( Key.NUMBER_0 )) {
      this.currentTileType = 0;
    }
    if (Keyboard.isDown( Key.NUMBER_1 )) {
      this.currentTileType = 1;
    }
    if (Keyboard.isDown( Key.NUMBER_2 )) {
      this.currentTileType = 2;
    }
    if (Keyboard.isDown( Key.NUMBER_3 )) {
      this.currentTileType = 4;
    }
    if (Keyboard.isDown( Key.NUMBER_4 )) {
      this.currentTileType = 8;
    }
    if (Keyboard.isDown( Key.NUMBER_5 )) {
      this.currentTileType = 13;
    }
    if (Keyboard.isDown( Key.NUMBER_6 )) {
      this.currentTileType = 16;
    }
    if (Keyboard.isDown( Key.NUMBER_7 )) {
      this.currentTileType = 20;
    }


    if (Mouse.isDown(Mouse.LEFT_MOUSE_BUTTON)) {

      tileId = getTileAt( Mouse.x, Mouse.y );
      if (tileId != currentTileType) { 
        setTileAt(Mouse.x, Mouse.y, currentTileType); 
      }

    }

  }
  private var tileId :Int;

  private function handleCollisions() :Void
  {
    
    dx = destx - player.x;
    dy = desty - player.y;
    // TODO: create a chunck collider and use collision math instead...
    if (dx > 0) {

      px = get_screenPos_x(destx + player.width);
      py = get_screenPos_y(player.y);
      destinationTile = getTileAt(px, py);

      if (world.collisionTypeIds.get(destinationTile)) {
        destx = player.x;
      }

      px = get_screenPos_x(destx + player.width);
      py = get_screenPos_y(player.y + player.height);
      destinationTile = getTileAt(px, py);

      if (world.collisionTypeIds.get(destinationTile)) {
        destx = player.x;
      }

    } else if (dx < 0) {

      px = get_screenPos_x(destx);
      py = get_screenPos_y(player.y);
      destinationTile = getTileAt(px, py);

      if (world.collisionTypeIds.get(destinationTile)) {
        destx = player.x;
      }

      px = get_screenPos_x(destx);
      py = get_screenPos_y(player.y + player.height);
      destinationTile = getTileAt(px, py);

      if (world.collisionTypeIds.get(destinationTile)) {
        destx = player.x;
      }

    }

    if (dy > 0) {

      px = get_screenPos_x(player.x);
      py = get_screenPos_y(desty + player.height);
      destinationTile = getTileAt(px, py);

      if (world.collisionTypeIds.get(destinationTile)) {
        desty = player.y;
      }

      px = get_screenPos_x(player.x + player.width);
      py = get_screenPos_y(desty + player.height);
      destinationTile = getTileAt(px, py);

      if (world.collisionTypeIds.get(destinationTile)) {
        desty = player.y;
      }

    } else if (dy < 0) {

      px = get_screenPos_x(player.x);
      py = get_screenPos_y(desty);
      destinationTile = getTileAt(px, py);

      if (world.collisionTypeIds.get(destinationTile)) {
        desty = player.y;
      } 

      px = get_screenPos_x(player.x + player.width);
      py = get_screenPos_y(desty);
      destinationTile = getTileAt(px, py);

      if (world.collisionTypeIds.get(destinationTile)) {
        desty = player.y;
      }

    }

    player.x = destx;
    player.y = desty;
    
  }
  private var destinationTile :Int;
  private var destx :Float;
  private var desty :Float;
  private var px :Int;
  private var py :Int;
  private var dx :Float;
  private var dy :Float;

  private function updateCamera() :Void
  {
    
    camera.update();

  }

  override public function render() :Void
  {

    world.drawChunks();
    world.debug_render(Game.graphics, this);

    var tileId = getTileAt(Mouse.x, Mouse.y);
    coords.text = 'x: ${Mouse.x - this.x} y: ${Mouse.y - this.y} px: ${player.x} py: ${player.y} xy_id: ${tileId}';

  }
  private var xx :Float;
  private var yy :Float;

  private inline function get_screenPos_x( x :Float ) :Int { return Math.floor(x + this.x); }
  private inline function get_screenPos_y( y :Float ) :Int { return Math.floor(y + this.y); }

  private function get_currentTileType() :Int { return _currentTileType; }
  private function set_currentTileType( value :Int ) :Int { 
    if (_currentTileType != value) {
      _currentTileType = value;
      // var frame = world.autotiler.getCursorFrame(_currentTileType);
      // cursor.bitmapData = frame.bitmapData;
    }
    return _currentTileType;
  }
  private var _currentTileType :Int;

}