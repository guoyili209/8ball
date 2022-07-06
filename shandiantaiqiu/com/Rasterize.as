package com
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class Rasterize extends MovieClip
   {
       
      
      public function Rasterize()
      {
         super();
      }
      
      public static function convertToRaster(source:DisplayObject) : Sprite
      {
         var snapClip:Function = function(clip:DisplayObject):BitmapData
         {
            var bounds:Rectangle = getRealBounds(clip);
            var bitmap:BitmapData = new BitmapData(Math.ceil(int(bounds.width + 0.5) * clip.scaleX),Math.ceil(int(bounds.height + 0.5) * clip.scaleY),true,0);
            var m:Matrix = new Matrix(1,0,0,1,-bounds.x,-bounds.y);
            m.scale(clip.scaleX,clip.scaleY);
            bitmap.draw(clip,m);
            return bitmap;
         };
         var getRealBounds:Function = function(displayObject:DisplayObject):Rectangle
         {
            var bounds:Rectangle = null;
            var boundsDispO:Rectangle = displayObject.getBounds(displayObject);
            var bitmapData:BitmapData = new BitmapData(int(boundsDispO.width + 0.5),int(boundsDispO.height + 0.5),true,0);
            var matrix:Matrix = new Matrix();
            matrix.translate(-boundsDispO.x,-boundsDispO.y);
            bitmapData.draw(displayObject,matrix,new ColorTransform(1,1,1,1,255,-255,-255,255));
            bounds = bitmapData.getColorBoundsRect(4278190080,4278190080);
            bounds.x += boundsDispO.x;
            bounds.y += boundsDispO.y;
            bitmapData.dispose();
            return bounds;
         };
         var regX:* = source.getBounds(source).x * source.scaleX;
         var regY:* = source.getBounds(source).y * source.scaleY;
         var bmd:BitmapData = snapClip(source);
         var bm:Bitmap = new Bitmap(bmd);
         bm.pixelSnapping = PixelSnapping.NEVER;
         bm.smoothing = true;
         var mc:Sprite = new Sprite();
         mc.addChild(bm);
         bm.x = regX;
         bm.y = regY;
         mc.mouseChildren = false;
         return mc;
      }
   }
}
