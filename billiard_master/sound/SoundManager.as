package sound
{
   import com.greensock.TweenLite;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundLoaderContext;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class SoundManager
   {
      
      private static var _instance:SoundManager;
      
      private static var _allowInstance:Boolean;
       
      
      private var _sounds:Array;
      
      private var _soundsDict:Dictionary;
      
      public function SoundManager()
      {
         super();
         this._soundsDict = new Dictionary(true);
         this._sounds = new Array();
         if(!SoundManager._allowInstance)
         {
            throw new Error("Error: Use SoundManager.getInstance() instead of the new keyword.");
         }
      }
      
      public static function getInstance() : SoundManager
      {
         if(SoundManager._instance == null)
         {
            SoundManager._allowInstance = true;
            SoundManager._instance = new SoundManager();
            SoundManager._allowInstance = false;
         }
         return SoundManager._instance;
      }
      
      public function pauseSound($name:String) : void
      {
         var snd:Object = this._soundsDict[$name];
         snd.paused = true;
         snd.position = snd.channel.position;
         snd.channel.stop();
      }
      
      public function fadeSound($name:String, $targVolume:Number = 0, $fadeLength:Number = 1) : void
      {
         var fadeChannel:SoundChannel = this._soundsDict[$name].channel;
         TweenLite.to(fadeChannel,$fadeLength,{"volume":$targVolume});
      }
      
      public function get sounds() : Array
      {
         return this._sounds;
      }
      
      public function setSoundVolume($name:String, $volume:Number) : void
      {
         var snd:Object = this._soundsDict[$name];
         var curTransform:SoundTransform = snd.channel.soundTransform;
         curTransform.volume = $volume;
         snd.channel.soundTransform = curTransform;
      }
      
      public function getSoundDuration($name:String) : Number
      {
         return this._soundsDict[$name].sound.length;
      }
      
      public function toString() : String
      {
         return getQualifiedClassName(this);
      }
      
      public function getSoundVolume($name:String) : Number
      {
         return this._soundsDict[$name].channel.soundTransform.volume;
      }
      
      public function addLibrarySound($linkageID:*, $name:String) : Boolean
      {
         for(var i:int = 0; i < this._sounds.length; i++)
         {
            if(this._sounds[i].name == $name)
            {
               return false;
            }
         }
         var sndObj:Object = new Object();
         var snd:Sound = new $linkageID();
         sndObj.name = $name;
         sndObj.sound = snd;
         sndObj.channel = new SoundChannel();
         sndObj.position = 0;
         sndObj.paused = true;
         sndObj.volume = 1;
         sndObj.startTime = 0;
         sndObj.loops = 0;
         sndObj.pausedByAll = false;
         this._soundsDict[$name] = sndObj;
         this._sounds.push(sndObj);
         return true;
      }
      
      public function isSoundPaused($name:String) : Boolean
      {
         return this._soundsDict[$name].paused;
      }
      
      public function hasSound($name:String) : Boolean
      {
         trace("hasSound",this._soundsDict[$name]);
         return this._soundsDict[$name] != null;
      }
      
      public function removeAllSounds() : void
      {
         for(var i:int = 0; i < this._sounds.length; i++)
         {
            this._sounds[i] = null;
         }
         this._sounds = new Array();
         this._soundsDict = new Dictionary(true);
      }
      
      public function getSoundPosition($name:String) : Number
      {
         return this._soundsDict[$name].channel.position;
      }
      
      public function stopAllSounds($useCurrentlyPlayingOnly:Boolean = true) : void
      {
         var id:String = null;
         for(var i:int = 0; i < this._sounds.length; i++)
         {
            id = this._sounds[i].name;
            if($useCurrentlyPlayingOnly)
            {
               if(!this._soundsDict[id].paused)
               {
                  this._soundsDict[id].pausedByAll = true;
                  this.stopSound(id);
               }
            }
            else
            {
               this.stopSound(id);
            }
         }
      }
      
      public function removeSound($name:String) : void
      {
         for(var i:int = 0; i < this._sounds.length; i++)
         {
            if(this._sounds[i].name == $name)
            {
               this._sounds[i] = null;
               this._sounds.splice(i,1);
            }
         }
         delete this._soundsDict[$name];
      }
      
      public function muteAllSounds() : void
      {
         var id:String = null;
         for(var i:int = 0; i < this._sounds.length; i++)
         {
            id = this._sounds[i].name;
            this.setSoundVolume(id,0);
         }
      }
      
      public function stopSound($name:String) : void
      {
         var snd:Object = this._soundsDict[$name];
         snd.paused = true;
         snd.channel.stop();
         snd.position = snd.channel.position;
      }
      
      public function pauseAllSounds($useCurrentlyPlayingOnly:Boolean = true) : void
      {
         var id:String = null;
         for(var i:int = 0; i < this._sounds.length; i++)
         {
            id = this._sounds[i].name;
            if($useCurrentlyPlayingOnly)
            {
               if(!this._soundsDict[id].paused)
               {
                  this._soundsDict[id].pausedByAll = true;
                  this.pauseSound(id);
               }
            }
            else
            {
               this.pauseSound(id);
            }
         }
      }
      
      public function playAllSounds($useCurrentlyPlayingOnly:Boolean = false) : void
      {
         var id:String = null;
         for(var i:int = 0; i < this._sounds.length; i++)
         {
            id = this._sounds[i].name;
            if($useCurrentlyPlayingOnly)
            {
               if(this._soundsDict[id].pausedByAll)
               {
                  this._soundsDict[id].pausedByAll = false;
                  this.playSound(id);
               }
            }
            else
            {
               this.playSound(id);
            }
         }
      }
      
      public function addExternalSound($path:String, $name:String, $buffer:Number = 1000, $checkPolicyFile:Boolean = false) : Boolean
      {
         for(var i:int = 0; i < this._sounds.length; i++)
         {
            if(this._sounds[i].name == $name)
            {
               return false;
            }
         }
         var sndObj:Object = new Object();
         var snd:Sound = new Sound(new URLRequest($path),new SoundLoaderContext($buffer,$checkPolicyFile));
         sndObj.name = $name;
         sndObj.sound = snd;
         sndObj.channel = new SoundChannel();
         sndObj.position = 0;
         sndObj.paused = true;
         sndObj.volume = 1;
         sndObj.startTime = 0;
         sndObj.loops = 0;
         sndObj.pausedByAll = false;
         this._soundsDict[$name] = sndObj;
         this._sounds.push(sndObj);
         return true;
      }
      
      public function unmuteAllSounds() : void
      {
         var id:String = null;
         var snd:Object = null;
         var curTransform:SoundTransform = null;
         for(var i:int = 0; i < this._sounds.length; i++)
         {
            id = this._sounds[i].name;
            snd = this._soundsDict[id];
            curTransform = snd.channel.soundTransform;
            curTransform.volume = snd.volume;
            snd.channel.soundTransform = curTransform;
         }
      }
      
      public function isSoundPausedByAll($name:String) : Boolean
      {
         return this._soundsDict[$name].pausedByAll;
      }
      
      public function getSoundObject($name:String) : Sound
      {
         return this._soundsDict[$name].sound;
      }
      
      public function playSound($name:String, $volume:Number = 1, $startTime:Number = 0, $loops:int = 0) : void
      {
         var snd:Object = this._soundsDict[$name];
         snd.volume = $volume;
         snd.startTime = $startTime;
         snd.loops = $loops;
         if(snd.paused)
         {
            snd.channel = snd.sound.play(snd.position,snd.loops,new SoundTransform(snd.volume));
         }
         else
         {
            snd.channel = snd.sound.play($startTime,snd.loops,new SoundTransform(snd.volume));
         }
         snd.paused = false;
      }
   }
}
