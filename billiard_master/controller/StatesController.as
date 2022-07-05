package controller
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import view.PauseView;
   
   public class StatesController
   {
      
      public static const START:int = 0;
      
      private static var _dispatcher:EventDispatcher = new EventDispatcher();
      
      public static const STATES_CHANGE:String = "states change event";
      
      public static const PAUSE:int = 3;
      
      private static var _lastStates:int = 0;
      
      private static var _curStates:int = 0;
      
      public static const REPLAY:int = 4;
      
      public static const PLAY:int = 1;
      
      public static const END:int = 2;
       
      
      public function StatesController()
      {
         super();
      }
      
      public static function bindPlatform() : void
      {
      }
      
      public static function changeStates(states:int) : int
      {
         if(states != _curStates)
         {
            _lastStates = _curStates;
            _curStates = states;
            _dispatcher.dispatchEvent(new Event(STATES_CHANGE));
         }
         return _curStates;
      }
      
      public static function returnStates() : int
      {
         return changeStates(lastStates);
      }
      
      public static function gamePause() : void
      {
         var _pauseView:* = undefined;
         if(curStates == PLAY)
         {
            trace("changeStates(PAUSE);11111111111111");
            changeStates(PAUSE);
         }
         else if(curStates == PAUSE && lastStates == PLAY)
         {
            trace("returnStates();222222222222222222222");
            _pauseView = new PauseView();
            _pauseView.backPauseMc(false);
         }
      }
      
      public static function get dispatcher() : EventDispatcher
      {
         return _dispatcher;
      }
      
      public static function get curStates() : int
      {
         return _curStates;
      }
      
      public static function get lastStates() : int
      {
         return _lastStates;
      }
      
      private static function platformStatesHandler(event:Event) : void
      {
      }
   }
}
