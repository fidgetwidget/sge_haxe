package sge.collision;

import openfl.geom.Point;


class CollisionMath
{

  public static function contains( self :Collider, x :Float, y :Float ) :Bool
  {
    switch (self.type)
    {
      case "sge.collision.CircleCollider":
        return circle_contains( cast(self, CircleCollider), x, y );
      case "sge.collision.BoxCollider":
        return box_contains( cast(self, BoxCollider), x, y );
      // TODO: add PolyCollider
    }
    return false;
  }

  public static function containsPoint( self :Collider, point :Point ) :Bool
  {
    return contains(self, point.x, point.y);
  }

  public static function collide( self :Collider, other :Collider, ?collision :Collision ) :Bool
  {
    switch (self.type)
    {
      // Circle Collider First
      case "sge.collision.CircleCollider":

        switch (other.type)
        {
          case "sge.collision.CircleCollider":
            return circle_circle(cast(self, CircleCollider), cast(other, CircleCollider), collision);

          case "sge.collision.BoxCollider":
            return circle_box(cast(self, CircleCollider), cast(other, BoxCollider), collision);

          // TODO: add PolyCollider
        }

      // Box Collider First
      case "sge.collision.BoxCollider":

        switch (other.type)
        {
          case "sge.collision.CircleCollider":
            return box_circle(cast(self, BoxCollider), cast(other, CircleCollider), collision);

          case "sge.collision.BoxCollider":
            return box_box(cast(self, BoxCollider), cast(other, BoxCollider), collision);

          // TODO: add PolyCollider
        }

      // TODO: add PolyCollider
    }
    return false;
  }

  public static function collideGroup( self :Collider, group :Array<Collider>, ?results :Array<Collision> ) :Bool
  {
    wasCollision = false;

    if (results != null) 
    {
      // we need to create one on the first time through...
      _collision = new Collision();
    }

    for (other in group)
    {
      if (results != null) {
        // only make a new one if the last one was used
        if (_collision == null) { _collision = new Collision(); }
        check = collide(self, other, _collision);
        // if we have a collider, we have a collision
        if (check)
        {
          results.push(_collision);
          _collision = null;
          wasCollision = true;
        }
      } else {
        check = collide(self, other, null);
        if (check) { wasCollision = true; }
      }
    }
    return wasCollision;
  }
  private static var check :Bool;
  private static var wasCollision :Bool;
  private static var _collision :Collision;

  
  // ------------------------------
  // Contains Helpers
  // ------------------------------

  public static function circle_contains( cc :CircleCollider, x :Float, y :Float ) :Bool 
  {
    // circle colliders are based around anchored position, not top left
    dx = cc.x - x; 
    dy = cc.y - y;
    return (dx*dx + dy*dy) > (cc.radius*cc.radius);
  }

  public static function box_contains( box :BoxCollider, x :Float, y :Float ) :Bool
  {
    // this assumes box x,y is center and not top left...
    dx = box.x - x;
    if (dx <= box.width) {
      dy = box.y - y;
      return (dy <= box.height);
    }
    return false;
  }

  // public static function poly_contains( polyCollider :PolyCollider, x :Float, y :Float ) :Bool
  // {
  //   return false;
  // }


  // ------------------------------
  // Collision Helpers
  // ------------------------------
  
  // ----- CIRCLE & _ COLLISIONS -----

  public static function circle_circle( cc1 :CircleCollider, cc2 :CircleCollider, ?collision :Collision ) :Bool
  {
    dx = cc1.x - cc2.x;
    dy = cc1.y - cc2.y;
    l = cc1.radius + cc2.radius;
    if (dx*dx + dy*dy < l*l) {

      if (collision != null)
      {
        d = Math.sqrt(dx*dx + dy*dy); // d: distance
        // assign the results
        if (d == 0) {
          collision.nx = 1;
          collision.ny = 1;
        } else {
          collision.nx = dx / d;
          collision.ny = dy / d;  
        }
        px = collision.nx * (l - d);
        py = collision.ny * (l - d);
        collision.px = px;
        collision.py = py;
        collision.collider = cc2;
        testForNaN(collision);
      }
      return true;
    }

    return false;
  }

  public static function circle_box( cc :CircleCollider, box :BoxCollider, ?collision :Collision ) :Bool
  {
    dx = cc.x - box.x; // delta x
    px = (cc.radius + box.hw) - Math.abs(dx); // penetration depth in x

    if (0 < px) {
      dy = cc.y - box.y; // delta y
      py = (cc.radius + box.hh) - Math.abs(dy); // penetration depth in y

      if (0 < py) {

        // get the distance to the closest edge
        dx = cc.x - clamp(cc.x, box.x - box.hw, box.x + box.hw);
        dy = cc.y - clamp(cc.y, box.y - box.hh, box.y + box.hh);
        
        if (dx*dx + dy*dy > cc.radius*cc.radius) { return false; }
        
        if (collision != null) 
        {
          d = Math.sqrt(dx*dx + dy*dy); // d: distance
          // assign the results
          if (d == 0) {
            collision.nx = 1;
            collision.ny = 1;
          } else {
            collision.nx = dx / d;
            collision.ny = dy / d;  
          }
          px = collision.nx * (cc.radius - d);
          py = collision.ny * (cc.radius - d);
          if (px == 0 && py == 0) { return false; }
          // get shallowest
          if (px != 0 && py != 0) {
            if (px < py) {
              py = 0;
            } else {
              px = 0;
            }
          }
          collision.px = px;
          collision.py = py;
          collision.collider = box;
          testForNaN(collision); // we should be able to get rid of these once we have it all sorted
        }
        
        return true;
      }
    }
    return false;
  }

