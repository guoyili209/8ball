package PoolMaster_fla
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public dynamic class straightBtn_19 extends MovieClip
   {
       
      
      public var playBtn:SimpleButton;
      
      public function straightBtn_19()
      {
         super();
      }
      
      function frame1() : *
      {
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
