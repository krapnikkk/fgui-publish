package fairygui.gears
{
   import fairygui.GObject;
   import fairygui.UIPackage;
   import fairygui.tween.GTween;
   import fairygui.tween.GTweener;
   
   public class GearSize extends GearBase
   {
       
      
      private var _storage:Object;
      
      private var _default:GearSizeValue#787;
      
      public function GearSize(param1:GObject)
      {
         super(param1);
      }
      
      override protected function init() : void
      {
         _default = new GearSizeValue#787(_owner.width,_owner.height,_owner.scaleX,_owner.scaleY);
         _storage = {};
      }
      
      override protected function addStatus(param1:String, param2:String) : void
      {
         var _loc4_:* = null;
         if(param2 == "-" || param2.length == 0)
         {
            return;
         }
         var _loc3_:Array = param2.split(",");
         if(param1 == null)
         {
            _loc4_ = _default;
         }
         else
         {
            _loc4_ = new GearSizeValue#787();
            _storage[param1] = _loc4_;
         }
         _loc4_.width = parseInt(_loc3_[0]);
         _loc4_.height = parseInt(_loc3_[1]);
         if(_loc3_.length > 2)
         {
            _loc4_.scaleX = parseFloat(_loc3_[2]);
            _loc4_.scaleY = parseFloat(_loc3_[3]);
         }
      }
      
      override public function apply() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:GearSizeValue = _storage[_controller.selectedPageId];
         if(!_loc3_)
         {
            _loc3_ = _default;
         }
         if(_tweenConfig != null && _tweenConfig.tween && !UIPackage._constructing && !disableAllTweenEffect)
         {
            if(_tweenConfig._tweener != null)
            {
               if(_tweenConfig._tweener.endValue.x != _loc3_.width || _tweenConfig._tweener.endValue.y != _loc3_.height || _tweenConfig._tweener.endValue.z != _loc3_.scaleX || _tweenConfig._tweener.endValue.w != _loc3_.scaleY)
               {
                  _tweenConfig._tweener.kill(true);
                  _tweenConfig._tweener = null;
               }
               else
               {
                  return;
               }
            }
            _loc1_ = _loc3_.width != _owner.width || _loc3_.height != _owner.height;
            _loc2_ = _loc3_.scaleX != _owner.scaleX || _loc3_.scaleY != _owner.scaleY;
            if(_loc1_ || _loc2_)
            {
               if(_owner.checkGearController(0,_controller))
               {
                  _tweenConfig._displayLockToken = _owner.addDisplayLock();
               }
               _tweenConfig._tweener = GTween.to4(_owner.width,_owner.height,_owner.scaleX,_owner.scaleY,_loc3_.width,_loc3_.height,_loc3_.scaleX,_loc3_.scaleY,_tweenConfig.duration).setDelay(_tweenConfig.delay).setEase(_tweenConfig.easeType).setUserData((!!_loc1_?1:0) + (!!_loc2_?2:0)).setTarget(this).onUpdate(__tweenUpdate).onComplete(__tweenComplete);
            }
         }
         else
         {
            _owner._gearLocked = true;
            _owner.setSize(_loc3_.width,_loc3_.height,_owner.checkGearController(1,_controller));
            _owner.setScale(_loc3_.scaleX,_loc3_.scaleY);
            _owner._gearLocked = false;
         }
      }
      
      private function __tweenUpdate(param1:GTweener) : void
      {
         var _loc2_:int = param1.userData;
         _owner._gearLocked = true;
         if((_loc2_ & 1) != 0)
         {
            _owner.setSize(param1.value.x,param1.value.y,_owner.checkGearController(1,_controller));
         }
         if((_loc2_ & 2) != 0)
         {
            _owner.setScale(param1.value.z,param1.value.w);
         }
         _owner._gearLocked = false;
      }
      
      private function __tweenComplete() : void
      {
         if(_tweenConfig._displayLockToken != 0)
         {
            _owner.releaseDisplayLock(_tweenConfig._displayLockToken);
            _tweenConfig._displayLockToken = 0;
         }
         _tweenConfig._tweener = null;
      }
      
      override public function updateState() : void
      {
         var _loc1_:GearSizeValue = _storage[_controller.selectedPageId];
         if(!_loc1_)
         {
            _loc1_ = new GearSizeValue#787();
            _storage[_controller.selectedPageId] = _loc1_;
         }
         _loc1_.width = _owner.width;
         _loc1_.height = _owner.height;
         _loc1_.scaleX = _owner.scaleX;
         _loc1_.scaleY = _owner.scaleY;
      }
      
      override public function updateFromRelations(param1:Number, param2:Number) : void
      {
         if(_controller == null || _storage == null)
         {
            return;
         }
         var _loc5_:int = 0;
         var _loc4_:* = _storage;
         for each(var _loc3_ in _storage)
         {
            _loc3_.width = _loc3_.width + param1;
            _loc3_.height = _loc3_.height + param2;
         }
         GearSizeValue#787(_default).width = GearSizeValue#787(_default).width + param1;
         GearSizeValue#787(_default).height = GearSizeValue#787(_default).height + param2;
         updateState();
      }
   }
}

class GearSizeValue#787
{
    
   
   public var width:Number;
   
   public var height:Number;
   
   public var scaleX:Number;
   
   public var scaleY:Number;
   
   function GearSizeValue#787(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0)
   {
      super();
      this.width = param1;
      this.height = param2;
      this.scaleX = param3;
      this.scaleY = param4;
   }
}
