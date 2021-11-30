package fairygui
{
   import com.greensock.TweenLite;
   
   public class GearSize extends GearBase
   {
       
      
      public var tweener:TweenLite;
      
      private var _storage:Object;
      
      private var _default:GearSizeValue#424;
      
      private var _tweenValue:GearSizeValue#424;
      
      public function GearSize(param1:GObject)
      {
         super(param1);
      }
      
      override protected function init() : void
      {
         _default = new GearSizeValue#424(_owner.width,_owner.height,_owner.scaleX,_owner.scaleY);
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
            _loc4_ = new GearSizeValue#424();
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
         var _loc3_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc1_:* = null;
         var _loc4_:GearSizeValue = _storage[_controller.selectedPageId];
         if(!_loc4_)
         {
            _loc4_ = _default;
         }
         if(_tween && !UIPackage._constructing && !disableAllTweenEffect)
         {
            if(tweener != null)
            {
               _loc3_ = tweener.vars.onUpdateParams[0];
               _loc2_ = tweener.vars.onUpdateParams[1];
               if(_loc3_ && (tweener.vars.width != _loc4_.width || tweener.vars.height != _loc4_.height) || _loc2_ && (tweener.vars.scaleX != _loc4_.scaleX || tweener.vars.scaleY != _loc4_.scaleY))
               {
                  _owner._gearLocked = true;
                  if(_loc3_)
                  {
                     _owner.setSize(tweener.vars.width,tweener.vars.height,_owner.checkGearController(1,_controller));
                  }
                  if(_loc2_)
                  {
                     _owner.setScale(tweener.vars.scaleX,tweener.vars.scaleY);
                  }
                  _owner._gearLocked = false;
                  tweener.kill();
                  tweener = null;
                  if(_displayLockToken != 0)
                  {
                     _owner.releaseDisplayLock(_displayLockToken);
                     _displayLockToken = 0;
                  }
               }
               else
               {
                  return;
               }
            }
            _loc3_ = _loc4_.width != _owner.width || _loc4_.height != _owner.height;
            _loc2_ = _loc4_.scaleX != _owner.scaleX || _loc4_.scaleY != _owner.scaleY;
            if(_loc3_ || _loc2_)
            {
               if(_owner.checkGearController(0,_controller))
               {
                  _displayLockToken = _owner.addDisplayLock();
               }
               _loc1_ = {
                  "width":_loc4_.width,
                  "height":_loc4_.height,
                  "scaleX":_loc4_.scaleX,
                  "scaleY":_loc4_.scaleY,
                  "ease":_easeType,
                  "delay":_delay,
                  "overwrite":0
               };
               _loc1_.onUpdate = __tweenUpdate;
               _loc1_.onUpdateParams = [_loc3_,_loc2_];
               _loc1_.onComplete = __tweenComplete;
               if(_tweenValue == null)
               {
                  _tweenValue = new GearSizeValue#424(0,0,0,0);
               }
               _tweenValue.width = _owner.width;
               _tweenValue.height = _owner.height;
               _tweenValue.scaleX = _owner.scaleX;
               _tweenValue.scaleY = _owner.scaleY;
               tweener = TweenLite.to(_tweenValue,_tweenTime,_loc1_);
            }
         }
         else
         {
            _owner._gearLocked = true;
            _owner.setSize(_loc4_.width,_loc4_.height,_owner.checkGearController(1,_controller));
            _owner.setScale(_loc4_.scaleX,_loc4_.scaleY);
            _owner._gearLocked = false;
         }
      }
      
      private function __tweenUpdate(param1:Boolean, param2:Boolean) : void
      {
         _owner._gearLocked = true;
         if(param1)
         {
            _owner.setSize(_tweenValue.width,_tweenValue.height,_owner.checkGearController(1,_controller));
         }
         if(param2)
         {
            _owner.setScale(_tweenValue.scaleX,_tweenValue.scaleY);
         }
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
         var _loc1_:GearSizeValue = _storage[_controller.selectedPageId];
         if(!_loc1_)
         {
            _loc1_ = new GearSizeValue#424();
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
         GearSizeValue#424(_default).width = GearSizeValue#424(_default).width + param1;
         GearSizeValue#424(_default).height = GearSizeValue#424(_default).height + param2;
         updateState();
      }
   }
}

class GearSizeValue#424
{
    
   
   public var width:Number;
   
   public var height:Number;
   
   public var scaleX:Number;
   
   public var scaleY:Number;
   
   function GearSizeValue#424(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0)
   {
      super();
      this.width = param1;
      this.height = param2;
      this.scaleX = param3;
      this.scaleY = param4;
   }
}
