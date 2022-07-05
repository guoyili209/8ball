package common
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class NumCreate extends Sprite
   {
      
      private static var EMBEDDED_FONT:String = "NumCreate_EMBEDDED_FONT";
       
      
      private var _back:Shape;
      
      private var _highLightTF:TextField;
      
      private var _bScore:Boolean;
      
      private var _numberTF:TextField;
      
      public function NumCreate(_score:Boolean = false)
      {
         super();
         this._bScore = _score;
         this._back = new Shape();
         this._numberTF = this.creatTF();
         this._highLightTF = this.creatTF();
         this._numberTF.x = -this._numberTF.width / 2;
         this.filters = [new DropShadowFilter(2,90,0,1,4,4,1.2)];
         this.drawBack(500,50);
         this._back.x = -this._back.width / 2;
         this._back.mask = this._numberTF;
         this._highLightTF.alpha = 0;
         addChild(this._back);
         addChild(this._numberTF);
         addChild(this._highLightTF);
         this.y = 100;
      }
      
      public function set text(value:String) : void
      {
         this._numberTF.text = value;
         this._numberTF.x = -this._numberTF.width / 2;
      }
      
      private function drawBack(w:int = 100, h:int = 100) : void
      {
         this._back.y += h * 0.15;
         h *= 0.7;
         var colors:Array = [5156875,1150211,11530654,9895272];
         var alphas:Array = [100,100,100,100];
         var ratios:Array = [38,89,153,255];
         if(this._bScore)
         {
            colors = [11184810,8947848,15658734,12303291];
         }
         var matrix:Matrix = new Matrix();
         matrix.createGradientBox(w,h,-Math.PI / 2);
         this._back.graphics.beginGradientFill("linear",colors,alphas,ratios,matrix);
         this._back.graphics.drawRect(0,0,w,h);
         this._back.graphics.endFill();
      }
      
      public function setHightlight() : void
      {
         this._highLightTF.text = this._numberTF.text;
         this._highLightTF.x = this._numberTF.x;
         this._highLightTF.alpha = 0;
         TweenMax.from(this._highLightTF,0.7,{
            "alpha":0.9,
            "glowFilter":{
               "color":16777215,
               "alpha":0.8,
               "blurX":3,
               "blurY":3,
               "strength":3
            },
            "ease":Back.easeInOut
         });
      }
      
      private function creatTF() : TextField
      {
         var tf:TextField = new TextField();
         var format:TextFormat = new TextFormat();
         format.color = 16777215;
         format.font = "Arial";
         format.size = 36;
         tf.defaultTextFormat = format;
         tf.embedFonts = true;
         tf.autoSize = "center";
         tf.selectable = false;
         return tf;
      }
   }
}
