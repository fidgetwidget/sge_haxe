package sge.tiles;

import openfl.display.BitmapData;
import openfl.display.Tilesheet;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import sge.display.AssetManager;
import sge.display.FrameData;


/**
 * Tileset with sub frames for A2_Autotiles
 *
 *  Optional additional tiles for specific neighbor states can be added
 *  By Default, the top left most tile is to be used instead of all 0 parts
 */
class AutoTiler extends Tileset
{

  public var parts :Map<String, FrameData>;
  public var names :Map<Int, String>;
  public var ids   :Map<String, Int>;


  private var partRect :Rectangle;
  private var tileRect :Rectangle;
  private var _0stateIndex :Map<String, Int>;
  private var _4stateIndex :Map<String, Int>;

  // memory saving (keep just the one of them)
  private var destPoint :Point;
  private var partsData :PartsData;


  public function new( source :Dynamic )
  {
    super(source);

    parts = new Map<String, FrameData>();
    names = new Map<Int, String>();
    ids   = new Map<String, Int>();
    // for copying the frame bitmapData to the destination (we can't use the frame rect)
    tileRect = new Rectangle(0, 0, TILES.TILE_SIZE[0],      TILES.TILE_SIZE[1]);
    partRect = new Rectangle(0, 0, TILES.TILE_PART_SIZE[0], TILES.TILE_PART_SIZE[1]);
    _0stateIndex = new Map<String, Int>();
    _4stateIndex = new Map<String, Int>();

    destPoint = null;
    partsData = null;
  }


  public function addAutoTileFrames( tileId :Int, name :String, offset_x :Int, offset_y :Int ) :Void
  {
    var id :Int,
      frame :FrameData;

    names.set( tileId, name );
    ids.set( name, tileId );
    
    _0stateIndex.set(name, 0);
    _4stateIndex.set(name, 0);

    // Add the Section as a frame
    addFrame(offset_x, offset_y, TILES.TILE_WIDTH * 2, TILES.TILE_HEIGHT * 3);
    id = frames.length - 1;
    frame = frames[ id ];
    frame.name = name;
    parts.set(name, frame);

    // Add the display tile 
    addFrame(offset_x, offset_y, TILES.TILE_WIDTH, TILES.TILE_HEIGHT);
    id = frames.length - 1;
    frame = frames[ id ];
    frame.name = '${name}_0${_0stateIndex[name]}';
    _0stateIndex[name] = _0stateIndex[name] + 1;
    parts.set(frame.name, frame);

    // Add each part
    for (s in 0...5) {
      for (q in 0...4) {
        cachePartFrame( name, offset_x, offset_y, q, s);
      }  
    }
  }


  public function getCursorFrame( tileId :Int ) :FrameData
  {
    var name = names[ tileId ];
    return getPart('${name}_00');
  }


  // Add alternative tiles for certain neighbor states
  // Currently supported state values: 0 for none, and 4 for all
  public function addTileFrame( name :String, offset_x :Int, offset_y :Int, state :Int ) :Void
  {
    if (state != 0 && state != 4) { return; }
    var id :Int,
      frame :FrameData;
    
    addFrame(offset_x, offset_y, TILES.TILE_WIDTH, TILES.TILE_HEIGHT);
    id = frames.length - 1;
    frame = frames[ id ];
    switch (state) {
      case 0:
        frame.name = '${name}_0${_0stateIndex[name]}';
        _0stateIndex[name] = _0stateIndex[name] + 1;

      case 4:
        frame.name = '${name}_4${_4stateIndex[name]}';
        _4stateIndex[name] = _4stateIndex[name] + 1;
    }
    parts.set(frame.name, frame);
  }



