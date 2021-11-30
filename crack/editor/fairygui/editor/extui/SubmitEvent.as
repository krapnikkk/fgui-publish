package fairygui.editor.extui
{
   import flash.events.Event;
   
   public class SubmitEvent extends Event
   {
      
      public static const SUBMIT:String = "__submit";
       
      
      public function SubmitEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
