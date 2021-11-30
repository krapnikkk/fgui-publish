package fairygui.event
{
   import flash.events.Event;
   
   public class StateChangeEvent extends Event
   {
      
      public static const CHANGED:String = "stateChanged";
       
      
      public function StateChangeEvent(param1:String)
      {
         super(param1,false,false);
      }
      
      override public function clone() : Event
      {
         return new StateChangeEvent(type);
      }
   }
}
