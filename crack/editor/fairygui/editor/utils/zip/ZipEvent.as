package fairygui.editor.utils.zip
{
   import flash.events.Event;
   
   public class ZipEvent extends Event
   {
      
      public static const PROGRESS:String = "progress";
      
      public static const LOADED:String = "loaded";
      
      public static const INIT:String = "init";
      
      public static const ERROR:String = "error";
       
      
      private var _message;
      
      public function ZipEvent(param1:String, param2:* = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._message = param2;
      }
      
      public function get message() : *
      {
         return this._message;
      }
      
      override public function toString() : String
      {
         return formatToString("ZipEvent","type","message");
      }
   }
}
