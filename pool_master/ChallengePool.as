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
   
   public class ChallengePool extends MovieClip
   {
       
      
      private var isLevelEnd:Boolean = false;
      
      private var shotPower:Number;
      
      private var dampCollision:Number = 0.99;
      
      private var rightBall:Object;
      
      private var levelInfo:LevelInfo;
      
      private var isSoundPlaying:Boolean = false;
      
      private var gameStartTime:uint;
      
      private var stick:Stick;
      
      private var numScratch:uint = 0;
      
      private var myGuide:MovieClip;
      
      private var shots:uint;
      
      private var cueBall:Ball;
      
      private var angle:Number;
      
      private var scratch:Boolean = false;
      
      private var power:Power;
      
      var poolTable:ChallengePoolTable;
      
      private var ballsPocketed:uint;
      
      private var savedGameStartTime:Number;
      
      private var numberOfBalls:uint = 16;
      
      private var ballList:Array;
      
      private var soundVol:SoundTransform;
      
      private var dampK:Number = 0.99;
      
      private var levelScore:int = 0;
      
      private var currentLevel:uint;
      
      private var levelPass:Boolean = false;
      
      private var myChannel:SoundChannel;
      
      private var levelFailWin:LevelFailWin;
      
      private var firstRun:Boolean = true;
      
      private var gameTime:uint;
      
      private var stickCont:MovieClip;
      
      private var levelPassWin:LevelPassWin;
      
      private var pa:PointAnim;
      
      var poolMain:PoolMain;
      
      public function ChallengePool(param1:*, param2:*)
      {
         numberOfBalls = 16;
         ballList = new Array(numberOfBalls);
         scratch = false;
         dampCollision = 0.99;
         dampK = 0.99;
         isSoundPlaying = false;
         soundVol = new SoundTransform();
         firstRun = true;
         levelPass = false;
         isLevelEnd = false;
         levelScore = 0;
         numScratch = 0;
         super();
         this.poolMain = param1;
         currentLevel = param2;
         initGame();
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
            if(currentLevel == 1 && ballsPocketed >= 3)
            {
               levelPass = true;
               levelEnd();
            }
            else if(currentLevel == 2 && ballsPocketed >= 5)
            {
               levelPass = true;
               levelEnd();
            }
            else if(currentLevel == 2 && shots >= 10)
            {
               levelPass = false;
               levelEnd();
            }
            else if(scratch == false)
            {
               if(isLevelEnd == false)
               {
                  stickAnim(null);
               }
            }
            else if(currentLevel == 3)
            {
               levelPass = false;
               levelEnd();
            }
            else
            {
               scratch = false;
               (_loc13_ = new Timer(800,1)).addEventListener(TimerEvent.TIMER,setupCue);
               _loc13_.start();
            }
         }
      }
      
      public function clockTime(param1:int) : *
      {
         var seconds:int = 0;
         var minutes:int = 0;
         var timeString:String = null;
         var ms:int = param1;
         if(ms < 0)
         {
            if(currentLevel == 3)
            {
               levelPass = true;
            }
            else
            {
               levelPass = false;
            }
            levelEnd();
            return "0:00";
         }
         try
         {
            if((currentLevel == 1 || currentLevel == 3 || currentLevel == 4 || currentLevel == 5 || currentLevel == 6) && ms < 10000)
            {
               if(poolTable.alarm.anim.txt2.text != Math.floor(ms / 1000))
               {
                  poolTable.alarm.visible = true;
                  poolTable.alarm.txt1.text = "Time Left: ";
                  poolTable.alarm.anim.txt2.text = "" + Math.floor(ms / 1000);
                  poolTable.alarm.gotoAndPlay(1);
               }
            }
            else if(currentLevel == 2)
            {
               poolTable.alarm.visible = true;
               poolTable.alarm.txt1.text = "Shots Left: ";
               poolTable.alarm.anim.txt2.text = "" + (10 - shots);
               poolTable.alarm.gotoAndStop(20);
            }
            else
            {
               poolTable.alarm.visible = false;
            }
         }
         catch(ex:*)
         {
         }
         seconds = Math.floor(ms / 1000);
         minutes = Math.floor(seconds / 60);
         seconds -= minutes * 60;
         timeString = minutes + ":" + String(seconds + 100).substr(1,2);
         return timeString;
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
      
      function playCueToBallSound(param1:*) : *
      {
         var _loc2_:cueSound = null;
         _loc2_ = new cueSound();
         myChannel = _loc2_.play();
         soundVol.volume = param1;
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
      
      function playTableHitSound(param1:*) : *
      {
         var _loc2_:tableHit = null;
         _loc2_ = new tableHit();
         myChannel = _loc2_.play();
         soundVol.volume = param1;
         myChannel.soundTransform = soundVol;
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
      
      function handleBorderHit(param1:*) : *
      {
         var _loc2_:* = undefined;
         param1.vx *= 0.9;
         param1.vy *= 0.9;
         _loc2_ = Math.sqrt(param1.vx * param1.vx + param1.vy * param1.vy);
         playTableHitSound(_loc2_ + 0.5);
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
         poolMain.initChallenge(currentLevel);
      }
      
      function levelEnd() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         isLevelEnd = true;
         poolTable.alarm.visible = false;
         removeAllListener();
         if(levelPass == false)
         {
            poolMain.challengeScore -= levelScore;
            levelFailWin.setText("You Failed to Pass Level " + currentLevel + ".\nClick the Retry Button to try again! ");
            levelFailWin.visible = true;
            swapChildren(levelFailWin,getChildAt(numChildren - 1));
         }
         else
         {
            ++currentLevel;
            _loc1_ = (getTimer() - savedGameStartTime) / 1000;
            _loc2_ = ballsPocketed * 300 - numScratch * 1000;
            levelPassWin.showText(clockTime(getTimer() - savedGameStartTime),shots,Math.round(ballsPocketed / shots * 100),numScratch,_loc1_);
            levelPassWin.visible = true;
            swapChildren(levelPassWin,getChildAt(numChildren - 1));
         }
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
      
      function dropCue(param1:MouseEvent) : void
      {
         cueBall.stopDrag();
         cueBall.removeEventListener(MouseEvent.MOUSE_DOWN,pickCue);
         removeEventListener(MouseEvent.MOUSE_UP,dropCue);
         cueBall.buttonMode = false;
         if(isLevelEnd == false)
         {
            stickAnim(null);
         }
      }
      
      function pocHitTrue(param1:*, param2:*) : *
      {
         var temp:Boolean = false;
         var tempTimer:* = undefined;
         var rightGreen:RightGreen = null;
         var numTemp:int = 0;
         var cBall:* = param1;
         var poc:* = param2;
         playPocketSound();
         temp = false;
         if(cBall == cueBall)
         {
            ++numScratch;
            temp = true;
            scratch = true;
            poolMain.challengeScore -= 1000;
            levelScore -= 1000;
            poolTable.scoreTxt.text = "" + poolMain.challengeScore;
            gameStartTime -= 5000;
            try
            {
               tempTimer = new Timer(1200,1);
               tempTimer.addEventListener(TimerEvent.TIMER,destroyPointAnim);
               tempTimer.start();
               pa = new PointAnim();
               pa.textHolder.dynTxt.text = "Scratch!!";
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
            scratch = false;
            ++ballsPocketed;
            poolTable.ballsPocketed = ballsPocketed;
            poolTable.ballsPocketedTxt.text = "" + ballsPocketed;
            poolTable.accuracyTxt.text = "" + Math.round(ballsPocketed / shots * 100) + "%";
            poolMain.challengeScore += 300;
            levelScore += 300;
            poolTable.scoreTxt.text = "" + poolMain.challengeScore;
         }
         cBall.hitPocket(poc.x + 30,poc.y + 80,temp);
         try
         {
            if(currentLevel == 4)
            {
               if(cBall != rightBall)
               {
                  levelPass = false;
                  levelEnd();
               }
               else
               {
                  levelPass = true;
                  levelEnd();
               }
            }
            else if(currentLevel == 5)
            {
               if(cBall != ballList[rightBall])
               {
                  levelPass = false;
                  levelEnd();
               }
               else
               {
                  rightGreen = new RightGreen();
                  addChild(rightGreen);
                  numTemp = new Number(rightBall);
                  rightGreen.x = poolTable.bhHolder.x + 20 + numTemp * 21;
                  rightGreen.y = poolTable.bhHolder.y + 65;
                  rightBall += 1;
                  if(rightBall >= 6)
                  {
                     levelPass = true;
                     levelEnd();
                  }
               }
            }
         }
         catch(ex:*)
         {
            trace("in pocHitTrue=" + ex);
         }
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
      
      function setupLevel() : *
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:* = undefined;
         var _loc10_:uint = 0;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         levelPass = false;
         levelInfo.visible = false;
         ballList = new Array();
         if(currentLevel == 1)
         {
            gameStartTime = getTimer() + 31000;
            ballList[0] = new Ball(new Ball5(),poolTable);
            ballList[0].startMove();
            ballList[0].x = 200;
            ballList[0].y = 200;
            addChild(ballList[0]);
            ballList[1] = new Ball(new Ball6(),poolTable);
            ballList[1].startMove();
            ballList[1].x = 200;
            ballList[1].y = 150;
            addChild(ballList[1]);
            ballList[2] = new Ball(new Ball7(),poolTable);
            ballList[2].startMove();
            ballList[2].x = 100;
            ballList[2].y = 250;
            addChild(ballList[2]);
            numberOfBalls = 4;
         }
         else if(currentLevel == 2)
         {
            gameStartTime = getTimer();
            ballList[0] = new Ball(new Ball5(),poolTable);
            ballList[0].startMove();
            ballList[0].x = 320;
            ballList[0].y = 300;
            addChild(ballList[0]);
            ballList[1] = new Ball(new Ball6(),poolTable);
            ballList[1].startMove();
            ballList[1].x = 425;
            ballList[1].y = 126;
            addChild(ballList[1]);
            ballList[2] = new Ball(new Ball7(),poolTable);
            ballList[2].startMove();
            ballList[2].x = 223;
            ballList[2].y = 250;
            addChild(ballList[2]);
            ballList[3] = new Ball(new Ball8(),poolTable);
            ballList[3].startMove();
            ballList[3].x = 123;
            ballList[3].y = 322;
            addChild(ballList[3]);
            ballList[4] = new Ball(new Ball9(),poolTable);
            ballList[4].startMove();
            ballList[4].x = 75;
            ballList[4].y = 256;
            addChild(ballList[4]);
            numberOfBalls = 6;
         }
         else if(currentLevel == 3)
         {
            levelPass = true;
            gameStartTime = getTimer() + 61000;
            _loc1_ = new Array(100,550,140,160,560,200,220,240,420,280,300,320,340,360,380);
            _loc2_ = new Array(120,140,160,180,200,220,240,260,280,300,320,340,360,250,290);
            _loc3_ = [new Ball15(),new Ball14(),new Ball13(),new Ball12(),new Ball11(),new Ball10(),new Ball9(),new Ball8(),new Ball7(),new Ball6(),new Ball5(),new Ball4(),new Ball3(),new Ball2(),new Ball1()];
            _loc1_ = mixArray(_loc1_);
            _loc2_ = mixArray(_loc2_);
            _loc3_ = mixArray(_loc3_);
            _loc4_ = 0;
            while(_loc4_ < 15)
            {
               ballList[_loc4_] = new Ball(_loc3_[_loc4_],poolTable);
               ballList[_loc4_].startMove();
               ballList[_loc4_].x = _loc1_[_loc4_];
               ballList[_loc4_].y = _loc2_[_loc4_];
               addChild(ballList[_loc4_]);
               _loc4_++;
            }
            numberOfBalls = 16;
         }
         else if(currentLevel == 4)
         {
            gameStartTime = getTimer() + 31000;
            _loc5_ = 150;
            _loc6_ = 200;
            _loc7_ = 0;
            _loc8_ = 5;
            _loc9_ = [new Ball2(),new Ball2(),new Ball2(),new Ball2(),new Ball2(),new Ball2(),new Ball2(),new Ball2(),new Ball2(),new Ball2(),new Ball8(),new Ball2(),new Ball2(),new Ball2(),new Ball2()];
            _loc4_ = 0;
            while(_loc4_ < _loc8_)
            {
               _loc10_ = 0;
               while(_loc10_ < _loc8_ - _loc4_)
               {
                  ballList[_loc7_] = new Ball(_loc9_[_loc7_],poolTable);
                  ballList[_loc7_].x = _loc5_;
                  ballList[_loc7_].y = _loc6_ + 16 * _loc10_;
                  addChild(ballList[_loc7_]);
                  ballList[_loc7_].poolBall.texture.x += Math.random() * 10;
                  ballList[_loc7_].poolBall.texture.y += Math.random() * 10;
                  ballList[_loc7_].startMove();
                  _loc7_++;
                  _loc10_++;
               }
               _loc5_ += 16;
               _loc6_ += 8;
               _loc4_++;
            }
            rightBall = ballList[10];
            numberOfBalls = 16;
         }
         else if(currentLevel == 5)
         {
            gameStartTime = getTimer() + 61000;
            _loc5_ = 150;
            _loc6_ = 223;
            _loc7_ = 0;
            _loc8_ = 3;
            _loc9_ = [new Ball1(),new Ball2(),new Ball3(),new Ball4(),new Ball5(),new Ball6()];
            _loc4_ = 0;
            while(_loc4_ < _loc8_)
            {
               _loc10_ = 0;
               while(_loc10_ < _loc8_ - _loc4_)
               {
                  ballList[_loc7_] = new Ball(_loc9_[_loc7_],poolTable);
                  ballList[_loc7_].x = _loc5_;
                  ballList[_loc7_].y = _loc6_ + 16 * _loc10_;
                  addChild(ballList[_loc7_]);
                  ballList[_loc7_].poolBall.texture.x += Math.random() * 10;
                  ballList[_loc7_].poolBall.texture.y += Math.random() * 10;
                  ballList[_loc7_].startMove();
                  _loc7_++;
                  _loc10_++;
               }
               _loc5_ += 16;
               _loc6_ += 8;
               _loc4_++;
            }
            numberOfBalls = 7;
            poolTable.bhHolder.visible = true;
            _loc11_ = [new Ball1(),new Ball2(),new Ball3(),new Ball4(),new Ball5(),new Ball6()];
            _loc12_ = new Array();
            _loc4_ = 0;
            while(_loc4_ < 6)
            {
               _loc12_[_loc4_] = new Ball(_loc11_[_loc4_],poolTable);
               _loc12_[_loc4_].x = poolTable.bhHolder["bh" + (_loc4_ + 1)].x + 493;
               _loc12_[_loc4_].y = poolTable.bhHolder["bh" + (_loc4_ + 1)].y + 47;
               addChild(_loc12_[_loc4_]);
               _loc4_++;
            }
            rightBall = new Number(0);
         }
         else if(currentLevel == 6)
         {
            levelPass = true;
            gameStartTime = getTimer() + 61000;
            _loc1_ = new Array(100,550,140,160,560,200,220,240,420,280,300,320,340,360,380);
            _loc2_ = new Array(120,140,160,180,200,220,240,260,280,300,320,340,360,250,290);
            _loc1_ = mixArray(_loc1_);
            _loc2_ = mixArray(_loc2_);
            _loc4_ = 0;
            while(_loc4_ < 15)
            {
               ballList[_loc4_] = new Ball(new Ball14(),poolTable);
               ballList[_loc4_].startMove();
               ballList[_loc4_].x = _loc1_[_loc4_];
               ballList[_loc4_].y = _loc2_[_loc4_];
               ballList[_loc4_].poolBall.texture.x += Math.random() * 10;
               ballList[_loc4_].poolBall.texture.y += Math.random() * 10;
               addChild(ballList[_loc4_]);
               _loc4_++;
            }
            numberOfBalls = 16;
         }
         cueBall = new Ball(new Ball0(),poolTable);
         cueBall.x = 472;
         cueBall.y = 240;
         ballList[numberOfBalls - 1] = cueBall;
         addChild(ballList[numberOfBalls - 1]);
         setupCue(null);
         cueBall.startMove();
         addEventListener(Event.ENTER_FRAME,showTime);
         poolTable.restartBtn.addEventListener(MouseEvent.CLICK,restartGame);
         poolTable.backBtn.addEventListener(MouseEvent.CLICK,backToMenu);
         savedGameStartTime = getTimer();
      }
      
      function initGame() : *
      {
         poolTable = new ChallengePoolTable();
         firstRun = true;
         shots = 0;
         ballsPocketed = 0;
         poolTable.ballsPocketed = 0;
         poolTable.bhHolder.visible = false;
         angle = 0;
         shotPower = 0;
         scratch = false;
         isLevelEnd = false;
         poolTable.alarm.visible = false;
         poolTable.scoreTxt.text = "" + poolMain.challengeScore;
         levelScore = 0;
         addChild(poolTable);
         poolTable.x = 20;
         poolTable.y = 70;
         levelInfo = new LevelInfo(this,currentLevel);
         addChild(levelInfo);
         levelInfo.x = 120;
         levelInfo.y = 75;
         if(currentLevel == 1)
         {
            levelInfo.setText("Level " + currentLevel,"Sink the 3 Balls Within 30 secs!\n Don\'t pocket the Cue Ball, or you will lose another 5 secs!");
         }
         else if(currentLevel == 2)
         {
            levelInfo.setText("Level " + currentLevel,"Sink the 5 Balls. \nYou have only 10 shots to take!");
         }
         else if(currentLevel == 3)
         {
            levelInfo.setText("Level " + currentLevel,"Bonus Level! \nSink as many balls as you can in 1 minute! \n\n Don\'t Sink the Cue Ball. Or the Level will end instantly.");
         }
         else if(currentLevel == 4)
         {
            levelInfo.setText("Level " + currentLevel,"Sink only and only the Black Ball in 30 secs!");
         }
         else if(currentLevel == 5)
         {
            levelInfo.setText("Level " + currentLevel,"The Six Ball Challenge!\n Sink the balls according to their number, from Lower to Higher! \nWatch out, you have only 1 minute to Win!!");
         }
         else if(currentLevel == 6)
         {
            levelInfo.setText("Level " + currentLevel,"Another Bonus Level!\n But this time you got an annoying Partner!!");
         }
         poolTable.levelNoTxt.text = "" + currentLevel;
         levelFailWin = new LevelFailWin(this);
         addChild(levelFailWin);
         levelFailWin.x = 120;
         levelFailWin.y = 75;
         levelFailWin.visible = false;
         levelPassWin = new LevelPassWin(this);
         addChild(levelPassWin);
         levelPassWin.x = 120;
         levelPassWin.y = 75;
         levelPassWin.visible = false;
      }
      
      function playPocketSound() : *
      {
         var _loc1_:pocketSound = null;
         _loc1_ = new pocketSound();
         myChannel = _loc1_.play();
         soundVol.volume = 0.5;
         myChannel.soundTransform = soundVol;
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
      
      function mixArray(param1:Array) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         _loc2_ = new Array();
         while(param1.length > 0)
         {
            _loc3_ = Math.floor(Math.random() * param1.length);
            _loc2_.push(param1[_loc3_]);
            param1.splice(_loc3_,1);
         }
         return _loc2_;
      }
      
      public function showTime(param1:Event) : *
      {
         if(currentLevel == 1 || currentLevel == 3 || currentLevel == 4 || currentLevel == 5)
         {
            poolTable.gameClock.text = clockTime(gameStartTime - getTimer());
         }
         else if(currentLevel == 2)
         {
            poolTable.gameClock.text = clockTime(getTimer() - gameStartTime);
         }
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
   }
}
