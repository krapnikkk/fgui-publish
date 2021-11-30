package fairygui
{
   public class GearAnimation extends GearBase
   {
       
      
      private var _storage:Object;
      
      private var _default:GearAnimationValue#251;
      
      public function GearAnimation(param1:GObject)
      {
         super(param1);
      }
      
      override protected function init() : void
      {
         _default = new GearAnimationValue#251(IAnimationGear(_owner).playing,IAnimationGear(_owner).frame);
         _storage = {};
      }
      
      override protected function addStatus(param1:String, param2:String) : void
      {
         var _loc4_:* = null;
         if(param2 == "-" || param2.length == 0)
         {
            return;
         }
         if(param1 == null)
         {
            _loc4_ = _default;
         }
         else
         {
            _loc4_ = new GearAnimationValue#251();
            _storage[param1] = _loc4_;
         }
         var _loc3_:Array = param2.split(",");
         _loc4_.frame = int(_loc3_[0]);
         _loc4_.playing = _loc3_[1] == "p";
      }
      
      override public function apply() : void
      {
         _owner._gearLocked = true;
         var _loc1_:GearAnimationValue = _storage[_controller.selectedPageId];
         if(!_loc1_)
         {
            _loc1_ = _default;
         }
         IAnimationGear(_owner).playing = _loc1_.playing;
         IAnimationGear(_owner).frame = _loc1_.frame;
         _owner._gearLocked = false;
      }
      
      override public function updateState() : void
      {
         var _loc1_:IAnimationGear = IAnimationGear(_owner);
         var _loc2_:GearAnimationValue = _storage[_controller.selectedPageId];
         if(!_loc2_)
         {
            _loc2_ = new GearAnimationValue#251();
            _storage[_controller.selectedPageId] = _loc2_;
         }
         _loc2_.playing = _loc1_.playing;
         _loc2_.frame = _loc1_.frame;
      }
   }
}

class GearAnimationValue#251
{
    
   
   public var playing:Boolean;
   
   public var frame:int;
   
   function GearAnimationValue#251(param1:Boolean = true, param2:int = 0)
   {
      super();
      this.playing = param1;
      this.frame = param2;
   }
}
