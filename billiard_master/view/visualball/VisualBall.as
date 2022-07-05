package view.visualball
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Matrix;
   import model.LogicalBall;
   import sound.SoundContain;
   
   public class VisualBall extends EventDispatcher
   {
       
      
      private var _ballSprite:Sprite;
      
      private var _highlightBitmap:BitmapData;
      
      private var _highlightClass:Class;
      
      private var _shadowBitmap:BitmapData;
      
      private var _shadowBitmapClass:Class;
      
      private var m_cLogicalBall:LogicalBall;
      
      private var _ballShadow:Sprite;
      
      private var _ballRender:BitmapData;
      
      private var _ballData:BitmapData;
      
      private var _ballHighlight:Sprite;
      
      public function VisualBall(logicalBall:LogicalBall, data:BitmapData)
      {
         this._shadowBitmapClass = view.visualball.VisualBall__shadowBitmapClass;
         this._highlightClass = view.visualball.VisualBall__highlightClass;
         super();
         this.m_cLogicalBall = logicalBall;
         logicalBall.view = this;
         this.m_cLogicalBall.addEventListener(LogicalBall.BALL_UPDATE,this.ballUpdated);
         this.m_cLogicalBall.addEventListener(LogicalBall.BALL_POCKET,this.ballPocketed);
         this._shadowBitmap = new Bitmap(new this._shadowBitmapClass()).bitmapData;
         this._highlightBitmap = new Bitmap(new this._highlightClass()).bitmapData;
         this._ballData = data;
         var transMatrix:Matrix = new Matrix();
         this._ballRender = new BitmapData(Math.ceil(this.m_cLogicalBall.radius * 2),Math.ceil(this.m_cLogicalBall.radius * 2));
         this._ballShadow = new Sprite();
         transMatrix.identity();
         transMatrix.translate(-this._shadowBitmap.width / 2,-this._shadowBitmap.height / 2);
         this._ballShadow.graphics.beginBitmapFill(this._shadowBitmap,transMatrix,false,true);
         this._ballShadow.graphics.drawRect(-this._shadowBitmap.width / 2,-this._shadowBitmap.height / 2,this._shadowBitmap.width,this._shadowBitmap.height);
         this._ballShadow.graphics.endFill();
         this._ballHighlight = new Sprite();
         transMatrix.identity();
         transMatrix.translate(-this._highlightBitmap.width / 2,-this._highlightBitmap.height / 2);
         this._ballHighlight.graphics.beginBitmapFill(this._highlightBitmap,transMatrix,false,true);
         this._ballHighlight.graphics.drawRect(-this._highlightBitmap.width / 2,-this._highlightBitmap.height / 2,this._highlightBitmap.width,this._highlightBitmap.height);
         this._ballHighlight.graphics.endFill();
         this._ballSprite = new Sprite();
         var xTrans:Number = -this._ballRender.width / 2;
         var yTrans:Number = -this._ballRender.height / 2;
         transMatrix.identity();
         transMatrix.translate(xTrans,yTrans);
         this._ballSprite.graphics.beginBitmapFill(this._ballRender,transMatrix,false);
         this._ballSprite.graphics.drawRect(xTrans,yTrans,this._ballRender.width,this._ballRender.height);
         this._ballSprite.graphics.endFill();
      }
      
      public function ballPocketed(event:Event) : void
      {
         trace("掉袋");
         SoundContain.playSound(SoundContain.BALL_POCKET);
         if(this._ballSprite.parent)
         {
            this._ballSprite.parent.removeChild(this._ballSprite);
         }
         if(this._ballShadow.parent)
         {
            this._ballShadow.parent.removeChild(this._ballShadow);
         }
         if(this._ballHighlight.parent)
         {
            this._ballHighlight.parent.removeChild(this._ballHighlight);
         }
      }
      
      public function get ballHighlight() : Sprite
      {
         return this._ballHighlight;
      }
      
      public function get ballSprite() : Sprite
      {
         return this._ballSprite;
      }
      
      public function get logicalBall() : LogicalBall
      {
         return this.m_cLogicalBall;
      }
      
      private function renderBall() : void
      {
         var xNum:Number = this.m_cLogicalBall.position.x;
         var yNum:Number = this.m_cLogicalBall.position.y;
         var xInt:int = xNum;
         var yInt:int = yNum;
         var xDist:Number = 1 - (xNum - xInt);
         var yDist:Number = 1 - (yNum - yInt);
         BallRender.renderBall(this._ballData,this._ballRender,this.m_cLogicalBall.rotation,xDist,yDist);
         this._ballSprite.x = xInt;
         this._ballSprite.y = yInt;
         this._ballHighlight.x = this.m_cLogicalBall.position.x;
         this._ballHighlight.y = this.m_cLogicalBall.position.y;
         this._ballShadow.x = this.m_cLogicalBall.position.x;
         this._ballShadow.y = this.m_cLogicalBall.position.y;
      }
      
      public function ballUpdated(event:Event) : void
      {
         this.renderBall();
      }
      
      public function get bitmap() : Bitmap
      {
         trace("bitmap");
         return new Bitmap(this._ballRender);
      }
      
      public function get ballShadow() : Sprite
      {
         return this._ballShadow;
      }
   }
}
