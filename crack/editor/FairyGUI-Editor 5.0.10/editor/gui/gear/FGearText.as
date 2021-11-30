package fairygui.editor.gui.gear
{
   import fairygui.editor.gui.FObject;
   
   public class FGearText extends FGearBase
   {
       
      
      public function FGearText(param1:FObject)
      {
         super(param1);
         _gearIndex = 6;
      }
      
      override protected function init() : void
      {
         _default = _owner.text;
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
         _owner._gearLocked = true;
         var _loc1_:* = _storage[_controller.selectedPageId];
         if(_loc1_ != undefined)
         {
            _owner.text = _loc1_;
         }
         else
         {
            _owner.text = _default;
         }
         _owner._gearLocked = false;
      }
      
      override public function updateState() : void
      {
         var _loc1_:String = _owner.text;
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
