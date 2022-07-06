package com
{
   import flash.events.Event;
   
   public class CustomEvent extends Event
   {
      
      public static const EVENT:String = "event";
       
      
      public var data:Object;
      
      public function CustomEvent(type:String, data:Object, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.data = data;
      }
      
      override public function clone() : Event
      {
         return new CustomEvent(type,this.data,bubbles,cancelable);
      }
   }
}
