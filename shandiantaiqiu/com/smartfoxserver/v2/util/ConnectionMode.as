package com.smartfoxserver.v2.util
{
   public class ConnectionMode
   {
      
      public static const SOCKET:String = "socket";
      
      public static const HTTP:String = "http";
       
      
      public function ConnectionMode()
      {
         super();
         throw new ArgumentError("This is class has no constructor!");
      }
   }
}
