package com.smartfoxserver.v2.util
{
   public class SFSErrorCodes
   {
      
      private static var errorsByCode:Array = ["Client API version is obsolete: {0}, Required version: {1}","Requested Zone: {0} does not exist.","Username: {0} is not recognized","Wrong password for user: {0}","User: {0} is banned","Zone: {0} is full.","User: {0} is already logged in Zone: {1}","The server is full","Zone: {0} is currently inactive","User name contains bad words. Name: {0}, Filtered: {1}","Guest users not allowed in Zone: {0}","IP Address: {0} is banned","A room with the same name already exists: {0}","Requested group is not available. Room: {0}, Group: {1}","Bad room name length. Min: {0}, Max: {1}, Your len: {2}","Room name contains bad words: {0}","Zone is full. Can\'t add any more rooms.","You have exceeded the number of rooms that you can create per session: {0}","Room creation failed, wrong parameter: {0}","User already joined in Room: {0}","The room is full: {0}","Wrong password for Room: {0}","Requested room doesn\'t exist","Room is locked: {0}","Group: {0} is already subscribed","Group: {0} does not exist","Group: {0} is not subscribed","Group: {0} does not exist","{0}","Room permission error. Room: {0} cannot be renamed","Room permission error: {0}, cannot change password state","Room permission error: {0}, cannot change capacity","SwitchUser error. No player slots available. Room: {0}","SwitchUser error. No spectator slots available. Room: {0}","SwitchUser error. Not a game Room: {0}","SwitchUser error. You are not joined in the Room: {0}","BuddyManager initialization error, could not load buddy list: {0}","BuddyManager error. Your buddy list is full. Size = {0}","BuddyManager error. Was not able to block buddy {0}, not online","BuddyManager error. You are attempting to set too many Buddy Variables, limit = {0}","Join Game Access Denied: {0} - User doesn\'t match access criteria.","QuickJoinGame failed: no matching Rooms were found","Your previous invitation reply was invalid or arrived too late."];
       
      
      public function SFSErrorCodes()
      {
         super();
         throw new Error("This class cannot be instantiated. Please check the documentation for more details on its usage");
      }
      
      public static function setErrorMessage(code:int, message:String) : void
      {
         errorsByCode[code] = message;
      }
      
      public static function getErrorMessage(code:int, params:Array = null) : String
      {
         return stringFormat(errorsByCode[code],params);
      }
      
      private static function stringFormat(ss:String, params:Array) : String
      {
         var j:int = 0;
         var src:String = null;
         if(ss == null)
         {
            return "";
         }
         if(params != null)
         {
            for(j = 0; j < params.length; j++)
            {
               src = "{" + j + "}";
               ss = ss.replace(src,params[j]);
            }
         }
         return ss;
      }
   }
}
