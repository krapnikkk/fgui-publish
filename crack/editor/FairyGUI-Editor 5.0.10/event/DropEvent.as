package fairygui.event
{
   import flash.events.Event;
   
   public class DropEvent extends Event
   {
      
      public static const DROP:String = "dropEvent";
       
      
      public var source:Object;
      
      public function DropEvent(param1:String, param2:Object)
      {
         super(param1,false,false);
         this.source = param2;
      }
      
      override public function clone() : Event
      {
         return new DropEvent(type,source);
      }
   }
}
