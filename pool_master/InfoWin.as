package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.media.SoundChannel;
   import flash.text.TextField;
   
   public class InfoWin extends MovieClip
   {
       
      
      public var shotsTakenTxt:TextField;
      
      public var backBtn:SimpleButton;
      
      private var pool:Object;
      
      public var scratchTxt:TextField;
      
      public var practiceBtn:SimpleButton;
      
      public var timeTxt:TextField;
      
      public var accuracyTxt:TextField;
      
      public var timeBonusTxt:TextField;
      
      private var myChannel:SoundChannel;
      
      public var scoreTxt:TextField;
      
      public var grandTxt:TextField;
      
      public var accuracyBonusTxt:TextField;
      
      public function InfoWin(param1:*, param2:*, param3:*, param4:*, param5:*, param6:*)
      {
         super();
         playAlertSound();
         this.pool = param1;
         practiceBtn.addEventListener(MouseEvent.CLICK,practiceAgain);
         backBtn.addEventListener(MouseEvent.CLICK,back);
         timeTxt.text = "" + param2;
         shotsTakenTxt.text = "" + param3;
         accuracyTxt.text = "" + param4 + "%";
         scratchTxt.text = "" + param5;
         scoreTxt.text = "" + (15 * 300 - parseInt(param5) * 1000);
         timeBonusTxt.text = "" + (5000 - parseInt(param6) * 10);
         accuracyBonusTxt.text = "" + parseInt(param4) * 100;
         grandTxt.text = "" + (parseInt(scoreTxt.text) + parseInt(timeBonusTxt.text) + parseInt(accuracyBonusTxt.text));
      }
      
      function playAlertSound() : *
      {
         var _loc1_:MyAlertSound = null;
         _loc1_ = new MyAlertSound();
         myChannel = _loc1_.play();
      }
      
      public function practiceAgain(param1:MouseEvent) : void
      {
         pool.restartGame(null);
      }
      
      public function back(param1:MouseEvent) : void
      {
         pool.backToMenu(null);
      }
   }
}
