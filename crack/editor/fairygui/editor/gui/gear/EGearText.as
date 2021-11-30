package fairygui.editor.gui.gear
{
   import fairygui.editor.gui.EGObject;
   
   public class EGearText extends EGearBase
   {
       
      
      public function EGearText(param1:EGObject)
      {
         super(param1);
         gearIndex = 6;
      }
      
      override protected function init() : void
      {
         _default = owner.text;
         _storage = {};
      }
      
      override protected function writeValue(param1:Object) : String
      {
         return String(param1);
      }
      
      override protected function readValue(param1:String) : Object
      {
         if(param1 == null)
         {
            return "";
         }
         return param1;
      }
      
      override public function apply() : void
      {
         owner.gearLocked = true;
         var _loc1_:* = _storage[_controller.selectedPageId];
         if(_loc1_ != undefined)
         {
            owner.text = _loc1_;
         }
         else
         {
            owner.text = _default;
         }
         owner.gearLocked = false;
      }
      
      override public function updateState() : void
      {
         var _loc1_:String = owner.text;
         if(_default == null || _default == _loc1_)
         {
            _default = _loc1_;
            delete _storage[_controller.selectedPageId];
         }
         else
         {
            _storage[_controller.selectedPageId] = _loc1_;
         }
      }
   }
}