  // TODO: circle_poly()

  // ----- BOX & _ COLLISIONS -----

  public static function box_box( box1 :BoxCollider, box2 :BoxCollider, ?collision :Collision ) :Bool
  {
    dx = box1.x - box2.x; // delta x
    px = (box1.hw + box2.hw) - Math.abs(dx); // penetration depth in x

    if (0 < px) {
      dy = box1.y - box2.y; // delta y
      py = (box1.hh + box2.hh) - Math.abs(dy); // penetration depth in y

      if (0 < py) {
        
        if (collision != null) 
        {
          l = Math.sqrt(px*px + py*py);
          // get shallowest
          if (px != 0 && py != 0) {
            if (px < py) {
              py = 0;
            } else {
              px = 0;
            }
          }

          if (dx < 0) { px *= -1; }
          if (dy < 0) { py *= -1; }
          // assign the results
          collision.px = px;
          collision.py = py;
          collision.nx = px / l;
          collision.ny = py / l;
          collision.collider = box2;
          testForNaN(collision); // we should be able to get rid of these once we have it all sorted
        }
        
        return true;
      }
    }
    return false;
  }

  public static function box_circle( box :BoxCollider, cc :CircleCollider, ?collision :Collision ) :Bool
  {
    dx = box.x - cc.x; // delta x
    px = (box.hw + cc.radius) - Math.abs(dx); // penetration depth in x

    if (0 < px) {
      dy = box.y - cc.y; // delta y
      py = (box.hh + cc.radius) - Math.abs(dy); // penetration depth in y

      if (0 < py) {

        // get the distance to the closest edge
        dx = cc.x - clamp(cc.x, box.x - box.hw, box.x + box.hw); 
        dy = cc.y - clamp(cc.y, box.y - box.hh, box.y + box.hh); 

        if (dx*dx + dy*dy > cc.radius*cc.radius) { return false; }
        
        if (collision != null) 
        {
          // super rare case
          d = Math.sqrt(dx*dx + dy*dy); // d: distance
          // assign the results
          if (d == 0) {
            collision.nx = 1;
            collision.ny = 1;
          } else {
            collision.nx = dx / d;
            collision.ny = dy / d;  
          }
          px = collision.nx * (cc.radius - d);
          py = collision.ny * (cc.radius - d);
          if (px == 0 && py == 0) {
            return false;
          }
          // get shallowest
          if (px != 0 && py != 0) {
            if (px < py) {
              py = 0;
            } else {
              px = 0;
            }
          }
          collision.px = px;
          collision.py = py;
          collision.collider = cc;
          testForNaN(collision); // we should be able to get rid of these once we have it all sorted
        }
        
        return true;
      }
    }
    return false;
  }

  // TODO: box_poly()
  
  // ----- POLY & _ COLLISIONS
  
  // TODO: poly_poly()

  // TODO: poly_circle()

  // TODO: poly_box()

  // ----- OTHER COLLISION HELPERS -----

  public static function aabb_aabb( aabb1 :AABB, aabb2 :AABB, ?collision :Collision ) :Bool
  {

    dx = aabb1.cx - aabb2.cx; // delta x
    px = (aabb1.hw + aabb2.hw) - Math.abs(dx); // penetration depth in x

    if (0 < px) {
      dy = aabb1.cy - aabb2.cy; // delta y
      py = (aabb1.hh + aabb2.hh) - Math.abs(dy); // penetration depth in y

      if (0 < py) {
        
        if (collision != null) 
        {
          // solve for shallowest
          if (px != 0 && py != 0) {
            if (px < py) {
              py = 0;
            } else {
              px = 0;
            }
          }
          if (dx < 0) { px *= -1; }
          if (dy < 0) { py *= -1; }

          l = Math.sqrt(px*px + py*py);
          // assign the results
          collision.px = px;
          collision.py = py;
          collision.nx = px / l;
          collision.ny = py / l;
          collision.collider = null; // an aabb isn't a collider
          testForNaN(collision); // we should be able to get rid of these once we have it all sorted
        }
        
        return true;
      }
    }
    return false;
  }

  public static inline function clamp( value :Float, min :Float, max :Float ) :Float
  {
    return ( value < min ? min : (value > max ? max : value) );
  }

  public static inline function distanceBetweenSquared( x1:Float, y1:Float, x2:Float, y2:Float ) :Float
  {
    return ((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1));
  } 

  public static inline function distanceBetween( x1:Float, y1:Float, x2:Float, y2:Float ) :Float
  {
    return Math.sqrt((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1));
  }


  private static var dx :Float;
  private static var dy :Float;
  private static var px :Float;
  private static var py :Float;
  private static var l :Float;
  private static var d :Float;


  private static function testForNaN( collision :Collision ) :Void
  {
    if ( Math.isNaN(collision.nx) || Math.isNaN(collision.ny) || Math.isNaN(collision.px) || Math.isNaN(collision.py) ) {
      haxe.Log.trace(collision.toString());
      throw new openfl.errors.Error('Collision resulted in NaN');
    }
  }

}