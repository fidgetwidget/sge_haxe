package sge;

import haxe.ds.StringMap;


class Properties implements IHasProperties
{

  private var nameValHash:StringMap<Dynamic>;

  
  public function new() 
  {
    nameValHash = new StringMap<Dynamic>();
  }
  

  public function set( name:String, value:Dynamic ) :Void {
    nameValHash.set(name, value);
  }
  

  public function get( name:String ) :Dynamic {
    if ( has(name) ) {
      return nameValHash.get(name);
    }
    return null;
  }
  

  public function has( name:String ) :Bool {
    return nameValHash.exists(name);
  }

}