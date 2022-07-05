package math
{
   public class Number2D
   {
      
      public static const RADTODEG:Number = 180 / Math.PI;
      
      public static const DEGTORAD:Number = Math.PI / 180;
       
      
      public var x:Number;
      
      public var y:Number;
      
      public function Number2D(x:Number = 0, y:Number = 0)
      {
         super();
         this.x = x;
         this.y = y;
      }
      
      public static function multiplyScalar(v:Number2D, n:Number) : Number2D
      {
         return new Number2D(v.x * n,v.y * n);
      }
      
      public static function subtract(v:Number2D, w:Number2D) : Number2D
      {
         return new Number2D(v.x - w.x,v.y - w.y);
      }
      
      public static function cross(v:Number2D, w:Number2D) : Number
      {
         return v.x * w.y + v.y * w.x;
      }
      
      public static function dot(v:Number2D, w:Number2D) : Number
      {
         return v.x * w.x + v.y * w.y;
      }
      
      public function divideEq(d:Number) : void
      {
         this.x /= d;
         this.y /= d;
      }
      
      public function scale(value:Number) : void
      {
         this.x *= value;
         this.y *= value;
      }
      
      public function reset(x:Number = 0, y:Number = 0) : void
      {
         this.x = x;
         this.y = y;
      }
      
      public function copyTo(v:Number2D) : void
      {
         v.x = this.x;
         v.y = this.y;
      }
      
      public function get moduloSquared() : Number
      {
         return this.x * this.x + this.y * this.y;
      }
      
      public function angle() : Number
      {
         if(Common.useDEGREES)
         {
            return RADTODEG * Math.atan2(this.y,this.x);
         }
         return Math.atan2(this.y,this.x);
      }
      
      public function rotate(angle:Number) : void
      {
         var temp:Number2D = null;
         if(Common.useDEGREES)
         {
            angle *= DEGTORAD;
         }
         var cosRY:Number = Math.cos(angle);
         var sinRY:Number = Math.sin(angle);
         temp = this.clone();
         this.x = temp.x * cosRY - temp.y * sinRY;
         this.y = temp.x * sinRY + temp.y * cosRY;
      }
      
      public function clone() : Number2D
      {
         return new Number2D(this.x,this.y);
      }
      
      public function add(x:Number, y:Number) : void
      {
         this.x += x;
         this.y += y;
      }
      
      public function reverse() : void
      {
         this.x = -this.x;
         this.y = -this.y;
      }
      
      public function get length() : Number
      {
         return Math.sqrt(this.x * this.x + this.y * this.y);
      }
      
      public function isModuloGreaterThan(v:Number) : Boolean
      {
         return this.moduloSquared > v * v;
      }
      
      public function toString() : String
      {
         var x:Number = Math.round(this.x * 1000) / 1000;
         var y:Number = Math.round(this.y * 1000) / 1000;
         return "[" + x + ", " + y + "]";
      }
      
      public function plusEq(v:Number2D) : void
      {
         this.x += v.x;
         this.y += v.y;
      }
      
      public function isModuloEqualTo(v:Number) : Boolean
      {
         return this.moduloSquared == v * v;
      }
      
      public function multiplyEq(d:Number) : void
      {
         this.x *= d;
         this.y *= d;
      }
      
      public function normalise() : void
      {
         var m:Number = this.modulo;
         this.x /= m;
         this.y /= m;
      }
      
      public function get modulo() : Number
      {
         return Math.sqrt(this.x * this.x + this.y * this.y);
      }
      
      public function isModuloLessThan(v:Number) : Boolean
      {
         return this.moduloSquared < v * v;
      }
      
      public function minusEq(v:Number2D) : void
      {
         this.x -= v.x;
         this.y -= v.y;
      }
      
      public function copyFrom(v:Number2D) : void
      {
         this.x = v.x;
         this.y = v.y;
      }
   }
}
