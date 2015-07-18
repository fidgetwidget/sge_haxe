package sge.systems;


import haxe.ds.StringMap;
import sge.display.FrameData;


// 
// Convert one dynamic object into a FrameData Object
// 
class FrameDataConverter {


  public var conversionMap :StringMap<String>;


  public function new()
  {

    conversionMap = new StringMap<String>();

  }

  // Convert from _ to FrameData
  public function convertToFrameData( from :Dynamic, ?to :FrameData ) :FrameData
  {
    if (to == null) {
      to = new FrameData();
    }

    to.name             = getProp( conversionMap('name'), from );
    to.rectangle.x      = getProp( conversionMap('rectangle.x'), from );
    to.rectangle.y      = getProp( conversionMap('rectangle.y'), from );
    to.rectangle.width  = getProp( conversionMap('rectangle.width'), from );
    to.rectangle.height = getProp( conversionMap('rectangle.height'), from );
    to.x                = getProp( conversionMap('x'), from );
    to.y                = getProp( conversionMap('y'), from );
    to.width            = getProp( conversionMap('width'), from );
    to.height           = getProp( conversionMap('height'), from );
    to.center.x         = getProp( conversionMap('center.x'), from );
    to.center.y         = getProp( conversionMap('center.y'), from );

    return to;
  }

  // Allows property access using a string with . notation
  // eg: 
  //  object = { foo : { bar: 'baz' }}
  //  string = 'foo.bar'
  //  result: 'baz'
  private function getProp( string :String, object :Dynamic ) :Dynamic
  {
    var accessor = string.split('.');
    var target = object;
    while (accessor.length > 0 && target = target[accessor.shift()] ) {}
    return target;
  }


}
