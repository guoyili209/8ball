package com.smartfoxserver.v2.util
{
   public class ConfigData
   {
       
      
      public var host:String = "127.0.0.1";
      
      public var port:int = 9933;
      
      public var udpHost:String = "127.0.0.1";
      
      public var udpPort:int = 9933;
      
      public var zone:String;
      
      public var debug:Boolean = false;
      
      public var httpPort:int = 8080;
      
      public var useBBox:Boolean = true;
      
      public var bboxHost:String;
      
      public var bboxPort:int = 8080;
      
      public var bboxPollingRate:int = 700;
      
      public function ConfigData()
      {
         super();
      }
   }
}
