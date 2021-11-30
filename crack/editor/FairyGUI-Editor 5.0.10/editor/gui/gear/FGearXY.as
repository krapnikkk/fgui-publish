package fairygui.editor.gui.gear
{
   import fairygui.editor.gui.FObject;
   import fairygui.editor.gui.FObjectFactory;
   import fairygui.editor.gui.FObjectFlags;
   import fairygui.tween.EaseType;
   import fairygui.tween.GTween;
   import fairygui.tween.GTweener;
   import fairygui.utils.UtilsStr;
   
   public class FGearXY extends FGearBase
   {
       
      
      private var _tweener:GTweener;
      
      public function FGearXY(param1:FObject)
      {
         super(param1);
         _gearIndex = 1;
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
      
      override protected function writeValue(param1:Object) : String
      {
         if(_positionsInPercent)
         {
            return int(param1.x) + "," + int(param1.y) + "," + UtilsStr.toFixed(param1.px,3) + "," + UtilsStr.toFixed(param1.py,3);
         }
         return int(param1.x) + "," + int(param1.y);
      }
      
      override protected function readValue(param1:String) : Object
      {
         if(param1 == "-" || param1.length == 0)
         {
            return null;
         }
         var _loc2_:Array = param1.split(",");
         var _loc3_:Object = {};
         _loc3_.x = parseInt(_loc2_[0]);
         _loc3_.y = parseInt(_loc2_[1]);
         _loc3_.px = parseFloat(_loc2_[2]);
         _loc3_.py = parseFloat(_loc2_[3]);
         if(isNaN(_loc3_.px))
         {
            _loc3_.px = _loc3_.x / _owner.parent.width;
            _loc3_.py = _loc3_.y / _owner.parent.height;
         }
         return _loc3_;
      }
      
      override public function apply() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc1_:Object = _storage[_controller.selectedPageId];
         if(!_loc1_)
         {
            _loc1_ = _default;
         }
         if(_positionsInPercent && _owner.parent)
         {
            _loc2_ = _loc1_.px * _owner.parent.width;
            _loc3_ = _loc1_.py * _owner.parent.height;
         }
         else
         {
            _loc2_ = _loc1_.x;
            _loc3_ = _loc1_.y;
         }
         if(_tween && (_owner._flags & FObjectFlags.IN_TEST) != 0 && !FObjectFactory.constructingDepth)
         {
            if(this._tweener != null)
            {
               if(this._tweener.endValue.x != _loc2_ || this._tweener.endValue.y != _loc3_)
               {
                  this._tweener.kill(true);
                  this._tweener = null;
               }
               else
               {
                  return;
               }
            }
            _loc4_ = _owner.x;
            _loc5_ = _owner.y;
            if(_loc4_ != _loc2_ || _loc5_ != _loc3_)
            {
               if(_owner.checkGearController(0,_controller))
               {
                  _displayLockToken = _owner.addDisplayLock();
               }
               this._tweener = GTween.to2(_loc4_,_loc5_,_loc2_,_loc3_,_duration).setDelay(_delay).setEase(EaseType.parseEaseType(this.easeName)).setTarget(this).onUpdate(this.__tweenUpdate).onComplete(this.__tweenComplete);
            }
         }
         else
         {
            _owner._gearLocked = true;
            _owner.setXY(_loc2_,_loc3_);
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
         if(_displayLockToken != 0)
         {
            _owner.releaseDisplayLock(_displayLockToken);
            _displayLockToken = 0;
         }
         this._tweener = null;
      }
      
      override public function updateState() : void
      {
         var _loc1_:Object = null;
         _loc1_ = _storage[_controller.selectedPageId];
         if(!_loc1_)
         {
            _loc1_ = {};
            _storage[_controller.selectedPageId] = _loc1_;
         }
         _loc1_.x = _owner.x;
         _loc1_.y = _owner.y;
         _loc1_.px = _owner.x / _owner.parent.width;
         _loc1_.py = _owner.y / _owner.parent.height;
      }
      
      override public function updateFromRelations(param1:Number, param2:Number) : void
      {
         var _loc3_:Object = null;
         if(_controller == null || _storage == null || _positionsInPercent)
         {
            return;
         }
         for each(_loc3_ in _storage)
         {
            _loc3_.x = _loc3_.x + param1;
            _loc3_.y = _loc3_.y + param2;
         }
         _default.x = _default.x + param1;
         _default.y = _default.y + param2;
         this.updateState();
      }
   }
}
