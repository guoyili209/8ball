package com.google.analytics.data
{
   import com.google.analytics.utils.Timespan;
   
   public class UTMX extends UTMCookie
   {
       
      
      public function UTMX()
      {
         super("utmx","__utmx",["dn","hash","timeout","tcp"],Timespan.twoyears * 1000);
      }
   }
}
