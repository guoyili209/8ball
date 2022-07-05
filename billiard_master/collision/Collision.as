package collision
{
   import flash.geom.Point;
   import model.LogicalBall;
   
   public class Collision
   {
      
      private static const DOPE:Number = 0.804;
      
      private static const SLID_FORCE:Number = 0.5;
      
      private static const ROLL_FORCE:Number = 0.025;
      
      public static const turnI:Number = 2.5;
      
      public static const MIN:Number = 1e-11;
      
      public static const ROLL_PARENT:Number = 0.285714;
      
      private static const MASS:Number = 980;
      
      private static const BL_COLLISION:Number = 0.54;
       
      
      public function Collision()
      {
         super();
      }
      
      public static function ballBallCollisionTime(ball1:LogicalBall, ball2:LogicalBall, time:Number) : Number
      {
         var t:Number = NaN;
         var radiusDist:Number = ball1.radius + ball2.radius;
         var distPosX:Number = ball1.position.x - ball2.position.x;
         var distPosY:Number = ball1.position.y - ball2.position.y;
         var distVelX:Number = ball1.velocity.x - ball2.velocity.x;
         var distVelY:Number = ball1.velocity.y - ball2.velocity.y;
         var c:Number = distPosX * distPosX + distPosY * distPosY - radiusDist * radiusDist;
         if(ball1.number == 1 && ball2.number == 2)
         {
         }
         if(c < 0)
         {
         }
         var a:Number = distVelX * distVelX + distVelY * distVelY;
         if(a < MIN)
         {
            return Number.POSITIVE_INFINITY;
         }
         var b:Number = distPosX * distVelX + distPosY * distVelY;
         if(b >= 0)
         {
            return Number.POSITIVE_INFINITY;
         }
         var d:Number = b * b - a * c;
         if(d < 0)
         {
            return Number.POSITIVE_INFINITY;
         }
         t = (-b - Math.sqrt(d)) / a;
         if(t <= 0 && t > -MIN)
         {
            return MIN;
         }
         if(t - MIN > time)
         {
            return Number.POSITIVE_INFINITY;
         }
         return t;
      }
      
      public static function ballBallCollision(ball1:LogicalBall, ball2:LogicalBall) : void
      {
         var lenX:Number = ball2.position.x - ball1.position.x;
         var lenY:Number = ball2.position.y - ball1.position.y;
         var angle:Number = Math.atan2(lenY,lenX);
         var cos:Number = Math.cos(angle);
         var sin:Number = Math.sin(angle);
         var pos0:Point = new Point();
         var pos1:Point = rotateCalculate(lenX,lenY,sin,cos,true);
         var vel0:Point = rotateCalculate(ball1.velocity.x,ball1.velocity.y,sin,cos,true);
         var vel1:Point = rotateCalculate(ball2.velocity.x,ball2.velocity.y,sin,cos,true);
         var vxTotal:Number = vel0.x - vel1.x;
         vel0.x = vel1.x;
         vel1.x = vxTotal + vel0.x;
         pos0.x += vel0.x;
         pos1.x += vel1.x;
         var pos0F:Point = rotateCalculate(pos0.x,pos0.y,sin,cos,false);
         var pos1F:Point = rotateCalculate(pos1.x,pos1.y,sin,cos,false);
         var vel0F:Point = rotateCalculate(vel0.x,vel0.y,sin,cos,false);
         var vel1F:Point = rotateCalculate(vel1.x,vel1.y,sin,cos,false);
         ball1.velocity.x = vel0F.x;
         ball1.velocity.y = vel0F.y;
         ball2.velocity.x = vel1F.x;
         ball2.velocity.y = vel1F.y;
      }
      
      public static function updateVelocity(ball:LogicalBall, time:Number) : void
      {
         var velPre:Number = NaN;
         var vpX:Number = NaN;
         var sildTime:Number = NaN;
         var rollTime:Number = NaN;
         if(ball.state != LogicalBall.nSTATE_IN_PLAY || !ball.isMoving)
         {
            return;
         }
         vpX = -ball.velocity.x - ball.w.y * ball.radius;
         var vpY:Number = -ball.velocity.y + ball.w.x * ball.radius;
         var vpLen:Number = Math.sqrt(vpX * vpX + vpY * vpY);
         var t:Number = ROLL_PARENT * vpLen / (MASS * SLID_FORCE);
         if(t > MIN)
         {
            if(ball.number == 0)
            {
            }
            sildTime = Math.min(t,time);
            velPre = sildTime * (MASS * SLID_FORCE) / vpLen;
            vpX *= velPre;
            vpY *= velPre;
            ball.velocity.x += vpX;
            ball.velocity.y += vpY;
            ball.w.x -= turnI * vpY / ball.radius;
            ball.w.y += turnI * vpX / ball.radius;
         }
         if(t < time)
         {
            if(ball.number == 0)
            {
            }
            rollTime = time - t;
            velPre = MASS * ROLL_FORCE * rollTime / ball.velocity.modulo;
            ball.velocity.scale(Math.max(0,1 - velPre));
            ball.w.x = ball.velocity.y / ball.radius;
            ball.w.y = -ball.velocity.x / ball.radius;
         }
         var addZ:Number = MASS / turnI * SLID_FORCE * time;
         if(ball.w.z > 0)
         {
            ball.w.z = Math.max(0,ball.w.z - addZ);
         }
         else
         {
            ball.w.z = Math.min(0,ball.w.z + addZ);
         }
      }
      
      private static function rotateCalculate(xpos:Number, ypos:Number, sin:Number, cos:Number, reverse:Boolean) : Point
      {
         var resultPoint:Point = new Point();
         if(reverse)
         {
            resultPoint.x = xpos * cos + ypos * sin;
            resultPoint.y = ypos * cos - xpos * sin;
         }
         else
         {
            resultPoint.x = xpos * cos - ypos * sin;
            resultPoint.y = ypos * cos + xpos * sin;
         }
         return resultPoint;
      }
      
      public static function ballPointCollisionTime(ball:LogicalBall, p:Point, time:Number) : Number
      {
         var velocityLen:Number = ball.velocity.x * ball.velocity.x + ball.velocity.y * ball.velocity.y;
         var lenX:Number = p.x - ball.position.x;
         var lenY:Number = p.y - ball.position.y;
         var b:Number = -ball.velocity.x * lenX - ball.velocity.y * lenY;
         var len:Number = lenX * lenX + lenY * lenY;
         var a:Number = velocityLen;
         var bDouble:Number = b * b;
         var rDouble:Number = ball.radius * ball.radius;
         if(-bDouble / a + len >= rDouble)
         {
            return Number.POSITIVE_INFINITY;
         }
         var t:Number = (-b - Math.sqrt(bDouble - a * (len - rDouble))) / velocityLen;
         if(t <= MIN || t - MIN > time)
         {
            return Number.POSITIVE_INFINITY;
         }
         return t;
      }
      
      public static function getAngle(x:Number, y:Number) : Number
      {
         if(x == 0)
         {
            return y >= 0 ? Number(Math.PI / 2) : Number(-Math.PI / 2);
         }
         var angle:Number = Math.atan(y / x);
         return Number(x < 0 ? Number(angle + Math.PI) : Number(angle));
      }
      
      public static function ballLineCollision(ball:LogicalBall, angle:Number) : void
      {
         var cosA:Number = Math.cos(-angle);
         var sinA:Number = Math.sin(-angle);
         var velocityX:Number = ball.velocity.x * cosA - ball.velocity.y * sinA;
         var velocityY:Number = ball.velocity.x * sinA + ball.velocity.y * cosA;
         var angleX:Number = ball.w.x * cosA - ball.w.y * sinA;
         var angleY:Number = ball.w.x * sinA + ball.w.y * cosA;
         angleX -= velocityY * BL_COLLISION / ball.radius;
         var angleZ:Number = velocityX - ball.w.z * ball.radius;
         var absZ:Number = Math.abs(angleZ);
         var minZ:Number = Math.min(absZ / turnI,0.2 * SLID_FORCE * Math.abs(velocityY));
         var addZ:Number = absZ == 0 ? Number(0) : Number(-angleZ * minZ / absZ);
         velocityX += addZ;
         ball.w.z -= turnI * addZ / ball.radius;
         velocityY = -velocityY * DOPE;
         ball.velocity.x = cosA * velocityX + sinA * velocityY;
         ball.velocity.y = -sinA * velocityX + cosA * velocityY;
         ball.w.x = cosA * angleX + sinA * angleY;
         ball.w.y = -sinA * angleX + cosA * angleY;
      }
      
      public static function ballLineCollisionTime(ball:LogicalBall, pStart:Point, pEnd:Point, time:Number) : Number
      {
         var ps:Point = pStart;
         var pe:Point = pEnd;
         var endX:int = pe.x - ps.x;
         var endY:int = pe.y - ps.y;
         var endLen:Number = Math.sqrt(endX * endX + endY * endY);
         var normX:Number = -endY / endLen;
         var normY:Number = endX / endLen;
         var closeBX:Number = ball.position.x - ps.x + normX * ball.radius;
         var closeBY:Number = ball.position.y - ps.y + normY * ball.radius;
         var projEndVelT:Number = endX * -ball.velocity.y + endY * ball.velocity.x;
         if(projEndVelT == 0)
         {
            return Number.POSITIVE_INFINITY;
         }
         var projBallVelT:Number = closeBX * -ball.velocity.y + closeBY * ball.velocity.x;
         var BallVsEnd:Number = projBallVelT / projEndVelT;
         if(BallVsEnd <= 0 || BallVsEnd >= 1)
         {
            return Number.POSITIVE_INFINITY;
         }
         var BallProjEnd:Number = closeBX * -endY + closeBY * endX;
         var t:Number = BallProjEnd / projEndVelT;
         if(t <= MIN || t - MIN > time)
         {
            return Number.POSITIVE_INFINITY;
         }
         return t;
      }
   }
}
