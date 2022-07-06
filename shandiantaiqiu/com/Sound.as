package com
{
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   public class Sound
   {
      
      public static var on:Boolean = true;
       
      
      public function Sound()
      {
         super();
      }
      
      public static function Play(type:String, volume:Number = 1) : void
      {
         var sound:* = undefined;
         var sfxChannel:SoundChannel = null;
         var sfxTransform:SoundTransform = null;
         if(on)
         {
            switch(type)
            {
               case "cue":
                  sound = new cueHit();
                  break;
               case "ball":
                  sound = new ballHit();
                  break;
               case "cushion":
                  sound = new cushionHit();
                  break;
               case "pocket":
                  sound = new pocketHit();
            }
            sfxChannel = new SoundChannel();
            sfxTransform = new SoundTransform(volume);
            sfxChannel = sound.play(0,0,sfxTransform);
         }
      }
   }
}
