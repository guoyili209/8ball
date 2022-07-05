package model
{
   import flash.geom.Point;
   
   public class Edge
   {
       
      
      public var start:Point;
      
      public var end:Point;
      
      public function Edge()
      {
         super();
         this.start = new Point();
         this.end = new Point();
      }
      
      public function setStart(x:Number, y:Number) : void
      {
         this.start.x = x;
         this.start.y = y;
      }
      
      public function setEnd(x:Number, y:Number) : void
      {
         this.end.x = x;
         this.end.y = y;
      }
   }
}
