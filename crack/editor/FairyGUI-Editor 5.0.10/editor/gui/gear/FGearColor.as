package fairygui.editor.gui.gear
{
   import fairygui.ObjectPropID;
   import fairygui.editor.gui.FObject;
   import fairygui.editor.gui.FObjectFactory;
   import fairygui.editor.gui.FObjectFlags;
   import fairygui.editor.gui.FTextField;
   import fairygui.tween.EaseType;
   import fairygui.tween.GTween;
   import fairygui.tween.GTweener;
   import fairygui.utils.UtilsStr;
   
   public class FGearColor extends FGearBase
   {
       
      
      private var _tweener:GTweener;
      
      public function FGearColor(param1:FObject)
      {
         super(param1);
         _gearIndex = 4;
      }
      
      override protected function init() : void
      {
         _default = new GearColorValue#1276(_owner.getProp(ObjectPropID.Color),_owner.getProp(ObjectPropID.OutlineColor));
         _storage = {};
      }
      
      override protected function writeValue(param1:Object) : String
      {
         var _loc2_:GearColorValue = GearColorValue#1276(param1);
         if(_owner is FTextField)
         {
            return UtilsStr.convertToHtmlColor(_loc2_.color) + "," + UtilsStr.convertToHtmlColor(_loc2_.strokeColor);
         }
         return UtilsStr.convertToHtmlColor(_loc2_.color);
      }
      
      override protected function readValue(param1:String) : Object
      {
         var _loc2_:GearColorValue = null;
         var _loc3_:int = 0;
         if(param1 == "-" || param1.length == 0)
         {
            return null;
         }
         _loc2_ = new GearColorValue#1276();
         _loc3_ = param1.indexOf(",");
         if(_loc3_ == -1)
         {
            _loc2_.color = UtilsStr.convertFromHtmlColor(param1);
            _loc2_.strokeColor = 4278190080;
         }
         else
         {
            _loc2_.color = UtilsStr.convertFromHtmlColor(param1.substr(0,_loc3_));
            _loc2_.strokeColor = UtilsStr.convertFromHtmlColor(param1.substr(_loc3_ + 1));
         }
         return _loc2_;
      }
      
      override public function apply() : void
      {
         var _loc1_:uint = 0;
         var _loc3_:uint = 0;
         var _loc2_:GearColorValue = _storage[_controller.selectedPageId];
         if(!_loc2_)
         {
            _loc2_ = _default;
         }
         _loc1_ = _loc2_.color;
         if(_tween && (_owner._flags & FObjectFlags.IN_TEST) != 0 && !FObjectFactory.constructingDepth)
         {
            if(_loc2_.strokeColor != 4278190080)
            {
               _owner._gearLocked = true;
               _owner.setProp(ObjectPropID.OutlineColor,_loc2_.strokeColor);
               _owner._gearLocked = false;
            }
            if(this._tweener != null)
            {
               if(this._tweener.endValue.color != _loc2_.color)
               {
                  this._tweener.kill(true);
                  this._tweener = null;
               }
               else
               {
                  return;
               }
            }
            _loc3_ = _owner.getProp(ObjectPropID.Color);
            if(_loc3_ != _loc2_.color)
            {
               if(_owner.checkGearController(0,_controller))
               {
                  _displayLockToken = _owner.addDisplayLock();
               }
               this._tweener = GTween.toColor(_loc3_,_loc2_.color,_duration).setDelay(_delay).setEase(EaseType.parseEaseType(this.easeName)).setTarget(this).onUpdate(this.__tweenUpdate).onComplete(this.__tweenComplete);
            }
         }
         else
         {
            _owner._gearLocked = true;
            _owner.setProp(ObjectPropID.Color,_loc2_.color);
            if(_loc2_.strokeColor != 4278190080)
            {
               _owner.setProp(ObjectPropID.OutlineColor,_loc2_.strokeColor);
            }
            _owner._gearLocked = false;
         }
      }
      
      private function __tweenUpdate(param1:GTweener) : void
      {
         _owner._gearLocked = true;
         _owner.setProp(ObjectPropID.Color,param1.value.color);
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
         var _loc1_:GearColorValue = _storage[_controller.selectedPageId];
         if(!_loc1_)
         {
            _loc1_ = new GearColorValue#1276();
            _storage[_controller.selectedPageId] = _loc1_;
         }
         _loc1_.color = _owner.getProp(ObjectPropID.Color);
         _loc1_.strokeColor = _owner.getProp(ObjectPropID.OutlineColor);
      }
   }
}

class GearColorValue#1276
{
    
   
   public var color:uint;
   
   public var strokeColor:uint;
   
   function GearColorValue#1276(param1:uint = 0, param2:uint = 0)
   {
      super();
      this.color = param1;
      this.strokeColor = param2;
   }
}
