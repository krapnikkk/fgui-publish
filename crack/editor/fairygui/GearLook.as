package fairygui
{
   import com.greensock.TweenLite;
   import flash.geom.Point;
   
   public class GearLook extends GearBase
   {
       
      
      public var tweener:TweenLite;
      
      private var _storage:Object;
      
      private var _default:GearLookValue#294;
      
      private var _tweenValue:Point;
      
      public function GearLook(param1:GObject)
      {
         super(param1);
      }
      
      override protected function init() : void
      {
         _default = new GearLookValue#294(_owner.alpha,_owner.rotation,_owner.grayed,_owner.touchable);
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
            _loc4_ = new GearLookValue#294();
            _storage[param1] = _loc4_;
         }
         _loc4_.alpha = parseFloat(_loc3_[0]);
         _loc4_.rotation = parseInt(_loc3_[1]);
         _loc4_.grayed = _loc3_[2] == "1"?true:false;
         if(_loc3_.length < 4)
         {
            _loc4_.touchable = _owner.touchable;
         }
         else
         {
            _loc4_.touchable = _loc3_[3] == "1"?true:false;
         }
      }
      
      override public function apply() : void
      {
         var _loc3_:* = false;
         var _loc2_:* = false;
         var _loc1_:* = null;
         var _loc4_:GearLookValue = _storage[_controller.selectedPageId];
         if(!_loc4_)
         {
            _loc4_ = _default;
         }
         if(_tween && !UIPackage._constructing && !disableAllTweenEffect)
         {
            _owner._gearLocked = true;
            _owner.grayed = _loc4_.grayed;
            _owner.touchable = _loc4_.touchable;
            _owner._gearLocked = false;
            if(tweener != null)
            {
               _loc3_ = Boolean(tweener.vars.onUpdateParams[0]);
               _loc2_ = Boolean(tweener.vars.onUpdateParams[1]);
               if(_loc3_ && tweener.vars.x != _loc4_.alpha || _loc2_ && tweener.vars.y != _loc4_.rotation)
               {
                  _owner._gearLocked = true;
                  if(_loc3_)
                  {
                     _owner.alpha = tweener.vars.x;
                  }
                  if(_loc2_)
                  {
                     _owner.rotation = tweener.vars.y;
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
            _loc3_ = _loc4_.alpha != _owner.alpha;
            _loc2_ = _loc4_.rotation != _owner.rotation;
            if(_loc3_ || _loc2_)
            {
               if(_owner.checkGearController(0,_controller))
               {
                  _displayLockToken = _owner.addDisplayLock();
               }
               _loc1_ = {
                  "ease":_easeType,
                  "x":_loc4_.alpha,
                  "y":_loc4_.rotation,
                  "delay":_delay,
                  "overwrite":0
               };
               _loc1_.onUpdate = __tweenUpdate;
               _loc1_.onUpdateParams = [_loc3_,_loc2_];
               _loc1_.onComplete = __tweenComplete;
               if(_tweenValue == null)
               {
                  _tweenValue = new Point();
               }
               _tweenValue.x = _owner.alpha;
               _tweenValue.y = _owner.rotation;
               tweener = TweenLite.to(_tweenValue,_tweenTime,_loc1_);
            }
         }
         else
         {
            _owner._gearLocked = true;
            _owner.alpha = _loc4_.alpha;
            _owner.rotation = _loc4_.rotation;
            _owner.grayed = _loc4_.grayed;
            _owner.touchable = _loc4_.touchable;
            _owner._gearLocked = false;
         }
      }
      
      private function __tweenUpdate(param1:Boolean, param2:Boolean) : void
      {
         _owner._gearLocked = true;
         if(param1)
         {
            _owner.alpha = _tweenValue.x;
         }
         if(param2)
         {
            _owner.rotation = _tweenValue.y;
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
         var _loc1_:GearLookValue = _storage[_controller.selectedPageId];
         if(!_loc1_)
         {
            _loc1_ = new GearLookValue#294();
            _storage[_controller.selectedPageId] = _loc1_;
         }
         _loc1_.alpha = _owner.alpha;
         _loc1_.rotation = _owner.rotation;
         _loc1_.grayed = _owner.grayed;
         _loc1_.touchable = _owner.touchable;
      }
   }
}

class GearLookValue#294
{
    
   
   public var alpha:Number;
   
   public var rotation:Number;
   
   public var grayed:Boolean;
   
   public var touchable:Boolean;
   
   function GearLookValue#294(param1:Number = 0, param2:Number = 0, param3:Boolean = false, param4:Boolean = true)
   {
      super();
      this.alpha = param1;
      this.rotation = param2;
      this.grayed = param3;
      this.touchable = param4;
   }
}
