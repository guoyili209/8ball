package view
{
   import controller.StatesController;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import model.Config;
   import model.GameData;
   import sound.SoundContain;
   
   public class GameOverView extends Sprite
   {
      
      private static var backClass:Class = GameOverView_backClass;
      
      public static const GAME_SHOW_INVITE:String = "game show invite";
       
      
      private var streakTF1:TextField;
      
      private var pocketNumTF:TextField;
      
      private var scoreTF:TextField;
      
      private var rackTF:TextField;
      
      private var _scoreMcs:Array;
      
      private var rackTF1:TextField;
      
      private var shotNumTF1:TextField;
      
      private var shotPerTimeTF:TextField;
      
      private var totalTimeTF:TextField;
      
      private var shotNumTF:TextField;
      
      private var accuracyTF1:TextField;
      
      private var back:MovieClip;
      
      private var accuracyTF:TextField;
      
      private var scoreTF1:TextField;
      
      private var totalTimeTF1:TextField;
      
      private var pocketNumTF1:TextField;
      
      private var streakTF:TextField;
      
      private var shotPerTimeTF1:TextField;
      
      private var _medalNum:int = 0;
      
      public function GameOverView()
      {
         super();
         this.init();
      }
      
      private function backEnterFrame(event:Event) : void
      {
         if(this.back.currentFrame == 66)
         {
            this.back.stop();
            this.back.removeEventListener(Event.ENTER_FRAME,this.backEnterFrame);
         }
      }
      
      public function show(_container:DisplayObjectContainer) : void
      {
         this.back.gotoAndPlay(1);
         this.back.addEventListener(Event.ENTER_FRAME,this.backEnterFrame);
         ++GameData.playNum;
         this._medalNum = 0;
         while(this._medalNum < Config.MEDAL_SCORE.length)
         {
            if(GameData.score < Config.MEDAL_SCORE[this._medalNum] * 1000)
            {
               break;
            }
            ++this._medalNum;
         }
         this.scoreTF.text = GameData.score.toString();
         this.scoreTF1.text = GameData.score.toString();
         this.pocketNumTF.text = GameData.gameTotalPocket + " Ball";
         this.pocketNumTF1.text = GameData.gameTotalPocket + " Ball";
         var accuracy:Number = GameData.hitNum == 0 ? Number(0) : Number(GameData.gameTotalPocket / GameData.hitNum * 100);
         accuracy = accuracy > 100 ? Number(100) : Number(accuracy);
         this.accuracyTF.text = accuracy == 0 ? "N/A" : accuracy.toFixed(1) + "%";
         this.accuracyTF1.text = accuracy == 0 ? "N/A" : accuracy.toFixed(1) + "%";
         this.rackTF.text = "Rack " + GameData.rack;
         this.rackTF1.text = "Rack " + GameData.rack;
         this.streakTF.text = GameData.maxHit == 0 ? "No Streak" : GameData.maxHit + " Shots in a row";
         this.streakTF1.text = GameData.maxHit == 0 ? "No Streak" : GameData.maxHit + " Shots in a row";
         if(GameData.score <= 0)
         {
            this.back.gameOver2.visible = false;
            this.back.gameOver1.visible = true;
         }
         else
         {
            this.back.gameOver1.visible = false;
            this.back.gameOver2.visible = true;
            this.back.gameOver2.medalMc.gotoAndStop(1);
         }
         _container.addChild(this);
         this.alpha = 1;
      }
      
      private function init() : void
      {
         this.back = new backClass();
         this.back.gotoAndStop(1);
         this.back.mask = this.back.maskMc;
         addChild(this.back);
         this.back.visible = true;
         this.back.gameOver1.replayBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.replayDownHandler);
         this.back.gameOver2.closeBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.replayDownHandler);
         this.back.gameOver2.shareBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.shareHandler);
         this.scoreTF = this.back.gameOver1.scoreMc.scoreTF;
         this.scoreTF1 = this.back.gameOver2.scoreMc.scoreTF;
         this.pocketNumTF = this.back.gameOver1.score2.pocketNumTF;
         this.pocketNumTF1 = this.back.gameOver2.score2.pocketNumTF;
         this.accuracyTF = this.back.gameOver1.score3.accuracyTF;
         this.accuracyTF1 = this.back.gameOver2.score3.accuracyTF;
         this.rackTF = this.back.gameOver1.score4.rackTF;
         this.rackTF1 = this.back.gameOver2.score4.rackTF;
         this.streakTF = this.back.gameOver1.score5.streakTF;
         this.streakTF1 = this.back.gameOver2.score5.streakTF;
      }
      
      private function showScore() : void
      {
         if(GameData.score > 0)
         {
            this.showMedal();
            SoundContain.playSound(SoundContain.LOGO_IMPACT);
         }
      }
      
      private function replayDownHandler(event:MouseEvent = null) : void
      {
         StatesController.changeStates(StatesController.START);
      }
      
      private function shareHandler(event:MouseEvent) : void
      {
         var obj:Object = new Object();
         obj.cupNum = GameData.cupNum;
         obj.score = GameData.score;
         obj.isHigh = GameData.isHighScore;
         this.replayDownHandler();
      }
      
      private function showMedal() : void
      {
      }
   }
}
