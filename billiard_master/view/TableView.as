package view
{
   import collision.Collision;
   import controller.CollisionEngine;
   import controller.CueEngine;
   import controller.StatesController;
   import controller.TimeController;
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import math.Number2D;
   import model.Config;
   import model.Edge;
   import model.GameData;
   import model.LogicalBall;
   import model.Table;
   import sound.SoundContain;
   import view.visualball.BallData;
   import view.visualball.BallRender;
   import view.visualball.VisualBall;
   
   public class TableView extends Sprite
   {
      
      private static var TableBackClass:Class = view.TableView_TableBackClass;
      
      private static var rackNumStartClass:Class = TableView_rackNumStartClass;
      
      private static var CubClass:Class = view.TableView_CubClass;
      
      private static var numOtherTimeMcClass:Class = TableView_numOtherTimeMcClass;
      
      private static var TableEdgeClass:Class = view.TableView_TableEdgeClass;
      
      public static var drawTime:int;
      
      private static var multiplierMcLineClass:Class = TableView_multiplierMcLineClass;
      
      private static var EdgeHClass:Class = view.TableView_EdgeHClass;
      
      public static var Sp:Sprite;
      
      private static var EdgeVClass:Class = view.TableView_EdgeVClass;
       
      
      private var _gameLayer:Sprite;
      
      private var _multiplierCount:int = 0;
      
      private var _nMultiplier:int = 1;
      
      private var _ballLayer:Sprite;
      
      private var _downPos:Point;
      
      private var _highlightLayer:Sprite;
      
      private var _pocketAmin:TablePocketStars;
      
      private var _cubSp:Sprite;
      
      private var _movePathSp:Sprite;
      
      private var _numOtherTimeMcClass:MovieClip;
      
      private var _isMove:Boolean;
      
      private var _cueAngle:CueAngleView;
      
      private var _rackNumStartClass:MovieClip;
      
      private var _chooseFlag:Boolean = false;
      
      private var _multiplierAmin:TableMultiplierStars;
      
      private var _shadowLayer:Sprite;
      
      private var balls:Array;
      
      private var _ballCount:int;
      
      private var _frameTime:int = 0;
      
      private var _controllerLayer:ControllerView;
      
      private var _startVelocity:int = 0;
      
      private var _engine:CollisionEngine;
      
      private var otherScore:Number = 0;
      
      private var drawAimTimer:Number = 0;
      
      private var _hitFlag:Boolean = false;
      
      private var _aimLayer:Sprite;
      
      private var drawAimFlag:Boolean = false;
      
      private var _multiplierMcLineClass:MovieClip;
      
      private var otherTime:Number = 0;
      
      public function TableView()
      {
         var ballV:VisualBall = null;
         var isMove:Boolean = false;
         var ball:LogicalBall = null;
         this._rackNumStartClass = new rackNumStartClass();
         this._multiplierMcLineClass = new multiplierMcLineClass();
         this._numOtherTimeMcClass = new numOtherTimeMcClass();
         super();
         trace("过关动画");
         Table.instanse();
         BallRender.setRadius(9.5);
         this._gameLayer = new Sprite();
         addChild(this._gameLayer);
         var back:Bitmap = new Bitmap(new TableEdgeClass());
         back.x = -55;
         back.y = -90;
         this._gameLayer.addChild(back);
         this._rackNumStartClass.x = 100;
         this._rackNumStartClass.y = 170;
         addChild(this._rackNumStartClass);
         ScoreView.Instanse.addChild(this._multiplierMcLineClass);
         this._multiplierMcLineClass.x = -4;
         this._multiplierMcLineClass.y = 135;
         for(var i:int = 2; i <= 7; i++)
         {
            this["_multiplierMcLineClass"]["num" + i].visible = false;
         }
         this._numOtherTimeMcClass.x = 265;
         this._numOtherTimeMcClass.y = 190;
         addChild(this._numOtherTimeMcClass);
         this._numOtherTimeMcClass.gotoAndStop(1);
         ScoreView.Instanse.x = -225;
         ScoreView.Instanse.y = -308;
         this._controllerLayer = new ControllerView();
         this._gameLayer.addChild(this._controllerLayer);
         this._movePathSp = new Sprite();
         Sp = this._movePathSp;
         Sp.graphics.lineStyle(1,16777215);
         Sp.graphics.moveTo(0,0);
         this._cueAngle = new CueAngleView();
         this._cueAngle.x = 657;
         this._cueAngle.y = 126;
         ScoreView.Instanse.addChild(this._cueAngle);
         this._shadowLayer = new Sprite();
         this._shadowLayer.mouseChildren = false;
         this._gameLayer.addChild(this._shadowLayer);
         this._ballLayer = new Sprite();
         this._ballLayer.mouseChildren = false;
         this._gameLayer.addChild(this._ballLayer);
         this._gameLayer.addChild(ScoreView._ballRollSp);
         this._highlightLayer = new Sprite();
         this._highlightLayer.mouseChildren = false;
         this._gameLayer.addChild(this._highlightLayer);
         this.drawEdge(this._gameLayer);
         this._pocketAmin = new TablePocketStars();
         this._gameLayer.addChild(this._pocketAmin);
         this._multiplierAmin = new TableMultiplierStars();
         this._gameLayer.addChild(this._multiplierAmin);
         this._aimLayer = new Sprite();
         this._aimLayer.mouseChildren = false;
         this._aimLayer.mouseEnabled = false;
         this._gameLayer.addChild(this._aimLayer);
         this.setBallsVisible(false);
         var index:int = 0;
         this.balls = Table.onTableBalls;
         this._ballCount = Table.onTableBalls.length;
         while(index < this._ballCount)
         {
            ball = this.balls[index] as LogicalBall;
            ballV = new VisualBall(ball,BallData.getBallData(ball.number));
            if(ball.state == LogicalBall.nSTATE_IN_PLAY)
            {
               this._shadowLayer.addChild(ballV.ballShadow);
               this._ballLayer.addChild(ballV.ballSprite);
               this._highlightLayer.addChild(ballV.ballHighlight);
               ball.updateVisualBall(0);
            }
            index++;
         }
         var cubBmp:Bitmap = new Bitmap(new CubClass());
         cubBmp.x = -cubBmp.width / 2;
         cubBmp.smoothing = true;
         this._cubSp = new Sprite();
         this._cubSp.scaleX = 1;
         this._cubSp.scaleY = this._cubSp.scaleX;
         this._cubSp.addChild(cubBmp);
         this._aimLayer.addChild(this._cubSp);
         this._aimLayer.visible = false;
         this._engine = new CollisionEngine();
         StatesController.dispatcher.addEventListener(StatesController.STATES_CHANGE,this.statesChangeHandler);
      }
      
      public function moveUpdate(event:Event = null) : void
      {
         var addScore:int = 0;
         var ball:LogicalBall = null;
         var _otherTime:int = 0;
         var rack:int = 0;
         if(this._frameTime == 0)
         {
            this._frameTime = getTimer();
            return;
         }
         var cutTime:int = getTimer();
         var frameStep:int = cutTime - this._frameTime;
         var dt:Number = frameStep / 1000;
         if(dt > 0.03)
         {
            frameStep = 30;
            dt = 0.03;
         }
         this._frameTime += frameStep;
         this._isMove = CollisionEngine.runBallCollision(dt);
         var index:int = 0;
         var len:int = this.balls.length;
         while(index < len)
         {
            ball = this.balls[index];
            if(ball.state == LogicalBall.nSTATE_IN_PLAY)
            {
               ball.updateVisualBall(dt);
            }
            else if(ball.state == LogicalBall.nSTATE_IN_POCKET)
            {
               ball.dropPocket();
               if(ball.number != 0)
               {
                  this._pocketAmin.play(ball.pocketNum);
                  GameData.doubleHit += 1;
                  if(this._hitFlag == true)
                  {
                     this._chooseFlag = this._multiplierAmin.chooseMultiplier(ball.pocketNum);
                     if(this._chooseFlag)
                     {
                        this["_multiplierMcLineClass"]["num" + GameData.nMultiplier].visible = true;
                        this._multiplierAmin.closeMultiplier(ball.pocketNum);
                        this._multiplierCount = 0;
                        this._hitFlag = false;
                        ScoreView._energyHit = 0;
                        SoundContain.playSound(SoundContain.NEWMULTIPLIER);
                     }
                  }
                  ++GameData.dropPocketNumber;
                  ++GameData.gameTotalPocket;
                  if(StatesController.curStates == StatesController.PLAY)
                  {
                     trace("nMultiplier:" + GameData.nMultiplier);
                     addScore = GameData.nMultiplier * Config.REWARD_BALL_SCORE_NEW;
                     GameData.score += addScore;
                     GameData.scoreArr.push(addScore);
                     ScoreView.setScore(GameData.score);
                     trace("GameData.doubleHit:",GameData.doubleHit);
                     if(GameData.doubleHit >= 2)
                     {
                        if(GameData.doubleHit % 2 == 0)
                        {
                           this.otherScore += GameData.doubleHit / 2 * Config.REWARD_OTHER_SCORE * GameData.nMultiplier;
                        }
                        else
                        {
                           _otherTime = int(GameData.doubleHit / 2) + Config.REWARD_OTHER_TIME > 5 ? int(int(GameData.doubleHit / 2) + Config.REWARD_OTHER_TIME) : 5;
                           GameData.leftTime += _otherTime;
                        }
                     }
                  }
                  GameData.preIsPocket = true;
               }
               else
               {
                  GameData.leftTime -= Config.CUE_POCKET_TIME;
                  if(GameData.leftTime < 0)
                  {
                     GameData.leftTime = 0;
                  }
                  GameData.doubleHit = 0;
                  ScoreView._energyHit = 0;
                  this["_multiplierMcLineClass"]["numLine" + (GameData.nMultiplier + 1)].width = 31;
               }
               ScoreView.setPocket(ball);
               this["_multiplierMcLineClass"]["numLine" + (GameData.nMultiplier + 1)].width = 31 - 31 / Config.REWARD_OTHER_IN_POCKET[GameData.nMultiplier - 1] * ScoreView._energyHit;
               if(this._nMultiplier < GameData.nMultiplier && this._nMultiplier <= 7)
               {
                  this["_multiplierMcLineClass"]["numLine" + GameData.nMultiplier].width = 0;
                  this._nMultiplier = GameData.nMultiplier;
                  this._multiplierAmin.showMultiplier(this._nMultiplier);
                  this._hitFlag = true;
               }
               ScoreView.setLeftTime(GameData.leftTime);
            }
            index++;
         }
         if(this._isMove == false)
         {
            trace(this._multiplierCount);
            if(this._multiplierCount >= 1)
            {
               ScoreView.setMultiplier(10);
               ScoreView._addHitFlag = true;
               this._multiplierAmin.closeMultiplier();
               this["_multiplierMcLineClass"]["numLine" + this._nMultiplier].width = 31;
               if(this._nMultiplier == 1)
               {
                  this._nMultiplier = 1;
                  GameData.nMultiplier = 1;
               }
               else
               {
                  this._nMultiplier = this._nMultiplier - 1;
                  --GameData.nMultiplier;
               }
               this._multiplierCount = 0;
               this._hitFlag = false;
            }
            else if(this._chooseFlag)
            {
               ScoreView._addHitFlag = true;
               this._chooseFlag = false;
            }
            if(GameData.preIsPocket == false)
            {
               ScoreView.setPocket();
            }
            else
            {
               GameData.preIsPocket = false;
            }
            trace("GameData.doubleHit:",GameData.doubleHit);
            if(GameData.doubleHit >= 2)
            {
               if(GameData.cueBallHit.state != LogicalBall.nSTATE_IN_PLAY)
               {
                  addScore = this.otherScore;
                  GameData.score += addScore;
                  GameData.scoreArr.push(addScore);
                  ScoreView.setScore(GameData.score);
                  this.otherScore = 0;
               }
            }
            GameData.cueBallHit = null;
            this._frameTime = 0;
            this.removeEventListener(Event.ENTER_FRAME,this.moveUpdate);
            if(GameData.dropPocketNumber >= Table.onTableBalls.length - 1)
            {
               this.nextRack();
               rack = GameData.rack >= Config.REWARD_RACK_TIME.length ? int(Config.REWARD_RACK_TIME.length - 1) : int(GameData.rack - 1);
               this.otherTime = Config.REWARD_RACK_TIME[rack];
               GameData.leftTime += this.otherTime;
               GameData.dropPocketNumber = 0;
            }
            if(Table.guideBall.state != LogicalBall.nSTATE_IN_PLAY)
            {
               trace("okok");
               this.resetGuide();
            }
            if(StatesController.curStates == StatesController.PLAY)
            {
               this.cubUpdate();
               this._aimLayer.visible = true;
               this._cubSp.x = Table.guideBall.position.x;
               this._cubSp.y = Table.guideBall.position.y;
               this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
               this._gameLayer.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            }
         }
      }
      
      public function endGame(isNow:Boolean = false) : void
      {
         this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         this.stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         this._gameLayer.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         if(isNow == true)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.moveUpdate);
         }
         this._aimLayer.visible = false;
         this._downPos = null;
         this._multiplierAmin.closeMultiplier();
         for(var i:int = 2; i < 8; i++)
         {
            this["_multiplierMcLineClass"]["num" + i].visible = false;
            this["_multiplierMcLineClass"]["numLine" + i].width = 31;
         }
      }
      
      private function mouseUpHandler(event:Event) : void
      {
         try
         {
            this.stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
            this._downPos = null;
            this._cubSp.x = CueEngine.startP.x;
            this._cubSp.y = CueEngine.startP.y;
            if(this._startVelocity > 0)
            {
               this._aimLayer.visible = false;
               SoundContain.playSound(SoundContain.CUE_WEAK_COLLISION,this._startVelocity / 100);
               this.hitCue();
               this.addEventListener(Event.ENTER_FRAME,this.moveUpdate);
               this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
            }
            else
            {
               this._gameLayer.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
               this.mouseMoveHandler();
            }
            this._startVelocity = 0;
         }
         catch(e:Error)
         {
            e.message = "TableView::mouseUpHandler" + e.message;
         }
      }
      
      public function setBallsVisible(value:Boolean) : void
      {
         this._ballLayer.visible = value;
         this._shadowLayer.visible = value;
         this._highlightLayer.visible = value;
      }
      
      private function cubUpdate() : void
      {
         if(StatesController.curStates == StatesController.PLAY)
         {
            if(Table.guideBall.state == LogicalBall.nSTATE_IN_PLAY)
            {
               CueEngine.updateAim(this.mouseX,this.mouseY);
               this.drawAim(this.drawAimFlag);
            }
         }
      }
      
      private function statesChangeHandler(event:Event) : void
      {
         if(StatesController.curStates == StatesController.PAUSE)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.moveUpdate);
            TimeController.Instanse.pause(true);
            this._controllerLayer.mouseChildren = false;
         }
         else if(StatesController.curStates == StatesController.PLAY)
         {
            this.filters = [];
            if(StatesController.lastStates == StatesController.PAUSE)
            {
               TimeController.Instanse.pause(false);
               if(!Game.game.isStartTime)
               {
                  if(this._isMove)
                  {
                     this.addEventListener(Event.ENTER_FRAME,this.moveUpdate);
                  }
                  else
                  {
                     this.cubUpdate();
                     this._aimLayer.visible = true;
                     this._cubSp.x = Table.guideBall.position.x;
                     this._cubSp.y = Table.guideBall.position.y;
                     this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
                     this._gameLayer.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
                  }
               }
            }
            this._controllerLayer.mouseChildren = true;
            this._frameTime = 0;
         }
         else if(StatesController.curStates == StatesController.REPLAY)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.moveUpdate);
            this.filters = [];
         }
         else if(StatesController.curStates == StatesController.END)
         {
            trace("游戏已经结束了啊***********************************");
            this.endGame();
         }
         if(StatesController.curStates != StatesController.PLAY)
         {
            this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
            this.stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
            this._gameLayer.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            this._aimLayer.visible = false;
         }
      }
      
      private function drawEdge(container:DisplayObjectContainer) : void
      {
         var edge:Bitmap = new Bitmap(new EdgeVClass());
         edge.y = 32;
         edge.x = 27;
         container.addChild(edge);
         edge.alpha = 0;
         edge = new Bitmap(new EdgeVClass());
         edge.y = 32;
         edge.x = 601;
         edge.scaleX = -1;
         container.addChild(edge);
         edge.alpha = 0;
         edge = new Bitmap(new EdgeVClass());
         edge.y = 346;
         edge.x = 27;
         edge.scaleY = -1;
         container.addChild(edge);
         edge.alpha = 0;
         edge = new Bitmap(new EdgeVClass());
         edge.y = 346;
         edge.x = 601;
         edge.scaleX = -1;
         edge.scaleY = -1;
         container.addChild(edge);
         edge.alpha = 0;
         edge = new Bitmap(new EdgeHClass());
         edge.y = 48;
         edge.x = 11;
         container.addChild(edge);
         edge.alpha = 0;
         edge = new Bitmap(new EdgeHClass());
         edge.y = 48;
         edge.x = 616;
         edge.scaleX = -1;
         container.addChild(edge);
         edge.alpha = 0;
      }
      
      private function hitCue() : void
      {
         if(this._hitFlag)
         {
            ++this._multiplierCount;
         }
         Table.guideBall.velocity.normalise();
         Table.guideBall.velocity.multiplyEq(this._startVelocity * Table.START_VELOCITY);
         var angle:Number2D = this._cueAngle.getValue();
         Table.guideBall.w.x = -Table.guideBall.velocity.y * angle.y * 0.08;
         Table.guideBall.w.y = Table.guideBall.velocity.x * angle.y * 0.08;
         Table.guideBall.state = LogicalBall.nSTATE_IN_PLAY;
         this._cueAngle.reset();
         TableView.Sp.graphics.clear();
         TableView.Sp.graphics.lineStyle(1,16777215);
         TableView.Sp.graphics.moveTo(0,500);
         drawTime = getTimer();
         ++GameData.hitNum;
         if(GameData.preHitTime != 0)
         {
            GameData.hitCueTimes.push(getTimer() - GameData.preHitTime - GameData.pauseTime);
         }
         GameData.preHitTime = getTimer();
      }
      
      private function drawEdgeLine() : void
      {
         var edge:Edge = null;
         var p:Point = null;
         var edgeSp:Shape = new Shape();
         edgeSp.graphics.clear();
         var index:int = 0;
         var len:int = Table.edges.length;
         edgeSp.graphics.lineStyle(1,16777215);
         while(index < len)
         {
            edge = Table.edges[index] as Edge;
            edgeSp.graphics.moveTo(edge.start.x,edge.start.y);
            edgeSp.graphics.lineTo(edge.end.x,edge.end.y);
            index++;
         }
         index = 0;
         len = Table.pocketPoints.length;
         while(index < len)
         {
            p = Table.pocketPoints[index];
            edgeSp.graphics.drawCircle(p.x,p.y,15);
            index++;
         }
         addChild(edgeSp);
      }
      
      public function startPlay() : void
      {
         trace("开始游戏");
         this._nMultiplier = 1;
         this._multiplierAmin.closeMultiplier();
         this._hitFlag = false;
         this._chooseFlag = false;
         this._multiplierCount = 0;
         for(var i:int = 2; i < 8; i++)
         {
            this["_multiplierMcLineClass"]["num" + i].visible = false;
            this["_multiplierMcLineClass"]["numLine" + i].width = 31;
         }
         this._isMove = false;
         this.setBallsVisible(true);
         Table.replay();
         this.resetBalls();
         SoundContain.playSound(SoundContain.RACK);
         this.addEventListener(Event.ENTER_FRAME,this.moveUpdate);
      }
      
      private function resetBalls() : void
      {
         var ballV:VisualBall = null;
         var ball:LogicalBall = null;
         var index:int = 0;
         this.balls = Table.onTableBalls;
         this._ballCount = Table.onTableBalls.length;
         while(index < this._ballCount)
         {
            ball = this.balls[index] as LogicalBall;
            ball.velocity.reset();
            ball.w.reset();
            ballV = ball.view as VisualBall;
            if(ballV.ballShadow.parent)
            {
               ballV.ballShadow.parent.removeChild(ballV.ballShadow);
            }
            if(ballV.ballSprite.parent)
            {
               ballV.ballSprite.parent.removeChild(ballV.ballSprite);
            }
            if(ballV.ballHighlight.parent)
            {
               ballV.ballHighlight.parent.removeChild(ballV.ballHighlight);
            }
            this._shadowLayer.addChild(ballV.ballShadow);
            this._ballLayer.addChild(ballV.ballSprite);
            this._highlightLayer.addChild(ballV.ballHighlight);
            index++;
         }
      }
      
      private function drawAim(boo:Boolean) : void
      {
         if(boo)
         {
            this.drawAimFlag = false;
         }
         else
         {
            this.drawAimFlag = true;
         }
         this._aimLayer.graphics.clear();
         this._aimLayer.graphics.lineStyle(2,16777215,0.2);
         var angle:Number = Collision.getAngle(this.mouseX - Table.guideBall.position.x,this.mouseY - Table.guideBall.position.y);
         this._cubSp.rotation = angle * 180 / Math.PI + 90;
         this._aimLayer.graphics.moveTo(CueEngine.startP.x,CueEngine.startP.y);
         this._aimLayer.graphics.lineTo(CueEngine.endP.x,CueEngine.endP.y);
         this._aimLayer.graphics.drawCircle(CueEngine.endP.x,CueEngine.endP.y,Table.guideBall.radius);
         if(CueEngine.aimBall)
         {
            this._aimLayer.graphics.moveTo(CueEngine.endP.x,CueEngine.endP.y);
            this._aimLayer.graphics.lineTo(CueEngine.velocityPosA.x,CueEngine.velocityPosA.y);
            this._aimLayer.graphics.moveTo(CueEngine.posB.x,CueEngine.posB.y);
            this._aimLayer.graphics.lineTo(CueEngine.velocityPosB.x,CueEngine.velocityPosB.y);
         }
      }
      
      private function nextRack() : void
      {
         ++GameData.rack;
         ScoreView.setRack(GameData.rack);
         ScoreView.rackReset();
         Table.resetBalls(GameData.dropPocketNumber);
         this.resetBalls();
         SoundContain.playSound(SoundContain.RACK);
         this.setRackNumStart(GameData.rack);
      }
      
      private function mouseMoveHandler(event:MouseEvent = null) : void
      {
         var l:Number2D = null;
         var v:Number2D = null;
         var proj:Number = NaN;
         var vel:Number = NaN;
         var c:Number = NaN;
         var t:Number2D = null;
         try
         {
            if(!this._cueAngle.isMove)
            {
               if(this._downPos == null)
               {
                  this.cubUpdate();
               }
               else
               {
                  l = new Number2D(CueEngine.startP.x - this._downPos.x,CueEngine.startP.y - this._downPos.y);
                  v = new Number2D(this.mouseX - this._downPos.x,this.mouseY - this._downPos.y);
                  proj = Number2D.dot(l,v);
                  vel = 0;
                  if(proj > 0)
                  {
                     c = proj / (l.x * l.x + l.y * l.y);
                     t = l.clone();
                     t.multiplyEq(c);
                     vel = t.modulo;
                     if(vel <= 100)
                     {
                        this._cubSp.x = CueEngine.startP.x + t.x;
                        this._cubSp.y = CueEngine.startP.y + t.y;
                     }
                  }
                  else
                  {
                     vel = 0;
                     this._cubSp.x = CueEngine.startP.x;
                     this._cubSp.y = CueEngine.startP.y;
                  }
                  this._startVelocity = vel > 100 ? 100 : int(vel);
               }
            }
         }
         catch(e:Error)
         {
            e.message = "TableView::mouseMoveHandler" + e.message;
         }
      }
      
      private function numOtherTimeMcClassEvent(event:Event) : void
      {
         if(this._numOtherTimeMcClass.currentFrame == 80)
         {
            this._numOtherTimeMcClass.gotoAndStop(1);
            this._numOtherTimeMcClass.removeEventListener(Event.ENTER_FRAME,this.numOtherTimeMcClassEvent);
         }
      }
      
      private function mouseDownHandler(event:MouseEvent) : void
      {
         try
         {
            this._downPos = new Point(this.mouseX,this.mouseY);
            this.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
            this.stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
            this._gameLayer.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         }
         catch(e:Error)
         {
            e.message = "TableView::mouseDownHandler" + e.message;
         }
      }
      
      public function setRackNumStart(num:int) : void
      {
         var num1:int = 0;
         var num2:int = 0;
         if(StatesController.curStates != StatesController.END)
         {
            this._rackNumStartClass.play();
            this._rackNumStartClass.addEventListener(Event.ENTER_FRAME,this.rackNumStartEvent);
            if(num == 1)
            {
               trace("num:",num);
            }
            if(num <= 9)
            {
               this._rackNumStartClass.rackNumMc0.visible = false;
               this._rackNumStartClass.rackNumMc1.visible = false;
               this._rackNumStartClass.rackNumMc2.visible = true;
               this._rackNumStartClass.rackNumMc2.gotoAndStop(num);
            }
            else
            {
               num1 = int(num / 10);
               num2 = num % 10;
               if(num1 == 0)
               {
                  num1 = 10;
               }
               if(num2 == 0)
               {
                  num2 = 10;
               }
               this._rackNumStartClass.rackNumMc0.gotoAndStop(num1);
               this._rackNumStartClass.rackNumMc1.gotoAndStop(num2);
               this._rackNumStartClass.rackNumMc0.visible = true;
               this._rackNumStartClass.rackNumMc1.visible = true;
               this._rackNumStartClass.rackNumMc2.visible = false;
            }
         }
      }
      
      private function rackNumStartEvent(event:Event) : void
      {
         if(this._rackNumStartClass.currentFrame == 80 && GameData.rack != 1)
         {
            trace(this.otherTime);
            this._rackNumStartClass.gotoAndStop(1);
            this._rackNumStartClass.removeEventListener(Event.ENTER_FRAME,this.rackNumStartEvent);
            this._numOtherTimeMcClass.gotoAndPlay(1);
            if(this.otherTime < 10)
            {
               this._numOtherTimeMcClass.timeNum1.visible = false;
               this._numOtherTimeMcClass.timeNum2.gotoAndStop(this.otherTime);
            }
            else
            {
               this._numOtherTimeMcClass.timeNum1.visible = true;
               this._numOtherTimeMcClass.timeNum1.gotoAndStop(int(this.otherTime / 10));
               if(this.otherTime % 10 == 0)
               {
                  this._numOtherTimeMcClass.timeNum2.gotoAndStop(10);
               }
               else
               {
                  this._numOtherTimeMcClass.timeNum2.gotoAndStop(this.otherTime % 10);
               }
            }
            this._numOtherTimeMcClass.addEventListener(Event.ENTER_FRAME,this.numOtherTimeMcClassEvent);
         }
         else if(this._rackNumStartClass.currentFrame == 160)
         {
            this._rackNumStartClass.gotoAndStop(1);
            this._rackNumStartClass.removeEventListener(Event.ENTER_FRAME,this.rackNumStartEvent);
         }
      }
      
      private function resetGuide() : void
      {
         var ball:LogicalBall = Table.guideBall;
         Table.resetBallCenter(ball);
         var ballV:VisualBall = ball.view as VisualBall;
         this._shadowLayer.addChild(ballV.ballShadow);
         this._ballLayer.addChild(ballV.ballSprite);
         this._highlightLayer.addChild(ballV.ballHighlight);
         ball.updateVisualBall();
      }
   }
}
