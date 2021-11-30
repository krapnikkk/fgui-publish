package fairygui.gears
{
   import fairygui.GObject;
   
   public class GearDisplay2 extends GearBase
   {
       
      
      public var pages:Array;
      
      public var condition:int;
      
      private var _visible:int;
      
      public function GearDisplay2(param1:GObject)
      {
         super(param1);
      }
      
      override protected function init() : void
      {
         pages = null;
      }
      
      public function evaluate(param1:Boolean) : Boolean
      {
         var _loc2_:Boolean = _controller == null || _visible > 0;
         if(condition == 0)
         {
            _loc2_ = _loc2_ && param1;
         }
         else
         {
            _loc2_ = _loc2_ || param1;
         }
         return _loc2_;
      }
      
      override public function apply() : void
      {
         if(pages == null || pages.length == 0 || pages.indexOf(_controller.selectedPageId) != -1)
         {
            _visible = 1;
         }
         else
         {
            _visible = 0;
         }
      }
   }
}
