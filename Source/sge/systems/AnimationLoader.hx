package sge.systems;

import sge.display.Animation;
import openfl.display.BitmapData;


class AnimationLoader {





  public static function loadAnimationsFromJson( jsonString :String, bitmapData :BitmapData, format :FrameDataConverter ) :Array<Animation>
  {

    var json = haxe.Json.parse(jsonString);
    
    var frames = new Array<FrameData>();
    var animations = new Array<Animation>();

    for (jsonFrame in cast (json.frames, Array <Dynamic>)) {
        var fd :FrameData = parseJsonFrame(jsonFrame, format);
        frames.push(fd);
    }    

  }


  private static function parseJsonFrame( json :Dynamic, format: FrameDataConverter ) :FrameData
  {

    var fd :FrameData = new FrameData();
    fd = format.convertToFrameData(json, fd);
    return fd;

  }

}