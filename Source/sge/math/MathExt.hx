package sge.math;

// 
// Math Extension:
// 
class MathExt
{

  // Get the Divisor result because % gives the Dividend
  
  public static inline function remainder_int( a :Int, n :Int ) :Int
  {
    return a - (n * Math.floor(a/n));
  }

  public static inline function remainder_float( a :Float, n :Float ) :Float
  {
    return a - (n * Math.floor(a/n));
  }

}