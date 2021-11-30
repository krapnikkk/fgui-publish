package fairygui.gears
{
   import fairygui.GObject;
   import fairygui.UIPackage;
   import fairygui.tween.GTween;
   import fairygui.tween.GTweener;
   
   public class GearXY extends GearBase
   {
       
      
      public var positionsInPercent:Boolean;
      
      private var _storage:Object;
      
      private var _default:Object;
      
      public function GearXY(param1:GObject)
      {
         super(param1);
      }
      
      override protected function init() : void
      {
         _default = {
            "x":_owner.x,
            "y":_owner.y,
            "px":_owner.x / _owner.parent.width,
            "py":_owner.y / _owner.parent.height
         };
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
            _loc4_ = {};
            _storage[param1] = _loc4_;
         }
         _loc4_.x = parseInt(_loc3_[0]);
         _loc4_.y = parseInt(_loc3_[1]);
         _loc4_.px = parseFloat(_loc3_[2]);
         _loc4_.py = parseFloat(_loc3_[3]);
         if(isNaN(_loc4_.px))
         {
            _loc4_.px = _loc4_.x / _owner.parent.width;
            _loc4_.py = _loc4_.y / _owner.parent.height;
         }
      }
      
      override public function apply() : void
      {
         var _loc1_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc2_:Object = _storage[_controller.selectedPageId];
         if(!_loc2_)
         {
            _loc2_ = _default;
         }
         if(positionsInPercent && _owner.parent)
         {
            _loc1_ = _loc2_.px * _owner.parent.width;
            _loc3_ = _loc2_.py * _owner.parent.height;
         }
         else
         {
            _loc1_ = _loc2_.x;
            _loc3_ = _loc2_.y;
         }
         if(_tweenConfig != null && _tweenConfig.tween && !UIPackage._constructing && !disableAllTweenEffect)
         {
            if(_tweenConfig._tweener != null)
            {
               if(_tweenConfig._tweener.endValue.x != _loc1_ || _tweenConfig._tweener.endValue.y != _loc3_)
               {
                  _tweenConfig._tweener.kill(true);
                  _tweenConfig._tweener = null;
               }
               else
               {
                  return;
               }
            }
            _loc4_ = _owner.x;
            _loc5_ = _owner.y;
            if(_loc4_ != _loc1_ || _loc5_ != _loc3_)
            {
               if(_owner.checkGearController(0,_controller))
               {
                  _tweenConfig._displayLockToken = _owner.addDisplayLock();
               }
               _tweenConfig._tweener = GTween.to2(_loc4_,_loc5_,_loc1_,_loc3_,_tweenConfig.duration).setDelay(_tweenConfig.delay).setEase(_tweenConfig.easeType).setTarget(this).onUpdate(__tweenUpdate).onComplete(__tweenComplete);
            }
         }
         else
         {
            _owner._gearLocked = true;
            _owner.setXY(_loc1_,_loc3_);
            _owner._gearLocked = false;
         }
      }
      
      private function __tweenUpdate(param1:GTweener) : void
      {
         _owner._gearLocked = true;
         _owner.setXY(param1.value.x,param1.value.y);
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
         var _loc1_:Object = _storage[_controller.selectedPageId];
         if(!_loc1_)
         {
            _loc1_ = {};
            _storage[_controller.selectedPageId] = _loc1_;
         }
         _loc1_.x = _owner.x;
         _loc1_.y = _owner.y;
         if(_owner.parent)
         {
            _loc1_.px = _owner.x / _owner.parent.width;
            _loc1_.py = _owner.y / _owner.parent.height;
         }
      }
      
      override public function updateFromRelations(param1:Number, param2:Number) : void
      {
         if(_controller == null || _storage == null || positionsInPercent)
         {
            return;
         }
         var _loc5_:int = 0;
         var _loc4_:* = _storage;
         for each(var _loc3_ in _storage)
         {
            _loc3_.x = _loc3_.x + param1;
            _loc3_.y = _loc3_.y + param2;
         }
         _default.x = _default.x + param1;
         _default.y = _default.y + param2;
         updateState();
      }
   }
}
