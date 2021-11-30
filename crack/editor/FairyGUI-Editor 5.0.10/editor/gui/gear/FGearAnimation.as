package fairygui.editor.gui.gear
{
   import fairygui.ObjectPropID;
   import fairygui.editor.gui.FObject;
   
   public class FGearAnimation extends FGearBase
   {
       
      
      public function FGearAnimation(param1:FObject)
      {
         super(param1);
         _gearIndex = 5;
      }
      
      override protected function init() : void
      {
         _default = new GearAnimationValue#1278(_owner.getProp(ObjectPropID.Playing),_owner.getProp(ObjectPropID.Frame));
         _storage = {};
      }
      
      override protected function writeValue(param1:Object) : String
      {
         var _loc2_:GearAnimationValue = GearAnimationValue#1278(param1);
         return _loc2_.frame + "," + (!!_loc2_.playing?"p":"s");
      }
      
      override protected function readValue(param1:String) : Object
      {
         if(param1 == "-" || param1.length == 0)
         {
            return null;
         }
         var _loc2_:GearAnimationValue = new GearAnimationValue#1278();
         var _loc3_:Array = param1.split(",");
         _loc2_.frame = int(_loc3_[0]);
         _loc2_.playing = _loc3_[1] == "p";
         return _loc2_;
      }
      
      override public function apply() : void
      {
         _owner._gearLocked = true;
         var _loc1_:GearAnimationValue = _storage[_controller.selectedPageId];
         if(!_loc1_)
         {
            _loc1_ = _default;
         }
         _owner.setProp(ObjectPropID.Playing,_loc1_.playing);
         _owner.setProp(ObjectPropID.Frame,_loc1_.frame);
         _owner._gearLocked = false;
      }
      
      override public function updateState() : void
      {
         var _loc1_:GearAnimationValue = _storage[_controller.selectedPageId];
         if(!_loc1_)
         {
            _loc1_ = new GearAnimationValue#1278();
            _storage[_controller.selectedPageId] = _loc1_;
         }
         _loc1_.playing = _owner.getProp(ObjectPropID.Playing);
         _loc1_.frame = _owner.getProp(ObjectPropID.Frame);
      }
   }
}

class GearAnimationValue#1278
{
    
   
   public var playing:Boolean;
   
   public var frame:int;
   
   function GearAnimationValue#1278(param1:Boolean = false, param2:int = 0)
   {
      super();
      this.playing = param1;
      this.frame = param2;
   }
}
