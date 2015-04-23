package sge.math;

import openfl.geom.Point;

/**
 * Random library
 *
 * various parts of it are taken from: https://github.com/ncannasse/ld24/blob/master/lib/Rand.hx 
 * TODO: rewrite this to a) no longer use borrowed code, b) to have pure static versions of the instance methods
 */
class Random 
{
  // ------------------------------
  // Singleton Pattern
  // ------------------------------
  
  public static var instance :Random;
  
  // Allow for multiple instances existing...
  public static function getInstance( seed :Int ) :Random { return new Random(seed); }

  // initialize the public access instance
  public static function init( seed :Int ) :Void { instance = getInstance(seed); }

  // ------------------------------



  private var seed : Float;

  // TODO: change it to accept a string too
  private function new( seed :Int ) {
    this.seed = hash( ( ( seed < 0 ) ? -seed : seed ) + 151 );
  }
  
  // taken from: https://github.com/ncannasse/ld24/blob/master/lib/Rand.hx
  public static function hash( n :Int ) :Int {
    for( i in 0...5 ) {
      n ^= (n << 7) & 0x2b5b2500;
      n ^= (n << 15) & 0x1b8b0000;
      n ^= n >>> 16;
      n &= 0x3FFFFFFF;
      var h :Int = 5381;
      h = (h << 5) + h + (n & 0xFF);
      h = (h << 5) + h + ((n >> 8) & 0xFF);
      h = (h << 5) + h + ((n >> 16) & 0xFF);
      h = (h << 5) + h + (n >> 24);
      n = h & 0x3FFFFFFF;
    }
    return n;
  } 

  public static function shash( str :String ) :Int {
    var n :Int = 5381;
    var c :Int;
    for (i in 0...str.length)
    {
      c = StringTools.fastCodeAt(str, i);
      n = ((n << 5) + n) + c;
    }
    return n;
  }
  
  public inline function random( n ) :Float {
    return int() % n;
  }
  
  public inline function between( min :Float, max :Float ) :Float {
    return int() % (max - min) + min;
  }
  
  public function randomDir( dir :Point = null ) :Point 
  {
    if (dir == null) { dir = new Point(); }
    dir.x = between( -10, 10);
    dir.y = between( -10, 10);
    dir.normalize(1);
    return dir;
  }
  
  public inline function randomColor() :Int {
    return int() * 0xFFFFFF;
  }

  // Roll n dice of type d and return an array of the results
  // eg. Roll(6, 2) to roll 2d6
  // default: d = 6, n = 1 eg Roll() is 1d6
  public inline function roll( d :Int = 6, n :Int = 1, results :Array<Int> = null ) :Array<Int>
  {    
    results = (results != null ? results : []);
    for (i in 0...n) {
      results[i] = Math.ceil(random(d) + 1);
    }
    return results;
  }
  
  // Roll n dice of type d and return the sum total
  // eg. Roll(6, 2) to roll 2d6
  // default: d = 6, n = 1 eg Roll() is 1d6
  public inline function rollSum( d :Int = 6, n :Int = 1, result :Int = 0 ) :Int
  {    
    for (i in 0...n) {
      result += Math.ceil(random(d) + 1);
    }
    return result;
  }
  
  public inline function rand() :Float {
    // we can't use a divider > 16807 or else two consecutive seeds
    // might generate a similar float
    return (int() % 10007) / 10007.0;
  }

  private inline function int() :Int {
    return Std.int(seed = (seed * 16807.0) % 2147483647.0) & 0x3FFFFFFF;
  }
  
}