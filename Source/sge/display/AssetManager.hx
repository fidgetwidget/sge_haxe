package sge.display;

import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.Tilesheet;
import haxe.Log;


class AssetManager
{

  private static var imageCache:Map<String, BitmapData>;
  private static var spritesheetCache:Map<String, Spritesheet>;
  private static var tilesheetCache:Map<String, Tilesheet>;

  private static function init()
  {
    imageCache = new Map<String, BitmapData>();
    tilesheetCache = new Map<String, Tilesheet>();
    spritesheetCache = new Map<String, Spritesheet>();
  }


  public static function saveBitmap( source :Dynamic ) :Bool 
  {
    var name :String,
      data :BitmapData;

    if (imageCache == null) { init(); }

    name = Std.string(source);
    data = Assets.getBitmapData(source);
    
    if (data != null) {
      imageCache.set(name, data);
      return true;
    }
    
    return false;
  }
  

  public static function getBitmap( source :Dynamic ) :BitmapData
  {
    if (imageCache == null) { init(); }

    var name = Std.string(source);
    // if it already exists, just return it
    if (imageCache.exists(name)) {
      return imageCache.get(name);
    }
    
    // save and return the data result
    var data = Assets.getBitmapData(source);
    if (data != null) {
      imageCache.set(name, data);
    }
    
    return data;
  }

  public static function saveSpritesheet( sheet :Spritesheet ) :Bool
  {
    return false;
  }

  public static function getSpritesheet( name :String ) :Spritesheet
  {
    return null;
  }

  public static function saveTilesheet( name :String ) :Bool
  {
    return false;
  }

  public static function getTilesheet( name :String ) :Tilesheet
  {
    return null;
  }

}
