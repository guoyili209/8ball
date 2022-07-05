package view
{
   import controller.StatesController;
   import controller.TimeController;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import model.Config;
   import model.GameData;
   
   public class Game extends Sprite
   {
      
      public static var game:Game;
       
      
      private var _pauseLayer:PauseView;
      
      private var _container:DisplayObjectContainer;
      
      private var pauseFlag:Boolean = false;
      
      private var table:TableView;
      
      private var backTimeSp:StartTimePlay;
      
      public var scoreView:ScoreView;
      
      public function Game()
      {
         super();
         this._container = this;
         game = this;
         this.addEventListener(Event.ADDED_TO_STAGE,this.init);
      }
      
      private function timeActive(event:Event) : void
      {
         ++GameData.gameTotalTime;
         --GameData.leftTime;
         if(GameData.leftTime < 0)
         {
            GameData.leftTime = 0;
         }
         ScoreView.setLeftTime(GameData.leftTime);
      }
      
      public function get isStartTime() : Boolean
      {
         return this.backTimeSp.parent != null;
      }
      
      private function gameOverHandler(event:Event) : void
      {
         StatesController.changeStates(StatesController.END);
      }
      
      private function init(event:Event) : void
      {
         this.table = new TableView();
         this.table.x = 55;
         this.table.y = 90;
         this._container.addChild(this.table);
         this.backTimeSp = new StartTimePlay();
         this.backTimeSp.x = 115;
         this.backTimeSp.y = 185;
         this.backTimeSp.addEventListener(StartTimePlay.START_PLAY,this.startGame);
         TimeController.Instanse.addEventListener(TimeController.TIME_PLAY,this.timeActive);
         TimeController.Instanse.addEventListener(TimeController.TIME_END,this.gameOverHandler);
         this._pauseLayer = new PauseView();
         this._pauseLayer.show(true);
         addChild(this._pauseLayer);
         this._pauseLayer.addChild(ScoreView.Instanse);
         StatesController.dispatcher.addEventListener(StatesController.STATES_CHANGE,this.statesChangeHandler);
         this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyHandler);
      }
      
      private function keyHandler(event:KeyboardEvent) : void
      {
      }
      
      private function statesChangeHandler(event:Event) : void
      {
         if(StatesController.curStates == StatesController.PAUSE)
         {
            if(this.isStartTime)
            {
               this.backTimeSp.visible = false;
               this.backTimeSp.pause(true);
            }
            this.pauseFlag = this._pauseLayer.backPauseMc(true);
         }
         else if(StatesController.curStates == StatesController.PLAY)
         {
            this.backTimeSp.visible = true;
            this.backTimeSp.pause(false);
            if(StatesController.lastStates != StatesController.PAUSE)
            {
               this.gameStart();
            }
         }
         else if(StatesController.curStates == StatesController.REPLAY)
         {
            StatesController.changeStates(StatesController.PLAY);
         }
         if(StatesController.curStates == StatesController.END)
         {
            this.mouseChildren = false;
            this.mouseEnabled = false;
         }
         else
         {
            this.mouseChildren = true;
            this.mouseEnabled = true;
         }
      }
      
      private function startGame(event:Event = null) : void
      {
         if(this.backTimeSp.parent)
         {
            this.backTimeSp.parent.removeChild(this.backTimeSp);
         }
         this.table.startPlay();
         TimeController.Instanse.play();
      }
      
      public function gameStart() : void
      {
         this._pauseLayer.backPauseMc(true,true);
         GameData.reset();
         GameData.leftTime = Config.GAME_TOTAL_TIME;
         this.table.setBallsVisible(false);
         this.backTimeSp.start();
         this.table.setRackNumStart(GameData.rack);
      }
   }
}
