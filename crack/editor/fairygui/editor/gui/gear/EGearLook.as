package fairygui.editor.gui.gear
{
   import com.greensock.TweenLite;
   import fairygui.editor.gui.EGObject;
   import fairygui.editor.gui.EUIObjectFactory;
   import fairygui.editor.utils.UtilsStr;
   import flash.geom.Point;
   
   public class EGearLook extends EGearBase
   {
       
      
      private var _tweenValue:Point;
      
      private var _tweener:TweenLite;
      
      public function EGearLook(param1:EGObject)
      {
         super(param1);
         gearIndex = 3;
      }
      
      override protected function init() : void
      {
         _default = new GearLookValue#523(owner.alpha,owner.rotation,owner.grayed,owner.touchable);
         _storage = {};
      }
      
      override protected function writeValue(param1:Object) : String
      {
         var _loc2_:GearLookValue = GearLookValue#523(param1);
         return UtilsStr.toFixed(_loc2_.alpha) + "," + _loc2_.rotation + "," + (!!_loc2_.grayed?"1":"0") + "," + (!!_loc2_.touchable?"1":"0");
      }
      
      override protected function readValue(param1:String) : Object
      {
         if(param1 == "-" || param1.length == 0)
         {
            return null;
         }
         var _loc3_:GearLookValue = new GearLookValue#523();
         var _loc2_:Array = param1.split(",");
         _loc3_.alpha = parseFloat(_loc2_[0]);
         _loc3_.rotation = parseInt(_loc2_[1]);
         _loc3_.grayed = _loc2_[2] == "1"?true:false;
         if(_loc2_.length < 4)
         {
            _loc3_.touchable = owner.touchable;
         }
         else
         {
            _loc3_.touchable = _loc2_[3] == "1"?true:false;
         }
         return _loc3_;
      }
      
      override public function apply() : void
      {
         var _loc3_:* = false;
         var _loc1_:* = false;
         var _loc2_:Object = null;
         var _loc4_:GearLookValue = _storage[_controller.selectedPageId];
         if(!_loc4_)
         {
            _loc4_ = _default;
         }
         if(_tween && owner.editMode == 1 && !EUIObjectFactory.constructingDepth)
         {
            owner.gearLocked = true;
            owner.grayed = _loc4_.grayed;
            owner.touchable = _loc4_.touchable;
            owner.gearLocked = false;
            if(this._tweener != null)
            {
               _loc3_ = Boolean(this._tweener.vars.onUpdateParams[0]);
               _loc1_ = Boolean(this._tweener.vars.onUpdateParams[1]);
               if(_loc3_ && this._tweener.vars.x != _loc4_.alpha || _loc1_ && this._tweener.vars.y != _loc4_.rotation)
               {
                  owner.gearLocked = true;
                  if(_loc3_)
                  {
                     owner.alpha = this._tweener.vars.x;
                  }
                  if(_loc1_)
                  {
                     owner.rotation = this._tweener.vars.y;
                  }
                  owner.gearLocked = false;
                  this._tweener.kill();
                  this._tweener = null;
                  if(_displayLockToken != 0)
                  {
                     owner.releaseDisplayLock(_displayLockToken);
                     _displayLockToken = 0;
                  }
               }
               else
               {
                  return;
               }
            }
            _loc3_ = _loc4_.alpha != owner.alpha;
            _loc1_ = _loc4_.rotation != owner.rotation;
            if(_loc3_ || _loc1_)
            {
               if(owner.checkGearController(0,_controller))
               {
                  _displayLockToken = owner.addDisplayLock();
               }
               _loc2_ = {
                  "ease":_ease,
                  "x":_loc4_.alpha,
                  "y":_loc4_.rotation,
                  "overwrite":0,
                  "delay":_delay
               };
               _loc2_.onUpdate = this.__tweenUpdate;
               _loc2_.onUpdateParams = [_loc3_,_loc1_];
               _loc2_.onComplete = this.__tweenComplete;
               if(this._tweenValue == null)
               {
                  this._tweenValue = new Point();
               }
               this._tweenValue.x = owner.alpha;
               this._tweenValue.y = owner.rotation;
               this._tweener = TweenLite.to(this._tweenValue,_duration,_loc2_);
            }
         }
         else
         {
            owner.gearLocked = true;
            owner.alpha = _loc4_.alpha;
            owner.rotation = _loc4_.rotation;
            owner.grayed = _loc4_.grayed;
            owner.touchable = _loc4_.touchable;
            owner.gearLocked = false;
         }
      }
      
      private function __tweenUpdate(param1:Boolean, param2:Boolean) : void
      {
         owner.gearLocked = true;
         if(param1)
         {
            owner.alpha = this._tweenValue.x;
         }
         if(param2)
         {
            owner.rotation = this._tweenValue.y;
         }
         owner.gearLocked = false;
      }
      
      private function __tweenComplete() : void
      {
         if(_displayLockToken != 0)
         {
            owner.releaseDisplayLock(_displayLockToken);
            _displayLockToken = 0;
         }
         this._tweener = null;
      }
      
      override public function updateState() : void
      {
         var _loc1_:GearLookValue = _storage[_controller.selectedPageId];
         if(!_loc1_)
         {
            _loc1_ = new GearLookValue#523();
            _storage[_controller.selectedPageId] = _loc1_;
         }
         _loc1_.alpha = owner.alpha;
         _loc1_.rotation = owner.rotation;
         _loc1_.grayed = owner.grayed;
         _loc1_.touchable = owner.touchable;
      }
   }
}

class GearLookValue#523
{
    
   
   public var alpha:Number;
   
   public var rotation:Number;
   
   public var grayed:Boolean;
   
   public var touchable:Boolean;
   
   function GearLookValue#523(param1:Number = 0, param2:Number = 0, param3:Boolean = false, param4:Boolean = true)
   {
      super();
      this.alpha = param1;
      this.rotation = param2;
      this.grayed = param3;
      this.touchable = param4;
   }
}
