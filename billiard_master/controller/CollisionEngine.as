package controller
{
   import collision.BBCollisionPoint;
   import collision.BLCollisionPoint;
   import collision.BPCollisionPoint;
   import collision.Collision;
   import collision.CollisionPoint;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import model.Edge;
   import model.GameData;
   import model.LogicalBall;
   import model.Table;
   import sound.SoundContain;
   
   public class CollisionEngine
   {
      
      private static var _ballCount:int;
      
      private static var _rect:Rectangle = Table.Rect;
       
      
      public function CollisionEngine()
      {
         super();
      }
      
      public static function updateAllVelocity(time:Number) : Boolean
      {
         var ball:LogicalBall = null;
         var isMove:Boolean = false;
         var index:int = 0;
         var len:int = Table.onTableBalls.length;
         while(index < len)
         {
            ball = Table.onTableBalls[index];
            if(ball.state == LogicalBall.nSTATE_IN_PLAY && ball.isMoving)
            {
               if(ball.w.x != 0 || ball.w.y != 0 || ball.w.z != 0)
               {
                  ball.rotate(time);
                  isMove = true;
               }
               Collision.updateVelocity(ball,time);
            }
            index++;
         }
         return isMove;
      }
      
      public static function runBallCollision(time:Number) : Boolean
      {
         var collisionT:Number = NaN;
         var point:CollisionPoint = null;
         var index:int = 0;
         var len:int = 0;
         var ball:LogicalBall = null;
         var t:Number = time;
         var isMove:Boolean = false;
         _ballCount = Table.onTableBalls.length;
         while(t > Collision.MIN)
         {
            collisionT = t;
            point = findTableFistCollisionBall(t);
            if(point)
            {
               collisionT = point.time;
            }
            index = 0;
            len = _ballCount;
            while(index < len)
            {
               ball = Table.onTableBalls[index] as LogicalBall;
               if(ball.state == LogicalBall.nSTATE_IN_PLAY && ball.isMoving == true)
               {
                  ball.move(collisionT);
                  if(isMove == false && ball.isMoving == true)
                  {
                     isMove = true;
                  }
               }
               index++;
            }
            if(point != null)
            {
               turnCollision(point);
            }
            t -= collisionT;
         }
         return Boolean(updateAllVelocity(collisionT) || isMove);
      }
      
      public static function findFirstCollisionBall(ball:LogicalBall, time:Number = 1) : CollisionPoint
      {
         var collisionPoint:CollisionPoint = null;
         var t:Number = NaN;
         var ball2:LogicalBall = null;
         var velX:Number = NaN;
         var velY:Number = NaN;
         var pocketDist:Number = NaN;
         var p:Point = null;
         var xdist:Number = NaN;
         var ydist:Number = NaN;
         var vertex:Point = null;
         var edge:Edge = null;
         var index:int = 0;
         var len:int = Table.onTableBalls.length;
         var shortTime:Number = time;
         var xStart:Number = 0;
         var xEnd:Number = 0;
         var yStart:Number = 0;
         var yEnd:Number = 0;
         while(index < len)
         {
            ball2 = Table.onTableBalls[index] as LogicalBall;
            if(ball != ball2 && ball2.state == LogicalBall.nSTATE_IN_PLAY)
            {
               t = Collision.ballBallCollisionTime(ball,ball2,time);
               if(t < shortTime)
               {
                  velX = ball.velocity.x - ball2.velocity.x;
                  velY = ball.velocity.y - ball2.velocity.y;
                  collisionPoint = new BBCollisionPoint(ball,ball2,t,Math.sqrt(velX * velX + velY * velY));
                  shortTime = t;
               }
            }
            index++;
         }
         if(ball.velocity.x > 0)
         {
            xStart = ball.position.x;
            xEnd = ball.position.x + ball.velocity.x * time;
         }
         else
         {
            xStart = ball.position.x + ball.velocity.x * time;
            xEnd = ball.position.x;
         }
         if(ball.velocity.y > 0)
         {
            yStart = ball.position.y;
            yEnd = ball.position.y + ball.velocity.y;
         }
         else
         {
            yStart = ball.position.y + ball.velocity.y;
            yEnd = ball.position.y;
         }
         if(xStart < _rect.left + ball.radius || xEnd > _rect.right - ball.radius || yStart <= _rect.bottom + ball.radius || yEnd >= _rect.top - ball.radius)
         {
            index = 0;
            len = Table.pocketPoints.length;
            pocketDist = 0;
            while(index < len)
            {
               p = Table.pocketPoints[index] as Point;
               xdist = p.x - ball.position.x;
               ydist = p.y - ball.position.y;
               pocketDist = Math.sqrt(xdist * xdist + ydist * ydist);
               if(ball.w.modulo != 0 && p.x == -2 && p.y == -2)
               {
                  trace(ball.position,pocketDist);
               }
               if(pocketDist < 15)
               {
                  ball.state = LogicalBall.nSTATE_IN_POCKET;
                  ball.pocketNum = index;
                  ball.stopMoving();
                  break;
               }
               index++;
            }
            index = 0;
            len = Table.vertexs.length;
            while(index < len)
            {
               vertex = Table.vertexs[index] as Point;
               t = Collision.ballPointCollisionTime(ball,vertex,shortTime);
               if(t < shortTime)
               {
                  collisionPoint = new BPCollisionPoint(ball,vertex,t,ball.velocity.modulo);
                  shortTime = t;
               }
               index++;
            }
            index = 0;
            len = Table.edges.length;
            while(index < len)
            {
               edge = Table.edges[index] as Edge;
               t = Collision.ballLineCollisionTime(ball,edge.start,edge.end,shortTime);
               if(t < shortTime)
               {
                  collisionPoint = new BLCollisionPoint(ball,Collision.getAngle(edge.end.x - edge.start.x,edge.end.y - edge.start.y),t,ball.velocity.modulo);
                  shortTime = t;
               }
               index++;
            }
         }
         if(shortTime < time)
         {
            return collisionPoint;
         }
         return null;
      }
      
      public static function turnCollision(point:CollisionPoint) : void
      {
         var ballLinePoint:BLCollisionPoint = null;
         var BBPoint:BBCollisionPoint = null;
         var BPPoint:BPCollisionPoint = null;
         var xVel:Number = NaN;
         var yVel:Number = NaN;
         var angle:Number = NaN;
         if(point is BLCollisionPoint)
         {
            ballLinePoint = point as BLCollisionPoint;
            Collision.ballLineCollision(ballLinePoint.ball,ballLinePoint.angle);
            SoundContain.playSound(SoundContain.CUSHION_COLLISION,ballLinePoint.ball.velocity.modulo / 3000);
         }
         else if(point is BBCollisionPoint)
         {
            BBPoint = point as BBCollisionPoint;
            Collision.ballBallCollision(BBPoint.ballA,BBPoint.ballB);
            if(GameData.cueBallHit == null)
            {
               if(BBPoint.ballA.number == 0)
               {
                  GameData.cueBallHit = BBPoint.ballB;
               }
               else if(BBPoint.ballB.number == 0)
               {
                  GameData.cueBallHit = BBPoint.ballA;
               }
            }
            SoundContain.playSound(SoundContain.BALL_COLLISION,(BBPoint.ballA.velocity.modulo + BBPoint.ballB.velocity.modulo) / 500);
         }
         else if(point is BPCollisionPoint)
         {
            BPPoint = point as BPCollisionPoint;
            xVel = BPPoint.point.x - BPPoint.ball.position.x;
            yVel = BPPoint.point.y - BPPoint.ball.position.y;
            angle = Collision.getAngle(yVel,-xVel);
            Collision.ballLineCollision(BPPoint.ball,angle);
            SoundContain.playSound(SoundContain.CUSHION_COLLISION,BPPoint.ball.velocity.modulo / 500);
         }
      }
      
      public static function findTableFistCollisionBall(time:Number) : CollisionPoint
      {
         var cPoint:CollisionPoint = null;
         var ball:LogicalBall = null;
         var p:CollisionPoint = null;
         var index:int = 0;
         while(index < _ballCount)
         {
            ball = Table.onTableBalls[index];
            if(ball.state == LogicalBall.nSTATE_IN_PLAY && ball.isMoving == true)
            {
               p = findFirstCollisionBall(ball,time);
               if(p != null)
               {
                  cPoint = p;
                  time = cPoint.time;
               }
            }
            index++;
         }
         return cPoint;
      }
   }
}
