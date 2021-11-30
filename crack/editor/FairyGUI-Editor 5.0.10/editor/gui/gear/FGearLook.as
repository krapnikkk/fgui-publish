package fairygui.editor.gui.gear
{
   import fairygui.editor.gui.FObject;
   import fairygui.editor.gui.FObjectFactory;
   import fairygui.editor.gui.FObjectFlags;
   import fairygui.tween.EaseType;
   import fairygui.tween.GTween;
   import fairygui.tween.GTweener;
   import fairygui.utils.UtilsStr;
   
   public class FGearLook extends FGearBase
   {
       
      
      private var _tweener:GTweener;
      
      public function FGearLook(param1:FObject)
      {
         super(param1);
         _gearIndex = 3;
      }
      
      override protected function init() : void
      {
         _default = new GearLookValue#1294(_owner.alpha,_owner.rotation,_owner.grayed,_owner.touchable);
         _storage = {};
      }
      
      override protected function writeValue(param1:Object) : String
      {
         var _loc2_:GearLookValue = GearLookValue#1294(param1);
         return UtilsStr.toFixed(_loc2_.alpha) + "," + UtilsStr.toFixed(_loc2_.rotation) + "," + (!!_loc2_.grayed?"1":"0") + "," + (!!_loc2_.touchable?"1":"0");
      }
      
      override protected function readValue(param1:String) : Object
      {
         if(param1 == "-" || param1.length == 0)
         {
            return null;
         }
         var _loc2_:GearLookValue = new GearLookValue#1294();
         var _loc3_:Array = param1.split(",");
         _loc2_.alpha = parseFloat(_loc3_[0]);
         _loc2_.rotation = parseFloat(_loc3_[1]);
         _loc2_.grayed = _loc3_[2] == "1"?true:false;
         if(_loc3_.length < 4)
         {
            _loc2_.touchable = _owner.touchable;
         }
         else
         {
            _loc2_.touchable = _loc3_[3] == "1"?true:false;
         }
         return _loc2_;
      }
      
      override public function apply() : void
      {
         var _loc2_:* = false;
         var _loc3_:* = false;
         var _loc1_:GearLookValue = _storage[_controller.selectedPageId];
         if(!_loc1_)
         {
            _loc1_ = _default;
         }
         if(_tween && (_owner._flags & FObjectFlags.IN_TEST) != 0 && !FObjectFactory.constructingDepth)
         {
            _owner._gearLocked = true;
            _owner.grayed = _loc1_.grayed;
            _owner.touchable = _loc1_.touchable;
            _owner._gearLocked = false;
            if(this._tweener != null)
            {
               if(this._tweener.endValue.x != _loc1_.alpha || this._tweener.endValue.y != _loc1_.rotation)
               {
                  this._tweener.kill(true);
                  this._tweener = null;
               }
               else
               {
                  return;
               }
            }
            _loc2_ = _loc1_.alpha != _owner.alpha;
            _loc3_ = _loc1_.rotation != _owner.rotation;
            if(_loc2_ || _loc3_)
            {
               if(_owner.checkGearController(0,_controller))
               {
                  _displayLockToken = _owner.addDisplayLock();
               }
               this._tweener = GTween.to2(_owner.alpha,_owner.rotation,_loc1_.alpha,_loc1_.rotation,_duration).setDelay(_delay).setEase(EaseType.parseEaseType(this.easeName)).setUserData((!!_loc2_?1:0) + (!!_loc3_?2:0)).setTarget(this).onUpdate(this.__tweenUpdate).onComplete(this.__tweenComplete);
            }
         }
         else
         {
            _owner._gearLocked = true;
            _owner.alpha = _loc1_.alpha;
            _owner.rotation = _loc1_.rotation;
            _owner.grayed = _loc1_.grayed;
            _owner.touchable = _loc1_.touchable;
            _owner._gearLocked = false;
         }
      }
      
      private function __tweenUpdate(param1:GTweener) : void
      {
         var _loc2_:int = int(param1.userData);
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
         if(_displayLockToken != 0)
         {
            _owner.releaseDisplayLock(_displayLockToken);
            _displayLockToken = 0;
         }
         this._tweener = null;
      }
      
      override public function updateState() : void
      {
         var _loc1_:GearLookValue = _storage[_controller.selectedPageId];
         if(!_loc1_)
         {
            _loc1_ = new GearLookValue#1294();
            _storage[_controller.selectedPageId] = _loc1_;
         }
         _loc1_.alpha = _owner.alpha;
         _loc1_.rotation = _owner.rotation;
         _loc1_.grayed = _owner.grayed;
         _loc1_.touchable = _owner.touchable;
      }
   }
}

class GearLookValue#1294
{
    
   
   public var alpha:Number;
   
   public var rotation:Number;
   
   public var grayed:Boolean;
   
   public var touchable:Boolean;
   
   function GearLookValue#1294(param1:Number = 0, param2:Number = 0, param3:Boolean = false, param4:Boolean = true)
   {
      super();
      this.alpha = param1;
      this.rotation = param2;
      this.grayed = param3;
      this.touchable = param4;
   }
}
