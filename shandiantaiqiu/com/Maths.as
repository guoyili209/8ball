package com
{
   import flash.geom.Point;
   
   public class Maths
   {
       
      
      public function Maths()
      {
         super();
      }
      
      public static function lineIntersectLine(A:Point, B:Point, E:Point, F:Point, as_seg:Boolean = true) : Point
      {
         var ip:Point = null;
         var a1:Number = NaN;
         var a2:Number = NaN;
         var b1:Number = NaN;
         var b2:Number = NaN;
         var c1:Number = NaN;
         var c2:Number = NaN;
         a1 = B.y - A.y;
         b1 = A.x - B.x;
         c1 = B.x * A.y - A.x * B.y;
         a2 = F.y - E.y;
         b2 = E.x - F.x;
         c2 = F.x * E.y - E.x * F.y;
         var denom:Number = a1 * b2 - a2 * b1;
         if(denom == 0)
         {
            return null;
         }
         ip = new Point();
         ip.x = (b1 * c2 - b2 * c1) / denom;
         ip.y = (a2 * c1 - a1 * c2) / denom;
         ip.x = fixNumber(ip.x);
         ip.y = fixNumber(ip.y);
         if(as_seg)
         {
            if((ip.x - A.x) * (ip.x - B.x) > 0 || (ip.y - A.y) * (ip.y - B.y) > 0 || (ip.x - E.x) * (ip.x - F.x) > 0 || (ip.y - E.y) * (ip.y - F.y) > 0)
            {
               return null;
            }
         }
         return ip;
      }
      
      public static function lineIntersectCircle(A:Point, B:Point, C:Point, r:Number) : Object
      {
         var e:Number = NaN;
         var u1:Number = NaN;
         var u2:Number = NaN;
         var result:Object = new Object();
         result.inside = false;
         result.tangent = false;
         result.intersects = false;
         result.enter = null;
         result.exit = null;
         var a:Number = (B.x - A.x) * (B.x - A.x) + (B.y - A.y) * (B.y - A.y);
         var b:Number = 2 * ((B.x - A.x) * (A.x - C.x) + (B.y - A.y) * (A.y - C.y));
         var cc:Number = C.x * C.x + C.y * C.y + A.x * A.x + A.y * A.y - 2 * (C.x * A.x + C.y * A.y) - r * r;
         var deter:Number = fixNumber(b * b - 4 * a * cc);
         if(deter <= 0)
         {
            result.inside = false;
         }
         else
         {
            e = fixNumber(Math.sqrt(deter));
            u1 = fixNumber((-b + e) / (2 * a));
            u2 = fixNumber((-b - e) / (2 * a));
            if((u1 < 0 || u1 > 1) && (u2 < 0 || u2 > 1))
            {
               if(u1 < 0 && u2 < 0 || u1 > 1 && u2 > 1)
               {
                  result.inside = false;
               }
               else
               {
                  result.inside = true;
               }
            }
            else
            {
               if(0 <= u2 && u2 <= 1)
               {
                  result.enter = Point.interpolate(A,B,1 - u2);
                  result.enter = new Point(fixNumber(result.enter.x),fixNumber(result.enter.y));
               }
               if(0 <= u1 && u1 <= 1)
               {
                  result.exit = Point.interpolate(A,B,1 - u1);
                  result.exit = new Point(fixNumber(result.exit.x),fixNumber(result.exit.y));
               }
               result.intersects = true;
               if(result.exit != null && result.enter != null && result.exit.equals(result.enter))
               {
                  result.tangent = true;
               }
            }
         }
         return result;
      }
      
      public static function findBearing(x:Number, y:Number) : Number
      {
         var bearing:Number = 180 / Math.PI * Math.atan2(y,x);
         return fixNumber(bearing);
      }
      
      public static function angleDiff(bearing1:Number, bearing2:Number) : Number
      {
         var diff:Number = wrapValue(bearing1 + 180 - bearing2) - 180;
         return fixNumber(diff);
      }
      
      public static function wrapValue(input:Number) : Number
      {
         if(input > 360)
         {
            input -= 360;
         }
         if(input < 0)
         {
            input += 360;
         }
         return input;
      }
      
      public static function fixNumber(numberValue:Number) : Number
      {
         return !!isNaN(Number(numberValue)) ? Number(0) : Number(Math.round(Number(numberValue) * 10000) / 10000);
      }
      
      public static function createVectorFrom2Points(point1:*, point2:*) : Vector2D
      {
         return new Vector2D(point2.x - point1.x,point2.y - point1.y);
      }
   }
}
