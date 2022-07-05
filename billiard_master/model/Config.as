package model
{
   public class Config
   {
      
      public static const REWARD_OTHER_MULTIPLIER:Array = [2,3,4,5,6,7];
      
      public static const REWARD_BALL_SCORE_NEW:int = 200;
      
      public static const MEDAL_SCORE:Array = [5,10,20,50,75,100,150,200];
      
      public static const POCKET_POS:Array = [[18,39],[609,38],[18,339],[609,340],[314,349],[314,29]];
      
      public static const GAME_HEIGHT:int = 500;
      
      public static const SPRING_CONSTANT:Number = 0.5;
      
      public static const TIME_TURN_SPEED:int = 1;
      
      public static const GAME_WIDTH:int = 700;
      
      public static const REWARD_OTHER_SCORE_NEW:int = 100;
      
      public static const REWARD_RACK_TIME:Array = [80,80,70,60,50,40,30,20,10];
      
      public static const CUE_POCKET_TIME:int = 30;
      
      public static const GRAVITY:Number = 1;
      
      public static const MU_ROLL:Number = 0.006;
      
      public static const MU_SLIDE:Number = 0.05;
      
      public static const MU_G_SLIDE:Number = MU_SLIDE * GRAVITY;
      
      public static const REWARD_BALL_SCORE:int = 200;
      
      public static const REWARD_OTHER_TIME:int = 1;
      
      public static const TABLE_POINTS:Array = [[-7,34],[23,67],[23,311],[-7,344],[15,364],[46,334],[294,334],[298,346],[302,365],[326,365],[330,346],[334,334],[580,334],[613,364],[635,342],[603,311],[603,67],[635,36],[613,14],[580,44],[332,44],[330,32],[326,13],[302,13],[298,32],[294,44],[46,44],[15,14]];
      
      public static const GUIDE_POCKET_POSITION:Array = [313,193];
      
      public static const REWARD_OTHER_IN_POCKET:Array = [8,10,12,14,16,18];
      
      public static const BALL_SLIDE_A:Number = -0.002;
      
      public static const POCKET_AMIN_POS:Array = [[15,36],[611,36],[15,342],[611,342],[313,347],[313,31]];
      
      public static const REWARD_OTHER_SCORE:int = 50;
      
      public static const REWARD_TIME:Array = [9,8,7,6,5,4,3,2];
      
      public static const MU_G_ROLL:Number = MU_ROLL * GRAVITY;
      
      public static const GAME_TOTAL_TIME:int = 3 * 60;
      
      public static const IMPULSE_TIME:Number = 1;
      
      public static const SHOOT_VELOCITY_PARAM:Number = SPRING_CONSTANT * IMPULSE_TIME;
       
      
      public function Config()
      {
         super();
      }
   }
}
