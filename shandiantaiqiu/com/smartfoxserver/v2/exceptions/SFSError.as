package com.smartfoxserver.v2.exceptions
{
   public class SFSError extends Error
   {
       
      
      public function SFSError(message:String, errorId:int = 0)
      {
         super(message,errorId);
      }
   }
}
