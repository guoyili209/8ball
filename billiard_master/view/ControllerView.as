package view
{
   import com.greensock.TweenLite;
   import controller.StatesController;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import sound.SoundContain;
   
   public class ControllerView extends Sprite
   {
      
      private static var soundOffClass:Class = ControllerView_soundOffClass;
      
      private static var pauseClass:Class = ControllerView_pauseClass;
      
      private static var soundOnClass:Class = ControllerView_soundOnClass;
       
      
      private var pauseBtn:Sprite;
      
      private var outObj:Sprite;
      
      private var soundOnBtn:Sprite;
      
      private var inObj:Sprite;
      
      private var soundOffBtn:Sprite;
      
      private var soundIsOn:Boolean;
      
      public function ControllerView()
      {
         super();
         this.init();
         this.x = -30;
         this.y = -70;
      }
      
      private function gamePauseHandler(event:MouseEvent) : void
      {
         StatesController.gamePause();
      }
      
      private function init() : void
      {
         this.pauseBtn = new pauseClass();
         this.pauseBtn.buttonMode = true;
         this.pauseBtn.x = 630;
         this.pauseBtn.y = 460;
         this.pauseBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.gamePauseHandler);
         addChild(this.pauseBtn);
         this.soundOffBtn = new soundOffClass();
         this.soundOffBtn.buttonMode = true;
         this.soundOffBtn.visible = false;
         this.soundOffBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.soundTurnHandler);
         addChild(this.soundOffBtn);
         this.soundOffBtn.x = 540;
         this.soundOffBtn.y = 460;
         this.soundOnBtn = new soundOnClass();
         this.soundOnBtn.buttonMode = true;
         this.soundOnBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.soundTurnHandler);
         addChild(this.soundOnBtn);
         this.soundIsOn = true;
         this.soundOnBtn.x = 540;
         this.soundOnBtn.y = 460;
      }
      
      private function soundTurnHandler(event:MouseEvent) : void
      {
         if(this.soundIsOn)
         {
            this.inObj = this.soundOffBtn;
            this.outObj = this.soundOnBtn;
            this.soundIsOn = false;
            SoundContain.stopAllSound();
         }
         else
         {
            this.inObj = this.soundOnBtn;
            this.outObj = this.soundOffBtn;
            this.soundIsOn = true;
            SoundContain.playAllSound();
         }
         this.inObj.visible = true;
         this.inObj.alpha = 1;
         this.outObj.alpha = 1;
         TweenLite.from(this.inObj,0.5,{
            "alpha":0,
            "onComplete":function():void
            {
               inObj = null;
            }
         });
         TweenLite.to(this.outObj,0.5,{
            "alpha":0,
            "onComplete":function():void
            {
               outObj.visible = false;
               outObj = null;
            }
         });
      }
   }
}
