package com.greensock
{
   import com.greensock.core.SimpleTimeline;
   import com.greensock.core.TweenCore;
   
   public class TimelineLite extends SimpleTimeline
   {
      
      public static const version:Number = 1.142;
      
      private static var _overwriteMode:int = !!OverwriteManager.enabled ? int(OverwriteManager.mode) : int(OverwriteManager.init(2));
       
      
      protected var _endCaps:Array;
      
      protected var _labels:Object;
      
      public function TimelineLite(vars:Object = null)
      {
         super(vars);
         _endCaps = [];
         _labels = {};
         this.autoRemoveChildren = Boolean(this.vars.autoRemoveChildren == true);
         _hasUpdate = Boolean(typeof this.vars.onUpdate == "function");
         if(this.vars.tweens is Array)
         {
            this.insertMultiple(this.vars.tweens,0,this.vars.align || "normal",Number(this.vars.stagger) || Number(0));
         }
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
      
      public function stop() : void
      {
         this.paused = true;
      }
      
      override public function renderTime(time:Number, suppressEvents:Boolean = false, force:Boolean = false) : void
      {
         var tween:TweenCore = null;
         var isComplete:* = false;
         var rendered:Boolean = false;
         var next:TweenCore = null;
         var dur:Number = NaN;
         if(this.gc)
         {
            this.setEnabled(true,false);
         }
         else if(!this.active && !this.cachedPaused)
         {
            this.active = true;
         }
         var totalDur:Number = !!this.cacheIsDirty ? Number(this.totalDuration) : Number(this.cachedTotalDuration);
         var prevTime:Number = this.cachedTime;
         var prevStart:Number = this.cachedStartTime;
         if(time >= totalDur)
         {
            if(_rawPrevTime <= totalDur && _rawPrevTime != time)
            {
               this.cachedTotalTime = this.cachedTime = totalDur;
               forceChildrenToEnd(totalDur,suppressEvents);
               isComplete = !this.hasPausedChild();
               rendered = true;
               if(this.cachedDuration == 0 && isComplete && (time == 0 || _rawPrevTime < 0))
               {
                  force = true;
               }
            }
         }
         else if(time <= 0)
         {
            if(time < 0)
            {
               this.active = false;
               if(this.cachedDuration == 0 && _rawPrevTime > 0)
               {
                  force = true;
                  isComplete = true;
               }
            }
            if(_rawPrevTime >= 0 && _rawPrevTime != time)
            {
               forceChildrenToBeginning(0,suppressEvents);
               this.cachedTotalTime = 0;
               this.cachedTime = 0;
               rendered = true;
               if(this.cachedReversed)
               {
                  isComplete = true;
               }
            }
         }
         else
         {
            this.cachedTotalTime = this.cachedTime = time;
         }
         _rawPrevTime = time;
         if(this.cachedTime == prevTime && !force)
         {
            return;
         }
         if(!this.initted)
         {
            this.initted = true;
         }
         if(prevTime == 0 && this.vars.onStart && this.cachedTime != 0 && !suppressEvents)
         {
            this.vars.onStart.apply(null,this.vars.onStartParams);
         }
         if(!rendered)
         {
            if(this.cachedTime - prevTime > 0)
            {
               tween = _firstChild;
               while(tween)
               {
                  next = tween.nextNode;
                  if(tween.active || !tween.cachedPaused && tween.cachedStartTime <= this.cachedTime && !tween.gc)
                  {
                     if(!tween.cachedReversed)
                     {
                        tween.renderTime((this.cachedTime - tween.cachedStartTime) * tween.cachedTimeScale,suppressEvents,false);
                     }
                     else
                     {
                        dur = !!tween.cacheIsDirty ? Number(tween.totalDuration) : Number(tween.cachedTotalDuration);
                        tween.renderTime(dur - (this.cachedTime - tween.cachedStartTime) * tween.cachedTimeScale,suppressEvents,false);
                     }
                  }
                  tween = next;
               }
            }
            else
            {
               tween = _lastChild;
               while(tween)
               {
                  next = tween.prevNode;
                  if(tween.active || !tween.cachedPaused && tween.cachedStartTime <= prevTime && !tween.gc)
                  {
                     if(!tween.cachedReversed)
                     {
                        tween.renderTime((this.cachedTime - tween.cachedStartTime) * tween.cachedTimeScale,suppressEvents,false);
                     }
                     else
                     {
                        dur = !!tween.cacheIsDirty ? Number(tween.totalDuration) : Number(tween.cachedTotalDuration);
                        tween.renderTime(dur - (this.cachedTime - tween.cachedStartTime) * tween.cachedTimeScale,suppressEvents,false);
                     }
                  }
                  tween = next;
               }
            }
         }
         if(_hasUpdate && !suppressEvents)
         {
            this.vars.onUpdate.apply(null,this.vars.onUpdateParams);
         }
         if(isComplete && prevStart == this.cachedStartTime)
         {
            complete(true,suppressEvents);
         }
      }
      
      override public function remove(tween:TweenCore, skipDisable:Boolean = false) : void
      {
         if(tween.gc)
         {
            return;
         }
         if(!skipDisable)
         {
            tween.setEnabled(false,true);
         }
         var first:TweenCore = _firstChild || _endCaps[0];
         var last:TweenCore = _lastChild || _endCaps[1];
         if(tween.nextNode)
         {
            tween.nextNode.prevNode = tween.prevNode;
         }
         else if(last == tween)
         {
            last = tween.prevNode;
         }
         if(tween.prevNode)
         {
            tween.prevNode.nextNode = tween.nextNode;
         }
         else if(first == tween)
         {
            first = tween.nextNode;
         }
         if(this.gc)
         {
            _endCaps[0] = first;
            _endCaps[1] = last;
         }
         else
         {
            _firstChild = first;
            _lastChild = last;
         }
         setDirtyCache(true);
      }
      
      public function get currentProgress() : Number
      {
         return this.cachedTime / this.duration;
      }
      
      override public function get totalDuration() : Number
      {
         var max:Number = NaN;
         var end:Number = NaN;
         var tween:TweenCore = null;
         var prevStart:Number = NaN;
         var next:TweenCore = null;
         if(this.cacheIsDirty)
         {
            max = 0;
            tween = _firstChild || _endCaps[0];
            prevStart = -Infinity;
            while(tween)
            {
               next = tween.nextNode;
               if(tween.cachedStartTime < prevStart)
               {
                  this.addChild(tween);
                  prevStart = tween.prevNode.cachedStartTime;
               }
               else
               {
                  prevStart = tween.cachedStartTime;
               }
               if(tween.cachedStartTime < 0)
               {
                  max -= tween.cachedStartTime;
                  this.shiftChildren(-tween.cachedStartTime,false,-9999999999);
               }
               end = tween.cachedStartTime + tween.totalDuration / tween.cachedTimeScale;
               if(end > max)
               {
                  max = end;
               }
               tween = next;
            }
            this.cachedDuration = this.cachedTotalDuration = max;
            this.cacheIsDirty = false;
         }
         return this.cachedTotalDuration;
      }
      
      public function gotoAndPlay(timeOrLabel:*, suppressEvents:Boolean = true) : void
      {
         goto(timeOrLabel,suppressEvents);
         play();
      }
      
      public function appendMultiple(tweens:Array, offset:Number = 0, align:String = "normal", stagger:Number = 0) : void
      {
         insertMultiple(tweens,this.duration + offset,align,stagger);
      }
      
      public function set currentProgress(n:Number) : void
      {
         setTotalTime(this.duration * n,false);
      }
      
      public function clear(tweens:Array = null) : void
      {
         if(tweens == null)
         {
            tweens = getChildren(false,true,true);
         }
         var i:int = tweens.length;
         while(i--)
         {
            TweenCore(tweens[i]).setEnabled(false,false);
         }
      }
      
      public function prepend(tween:TweenCore, adjustLabels:Boolean = false) : void
      {
         shiftChildren(tween.totalDuration / tween.cachedTimeScale + tween.delay,adjustLabels,0);
         insert(tween,0);
      }
      
      public function removeLabel(label:String) : Number
      {
         var n:Number = _labels[label];
         delete _labels[label];
         return n;
      }
      
      public function addLabel(label:String, time:Number) : void
      {
         _labels[label] = time;
      }
      
      public function hasPausedChild() : Boolean
      {
         var tween:TweenCore = _firstChild || _endCaps[0];
         while(tween)
         {
            if(tween.cachedPaused || tween is TimelineLite && (tween as TimelineLite).hasPausedChild())
            {
               return true;
            }
            tween = tween.nextNode;
         }
         return false;
      }
      
      public function getTweensOf(target:Object, nested:Boolean = true) : Array
      {
         var i:int = 0;
         var tweens:Array = getChildren(nested,true,false);
         var a:Array = [];
         var l:uint = tweens.length;
         for(i = 0; i < l; i++)
         {
            if(TweenLite(tweens[i]).target == target)
            {
               a[a.length] = tweens[i];
            }
         }
         return a;
      }
      
      public function gotoAndStop(timeOrLabel:*, suppressEvents:Boolean = true) : void
      {
         goto(timeOrLabel,suppressEvents);
         this.paused = true;
      }
      
      public function append(tween:TweenCore, offset:Number = 0) : void
      {
         insert(tween,this.duration + offset);
      }
      
      override public function get duration() : Number
      {
         var d:Number = NaN;
         if(this.cacheIsDirty)
         {
            d = this.totalDuration;
         }
         return this.cachedDuration;
      }
      
      public function get useFrames() : Boolean
      {
         var tl:SimpleTimeline = this.timeline;
         while(tl.timeline)
         {
            tl = tl.timeline;
         }
         return Boolean(tl == TweenLite.rootFramesTimeline);
      }
      
      public function shiftChildren(amount:Number, adjustLabels:Boolean = false, ignoreBeforeTime:Number = 0) : void
      {
         var p:* = null;
         var tween:TweenCore = _firstChild || _endCaps[0];
         while(tween)
         {
            if(tween.cachedStartTime >= ignoreBeforeTime)
            {
               tween.cachedStartTime += amount;
            }
            tween = tween.nextNode;
         }
         if(adjustLabels)
         {
            for(p in _labels)
            {
               if(_labels[p] >= ignoreBeforeTime)
               {
                  _labels[p] += amount;
               }
            }
         }
         this.setDirtyCache(true);
      }
      
      public function goto(timeOrLabel:*, suppressEvents:Boolean = true) : void
      {
         if(typeof timeOrLabel == "string")
         {
            if(timeOrLabel in _labels)
            {
               setTotalTime(Number(_labels[timeOrLabel]),suppressEvents);
            }
         }
         else
         {
            setTotalTime(Number(timeOrLabel),suppressEvents);
         }
      }
      
      public function killTweensOf(target:Object, nested:Boolean = true) : Boolean
      {
         var tweens:Array = getTweensOf(target,nested);
         var i:int = tweens.length;
         while(i--)
         {
            TweenLite(tweens[i]).setEnabled(false,false);
         }
         return Boolean(tweens.length > 0);
      }
      
      override public function invalidate() : void
      {
         var tween:TweenCore = _firstChild || _endCaps[0];
         while(tween)
         {
            tween.invalidate();
            tween = tween.nextNode;
         }
      }
      
      public function insertMultiple(tweens:Array, timeOrLabel:* = 0, align:String = "normal", stagger:Number = 0) : void
      {
         var i:int = 0;
         var tween:TweenCore = null;
         var curTime:Number = Number(Number(timeOrLabel)) || Number(0);
         var l:uint = tweens.length;
         if(typeof timeOrLabel == "string")
         {
            if(!(timeOrLabel in _labels))
            {
               addLabel(timeOrLabel,this.duration);
            }
            curTime = _labels[timeOrLabel];
         }
         for(i = 0; i < l; i++)
         {
            tween = tweens[i] as TweenCore;
            insert(tween,curTime);
            if(align == "sequence")
            {
               curTime = tween.cachedStartTime + tween.totalDuration / tween.cachedTimeScale;
            }
            else if(align == "start")
            {
               tween.cachedStartTime -= tween.delay;
            }
            curTime += stagger;
         }
      }
      
      public function getLabelTime(label:String) : Number
      {
         return label in _labels ? Number(Number(_labels[label])) : Number(-1);
      }
      
      override public function get rawTime() : Number
      {
         if(this.cachedTotalTime != 0 && this.cachedTotalTime != this.cachedTotalDuration)
         {
            return this.cachedTotalTime;
         }
         return (this.timeline.rawTime - this.cachedStartTime) * this.cachedTimeScale;
      }
      
      override public function set duration(n:Number) : void
      {
         if(this.duration != 0 && n != 0)
         {
            this.timeScale = this.duration / n;
         }
      }
      
      override public function set totalDuration(n:Number) : void
      {
         if(this.totalDuration != 0 && n != 0)
         {
            this.timeScale = this.totalDuration / n;
         }
      }
      
      public function getChildren(nested:Boolean = true, tweens:Boolean = true, timelines:Boolean = true, ignoreBeforeTime:Number = -9.999999999E9) : Array
      {
         var a:Array = [];
         var tween:TweenCore = _firstChild || _endCaps[0];
         var cnt:uint = 0;
         while(tween)
         {
            if(tween.cachedStartTime >= ignoreBeforeTime)
            {
               if(tween is TweenLite)
               {
                  if(tweens)
                  {
                     var _loc8_:*;
                     a[_loc8_ = cnt++] = tween;
                  }
               }
               else
               {
                  if(timelines)
                  {
                     a[_loc8_ = cnt++] = tween;
                  }
                  if(nested)
                  {
                     a = a.concat(TimelineLite(tween).getChildren(true,tweens,timelines));
                  }
               }
            }
            tween = tween.nextNode;
         }
         return a;
      }
      
      protected function forceChildrenToEnd(time:Number, suppressEvents:Boolean = false) : Number
      {
         var next:TweenCore = null;
         var dur:Number = NaN;
         var tween:TweenCore = _firstChild;
         while(tween)
         {
            next = tween.nextNode;
            if(tween.active || !tween.cachedPaused && !tween.gc && (tween.cachedTotalTime != tween.cachedTotalDuration || tween.cachedDuration == 0))
            {
               if(time == this.cachedDuration && (tween.cachedDuration != 0 || tween.cachedStartTime == this.cachedDuration))
               {
                  tween.renderTime(!!tween.cachedReversed ? Number(0) : Number(tween.cachedTotalDuration),suppressEvents,false);
               }
               else if(!tween.cachedReversed)
               {
                  tween.renderTime((time - tween.cachedStartTime) * tween.cachedTimeScale,suppressEvents,false);
               }
               else
               {
                  dur = !!tween.cacheIsDirty ? Number(tween.totalDuration) : Number(tween.cachedTotalDuration);
                  tween.renderTime(dur - (time - tween.cachedStartTime) * tween.cachedTimeScale,suppressEvents,false);
               }
            }
            tween = next;
         }
         return time;
      }
      
      protected function forceChildrenToBeginning(time:Number, suppressEvents:Boolean = false) : Number
      {
         var next:TweenCore = null;
         var dur:Number = NaN;
         var tween:TweenCore = _lastChild;
         while(tween)
         {
            next = tween.prevNode;
            if(tween.active || !tween.cachedPaused && !tween.gc && (tween.cachedTotalTime != 0 || tween.cachedDuration == 0))
            {
               if(time == 0 && (tween.cachedDuration != 0 || tween.cachedStartTime == 0))
               {
                  tween.renderTime(!!tween.cachedReversed ? Number(tween.cachedTotalDuration) : Number(0),suppressEvents,false);
               }
               else if(!tween.cachedReversed)
               {
                  tween.renderTime((time - tween.cachedStartTime) * tween.cachedTimeScale,suppressEvents,false);
               }
               else
               {
                  dur = !!tween.cacheIsDirty ? Number(tween.totalDuration) : Number(tween.cachedTotalDuration);
                  tween.renderTime(dur - (time - tween.cachedStartTime) * tween.cachedTimeScale,suppressEvents,false);
               }
            }
            tween = next;
         }
         return time;
      }
      
      public function insert(tween:TweenCore, timeOrLabel:* = 0) : void
      {
         if(typeof timeOrLabel == "string")
         {
            if(!(timeOrLabel in _labels))
            {
               addLabel(timeOrLabel,this.duration);
            }
            timeOrLabel = Number(_labels[timeOrLabel]);
         }
         tween.cachedStartTime = Number(timeOrLabel) + tween.delay;
         addChild(tween);
      }
      
      override public function addChild(tween:TweenCore) : void
      {
         var curTween:TweenCore = null;
         var st:Number = NaN;
         if(!tween.gc && tween.timeline)
         {
            tween.timeline.remove(tween,true);
         }
         tween.timeline = this;
         if(tween.gc)
         {
            tween.setEnabled(true,true);
         }
         setDirtyCache(true);
         var first:TweenCore = _firstChild || _endCaps[0];
         var last:TweenCore = _lastChild || _endCaps[1];
         if(last == null)
         {
            first = last = tween;
            tween.nextNode = tween.prevNode = null;
         }
         else
         {
            curTween = last;
            st = tween.cachedStartTime;
            while(curTween != null && st <= curTween.cachedStartTime)
            {
               curTween = curTween.prevNode;
            }
            if(curTween == null)
            {
               first.prevNode = tween;
               tween.nextNode = first;
               tween.prevNode = null;
               first = tween;
            }
            else
            {
               if(curTween.nextNode)
               {
                  curTween.nextNode.prevNode = tween;
               }
               else if(curTween == last)
               {
                  last = tween;
               }
               tween.prevNode = curTween;
               tween.nextNode = curTween.nextNode;
               curTween.nextNode = tween;
            }
         }
         if(this.gc)
         {
            _endCaps[0] = first;
            _endCaps[1] = last;
         }
         else
         {
            _firstChild = first;
            _lastChild = last;
         }
      }
      
      public function get timeScale() : Number
      {
         return this.cachedTimeScale;
      }
      
      public function prependMultiple(tweens:Array, align:String = "normal", stagger:Number = 0, adjustLabels:Boolean = false) : void
      {
         var tl:TimelineLite = new TimelineLite({
            "tweens":tweens,
            "align":align,
            "stagger":stagger
         });
         shiftChildren(tl.duration,adjustLabels,0);
         insertMultiple(tweens,0,align,stagger);
         tl.kill();
      }
      
      override public function setEnabled(enabled:Boolean, ignoreTimeline:Boolean = false) : Boolean
      {
         var tween:TweenCore = null;
         var next:TweenCore = null;
         if(enabled == this.gc)
         {
            if(enabled)
            {
               _firstChild = tween = _endCaps[0];
               _lastChild = _endCaps[1];
            }
            else
            {
               tween = _firstChild;
               _endCaps = [_firstChild,_lastChild];
               _firstChild = _lastChild = null;
            }
            while(tween)
            {
               tween.setEnabled(enabled,true);
               tween = tween.nextNode;
            }
         }
         return super.setEnabled(enabled,ignoreTimeline);
      }
   }
}
