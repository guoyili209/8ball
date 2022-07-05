package collision
{
   import model.LogicalBall;
   
   public class BBCollisionPoint extends CollisionPoint
   {
       
      
      private var _ballB:LogicalBall;
      
      private var _ballA:LogicalBall;
      
      public function BBCollisionPoint(ballA:LogicalBall, ballB:LogicalBall, time:Number, dist:Number)
      {
         super(time,dist);
         this._ballA = ballA;
         this._ballB = ballB;
      }
      
      public function get ballA() : LogicalBall
      {
         return this._ballA;
      }
      
      public function ballCollided(ball:LogicalBall) : Boolean
      {
         return ball == this._ballA || ball == this._ballB;
      }
      
      public function get ballB() : LogicalBall
      {
         return this._ballB;
      }
   }
}
