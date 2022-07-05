package view
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import sound.SoundContain;
   
   public class StartSplash extends Sprite
   {
      
      public static const PLAY_DOWN:String = "play down";
       
      
      private var _back:MovieClip;
      
      private var playBtn:SimpleButton;
      
      private var time:int = 0;
      
      private var backClass:Class;
      
      private var inviteBtn:SimpleButton;
      
      private var howToPlayBtn:SimpleButton;
      
      private var playBoo:Boolean;
      
      private var PlayFrame:int = 1;
      
      public function StartSplash(frame:Number)
      {
         this.backClass = StartSplash_backClass;
         super();
         this._back = new this.backClass();
         this.time = getTimer();
         this.playBtn = this._back.playBtn;
         this.howToPlayBtn = this._back.howToPlayBtn;
         this._back.helpMc.visible = false;
         this._back.helpMc.gotoAndStop(1);
         this.playBoo = false;
         this.howToPlayBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.howToPlayHandler);
         this.playBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.playHandler);
         addChild(this._back);
      }
      
      private function backEvent(event:Event) : void
      {
         if(this.playBoo == false)
         {
            event.currentTarget.gotoAndStop(1);
         }
         else if(event.currentTarget.currentFrame == 69)
         {
            this.playBoo = false;
            event.currentTarget.removeEventListener(Event.ENTER_FRAME,this.backEvent);
            dispatchEvent(new Event(PLAY_DOWN));
         }
      }
      
      private function howToPlayHandler(event:MouseEvent) : void
      {
         this._back.helpMc.visible = true;
         this._back.helpMc.gotoAndStop(2);
         this._back.helpMc.nextPageBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.nextPageHandler);
         this._back.helpMc.addEventListener(Event.ENTER_FRAME,this.helpMcEnterFrame);
      }
      
      private function nextPageHandler(event:MouseEvent) : void
      {
         this._back.helpMc.gotoAndPlay(60);
         this._back.helpMc.nextPageBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.nextPageHandler);
         this._back.helpMc.prevPageBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.prevPageHandler);
         this._back.helpMc.closePageBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closePageHandler);
      }
      
      private function prevPageHandler(event:MouseEvent) : void
      {
         this._back.helpMc.prevPageBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.prevPageHandler);
         this._back.helpMc.closePageBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.closePageHandler);
         this._back.helpMc.nextPageBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.nextPageHandler);
         this._back.helpMc.gotoAndStop(2);
      }
      
      private function helpMcEnterFrame(event:Event) : void
      {
         if(this._back.helpMc.currentFrame == 108)
         {
            this._back.helpMc.stop();
         }
         if(this._back.helpMc.currentFrame == 170)
         {
            this._back.helpMc.gotoAndStop(1);
            this._back.helpMc.visible = false;
            this._back.helpMc.removeEventListener(Event.ENTER_FRAME,this.helpMcEnterFrame);
         }
      }
      
      private function frameHandler(event:Event) : void
      {
         var curFrame:int = this._back.currentFrame;
         if(curFrame == 40)
         {
            SoundContain.playSound(SoundContain.LOGO_IMPACT);
         }
         if(getTimer() - this.time > this.PlayFrame)
         {
            this.time = getTimer();
            if(curFrame + 1 < this._back.totalFrames)
            {
               this._back.gotoAndStop(curFrame + 1);
            }
            else
            {
               this._back.removeEventListener(Event.ENTER_FRAME,this.frameHandler);
            }
         }
      }
      
      private function closePageHandler(event:MouseEvent) : void
      {
         this._back.helpMc.gotoAndPlay(109);
         this._back.helpMc.prevPageBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.prevPageHandler);
         this._back.helpMc.closePageBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.closePageHandler);
      }
      
      public function start() : void
      {
         this._back.addEventListener(Event.ENTER_FRAME,this.backEvent);
         this._back.gotoAndStop(0);
         this._back.addEventListener(Event.ENTER_FRAME,this.frameHandler);
      }
      
      private function myRemoveEvent() : void
      {
         if(this._back.helpMc.hasEventListener(Event.ENTER_FRAME))
         {
            this._back.helpMc.removeEventListener(Event.ENTER_FRAME,this.helpMcEnterFrame);
         }
         if(this._back.helpMc.nextPageBtn.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            this._back.helpMc.nextPageBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.nextPageHandler);
         }
         if(this._back.helpMc.prevPageBtn.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            this._back.helpMc.prevPageBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.prevPageHandler);
         }
         if(this._back.helpMc.closePageBtn.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            this._back.helpMc.closePageBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.closePageHandler);
         }
      }
      
      private function playHandler(event:MouseEvent) : void
      {
         this.playBoo = true;
      }
   }
}
