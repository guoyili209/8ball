package
{
   import controller.StatesController;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import mochi.as3.MochiAd;
   import view.Game;
   import view.GameOverView;
   import view.StartSplash;
   import view.visualball.BallRender;
   
   public dynamic class MainView extends MovieClip
   {
      
      private static var EMBEDDED_FONT:String = "MainView_EMBEDDED_FONT";
      
      public static var Instance:MainView;
       
      
      private var _gameLayer:Sprite;
      
      private var gameover:GameOverView;
      
      private var splash:StartSplash;
      
      private var game:Game;
      
      public function MainView()
      {
         var obj:Object = null;
         super();
         Instance = this;
         this.stage.frameRate = 60;
         this._gameLayer = new Sprite();
         addChild(this._gameLayer);
         var isLoade:Boolean = false;
         if(isLoade == false)
         {
            obj = new Object();
            obj.res = "740x520";
            obj.id = "c6ab91440fac836c";
            obj.clip = this;
            obj.ad_finished = this.init;
            MochiAd.showPreGameAd(obj);
         }
      }
      
      private function gameOverHandler() : void
      {
         this.gameover.x = 370;
         this.gameover.y = 259;
         this.gameover.show(this._gameLayer);
      }
      
      private function init(e:Event = null) : void
      {
         Debug.printInit("init","init");
         Debug.printInit(this.loaderInfo.bytesLoaded,"bytesLoaded");
         BallRender.setRadius(9.5);
         this.stage.scaleMode = StageScaleMode.NO_SCALE;
         this.game = new Game();
         this.gameover = new GameOverView();
         this.splash = new StartSplash(stage.frameRate);
         removeEventListener(Event.ADDED_TO_STAGE,this.init);
         StatesController.dispatcher.addEventListener(StatesController.STATES_CHANGE,this.statesChangeHandler);
         this.replayAllHandler();
      }
      
      private function startGameHandler(event:Event = null) : void
      {
         if(this.gameover.parent)
         {
            this.gameover.parent.removeChild(this.gameover);
         }
         if(this.game.parent == null)
         {
            this._gameLayer.addChild(this.game);
         }
         StatesController.changeStates(StatesController.PLAY);
         if(this.splash.parent)
         {
            this.splash.removeEventListener(StartSplash.PLAY_DOWN,this.startGameHandler);
            this.splash.parent.removeChild(this.splash);
         }
         this._gameLayer.mouseChildren = true;
      }
      
      private function replayAllHandler() : void
      {
         this._gameLayer.mouseChildren = true;
         StatesController.changeStates(StatesController.START);
         if(this.gameover.parent)
         {
            this.gameover.parent.removeChild(this.gameover);
         }
         this.splash.addEventListener(StartSplash.PLAY_DOWN,this.startGameHandler);
         this._gameLayer.addChild(this.splash);
         this.splash.start();
      }
      
      private function statesChangeHandler(event:Event) : void
      {
         if(StatesController.curStates == StatesController.START)
         {
            this.replayAllHandler();
         }
         else if(StatesController.curStates == StatesController.END)
         {
            this.gameOverHandler();
         }
      }
      
      private function showInviteHandler(event:Event) : void
      {
      }
   }
}
