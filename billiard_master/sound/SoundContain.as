package sound
{
   import flash.utils.Dictionary;
   
   public class SoundContain
   {
      
      public static const MULTIPLIER:String = "multiplier";
      
      public static const NEWMULTIPLIER:String = "new multiplier";
      
      public static const TIME:String = "time";
      
      public static const BALL_COLLISION:String = "ball collision";
      
      public static const CUSHION_COLLISION:String = "cushion collision";
      
      public static const BALL_POCKET:String = "ball pocket";
      
      public static const RACK:String = "rack";
      
      public static const LOGO_IMPACT:String = "logo impact";
      
      private static var _soundClassDict:Dictionary;
      
      private static var _allSound:Boolean;
      
      public static const CUE_COLLISION:String = "cue collision";
      
      public static const RUNNER:String = "SoundRunner";
      
      public static const COUNT_DOWN:String = "count down";
      
      public static const CUE_WEAK_COLLISION:String = "cue weak collision";
      
      private static var _manager:SoundManager;
       
      
      public function SoundContain()
      {
         super();
      }
      
      public static function stopAllSound() : void
      {
         if(_allSound)
         {
            try
            {
               _manager.stopAllSounds();
               _allSound = false;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public static function playAllSound() : void
      {
         if(_allSound == false)
         {
            _allSound = true;
         }
      }
      
      private static function initSound() : void
      {
         _allSound = true;
         _manager = SoundManager.getInstance();
         _soundClassDict = new Dictionary();
         _soundClassDict[CUE_WEAK_COLLISION] = PoolSounds.PoolSounds_SoundCueWeakCollision;
         _soundClassDict[BALL_COLLISION] = PoolSounds.PoolSounds_SoundBallCollision;
         _soundClassDict[BALL_POCKET] = PoolSounds.PoolSounds_SoundPocket;
         _soundClassDict[CUSHION_COLLISION] = PoolSounds.PoolSounds_SoundCushionCollision;
         _soundClassDict[NEWMULTIPLIER] = PoolSounds.PoolSounds_SoundMultiplier;
      }
      
      public static function stopSound(name:String) : void
      {
         try
         {
            if(_manager.hasSound(name))
            {
               _manager.stopSound(name);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public static function setSound(value:Boolean) : void
      {
      }
      
      public static function playSound(name:String, volume:Number = 1, startTime:Number = 0, loops:int = 1) : void
      {
         var cl:Class = null;
         try
         {
            if(_manager == null)
            {
               initSound();
            }
            if(!_allSound)
            {
               return;
            }
            if(_soundClassDict[name] != null)
            {
               cl = _soundClassDict[name] as Class;
               _manager.addLibrarySound(cl,name);
               _manager.playSound(name,volume,startTime,loops);
            }
         }
         catch(e:Error)
         {
            trace("声音素材未初始化");
         }
      }
   }
}
