package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   
   public class BanUserRequest extends BaseRequest
   {
      
      public static const KEY_USER_ID:String = "u";
      
      public static const KEY_MESSAGE:String = "m";
      
      public static const KEY_DELAY:String = "d";
      
      public static const KEY_BAN_MODE:String = "b";
      
      public static const KEY_BAN_DURATION_HOURS:String = "dh";
       
      
      private var _userId:int;
      
      private var _message:String;
      
      private var _delay:int;
      
      private var _banMode:int;
      
      private var _durationHours:int;
      
      public function BanUserRequest(userId:int, message:String = null, banMode:int = 1, delaySeconds:int = 5)
      {
         super(BaseRequest.BanUser);
         this._userId = userId;
         this._message = message;
         this._banMode = banMode;
         this._delay = delaySeconds;
      }
      
      override public function validate(sfs:SmartFox) : void
      {
         var errors:Array = [];
         if(!sfs.mySelf.isModerator() && !sfs.mySelf.isAdmin())
         {
            errors.push("You don\'t have enough permissions to execute this request.");
         }
         if(errors.length > 0)
         {
            throw new SFSValidationError("BanUser request error",errors);
         }
      }
      
      override public function execute(sfs:SmartFox) : void
      {
         _sfso.putInt(KEY_USER_ID,this._userId);
         _sfso.putInt(KEY_DELAY,this._delay);
         _sfso.putInt(KEY_BAN_MODE,this._banMode);
         _sfso.putInt(KEY_BAN_DURATION_HOURS,this._durationHours);
         if(this._message != null && this._message.length > 0)
         {
            _sfso.putUtfString(KEY_MESSAGE,this._message);
         }
      }
   }
}
