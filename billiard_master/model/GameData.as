package model
{
   public class GameData
   {
      
      public static var multiplier:Number = 1;
      
      public static var isHighScore:int = 0;
      
      public static var scoreArr:Array = new Array();
      
      public static var doubleHit:int = 0;
      
      public static var dropPocketNumber:int = 0;
      
      public static var maxHit:int = 0;
      
      public static var score:int = 0;
      
      public static var hitCueTimes:Array = [];
      
      public static var nMultiplier:Number = 1;
      
      public static var rack:int = 1;
      
      public static var inPocket:Array = [];
      
      public static var preHitTime:int = 0;
      
      public static var gameTotalTime:int = 0;
      
      public static var cueBallHit:LogicalBall;
      
      public static var preIsPocket:Boolean = false;
      
      public static var gameTotalPocket:int = 0;
      
      public static var pauseTime:int = 0;
      
      public static var highScore:int = 0;
      
      public static var hitNum:int = 0;
      
      public static var leftTime:int = 0;
      
      public static var cupNum:int = 0;
      
      public static var playNum:int = 0;
      
      public static var isFirstPlay:Boolean = true;
       
      
      public function GameData()
      {
         super();
      }
      
      public static function getPushScore() : int
      {
         var scoreSum:int = 0;
         for(var i:int = 0; i < scoreArr.length; i++)
         {
            scoreSum += scoreArr[i];
         }
         return scoreSum;
      }
      
      public static function reset() : void
      {
         dropPocketNumber = 0;
         hitNum = 0;
         score = 0;
         scoreArr = new Array();
         leftTime = 0;
         rack = 1;
         multiplier = 1;
         nMultiplier = 1;
         inPocket = [];
         gameTotalTime = 0;
         gameTotalPocket = 0;
         maxHit = 0;
         preIsPocket = false;
         cueBallHit = null;
         pauseTime = 0;
         hitCueTimes = [];
         preHitTime = 0;
      }
   }
}
