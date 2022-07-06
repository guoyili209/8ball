package PoolMaster_fla
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public dynamic class eightBallBtn_20 extends MovieClip
   {
       
      
      public var ballList:Array;
      
      public var sX:uint;
      
      public var strips:uint;
      
      public var i:uint;
      
      public var j:uint;
      
      public var sY:uint;
      
      public var ballsArray;
      
      public var playBtn:SimpleButton;
      
      public var index:uint;
      
      public function eightBallBtn_20()
      {
         super();
      }
      
      function frame1() : *
      {
         ballsArray = [new Ball15(),new Ball14(),new Ball13(),new Ball12(),new Ball11(),new Ball10(),new Ball9(),new Ball8(),new Ball7(),new Ball6(),new Ball5(),new Ball4(),new Ball3(),new Ball2(),new Ball1()];
         ballList = new Array();
         index = 0;
         sX = 145;
         sY = 85;
         strips = 5;
         i = 0;
         while(i < strips)
         {
            j = 0;
            while(j < strips - i)
            {
               ballList[index] = new Ball(ballsArray[index],null);
               ballList[index].x = sX;
               ballList[index].y = sY + 16 * j;
               addChild(ballList[index]);
               ballList[index].scaleX = ballList[index].scaleY = 1;
               ++index;
               ++j;
            }
            sX += 16;
            sY += 8;
            ++i;
         }
         playBtn.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):*
         {
            playBtn.alpha = 0.6;
         });
         playBtn.addEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):*
         {
            playBtn.alpha = 1;
         });
      }
   }
}
