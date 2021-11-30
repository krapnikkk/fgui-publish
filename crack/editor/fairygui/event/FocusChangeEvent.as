package fairygui.event
{
   import fairygui.GObject;
   import flash.events.Event;
   
   public class FocusChangeEvent extends Event
   {
      
      public static const CHANGED:String = "focusChanged";
       
      
      private var _oldFocusedObject:GObject;
      
      private var _newFocusedObject:GObject;
      
      public function FocusChangeEvent(param1:String, param2:GObject, param3:GObject)
      {
         super(param1,false,false);
         _oldFocusedObject = param2;
         _newFocusedObject = param3;
      }
      
      public final function get oldFocusedObject() : GObject
      {
         return _oldFocusedObject;
      }
      
      public final function get newFocusedObject() : GObject
      {
         return _newFocusedObject;
      }
      
      override public function clone() : Event
      {
         return new FocusChangeEvent(type,_oldFocusedObject,_newFocusedObject);
      }
   }
}
