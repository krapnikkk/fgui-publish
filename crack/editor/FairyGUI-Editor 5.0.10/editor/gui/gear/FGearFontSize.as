package fairygui.editor.gui.gear
{
   import fairygui.ObjectPropID;
   import fairygui.editor.gui.FObject;
   
   public class FGearFontSize extends FGearBase
   {
       
      
      public function FGearFontSize(param1:FObject)
      {
         super(param1);
         _gearIndex = 9;
      }
      
      override protected function init() : void
      {
         _default = _owner.getProp(ObjectPropID.FontSize);
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
            return 0;
         }
         return parseInt(param1);
      }
      
      override public function apply() : void
      {
         _owner._gearLocked = true;
         var _loc1_:* = _storage[_controller.selectedPageId];
         if(_loc1_ != undefined)
         {
            _owner.setProp(ObjectPropID.FontSize,_loc1_);
         }
         else
         {
            _owner.setProp(ObjectPropID.FontSize,_default);
         }
         _owner._gearLocked = false;
      }
      
      override public function updateState() : void
      {
         var _loc1_:int = _owner.getProp(ObjectPropID.FontSize);
         if(_default == _loc1_)
         {
            delete _storage[_controller.selectedPageId];
         }
         else
         {
            _storage[_controller.selectedPageId] = _loc1_;
         }
      }
   }
}
