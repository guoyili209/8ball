package collision
{
   import model.LogicalBall;
   
   public class BLCollisionPoint extends BallCollisionPoint
   {
       
      
      private var _angle:Number;
      
      public function BLCollisionPoint(ball:LogicalBall, angle:Number, time:Number, dist:Number)
      {
         super(ball,time,dist);
         this._angle = angle;
      }
      
      public function get angle() : Number
      {
         return this._angle;
      }
   }
}
