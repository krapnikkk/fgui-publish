package fairygui.editor
{
   import flash.net.SharedObject;
   
   public class LocalStore
   {
      
      private static var cookie:SharedObject = SharedObject.getLocal("fairygui.FairyGUIEditor");
       
      
      public function LocalStore()
      {
         super();
      }
      
      public static function get data() : Object
      {
         return cookie.data;
      }
      
      public static function setDirty(param1:String) : void
      {
         cookie.setDirty(param1);
      }
   }
}
