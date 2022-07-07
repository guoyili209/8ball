package com
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.getDefinitionByName;
   
   public class ParticleExplosion extends MovieClip
   {
       
      
      private var _holder:MovieClip;
      
      private var _splatterArray:Array;
      
      private var _numSplatters:uint;
      
      private var _gravity:Number;
      
      private var _particleAlpha:Number = 0;
      
      private var _alphaInc:Boolean = true;
      
      private var _fadeAmount:Number;
      
      public function ParticleExplosion(className:String, numSplatters:uint, scale:Number, gravity:Number, fadeAmount:Number, upImpulse:Number, spread:Number)
      {
         var ClassReference:Class = null;
         var mc:MovieClip = null;
         this._splatterArray = new Array();
         super();
         this._numSplatters = numSplatters;
         this._gravity = gravity;
         this._fadeAmount = fadeAmount;
         this._holder = new MovieClip();
         for(var n:* = 1; n <= this._numSplatters; n++)
         {
            // ClassReference = getDefinitionByName(className) as Class;
            mc = new star_mc();
            this._splatterArray[n] = mc;
            this._holder.addChild(this._splatterArray[n]);
            this._splatterArray[n].scaleX = scale;
            this._splatterArray[n].scaleY = scale;
            this._splatterArray[n].omega = Math.random() * 5 - 2.5;
            if(gravity != 0)
            {
               this._splatterArray[n].splatSpeedY = -upImpulse - Math.random() * upImpulse;
            }
            else
            {
               this._splatterArray[n].splatSpeedY = -spread + Math.random() * spread * 2;
            }
            this._splatterArray[n].splatSpeedX = -spread + Math.random() * spread * 2;
         }
         this.addChild(this._holder);
      }
      
      public function Start() : void
      {
         addEventListener(Event.ENTER_FRAME,this.update);
      }
      
      private function update(e:Event) : void
      {
         for(var n:* = 1; n <= this._numSplatters; n++)
         {
            if(this._splatterArray[n] != undefined && this._splatterArray[n] != 0)
            {
               this._splatterArray[n].x += this._splatterArray[n].splatSpeedX;
               this._splatterArray[n].y += this._splatterArray[n].splatSpeedY;
               this._splatterArray[n].splatSpeedY += this._gravity;
               this._splatterArray[n].rotation += this._splatterArray[n].omega;
            }
         }
         this._holder.alpha = this._particleAlpha;
         if(this._alphaInc == true)
         {
            this._particleAlpha += 0.1;
         }
         else
         {
            this._particleAlpha -= this._fadeAmount;
         }
         if(this._particleAlpha >= 1 && this._alphaInc == true)
         {
            this._alphaInc = false;
         }
         if(this._particleAlpha <= 0 && this._alphaInc == false)
         {
            e.target.removeEventListener(Event.ENTER_FRAME,this.update);
            e.target.parent.removeChild(this);
         }
      }
   }
}
