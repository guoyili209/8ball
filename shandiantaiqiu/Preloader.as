package
{
   import CPMStar.AdLoader;
   import com.SuperGlobals;
   import com.google.analytics.GATracker;
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
   import mochi.as3.MochiServices;
   
   public class Preloader extends MovieClip
   {
       
      
      var preloadingScreen:MovieClip;
      
      var counter:uint = 0;
      
      var counterMax:uint = 100;
      
      var bytesloaded:uint = 0;
      
      var bytestotal:uint = 0;
      
      var finished:Boolean = false;
      
      var ad:DisplayObject;
      
      var hideAds:Boolean = false;
      
      public function Preloader()
      {
         var filteredURL:* = undefined;
         var CPMStarContentSpotID:String = null;
         super();
         if(stage)
         {
            this.initAPIs();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.initAPIs);
         }
         if(stage)
         {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
         }
         addEventListener(Event.ENTER_FRAME,this.checkFrame);
         loaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioError);
         var thisURL:String = stage.loaderInfo.url;
         var filterList:Array = new Array();
         filterList.push("kongregate.com");
         filterList.push("zayplay.com");
         for(var n:uint = 0; n < filterList.length; n++)
         {
            filteredURL = filterList[n];
            if(thisURL.indexOf(filteredURL,0) != -1)
            {
               this.hideAds = true;
            }
         }
         if(this.hideAds == false)
         {
            this.preloadingScreen = new preloadingScreen2_mc();
            stage.addChild(this.preloadingScreen);
            CPMStarContentSpotID = "7586Q465F16C2";
            this.ad = new AdLoader(CPMStarContentSpotID);
            this.preloadingScreen.adBox.addChild(this.ad);
         }
         else
         {
            this.preloadingScreen = new preloadingScreen_mc();
            stage.addChild(this.preloadingScreen);
         }
         this.preloadingScreen.preloader.loadingBar.width = 0;
         this.preloadingScreen.preloader.loadingText.text = "LOADING: 0%";
         this.preloadingScreen.sponsorLogo.addEventListener(MouseEvent.CLICK,this.gotoSponsor);
         this.preloadingScreen._MORE_GAMES_.addEventListener(MouseEvent.CLICK,this.gotoSponsor);
         this.preloadingScreen._CONTINUE_.visible = false;
      }
      
      private function initAPIs(e:Event = null) : void
      {
         SuperGlobals.tracker = new GATracker(this,"UA-33261911-1","AS3",true);
         SuperGlobals.tracker.trackPageview("PoolSkool_view");
         SuperGlobals.tracker.trackEvent("Events","hosted",stage.loaderInfo.url);
         MochiServices.connect("1f8075640fcf77a2",stage);
         MochiBot.track(this,"51af15b0");
      }
      
      private function gotoSponsor(e:MouseEvent) : void
      {
         SuperGlobals.tracker.trackEvent("Events","clicked sponsor link");
         var thisURL:String = stage.loaderInfo.url;
         var url:URLRequest = new URLRequest("http://www.zayplay.com?utm_source=" + thisURL + "&utm_medium=flashgame&utm_campaign=Billard-Blitz-Pool-Skool");
         navigateToURL(url,"_blank");
      }
      
      private function ioError(e:IOErrorEvent) : void
      {
         trace(e.text);
      }
      
      private function checkFrame(e:Event) : void
      {
         if(this.counter < this.counterMax)
         {
            ++this.counter;
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
         if(this.bytesloaded >= this.bytestotal && this.finished == false && this.counter >= this.counterMax)
         {
            this.preloadingScreen.preloader.loadingText.text = "LOADING: 100%";
            this.finished = true;
            stop();
            this.loadingFinished();
         }
      }
      
      private function loadingFinished() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.checkFrame);
         loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.ioError);
         this.preloadingScreen.preloader.visible = false;
         this.preloadingScreen._CONTINUE_.visible = true;
         this.preloadingScreen._CONTINUE_.addEventListener(MouseEvent.MOUSE_DOWN,this.removeAd);
      }
      
      private function removeAd(e:MouseEvent) : void
      {
         if(this.hideAds == false)
         {
            this.preloadingScreen.adBox.removeChild(this.ad);
         }
         this.preloadingScreen._CONTINUE_.removeEventListener(MouseEvent.MOUSE_DOWN,this.removeAd);
         this.preloadingScreen._CONTINUE_.visible = false;
         stage.removeChild(this.preloadingScreen);
         this.preloadingScreen = null;
         this.startup();
      }
      
      private function startup() : void
      {
         var mainClass:Class = getDefinitionByName("Main") as Class;
         addChild(new mainClass() as DisplayObject);
      }
   }
}
