package fairygui.gears
{
   import fairygui.GObject;
   import fairygui.UIPackage;
   import fairygui.tween.GTween;
   import fairygui.tween.GTweener;
   
   public class GearLook extends GearBase
   {
       
      
      private var _storage:Object;
      
      private var _default:GearLookValue#859;
      
      public function GearLook(param1:GObject)
      {
         super(param1);
      }
      
      override protected function init() : void
      {
         _default = new GearLookValue#859(_owner.alpha,_owner.rotation,_owner.grayed,_owner.touchable);
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
            _loc4_ = new GearLookValue#859();
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
         var _loc1_:* = false;
         var _loc2_:* = false;
         var _loc3_:GearLookValue = _storage[_controller.selectedPageId];
         if(!_loc3_)
         {
            _loc3_ = _default;
         }
         if(_tweenConfig != null && _tweenConfig.tween && !UIPackage._constructing && !disableAllTweenEffect)
         {
            _owner._gearLocked = true;
            _owner.grayed = _loc3_.grayed;
            _owner.touchable = _loc3_.touchable;
            _owner._gearLocked = false;
            if(_tweenConfig._tweener != null)
            {
               if(_tweenConfig._tweener.endValue.x != _loc3_.alpha || _tweenConfig._tweener.endValue.y != _loc3_.rotation)
               {
                  _tweenConfig._tweener.kill(true);
                  _tweenConfig._tweener = null;
               }
               else
               {
                  return;
               }
            }
            _loc1_ = _loc3_.alpha != _owner.alpha;
            _loc2_ = _loc3_.rotation != _owner.rotation;
            if(_loc1_ || _loc2_)
            {
               if(_owner.checkGearController(0,_controller))
               {
                  _tweenConfig._displayLockToken = _owner.addDisplayLock();
               }
               _tweenConfig._tweener = GTween.to2(_owner.alpha,_owner.rotation,_loc3_.alpha,_loc3_.rotation,_tweenConfig.duration).setDelay(_tweenConfig.delay).setEase(_tweenConfig.easeType).setUserData((!!_loc1_?1:0) + (!!_loc2_?2:0)).setTarget(this).onUpdate(__tweenUpdate).onComplete(__tweenComplete);
            }
         }
         else
         {
            _owner._gearLocked = true;
            _owner.alpha = _loc3_.alpha;
            _owner.rotation = _loc3_.rotation;
            _owner.grayed = _loc3_.grayed;
            _owner.touchable = _loc3_.touchable;
            _owner._gearLocked = false;
         }
      }
      
      private function __tweenUpdate(param1:GTweener) : void
      {
         var _loc2_:int = param1.userData;
         _owner._gearLocked = true;
         if((_loc2_ & 1) != 0)
         {
            _owner.alpha = param1.value.x;
         }
         if((_loc2_ & 2) != 0)
         {
            _owner.rotation = param1.value.y;
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
         var _loc1_:GearLookValue = _storage[_controller.selectedPageId];
         if(!_loc1_)
         {
            _loc1_ = new GearLookValue#859();
            _storage[_controller.selectedPageId] = _loc1_;
         }
         _loc1_.alpha = _owner.alpha;
         _loc1_.rotation = _owner.rotation;
         _loc1_.grayed = _owner.grayed;
         _loc1_.touchable = _owner.touchable;
      }
   }
}

class GearLookValue#859
{
    
   
   public var alpha:Number;
   
   public var rotation:Number;
   
   public var grayed:Boolean;
   
   public var touchable:Boolean;
   
   function GearLookValue#859(param1:Number = 0, param2:Number = 0, param3:Boolean = false, param4:Boolean = true)
   {
      super();
      this.alpha = param1;
      this.rotation = param2;
      this.grayed = param3;
      this.touchable = param4;
   }
}
