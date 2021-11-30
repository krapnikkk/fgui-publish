package fairygui
{
   import com.greensock.TweenLite;
   import flash.geom.Point;
   
   public class GearXY extends GearBase
   {
       
      
      public var tweener:TweenLite;
      
      private var _storage:Object;
      
      private var _default:Point;
      
      private var _tweenValue:Point;
      
      public function GearXY(param1:GObject)
      {
         super(param1);
      }
      
      override protected function init() : void
      {
         _default = new Point(_owner.x,_owner.y);
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
            _loc4_ = new Point();
            _storage[param1] = _loc4_;
         }
         _loc4_.x = parseInt(_loc3_[0]);
         _loc4_.y = parseInt(_loc3_[1]);
      }
      
      override public function apply() : void
      {
         var _loc1_:* = null;
         var _loc2_:Point = _storage[_controller.selectedPageId];
         if(!_loc2_)
         {
            _loc2_ = _default;
         }
         if(_tween && !UIPackage._constructing && !disableAllTweenEffect)
         {
            if(tweener != null)
            {
               if(tweener.vars.x != _loc2_.x || tweener.vars.y != _loc2_.y)
               {
                  _owner._gearLocked = true;
                  _owner.setXY(tweener.vars.x,tweener.vars.y);
                  _owner._gearLocked = false;
                  tweener.kill();
                  tweener = null;
                  _owner.releaseDisplayLock(_displayLockToken);
                  _displayLockToken = 0;
               }
               else
               {
                  return;
               }
            }
            if(_owner.x != _loc2_.x || _owner.y != _loc2_.y)
            {
               if(_owner.checkGearController(0,_controller))
               {
                  _displayLockToken = _owner.addDisplayLock();
               }
               _loc1_ = {
                  "x":_loc2_.x,
                  "y":_loc2_.y,
                  "ease":_easeType,
                  "delay":_delay,
                  "overwrite":0
               };
               _loc1_.onUpdate = __tweenUpdate;
               _loc1_.onComplete = __tweenComplete;
               if(_tweenValue == null)
               {
                  _tweenValue = new Point();
               }
               _tweenValue.x = _owner.x;
               _tweenValue.y = _owner.y;
               tweener = TweenLite.to(_tweenValue,_tweenTime,_loc1_);
            }
         }
         else
         {
            _owner._gearLocked = true;
            _owner.setXY(_loc2_.x,_loc2_.y);
            _owner._gearLocked = false;
         }
      }
      
      private function __tweenUpdate() : void
      {
         _owner._gearLocked = true;
         _owner.setXY(_tweenValue.x,_tweenValue.y);
         _owner._gearLocked = false;
      }
      
      private function __tweenComplete() : void
      {
         if(_displayLockToken != 0)
         {
            _owner.releaseDisplayLock(_displayLockToken);
            _displayLockToken = 0;
         }
         tweener = null;
      }
      
      override public function updateState() : void
      {
         var _loc1_:Point = _storage[_controller.selectedPageId];
         if(!_loc1_)
         {
            _loc1_ = new Point();
            _storage[_controller.selectedPageId] = _loc1_;
         }
         _loc1_.x = _owner.x;
         _loc1_.y = _owner.y;
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
            _loc3_.x = _loc3_.x + param1;
            _loc3_.y = _loc3_.y + param2;
         }
         _default.x = _default.x + param1;
         _default.y = _default.y + param2;
         updateState();
      }
   }
}
