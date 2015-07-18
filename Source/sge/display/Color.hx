package sge.display;


// 
// A color value helper
// 
class Color
{

  public var value :UInt;

  public var red(get, set) :Int;
  public var redf(get, set) :Float;
  public var green(get, set) :Int;
  public var greenf(get, set) :Float;
  public var blue(get, set) :Int;
  public var bluef(get, set) :Float;
  public var alpha(get, set) :Int;
  public var alphaf(get, set) :Float;
  

  public function new( value :UInt = 0xffffffff )
  {
    this.value = value;
  }

  public inline function rgb( r :Int = 0, g :Int = 0, b :Int = 0 ) :UInt
  {
    return rgba( r, g, b );
  }

  public inline function rgba( r :Int = 0, g :Int = 0, b :Int = 0, a :Int = 255 ) :UInt 
  {
    red = r;
    green = g;
    blue = b;
    alpha = a;
    return value;
  }

  public inline function rgbf( rf :Float = 0, gf :Float = 0, bf :Float = 0 ) :UInt
  {
    return rgbaf( rf, gf, bf );
  }

  public inline function rgbaf( rf :Float = 0, gf :Float = 0, bf :Float = 0, af :Float = 1 ) :UInt
  {
    redf = rf;
    greenf = gf;
    bluef = bf;
    alphaf = af;
    return value;
  }


  private inline function forceBounds( value :Int ) :Int
  {
    return value > 0xff ? 0xff : value < 0 ? 0 : value;
  }


  public function get_red() :Int { return (value >> 16) & 0xff; }
  public function get_redf() :Float { return red / 255; }
  public function set_red(r :Int) :Int 
  { 
    value &= 0xff00ffff;
    value |= forceBounds(r) << 16;
    return r;
  }
  public function set_redf(rf :Float) :Float 
  { 
    red = Math.round(rf * 255);
    return rf; 
  }

  public function get_green() :Int { return (value >> 8) & 0xff; }
  public function get_greenf() :Float { return green / 255; }
  public function set_green(g :Int) :Int 
  { 
    value &= 0xffff00ff;
    value |= forceBounds(g) << 8;
    return r;
  }
  public function set_greenf(gf :Float) :Float 
  { 
    green = Math.round(gf * 255);
    return gf; 
  }

  public function get_blue() :Int { return value & 0xff; }
  public function get_bluef() :Float { return blue / 255; }
  public function set_blue(b :Int) :Int 
  { 
    value &= 0xffffff00;
    value |= forceBounds(b);
    return r;
  }
  public function set_bluef(bf :Float) :Float 
  { 
    blue = Math.round(bf * 255);
    return bf; 
  }

  public function get_alpha() :Int { return (value >> 24) & 0xff; }
  public function get_alphaf() :Float { return alpha / 255; }
  public function set_alpha( a :Int ) :Int 
  {
    value &= 0x00ffffff;
    value |= forceBounds(a) << 24;
    return a;
  }
  public function set_alphaf( af :Float ) :Float 
  {
    alpha = Math.round(af * 255);
    return af;
  }

}