package collision
{
   import model.LogicalBall;
   
   public class BallCollisionPoint extends CollisionPoint
   {
       
      
      private var m_cBall:LogicalBall;
      
      public function BallCollisionPoint(ball:LogicalBall, time:Number, dist:Number)
      {
         super(time,dist);
         this.m_cBall = ball;
      }
      
      public function get ball() : LogicalBall
      {
         return this.m_cBall;
      }
   }
}
