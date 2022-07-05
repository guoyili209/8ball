package view
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.getTimer;
   import model.Config;
   
   public class TablePocketStars extends Sprite
   {
      
      private static var starClass:Class = TablePocketStars_starClass;
       
      
      private var isAllStop:Boolean;
      
      private var stars:Array;
      
      private var PlayFrame:int = 50;
      
      private var time:int;
      
      public function TablePocketStars()
      {
         var star:MovieClip = null;
         super();
         this.stars = new Array();
         for(var i:int = 0; i < 6; i++)
         {
            star = new starClass();
            star.gotoAndStop(18);
            star.x = Config.POCKET_AMIN_POS[i][0];
            star.y = Config.POCKET_AMIN_POS[i][1];
            this.isAllStop = true;
            addChild(star);
            this.stars.push(star);
         }
      }
      
      private function playFrameHandler(event:Event) : void
      {
         var star:MovieClip = null;
         var s:int = getTimer() - this.time;
         if(s > 30)
         {
            this.time = getTimer();
            this.isAllStop = true;
            for each(star in this.stars)
            {
               if(star.currentFrame < star.totalFrames)
               {
                  star.gotoAndStop(star.currentFrame + 1);
                  this.isAllStop = false;
               }
            }
            if(this.isAllStop)
            {
               this.removeEventListener(Event.ENTER_FRAME,this.playFrameHandler);
            }
         }
      }
      
      public function play(num:int) : void
      {
         var star:MovieClip = this.stars[num];
         star.gotoAndPlay(0);
         this.time = getTimer();
         this.addEventListener(Event.ENTER_FRAME,this.playFrameHandler);
      }
   }
}
