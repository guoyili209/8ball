package view.visualball
{
   import flash.display.BitmapData;
   import math.Matrix3D;
   
   public class BallRender
   {
      
      private static var _alphaParent:Number;
      
      private static var _radiusX2:Number;
      
      private static var _diameter:Number;
      
      private static var _radius:Number;
      
      private static var _alphaValue:Number;
       
      
      public function BallRender()
      {
         super();
      }
      
      public static function setRadius(value:Number) : void
      {
         _radius = value;
         _diameter = _radius * 2;
         _radiusX2 = _radius * _radius;
         _alphaValue = (_radius - 1) * (_radius - 1);
         _alphaParent = 256 / (_radiusX2 - _alphaValue);
      }
      
      public static function renderBall(ballSource:BitmapData, ballTarget:BitmapData = null, rotation:Matrix3D = null, xOffset:Number = 0, yOffset:Number = 0) : BitmapData
      {
         var deep:int = 0;
         if(ballTarget == null)
         {
            ballTarget = new BitmapData(_diameter,_diameter);
         }
         if(rotation == null)
         {
            rotation = new Matrix3D();
         }
         var sWidth:Number = ballSource.width / 2;
         var sHeight:Number = ballSource.height / 2;
         var tWidth:int = ballTarget.width;
         var tHeight:int = ballTarget.height;
         var xRela:Number = 0;
         var yRela:Number = 0;
         var xProp:Number = 0;
         var yPorp:Number = 0;
         var dist:Number = 0;
         var xIndex:uint = 0;
         var yIndex:uint = 0;
         var iVect:Number = 0;
         var jVect:Number = 0;
         var kVect:Number = 0;
         var colorDeep:uint = 0;
         var isBack:int = rotation.n33 >= 0 ? 1 : -1;
         var pix:uint = 0;
         var temp:int = 0;
         ballTarget.lock();
         while(yIndex < tWidth)
         {
            xIndex = 0;
            while(xIndex < tHeight)
            {
               xRela = xIndex - _radius + xOffset;
               yRela = yIndex - _radius + yOffset;
               iVect = xRela / _radius;
               jVect = yRela / _radius;
               dist = xRela * xRela + yRela * yRela;
               if(dist < _radiusX2)
               {
                  kVect = Math.sqrt(1 - iVect * iVect - jVect * jVect);
                  colorDeep = 64 + kVect * 191;
                  xProp = (iVect * rotation.n11 + jVect * rotation.n12 + kVect * rotation.n13) * isBack;
                  yPorp = iVect * rotation.n21 + jVect * rotation.n22 + kVect * rotation.n23;
                  pix = ballSource.getPixel32(sWidth + sWidth * xProp,sHeight + sHeight * yPorp);
                  pix = ((pix & 16711935) * colorDeep >> 8 & 16711935) + ((pix & 65280) * colorDeep >> 8 & 65280);
                  if(dist <= _alphaValue)
                  {
                     pix = 4278190080 + pix;
                  }
                  else
                  {
                     deep = 256 - (dist - _alphaValue) * _alphaParent;
                     pix = (deep << 24) + pix;
                  }
               }
               else
               {
                  pix = 0;
               }
               ballTarget.setPixel32(xIndex,yIndex,pix);
               xIndex++;
            }
            yIndex++;
         }
         ballTarget.unlock();
         return ballTarget;
      }
   }
}
