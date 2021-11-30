package fairygui.editor.gui
{
   import flash.events.Event;
   
   public class EItemEvent extends Event
   {
      
      public static const CLICK:String = "___itemClick";
       
      
      public var itemObject:EGObject;
      
      public var stageX:Number;
      
      public var stageY:Number;
      
      public var clickCount:int;
      
      public var rightButton:Boolean;
      
      public function EItemEvent(param1:String, param2:EGObject = null, param3:Number = 0, param4:Number = 0, param5:int = 1, param6:Boolean = false)
      {
         super(param1,false,false);
         this.itemObject = param2;
         this.stageX = param3;
         this.stageY = param4;
         this.clickCount = param5;
         this.rightButton = param6;
      }
      
      override public function clone() : Event
      {
         return new EItemEvent(type,this.itemObject,this.stageX,this.stageY,this.clickCount,this.rightButton);
      }
   }
}
