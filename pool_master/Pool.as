package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class Pool extends MovieClip
   {
       
      
      private var pa:PointAnim;
      
      private var scratch:Boolean = false;
      
      private var poolMain:PoolMain;
      
      private var power:Power;
      
      var poolTable:MovieClip;
      
      private var ballsPocketed:uint;
      
      private var dampCollision:Number = 0.99;
      
      private var numberOfBalls:uint = 16;
      
      private var shotPower:Number;
      
      private var ballList:Array;
      
      private var soundVol:SoundTransform;
      
      private var isSoundPlaying:Boolean = false;
      
      private var dampK:Number = 0.99;
      
      private var gameStartTime:uint;
      
      private var stick:Stick;
      
      private var numScratch:uint = 0;
      
      private var myGuide:MovieClip;
      
      private var myChannel:SoundChannel;
      
      private var shots:uint;
      
      private var firstRun:Boolean = true;
      
      private var cueBall:Ball;
      
      private var angle:Number;
      
      private var stickCont:MovieClip;
      
      public function Pool(param1:*)
      {
         numberOfBalls = 16;
         ballList = new Array(numberOfBalls);
         scratch = false;
         dampCollision = 0.99;
         dampK = 0.99;
         isSoundPlaying = false;
         soundVol = new SoundTransform();
         firstRun = true;
         numScratch = 0;
         super();
         this.poolMain = param1;
         gameStartTime = getTimer();
         initGame();
      }
      
      function borderHitTest(param1:*) : *
      {
         var _loc2_:* = undefined;
         _loc2_ = param1.ball_itself;
         if(_loc2_.hitTestObject(poolTable.border1) && param1.currentHit != 1)
         {
            param1.currentHit = 1;
            ++param1.y;
            param1.vy *= -dampCollision;
            param1.vx *= dampCollision;
            handleBorderHit(param1);
         }
         else if(_loc2_.hitTestObject(poolTable.border2) && param1.currentHit != 2)
         {
            param1.vy *= -dampCollision;
            param1.vx *= dampCollision;
            param1.currentHit = 2;
            ++param1.y;
            handleBorderHit(param1);
         }
         else if(_loc2_.hitTestObject(poolTable.border3) && param1.currentHit != 3)
         {
            param1.vy *= dampCollision;
            param1.vx *= -dampCollision;
            param1.currentHit = 3;
            --param1.x;
            handleBorderHit(param1);
         }
         else if(_loc2_.hitTestObject(poolTable.border4) && param1.currentHit != 4)
         {
            param1.vy *= -dampCollision;
            param1.vx *= dampCollision;
            param1.currentHit = 4;
            --param1.y;
            handleBorderHit(param1);
         }
         else if(_loc2_.hitTestObject(poolTable.border5) && param1.currentHit != 5)
         {
            param1.vy *= -dampCollision;
            param1.vx *= dampCollision;
            param1.currentHit = 5;
            --param1.y;
            handleBorderHit(param1);
         }
         else if(_loc2_.hitTestObject(poolTable.border6) && param1.currentHit != 6)
         {
            param1.vy *= dampCollision;
            param1.vx *= -dampCollision;
            param1.currentHit = 6;
            ++param1.x;
            handleBorderHit(param1);
         }
      }
      
      function rotateStick(param1:MouseEvent) : void
      {
         var x1:* = undefined;
         var y1:* = undefined;
         var event:MouseEvent = param1;
         try
         {
            x1 = stickCont.mouseX;
            y1 = stickCont.mouseY;
            angle = Math.atan(y1 / x1) / (Math.PI / 180);
            if(x1 < 0)
            {
               angle += 180;
            }
            if(x1 >= 0 && y1 < 0)
            {
               angle += 360;
            }
            angle += 180;
            stick.rotation = angle;
            try
            {
               if(myGuide)
               {
                  removeChild(myGuide);
               }
            }
            catch(ex:*)
            {
            }
            myGuide = null;
            myGuide = new MovieClip();
            myGuide.graphics.lineStyle(1,16777164,10);
            myGuide.graphics.moveTo(cueBall.x,cueBall.y);
            myGuide.graphics.lineTo(mouseX,mouseY);
            addChild(myGuide);
         }
         catch(ex1:*)
         {
         }
      }
      
      function takeShot(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         removeEventListener(MouseEvent.MOUSE_MOVE,rotateStick);
         removeEventListener(MouseEvent.MOUSE_DOWN,startStickAnim);
         removeEventListener(MouseEvent.MOUSE_UP,takeShot);
         stick.gotoAndStop(1);
         power.gotoAndStop(1);
         shotPower = power.sPower / 85;
         playCueToBallSound(shotPower);
         angle = (180 + angle) * Math.PI / 180;
         cueBall.vx = shotPower * Math.cos(angle);
         cueBall.vy = shotPower * Math.sin(angle);
         try
         {
            if(myGuide)
            {
               removeChild(myGuide);
            }
            if(power)
            {
               removeChild(power);
            }
            if(stickCont)
            {
               removeChild(stickCont);
            }
         }
         catch(e:*)
         {
         }
         myGuide = null;
         power = null;
         gameStart();
      }
      
      function initGame() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:* = undefined;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         poolTable = new PoolTable();
         firstRun = true;
         shots = 0;
         ballsPocketed = 0;
         poolTable.ballsPocketed = 0;
         angle = 0;
         shotPower = 0;
         scratch = false;
         numScratch = 0;
         addChild(poolTable);
         poolTable.x = 20;
         poolTable.y = 70;
         cueBall = new Ball(new Ball0(),poolTable);
         _loc1_ = 150;
         _loc2_ = 200;
         _loc3_ = 0;
         _loc4_ = 5;
         _loc5_ = [new Ball15(),new Ball14(),new Ball13(),new Ball12(),new Ball11(),new Ball10(),new Ball9(),new Ball8(),new Ball7(),new Ball6(),new Ball5(),new Ball4(),new Ball3(),new Ball2(),new Ball1()];
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc4_ - _loc6_)
            {
               ballList[_loc3_] = new Ball(_loc5_[_loc3_],poolTable);
               ballList[_loc3_].x = _loc1_;
               ballList[_loc3_].y = _loc2_ + 16 * _loc7_;
               addChild(ballList[_loc3_]);
               ballList[_loc3_].poolBall.texture.x += Math.random() * 10;
               ballList[_loc3_].poolBall.texture.y += Math.random() * 10;
               _loc3_++;
               _loc7_++;
            }
            _loc1_ += 16;
            _loc2_ += 8;
            _loc6_++;
         }
         ballList[numberOfBalls - 1] = cueBall;
         cueBall.x = 472;
         cueBall.y = 240;
         addChild(ballList[numberOfBalls - 1]);
         setupCue(null);
         cueBall.startMove();
         _loc6_ = 0;
         while(_loc6_ < numberOfBalls - 1)
         {
            ballList[_loc6_].startMove();
            _loc6_++;
         }
         addEventListener(Event.ENTER_FRAME,showTime);
         poolTable.restartBtn.addEventListener(MouseEvent.CLICK,restartGame);
         poolTable.backBtn.addEventListener(MouseEvent.CLICK,backToMenu);
      }
      
      function playCueToBallSound(param1:*) : *
      {
         var _loc2_:cueSound = null;
         _loc2_ = new cueSound();
         myChannel = _loc2_.play();
         soundVol.volume = param1;
         myChannel.soundTransform = soundVol;
      }
      
      function handleBorderHit(param1:*) : *
      {
         var _loc2_:* = undefined;
         param1.vx *= 0.9;
         param1.vy *= 0.9;
         _loc2_ = Math.sqrt(param1.vx * param1.vx + param1.vy * param1.vy);
         playTableHitSound(_loc2_ + 0.5);
      }
      
      function playPocketSound() : *
      {
         var _loc1_:pocketSound = null;
         _loc1_ = new pocketSound();
         myChannel = _loc1_.play();
         soundVol.volume = 0.5;
         myChannel.soundTransform = soundVol;
      }
      
      function backToMenu(param1:MouseEvent) : *
      {
         var _loc2_:uint = 0;
         removeAllListener();
         _loc2_ = poolTable.numChildren;
         while(_loc2_--)
         {
            poolTable.removeChildAt(_loc2_);
         }
         _loc2_ = this.numChildren;
         while(_loc2_--)
         {
            this.removeChildAt(_loc2_);
         }
         poolMain.resetAll();
      }
      
      function solveBalls(param1:*, param2:*) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         _loc3_ = param1.x;
         _loc4_ = param1.y;
         _loc5_ = param2.x - _loc3_;
         _loc6_ = param2.y - _loc4_;
         _loc7_ = Math.sqrt(_loc5_ * _loc5_ + _loc6_ * _loc6_);
         _loc8_ = 8;
         _loc9_ = _loc5_ / _loc7_;
         _loc10_ = _loc6_ / _loc7_;
         _loc11_ = (_loc3_ + param2.x) / 2;
         _loc12_ = (_loc4_ + param2.y) / 2;
         param1.x = _loc11_ - _loc9_ * _loc8_;
         param1.y = _loc12_ - _loc10_ * _loc8_;
         param2.x = _loc11_ + _loc9_ * _loc8_;
         param2.y = _loc12_ + _loc10_ * _loc8_;
         _loc14_ = (_loc13_ = (param1.vx - param2.vx) * _loc9_ + (param1.vy - param2.vy) * _loc10_) * _loc9_;
         _loc15_ = _loc13_ * _loc10_;
         param1.vx -= _loc14_ * dampCollision;
         param1.vy -= _loc15_ * dampCollision;
         param2.vx += _loc14_ * dampCollision;
         param2.vy += _loc15_ * dampCollision;
      }
      
      public function showTime(param1:Event) : *
      {
         poolTable.gameClock.text = clockTime(getTimer() - gameStartTime);
      }
      
      public function clockTime(param1:int) : *
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc2_ = Math.floor(param1 / 1000);
         _loc3_ = Math.floor(_loc2_ / 60);
         _loc2_ -= _loc3_ * 60;
         return _loc3_ + ":" + String(_loc2_ + 100).substr(1,2);
      }
      
      function onPlaybackComplete(param1:Event) : void
      {
         isSoundPlaying = false;
      }
      
      function setupCue(param1:TimerEvent) : *
      {
         trace("Setting up the cue....");
         cueBall.buttonMode = true;
         cueBall.addEventListener(MouseEvent.MOUSE_DOWN,pickCue);
         this.addEventListener(MouseEvent.MOUSE_UP,dropCue);
         cueBall.ballMC.gotoAndPlay(2);
      }
      
      function gameStart() : *
      {
         var _loc1_:uint = 0;
         firstRun = false;
         shots += 1;
         poolTable.shotsTakenTxt.text = "" + shots;
         poolTable.accuracyTxt.text = "" + Math.round(ballsPocketed / shots * 100) + "%";
         _loc1_ = 0;
         while(_loc1_ < numberOfBalls)
         {
            ballList[_loc1_].currentHit = -1;
            _loc1_++;
         }
         cueBall.isMoving = true;
         addEventListener(Event.ENTER_FRAME,handleCollision);
      }
      
      function restartGame(param1:MouseEvent) : *
      {
         var _loc2_:uint = 0;
         removeAllListener();
         _loc2_ = poolTable.numChildren;
         while(_loc2_--)
         {
            poolTable.removeChildAt(_loc2_);
         }
         _loc2_ = this.numChildren;
         while(_loc2_--)
         {
            this.removeChildAt(_loc2_);
         }
         poolMain.initPractice();
      }
      
      function pickCue(param1:MouseEvent) : void
      {
         var _loc2_:Rectangle = null;
         if(firstRun == true)
         {
            _loc2_ = new Rectangle(472,125,95,230);
         }
         else
         {
            _loc2_ = new Rectangle(72,125,500,230);
         }
         cueBall.startDrag(false,_loc2_);
         cueBall.ballMC.gotoAndStop(1);
      }
      
      function stickAnim(param1:TimerEvent) : *
      {
         cueBall.ballMC.gotoAndStop(1);
         stick = new Stick();
         power = new Power();
         stickCont = new MovieClip();
         stickCont.addChild(stick);
         stickCont.x = cueBall.x;
         stickCont.y = cueBall.y;
         addChild(stickCont);
         rotateStick(null);
         this.addEventListener(MouseEvent.MOUSE_MOVE,rotateStick);
         this.addEventListener(MouseEvent.MOUSE_DOWN,startStickAnim);
      }
      
      function playBallToBallSound(param1:*) : *
      {
         var _loc2_:ballHit = null;
         if(isSoundPlaying == false)
         {
            isSoundPlaying = true;
            _loc2_ = new ballHit();
            myChannel = _loc2_.play();
            soundVol.volume = param1;
            myChannel.soundTransform = soundVol;
            myChannel.addEventListener(Event.SOUND_COMPLETE,onPlaybackComplete);
         }
      }
      
      function startStickAnim(param1:MouseEvent) : void
      {
         addChild(power);
         swapChildren(power,stickCont);
         power.x = 598;
         power.y = 150;
         stick.gotoAndPlay(2);
         power.gotoAndPlay(2);
         this.addEventListener(MouseEvent.MOUSE_UP,takeShot);
         this.removeEventListener(MouseEvent.MOUSE_DOWN,startStickAnim);
      }
      
      function playTableHitSound(param1:*) : *
      {
         var _loc2_:tableHit = null;
         _loc2_ = new tableHit();
         myChannel = _loc2_.play();
         soundVol.volume = param1;
         myChannel.soundTransform = soundVol;
      }
      
      function removeAllListener() : *
      {
         removeEventListener(Event.ENTER_FRAME,showTime);
         poolTable.restartBtn.removeEventListener(MouseEvent.CLICK,restartGame);
         poolTable.backBtn.removeEventListener(MouseEvent.CLICK,backToMenu);
         cueBall.removeEventListener(MouseEvent.MOUSE_DOWN,pickCue);
         this.removeEventListener(MouseEvent.MOUSE_UP,dropCue);
         this.removeEventListener(MouseEvent.MOUSE_MOVE,rotateStick);
         this.removeEventListener(MouseEvent.MOUSE_DOWN,startStickAnim);
         this.removeEventListener(MouseEvent.MOUSE_UP,takeShot);
         removeEventListener(Event.ENTER_FRAME,handleCollision);
      }
      
      function pocHitTrue(param1:*, param2:*) : *
      {
         var temp:Boolean = false;
         var tempTimer:* = undefined;
         var cBall:* = param1;
         var poc:* = param2;
         playPocketSound();
         temp = false;
         if(cBall == cueBall)
         {
            temp = true;
            scratch = true;
            ++numScratch;
            try
            {
               tempTimer = new Timer(1200,1);
               tempTimer.addEventListener(TimerEvent.TIMER,destroyPointAnim);
               tempTimer.start();
               pa = new PointAnim();
               pa.textHolder.dynTxt.text = "-1000";
               addChild(pa);
               pa.x = poc.x + 35;
               pa.y = poc.y + 75;
            }
            catch(ex:*)
            {
            }
         }
         else
         {
            scratch = false;
            ++ballsPocketed;
            poolTable.ballsPocketed = ballsPocketed;
            poolTable.ballsPocketedTxt.text = "" + ballsPocketed;
            poolTable.accuracyTxt.text = "" + Math.round(ballsPocketed / shots * 100) + "%";
            try
            {
               tempTimer = new Timer(1200,1);
               tempTimer.addEventListener(TimerEvent.TIMER,destroyPointAnim);
               tempTimer.start();
               pa = new PointAnim();
               pa.textHolder.dynTxt.text = "+300";
               addChild(pa);
               pa.x = poc.x + 35;
               pa.y = poc.y + 75;
            }
            catch(ex:*)
            {
            }
         }
         cBall.hitPocket(poc.x + 30,poc.y + 80,temp);
      }
      
      function pocketHitTest(param1:*) : *
      {
         var _loc2_:* = undefined;
         _loc2_ = param1.ball_itself;
         if(_loc2_.hitTestObject(poolTable.poc1))
         {
            pocHitTrue(param1,poolTable.poc1);
         }
         else if(_loc2_.hitTestObject(poolTable.poc2))
         {
            pocHitTrue(param1,poolTable.poc2);
         }
         else if(_loc2_.hitTestObject(poolTable.poc3))
         {
            pocHitTrue(param1,poolTable.poc3);
         }
         else if(_loc2_.hitTestObject(poolTable.poc4))
         {
            pocHitTrue(param1,poolTable.poc4);
         }
         else if(_loc2_.hitTestObject(poolTable.poc5))
         {
            pocHitTrue(param1,poolTable.poc5);
         }
         else if(_loc2_.hitTestObject(poolTable.poc6))
         {
            pocHitTrue(param1,poolTable.poc6);
         }
      }
      
      function dropCue(param1:MouseEvent) : void
      {
         cueBall.stopDrag();
         cueBall.removeEventListener(MouseEvent.MOUSE_DOWN,pickCue);
         removeEventListener(MouseEvent.MOUSE_UP,dropCue);
         cueBall.buttonMode = false;
         stickAnim(null);
      }
      
      function destroyPointAnim(param1:TimerEvent) : void
      {
         var e:TimerEvent = param1;
         try
         {
            removeChild(pa);
         }
         catch(ex:*)
         {
         }
      }
      
      function handleCollision(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:uint = 0;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:InfoWin = null;
         var _loc15_:* = undefined;
         _loc2_ = ballList.length - 1;
         while(_loc2_ >= 0)
         {
            if(ballList[_loc2_].isAlive)
            {
               _loc5_ = ballList[_loc2_].x;
               _loc6_ = ballList[_loc2_].y;
               _loc7_ = _loc2_ - 1;
               while(_loc7_ >= 0)
               {
                  if(ballList[_loc7_].isAlive)
                  {
                     _loc8_ = ballList[_loc7_].x - _loc5_;
                     _loc9_ = ballList[_loc7_].y - _loc6_;
                     if((_loc10_ = Math.sqrt(_loc8_ * _loc8_ + _loc9_ * _loc9_)) < 16)
                     {
                        solveBalls(ballList[_loc2_],ballList[_loc7_]);
                        _loc11_ = Math.sqrt(ballList[_loc2_].vx * ballList[_loc2_].vx + ballList[_loc2_].vy * ballList[_loc2_].vy);
                        _loc12_ = Math.sqrt(ballList[_loc7_].vx * ballList[_loc7_].vx + ballList[_loc7_].vy * ballList[_loc7_].vy);
                        playBallToBallSound(_loc11_ + _loc12_);
                        ballList[_loc2_].currentHit = -1;
                        ballList[_loc7_].currentHit = -1;
                     }
                  }
                  _loc7_--;
               }
            }
            _loc2_--;
         }
         _loc3_ = 0;
         _loc4_ = 0;
         while(_loc4_ < numberOfBalls)
         {
            if(ballList[_loc4_].isAlive == true)
            {
               pocketHitTest(ballList[_loc4_]);
               borderHitTest(ballList[_loc4_]);
            }
            if(ballList[_loc4_].isMoving == true)
            {
               _loc3_ = 1;
            }
            _loc4_++;
         }
         if(_loc3_ == 0)
         {
            removeEventListener(Event.ENTER_FRAME,handleCollision);
            if(ballsPocketed >= 15)
            {
               removeAllListener();
               _loc13_ = (getTimer() - gameStartTime) / 1000;
               _loc14_ = new InfoWin(this,poolTable.gameClock.text,shots,Math.round(ballsPocketed / shots * 100),numScratch,_loc13_);
               addChild(_loc14_);
               _loc14_.x = 120;
               _loc14_.y = 75;
            }
            else if(scratch == false)
            {
               stickAnim(null);
            }
            else
            {
               scratch = false;
               (_loc15_ = new Timer(800,1)).addEventListener(TimerEvent.TIMER,setupCue);
               _loc15_.start();
            }
         }
      }
   }
}
