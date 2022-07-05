package view
{
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import math.Number2D;
      import flash.display.Bitmap;
   
   public class CueAngleView extends Sprite
   {
     
      private static var CueAngleClass:Class = view.CueAngleView_CueAngleClass;
       
      
      private var radius:Number = 0;
      
      private var _pos:Number2D;
      
      private var _isDrag:Boolean;
      
      private var _aimCirle:Shape;
      
      public function CueAngleView()
      {
         super();
         var back:DisplayObject = new Bitmap(new CueAngleClass());
         this.radius = 22;
         back.x = -37;
         back.y = -33;
         addChild(back);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         this._aimCirle = this.creatAim();
         addChild(this._aimCirle);
         this._isDrag = false;
         this._pos = new Number2D();
      }
      
      public function getValue() : Number2D
      {
         this._pos.x = this._aimCirle.x / this.radius;
         this._pos.y = this._aimCirle.y / this.radius;
         return this._pos;
      }
      
      private function mouseDownHandler(event:MouseEvent) : void
      {
         this._isDrag = true;
         this.setPosition();
         this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         this.stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
      }
      
      private function setPosition() : void
      {
         var pos:Number2D = null;
         if(this._isDrag)
         {
            pos = new Number2D(this.mouseX,this.mouseY);
            if(pos.length > this.radius)
            {
               pos.normalise();
               pos.scale(this.radius);
            }
            this._aimCirle.x = pos.x;
            this._aimCirle.y = pos.y;
         }
      }
      
      public function reset() : void
      {
         this._aimCirle.x = 0;
         this._aimCirle.y = 0;
      }
      
      private function mouseUpHandler(event:MouseEvent) : void
      {
         this._isDrag = false;
         this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         this.stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
      }
      
      private function mouseMoveHandler(event:MouseEvent) : void
      {
         this.setPosition();
      }
      
      public function get isMove() : Boolean
      {
         return this._isDrag;
      }
      
      private function creatAim() : Shape
      {
         var aim:Shape = new Shape();
         aim.graphics.lineStyle(2,16724787,0.7);
         aim.graphics.drawCircle(0,0,5);
         return aim;
      }
   }
}
