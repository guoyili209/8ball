package
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.getDefinitionByName;

   [SWF(width="800", height="600", backgroundColor="#000000", frameRate="30")]
   public class Preloader extends MovieClip
   {

      var preloadingScreen:MovieClip;

      var counter:uint = 0;

      var counterMax:uint = 100;

      var bytesloaded:uint = 0;

      var bytestotal:uint = 0;

      var finished:Boolean = false;

      var hideAds:Boolean = false;

      public function Preloader()
      {

         super();
         if (stage)
         {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
         }
         addEventListener(Event.ENTER_FRAME, this.checkFrame);
         loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioError);

         if (this.hideAds == false)
         {
            this.preloadingScreen = new preloadingScreen2_mc();
            stage.addChild(this.preloadingScreen);
         }
         else
         {
            this.preloadingScreen = new preloadingScreen_mc();
            stage.addChild(this.preloadingScreen);
         }
         this.preloadingScreen.preloader.loadingBar.width = 0;
         this.preloadingScreen.preloader.loadingText.text = "LOADING: 0%";

         this.preloadingScreen._CONTINUE_.visible = false;
      }

      private function ioError(e:IOErrorEvent):void
      {
         trace(e.text);
      }

      private function checkFrame(e:Event):void
      {
         if (this.counter < this.counterMax)
         {
            ++ this.counter;
         }
         else
         {
            this.counter = this.counterMax;
         }
         var counterPercentage:Number = 100 * this.counter / this.counterMax;
         this.bytestotal = stage.loaderInfo.bytesTotal;
         this.bytesloaded = stage.loaderInfo.bytesLoaded;
         var percentage:* = Math.round(this.bytesloaded * 100 / this.bytestotal);
         this.preloadingScreen.preloader.loadingBar.width = 2 * (percentage + counterPercentage);
         this.preloadingScreen.preloader.loadingText.text = "LOADING: " + String(Math.round((percentage + counterPercentage) / 2)) + "%";
         if (this.bytesloaded >= this.bytestotal && this.finished == false && this.counter >= this.counterMax)
         {
            this.preloadingScreen.preloader.loadingText.text = "LOADING: 100%";
            this.finished = true;
            stop();
            this.loadingFinished();
         }
      }

      private function loadingFinished():void
      {
         removeEventListener(Event.ENTER_FRAME, this.checkFrame);
         loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.ioError);
         this.preloadingScreen.preloader.visible = false;
         this.preloadingScreen._CONTINUE_.visible = true;
         this.preloadingScreen._CONTINUE_.addEventListener(MouseEvent.MOUSE_DOWN, this.removeAd);
      }

      private function removeAd(e:MouseEvent):void
      {
         this.preloadingScreen._CONTINUE_.removeEventListener(MouseEvent.MOUSE_DOWN, this.removeAd);
         this.preloadingScreen._CONTINUE_.visible = false;
         stage.removeChild(this.preloadingScreen);
         this.preloadingScreen = null;
         this.startup();
      }

      private function startup():void
      {
         // var mainClass:Class = getDefinitionByName("Main") as Class;
         addChild(new Main());
      }
   }
}


