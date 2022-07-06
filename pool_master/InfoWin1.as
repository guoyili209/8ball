package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.media.SoundChannel;
   import flash.text.TextField;
   
   public class InfoWin1 extends MovieClip
   {
       
      
      public var shotsTakenTxt:TextField;
      
      public var backBtn:SimpleButton;
      
      private var pool:Object;
      
      public var scratchTxt:TextField;
      
      public var arcadeBtn:SimpleButton;
      
      public var timeTxt:TextField;
      
      public var accuracyTxt:TextField;
      
      public var timeBonusTxt:TextField;
      
      private var myChannel:SoundChannel;
      
      public var scoreTxt:TextField;
      
      public var grandTxt:TextField;
      
      public var accuracyBonusTxt:TextField;
      
      public function InfoWin1(param1:*, param2:*, param3:*, param4:*, param5:*, param6:*, param7:*)
      {
         var _loc8_:* = undefined;
         super();
         playAlertSound();
         this.pool = param1;
         arcadeBtn.addEventListener(MouseEvent.CLICK,arcadeAgain);
         backBtn.addEventListener(MouseEvent.CLICK,back);
         timeTxt.text = "" + param2;
         shotsTakenTxt.text = "" + param3;
         accuracyTxt.text = "" + param4 + "%";
         scratchTxt.text = "" + param5;
         scoreTxt.text = "" + param7;
         timeBonusTxt.text = "" + Math.round(param6 * 10);
         accuracyBonusTxt.text = "" + parseInt(param4) * 100;
         _loc8_ = param7 + parseInt(timeBonusTxt.text) + parseInt(accuracyBonusTxt.text);
         grandTxt.text = "" + _loc8_;
      }
      
      public function arcadeAgain(param1:MouseEvent) : void
      {
         pool.restartGame(null);
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
