package fairygui.editor.gui.gear
{
   import com.greensock.TweenLite;
   import fairygui.editor.gui.EGObject;
   import fairygui.editor.gui.EITextColorGear;
   import fairygui.editor.gui.EUIObjectFactory;
   import fairygui.editor.utils.UtilsStr;
   
   public class EGearColor extends EGearBase
   {
       
      
      private var _tweener:TweenLite;
      
      private var _tweenValue:Object;
      
      public function EGearColor(param1:EGObject)
      {
         super(param1);
         gearIndex = 4;
      }
      
      override protected function init() : void
      {
         if(owner is EITextColorGear)
         {
            _default = new GearColorValue#761(EIColorGear(owner).color,EITextColorGear(owner).strokeColor);
         }
         else
         {
            _default = new GearColorValue#761(EIColorGear(owner).color);
         }
         _storage = {};
      }
      
      override protected function writeValue(param1:Object) : String
      {
         var _loc2_:GearColorValue = GearColorValue#761(param1);
         if(owner is EITextColorGear)
         {
            return UtilsStr.convertToHtmlColor(_loc2_.color) + "," + UtilsStr.convertToHtmlColor(_loc2_.strokeColor);
         }
         return UtilsStr.convertToHtmlColor(_loc2_.color);
      }
      
      override protected function readValue(param1:String) : Object
      {
         var _loc3_:GearColorValue = null;
         var _loc2_:int = 0;
         if(param1 == "-" || param1.length == 0)
         {
            return null;
         }
         _loc3_ = new GearColorValue#761();
         _loc2_ = param1.indexOf(",");
         if(_loc2_ == -1)
         {
            _loc3_.color = UtilsStr.convertFromHtmlColor(param1);
            _loc3_.strokeColor = 4278190080;
         }
         else
         {
            _loc3_.color = UtilsStr.convertFromHtmlColor(param1.substr(0,_loc2_));
            _loc3_.strokeColor = UtilsStr.convertFromHtmlColor(param1.substr(_loc2_ + 1));
         }
         return _loc3_;
      }
      
      override public function apply() : void
      {
         var _loc3_:uint = 0;
         var _loc1_:Object = null;
         var _loc2_:GearColorValue = _storage[_controller.selectedPageId];
         if(!_loc2_)
         {
            _loc2_ = _default;
         }
         _loc3_ = _loc2_.color;
         if(_tween && owner.editMode == 1 && !EUIObjectFactory.constructingDepth)
         {
            if(owner is EITextColorGear && _loc2_.strokeColor != 4278190080)
            {
               owner.gearLocked = true;
               EITextColorGear(owner).strokeColor = _loc2_.strokeColor;
               owner.gearLocked = false;
            }
            if(this._tweener != null)
            {
               if(this._tweener.vars.color != _loc3_)
               {
                  owner.gearLocked = true;
                  EIColorGear(owner).color = this._tweener.vars.color;
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
            if(EIColorGear(owner).color != _loc3_)
            {
               if(owner.checkGearController(0,_controller))
               {
                  _displayLockToken = owner.addDisplayLock();
               }
               _loc1_ = {
                  "hexColors":{"color":_loc3_},
                  "ease":_ease,
                  "overwrite":0,
                  "delay":_delay
               };
               _loc1_.onUpdate = this.__tweenUpdate;
               _loc1_.onComplete = this.__tweenComplete;
               if(this._tweenValue == null)
               {
                  this._tweenValue = {};
               }
               this._tweenValue.color = EIColorGear(owner).color;
               this._tweener = TweenLite.to(this._tweenValue,_duration,_loc1_);
            }
         }
         else
         {
            owner.gearLocked = true;
            EIColorGear(owner).color = _loc3_;
            if(owner is EITextColorGear && _loc2_.strokeColor != 4278190080)
            {
               EITextColorGear(owner).strokeColor = _loc2_.strokeColor;
            }
            owner.gearLocked = false;
         }
      }
      
      private function __tweenUpdate() : void
      {
         owner.gearLocked = true;
         EIColorGear(owner).color = this._tweenValue.color;
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
         var _loc1_:GearColorValue = _storage[_controller.selectedPageId];
         if(!_loc1_)
         {
            _loc1_ = new GearColorValue#761();
            _storage[_controller.selectedPageId] = _loc1_;
         }
         _loc1_.color = EIColorGear(owner).color;
         if(owner is EITextColorGear)
         {
            _loc1_.strokeColor = EITextColorGear(owner).strokeColor;
         }
      }
   }
}

class GearColorValue#761
{
    
   
   public var color:uint;
   
   public var strokeColor:uint;
   
   function GearColorValue#761(param1:uint = 0, param2:uint = 0)
   {
      super();
      this.color = param1;
      this.strokeColor = param2;
   }
}
