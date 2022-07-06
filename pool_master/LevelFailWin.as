package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class LevelFailWin extends MovieClip
   {
       
      
      public var backBtn:SimpleButton;
      
      public var levelTxt:TextField;
      
      private var pMain:Object;
      
      public var retryBtn:SimpleButton;
      
      public function LevelFailWin(param1:*)
      {
         super();
         this.pMain = param1;
         retryBtn.addEventListener(MouseEvent.CLICK,retryLevel);
         backBtn.addEventListener(MouseEvent.CLICK,back);
      }
      
      function setText(param1:*) : *
      {
         levelTxt.text = param1;
      }
      
      function retryLevel(param1:MouseEvent) : *
      {
         pMain.restartGame(null);
      }
      
      public function back(param1:MouseEvent) : void
      {
         pMain.backToMenu(null);
      }
   }
}
