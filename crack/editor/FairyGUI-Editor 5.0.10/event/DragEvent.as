package fairygui.event
{
   import flash.events.Event;
   
   public class DragEvent extends Event
   {
      
      public static const DRAG_START:String = "startDrag";
      
      public static const DRAG_END:String = "endDrag";
      
      public static const DRAG_MOVING:String = "dragMoving";
       
      
      public var stageX:Number;
      
      public var stageY:Number;
      
      public var touchPointID:int;
      
      public function DragEvent(param1:String, param2:Number = 0, param3:Number = 0, param4:int = -1)
      {
         super(param1,false,true);
         this.stageX = param2;
         this.stageY = param3;
         this.touchPointID = param4;
      }
      
      override public function clone() : Event
      {
         return new DragEvent(type,stageX,stageY,touchPointID);
      }
   }
}
