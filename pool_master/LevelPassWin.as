package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.media.SoundChannel;
   import flash.text.TextField;
   
   public class LevelPassWin extends MovieClip
   {
       
      
      public var shotsTakenTxt:TextField;
      
      public var backBtn:SimpleButton;
      
      private var pool:Object;
      
      public var scratchTxt:TextField;
      
      public var levelTotalTxt:TextField;
      
      public var timeTxt:TextField;
      
      public var accuracyTxt:TextField;
      
      public var timeBonusTxt:TextField;
      
      public var contBtn:SimpleButton;
      
      private var myChannel:SoundChannel;
      
      public var scoreTxt:TextField;
      
      public var grandTxt:TextField;
      
      public var accuracyBonusTxt:TextField;
      
      public function LevelPassWin(param1:*)
      {
         super();
         playAlertSound();
         this.pool = param1;
         contBtn.addEventListener(MouseEvent.CLICK,contFunc);
         backBtn.addEventListener(MouseEvent.CLICK,back);
      }
      
      public function contFunc(param1:MouseEvent) : void
      {
         pool.restartGame(null);
      }
      
      function playAlertSound() : *
      {
         var _loc1_:MyAlertSound = null;
         _loc1_ = new MyAlertSound();
         myChannel = _loc1_.play();
      }
      
      function showText(param1:*, param2:*, param3:*, param4:*, param5:*) : *
      {
         var _loc6_:* = undefined;
         timeTxt.text = "" + param1;
         shotsTakenTxt.text = "" + param2;
         accuracyTxt.text = "" + param3 + "%";
         scratchTxt.text = "" + param4;
         scoreTxt.text = "" + (15 * 300 - param4 * 1000);
         timeBonusTxt.text = "" + (5000 - parseInt(param5) * 10);
         accuracyBonusTxt.text = "" + param3 * 100;
         _loc6_ = parseInt(scoreTxt.text) + parseInt(timeBonusTxt.text) + parseInt(accuracyBonusTxt.text);
         levelTotalTxt.text = "" + _loc6_;
         pool.poolMain.challengeScore += _loc6_;
         grandTxt.text = "" + pool.poolMain.challengeScore;
      }
      
      public function back(param1:MouseEvent) : void
      {
         pool.backToMenu(null);
      }
   }
}
