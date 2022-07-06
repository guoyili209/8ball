package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.media.SoundChannel;
   import flash.text.TextField;
   
   public class InfoBox extends MovieClip
   {
       
      
      public var okTxt:TextField;
      
      private var pAgainCallback:Function;
      
      private var okCallback:Function;
      
      public var pAgainBtn:SimpleButton;
      
      public var clickawayad_mc:MovieClip;
      
      private var myChannel:SoundChannel;
      
      public var awardTxt:TextField;
      
      public var okBtn:SimpleButton;
      
      public function InfoBox(param1:Function, param2:Function)
      {
         super();
         stop();
         okBtn.visible = false;
         okBtn.addEventListener(MouseEvent.CLICK,handleOk);
         pAgainBtn.visible = false;
         pAgainBtn.addEventListener(MouseEvent.CLICK,handlepAgain);
         this.pAgainCallback = param2;
         this.okCallback = param1;
      }
      
      private function handlepAgain(param1:MouseEvent) : *
      {
         var e:MouseEvent = param1;
         try
         {
            MochiAd.unload(clickawayad_mc);
         }
         catch(e:*)
         {
         }
         pAgainCallback(true);
      }
      
      private function handleOk(param1:MouseEvent) : *
      {
         var e:MouseEvent = param1;
         try
         {
            MochiAd.unload(clickawayad_mc);
         }
         catch(e:*)
         {
         }
         okCallback();
      }
      
      public function Show(param1:String, param2:String = "") : *
      {
         var what:String = param1;
         var data:String = param2;
         okBtn.visible = true;
         pAgainBtn.visible = true;
         okTxt.htmlText = what;
         this.gotoAndStop(1);
         this.visible = true;
         playAlertSound();
         try
         {
            MochiAd.showClickAwayAd({
               "clip":clickawayad_mc,
               "id":"ab6122b4a63b00dd"
            });
         }
         catch(e:*)
         {
         }
      }
      
      public function Award(param1:String) : *
      {
         awardTxt.htmlText = param1;
      }
      
      public function Hide() : *
      {
         this.visible = false;
      }
      
      function playAlertSound() : *
      {
         var _loc1_:MyAlertSound = null;
         _loc1_ = new MyAlertSound();
         myChannel = _loc1_.play();
      }
      
      public function Show1(param1:String, param2:String = "") : *
      {
         var what:String = param1;
         var data:String = param2;
         okBtn.visible = true;
         pAgainBtn.visible = false;
         okTxt.htmlText = what;
         this.gotoAndStop(1);
         this.visible = true;
         playAlertSound();
         try
         {
            MochiAd.showClickAwayAd({
               "clip":clickawayad_mc,
               "id":"ab6122b4a63b00dd"
            });
         }
         catch(e:*)
         {
         }
      }
   }
}