  public function drawTileTo( tileId :Int, neighborData :NeighborData, target :Point, dest :BitmapData  ) :Void
  {
    var name :String,
      frame :FrameData;

    name = names[ tileId ];
    if (name == null) { 
      throw new openfl.errors.Error('the name for the tile draw request was null.');
      return;
    }

    if ( neighborData == null ) {
      partsData = null;
    } else {
      partsData = getPartsData( neighborData, partsData );
    }

    if ( partsData == null || partsData.none ) {
      
      frame = getPart( '${name}_00' );
      dest.copyPixels( frame.bitmapData, tileRect, target );

    } else if ( partsData.all && _4stateIndex[name] > 0 ) {

      frame = getPart( '${name}_40' );
      dest.copyPixels( frame.bitmapData, tileRect, target );

    } else {

      var xx :Int,
        yy :Int;

      // copy over the 4 parts
      for (q in 0...4) {
        frame = getTilePart( name, q, partsData );
        xx = Math.floor( target.x + (TILES.TILE_PART_OFFSET[0][q] * TILES.TILE_PART_SIZE[0]) );
        yy = Math.floor( target.y + (TILES.TILE_PART_OFFSET[1][q] * TILES.TILE_PART_SIZE[1]) );
        if (destPoint == null) { destPoint = new Point(); }
        destPoint.x = xx;
        destPoint.y = yy;
        dest.copyPixels(frame.bitmapData, partRect, destPoint);
      }

    }
  }



  private function getPart( name :String ) :FrameData
  {
    var frame :FrameData;

    frame = parts[ name ];
    if (frame != null && frame.bitmapData == null) {
      generateBitmapData( frame );
    }
    return frame;
  }


  private function cachePartFrame( name :String, offset_x :Int, offset_y :Int, quad :Int, segment :Int ) :Void
  {
    var _x :Int,
      _y :Int,
      dx :Int,
      dy :Int,
      xx :Int,
      yy :Int,
      id :Int,
      frame :FrameData;

    _x = TILES.TILE_OFFSET[0][segment] * TILES.TILE_SIZE[0];
    _y = TILES.TILE_OFFSET[1][segment] * TILES.TILE_SIZE[1];
    dx = TILES.TILE_PART_OFFSET[0][quad] * TILES.TILE_PART_SIZE[0];
    dy = TILES.TILE_PART_OFFSET[1][quad] * TILES.TILE_PART_SIZE[1];
    xx = Math.floor( _x + dx + offset_x );
    yy = Math.floor( _y + dy + offset_y );
    addFrame(xx, yy, TILES.TILE_PART_SIZE[0], TILES.TILE_PART_SIZE[1]);
    id = frames.length - 1;
    frame = frames[ id ];
    frame.name = '${name}_${TILES.TILE_PART_LETTER[quad]}${segment}';
    parts.set(frame.name, frame);
  }


  private function getTilePart( name:String, quad :Int, partsData :PartsData ) :FrameData
  {
    return getPart('${name}_${TILES.TILE_PART_LETTER[quad]}${TILES.TILE_PART_INDEX[quad][partsData.values[quad]]}');
  }


  private function getPartsData( neighborData :NeighborData, results :PartsData ) :PartsData
  {
    if (results == null) { results = new PartsData(); }
    // A: TOP LEFT
    results.a = neighborData.w + (neighborData.n * 2); // left + 2*top
    if (neighborData.w == 1 && neighborData.n == 1 && neighborData.nw == 1) {
      results.a = 4;
    }
    // B: TOP RIGHT
    results.b = neighborData.e + (neighborData.n * 2); // right + 2*top
    if (neighborData.e == 1 && neighborData.n == 1 && neighborData.ne == 1) {
      results.b = 4;
    }
    // C: BOTTOM LEFT
    results.c = neighborData.w + (neighborData.s * 2); // left + 2*bottom
    if (neighborData.w == 1 && neighborData.s == 1 && neighborData.sw == 1) {
      results.c = 4;
    }
    // D: BOTTOM RIGHT
    results.d = neighborData.e + (neighborData.s * 2); // right + 2*bottom
    if (neighborData.e == 1 && neighborData.s == 1 && neighborData.se == 1) {
      results.d = 4;
    }
    return results;
  }

}
