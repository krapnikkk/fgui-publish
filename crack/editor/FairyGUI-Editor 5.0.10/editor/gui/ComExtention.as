package fairygui.editor.gui
{
   import fairygui.utils.XData;
   import flash.events.EventDispatcher;
   
   public class ComExtention extends EventDispatcher
   {
       
      
      protected var _owner:FComponent;
      
      public var _type:String;
      
      public function ComExtention()
      {
         super();
      }
      
      public function get owner() : FComponent
      {
         return this._owner;
      }
      
      public function set owner(param1:FComponent) : void
      {
         this._owner = param1;
      }
      
      public function get title() : String
      {
         return null;
      }
      
      public function set title(param1:String) : void
      {
      }
      
      public function get icon() : String
      {
         return null;
      }
      
      public function set icon(param1:String) : void
      {
      }
      
      public function get color() : uint
      {
         return 0;
      }
      
      public function set color(param1:uint) : void
      {
      }
      
      public function create() : void
      {
      }
      
      public function dispose() : void
      {
      }
      
      public function read_editMode(param1:XData) : void
      {
      }
      
      public function write_editMode() : XData
      {
         return null;
      }
      
      public function read(param1:XData, param2:Object) : void
      {
      }
      
      public function write() : XData
      {
         return null;
      }
      
      public function handleControllerChanged(param1:FController) : void
      {
      }
      
      public function getProp(param1:int) : *
      {
         return undefined;
      }
      
      public function setProp(param1:int, param2:*) : void
      {
      }
   }
}
