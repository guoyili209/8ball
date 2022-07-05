package view
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import model.Config;
   
   public class TableMultiplierStars extends Sprite
   {
      
      private static var multiplierClass:Class = TableMultiplierStars_multiplierClass;
       
      
      private var multiplier_arr:Array;
      
      private var isAllStop:Boolean;
      
      private var time:int;
      
      public function TableMultiplierStars()
      {
         var multiplier:MovieClip = null;
         super();
         this.multiplier_arr = new Array();
         for(var i:int = 0; i < 6; i++)
         {
            multiplier = new multiplierClass();
            multiplier.multiplierMc.multiplierMcNum.gotoAndStop(1);
            multiplier.x = Config.POCKET_AMIN_POS[i][0];
            multiplier.y = Config.POCKET_AMIN_POS[i][1];
            this.isAllStop = true;
            multiplier.visible = false;
            addChild(multiplier);
            this.multiplier_arr.push(multiplier);
         }
      }
      
      public function closeMultiplier(num:Number = -1) : void
      {
         for(var i:int = 0; i < 6; i++)
         {
            this.multiplier_arr[i].visible = false;
         }
         if(num != -1)
         {
            this.multiplier_arr[num].visible = true;
            this.multiplier_arr[num].gotoAndPlay(2);
            this.multiplier_arr[num].addEventListener(Event.ENTER_FRAME,this.multiplierEvent);
         }
      }
      
      private function randomsort(a:*, b:*) : *
      {
         return Math.random() > 0.5 ? -1 : 1;
      }
      
      public function chooseMultiplier(num:Number) : Boolean
      {
         if(this.multiplier_arr[num].visible == true)
         {
            return true;
         }
         return false;
      }
      
      public function showMultiplier(num:Number) : void
      {
         var _num:Number = num - 1;
         if(_num >= 7)
         {
            _num = 6;
         }
         var arr:Array = new Array();
         for(var i:int = 0; i < 6; i++)
         {
            arr.push(i);
         }
         arr.sort(this.randomsort);
         for(var j:int = 0; j < 7 - _num; j++)
         {
            this.multiplier_arr[arr[j]].gotoAndStop(1);
            this.multiplier_arr[arr[j]].multiplierMc.multiplierMcNum.gotoAndStop(_num);
            this.multiplier_arr[arr[j]].visible = true;
         }
      }
      
      private function multiplierEvent(event:Event) : void
      {
         if(event.currentTarget.currentFrame >= 28)
         {
            event.currentTarget.visible = false;
            event.currentTarget.removeEventListener(Event.ENTER_FRAME,this.multiplierEvent);
         }
      }
   }
}
