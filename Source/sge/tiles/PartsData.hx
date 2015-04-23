package sge.tiles;


class PartsData
{

  public static inline var QUAD_A :Int = 0;
  public static inline var QUAD_B :Int = 1;
  public static inline var QUAD_C :Int = 2;
  public static inline var QUAD_D :Int = 3;
  

  public var a(get, set) :Int;
  public var b(get, set) :Int;
  public var c(get, set) :Int;
  public var d(get, set) :Int;
  public var values :Array<Int>;
  public var all(get, never) :Bool;
  public var none(get, never) :Bool;



  // Parts Data should look like this:
  //  [topLeft, topRight, bottomLeft, bottomRight] -> 
  //  [QUAD_A,  QUAD_B,   QUAD_C,     QUAD_D]
  public function new() { values = new Array<Int>(); }



  private inline function get_a() :Int { return values[PartsData.QUAD_A]; }
  private inline function set_a( value :Int ) :Int { return values[PartsData.QUAD_A] = value; }

  private inline function get_b() :Int { return values[PartsData.QUAD_B]; }
  private inline function set_b( value :Int ) :Int { return values[PartsData.QUAD_B] = value; }

  private inline function get_c() :Int { return values[PartsData.QUAD_C]; }
  private inline function set_c( value :Int ) :Int { return values[PartsData.QUAD_C] = value; }

  private inline function get_d() :Int { return values[PartsData.QUAD_D]; }
  private inline function set_d( value :Int ) :Int { return values[PartsData.QUAD_D] = value; }

  private inline function get_all() :Bool { return (a == 4 && b == 4 && c == 4 && d == 4); }
  private inline function get_none() :Bool { return (a == 0 && b == 0 && c == 0 && d == 0); }

}
