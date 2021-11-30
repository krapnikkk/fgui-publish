package fairygui.event
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TouchEvent;
   
   public class GTouchEvent extends Event
   {
      
      public static const BEGIN:String = "beginGTouch";
      
      public static const DRAG:String = "dragGTouch";
      
      public static const END:String = "endGTouch";
      
      public static const CLICK:String = "clickGTouch";
       
      
      private var _stopPropagation:Boolean;
      
      private var _realTarget:DisplayObject;
      
      private var _clickCount:int;
      
      private var _stageX:Number;
      
      private var _stageY:Number;
      
      private var _shiftKey:Boolean;
      
      private var _ctrlKey:Boolean;
      
      private var _touchPointID:int;
      
      public function GTouchEvent(param1:String)
      {
         super(param1,false,false);
      }
      
      public function copyFrom(param1:Event, param2:int = 1) : void
      {
         if(param1 is MouseEvent)
         {
            _stageX = MouseEvent(param1).stageX;
            _stageY = MouseEvent(param1).stageY;
            _shiftKey = MouseEvent(param1).shiftKey;
            _ctrlKey = MouseEvent(param1).ctrlKey;
         }
         else
         {
            _stageX = TouchEvent(param1).stageX;
            _stageY = TouchEvent(param1).stageY;
            _shiftKey = TouchEvent(param1).shiftKey;
            _ctrlKey = TouchEvent(param1).ctrlKey;
            _touchPointID = TouchEvent(param1).touchPointID;
         }
         _realTarget = param1.target as DisplayObject;
         _clickCount = param2;
         _stopPropagation = false;
      }
      
      public final function get realTarget() : DisplayObject
      {
         return _realTarget;
      }
      
      public final function get clickCount() : int
      {
         return _clickCount;
      }
      
      public final function get stageX() : Number
      {
         return _stageX;
      }
      
      public final function get stageY() : Number
      {
         return _stageY;
      }
      
      public final function get shiftKey() : Boolean
      {
         return _shiftKey;
      }
      
      public final function get ctrlKey() : Boolean
      {
         return _ctrlKey;
      }
      
      public final function get touchPointID() : int
      {
         return _touchPointID;
      }
      
      override public function stopPropagation() : void
      {
         _stopPropagation = true;
      }
      
      public final function get isPropagationStop() : Boolean
      {
         return _stopPropagation;
      }
      
      override public function clone() : Event
      {
         var _loc1_:GTouchEvent = new GTouchEvent(type);
         _loc1_._realTarget = _realTarget;
         _loc1_._clickCount = _clickCount;
         _loc1_._stageX = _stageX;
         _loc1_._stageY = _stageY;
         _loc1_._shiftKey = _shiftKey;
         _loc1_._ctrlKey = _ctrlKey;
         _loc1_._touchPointID = _touchPointID;
         return _loc1_;
      }
   }
}
