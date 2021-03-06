package fairygui.event
{
   import fairygui.GObject;
   import flash.events.Event;
   
   public class ItemEvent extends Event
   {
      
      public static const CLICK:String = "itemClick";
       
      
      public var itemObject:GObject;
      
      public var stageX:Number;
      
      public var stageY:Number;
      
      public var clickCount:int;
      
      public var rightButton:Boolean;
      
      public function ItemEvent(param1:String, param2:GObject = null, param3:Number = 0, param4:Number = 0, param5:int = 1, param6:Boolean = false)
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
         return new ItemEvent(type,itemObject,stageX,stageY,clickCount,rightButton);
      }
   }
}
