package com
{
   import flash.events.EventDispatcher;
   
   public class Dispatcher extends EventDispatcher
   {
      
      private static var dispatcher:Dispatcher = null;
       
      
      public function Dispatcher(enforcer:SingletonEnforcer)
      {
         super();
         if(!enforcer)
         {
            throw new Error("Direct instatiation is not allowed");
         }
      }
      
      public static function GetInstance() : Dispatcher
      {
         if(!dispatcher)
         {
            dispatcher = new Dispatcher(new SingletonEnforcer());
         }
         return dispatcher;
      }
   }
}

class SingletonEnforcer
{
    
   
   function SingletonEnforcer()
   {
      super();
   }
}
