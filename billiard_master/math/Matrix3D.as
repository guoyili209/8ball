package math
{
   public class Matrix3D
   {
       
      
      public var n31:Number;
      
      public var n21:Number;
      
      public var n11:Number;
      
      public var n23:Number;
      
      public var n13:Number;
      
      public var n32:Number;
      
      public var n22:Number;
      
      public var n12:Number;
      
      public var n33:Number;
      
      public function Matrix3D()
      {
         super();
         this.reset();
      }
      
      public function multiply(b:Matrix3D) : void
      {
         var tn11:Number = this.n11 * b.n11 + this.n12 * b.n21 + this.n13 * b.n31;
         var tn12:Number = this.n11 * b.n12 + this.n12 * b.n22 + this.n13 * b.n32;
         var tn13:Number = this.n11 * b.n13 + this.n12 * b.n23 + this.n13 * b.n33;
         var tn21:Number = this.n21 * b.n11 + this.n22 * b.n21 + this.n23 * b.n31;
         var tn22:Number = this.n21 * b.n12 + this.n22 * b.n22 + this.n23 * b.n32;
         var tn23:Number = this.n21 * b.n13 + this.n22 * b.n23 + this.n23 * b.n33;
         var tn31:Number = this.n31 * b.n11 + this.n32 * b.n21 + this.n33 * b.n31;
         var tn32:Number = this.n31 * b.n12 + this.n32 * b.n22 + this.n33 * b.n32;
         var tn33:Number = this.n31 * b.n13 + this.n32 * b.n23 + this.n33 * b.n33;
         this.n11 = tn11;
         this.n12 = tn12;
         this.n13 = tn13;
         this.n21 = tn21;
         this.n22 = tn22;
         this.n23 = tn23;
         this.n31 = tn31;
         this.n32 = tn32;
         this.n33 = tn33;
      }
      
      public function reset() : void
      {
         this.n11 = this.n22 = this.n33 = 1;
         this.n12 = this.n13 = this.n21 = this.n23 = this.n31 = this.n32 = 0;
      }
      
      public function add(num:Number3D) : void
      {
         var z:Number = NaN;
         var x:Number = num.x;
         var y:Number = num.y;
         z = num.z;
         num.x = this.n11 * x + this.n12 * y + this.n13 * z;
         num.y = this.n21 * x + this.n22 * y + this.n23 * z;
         num.z = this.n31 * x + this.n32 * y + this.n33 * z;
      }
      
      public function toString() : String
      {
         var s:* = "[" + this.n11 + "," + this.n12 + "," + this.n13 + "]\n";
         s += "[" + this.n21 + "," + this.n22 + "," + this.n23 + "]\n";
         return s + ("[" + this.n31 + "," + this.n32 + "," + this.n33 + "]\n");
      }
      
      public function rotationMatrix(point:Number3D, rad:Number) : void
      {
         var x:Number = point.x;
         var y:Number = point.y;
         var z:Number = point.z;
         var nCos:Number = Math.cos(rad);
         var nSin:Number = Math.sin(rad);
         var scos:Number = 1 - nCos;
         var sxy:Number = x * y * scos;
         var syz:Number = y * z * scos;
         var sxz:Number = x * z * scos;
         var sz:Number = nSin * z;
         var sy:Number = nSin * y;
         var sx:Number = nSin * x;
         this.n11 = nCos + x * x * scos;
         this.n12 = -sz + sxy;
         this.n13 = sy + sxz;
         this.n21 = sz + sxy;
         this.n22 = nCos + y * y * scos;
         this.n23 = -sx + syz;
         this.n31 = -sy + sxz;
         this.n32 = sx + syz;
         this.n33 = nCos + z * z * scos;
      }
   }
}
