package
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mochi.MochiServices;
   
   public dynamic class PoolMain extends MovieClip
   {
       
      
      private var poolTable:Pool;
      
      private var challengePool:ChallengePool;
      
      private var myMenu:MenuMc;
      
      private var arcadePool:ArcadePool;
      
      public var _mochiads_game_id:String;
      
      private var poolAi:PoolAi;
      
      var miniIndex:uint = 0;
      
      private var aiChallengePool:AiChallengePool;
      
      var miniLoad:Miniload;
      
      var challengeScore:Number = 0;
      
      public function PoolMain()
      {
         var _loc1_:* = undefined;
         challengeScore = 0;
         miniIndex = 0;
         super();
         stop();
         miniIndex = 1;
         miniLoad = new Miniload();
         addChild(miniLoad);
         miniLoad.gotoAndStop(miniIndex);
         _loc1_ = new Timer(30,100);
         _loc1_.addEventListener(TimerEvent.TIMER,showMinijuego);
         _loc1_.start();
      }
      
      function init8BallPool() : *
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         _loc1_ = this.numChildren;
         while(_loc1_--)
         {
            this.removeChildAt(_loc1_);
         }
         poolAi = new PoolAi(this,8);
         poolAi.x = 0;
         poolAi.y = -5;
         addChild(poolAi);
         _loc2_ = new Sprite();
         _loc2_.addChild(poolAi.poolTable.miniBtn);
         poolAi.poolTable.addChild(_loc2_);
         MochiServices.addLinkEvent("http://x.mochiads.com/link/0edbed78cd69711a","http://www.minijuegos.com/",_loc2_);
      }
      
      function initStraightPool() : *
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         _loc1_ = this.numChildren;
         while(_loc1_--)
         {
            this.removeChildAt(_loc1_);
         }
         poolAi = new PoolAi(this,7);
         poolAi.x = 0;
         poolAi.y = -5;
         addChild(poolAi);
         _loc2_ = new Sprite();
         _loc2_.addChild(poolAi.poolTable.miniBtn);
         poolAi.poolTable.addChild(_loc2_);
         MochiServices.addLinkEvent("http://x.mochiads.com/link/0edbed78cd69711a","http://www.minijuegos.com/",_loc2_);
      }
      
      function initArcade() : *
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         _loc1_ = this.numChildren;
         while(_loc1_--)
         {
            this.removeChildAt(_loc1_);
         }
         arcadePool = new ArcadePool(this);
         arcadePool.x = 0;
         arcadePool.y = -5;
         addChild(arcadePool);
         _loc2_ = new Sprite();
         _loc2_.addChild(arcadePool.poolTable.miniBtn);
         arcadePool.poolTable.addChild(_loc2_);
         MochiServices.addLinkEvent("http://x.mochiads.com/link/0edbed78cd69711a","http://www.minijuegos.com/",_loc2_);
      }
      
      function showMinijuego(param1:TimerEvent) : *
      {
         ++miniIndex;
         if(miniIndex >= 100)
         {
            param1.currentTarget.stop();
            removeChild(miniLoad);
            myMenu = new MenuMc(this);
            addChild(myMenu);
            challengeScore = 0;
         }
         else
         {
            miniLoad.gotoAndStop(miniIndex);
         }
      }
      
      function frame1() : *
      {
         _mochiads_game_id = "a2e24749f23b30c2";
         MochiServices.connect("a2e24749f23b30c2",root,onConnectError);
         stop();
      }
      
      function initChallenge(param1:*) : *
      {
         var i:int = 0;
         var container:Sprite = null;
         var levelNum:* = param1;
         i = this.numChildren;
         while(i--)
         {
            this.removeChildAt(i);
         }
         if(levelNum >= 6)
         {
            aiChallengePool = new AiChallengePool(this,levelNum);
            aiChallengePool.x = 0;
            aiChallengePool.y = -5;
            addChild(aiChallengePool);
            try
            {
               container = new Sprite();
               container.addChild(aiChallengePool.poolTable.miniBtn);
               aiChallengePool.poolTable.addChild(container);
               MochiServices.addLinkEvent("http://x.mochiads.com/link/0edbed78cd69711a","http://www.minijuegos.com/",container);
            }
            catch(ex:*)
            {
            }
         }
         else
         {
            challengePool = new ChallengePool(this,levelNum);
            challengePool.x = 0;
            challengePool.y = -5;
            addChild(challengePool);
            try
            {
               container = new Sprite();
               container.addChild(challengePool.poolTable.miniBtn);
               challengePool.poolTable.addChild(container);
               MochiServices.addLinkEvent("http://x.mochiads.com/link/0edbed78cd69711a","http://www.minijuegos.com/",container);
            }
            catch(ex:*)
            {
            }
         }
      }
      
      function initPractice() : *
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         _loc1_ = this.numChildren;
         while(_loc1_--)
         {
            this.removeChildAt(_loc1_);
         }
         poolTable = new Pool(this);
         poolTable.x = 0;
         poolTable.y = -5;
         addChild(poolTable);
         _loc2_ = new Sprite();
         _loc2_.addChild(poolTable.poolTable.miniBtn);
         poolTable.poolTable.addChild(_loc2_);
         MochiServices.addLinkEvent("http://x.mochiads.com/link/0edbed78cd69711a","http://www.minijuegos.com/",_loc2_);
      }
      
      public function onConnectError(param1:String) : void
      {
      }
      
      public function resetAll() : *
      {
         var _loc1_:int = 0;
         _loc1_ = this.numChildren;
         while(_loc1_--)
         {
            this.removeChildAt(_loc1_);
         }
         myMenu = new MenuMc(this);
         addChild(myMenu);
         challengeScore = 0;
      }
   }
}
