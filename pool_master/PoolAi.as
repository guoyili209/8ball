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
   
   public class PoolAi extends MovieClip
   {
       
      
      private var isLevelEnd:Boolean = false;
      
      var isBallPocketed:Boolean = false;
      
      private var shotPower:Number;
      
      private var dampCollision:Number = 0.99;
      
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
      
      var poolTable:AiPoolTable;
      
      private var ballsPocketed:uint;
      
      var whoseTurn = 2;
      
      private var savedGameStartTime:uint;
      
      private var numberOfBalls:uint = 16;
      
      private var ballList:Array;
      
      private var soundVol:SoundTransform;
      
      var myPoint:uint = 0;
      
      private var dampK:Number = 0.99;
      
      private var isFoul:Boolean = false;
      
      var currentLevel:uint;
      
      private var totalScore:Number = 0;
      
      private var myChannel:SoundChannel;
      
      private var levelFailWin:LevelFailWin;
      
      private var firstRun:Boolean = true;
      
      private var levelPass:Boolean = false;
      
      var compPoint:uint = 0;
      
      private var stickCont:MovieClip;
      
      private var pa:PointAnim;
      
      private var poolMain:PoolMain;
      
      public function PoolAi(param1:*, param2:*)
      {
         numberOfBalls = 16;
         ballList = new Array(numberOfBalls);
         scratch = false;
         dampCollision = 0.99;
         dampK = 0.99;
         isSoundPlaying = false;
         soundVol = new SoundTransform();
         firstRun = true;
         whoseTurn = 2;
         myPoint = 0;
         compPoint = 0;
         isBallPocketed = false;
         levelPass = false;
         isFoul = false;
         totalScore = 0;
         numScratch = 0;
         isLevelEnd = false;
         super();
         this.currentLevel = param2;
         this.poolMain = param1;
         gameStartTime = getTimer();
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
      
      function distanceCalc(param1:*, param2:*, param3:*, param4:*) : *
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         _loc5_ = param1 - param3;
         _loc6_ = param2 - param4;
         return Math.sqrt(_loc5_ * _loc5_ + _loc6_ * _loc6_);
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
      
      function handleCollision(param1:Event) : void
      {
         var i:* = undefined;
         var activeBalls:* = undefined;
         var k:uint = 0;
         var x1:* = undefined;
         var y1:* = undefined;
         var j:* = undefined;
         var dx:* = undefined;
         var dy:* = undefined;
         var dist:* = undefined;
         var t1:* = undefined;
         var t2:* = undefined;
         var scratchTimer:* = undefined;
         var event:Event = param1;
         i = ballList.length - 1;
         while(i >= 0)
         {
            if(ballList[i].isAlive)
            {
               x1 = ballList[i].x;
               y1 = ballList[i].y;
               j = i - 1;
               while(j >= 0)
               {
                  if(ballList[j].isAlive)
                  {
                     dx = ballList[j].x - x1;
                     dy = ballList[j].y - y1;
                     dist = Math.sqrt(dx * dx + dy * dy);
                     if(dist < 16)
                     {
                        solveBalls(ballList[i],ballList[j]);
                        t1 = Math.sqrt(ballList[i].vx * ballList[i].vx + ballList[i].vy * ballList[i].vy);
                        t2 = Math.sqrt(ballList[j].vx * ballList[j].vx + ballList[j].vy * ballList[j].vy);
                        playBallToBallSound(t1 + t2);
                        ballList[i].currentHit = -1;
                        ballList[j].currentHit = -1;
                     }
                  }
                  j--;
               }
            }
            i--;
         }
         activeBalls = 0;
         k = 0;
         while(k < numberOfBalls)
         {
            if(ballList[k].isAlive == true)
            {
               pocketHitTest(ballList[k]);
               borderHitTest(ballList[k]);
            }
            if(ballList[k].isMoving == true)
            {
               activeBalls = 1;
            }
            k++;
         }
         if(activeBalls == 0)
         {
            removeEventListener(Event.ENTER_FRAME,handleCollision);
            if(scratch == false)
            {
               if(isBallPocketed == true)
               {
                  isBallPocketed = false;
                  if(currentLevel == 8)
                  {
                     if(isFoul == true)
                     {
                        isFoul = false;
                        if(whoseTurn == 1)
                        {
                           poolTable.whoseTurn = 2;
                           whoseTurn = 2;
                           stickAnim(null);
                        }
                        else
                        {
                           poolTable.whoseTurn = 1;
                           whoseTurn = 1;
                           ai(null);
                        }
                     }
                     else if(whoseTurn == 1)
                     {
                        ai(null);
                     }
                     else
                     {
                        stickAnim(null);
                     }
                  }
                  else if(whoseTurn == 1)
                  {
                     ai(null);
                  }
                  else
                  {
                     stickAnim(null);
                  }
               }
               else if(whoseTurn == 1)
               {
                  poolTable.whoseTurn = 2;
                  whoseTurn = 2;
                  stickAnim(null);
               }
               else
               {
                  poolTable.whoseTurn = 1;
                  whoseTurn = 1;
                  ai(null);
               }
            }
            else
            {
               scratch = false;
               if(whoseTurn == 1)
               {
                  poolTable.whoseTurn = 2;
                  whoseTurn = 2;
                  scratchTimer = new Timer(800,1);
                  scratchTimer.addEventListener(TimerEvent.TIMER,setupCue);
                  scratchTimer.start();
               }
               else
               {
                  poolTable.whoseTurn = 1;
                  whoseTurn = 1;
                  scratchTimer = new Timer(800,1);
                  scratchTimer.addEventListener(TimerEvent.TIMER,function(param1:TimerEvent):*
                  {
                     ai(null);
                  });
                  scratchTimer.start();
               }
            }
         }
      }
      
      function angleTriangle(param1:*, param2:*) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         _loc3_ = distanceCalc(cueBall.x,cueBall.y,param1.x,param1.y);
         _loc4_ = distanceCalc(cueBall.x,cueBall.y,param2.x,param2.y);
         _loc5_ = distanceCalc(param1.x,param1.y,param2.x,param2.y);
         _loc6_ = (_loc3_ * _loc3_ + _loc5_ * _loc5_ - _loc4_ * _loc4_) / (2 * _loc5_ * _loc3_);
         return Math.acos(_loc6_) * 180 / Math.PI;
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
         trace("shot sound=" + shotPower);
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
      
      function ai(param1:MouseEvent) : *
      {
         var cueToBallDist:* = undefined;
         var nearBall:* = undefined;
         var aiTimer:* = undefined;
         var i:* = undefined;
         var dx:* = undefined;
         var dy:* = undefined;
         var dist:* = undefined;
         var e:MouseEvent = param1;
         if(isLevelEnd == false)
         {
            cueToBallDist = 10000;
            if(currentLevel == 8)
            {
               if(compPoint < 7)
               {
                  i = 0;
                  while(i < 7)
                  {
                     if(ballList[i].isAlive == true)
                     {
                        dx = cueBall.x - ballList[i].x;
                        dy = cueBall.y - ballList[i].y;
                        dist = Math.sqrt(dx * dx + dy * dy);
                        if(dist < cueToBallDist)
                        {
                           cueToBallDist = dist;
                           nearBall = ballList[i];
                        }
                     }
                     i++;
                  }
               }
               else
               {
                  nearBall = ballList[7];
               }
            }
            else
            {
               i = 0;
               while(i < 15)
               {
                  if(ballList[i].isAlive == true)
                  {
                     dx = cueBall.x - ballList[i].x;
                     dy = cueBall.y - ballList[i].y;
                     dist = Math.sqrt(dx * dx + dy * dy);
                     if(dist < cueToBallDist)
                     {
                        cueToBallDist = dist;
                        nearBall = ballList[i];
                     }
                  }
                  i++;
               }
            }
            angle = angleCalculate(cueToBallDist,nearBall);
            stickCont = new MovieClip();
            stickCont.addChild(stick);
            stickCont.x = cueBall.x;
            stickCont.y = cueBall.y;
            addChild(stickCont);
            stick.rotation = angle;
            stick.gotoAndPlay(2);
            aiTimer = new Timer(1200,1);
            aiTimer.addEventListener(TimerEvent.TIMER,function(param1:TimerEvent):*
            {
               var _loc2_:* = undefined;
               power = new Power();
               addChild(power);
               power.x = 598;
               power.y = 150;
               power.gotoAndPlay(2);
               _loc2_ = 20 + Math.random() * 50;
               power.sPower = _loc2_;
               takeShot(null);
            });
            aiTimer.start();
         }
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
         removeEventListener(Event.ENTER_FRAME,showTime);
         poolTable.restartBtn.removeEventListener(MouseEvent.CLICK,restartGame);
         cueBall.removeEventListener(MouseEvent.MOUSE_DOWN,pickCue);
         this.removeEventListener(MouseEvent.MOUSE_UP,dropCue);
         this.removeEventListener(MouseEvent.MOUSE_MOVE,rotateStick);
         this.removeEventListener(MouseEvent.MOUSE_DOWN,startStickAnim);
         this.removeEventListener(MouseEvent.MOUSE_UP,takeShot);
         removeEventListener(Event.ENTER_FRAME,handleCollision);
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
      
      function setupCue(param1:TimerEvent) : *
      {
         trace("Setting up the cue....");
         cueBall.buttonMode = true;
         cueBall.addEventListener(MouseEvent.MOUSE_DOWN,pickCue);
         this.addEventListener(MouseEvent.MOUSE_UP,dropCue);
         cueBall.ballMC.gotoAndPlay(2);
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
      
      function findNearBallQuad(param1:*) : *
      {
         if(param1.x >= cueBall.x && param1.y <= cueBall.y)
         {
            return 1;
         }
         if(param1.x >= cueBall.x && param1.y >= cueBall.y)
         {
            return 2;
         }
         if(param1.x <= cueBall.x && param1.y >= cueBall.y)
         {
            return 3;
         }
         if(param1.x <= cueBall.x && param1.y <= cueBall.y)
         {
            return 4;
         }
      }
      
      function onPlaybackComplete(param1:Event) : void
      {
         isSoundPlaying = false;
      }
      
      function restartGame(param1:MouseEvent) : *
      {
         var _loc2_:uint = 0;
         removeEventListener(Event.ENTER_FRAME,showTime);
         poolTable.restartBtn.removeEventListener(MouseEvent.CLICK,restartGame);
         cueBall.removeEventListener(MouseEvent.MOUSE_DOWN,pickCue);
         this.removeEventListener(MouseEvent.MOUSE_UP,dropCue);
         this.removeEventListener(MouseEvent.MOUSE_MOVE,rotateStick);
         this.removeEventListener(MouseEvent.MOUSE_DOWN,startStickAnim);
         this.removeEventListener(MouseEvent.MOUSE_UP,takeShot);
         removeEventListener(Event.ENTER_FRAME,handleCollision);
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
         if(currentLevel == 7)
         {
            poolMain.initStraightPool();
         }
         else
         {
            poolMain.init8BallPool();
         }
      }
      
      function levelEnd() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:InfoWin2 = null;
         isLevelEnd = true;
         removeAllListener();
         if(levelPass == false)
         {
            levelFailWin.setText("You lost the game!\nClick the Retry Button to try again! ");
            levelFailWin.visible = true;
            swapChildren(levelFailWin,getChildAt(numChildren - 1));
         }
         else
         {
            _loc1_ = (getTimer() - savedGameStartTime) / 1000;
            _loc2_ = ballsPocketed * 300 - numScratch * 1000;
            _loc3_ = new InfoWin2(this,clockTime(getTimer() - savedGameStartTime),shots,Math.round(ballsPocketed / shots * 100),numScratch,_loc1_,_loc2_);
            addChild(_loc3_);
            _loc3_.x = 120;
            _loc3_.y = 75;
         }
      }
      
      function stickAnim(param1:TimerEvent) : *
      {
         if(isLevelEnd == false)
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
         stickAnim(null);
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
            if(whoseTurn == 2)
            {
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
                  totalScore -= 1000;
                  poolTable.scoreTxt.text = "" + totalScore;
               }
               catch(ex:*)
               {
               }
            }
         }
         else
         {
            scratch = false;
            ++ballsPocketed;
            poolTable.ballsPocketed = ballsPocketed;
            poolTable.ballsPocketedTxt.text = "" + ballsPocketed;
            poolTable.accuracyTxt.text = "" + Math.round(ballsPocketed / shots * 100) + "%";
            if(currentLevel == 8)
            {
               if(whoseTurn == 2 && cBall.num < 8)
               {
                  ++compPoint;
                  ++poolTable.compPoint;
                  poolTable.compPointTxt.text = "" + compPoint;
                  try
                  {
                     tempTimer = new Timer(1200,1);
                     tempTimer.addEventListener(TimerEvent.TIMER,destroyPointAnim);
                     tempTimer.start();
                     pa = new PointAnim();
                     pa.textHolder.dynTxt.text = "-100";
                     addChild(pa);
                     pa.x = poc.x + 35;
                     pa.y = poc.y + 75;
                     totalScore -= 100;
                     poolTable.scoreTxt.text = "" + totalScore;
                  }
                  catch(ex:*)
                  {
                  }
               }
               else if(whoseTurn == 1 && cBall.num > 8)
               {
                  ++myPoint;
                  ++poolTable.myPoint;
                  poolTable.myPointTxt.text = "" + myPoint;
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
                     totalScore += 300;
                     poolTable.scoreTxt.text = "" + totalScore;
                  }
                  catch(ex:*)
                  {
                  }
               }
               else if(whoseTurn == 1)
               {
                  ++compPoint;
                  ++poolTable.compPoint;
                  poolTable.compPointTxt.text = "" + compPoint;
                  try
                  {
                     tempTimer = new Timer(1200,1);
                     tempTimer.addEventListener(TimerEvent.TIMER,destroyPointAnim);
                     tempTimer.start();
                     pa = new PointAnim();
                     pa.textHolder.dynTxt.text = "-100";
                     addChild(pa);
                     pa.x = poc.x + 35;
                     pa.y = poc.y + 75;
                     totalScore -= 100;
                     poolTable.scoreTxt.text = "" + totalScore;
                  }
                  catch(ex:*)
                  {
                  }
               }
               else
               {
                  ++myPoint;
                  ++poolTable.myPoint;
                  poolTable.myPointTxt.text = "" + myPoint;
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
                     totalScore += 300;
                     poolTable.scoreTxt.text = "" + totalScore;
                  }
                  catch(ex:*)
                  {
                  }
               }
            }
            else if(whoseTurn == 1)
            {
               ++compPoint;
               ++poolTable.compPoint;
               poolTable.compPointTxt.text = "" + compPoint;
               try
               {
                  tempTimer = new Timer(1200,1);
                  tempTimer.addEventListener(TimerEvent.TIMER,destroyPointAnim);
                  tempTimer.start();
                  pa = new PointAnim();
                  pa.textHolder.dynTxt.text = "-100";
                  addChild(pa);
                  pa.x = poc.x + 35;
                  pa.y = poc.y + 75;
                  totalScore -= 100;
                  poolTable.scoreTxt.text = "" + totalScore;
               }
               catch(ex:*)
               {
               }
            }
            else
            {
               ++myPoint;
               ++poolTable.myPoint;
               poolTable.myPointTxt.text = "" + myPoint;
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
                  totalScore += 300;
                  poolTable.scoreTxt.text = "" + totalScore;
               }
               catch(ex:*)
               {
               }
            }
            isBallPocketed = true;
            if(currentLevel == 8)
            {
               if(whoseTurn == 2 && cBall.num < 8)
               {
                  isFoul = true;
               }
               else if(whoseTurn == 1 && cBall.num > 8)
               {
                  isFoul = true;
               }
               if(cBall.num == 8)
               {
                  if(whoseTurn == 1 && compPoint >= 7)
                  {
                     levelPass = false;
                     levelEnd();
                  }
                  else if(whoseTurn == 2 && myPoint >= 7)
                  {
                     levelPass = true;
                     levelEnd();
                  }
                  else if(whoseTurn == 1)
                  {
                     levelPass = true;
                     levelEnd();
                  }
                  else
                  {
                     levelPass = false;
                     levelEnd();
                  }
               }
            }
         }
         cBall.hitPocket(poc.x + 30,poc.y + 80,temp);
         trace("------------------------" + myPoint);
         if(currentLevel == 6 && ballsPocketed >= 15)
         {
            levelEnd();
         }
         else if(currentLevel == 7 && ballsPocketed >= 8)
         {
            if(myPoint > 7)
            {
               levelPass = true;
               levelEnd();
            }
            else if(compPoint > 7)
            {
               levelPass = false;
               levelEnd();
            }
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
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:* = undefined;
         var _loc6_:uint = 0;
         var _loc7_:Array = null;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         levelPass = false;
         if(currentLevel == 7)
         {
            poolTable.gameNameTxt.text = "Straight Pool";
            gameStartTime = getTimer();
            _loc1_ = 150;
            _loc2_ = 200;
            _loc3_ = 0;
            _loc4_ = 5;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc4_ - _loc5_)
               {
                  ballList[_loc3_] = new Ball(new Ball1(),poolTable);
                  ballList[_loc3_].x = _loc1_;
                  ballList[_loc3_].y = _loc2_ + 16 * _loc6_;
                  addChild(ballList[_loc3_]);
                  ballList[_loc3_].poolBall.texture.x += Math.random() * 10;
                  ballList[_loc3_].poolBall.texture.y += Math.random() * 10;
                  _loc3_++;
                  _loc6_++;
               }
               _loc1_ += 16;
               _loc2_ += 8;
               _loc5_++;
            }
         }
         else if(currentLevel == 8)
         {
            poolTable.gameNameTxt.text = "8-Ball Pool";
            gameStartTime = getTimer();
            isFoul = false;
            _loc1_ = 150;
            _loc2_ = 200;
            _loc3_ = 0;
            _loc4_ = 5;
            _loc7_ = [new Ball15(),new Ball14(),new Ball13(),new Ball12(),new Ball11(),new Ball10(),new Ball9(),new Ball8(),new Ball7(),new Ball6(),new Ball5(),new Ball4(),new Ball3(),new Ball2(),new Ball1()];
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc4_ - _loc5_)
               {
                  ballList[_loc3_] = new Ball(_loc7_[_loc3_],poolTable);
                  ballList[_loc3_].x = _loc1_;
                  ballList[_loc3_].y = _loc2_ + 16 * _loc6_;
                  addChild(ballList[_loc3_]);
                  ballList[_loc3_].poolBall.texture.x += Math.random() * 10;
                  ballList[_loc3_].poolBall.texture.y += Math.random() * 10;
                  ballList[_loc3_].num = _loc3_ + 1;
                  _loc3_++;
                  _loc6_++;
               }
               _loc1_ += 16;
               _loc2_ += 8;
               _loc5_++;
            }
            (_loc8_ = new Ball(new Ball2(),poolTable)).x = 255;
            _loc8_.y = 55;
            _loc8_.poolBall.texture.x += 2;
            _loc8_.poolBall.texture.y += 2;
            addChild(_loc8_);
            (_loc9_ = new Ball(new Ball12(),poolTable)).x = 395;
            _loc9_.y = 55;
            _loc9_.poolBall.texture.x += 5;
            _loc9_.poolBall.texture.y += 5;
            addChild(_loc9_);
            savedGameStartTime = getTimer();
         }
         numberOfBalls = 16;
         ballList[numberOfBalls - 1] = cueBall;
         cueBall.x = 472;
         cueBall.y = 240;
         addChild(ballList[numberOfBalls - 1]);
         setupCue(null);
         cueBall.startMove();
         _loc5_ = 0;
         while(_loc5_ < numberOfBalls - 1)
         {
            ballList[_loc5_].startMove();
            _loc5_++;
         }
         addEventListener(Event.ENTER_FRAME,showTime);
         poolTable.restartBtn.addEventListener(MouseEvent.CLICK,restartGame);
         poolTable.backBtn.addEventListener(MouseEvent.CLICK,backToMenu);
         levelFailWin = new LevelFailWin(this);
         addChild(levelFailWin);
         levelFailWin.x = 120;
         levelFailWin.y = 75;
         levelFailWin.visible = false;
         isLevelEnd = false;
      }
      
      function initGame() : *
      {
         poolTable = new AiPoolTable();
         poolTable.whoseTurn = 2;
         poolTable.myPoint = 0;
         poolTable.compPoint = 0;
         poolTable.currentLevel = 6;
         firstRun = true;
         shots = 0;
         ballsPocketed = 0;
         poolTable.ballsPocketed = 0;
         angle = 0;
         shotPower = 0;
         scratch = false;
         poolTable.gameNameTxt.text = "";
         totalScore = 0;
         poolTable.scoreTxt.text = "" + totalScore;
         numScratch = 0;
         addChild(poolTable);
         poolTable.x = 20;
         poolTable.y = 70;
         cueBall = new Ball(new Ball0(),poolTable);
         setupLevel();
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
         poolTable.gameClock.text = clockTime(getTimer() - gameStartTime);
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
      
      function angleCalculate(param1:*, param2:*) : *
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
         _loc3_ = findNearBallQuad(param2);
         if(_loc3_ == 1)
         {
            _loc5_ = angleTriangle(param2,poolTable.poc3);
            trace(_loc5_);
            _loc6_ = 0;
            if(param2.x <= poolTable.poc2.x)
            {
               _loc6_ = angleTriangle(param2,poolTable.poc2);
            }
            trace(_loc6_);
            if(_loc5_ >= _loc6_)
            {
               _loc4_ = poolTable.poc3;
            }
            else
            {
               _loc4_ = poolTable.poc2;
            }
         }
         else if(_loc3_ == 2)
         {
            _loc5_ = angleTriangle(param2,poolTable.poc4);
            trace(_loc5_);
            _loc6_ = 0;
            if(param2.x <= poolTable.poc5.x)
            {
               _loc6_ = angleTriangle(param2,poolTable.poc5);
            }
            trace(_loc6_);
            if(_loc5_ >= _loc6_)
            {
               _loc4_ = poolTable.poc4;
            }
            else
            {
               _loc4_ = poolTable.poc5;
            }
         }
         else if(_loc3_ == 3)
         {
            _loc5_ = angleTriangle(param2,poolTable.poc6);
            trace(_loc5_);
            _loc6_ = 0;
            if(param2.x >= poolTable.poc5.x)
            {
               _loc6_ = angleTriangle(param2,poolTable.poc5);
            }
            trace(_loc6_);
            if(_loc5_ >= _loc6_)
            {
               _loc4_ = poolTable.poc6;
            }
            else
            {
               _loc4_ = poolTable.poc5;
            }
         }
         else if(_loc3_ == 4)
         {
            _loc5_ = angleTriangle(param2,poolTable.poc1);
            trace(_loc5_);
            _loc6_ = 0;
            if(param2.x >= poolTable.poc2.x)
            {
               _loc6_ = angleTriangle(param2,poolTable.poc2);
            }
            trace(_loc6_);
            if(_loc5_ >= _loc6_)
            {
               _loc4_ = poolTable.poc1;
            }
            else
            {
               _loc4_ = poolTable.poc2;
            }
         }
         _loc7_ = distanceCalc(param2.x,param2.y,_loc4_.x,_loc4_.y);
         _loc8_ = 1 + Math.random() * 5;
         _loc9_ = _loc4_.x + poolTable.x + 15;
         _loc10_ = _loc4_.y + poolTable.y + 15;
         _loc11_ = (_loc7_ + _loc8_) * (param2.x - _loc9_) / _loc7_ + _loc9_;
         _loc12_ = (_loc7_ + _loc8_) * (param2.y - _loc10_) / _loc7_ + _loc10_;
         _loc13_ = cueBall.x - _loc11_;
         _loc14_ = cueBall.y - _loc12_;
         _loc15_ = Math.atan(_loc14_ / _loc13_) * 180 / Math.PI;
         if(_loc14_ > 0 && _loc13_ < 0)
         {
            _loc15_ += 180;
         }
         else if(!(_loc14_ > 0 && _loc13_ > 0))
         {
            if(!(_loc14_ < 0 && _loc13_ > 0))
            {
               if(_loc14_ < 0 && _loc13_ < 0)
               {
                  _loc15_ += 180;
               }
            }
         }
         return _loc15_;
      }
   }
}
