package sge;


interface IHasProperties
{

  public function set( name:String, value:Dynamic ) :Void;
  
  public function get( name:String ) :Dynamic;
  
  public function has( name:String ) :Bool;

}
