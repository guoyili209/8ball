package com.google.analytics.components
{
   import com.google.analytics.API;
   import com.google.analytics.AnalyticsTracker;
   import com.google.analytics.core.Buffer;
   import com.google.analytics.core.EventTracker;
   import com.google.analytics.core.GIFRequest;
   import com.google.analytics.core.IdleTimer;
   import com.google.analytics.core.ServerOperationMode;
   import com.google.analytics.core.TrackerCache;
   import com.google.analytics.core.TrackerMode;
   import com.google.analytics.debug.DebugConfiguration;
   import com.google.analytics.debug.Layout;
   import com.google.analytics.events.AnalyticsEvent;
   import com.google.analytics.external.AdSenseGlobals;
   import com.google.analytics.external.HTMLDOM;
   import com.google.analytics.external.JavascriptProxy;
   import com.google.analytics.utils.Environment;
   import com.google.analytics.utils.Version;
   import com.google.analytics.v4.Bridge;
   import com.google.analytics.v4.Configuration;
   import com.google.analytics.v4.GoogleAnalyticsAPI;
   import com.google.analytics.v4.Tracker;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   [IconFile("analytics.png")]
   [Event(name="ready",type="com.google.analytics.events.AnalyticsEvent")]
   public class FlashTracker extends Sprite implements AnalyticsTracker
   {
      
      public static var version:Version = API.version;
       
      
      private var _adSense:AdSenseGlobals;
      
      private var _env:Environment;
      
      private var _visualDebug:Boolean = false;
      
      protected var _height:Number = 18;
      
      public var boundingBox_mc:DisplayObject;
      
      private var _idleTimer:IdleTimer;
      
      private var _debug:DebugConfiguration;
      
      private var _buffer:Buffer;
      
      private var _config:Configuration;
      
      private var _mode:String = "AS3";
      
      private var _display:DisplayObject;
      
      private var _jsproxy:JavascriptProxy;
      
      private var _dom:HTMLDOM;
      
      protected var livePreviewHeight:Number;
      
      private var _ready:Boolean = false;
      
      protected var isLivePreview:Boolean;
      
      protected var _width:Number = 18;
      
      protected var preview:MovieClip;
      
      private var _gifRequest:GIFRequest;
      
      protected var livePreviewWidth:Number;
      
      private var _account:String = "";
      
      private var _tracker:GoogleAnalyticsAPI;
      
      protected var _componentInspectorSetting:Boolean;
      
      public function FlashTracker()
      {
         super();
         _tracker = new TrackerCache();
         isLivePreview = _checkLivePreview();
         _componentInspectorSetting = false;
         if(boundingBox_mc)
         {
            boundingBox_mc.visible = false;
            removeChild(boundingBox_mc);
            boundingBox_mc = null;
         }
         if(isLivePreview)
         {
            _createLivePreview();
         }
         addEventListener(Event.ENTER_FRAME,_factory);
      }
      
      public function link(targetUrl:String, useHash:Boolean = false) : void
      {
         _tracker.link(targetUrl,useHash);
      }
      
      public function addOrganic(param1:String, param2:String) : void
      {
         _tracker.addOrganic(param1,param2);
      }
      
      public function setAllowLinker(enable:Boolean) : void
      {
         _tracker.setAllowLinker(enable);
      }
      
      public function getAccount() : String
      {
         return _tracker.getAccount();
      }
      
      public function trackEvent(param1:String, param2:String, param3:String = null, param4:Number = NaN) : Boolean
      {
         return _tracker.trackEvent(param1,param2,param3,param4);
      }
      
      public function setCookieTimeout(newDefaultTimeout:int) : void
      {
         _tracker.setCookieTimeout(newDefaultTimeout);
      }
      
      public function trackPageview(pageURL:String = "") : void
      {
         _tracker.trackPageview(pageURL);
      }
      
      private function _createLivePreview() : void
      {
         preview = new MovieClip();
         var g:Graphics = preview.graphics;
         g.beginFill(16777215);
         g.moveTo(0,0);
         g.lineTo(0,_width);
         g.lineTo(_width,_height);
         g.lineTo(_height,0);
         g.lineTo(0,0);
         g.endFill();
         var iconClass:Class = getDefinitionByName("com.google.analytics.components::Icon") as Class;
         preview.icon_mc = new iconClass();
         preview.icon_mc.name = "icon_mc";
         preview.addChild(preview.icon_mc);
         addChild(preview);
      }
      
      public function trackTrans() : void
      {
         _tracker.trackTrans();
      }
      
      public function getClientInfo() : Boolean
      {
         return _tracker.getClientInfo();
      }
      
      public function setClientInfo(param1:Boolean) : void
      {
         _tracker.setClientInfo(param1);
      }
      
      [Inspectable]
      public function get account() : String
      {
         return _account;
      }
      
      public function linkByPost(formObject:Object, useHash:Boolean = false) : void
      {
         _tracker.linkByPost(formObject,useHash);
      }
      
      public function getDetectTitle() : Boolean
      {
         return _tracker.getDetectTitle();
      }
      
      private function _bridgeFactory() : GoogleAnalyticsAPI
      {
         debug.info("GATracker (Bridge) v" + version + "\naccount: " + account);
         return new Bridge(account,_debug,_jsproxy);
      }
      
      public function resetSession() : void
      {
         _tracker.resetSession();
      }
      
      public function get config() : Configuration
      {
         if(!_config)
         {
            _createDebugAndConfig();
         }
         return _config;
      }
      
      public function setDetectFlash(param1:Boolean) : void
      {
         _tracker.setDetectFlash(param1);
      }
      
      public function set mode(value:String) : void
      {
         _mode = value;
      }
      
      public function setCampNameKey(newCampNameKey:String) : void
      {
         _tracker.setCampNameKey(newCampNameKey);
      }
      
      public function get debug() : DebugConfiguration
      {
         if(!_debug)
         {
            _createDebugAndConfig();
         }
         return _debug;
      }
      
      public function set account(value:String) : void
      {
         _account = value;
      }
      
      public function addItem(item:String, sku:String, name:String, category:String, price:Number, quantity:int) : void
      {
         _tracker.addItem(item,sku,name,category,price,quantity);
      }
      
      public function setVar(newVal:String) : void
      {
         _tracker.setVar(newVal);
      }
      
      public function clearIgnoredOrganic() : void
      {
         _tracker.clearIgnoredOrganic();
      }
      
      public function setDomainName(newDomainName:String) : void
      {
         _tracker.setDomainName(newDomainName);
      }
      
      public function createEventTracker(param1:String) : EventTracker
      {
         return _tracker.createEventTracker(param1);
      }
      
      private function _checkLivePreview() : Boolean
      {
         if(parent != null && getQualifiedClassName(parent) == "fl.livepreview::LivePreviewParent")
         {
            return true;
         }
         return false;
      }
      
      public function setCampSourceKey(newCampSrcKey:String) : void
      {
         _tracker.setCampSourceKey(newCampSrcKey);
      }
      
      public function set config(value:Configuration) : void
      {
         _config = value;
      }
      
      public function addTrans(orderId:String, affiliation:String, total:Number, tax:Number, shipping:Number, city:String, state:String, country:String) : Object
      {
         return _tracker.addTrans(orderId,affiliation,total,tax,shipping,city,state,country);
      }
      
      public function setCampContentKey(newCampContentKey:String) : void
      {
         _tracker.setCampContentKey(newCampContentKey);
      }
      
      public function setLocalServerMode() : void
      {
         _tracker.setLocalServerMode();
      }
      
      public function clearIgnoredRef() : void
      {
         _tracker.clearIgnoredRef();
      }
      
      public function setRemoteServerMode() : void
      {
         _tracker.setRemoteServerMode();
      }
      
      public function isReady() : Boolean
      {
         return _ready;
      }
      
      public function setSize(w:Number, h:Number) : void
      {
      }
      
      public function getVersion() : String
      {
         return _tracker.getVersion();
      }
      
      [Inspectable(defaultValue="AS3",enumeration="AS3,Bridge",type="String")]
      public function get mode() : String
      {
         return _mode;
      }
      
      public function set debug(value:DebugConfiguration) : void
      {
         _debug = value;
      }
      
      public function setLocalGifPath(param1:String) : void
      {
         _tracker.setLocalGifPath(param1);
      }
      
      public function setSampleRate(newRate:Number) : void
      {
         _tracker.setSampleRate(newRate);
      }
      
      public function setAllowHash(enable:Boolean) : void
      {
         _tracker.setAllowHash(enable);
      }
      
      public function getLocalGifPath() : String
      {
         return _tracker.getLocalGifPath();
      }
      
      public function setCookiePath(newCookiePath:String) : void
      {
         _tracker.setCookiePath(newCookiePath);
      }
      
      public function addIgnoredOrganic(param1:String) : void
      {
         _tracker.addIgnoredOrganic(param1);
      }
      
      public function setLocalRemoteServerMode() : void
      {
         _tracker.setLocalRemoteServerMode();
      }
      
      public function cookiePathCopy(newPath:String) : void
      {
         _tracker.cookiePathCopy(newPath);
      }
      
      public function setAllowAnchor(enable:Boolean) : void
      {
         _tracker.setAllowAnchor(enable);
      }
      
      private function _factory(event:Event) : void
      {
         var activeTracker:GoogleAnalyticsAPI = null;
         removeEventListener(Event.ENTER_FRAME,_factory);
         if(isLivePreview)
         {
            return;
         }
         _display = this;
         _createDebugAndConfig();
         if(visualDebug)
         {
            debug.layout = new Layout(debug,_display);
            debug.active = visualDebug;
         }
         _jsproxy = new JavascriptProxy(debug);
         var cache:TrackerCache = _tracker as TrackerCache;
         switch(mode)
         {
            case TrackerMode.BRIDGE:
               activeTracker = _bridgeFactory();
               break;
            case TrackerMode.AS3:
            default:
               activeTracker = _trackerFactory();
         }
         if(!cache.isEmpty())
         {
            cache.tracker = activeTracker;
            cache.flush();
         }
         _tracker = activeTracker;
         _ready = true;
         dispatchEvent(new AnalyticsEvent(AnalyticsEvent.READY,this));
      }
      
      public function setCampTermKey(newCampTermKey:String) : void
      {
         _tracker.setCampTermKey(newCampTermKey);
      }
      
      private function _trackerFactory() : GoogleAnalyticsAPI
      {
         debug.info("GATracker (AS3) v" + version + "\naccount: " + account);
         _adSense = new AdSenseGlobals(debug);
         _dom = new HTMLDOM(debug);
         _dom.cacheProperties();
         _env = new Environment("","","",debug,_dom);
         _buffer = new Buffer(config,debug,false);
         _gifRequest = new GIFRequest(config,debug,_buffer,_env);
         _idleTimer = new IdleTimer(config,debug,_display,_buffer);
         _env.url = _display.stage.loaderInfo.url;
         return new Tracker(account,config,debug,_env,_buffer,_gifRequest,_adSense);
      }
      
      public function setCampNOKey(newCampNOKey:String) : void
      {
         _tracker.setCampNOKey(newCampNOKey);
      }
      
      public function setDetectTitle(param1:Boolean) : void
      {
         _tracker.setDetectTitle(param1);
      }
      
      public function setCampaignTrack(enable:Boolean) : void
      {
         _tracker.setCampaignTrack(enable);
      }
      
      public function clearOrganic() : void
      {
         _tracker.clearOrganic();
      }
      
      private function _createDebugAndConfig() : void
      {
         if(!_debug)
         {
            this.debug = new DebugConfiguration();
         }
         if(!_config)
         {
            this.config = new Configuration(debug);
         }
      }
      
      public function addIgnoredRef(param1:String) : void
      {
         _tracker.addIgnoredRef(param1);
      }
      
      public function getServiceMode() : ServerOperationMode
      {
         return _tracker.getServiceMode();
      }
      
      public function set visualDebug(value:Boolean) : void
      {
         _visualDebug = value;
      }
      
      public function setCampMediumKey(newCampMedKey:String) : void
      {
         _tracker.setCampMediumKey(newCampMedKey);
      }
      
      public function set componentInspectorSetting(value:Boolean) : void
      {
         _componentInspectorSetting = value;
      }
      
      public function getDetectFlash() : Boolean
      {
         return _tracker.getDetectFlash();
      }
      
      [Inspectable(defaultValue="false",type="Boolean")]
      public function get visualDebug() : Boolean
      {
         return _visualDebug;
      }
      
      public function setSessionTimeout(newTimeout:int) : void
      {
         _tracker.setSessionTimeout(newTimeout);
      }
   }
}
