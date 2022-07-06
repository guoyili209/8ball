package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class Ball extends MovieClip
   {
       
      
      private var poolTable:Object;
      
      var isMoving:Boolean;
      
      private var dampCollision:Number = 0.99;
      
      var poolBall:BallMC;
      
      var ball_itself;
      
      private var timer:Timer;
      
      var currentHit:int = -1;
      
      var isScratch:Boolean;
      
      private var dampK:Number = 0.99;
      
      private var pocTimer:Timer;
      
      var pocX:Number;
      
      var pocY:Number;
      
      var num:uint = 0;
      
      var vx:Number = 0;
      
      var vy:Number = 0;
      
      var isAlive:Boolean;
      
      var ballMC;
      
      public function Ball(param1:*, param2:*)
      {
         vx = 0;
         vy = 0;
         currentHit = -1;
         dampCollision = 0.99;
         dampK = 0.99;
         num = 0;
         super();
         this.poolTable = param2;
         poolBall = new BallMC();
         poolBall.texture.mask = poolBall.ball_itself;
         ball_itself = poolBall.ball_itself;
         this.ballMC = param1;
         param1.width = param1.height = 64;
         poolBall.texture.addChild(param1);
         isAlive = true;
         isMoving = false;
         addChild(poolBall);
      }
      
      function hitPocket(param1:*, param2:*, param3:*) : *
      {
         isScratch = param3;
         this.removeEventListener(Event.ENTER_FRAME,ballAnim);
         timer = null;
         isAlive = false;
         isMoving = false;
         pocX = param1;
         pocY = param2;
         pocTimer = new Timer(20);
         pocTimer.addEventListener(TimerEvent.TIMER,pocAnim);
         pocTimer.start();
      }
      
      function stopMove() : *
      {
         this.removeEventListener(Event.ENTER_FRAME,ballAnim);
      }
      
      function pocAnim(param1:TimerEvent) : *
      {
         var event:TimerEvent = param1;
         try
         {
            this.x += (pocX - this.x) / 5;
            this.y += (pocY - this.y) / 5;
            this.alpha -= 0.08;
            if(Math.abs(pocX - this.x) < 1)
            {
               this.alpha = 0;
               pocTimer.stop();
               pocTimer.removeEventListener(TimerEvent.TIMER,pocAnim);
               pocTimer = null;
               if(isScratch == true)
               {
                  trace("do something");
                  isScratch = false;
                  this.x = 300;
                  this.y = 200;
                  this.alpha = 1;
                  this.vx = 0;
                  this.vy = 0;
                  this.isAlive = true;
                  startMove();
               }
               else
               {
                  if(poolTable.currentLevel == 6)
                  {
                     if(poolTable.whoseTurn == 2)
                     {
                        this.x = poolTable["t" + poolTable.myPoint].x + 20;
                        this.y = poolTable["t" + poolTable.myPoint].y + 70;
                     }
                     else
                     {
                        this.x = poolTable["t" + (poolTable.compPoint + 8)].x + 20;
                        this.y = poolTable["t" + (poolTable.compPoint + 8)].y + 70;
                     }
                  }
                  else
                  {
                     this.x = poolTable["t" + poolTable.ballsPocketed].x + 20;
                     this.y = poolTable["t" + poolTable.ballsPocketed].y + 70;
                  }
                  this.alpha = 1;
               }
            }
         }
         catch(ex:*)
         {
            trace("Error in Ball.as->PocAnim" + ex);
         }
      }
      
      function startMove() : *
      {
         this.addEventListener(Event.ENTER_FRAME,ballAnim);
      }
      
      function ballUpdate() : *
      {
         if(Math.sqrt(vx * vx + vy * vy) > 0.014)
         {
            vx *= dampK;
            vy *= dampK;
            this.x += vx * 20;
            this.y += vy * 20;
            poolBall.texture.x += vx * 10;
            poolBall.texture.y += vy * 10;
            if(poolBall.texture.x > 12)
            {
               poolBall.texture.x -= 24;
            }
            if(poolBall.texture.x < -12)
            {
               poolBall.texture.x += 24;
            }
            if(poolBall.texture.y > 12)
            {
               poolBall.texture.y -= 24;
            }
            if(poolBall.texture.y < -12)
            {
               poolBall.texture.y += 24;
            }
            isMoving = true;
         }
         else
         {
            vx = 0;
            vy = 0;
            isMoving = false;
         }
      }
      
      function ballAnim(param1:Event) : *
      {
         ballUpdate();
      }
   }
}
