package sge.tiles;


class NeighborData
{

  public static inline var NORTH :Int = 0;
  public static inline var NORTH_EAST :Int = 1;
  public static inline var EAST :Int = 2;
  public static inline var SOUTH_EAST :Int = 3;
  public static inline var SOUTH :Int = 4;
  public static inline var SOUTH_WEST :Int = 5;
  public static inline var WEST :Int = 6;
  public static inline var NORTH_WEST :Int = 7;


  public var n(get, set) :Int;
  public var ne(get, set) :Int;
  public var e(get, set) :Int;
  public var se(get, set) :Int;
  public var s(get, set) :Int;
  public var sw(get, set) :Int;
  public var w(get, set) :Int;
  public var nw(get, set) :Int;
  public var values :Array<Int>;



  // Neighbor data should look like this:
  // [NORTH, NORTH_EAST, EAST, SOUTH_EAST, SOUTH, SOUTH_WEST, WEST, NORTH_WEST]
  // values 0 is no match, 1 is a match
  public function new() { values = new Array<Int>(); }


  public function toString() :String
  {
    return values.toString();
  }


  private inline function get_n() :Int  { return values[NeighborData.NORTH]; }
  private inline function set_n( value :Int ) :Int  { return values[NeighborData.NORTH] = value; }

  private inline function get_ne() :Int  { return values[NeighborData.NORTH_EAST]; }
  private inline function set_ne( value :Int ) :Int  { return values[NeighborData.NORTH_EAST] = value; }

  private inline function get_e() :Int  { return values[NeighborData.EAST]; }
  private inline function set_e( value :Int ) :Int  { return values[NeighborData.EAST] = value; }

  private inline function get_se() :Int  { return values[NeighborData.SOUTH_EAST]; }
  private inline function set_se( value :Int ) :Int  { return values[NeighborData.SOUTH_EAST] = value; }

  private inline function get_s() :Int  { return values[NeighborData.SOUTH]; }
  private inline function set_s( value :Int ) :Int  { return values[NeighborData.SOUTH] = value; }

  private inline function get_sw() :Int  { return values[NeighborData.SOUTH_WEST]; }
  private inline function set_sw( value :Int ) :Int  { return values[NeighborData.SOUTH_WEST] = value; }

  private inline function get_w() :Int  { return values[NeighborData.WEST]; }
  private inline function set_w( value :Int ) :Int  { return values[NeighborData.WEST] = value; }

  private inline function get_nw() :Int  { return values[NeighborData.NORTH_WEST]; }
  private inline function set_nw( value :Int ) :Int  { return values[NeighborData.NORTH_WEST] = value; }

}
