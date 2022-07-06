package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [ExcludeClass]
   public class _f68e01f1193df65735eba0bdb5be84ed91c1661ed75e7bc5f5552ca4effacf8a_flash_display_Sprite extends Sprite
   {
       
      
      public function _f68e01f1193df65735eba0bdb5be84ed91c1661ed75e7bc5f5552ca4effacf8a_flash_display_Sprite()
      {
         super();
      }
      
      public function allowDomainInRSL(... rest) : void
      {
         Security.allowDomain(rest);
      }
      
      public function allowInsecureDomainInRSL(... rest) : void
      {
         Security.allowInsecureDomain(rest);
      }
   }
}
