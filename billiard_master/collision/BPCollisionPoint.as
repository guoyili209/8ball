package collision
{
   import flash.geom.Point;
   import model.LogicalBall;
   
   public class BPCollisionPoint extends BallCollisionPoint
   {
       
      
      private var _point:Point;
      
      public function BPCollisionPoint(ball:LogicalBall, point:Point, time:Number, dist:Number)
      {
         super(ball,time,dist);
         this._point = point;
      }
      
      public function get point() : Point
      {
         return this._point;
      }
   }
}
