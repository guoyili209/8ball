package math
{
   public class Number3D
   {
      
      public static var toDEGREES:Number = 180 / Math.PI;
      
      private static var temp:Number3D = Number3D.ZERO;
      
      public static var toRADIANS:Number = Math.PI / 180;
       
      
      public var z:Number;
      
      public var x:Number;
      
      public var y:Number;
      
      public function Number3D(x:Number = 0, y:Number = 0, z:Number = 0)
      {
         super();
         this.x = x;
         this.y = y;
         this.z = z;
      }
      
      public static function sub(v:Number3D, w:Number3D) : Number3D
      {
         return new Number3D(v.x - w.x,v.y - w.y,v.z - w.z);
      }
      
      public static function unit(v:Number3D) : Number3D
      {
         var t:Number3D = v.clone();
         t.normalise();
         return t;
      }
      
      public static function cross(v:Number3D, w:Number3D, targetN:Number3D = null) : Number3D
      {
         if(!targetN)
         {
            targetN = ZERO;
         }
         targetN.reset(w.y * v.z - w.z * v.y,w.z * v.x - w.x * v.z,w.x * v.y - w.y * v.x);
         return targetN;
      }
      
      public static function dot(v:Number3D, w:Number3D) : Number
      {
         return v.x * w.x + v.y * w.y + w.z * v.z;
      }
      
      public static function scale(v:Number3D, scale:Number) : Number3D
      {
         return new Number3D(v.x * scale,v.y * scale,v.z * scale);
      }
      
      public static function addEp(v:Number3D, w:Number3D) : Number3D
      {
         return new Number3D(v.x + w.x,v.y + w.y,v.z + w.z);
      }
      
      public static function get ZERO() : Number3D
      {
         return new Number3D(0,0,0);
      }
      
      public function normalize() : void
      {
         var mod:Number = Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
         if(mod != 0 && mod != 1)
         {
            mod = 1 / mod;
            this.x *= mod;
            this.y *= mod;
            this.z *= mod;
         }
      }
      
      public function reset(newx:Number = 0, newy:Number = 0, newz:Number = 0) : void
      {
         this.x = newx;
         this.y = newy;
         this.z = newz;
      }
      
      public function copyTo(n:Number3D) : void
      {
         n.x = this.x;
         n.y = this.y;
         n.z = this.z;
      }
      
      public function get moduloSquared() : Number
      {
         return this.x * this.x + this.y * this.y + this.z * this.z;
      }
      
      public function isModuloGreaterThan(v:Number) : Boolean
      {
         return this.moduloSquared > v * v;
      }
      
      public function rotateX(angle:Number) : void
      {
         if(Common.useDEGREES)
         {
            angle *= toRADIANS;
         }
         var cosRY:Number = Math.cos(angle);
         var sinRY:Number = Math.sin(angle);
         temp.copyFrom(this);
         this.y = temp.y * cosRY - temp.z * sinRY;
         this.z = temp.y * sinRY + temp.z * cosRY;
      }
      
      public function rotateY(angle:Number) : void
      {
         if(Common.useDEGREES)
         {
            angle *= toRADIANS;
         }
         var cosRY:Number = Math.cos(angle);
         var sinRY:Number = Math.sin(angle);
         temp.copyFrom(this);
         this.x = temp.x * cosRY + temp.z * sinRY;
         this.z = temp.x * -sinRY + temp.z * cosRY;
      }
      
      public function rotateZ(angle:Number) : void
      {
         if(Common.useDEGREES)
         {
            angle *= toRADIANS;
         }
         var cosRY:Number = Math.cos(angle);
         var sinRY:Number = Math.sin(angle);
         temp.copyFrom(this);
         this.x = temp.x * cosRY - temp.y * sinRY;
         this.y = temp.x * sinRY + temp.y * cosRY;
      }
      
      public function add(x:Number = 0, y:Number = 0, z:Number = 0) : void
      {
         this.x += x;
         this.y += y;
         this.z += z;
      }
      
      public function reverse() : void
      {
         this.x = -this.x;
         this.y = -this.y;
         this.z = -this.z;
      }
      
      public function clone() : Number3D
      {
         return new Number3D(this.x,this.y,this.z);
      }
      
      public function plusEq(v:Number3D) : void
      {
         this.x += v.x;
         this.y += v.y;
         this.z += v.z;
      }
      
      public function toString() : String
      {
         return "x:" + Math.round(this.x * 100) / 100 + " y:" + Math.round(this.y * 100) / 100 + " z:" + Math.round(this.z * 100) / 100;
      }
      
      public function isModuloEqualTo(v:Number) : Boolean
      {
         return this.moduloSquared == v * v;
      }
      
      public function multiplyEq(n:Number) : void
      {
         this.x *= n;
         this.y *= n;
         this.z *= n;
      }
      
      public function get modulo() : Number
      {
         return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
      }
      
      public function isModuloLessThan(v:Number) : Boolean
      {
         return this.moduloSquared < v * v;
      }
      
      public function normalise() : void
      {
         var len:Number = this.modulo;
         if(len != 0)
         {
            this.x /= len;
            this.y /= len;
            this.z /= len;
         }
         else
         {
            this.x = 0;
            this.y = 0;
            this.z = 0;
         }
      }
      
      public function minusEq(v:Number3D) : void
      {
         this.x -= v.x;
         this.y -= v.y;
         this.z -= v.z;
      }
      
      public function copyFrom(n:Number3D) : void
      {
         this.x = n.x;
         this.y = n.y;
         this.z = n.z;
      }
   }
}
