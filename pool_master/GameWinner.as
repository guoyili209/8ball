package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.media.SoundChannel;
   import flash.text.TextField;
   
   public class GameWinner extends MovieClip
   {
       
      
      public var backBtn:SimpleButton;
      
      private var pool:Object;
      
      private var myChannel:SoundChannel;
      
      public var grandTxt:TextField;
      
      public function GameWinner(param1:*, param2:*)
      {
         super();
         playAlertSound();
         this.pool = param1;
         backBtn.addEventListener(MouseEvent.CLICK,back);
         grandTxt.text = "" + param2;
      }
      
      function playAlertSound() : *
      {
         var _loc1_:MyAlertSound = null;
         _loc1_ = new MyAlertSound();
         myChannel = _loc1_.play();
      }
      
      public function back(param1:MouseEvent) : void
      {
         pool.backToMenu(null);
      }
   }
}
