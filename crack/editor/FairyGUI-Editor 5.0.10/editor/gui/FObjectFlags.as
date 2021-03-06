package fairygui.editor.gui
{
   public class FObjectFlags
   {
      
      public static const IN_DOC:int = 16;
      
      public static const IN_TEST:int = 32;
      
      public static const IN_PREVIEW:int = 64;
      
      public static const INSPECTING:int = 256;
      
      public static const ROOT:int = 1024;
       
      
      public function FObjectFlags()
      {
         super();
      }
      
      public static function isDocRoot(param1:int) : Boolean
      {
         return (param1 & IN_DOC) != 0 && (param1 & ROOT) != 0;
      }
      
      public static function getScaleLevel(param1:int) : int
      {
         return param1 & 15;
      }
   }
}
