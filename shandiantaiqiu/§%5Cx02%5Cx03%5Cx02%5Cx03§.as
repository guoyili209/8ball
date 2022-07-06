package
{
   import flash.display.Sprite;
   import flash.net.LocalConnection;
   import flash.utils.ByteArray;
   
   public final dynamic class §\x02\x03\x02\x03§
   {
       
      
      public function §\x02\x03\x02\x03§()
      {
         super();
      }
      
      public static function §\x04\x05\x04\x05§(param1:int) : String
      {
         var _loc2_:* = new Array(13592213,7434609,6778408,6516069,7628642,6448997,6775139,7693163,6907176,394859,13592217,6908770,7237473,6912107,7302763,6777709,2390383,6776169,13592221,7960953,7300640,7044457,7043196,7151740,942945,13592193,7697274,6322017,6322020,8220988,3281535);
         var _loc3_:* = new ByteArray();
         var _loc4_:* = 0;
         while(true)
         {
            §§push(_loc4_);
            §§push(_loc2_);
            if(true)
            {
               §§push(§§pop()[param1] ^ 13592211);
            }
            if(§§pop() >= (§§pop() ^ 31))
            {
               break;
            }
            §§push(_loc3_);
            §§push(_loc2_);
            if(true)
            {
               §§push(§§pop()[param1 + 1 + (_loc4_ - _loc4_ % 3) / 3]);
            }
            §§pop().writeByte(§§pop() >>> 8 * (_loc4_ % 3) & 255 ^ (_loc2_[param1] ^ 13592211));
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function §\x06\x07\x06\x07§(param1:Sprite) : Boolean
      {
         var _loc2_:* = new Array(0,10,18,25);
         var _loc3_:* = new LocalConnection().domain;
         var _loc4_:* = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(§\x04\x05\x04\x05§(_loc2_[_loc4_]) == _loc3_)
            {
               return true;
            }
            _loc4_++;
         }
         param1.stage.removeChildAt(0);
         return false;
      }
   }
}
