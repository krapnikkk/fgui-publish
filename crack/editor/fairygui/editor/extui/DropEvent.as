package fairygui.editor.extui
{
   import flash.events.Event;
   
   public class DropEvent extends Event
   {
      
      public static const DROP:String = "__drop";
       
      
      private var _source:Object;
      
      private var _sourceData:Object;
      
      public function DropEvent(param1:String, param2:Object, param3:Object)
      {
         super(param1,false,false);
         this._source = param2;
         this._sourceData = param3;
      }
      
      public function get source() : Object
      {
         return this._source;
      }
      
      public function get sourceData() : Object
      {
         return this._sourceData;
      }
   }
}
