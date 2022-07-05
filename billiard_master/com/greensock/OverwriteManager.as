package com.greensock
{
   import com.greensock.core.SimpleTimeline;
   import com.greensock.core.TweenCore;
   
   public class OverwriteManager
   {
      
      public static var enabled:Boolean;
      
      public static var mode:int;
      
      public static const ALL_ONSTART:int = 4;
      
      public static const CONCURRENT:int = 3;
      
      public static const ALL_IMMEDIATE:int = 1;
      
      public static const PREEXISTING:int = 5;
      
      public static const AUTO:int = 2;
      
      public static const version:Number = 6;
      
      public static const NONE:int = 0;
       
      
      public function OverwriteManager()
      {
         super();
      }
      
      public static function getGlobalPaused(tween:TweenCore) : Boolean
      {
         while(tween)
         {
            if(tween.cachedPaused)
            {
               return true;
            }
            tween = tween.timeline;
         }
         return false;
      }
      
      public static function init(defaultMode:int = 2) : int
      {
         if(TweenLite.version < 11.099994)
         {
            throw new Error("Warning: Your TweenLite class needs to be updated to work with OverwriteManager (or you may need to clear your ASO files). Please download and install the latest version from http://www.tweenlite.com.");
         }
         TweenLite.overwriteManager = OverwriteManager;
         mode = defaultMode;
         enabled = true;
         return mode;
      }
      
      public static function manageOverwrites(tween:TweenLite, props:Object, targetTweens:Array, mode:uint) : Boolean
      {
         var i:int = 0;
         var changed:Boolean = false;
         var curTween:TweenLite = null;
         var l:uint = 0;
         var combinedTimeScale:Number = NaN;
         var combinedStartTime:Number = NaN;
         var cousin:TweenCore = null;
         var cousinStartTime:Number = NaN;
         var timeline:SimpleTimeline = null;
         if(mode >= 4)
         {
            l = targetTweens.length;
            for(i = 0; i < l; i++)
            {
               curTween = targetTweens[i];
               if(curTween != tween)
               {
                  if(curTween.setEnabled(false,false))
                  {
                     changed = true;
                  }
               }
               else if(mode == 5)
               {
                  break;
               }
            }
            return changed;
         }
         var startTime:Number = tween.startTime;
         var overlaps:Array = [];
         var cousins:Array = [];
         var cCount:uint = 0;
         var oCount:uint = 0;
         i = targetTweens.length;
         while(i--)
         {
            curTween = targetTweens[i];
            if(!(curTween == tween || curTween.gc))
            {
               if(curTween.timeline != tween.timeline)
               {
                  if(!getGlobalPaused(curTween))
                  {
                     var _loc19_:*;
                     cousins[_loc19_ = cCount++] = curTween;
                  }
               }
               else if(curTween.startTime <= startTime && curTween.startTime + curTween.totalDuration > startTime && !getGlobalPaused(curTween))
               {
                  overlaps[_loc19_ = oCount++] = curTween;
               }
            }
         }
         if(cCount != 0)
         {
            combinedTimeScale = tween.cachedTimeScale;
            combinedStartTime = startTime;
            timeline = tween.timeline;
            while(timeline)
            {
               combinedTimeScale *= timeline.cachedTimeScale;
               combinedStartTime += timeline.startTime;
               timeline = timeline.timeline;
            }
            startTime = combinedTimeScale * combinedStartTime;
            i = cCount;
            while(i--)
            {
               cousin = cousins[i];
               combinedTimeScale = cousin.cachedTimeScale;
               combinedStartTime = cousin.startTime;
               timeline = cousin.timeline;
               while(timeline)
               {
                  combinedTimeScale *= timeline.cachedTimeScale;
                  combinedStartTime += timeline.startTime;
                  timeline = timeline.timeline;
               }
               cousinStartTime = combinedTimeScale * combinedStartTime;
               if(cousinStartTime <= startTime && (cousinStartTime + cousin.totalDuration * combinedTimeScale > startTime || cousin.cachedDuration == 0))
               {
                  overlaps[_loc19_ = oCount++] = cousin;
               }
            }
         }
         if(oCount == 0)
         {
            return changed;
         }
         i = oCount;
         if(mode == 2)
         {
            while(i--)
            {
               curTween = overlaps[i];
               if(curTween.killVars(props))
               {
                  changed = true;
               }
               if(curTween.cachedPT1 == null && curTween.initted)
               {
                  curTween.setEnabled(false,false);
               }
            }
         }
         else
         {
            while(i--)
            {
               if(TweenLite(overlaps[i]).setEnabled(false,false))
               {
                  changed = true;
               }
            }
         }
         return changed;
      }
   }
}
