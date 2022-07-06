package
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class MenuMc extends MovieClip
   {
       
      
      private var pMain:PoolMain;
      
      public var menu:MovieClip;
      
      public function MenuMc(param1:*)
      {
         var ballsArray:* = undefined;
         var ballList:Array = null;
         var index:uint = 0;
         var sX:uint = 0;
         var sY:uint = 0;
         var strips:uint = 0;
         var i:uint = 0;
         var j:uint = 0;
         var pMain:* = param1;
         super();
         this.pMain = pMain;
         menu.matchDiag.visible = false;
         ballsArray = [new Ball15(),new Ball14(),new Ball13(),new Ball12(),new Ball11(),new Ball10(),new Ball9(),new Ball8(),new Ball7(),new Ball6(),new Ball5(),new Ball4(),new Ball3(),new Ball2(),new Ball1()];
         ballList = new Array();
         index = 0;
         sX = 100;
         sY = 175;
         strips = 5;
         i = 0;
         while(i < strips)
         {
            j = 0;
            while(j < strips - i)
            {
               ballList[index] = new Ball(ballsArray[index],null);
               ballList[index].x = sX;
               ballList[index].y = sY + 32 * j;
               addChild(ballList[index]);
               ballList[index].scaleX = ballList[index].scaleY = 2;
               ballList[index].poolBall.texture.x += Math.random() * 10;
               ballList[index].poolBall.texture.y += Math.random() * 10;
               index++;
               j++;
            }
            sX += 32;
            sY += 16;
            i++;
         }
         menu.practiceBtn.addEventListener(MouseEvent.CLICK,startPractice);
         menu.practiceBtn.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):*
         {
            menu.practiceBtn.alpha = 0.6;
         });
         menu.practiceBtn.addEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):*
         {
            menu.practiceBtn.alpha = 1;
         });
         menu.arcadeBtn.addEventListener(MouseEvent.CLICK,startArcade);
         menu.arcadeBtn.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):*
         {
            menu.arcadeBtn.alpha = 0.6;
         });
         menu.arcadeBtn.addEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):*
         {
            menu.arcadeBtn.alpha = 1;
         });
         menu.challengeBtn.addEventListener(MouseEvent.CLICK,startChallenge);
         menu.challengeBtn.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):*
         {
            menu.challengeBtn.alpha = 0.6;
         });
         menu.challengeBtn.addEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):*
         {
            menu.challengeBtn.alpha = 1;
         });
         menu.compBtn.addEventListener(MouseEvent.CLICK,showMatchDialog);
         menu.compBtn.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):*
         {
            menu.compBtn.alpha = 0.6;
         });
         menu.compBtn.addEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):*
         {
            menu.compBtn.alpha = 1;
         });
      }
      
      function startArcade(param1:MouseEvent) : *
      {
         pMain.initArcade();
      }
      
      function startChallenge(param1:MouseEvent) : *
      {
         pMain.initChallenge(1);
      }
      
      function start8Ball(param1:MouseEvent) : *
      {
         trace("Starting 8 Pool...");
         pMain.init8BallPool();
      }
      
      function showMatchDialog(param1:MouseEvent) : *
      {
         menu.matchDiag.visible = true;
         this.swapChildren(menu,getChildAt(numChildren - 1));
         menu.matchDiag.straightBtn.playBtn.addEventListener(MouseEvent.CLICK,startStraight);
         menu.matchDiag.ball8Btn.playBtn.addEventListener(MouseEvent.CLICK,start8Ball);
      }
      
      function startStraight(param1:MouseEvent) : *
      {
         trace("Starting Straight Pool...");
         pMain.initStraightPool();
      }
      
      function startPractice(param1:MouseEvent) : *
      {
         pMain.initPractice();
      }
   }
}
