package collision
{
   public class CollisionPoint
   {
       
      
      private var _distance:Number;
      
      private var _time:Number;
      
      public function CollisionPoint(time:Number, dist:Number)
      {
         super();
         this._time = time;
         this._distance = dist;
      }
      
      public function get dist() : Number
      {
         return this._distance;
      }
      
      public function set time(value:Number) : void
      {
         this._time = value;
      }
      
      public function get time() : Number
      {
         return this._time;
      }
   }
}
