package fairygui.editor.gui.gear
{
   import com.greensock.TweenLite;
   import fairygui.editor.gui.EGObject;
   import fairygui.editor.gui.EUIObjectFactory;
   import fairygui.editor.utils.UtilsStr;
   
   public class EGearSize extends EGearBase
   {
       
      
      private var _tweenValue:GearSizeValue#770;
      
      private var _tweener:TweenLite;
      
      public function EGearSize(param1:EGObject)
      {
         super(param1);
         gearIndex = 2;
      }
      
      override protected function init() : void
      {
         _default = new GearSizeValue#770(owner.width,owner.height,owner.scaleX,owner.scaleY);
         _storage = {};
      }
      
      override protected function writeValue(param1:Object) : String
      {
         var _loc2_:GearSizeValue = GearSizeValue#770(param1);
         return int(_loc2_.width) + "," + int(_loc2_.height) + "," + UtilsStr.toFixed(_loc2_.scaleX) + "," + UtilsStr.toFixed(_loc2_.scaleY);
      }
      
      override protected function readValue(param1:String) : Object
      {
         if(param1 == "-" || param1.length == 0)
         {
            return null;
         }
         var _loc3_:GearSizeValue = new GearSizeValue#770();
         var _loc2_:Array = param1.split(",");
         _loc3_.width = parseInt(_loc2_[0]);
         _loc3_.height = parseInt(_loc2_[1]);
         if(_loc2_.length > 2)
         {
            _loc3_.scaleX = parseFloat(_loc2_[2]);
            _loc3_.scaleY = parseFloat(_loc2_[3]);
         }
         else
         {
            _loc3_.scaleX = 1;
            _loc3_.scaleY = 1;
         }
         return _loc3_;
      }
      
      override public function apply() : void
      {
         var _loc3_:Boolean = false;
         var _loc1_:Boolean = false;
         var _loc2_:Object = null;
         var _loc4_:GearSizeValue = _storage[_controller.selectedPageId];
         if(!_loc4_)
         {
            _loc4_ = _default;
         }
         if(_tween && owner.editMode == 1 && !EUIObjectFactory.constructingDepth)
         {
            if(this._tweener != null)
            {
               _loc3_ = this._tweener.vars.onUpdateParams[0];
               _loc1_ = this._tweener.vars.onUpdateParams[1];
               if(_loc3_ && (this._tweener.vars.width != _loc4_.width || this._tweener.vars.height != _loc4_.height) || _loc1_ && (this._tweener.vars.scaleX != _loc4_.scaleX || this._tweener.vars.scaleY != _loc4_.scaleY))
               {
                  owner.gearLocked = true;
                  if(_loc3_)
                  {
                     owner.setSize(this._tweener.vars.width,this._tweener.vars.height,owner.checkGearController(1,_controller));
                  }
                  if(_loc1_)
                  {
                     owner.setScale(this._tweener.vars.scaleX,this._tweener.vars.scaleY);
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
            _loc3_ = _loc4_.width != owner.width || _loc4_.height != owner.height;
            _loc1_ = _loc4_.scaleX != owner.scaleX || _loc4_.scaleY != owner.scaleY;
            if(_loc3_ || _loc1_)
            {
               if(owner.checkGearController(0,_controller))
               {
                  _displayLockToken = owner.addDisplayLock();
               }
               _loc2_ = {
                  "width":_loc4_.width,
                  "height":_loc4_.height,
                  "scaleX":_loc4_.scaleX,
                  "scaleY":_loc4_.scaleY,
                  "ease":_ease,
                  "overwrite":0,
                  "delay":_delay
               };
               _loc2_.onUpdate = this.__tweenUpdate;
               _loc2_.onUpdateParams = [_loc3_,_loc1_];
               _loc2_.onComplete = this.__tweenComplete;
               if(this._tweenValue == null)
               {
                  this._tweenValue = new GearSizeValue#770(0,0,0,0);
               }
               this._tweenValue.width = owner.width;
               this._tweenValue.height = owner.height;
               this._tweenValue.scaleX = owner.scaleX;
               this._tweenValue.scaleY = owner.scaleY;
               this._tweener = TweenLite.to(this._tweenValue,_duration,_loc2_);
            }
         }
         else
         {
            owner.gearLocked = true;
            owner.setSize(_loc4_.width,_loc4_.height,owner.checkGearController(1,_controller));
            owner.setScale(_loc4_.scaleX,_loc4_.scaleY);
            owner.gearLocked = false;
         }
      }
      
      private function __tweenUpdate(param1:Boolean, param2:Boolean) : void
      {
         owner.gearLocked = true;
         if(param1)
         {
            owner.setSize(this._tweenValue.width,this._tweenValue.height,owner.checkGearController(1,_controller));
         }
         if(param2)
         {
            owner.setScale(this._tweenValue.scaleX,this._tweenValue.scaleY);
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
         var _loc1_:GearSizeValue = _storage[_controller.selectedPageId];
         if(!_loc1_)
         {
            _loc1_ = new GearSizeValue#770();
            _storage[_controller.selectedPageId] = _loc1_;
         }
         _loc1_.width = owner.width;
         _loc1_.height = owner.height;
         _loc1_.scaleX = owner.scaleX;
         _loc1_.scaleY = owner.scaleY;
      }
      
      override public function updateFromRelations(param1:Number, param2:Number) : void
      {
         var _loc3_:GearSizeValue = null;
         if(_controller == null || _storage == null)
         {
            return;
         }
         var _loc5_:int = 0;
         var _loc4_:* = _storage;
         for each(_loc3_ in _storage)
         {
            _loc3_.width = _loc3_.width + param1;
            _loc3_.height = _loc3_.height + param2;
         }
         GearSizeValue#770(_default).width = GearSizeValue#770(_default).width + param1;
         GearSizeValue#770(_default).height = GearSizeValue#770(_default).height + param2;
         this.updateState();
      }
   }
}

class GearSizeValue#770
{
    
   
   public var width:Number;
   
   public var height:Number;
   
   public var scaleX:Number;
   
   public var scaleY:Number;
   
   function GearSizeValue#770(param1:Number = 0, param2:Number = 0, param3:Number = 1, param4:Number = 1)
   {
      super();
      this.width = param1;
      this.height = param2;
      this.scaleX = param3;
      this.scaleY = param4;
   }
}
