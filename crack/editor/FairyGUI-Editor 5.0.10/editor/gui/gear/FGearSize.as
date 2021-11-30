package fairygui.editor.gui.gear
{
   import fairygui.editor.gui.FObject;
   import fairygui.editor.gui.FObjectFactory;
   import fairygui.editor.gui.FObjectFlags;
   import fairygui.tween.EaseType;
   import fairygui.tween.GTween;
   import fairygui.tween.GTweener;
   import fairygui.utils.UtilsStr;
   
   public class FGearSize extends FGearBase
   {
       
      
      private var _tweener:GTweener;
      
      public function FGearSize(param1:FObject)
      {
         super(param1);
         _gearIndex = 2;
      }
      
      override protected function init() : void
      {
         _default = new GearSizeValue#1273(_owner.width,_owner.height,_owner.scaleX,_owner.scaleY);
         _storage = {};
      }
      
      override protected function writeValue(param1:Object) : String
      {
         var _loc2_:GearSizeValue = GearSizeValue#1273(param1);
         return int(_loc2_.width) + "," + int(_loc2_.height) + "," + UtilsStr.toFixed(_loc2_.scaleX) + "," + UtilsStr.toFixed(_loc2_.scaleY);
      }
      
      override protected function readValue(param1:String) : Object
      {
         if(param1 == "-" || param1.length == 0)
         {
            return null;
         }
         var _loc2_:GearSizeValue = new GearSizeValue#1273();
         var _loc3_:Array = param1.split(",");
         _loc2_.width = parseInt(_loc3_[0]);
         _loc2_.height = parseInt(_loc3_[1]);
         if(_loc3_.length > 2)
         {
            _loc2_.scaleX = parseFloat(_loc3_[2]);
            _loc2_.scaleY = parseFloat(_loc3_[3]);
         }
         else
         {
            _loc2_.scaleX = 1;
            _loc2_.scaleY = 1;
         }
         return _loc2_;
      }
      
      override public function apply() : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc1_:GearSizeValue = _storage[_controller.selectedPageId];
         if(!_loc1_)
         {
            _loc1_ = _default;
         }
         if(_tween && (_owner._flags & FObjectFlags.IN_TEST) != 0 && !FObjectFactory.constructingDepth)
         {
            if(this._tweener != null)
            {
               if(this._tweener.endValue.x != _loc1_.width || this._tweener.endValue.y != _loc1_.height || this._tweener.endValue.z != _loc1_.scaleX || this._tweener.endValue.w != _loc1_.scaleY)
               {
                  this._tweener.kill(true);
                  this._tweener = null;
               }
               else
               {
                  return;
               }
            }
            _loc2_ = _loc1_.width != _owner.width || _loc1_.height != _owner.height;
            _loc3_ = _loc1_.scaleX != _owner.scaleX || _loc1_.scaleY != _owner.scaleY;
            if(_loc2_ || _loc3_)
            {
               if(_owner.checkGearController(0,_controller))
               {
                  _displayLockToken = _owner.addDisplayLock();
               }
               this._tweener = GTween.to4(_owner.width,_owner.height,_owner.scaleX,_owner.scaleY,_loc1_.width,_loc1_.height,_loc1_.scaleX,_loc1_.scaleY,_duration).setDelay(_delay).setEase(EaseType.parseEaseType(this.easeName)).setUserData((!!_loc2_?1:0) + (!!_loc3_?2:0)).setTarget(this).onUpdate(this.__tweenUpdate).onComplete(this.__tweenComplete);
            }
         }
         else
         {
            _owner._gearLocked = true;
            _owner.setSize(_loc1_.width,_loc1_.height,_owner.checkGearController(1,_controller));
            _owner.setScale(_loc1_.scaleX,_loc1_.scaleY);
            _owner._gearLocked = false;
         }
      }
      
      private function __tweenUpdate(param1:GTweener) : void
      {
         var _loc2_:int = int(param1.userData);
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
         if(_displayLockToken != 0)
         {
            _owner.releaseDisplayLock(_displayLockToken);
            _displayLockToken = 0;
         }
         this._tweener = null;
      }
      
      override public function updateState() : void
      {
         var _loc1_:GearSizeValue = _storage[_controller.selectedPageId];
         if(!_loc1_)
         {
            _loc1_ = new GearSizeValue#1273();
            _storage[_controller.selectedPageId] = _loc1_;
         }
         _loc1_.width = _owner.width;
         _loc1_.height = _owner.height;
         _loc1_.scaleX = _owner.scaleX;
         _loc1_.scaleY = _owner.scaleY;
      }
      
      override public function updateFromRelations(param1:Number, param2:Number) : void
      {
         var _loc3_:GearSizeValue = null;
         if(_controller == null || _storage == null)
         {
            return;
         }
         for each(_loc3_ in _storage)
         {
            _loc3_.width = _loc3_.width + param1;
            _loc3_.height = _loc3_.height + param2;
         }
         GearSizeValue#1273(_default).width = GearSizeValue#1273(_default).width + param1;
         GearSizeValue#1273(_default).height = GearSizeValue#1273(_default).height + param2;
         this.updateState();
      }
   }
}

class GearSizeValue#1273
{
    
   
   public var width:Number;
   
   public var height:Number;
   
   public var scaleX:Number;
   
   public var scaleY:Number;
   
   function GearSizeValue#1273(param1:Number = 0, param2:Number = 0, param3:Number = 1, param4:Number = 1)
   {
      super();
      this.width = param1;
      this.height = param2;
      this.scaleX = param3;
      this.scaleY = param4;
   }
}
