package view.visualball
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   
   public class BallData
   {
      
      private static const BLACK:uint = 2299145;
      
      private static var BallMaskTextureClass:Class = view.visualball.BallData_BallMaskTextureClass;
      
      private static var ballMask:Bitmap;
      
      private static var ballNumber:Bitmap;
      
      private static var ballNumberClass:Class = view.visualball.BallData_ballNumberClass;
      
      private static var backColor:uint = 15658195;
      
      private static var dict:Array = [];
      
      private static var colors:Array = [16762368,2704565,14357267,6492525,16736256,414208,6622720,BLACK];
       
      
      public function BallData()
      {
         super();
      }
      
      public static function getBallData(number:int) : BitmapData
      {
         var bColor:uint = 0;
         var pixDeep:uint = 0;
         var pixDeep2:uint = 0;
         var pix1:uint = 0;
         var pix2:uint = 0;
         var bpix:uint = 0;
         if(dict[number] != null)
         {
            return dict[number] as BitmapData;
         }
         if(ballMask == null)
         {
            ballMask = new Bitmap(new BallMaskTextureClass());
         }
         if(ballNumber == null)
         {
            ballNumber = new Bitmap(new ballNumberClass());
         }
         var protyData:BitmapData = ballMask.bitmapData.clone();
         var isDoubleColor:* = false;
         var bWidth:int = protyData.width;
         var bHeight:int = protyData.height;
         var wLenght:int = ballNumber.width;
         var numPos:int = (bWidth - wLenght) / 2;
         var xPos:int = 0;
         var yPos:int = (number - 1) * wLenght;
         var xIndex:int = 0;
         var yIndex:int = 0;
         if(number == 0)
         {
            protyData.fillRect(new Rectangle(0,0,protyData.width,protyData.height),backColor | 4278190080);
         }
         else
         {
            isDoubleColor = number > 8;
            bColor = colors[(number - 1) % colors.length];
            while(yIndex < bWidth)
            {
               xIndex = 0;
               while(xIndex < bHeight)
               {
                  if(isDoubleColor)
                  {
                     pixDeep = (protyData.getPixel32(xIndex,yIndex) & 65280) >> 8;
                  }
                  else
                  {
                     pixDeep = protyData.getPixel32(xIndex,yIndex) & 255;
                  }
                  pixDeep2 = 255 - pixDeep;
                  pix1 = ((pixDeep * (bColor & 16711935) & 4278255360) >> 8) + ((pixDeep2 * (backColor & 16711935) & 4278255360) >> 8);
                  pix2 = (pixDeep * (bColor & 65280) >> 8 & 65280) + (pixDeep2 * (backColor & 65280) >> 8 & 65280);
                  protyData.setPixel32(xIndex,yIndex,pix1 | pix2 | 4278190080);
                  xIndex++;
               }
               yIndex++;
            }
            yIndex = 0;
            while(yIndex < wLenght)
            {
               xIndex = 0;
               while(xIndex < wLenght)
               {
                  bpix = protyData.getPixel32(xIndex + numPos,yIndex + numPos);
                  pixDeep = ballNumber.bitmapData.getPixel32(xIndex + xPos,yIndex + yPos) & 255;
                  pixDeep2 = 255 - pixDeep;
                  pix1 = ((pixDeep * (BLACK & 16711935) & 4278255360) >> 8) + ((pixDeep2 * (bpix & 16711935) & 4278255360) >> 8);
                  pix2 = (pixDeep * (BLACK & 65280) >> 8 & 65280) + (pixDeep2 * (bpix & 65280) >> 8 & 65280);
                  protyData.setPixel32(xIndex + numPos,yIndex + numPos,pix1 | pix2 | 4278190080);
                  xIndex++;
               }
               yIndex++;
            }
         }
         dict[number] = protyData;
         return protyData;
      }
   }
}
