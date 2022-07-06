package com.smartfoxserver.v2.entities.invitation
{
   public class InvitationReply
   {
      
      public static const ACCEPT:int = 0;
      
      public static const REFUSE:int = 1;
       
      
      public function InvitationReply()
      {
         super();
         throw new ArgumentError("This class cannot be instantiated");
      }
   }
}
