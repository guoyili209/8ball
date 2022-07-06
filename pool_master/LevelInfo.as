package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class LevelInfo extends MovieClip
   {
       
      
      public var backBtn:SimpleButton;
      
      public var levelTxt:TextField;
      
      private var pMain:Object;
      
      private var levelNo:uint;
      
      public var startBtn:SimpleButton;
      
      public var levelNoTxt:TextField;
      
      public function LevelInfo(param1:*, param2:*)
      {
         super();
         this.pMain = param1;
         this.levelNo = param2;
         startBtn.addEventListener(MouseEvent.CLICK,startLevel);
         backBtn.addEventListener(MouseEvent.CLICK,back);
      }
      
      function startLevel(param1:MouseEvent) : *
      {
         pMain.setupLevel();
      }
      
      function setText(param1:*, param2:*) : *
      {
         levelNoTxt.text = param1;
         levelTxt.text = param2;
      }
      
      public function back(param1:MouseEvent) : void
      {
         pMain.backToMenu(null);
      }
   }
}
