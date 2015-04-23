package sge.geom;

import openfl.geom.Point;


interface IHasPosition
{

  public var x(get,set) :Float;

  public var y(get,set) :Float;

  public var point(get,set) :Point;

  public var anchor(get,set) :Point;

  public var rotation(get,set) :Float;

}