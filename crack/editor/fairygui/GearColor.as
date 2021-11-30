package fairygui
{
   import fairygui.utils.ToolSet;
   
   public class GearColor extends GearBase
   {
       
      
      private var _storage:Object;
      
      private var _default:GearColorValue#330;
      
      public function GearColor(param1:GObject)
      {
         super(param1);
      }
      
      override protected function init() : void
      {
         if(_owner is ITextColorGear)
         {
            _default = new GearColorValue#330(IColorGear(_owner).color,ITextColorGear(_owner).strokeColor);
         }
         else
         {
            _default = new GearColorValue#330(IColorGear(_owner).color);
         }
         _storage = {};
      }
      
      override protected function addStatus(param1:String, param2:String) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         if(param2 == "-" || param2.length == 0)
         {
            return;
         }
         var _loc5_:int = param2.indexOf(",");
         if(_loc5_ == -1)
         {
            _loc3_ = uint(ToolSet.convertFromHtmlColor(param2));
            _loc4_ = uint(4278190080);
         }
         else
         {
            _loc3_ = uint(ToolSet.convertFromHtmlColor(param2.substr(0,_loc5_)));
            _loc4_ = uint(ToolSet.convertFromHtmlColor(param2.substr(_loc5_ + 1)));
         }
         if(param1 == null)
         {
            _default.color = _loc3_;
            _default.strokeColor = _loc4_;
         }
         else
         {
            _storage[param1] = new GearColorValue#330(_loc3_,_loc4_);
         }
      }
      
      override public function apply() : void
      {
         _owner._gearLocked = true;
         var _loc1_:GearColorValue = _storage[_controller.selectedPageId];
         if(!_loc1_)
         {
            _loc1_ = _default;
         }
         IColorGear(_owner).color = _loc1_.color;
         if(_owner is ITextColorGear && _loc1_.strokeColor != 4278190080)
         {
            ITextColorGear(_owner).strokeColor = _loc1_.strokeColor;
         }
         _owner._gearLocked = false;
      }
      
      override public function updateState() : void
      {
         var _loc1_:GearColorValue = _storage[_controller.selectedPageId];
         if(!_loc1_)
         {
            _loc1_ = new GearColorValue#330();
            _storage[_controller.selectedPageId] = _loc1_;
         }
         _loc1_.color = IColorGear(_owner).color;
         if(_owner is ITextColorGear)
         {
            _loc1_.strokeColor = ITextColorGear(_owner).strokeColor;
         }
      }
   }
}

class GearColorValue#330
{
    
   
   public var color:uint;
   
   public var strokeColor:uint;
   
   function GearColorValue#330(param1:uint = 0, param2:uint = 0)
   {
      super();
      this.color = param1;
      this.strokeColor = param2;
   }
}
