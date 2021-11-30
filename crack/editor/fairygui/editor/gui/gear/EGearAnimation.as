package fairygui.editor.gui.gear
{
   import fairygui.editor.gui.EGObject;
   
   public class EGearAnimation extends EGearBase
   {
       
      
      public function EGearAnimation(param1:EGObject)
      {
         super(param1);
         gearIndex = 5;
      }
      
      override protected function init() : void
      {
         var _loc1_:EIAnimationGear = EIAnimationGear(owner);
         _default = new GearAnimationValue#986(_loc1_.playing,_loc1_.frame);
         _storage = {};
      }
      
      override protected function writeValue(param1:Object) : String
      {
         var _loc2_:GearAnimationValue = GearAnimationValue#986(param1);
         return _loc2_.frame + "," + (!!_loc2_.playing?"p":"s");
      }
      
      override protected function readValue(param1:String) : Object
      {
         if(param1 == "-" || param1.length == 0)
         {
            return null;
         }
         var _loc3_:GearAnimationValue = new GearAnimationValue#986();
         var _loc2_:Array = param1.split(",");
         _loc3_.frame = int(_loc2_[0]);
         _loc3_.playing = _loc2_[1] == "p";
         return _loc3_;
      }
      
      override public function apply() : void
      {
         owner.gearLocked = true;
         var _loc2_:GearAnimationValue = _storage[_controller.selectedPageId];
         if(!_loc2_)
         {
            _loc2_ = _default;
         }
         var _loc1_:EIAnimationGear = EIAnimationGear(owner);
         _loc1_.playing = _loc2_.playing;
         _loc1_.frame = _loc2_.frame;
         owner.gearLocked = false;
      }
      
      override public function updateState() : void
      {
         var _loc2_:GearAnimationValue = _storage[_controller.selectedPageId];
         if(!_loc2_)
         {
            _loc2_ = new GearAnimationValue#986();
            _storage[_controller.selectedPageId] = _loc2_;
         }
         var _loc1_:EIAnimationGear = EIAnimationGear(owner);
         _loc2_.frame = _loc1_.frame;
         _loc2_.playing = _loc1_.playing;
      }
   }
}

class GearAnimationValue#986
{
    
   
   public var playing:Boolean;
   
   public var frame:int;
   
   function GearAnimationValue#986(param1:Boolean = false, param2:int = 0)
   {
      super();
      this.playing = param1;
      this.frame = param2;
   }
}
