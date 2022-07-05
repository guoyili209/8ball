package model
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import math.Matrix3D;
   import math.Number2D;
   import math.Number3D;
   
   public class LogicalBall extends EventDispatcher
   {
      
      public static const MOVE_SLIDE:int = 1;
      
      public static const BALL_UPDATE:String = "ballUpdated";
      
      public static const MOVE_ROLL:int = 2;
      
      public static const nSTATE_POCKETED:int = 3;
      
      public static const nSTATE_IN_POCKET:int = 2;
      
      public static const BALL_POCKET:String = "ball Pocket";
      
      public static const nSTATE_IN_PLAY:int = 1;
      
      public static const nSTATE_IN_NONE:int = 0;
       
      
      public var number:uint;
      
      public var pocketNum:int;
      
      public var state:int;
      
      public var radius:Number;
      
      private var _isMoveable:Boolean;
      
      private var _vp:Number3D;
      
      public var _angular:Number3D;
      
      public var view:EventDispatcher;
      
      public var position:Number2D;
      
      public var movement:int;
      
      private var _r:Number3D;
      
      private var _v:Number2D;
      
      private var _w:Number3D;
      
      public var rotation:Matrix3D;
      
      public function LogicalBall()
      {
         super();
         this.radius = 9.5;
         this.position = new Number2D();
         this.rotation = new Matrix3D();
         this._w = new Number3D();
         this._r = new Number3D();
         this._v = new Number2D();
         this._vp = new Number3D();
         this._angular = new Number3D();
         this.state = nSTATE_IN_NONE;
         this.movement = MOVE_SLIDE;
      }
      
      public function set velocity(value:Number2D) : void
      {
         this._v = value;
      }
      
      public function updateVisualBall(time:Number = 0) : void
      {
         if(this.state == nSTATE_POCKETED)
         {
            this.velocity.y -= 0.01 * time;
            this.velocity.x -= 0.01 * time;
            if(this.velocity.y < 0)
            {
               this.velocity.y = 0;
            }
            if(this.velocity.x < -0.6)
            {
               this.velocity.x = -0.6;
            }
            this.w.x = this.velocity.y / this.radius;
            this.w.y = -this.velocity.x / this.radius;
         }
         dispatchEvent(new Event(BALL_UPDATE));
      }
      
      public function get w() : Number3D
      {
         return this._w;
      }
      
      public function move(time:Number = 1) : void
      {
         this._isMoveable = true;
         this.position.x += this.velocity.x * time;
         this.position.y += this.velocity.y * time;
      }
      
      public function rotate(time:Number = 1) : void
      {
         var w:Number3D = new Number3D();
         w.x = this._w.x;
         w.y = this._w.y;
         w.z = this._w.z;
         var len:Number = w.modulo * time;
         w.normalise();
         var r:Matrix3D = new Matrix3D();
         r.rotationMatrix(w,len);
         this.rotation.multiply(r);
      }
      
      public function get velocity() : Number2D
      {
         return this._v;
      }
      
      public function get isMoving() : Boolean
      {
         return this._v.x != 0 || this._v.y != 0 || this._w.x != 0 || this._w.y != 0 || this._w.z != 0;
      }
      
      public function setPosition(x:Number, y:Number) : void
      {
         this.position.x = x;
         this.position.y = y;
      }
      
      public function dropPocket() : void
      {
         dispatchEvent(new Event(BALL_POCKET));
         this.state = nSTATE_POCKETED;
      }
      
      public function set w(value:Number3D) : void
      {
         this._w = value;
      }
      
      public function get v() : Number2D
      {
         return this._v;
      }
      
      public function get r() : Number3D
      {
         return this._r;
      }
      
      public function stopMoving() : void
      {
         this._isMoveable = false;
         this._v.x = 0;
         this._v.y = 0;
         this._w.reset();
      }
   }
}
