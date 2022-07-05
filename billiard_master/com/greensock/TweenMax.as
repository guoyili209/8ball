package com.greensock
{
   import com.greensock.core.PropTween;
   import com.greensock.core.SimpleTimeline;
   import com.greensock.core.TweenCore;
   import com.greensock.events.TweenEvent;
   import com.greensock.plugins.AutoAlphaPlugin;
   import com.greensock.plugins.BevelFilterPlugin;
   import com.greensock.plugins.BezierPlugin;
   import com.greensock.plugins.BezierThroughPlugin;
   import com.greensock.plugins.BlurFilterPlugin;
   import com.greensock.plugins.ColorMatrixFilterPlugin;
   import com.greensock.plugins.ColorTransformPlugin;
   import com.greensock.plugins.DropShadowFilterPlugin;
   import com.greensock.plugins.EndArrayPlugin;
   import com.greensock.plugins.FrameLabelPlugin;
   import com.greensock.plugins.FramePlugin;
   import com.greensock.plugins.GlowFilterPlugin;
   import com.greensock.plugins.HexColorsPlugin;
   import com.greensock.plugins.RemoveTintPlugin;
   import com.greensock.plugins.RoundPropsPlugin;
   import com.greensock.plugins.ShortRotationPlugin;
   import com.greensock.plugins.TintPlugin;
   import com.greensock.plugins.TweenPlugin;
   import com.greensock.plugins.VisiblePlugin;
   import com.greensock.plugins.VolumePlugin;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   public class TweenMax extends TweenLite implements IEventDispatcher
   {
      
      private static var _overwriteMode:int = !!OverwriteManager.enabled ? int(OverwriteManager.mode) : int(OverwriteManager.init(2));
      
      public static const version:Number = 11.14;
      
      public static var killTweensOf:Function = TweenLite.killTweensOf;
      
      public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
      
      {
         TweenPlugin.activate([AutoAlphaPlugin,EndArrayPlugin,FramePlugin,RemoveTintPlugin,TintPlugin,VisiblePlugin,VolumePlugin,BevelFilterPlugin,BezierPlugin,BezierThroughPlugin,BlurFilterPlugin,ColorMatrixFilterPlugin,ColorTransformPlugin,DropShadowFilterPlugin,FrameLabelPlugin,GlowFilterPlugin,HexColorsPlugin,RoundPropsPlugin,ShortRotationPlugin,{}]);
      }
      
      protected var _cyclesComplete:uint = 0;
      
      protected var _dispatcher:EventDispatcher;
      
      protected var _hasUpdateListener:Boolean;
      
      protected var _easeType:uint;
      
      protected var _repeatDelay:Number = 0;
      
      public var yoyo:Boolean;
      
      protected var _easePower:uint;
      
      protected var _repeat:int = 0;
      
      public function TweenMax(target:Object, duration:Number, vars:Object)
      {
         super(target,duration,vars);
         if(TweenLite.version < 11.1)
         {
            throw new Error("TweenMax error! Please update your TweenLite class or try deleting your ASO files. TweenMax requires a more recent version. Download updates at http://www.TweenMax.com.");
         }
         this.yoyo = Boolean(this.vars.yoyo);
         _repeat = int(this.vars.repeat) || 0;
         _repeatDelay = Number(this.vars.repeatDelay) || Number(0);
         this.cacheIsDirty = true;
         if(this.vars.onCompleteListener || this.vars.onUpdateListener || this.vars.onStartListener || this.vars.onRepeatListener || this.vars.onReverseCompleteListener)
         {
            initDispatcher();
            if(duration == 0 && _delay == 0)
            {
               _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
               _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
            }
         }
         if("timeScale" in this.vars && !(this.target is TweenCore))
         {
            this.cachedTimeScale = this.vars.timeScale;
         }
      }
      
      public static function set globalTimeScale(n:Number) : void
      {
         if(n == 0)
         {
            n = 0.0001;
         }
         if(TweenLite.rootTimeline == null)
         {
            TweenLite.to({},0,{});
         }
         var tl:SimpleTimeline = TweenLite.rootTimeline;
         var curTime:Number = getTimer() * 0.001;
         tl.cachedStartTime = curTime - (curTime - tl.cachedStartTime) * tl.cachedTimeScale / n;
         tl = TweenLite.rootFramesTimeline;
         curTime = TweenLite.rootFrame;
         tl.cachedStartTime = curTime - (curTime - tl.cachedStartTime) * tl.cachedTimeScale / n;
         TweenLite.rootFramesTimeline.cachedTimeScale = TweenLite.rootTimeline.cachedTimeScale = n;
      }
      
      public static function fromTo(target:Object, duration:Number, fromVars:Object, toVars:Object) : TweenMax
      {
         toVars.startAt = fromVars;
         if(fromVars.immediateRender)
         {
            toVars.immediateRender = true;
         }
         return new TweenMax(target,duration,toVars);
      }
      
      public static function allFromTo(targets:Array, duration:Number, fromVars:Object, toVars:Object, stagger:Number = 0, onCompleteAll:Function = null, onCompleteAllParams:Array = null) : Array
      {
         toVars.startAt = fromVars;
         if(fromVars.immediateRender)
         {
            toVars.immediateRender = true;
         }
         return allTo(targets,duration,toVars,stagger,onCompleteAll,onCompleteAllParams);
      }
      
      public static function pauseAll(tweens:Boolean = true, delayedCalls:Boolean = true) : void
      {
         changePause(true,tweens,delayedCalls);
      }
      
      public static function getTweensOf(target:Object) : Array
      {
         var i:int = 0;
         var cnt:uint = 0;
         var a:Array = masterList[target];
         var toReturn:Array = [];
         if(a)
         {
            i = a.length;
            cnt = 0;
            while(i--)
            {
               if(!a[i].gc)
               {
                  var _loc6_:*;
                  toReturn[_loc6_ = cnt++] = a[i];
               }
            }
         }
         return toReturn;
      }
      
      public static function get globalTimeScale() : Number
      {
         return TweenLite.rootTimeline == null ? Number(1) : Number(TweenLite.rootTimeline.cachedTimeScale);
      }
      
      public static function killChildTweensOf(parent:DisplayObjectContainer, complete:Boolean = false) : void
      {
         var curTarget:Object = null;
         var curParent:DisplayObjectContainer = null;
         var a:Array = getAllTweens();
         var i:int = a.length;
         while(i--)
         {
            curTarget = a[i].target;
            if(curTarget is DisplayObject)
            {
               curParent = curTarget.parent;
               while(curParent)
               {
                  if(curParent == parent)
                  {
                     if(complete)
                     {
                        a[i].complete(false);
                     }
                     else
                     {
                        a[i].setEnabled(false,false);
                     }
                  }
                  curParent = curParent.parent;
               }
            }
         }
      }
      
      public static function delayedCall(delay:Number, onComplete:Function, onCompleteParams:Array = null, useFrames:Boolean = false) : TweenMax
      {
         return new TweenMax(onComplete,0,{
            "delay":delay,
            "onComplete":onComplete,
            "onCompleteParams":onCompleteParams,
            "immediateRender":false,
            "useFrames":useFrames,
            "overwrite":0
         });
      }
      
      public static function isTweening(target:Object) : Boolean
      {
         var tween:TweenLite = null;
         var a:Array = getTweensOf(target);
         var i:int = a.length;
         while(i--)
         {
            tween = a[i];
            if(tween.active || tween.cachedStartTime == tween.timeline.cachedTime && tween.timeline.active)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function killAll(complete:Boolean = false, tweens:Boolean = true, delayedCalls:Boolean = true) : void
      {
         var isDC:* = false;
         var a:Array = getAllTweens();
         var i:int = a.length;
         while(i--)
         {
            isDC = a[i].target == a[i].vars.onComplete;
            if(isDC == delayedCalls || isDC != tweens)
            {
               if(complete)
               {
                  a[i].complete(false);
               }
               else
               {
                  a[i].setEnabled(false,false);
               }
            }
         }
      }
      
      private static function changePause(pause:Boolean, tweens:Boolean = true, delayedCalls:Boolean = false) : void
      {
         var isDC:* = false;
         var a:Array = getAllTweens();
         var i:int = a.length;
         while(i--)
         {
            isDC = TweenLite(a[i]).target == TweenLite(a[i]).vars.onComplete;
            if(isDC == delayedCalls || isDC != tweens)
            {
               TweenCore(a[i]).paused = pause;
            }
         }
      }
      
      public static function from(target:Object, duration:Number, vars:Object) : TweenMax
      {
         vars.runBackwards = true;
         if(!("immediateRender" in vars))
         {
            vars.immediateRender = true;
         }
         return new TweenMax(target,duration,vars);
      }
      
      public static function allFrom(targets:Array, duration:Number, vars:Object, stagger:Number = 0, onCompleteAll:Function = null, onCompleteAllParams:Array = null) : Array
      {
         vars.runBackwards = true;
         if(!("immediateRender" in vars))
         {
            vars.immediateRender = true;
         }
         return allTo(targets,duration,vars,stagger,onCompleteAll,onCompleteAllParams);
      }
      
      public static function getAllTweens() : Array
      {
         var a:Array = null;
         var i:int = 0;
         var ml:Dictionary = masterList;
         var cnt:uint = 0;
         var toReturn:Array = [];
         for each(a in ml)
         {
            i = a.length;
            while(i--)
            {
               if(!TweenLite(a[i]).gc)
               {
                  var _loc8_:*;
                  toReturn[_loc8_ = cnt++] = a[i];
               }
            }
         }
         return toReturn;
      }
      
      public static function resumeAll(tweens:Boolean = true, delayedCalls:Boolean = true) : void
      {
         changePause(false,tweens,delayedCalls);
      }
      
      public static function to(target:Object, duration:Number, vars:Object) : TweenMax
      {
         return new TweenMax(target,duration,vars);
      }
      
      public static function allTo(targets:Array, duration:Number, vars:Object, stagger:Number = 0, onCompleteAll:Function = null, onCompleteAllParams:Array = null) : Array
      {
         var i:int = 0;
         var varsDup:Object = null;
         var p:String = null;
         var onCompleteProxy:Function = null;
         var onCompleteParamsProxy:Array = null;
         var l:uint = targets.length;
         var a:Array = [];
         var curDelay:Number = Number(vars.delay) || Number(0);
         onCompleteProxy = vars.onComplete;
         onCompleteParamsProxy = vars.onCompleteParams;
         var lastIndex:int = stagger <= 0 ? 0 : int(l - 1);
         for(i = 0; i < l; i++)
         {
            varsDup = {};
            for(p in vars)
            {
               varsDup[p] = vars[p];
            }
            varsDup.delay = curDelay;
            if(i == lastIndex && onCompleteAll != null)
            {
               varsDup.onComplete = function():void
               {
                  if(onCompleteProxy != null)
                  {
                     onCompleteProxy.apply(null,onCompleteParamsProxy);
                  }
                  onCompleteAll.apply(null,onCompleteAllParams);
               };
            }
            a[a.length] = new TweenMax(targets[i],duration,varsDup);
            curDelay += stagger;
         }
         return a;
      }
      
      public function dispatchEvent(e:Event) : Boolean
      {
         return _dispatcher == null ? false : Boolean(_dispatcher.dispatchEvent(e));
      }
      
      public function set timeScale(n:Number) : void
      {
         if(n == 0)
         {
            n = 0.0001;
         }
         var tlTime:Number = _pauseTime || _pauseTime == 0 ? Number(_pauseTime) : Number(this.timeline.cachedTotalTime);
         this.cachedStartTime = tlTime - (tlTime - this.cachedStartTime) * this.cachedTimeScale / n;
         this.cachedTimeScale = n;
         setDirtyCache(false);
      }
      
      override public function renderTime(time:Number, suppressEvents:Boolean = false, force:Boolean = false) : void
      {
         var isComplete:Boolean = false;
         var repeated:Boolean = false;
         var setRatio:Boolean = false;
         var cycleDuration:Number = NaN;
         var power:uint = 0;
         var val:Number = NaN;
         var totalDur:Number = !!this.cacheIsDirty ? Number(this.totalDuration) : Number(this.cachedTotalDuration);
         var prevTime:Number = this.cachedTime;
         if(time >= totalDur)
         {
            this.cachedTotalTime = totalDur;
            this.cachedTime = this.cachedDuration;
            this.ratio = 1;
            isComplete = true;
            if(this.cachedDuration == 0)
            {
               if((time == 0 || _rawPrevTime < 0) && _rawPrevTime != time)
               {
                  force = true;
               }
               _rawPrevTime = time;
            }
         }
         else if(time <= 0)
         {
            if(time < 0)
            {
               this.active = false;
               if(this.cachedDuration == 0)
               {
                  if(_rawPrevTime > 0)
                  {
                     force = true;
                     isComplete = true;
                  }
                  _rawPrevTime = time;
               }
            }
            this.cachedTotalTime = this.cachedTime = this.ratio = 0;
            if(this.cachedReversed && prevTime != 0)
            {
               isComplete = true;
            }
         }
         else
         {
            this.cachedTotalTime = this.cachedTime = time;
            setRatio = true;
         }
         if(_repeat != 0)
         {
            cycleDuration = this.cachedDuration + _repeatDelay;
            if(isComplete)
            {
               if(this.yoyo && _repeat % 2)
               {
                  this.cachedTime = this.ratio = 0;
               }
            }
            else if(time > 0)
            {
               if(_cyclesComplete != (_cyclesComplete = int(this.cachedTotalTime / cycleDuration)))
               {
                  repeated = true;
               }
               this.cachedTime = (this.cachedTotalTime / cycleDuration - _cyclesComplete) * cycleDuration;
               if(this.yoyo && _cyclesComplete % 2)
               {
                  this.cachedTime = this.cachedDuration - this.cachedTime;
               }
               else if(this.cachedTime >= this.cachedDuration)
               {
                  this.cachedTime = this.cachedDuration;
                  this.ratio = 1;
                  setRatio = false;
               }
               if(this.cachedTime <= 0)
               {
                  this.cachedTime = this.ratio = 0;
                  setRatio = false;
               }
            }
         }
         if(prevTime == this.cachedTime && !force)
         {
            return;
         }
         if(!this.initted)
         {
            init();
         }
         if(!this.active && !this.cachedPaused)
         {
            this.active = true;
         }
         if(setRatio)
         {
            if(_easeType)
            {
               power = _easePower;
               val = this.cachedTime / this.cachedDuration;
               if(_easeType == 2)
               {
                  this.ratio = val = 1 - val;
                  while(power--)
                  {
                     this.ratio = val * this.ratio;
                  }
                  this.ratio = 1 - this.ratio;
               }
               else if(_easeType == 1)
               {
                  this.ratio = val;
                  while(power--)
                  {
                     this.ratio = val * this.ratio;
                  }
               }
               else if(val < 0.5)
               {
                  this.ratio = val = val * 2;
                  while(power--)
                  {
                     this.ratio = val * this.ratio;
                  }
                  this.ratio *= 0.5;
               }
               else
               {
                  this.ratio = val = (1 - val) * 2;
                  while(power--)
                  {
                     this.ratio = val * this.ratio;
                  }
                  this.ratio = 1 - 0.5 * this.ratio;
               }
            }
            else
            {
               this.ratio = _ease(this.cachedTime,0,1,this.cachedDuration);
            }
         }
         if(prevTime == 0 && this.cachedTotalTime != 0 && !suppressEvents)
         {
            if(this.vars.onStart)
            {
               this.vars.onStart.apply(null,this.vars.onStartParams);
            }
            if(_dispatcher)
            {
               _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.START));
            }
         }
         var pt:PropTween = this.cachedPT1;
         while(pt)
         {
            pt.target[pt.property] = pt.start + this.ratio * pt.change;
            pt = pt.nextNode;
         }
         if(_hasUpdate && !suppressEvents)
         {
            this.vars.onUpdate.apply(null,this.vars.onUpdateParams);
         }
         if(_hasUpdateListener && !suppressEvents)
         {
            _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
         }
         if(isComplete)
         {
            if(_hasPlugins && this.cachedPT1)
            {
               onPluginEvent("onComplete",this);
            }
            complete(true,suppressEvents);
         }
         else if(repeated && !suppressEvents)
         {
            if(this.vars.onRepeat)
            {
               this.vars.onRepeat.apply(null,this.vars.onRepeatParams);
            }
            if(_dispatcher)
            {
               _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.REPEAT));
            }
         }
      }
      
      override public function set totalDuration(n:Number) : void
      {
         if(_repeat == -1)
         {
            return;
         }
         this.duration = (n - _repeat * _repeatDelay) / (_repeat + 1);
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         if(_dispatcher == null)
         {
            initDispatcher();
         }
         if(type == TweenEvent.UPDATE)
         {
            _hasUpdateListener = true;
         }
         _dispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      protected function insertPropTween(target:Object, property:String, start:Number, end:*, name:String, isPlugin:Boolean, nextNode:PropTween) : PropTween
      {
         var op:Array = null;
         var i:int = 0;
         var pt:PropTween = new PropTween(target,property,start,typeof end == "number" ? Number(end - start) : Number(Number(end)),name,isPlugin,nextNode);
         if(isPlugin && name == "_MULTIPLE_")
         {
            op = target.overwriteProps;
            i = op.length;
            while(i--)
            {
               this.propTweenLookup[op[i]] = pt;
            }
         }
         else
         {
            this.propTweenLookup[name] = pt;
         }
         return pt;
      }
      
      override protected function init() : void
      {
         var startTween:TweenMax = null;
         var j:int = 0;
         var prop:String = null;
         var multiProps:* = null;
         var rp:Array = null;
         var plugin:Object = null;
         var ptPlugin:PropTween = null;
         var pt:PropTween = null;
         var i:int = 0;
         if(this.vars.startAt)
         {
            this.vars.startAt.overwrite = 0;
            this.vars.startAt.immediateRender = true;
            startTween = new TweenMax(this.target,0,this.vars.startAt);
         }
         super.init();
         if(_ease in fastEaseLookup)
         {
            _easeType = fastEaseLookup[_ease][0];
            _easePower = fastEaseLookup[_ease][1];
         }
         if(this.vars.roundProps != null && "roundProps" in TweenLite.plugins)
         {
            rp = this.vars.roundProps;
            i = rp.length;
            while(i--)
            {
               prop = rp[i];
               pt = this.cachedPT1;
               while(pt)
               {
                  if(pt.name == prop)
                  {
                     if(pt.isPlugin)
                     {
                        pt.target.round = true;
                     }
                     else
                     {
                        if(plugin == null)
                        {
                           plugin = new TweenLite.plugins.roundProps();
                           plugin.add(pt.target,prop,pt.start,pt.change);
                           _hasPlugins = true;
                           this.cachedPT1 = ptPlugin = insertPropTween(plugin,"changeFactor",0,1,"_MULTIPLE_",true,this.cachedPT1);
                        }
                        else
                        {
                           plugin.add(pt.target,prop,pt.start,pt.change);
                        }
                        this.removePropTween(pt);
                        this.propTweenLookup[prop] = ptPlugin;
                     }
                  }
                  else if(pt.isPlugin && pt.name == "_MULTIPLE_" && !pt.target.round)
                  {
                     multiProps = " " + pt.target.overwriteProps.join(" ") + " ";
                     if(multiProps.indexOf(" " + prop + " ") != -1)
                     {
                        pt.target.round = true;
                     }
                  }
                  pt = pt.nextNode;
               }
            }
         }
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         if(_dispatcher)
         {
            _dispatcher.removeEventListener(type,listener,useCapture);
         }
      }
      
      public function setDestination(property:String, value:*, adjustStartValues:Boolean = true) : void
      {
         var vars:Object = {};
         vars[property] = value;
         updateTo(vars,!adjustStartValues);
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return _dispatcher == null ? false : Boolean(_dispatcher.willTrigger(type));
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return _dispatcher == null ? false : Boolean(_dispatcher.hasEventListener(type));
      }
      
      protected function initDispatcher() : void
      {
         if(_dispatcher == null)
         {
            _dispatcher = new EventDispatcher(this);
         }
         if(this.vars.onStartListener is Function)
         {
            _dispatcher.addEventListener(TweenEvent.START,this.vars.onStartListener,false,0,true);
         }
         if(this.vars.onUpdateListener is Function)
         {
            _dispatcher.addEventListener(TweenEvent.UPDATE,this.vars.onUpdateListener,false,0,true);
            _hasUpdateListener = true;
         }
         if(this.vars.onCompleteListener is Function)
         {
            _dispatcher.addEventListener(TweenEvent.COMPLETE,this.vars.onCompleteListener,false,0,true);
         }
         if(this.vars.onRepeatListener is Function)
         {
            _dispatcher.addEventListener(TweenEvent.REPEAT,this.vars.onRepeatListener,false,0,true);
         }
         if(this.vars.onReverseCompleteListener is Function)
         {
            _dispatcher.addEventListener(TweenEvent.REVERSE_COMPLETE,this.vars.onReverseCompleteListener,false,0,true);
         }
      }
      
      public function set currentProgress(n:Number) : void
      {
         if(_cyclesComplete == 0)
         {
            setTotalTime(this.duration * n,false);
         }
         else
         {
            setTotalTime(this.duration * n + _cyclesComplete * this.cachedDuration,false);
         }
      }
      
      public function get totalProgress() : Number
      {
         return this.cachedTotalTime / this.totalDuration;
      }
      
      public function set totalProgress(n:Number) : void
      {
         setTotalTime(this.totalDuration * n,false);
      }
      
      protected function removePropTween(propTween:PropTween) : Boolean
      {
         if(propTween.nextNode)
         {
            propTween.nextNode.prevNode = propTween.prevNode;
         }
         if(propTween.prevNode)
         {
            propTween.prevNode.nextNode = propTween.nextNode;
         }
         else if(this.cachedPT1 == propTween)
         {
            this.cachedPT1 = propTween.nextNode;
         }
         if(propTween.isPlugin && propTween.target.onDisable)
         {
            propTween.target.onDisable();
            if(propTween.target.activeDisable)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get currentProgress() : Number
      {
         return this.cachedTime / this.duration;
      }
      
      public function get repeat() : int
      {
         return _repeat;
      }
      
      public function updateTo(vars:Object, resetDuration:Boolean = false) : void
      {
         var p:* = null;
         var inv:Number = NaN;
         var pt:PropTween = null;
         var endValue:Number = NaN;
         var curRatio:Number = this.ratio;
         if(resetDuration && this.timeline != null && this.cachedStartTime < this.timeline.cachedTime)
         {
            this.cachedStartTime = this.timeline.cachedTime;
            if(this.gc)
            {
               this.setEnabled(true,false);
            }
            else
            {
               this.timeline.addChild(this);
            }
         }
         for(p in vars)
         {
            this.vars[p] = vars[p];
         }
         if(this.initted)
         {
            init();
            if(!resetDuration && this.cachedTime > 0 && this.cachedTime < this.cachedDuration)
            {
               inv = 1 / (1 - curRatio);
               pt = this.cachedPT1;
               while(pt)
               {
                  endValue = pt.start + pt.change;
                  pt.change *= inv;
                  pt.start = endValue - pt.change;
                  pt = pt.nextNode;
               }
            }
         }
      }
      
      override public function set currentTime(n:Number) : void
      {
         if(_cyclesComplete != 0)
         {
            if(this.yoyo && _cyclesComplete % 2 == 1)
            {
               n = this.duration - n + _cyclesComplete * (this.cachedDuration + _repeatDelay);
            }
            else
            {
               n += _cyclesComplete * (this.duration + _repeatDelay);
            }
         }
         setTotalTime(n,false);
      }
      
      public function get repeatDelay() : Number
      {
         return _repeatDelay;
      }
      
      public function killProperties(names:Array) : void
      {
         var v:Object = {};
         var i:int = names.length;
         while(i--)
         {
            v[names[i]] = true;
         }
         killVars(v);
      }
      
      public function set repeatDelay(n:Number) : void
      {
         _repeatDelay = n;
         setDirtyCache(true);
      }
      
      public function set repeat(n:int) : void
      {
         _repeat = n;
         setDirtyCache(true);
      }
      
      override public function complete(skipRender:Boolean = false, suppressEvents:Boolean = false) : void
      {
         super.complete(skipRender,suppressEvents);
         if(!suppressEvents && _dispatcher)
         {
            if(this.cachedTotalTime == this.cachedTotalDuration && !this.cachedReversed)
            {
               _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
            }
            else if(this.cachedReversed && this.cachedTotalTime == 0)
            {
               _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.REVERSE_COMPLETE));
            }
         }
      }
      
      override public function invalidate() : void
      {
         this.yoyo = Boolean(this.vars.yoyo == true);
         _repeat = int(this.vars.repeat) || 0;
         _repeatDelay = Number(this.vars.repeatDelay) || Number(0);
         _hasUpdateListener = false;
         if(this.vars.onCompleteListener != null || this.vars.onUpdateListener != null || this.vars.onStartListener != null)
         {
            initDispatcher();
         }
         setDirtyCache(true);
         super.invalidate();
      }
      
      public function get timeScale() : Number
      {
         return this.cachedTimeScale;
      }
      
      override public function get totalDuration() : Number
      {
         if(this.cacheIsDirty)
         {
            this.cachedTotalDuration = _repeat == -1 ? Number(999999999999) : Number(this.cachedDuration * (_repeat + 1) + _repeatDelay * _repeat);
            this.cacheIsDirty = false;
         }
         return this.cachedTotalDuration;
      }
   }
}
