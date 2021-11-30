package fairygui
{
   public class GearIcon extends GearBase
   {
       
      
      private var _storage:Object;
      
      private var _default:String;
      
      public function GearIcon(param1:GObject)
      {
         super(param1);
      }
      
      override protected function init() : void
      {
         _default = _owner.icon;
         _storage = {};
      }
      
      override protected function addStatus(param1:String, param2:String) : void
      {
         if(param1 == null)
         {
            _default = param2;
         }
         else
         {
            _storage[param1] = param2;
         }
      }
      
      override public function apply() : void
      {
         _owner._gearLocked = true;
         var _loc1_:* = _storage[_controller.selectedPageId];
         if(_loc1_ != undefined)
         {
            _owner.icon = String(_loc1_);
         }
         else
         {
            _owner.icon = _default;
         }
         _owner._gearLocked = false;
      }
      
      override public function updateState() : void
      {
         _storage[_controller.selectedPageId] = _owner.icon;
      }
   }
}
