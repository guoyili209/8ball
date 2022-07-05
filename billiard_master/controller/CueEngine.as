package controller
{
   import collision.BBCollisionPoint;
   import collision.Collision;
   import collision.CollisionPoint;
   import flash.geom.Point;
   import model.LogicalBall;
   import model.Table;
   
   public class CueEngine
   {
      
      public static var aimBall:Boolean;
      
      public static var n_cueBallY:Number;
      
      public static var velocityPosA:Point;
      
      public static var velocityPosB:Point;
      
      public static var posB:Point;
      
      public static var endP:Point;
      
      public static var n_targetBallX:Number;
      
      public static var n_targetBallY:Number;
      
      public static var startP:Point;
      
      public static var n_cueBallX:Number;
       
      
      public function CueEngine()
      {
         super();
         startP = new Point();
         endP = new Point();
      }
      
      public static function updateAim(mouseX:Number = 0, mouseY:Number = 0) : void
      {
         var bB:LogicalBall = null;
         var targetBall:LogicalBall = null;
         var cueBall:LogicalBall = null;
         var len:int = 0;
         aimBall = false;
         if(startP == null || endP == null)
         {
            startP = new Point();
            endP = new Point();
            velocityPosA = new Point();
            velocityPosB = new Point();
            posB = new Point();
         }
         startP.x = Table.guideBall.position.x;
         startP.y = Table.guideBall.position.y;
         Table.guideBall.velocity.x = mouseX - Table.guideBall.position.x;
         Table.guideBall.velocity.y = mouseY - Table.guideBall.position.y;
         Table.guideBall.velocity.normalise();
         var point:CollisionPoint = CollisionEngine.findFirstCollisionBall(Table.guideBall,Number.POSITIVE_INFINITY);
         if(point)
         {
            endP.x = Table.guideBall.position.x + Table.guideBall.velocity.x * point.time;
            endP.y = Table.guideBall.position.y + Table.guideBall.velocity.y * point.time;
            if(point is BBCollisionPoint)
            {
               bB = (point as BBCollisionPoint).ballB;
               posB.x = bB.position.x;
               posB.y = bB.position.y;
               targetBall = new LogicalBall();
               cueBall = new LogicalBall();
               targetBall.position.x = bB.position.x;
               targetBall.position.y = bB.position.y;
               cueBall.velocity = Table.guideBall.velocity.clone();
               cueBall.position.x = endP.x;
               cueBall.position.y = endP.y;
               Collision.ballBallCollision(cueBall,targetBall);
               n_cueBallX = cueBall.velocity.x;
               n_cueBallY = cueBall.velocity.y;
               n_targetBallX = targetBall.velocity.x;
               n_targetBallY = targetBall.velocity.y;
               len = 10 + 20 * Math.max(250 - point.dist,0) / 250;
               targetBall.velocity.multiplyEq(len);
               cueBall.velocity.multiplyEq(len);
               velocityPosA.x = endP.x + cueBall.velocity.x;
               velocityPosA.y = endP.y + cueBall.velocity.y;
               velocityPosB.x = posB.x + targetBall.velocity.x;
               velocityPosB.y = posB.y + targetBall.velocity.y;
               aimBall = true;
            }
         }
      }
   }
}
