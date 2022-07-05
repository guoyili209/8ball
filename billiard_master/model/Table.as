package model
{
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import math.Number2D;
   
   public class Table extends EventDispatcher
   {
      
      private static var _setSpace:Number = 9.5;
      
      private static var _instanse:Table;
      
      private static const SPACE:Number = 1e-10;
      
      private static var _radiusSqrt3:Number = Math.sqrt(3) * _setSpace;
      
      public static var Rect:Rectangle = new Rectangle(0,0,580,290);
      
      public static const START_VELOCITY:Number = 15;
       
      
      private var _tableBalls:Array;
      
      private var _height:Number;
      
      private var _width:Number;
      
      private var _vertexs:Array;
      
      private var _ballCount:int;
      
      private var _balls:Array;
      
      private var _edges:Array;
      
      private var _guideBall:LogicalBall;
      
      private var _pocketPoints:Array;
      
      public function Table(width:Number = 580, height:Number = 290, ballCount:int = 15)
      {
         super();
         this._ballCount = ballCount;
         this._width = width;
         this._height = height;
         this.init(width,height);
         this.initBalls();
      }
      
      public static function get guideBall() : LogicalBall
      {
         return _instanse._guideBall;
      }
      
      public static function instanse() : Table
      {
         if(_instanse == null)
         {
            _instanse = new Table();
         }
         return _instanse;
      }
      
      public static function replay() : void
      {
         _instanse.replayReset();
      }
      
      public static function resetBallCenter(lBall:LogicalBall = null) : void
      {
         var ball:LogicalBall = null;
         var xd:Number = NaN;
         var yd:Number = NaN;
         var setBall:LogicalBall = null;
         var turn:int = 0;
         var lrNum:int = 0;
         var posX:Number = NaN;
         var otherBall:LogicalBall = null;
         trace("球体置中");
         var coverBalls:Array = new Array();
         var levelBalls:Array = new Array();
         var index:int = 0;
         var len:int = onTableBalls.length;
         if(lBall == null)
         {
            setBall = Table.guideBall;
         }
         else
         {
            setBall = lBall;
         }
         setBall.position.x = Config.GUIDE_POCKET_POSITION[0];
         setBall.position.y = Config.GUIDE_POCKET_POSITION[1];
         while(index < len)
         {
            ball = onTableBalls[index] as LogicalBall;
            if(ball.state == LogicalBall.nSTATE_IN_PLAY)
            {
               xd = ball.position.x - setBall.position.x;
               yd = ball.position.y - setBall.position.y;
               if(xd * xd + yd * yd < 361)
               {
                  coverBalls.push(ball);
               }
               if(ball.position.y < 170 && ball.position.y > 130)
               {
                  levelBalls.push(ball);
               }
            }
            index++;
         }
         var cIndex:int = 1;
         while(coverBalls.length > 0)
         {
            index = 0;
            ball = coverBalls[0] as LogicalBall;
            turn = !!(cIndex % 2) ? 1 : -1;
            lrNum = Math.ceil(cIndex / 2);
            posX = Config.GUIDE_POCKET_POSITION[0] + 19 * turn * lrNum;
            while(index < levelBalls.length)
            {
               otherBall = levelBalls[index] as LogicalBall;
               if(ball != otherBall)
               {
                  xd = posX - otherBall.position.x;
                  yd = Config.GUIDE_POCKET_POSITION[1] - otherBall.position.y;
                  if(xd * xd + yd * yd < 361)
                  {
                     if(otherBall.number == 0)
                     {
                        ball = otherBall;
                     }
                     else
                     {
                        if(coverBalls.indexOf(otherBall) < 0)
                        {
                           coverBalls.push(otherBall);
                        }
                        otherBall.position.x = -100;
                        otherBall.position.y = -100;
                     }
                  }
               }
               index++;
            }
            ball.position.x = posX;
            ball.position.y = Config.GUIDE_POCKET_POSITION[1];
            ball.updateVisualBall();
            coverBalls.splice(0,1);
            cIndex++;
         }
         setBall.stopMoving();
         setBall.state = LogicalBall.nSTATE_IN_PLAY;
      }
      
      public static function get onTableBalls() : Array
      {
         return _instanse._tableBalls;
      }
      
      public static function get edges() : Array
      {
         return _instanse._edges;
      }
      
      public static function get pocketPoints() : Array
      {
         return _instanse._pocketPoints;
      }
      
      public static function get balls() : Array
      {
         return _instanse._balls;
      }
      
      public static function resetBalls(resetNum:int) : void
      {
         var leftBalls:Array = null;
         var ball:LogicalBall = null;
         var xd:Number = NaN;
         var yd:Number = NaN;
         var otherBall:LogicalBall = null;
         trace("重置球");
         var index:int = 0;
         var len:int = onTableBalls.length;
         var startRow:int = resetNum == len - 1 ? 0 : 1;
         leftBalls = _instanse.setBallsPos(false,startRow);
         leftBalls.splice(0,0,guideBall);
         while(leftBalls.length > 0)
         {
            ball = leftBalls[leftBalls.length - 1] as LogicalBall;
            index = 0;
            while(index < onTableBalls.length)
            {
               otherBall = onTableBalls[index] as LogicalBall;
               xd = ball.position.x - otherBall.position.x;
               yd = ball.position.y - otherBall.position.y;
               if(ball != otherBall && xd * xd + yd * yd < 361)
               {
                  resetBallCenter(ball);
                  break;
               }
               index++;
            }
            leftBalls.pop();
         }
      }
      
      public static function get vertexs() : Array
      {
         return _instanse._vertexs;
      }
      
      private function initBalls() : void
      {
         var ball:LogicalBall = null;
         this._balls = new Array();
         var index:int = 0;
         this._guideBall = new LogicalBall();
         this._guideBall.state = LogicalBall.nSTATE_IN_PLAY;
         this._guideBall.number = 0;
         var row:int = 0;
         var curR:int = 0;
         while(index < this._ballCount)
         {
            ball = new LogicalBall();
            ball.number = index + 1;
            this._balls.push(ball);
            index++;
         }
         this.setBallsPos();
         this._tableBalls = this._balls.concat([this._guideBall]);
      }
      
      private function setBallsPos(isAll:Boolean = false, startRow:int = 0) : Array
      {
         var ball:LogicalBall = null;
         var a:Number = NaN;
         var index:int = 0;
         var len:int = this._balls.length;
         var row:int = startRow;
         var curR:int = 0;
         var leftBalls:Array = new Array();
         var xPos:Number = 455;
         while(index < len)
         {
            ball = this._balls[index];
            if(isAll == true || ball.state != LogicalBall.nSTATE_IN_PLAY)
            {
               a = 0;
               if(row == 4)
               {
                  a = Math.random() * 0.0001;
               }
               ball.position = new Number2D(xPos + a,189 + row * _setSpace - curR * 2 * _setSpace);
               curR++;
               if(curR > row)
               {
                  curR = 0;
                  xPos += _radiusSqrt3;
                  row++;
               }
               ball.stopMoving();
               ball.state = LogicalBall.nSTATE_IN_PLAY;
               ball.updateVisualBall(0);
            }
            else
            {
               leftBalls.push(ball);
            }
            index++;
         }
         return leftBalls;
      }
      
      private function replayReset() : void
      {
         this.setBallsPos(true);
         this._guideBall.position = new Number2D(162,189);
         this._guideBall.stopMoving();
         this._guideBall.velocity = new Number2D();
         this._guideBall.state = LogicalBall.nSTATE_IN_PLAY;
         this._guideBall.updateVisualBall(0);
      }
      
      private function init(width:Number = 580, height:Number = 290) : void
      {
         var prePoint:Point = null;
         var e:Edge = null;
         var v:Point = null;
         var n:Array = null;
         var verts:Array = Config.TABLE_POINTS;
         var len:int = verts.length;
         this._edges = new Array();
         this._vertexs = new Array();
         for(var i:int = 0; i < len; i++)
         {
            v = new Point(verts[i][0],verts[i][1]);
            this._vertexs.push(v);
            if(prePoint != null)
            {
               e = new Edge();
               e.setStart(prePoint.x,prePoint.y);
               e.setEnd(v.x,v.y);
               this._edges.push(e);
            }
            prePoint = v;
         }
         e = new Edge();
         e.setStart(prePoint.x,prePoint.y);
         e.setEnd(this._vertexs[0].x,this._vertexs[0].y);
         this._edges.push(e);
         this._pocketPoints = new Array();
         var pockets:Array = Config.POCKET_POS;
         for(i = 0; i < pockets.length; i++)
         {
            n = pockets[i];
            this._pocketPoints.push(new Point(n[0],n[1]));
         }
      }
   }
}
