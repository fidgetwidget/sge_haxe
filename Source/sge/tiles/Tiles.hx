package sge.tiles;


class TILES
{
  // TODO: load these values in from a config file...
  public static inline var TILE_WIDTH = 32;
  public static inline var TILE_HEIGHT = 32;
  public static inline var CHUNK_TILES_WIDE = 16;
  public static inline var CHUNK_TILES_HIGH = 16;

  public static var CHUNK_WIDTH = TILE_WIDTH * CHUNK_TILES_WIDE;
  public static var CHUNK_HEIGHT = TILE_HEIGHT * CHUNK_TILES_HIGH;
  public static var TILE_SIZE = [TILE_WIDTH, TILE_HEIGHT];
  public static var TILE_PART_SIZE = [ Math.floor(TILE_WIDTH * 0.5), Math.floor(TILE_HEIGHT * 0.5)];
  public static var CHUNK_SIZE = [CHUNK_TILES_WIDE, CHUNK_TILES_HIGH];


  // ------ AUTO TILE FORMATTING ------ //
  /**
   * Divide 32x32 size map chip to parts of 16x16 size with label "a"-"d" and "0"-"4"
   *  index               part labels 
   * ╔══╤══╦══╤══╗       ╔═════╦══╤══╗
   * ║a │b ║0 │0 ║       ║     ║a3│b3║
   * ╟──┼──╫──┼──╢       ║ x x ╟──┼──╢
   * ║c │d ║0 │0 ║       ║     ║c3│d3║
   * ╠══╪══╬══╪══╣       ╠═════╬══╪══╣
   * ║1 │1 │2 │2 ║       ║a0│b1│a1│b0║
   * ╟──┼──┼──┼──╢  -->  ╟──┼──┼──┼──╢
   * ║1 │1 │2 │2 ║       ║c2│d4│c4│d2║
   * ╟──┼──┼──┼──╢       ╟──┼──┼──┼──╢
   * ║3 │3 │4 │4 ║       ║a2│b4│a4│b2║
   * ╟──┼──┼──┼──╢       ╟──┼──┼──┼──╢
   * ║3 │3 │4 │4 ║       ║c0│d1│c1│d0║
   * ╚══╧══╧══╧══╝       ╚══╧══╧══╧══╝
   */ 
  public static var TILE_PART_LETTER = [ 'a','b','c','d' ];
  public static var TILE_PART_INDEX = [
      [1, 2, 3, 0, 4], //a [a0 -> index:1, a1 -> index:2, a2 -> index:3, a3 -> index:0, a4 -> index:4]
      [2, 1, 4, 0, 3], //b [b0 -> index:2, b1 -> index:1, b2 -> index:4, b3 -> index:0, b4 -> index:3]
      [3, 4, 1, 0, 2], //c [c0 -> index:3, c1 -> index:4, c2 -> index:1, c3 -> index:0, c4 -> index:2]
      [4, 3, 2, 0, 1]  //d [d0 -> index:4, d1 -> index:3, d2 -> index:2, d3 -> index:0, d4 -> index:1]
    ];
  public static var TILE_OFFSET = [
      [1, 0, 1, 0, 1], //x
      [0, 1, 1, 2, 2]  //y
    ];
  public static var TILE_PART_OFFSET = [
      [0, 1, 0, 1], //x
      [0, 0, 1, 1]  //y
    ];


}
