package view
{
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import common.NumCreate;
   import controller.StatesController;
   import controller.TimeController;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.getTimer;
   import model.Config;
   import model.GameData;
   import model.LogicalBall;
   import sound.SoundContain;
   import view.visualball.BallData;
   import view.visualball.BallRender;
   import view.visualball.VisualBall;

   public class ScoreView extends Sprite
   {

      private static var _isLastTimeSound:Boolean;

      private static var _hitInP:int = 0;

      public static var _addHitFlag:Boolean = true;

      private static var _instanse:ScoreView;

      public static var _energyHit:int = 0;

      private static var _preRollTime:int = -100;

      private static var _multiplierValue:int = 0;

      private static var _maxHit:int = 0;

      private static var PocketShadow:Class = view.ScoreView_PocketShadow;

      private static var _roolStopBallNum:int = 0;

      public static var _ballRollSp:Sprite = new Sprite();

      private var _leftTimeTF:NumCreate;

      private var _ballRollMask:Shape;

      private var _pocketBmp:Array;

      private var _score:int;

      private var _nMultiplier:Number;

      private var _targetTime:int;

      private var _speedNum:int;

      private var _rackTF:NumCreate;

      private var _rackTableTF:TextField;

      private var _pocketBalls:Sprite;

      private var _rack:int;

      private var _ballsLight:Array;

      private var _scoreTF:NumCreate;

      private var _rackLine:TimelineLite;

      private var _multiplierTF:NumCreate;

      private var _rollBalls:Array;

      private var _frameTime:int = 0;

      private var _multiplier:Number;

      private var _curTime:int;

      private var _removeBalls:Array;

      private var _ballHighlight:Sprite;

      private var _rollingBalls:Array;

      public function ScoreView()
      {
         super();
         this.init();
      }

      public static function setLeftTime(value:int):void
      {
         _instanse.setTime(value);
      }

      public static function setMultiplier(addValue:Number):void
      {
         if (addValue == 10)
         {
            _instanse._multiplierTF.text = "1.0x";
         }
         else
         {
            GameData.nMultiplier += addValue;
            if (GameData.nMultiplier < 1)
            {
               GameData.nMultiplier = 1;
            }
            else if (GameData.nMultiplier > 7)
            {
               GameData.nMultiplier = 7;
            }
            GameData.inPocket = [];
            _instanse.ballPocket();
            if (_instanse._nMultiplier != GameData.nMultiplier)
            {
               _instanse._nMultiplier = GameData.nMultiplier;
               _instanse._multiplierTF.text = _instanse._nMultiplier.toFixed(1) + "x";
               _instanse._multiplierTF.setHightlight();
            }
         }
      }

      public static function reset(lefttime:int = 180, rack:int = 1, score:int = 0, multiplier:Number = 1):void
      {
         trace("reset");
         _instanse.resetAll(lefttime, rack, score, multiplier);
         _instanse.setTime(lefttime);
         _instanse._multiplierTF.text = "1.0x";
         _instanse._rackTF.text = "1";
         _instanse._scoreTF.text = "0";
         _instanse.ballPocket();
      }

      public static function setScore(score:int):void
      {
         if (_instanse._score != score)
         {
            _instanse._score = score;
            _instanse._scoreTF.text = _instanse._score.toString();
            _instanse._scoreTF.setHightlight();
         }
      }

      public static function setRack(rack:int):void
      {
         _instanse._rack = rack;
         _instanse._rackTF.text = _instanse._rack.toString();
         _instanse._rackTF.setHightlight();
      }

      public static function get Instanse():ScoreView
      {
         if (_instanse == null)
         {
            _instanse = new ScoreView();
         }
         return _instanse;
      }

      public static function setPocket(ball:LogicalBall = null):void
      {
         if (ball == null || ball.number == 0)
         {
            _maxHit = 0;
            GameData.doubleHit = _maxHit;
         }
         else
         {
            ++ _maxHit;
            if (GameData.maxHit < _maxHit)
            {
               GameData.maxHit = _maxHit;
            }
            if (_addHitFlag)
            {
               ++ _energyHit;
            }
            _multiplierValue = GameData.nMultiplier - 1;
            GameData.inPocket.push(ball);
            if (_energyHit >= Config.REWARD_OTHER_IN_POCKET[_multiplierValue])
            {
               trace(_multiplierValue);
               ++_multiplierValue;
               _energyHit = 0;
               ScoreView.setMultiplier(1);
               _addHitFlag = false;
            }
            _instanse.rollBall(ball, GameData.dropPocketNumber);
         }
      }

      public static function rackReset():void
      {
         _instanse.rackResetAll();
      }

      private function timeTurnHandler(event:Event):void
      {
         var speed:int = 0;
         if (this._speedNum < Config.TIME_TURN_SPEED)
         {
            ++ this._speedNum;
         }
         else
         {
            this._speedNum = 0;
            speed = this._targetTime > this._curTime ? 1 : -1;
            this._curTime += speed;
            this._leftTimeTF.text = this.fromatTime(this._curTime);
            if (this._curTime == this._targetTime)
            {
               this.removeEventListener(Event.ENTER_FRAME, this.timeTurnHandler);
            }
         }
      }

      private function statesChangeHandler(event:Event):void
      {
         if (StatesController.curStates == StatesController.PAUSE && StatesController.lastStates == StatesController.PLAY)
         {
            _instanse.animPause(true);
         }
         else if (StatesController.curStates == StatesController.PLAY)
         {
            if (StatesController.lastStates == StatesController.PAUSE)
            {
               _instanse.animPause(false);
            }
            else
            {
               reset();
            }
         }
      }

      private function rollBall(ball:LogicalBall, pos:int = 0):void
      {
         trace("rollball");
         if (this._rollBalls == null)
         {
            this._rollBalls = new Array();
         }
         this._rollBalls.push(ball);
         ball.position.x = 475;
         ball.position.y = 365;
         var vBall:VisualBall = ball.view as VisualBall;
         _ballRollSp.addChild(vBall.ballSprite);
         _ballRollSp.addChild(vBall.ballHighlight);
         ball.updateVisualBall(0);
         this.addEventListener(Event.ENTER_FRAME, this.rollBallsHandler);
      }

      private function init():void
      {
         var b:DisplayObject = null;
         var c:Shape = null;
         this._leftTimeTF = new NumCreate();
         this._leftTimeTF.text = "3:00";
         this._leftTimeTF.x = 382;
         this._leftTimeTF.y = 97;
         addChild(this._leftTimeTF);
         this._multiplierTF = new NumCreate(true);
         this._multiplierTF.text = "1.0x";
         this._multiplierTF.x = 1195;
         this._multiplierTF.y += 10;
         this._multiplierTF.scaleX = this._multiplierTF.scaleY = 0.6;
         this._scoreTF = new NumCreate();
         this._scoreTF.text = "0";
         this._scoreTF.x = 530;
         this._scoreTF.y = 97;
         addChild(this._scoreTF);
         this._rackTF = new NumCreate();
         this._rackTF.text = "1";
         this._rackTF.x = 280;
         this._rackTF.y = 97;
         addChild(this._rackTF);
         this._pocketBalls = new Sprite();
         this._pocketBalls.x = 40;
         this._pocketBmp = new Array();
         this._pocketBalls.y = 104;
         addChild(this._pocketBalls);
         var pocketShowder:Sprite = new Sprite();
         this._ballHighlight = new Sprite();
         this._ballsLight = new Array();
         pocketShowder.x = this._pocketBalls.x - 2;
         pocketShowder.y = this._pocketBalls.y - 1;
         for (var i:int = 0; i < 5; i++)
         {
            b = new Bitmap(new PocketShadow());
            c = new Shape();
            c.graphics.beginFill(16777215);
            c.graphics.drawCircle(-8, -8, 8);
            c.graphics.endFill();
            b.y = 10;
            b.x = i * 24;
            pocketShowder.addChild(b);
            c.y = 10;
            c.x = i * 24;
            c.alpha = 0;
            this._ballsLight.push(c);
            this._ballHighlight.addChild(c);
         }
         this.drawMask(350, 32);
         this._ballRollMask.x = 180;
         this._ballRollMask.y = 560;
         this._ballRollMask.cacheAsBitmap = true;
         _ballRollSp.cacheAsBitmap = true;
         _ballRollSp.mask = this._ballRollMask;
         this._ballHighlight.x = pocketShowder.x + 20;
         trace(this._ballHighlight.x);
         this._ballHighlight.y = pocketShowder.y + 20;
         addChild(this._ballHighlight);
         this._rackTableTF = new TextField();
         var tf:TextFormat = new TextFormat();
         tf.size = 70;
         tf.font = "Arial";
         tf.color = 16777215;
         tf.bold = true;
         this._rackTableTF.defaultTextFormat = tf;
         this._rackTableTF.x = 300;
         this._rackTableTF.y = -116;
         this._rackTableTF.selectable = false;
         this._rackTableTF.autoSize = "center";
         addChild(this._rackTableTF);
         this._rackLine = new TimelineLite();
         this._rackLine.append(TweenLite.to(this._rackTableTF, 5, {"alpha": 0}), 10);
         this._rackLine.insert(TweenLite.to(this._rackTableTF, 2, {"alpha": 0.3}));
         StatesController.dispatcher.addEventListener(StatesController.STATES_CHANGE, this.statesChangeHandler);
      }

      private function rackResetAll():void
      {
         trace("rackResetAll");
         _roolStopBallNum = 0;
         this._rollBalls = new Array();
         if (this.hasEventListener(Event.ENTER_FRAME))
         {
            this.removeEventListener(Event.ENTER_FRAME, this.rollBallsHandler);
         }
         while (_ballRollSp.numChildren > 0)
         {
            _ballRollSp.removeChildAt(0);
         }
         this._frameTime = 0;
         this._rackTableTF.alpha = 0;
         trace("rackResetAll 222", this._rackTableTF.alpha);
         if (GameData.rack > 1)
         {
            this._rackTableTF.text = "RACK " + this._rack;
            this._rackLine.restart();
         }
         else if (this._rackLine && this._rackLine.active)
         {
            this._rackLine.kill();
            this._rackTableTF.alpha = 0;
            this._rackTableTF.text = "";
         }
         else
         {
            this._rackTableTF.text = "";
         }
      }

      private function setTime(value:int):void
      {
         if (value <= 0)
         {
            this._targetTime = 0;
            GameData.leftTime = 0;
            TimeController.Instanse.stop();
         }
         else
         {
            this._targetTime = value;
         }
         if (_isLastTimeSound == true && (this._targetTime == 0 || this._targetTime > 10))
         {
            SoundContain.stopSound(SoundContain.TIME);
            _isLastTimeSound = false;
         }
         if (this._targetTime == this._curTime || this._targetTime == this._curTime - 1 || this._targetTime == this._curTime + 1)
         {
            this._curTime = this._targetTime;
            this._leftTimeTF.text = this.fromatTime(this._curTime);
            if (this._curTime < 11 && this._curTime > 0)
            {
               this._leftTimeTF.setHightlight();
               if (_isLastTimeSound == false && this._targetTime != 0)
               {
                  trace("play sound");
                  SoundContain.playSound(SoundContain.TIME, 1, 0, int.MAX_VALUE);
                  _isLastTimeSound = true;
               }
            }
         }
         else
         {
            this.addEventListener(Event.ENTER_FRAME, this.timeTurnHandler);
         }
      }

      private function fromatTime(value:int):String
      {
         var min:int = Math.floor(value / 60);
         var sed:Number = value - min * 60;
         var end:String = sed < 10 ? "0" : "";
         return min + ":" + end + sed;
      }

      private function drawMask(w:Number, h:Number):void
      {
         this._ballRollMask = new Shape();
         var colors:Array = [16777215, 16777215, 16777215];
         var alphas:Array = [0, 1, 1];
         var ratios:Array = [0, 85, 255];
         var matrix:Matrix = new Matrix();
         matrix.createGradientBox(w, h, Math.PI / 2);
         this._ballRollMask.graphics.beginGradientFill("linear", colors, alphas, ratios, matrix);
         this._ballRollMask.graphics.drawRect(0, 0, w, h);
         this._ballRollMask.graphics.endFill();
         addChild(this._ballRollMask);
      }

      private function removePocketBall():void
      {
         var i:int = 0;
         var dis:DisplayObject = null;
         if (this._removeBalls)
         {
            for (i = 0; i < this._removeBalls.length; i++)
            {
               dis = this._removeBalls[i] as DisplayObject;
               if (dis.parent)
               {
                  dis.parent.removeChild(dis);
               }
            }
            this._removeBalls = null;
         }
      }

      private function resetAll(lefttime:int = 180, rack:int = 1, score:int = 0, multiplier:Number = 1):void
      {
         trace("start");
         _energyHit = 0;
         _addHitFlag = true;
         this._curTime = lefttime;
         this._rack = rack;
         GameData.rack = this._rack;
         this._score = score;
         this._nMultiplier = multiplier;
         this.removePocketBall();
         this.rackResetAll();
         if (this.hasEventListener(Event.ENTER_FRAME))
         {
            this.removeEventListener(Event.ENTER_FRAME, this.timeTurnHandler);
         }
         trace("resetAll", this._rackTableTF.alpha);
      }

      private function animPause(value:Boolean):void
      {
         if (value)
         {
            this.removeEventListener(Event.ENTER_FRAME, this.timeTurnHandler);
            this.removeEventListener(Event.ENTER_FRAME, this.rollBallsHandler);
         }
         else
         {
            this._frameTime = 0;
            this.setTime(GameData.leftTime);
            if (this._rollBalls != null)
            {
               this.addEventListener(Event.ENTER_FRAME, this.rollBallsHandler);
            }
         }
      }

      private function ballPocket(ball:LogicalBall = null, pos:int = 0):void
      {
         var b:DisplayObject = null;
         var bd:BitmapData = null;
         var bmp:Bitmap = null;
         if (ball == null)
         {
            this._removeBalls = this._pocketBmp.splice(0, 5);
            for each (b in this._ballsLight)
            {
               if (b.alpha != 0)
               {
                  b.alpha = 0;
               }
            }
            if (this._removeBalls.length == 5)
            {
               TweenMax.allFrom(this._ballsLight, 0.7, {
                     "alpha": 0.9,
                     "glowFilter": {
                        "color": 16777215,
                        "alpha": 0.8,
                        "blurX": 10,
                        "blurY": 10,
                        "strength": 3
                     },
                     "ease": Back.easeInOut
                  });
            }
            TweenMax.allTo(this._removeBalls, 0.5, {"alpha": 0}, 0, this.removePocketBall);
         }
         else
         {
            bd = BallRender.renderBall(BallData.getBallData(ball.number));
            bmp = new Bitmap(bd);
            bmp.y = 12;
            bmp.x = pos * 24;
            this._pocketBalls.addChild(bmp);
            this._pocketBmp.push(bmp);
            if (this._pocketBmp.length < 5)
            {
               this._ballsLight[pos].alpha = 0;
               TweenMax.from(this._ballsLight[pos], 0.7, {
                     "alpha": 0.9,
                     "glowFilter": {
                        "color": 16777215,
                        "alpha": 0.8,
                        "blurX": 10,
                        "blurY": 10,
                        "strength": 3
                     },
                     "ease": Back.easeInOut
                  });
            }
         }
      }

      private function rollBallsHandler(event:Event):void
      {
         var b:LogicalBall = null;
         var i:int = 0;
         if (this._frameTime == 0)
         {
            this._frameTime = getTimer();
            return;
         }
         var cutTime:int = getTimer();
         var frameStep:int = cutTime - this._frameTime;
         this._frameTime = cutTime;
         var dt:Number = frameStep / 10;
         if (this._rollBalls.length == 0)
         {
            this.removeEventListener(Event.ENTER_FRAME, this.rollBallsHandler);
            this._frameTime = 0;
         }
         var leftBalls:Array = new Array();
         for each (b in this._rollBalls)
         {
            if (b.isMoving == false)
            {
               if (getTimer() - _preRollTime > 400)
               {
                  _preRollTime = getTimer();
                  b.velocity.x = 0;
                  b.velocity.y = 0.8;
                  b.w.reset();
               }
            }
            else if (b.position.x > 159 + _roolStopBallNum * 18)
            {
               b.move(dt);
               b.rotate(dt);
               b.updateVisualBall(dt);
            }
            else
            {
               b.position.x = 159 + _roolStopBallNum * 18;
               b.updateVisualBall(1);
               b.stopMoving();
               ++_roolStopBallNum;
               i = this._rollBalls.indexOf(b);
               this._rollBalls.splice(i, 1);
            }
         }
      }
   }
}

