package com.greensock.events
{
   import flash.events.Event;
   
   public class TweenEvent extends Event
   {
      
      public static const COMPLETE:String = "complete";
      
      public static const START:String = "init";
      
      public static const UPDATE:String = "change";
      
      public static const REVERSE_COMPLETE:String = "reverseComplete";
      
      public static const VERSION:Number = 1;
      
      public static const REPEAT:String = "repeat";
       
      
      public function TweenEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         return new TweenEvent(this.type,this.bubbles,this.cancelable);
      }
   }
}
