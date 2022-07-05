package controller
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class TimeController extends EventDispatcher
   {
      
      private static var _instanse:TimeController;
      
      public static const TIME_PLAY:String = "time play";
      
      public static const TIME_END:String = "time end";
       
      
      private var _lastTime:int;
      
      private var _curTimer:int;
      
      private var _timer:Timer;
      
      private var _pauseTimer:int;
      
      public function TimeController()
      {
         super();
         if(_instanse)
         {
            throw new Error("TimeController is single Class");
         }
         this._timer = new Timer(10);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.completeHandler);
      }
      
      public static function get Instanse() : TimeController
      {
         if(_instanse == null)
         {
            _instanse = new TimeController();
         }
         return _instanse;
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         this._curTimer = getTimer();
         if(this._curTimer - this._lastTime >= 1000)
         {
            dispatchEvent(new Event(TIME_PLAY));
            this._lastTime = this._curTimer;
         }
      }
      
      public function stop() : void
      {
         trace("stop");
         this._timer.stop();
         this.completeHandler();
      }
      
      private function completeHandler(event:TimerEvent = null) : void
      {
         trace("completeHandler");
         dispatchEvent(new Event(TIME_END));
      }
      
      public function play() : void
      {
         this._timer.start();
         this._lastTime = getTimer();
      }
      
      public function pause(value:Boolean = true) : void
      {
         if(value == true && this._timer.running)
         {
            this._timer.stop();
            this._pauseTimer = getTimer();
         }
         else if(value == false && this._timer.running == false)
         {
            this._lastTime += getTimer() - this._pauseTimer;
            this._timer.start();
         }
      }
   }
}
