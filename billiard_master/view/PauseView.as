package view
{
   import controller.StatesController;
   import flash.display.DisplayObject;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import model.GameData;
   
   public class PauseView extends Sprite
   {
      
      private static var pauseViewClass:Class = PauseView_pauseViewClass;
       
      
      private var _back:Object;
      
      private var count:int;
      
      private var _pausePreTime:int;
      
      public function PauseView()
      {
         super();
         this._back = new pauseViewClass();
         this._back.gotoAndStop(1);
         addChild(this._back as DisplayObject);
         this.x = 247;
         this.y = 215;
         this.overBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.overHandler);
         this.resumeBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.resumeHandler);
      }
      
      public function show(value:Boolean) : void
      {
         this.visible = value;
         if(value == true)
         {
            this._pausePreTime = getTimer();
            GameData.pauseTime = 0;
         }
         else
         {
            GameData.pauseTime = getTimer() - this._pausePreTime;
         }
      }
      
      public function backPauseMc(boo:Boolean = false, flag:Boolean = false) : Boolean
      {
         var _boo:Boolean = true;
         if(flag)
         {
            this._back.gotoAndStop(1);
         }
         if(boo == true && flag == false)
         {
            trace("55");
            this._back.gotoAndPlay(1);
            this._back.addEventListener(Event.ENTER_FRAME,this.backEnterFrame);
            _boo = false;
         }
         if(boo == false && flag == false)
         {
            trace("66");
            this._back.gotoAndPlay(36);
            this.count = 1;
            this._back.addEventListener(Event.ENTER_FRAME,this.backEnterFrame);
            _boo = true;
         }
         return _boo;
      }
      
      public function get overBtn() : SimpleButton
      {
         return this._back.over as SimpleButton;
      }
      
      public function get resumeBtn() : SimpleButton
      {
         return this._back.resume as SimpleButton;
      }
      
      private function overHandler(event:Event) : void
      {
         this.count = 0;
         this._back.gotoAndPlay(36);
         this._back.addEventListener(Event.ENTER_FRAME,this.backEnterFrame);
      }
      
      private function backEnterFrame(event:Event) : void
      {
         if(this._back.currentFrame == 35)
         {
            this._back.stop();
            this._back.removeEventListener(Event.ENTER_FRAME,this.backEnterFrame);
         }
         else if(this._back.currentFrame == 70)
         {
            if(this.count == 0)
            {
               StatesController.changeStates(StatesController.REPLAY);
            }
            else
            {
               StatesController.changeStates(StatesController.PLAY);
            }
            this._back.gotoAndStop(1);
         }
      }
      
      private function resumeHandler(event:Event) : void
      {
         this.count = 1;
         this._back.gotoAndPlay(36);
         this._back.addEventListener(Event.ENTER_FRAME,this.backEnterFrame);
      }
   }
}
