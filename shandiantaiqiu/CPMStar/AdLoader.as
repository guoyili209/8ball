package CPMStar
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.system.Security;
   
   public class AdLoader extends Sprite
   {
       
      
      private var cpmstarLoader:Loader;
      
      private var contentspotid:String;
      
      public function AdLoader(contentspotid:String)
      {
         super();
         this.contentspotid = contentspotid;
         addEventListener(Event.ADDED,this.addedHandler);
      }
      
      private function addedHandler(event:Event) : void
      {
         removeEventListener(Event.ADDED,this.addedHandler);
         Security.allowDomain("server.cpmstar.com");
         var cpmstarViewSWFUrl:String = "http://server.cpmstar.com/adviewas3.swf";
         var container:DisplayObjectContainer = parent;
         this.cpmstarLoader = new Loader();
         this.cpmstarLoader.contentLoaderInfo.addEventListener(Event.INIT,this.dispatchHandler);
         this.cpmstarLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.dispatchHandler);
         this.cpmstarLoader.load(new URLRequest(cpmstarViewSWFUrl + "?contentspotid=" + this.contentspotid));
         addChild(this.cpmstarLoader);
      }
      
      private function dispatchHandler(event:Event) : void
      {
         dispatchEvent(event);
      }
   }
}
