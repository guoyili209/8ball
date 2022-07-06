package
{
   import flash.display.MovieClip;
   
   public dynamic class Stick extends MovieClip
   {
       
      
      public function Stick()
      {
         super();
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame120() : *
      {
         gotoAndPlay(2);
      }
   }
}
