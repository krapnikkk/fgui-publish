package fairygui.gears
{
   import fairygui.GObject;
   import fairygui.UIPackage;
   import fairygui.tween.GTween;
   import fairygui.tween.GTweener;
   import fairygui.utils.ToolSet;
   
   public class GearColor extends GearBase
   {
       
      
      private var _storage:Object;
      
      private var _default:GearColorValue#1005;
      
      public function GearColor(param1:GObject)
      {
         super(param1);
      }
      
      override protected function init() : void
      {
         _default = new GearColorValue#1005(_owner.getProp(2),_owner.getProp(3));
         _storage = {};
      }
      
      override protected function addStatus(param1:String, param2:String) : void
      {
         var _loc5_:* = 0;
         var _loc4_:* = 0;
         if(param2 == "-" || param2.length == 0)
         {
            return;
         }
         var _loc3_:int = param2.indexOf(",");
         if(_loc3_ == -1)
         {
            _loc5_ = uint(ToolSet.convertFromHtmlColor(param2));
            _loc4_ = uint(4278190080);
         }
         else
         {
            _loc5_ = uint(ToolSet.convertFromHtmlColor(param2.substr(0,_loc3_)));
            _loc4_ = uint(ToolSet.convertFromHtmlColor(param2.substr(_loc3_ + 1)));
         }
         if(param1 == null)
         {
            _default.color = _loc5_;
            _default.strokeColor = _loc4_;
         }
         else
         {
            _storage[param1] = new GearColorValue#1005(_loc5_,_loc4_);
         }
      }
      
      override public function apply() : void
      {
         var _loc1_:* = 0;
         var _loc2_:GearColorValue = _storage[_controller.selectedPageId];
         if(!_loc2_)
         {
            _loc2_ = _default;
         }
         if(_tweenConfig != null && _tweenConfig.tween && !UIPackage._constructing && !disableAllTweenEffect)
         {
            if(_loc2_.strokeColor != 4278190080)
            {
               _owner._gearLocked = true;
               _owner.setProp(3,_loc2_.strokeColor);
               _owner._gearLocked = false;
            }
            if(_tweenConfig._tweener != null)
            {
               if(_tweenConfig._tweener.endValue.color != _loc2_.color)
               {
                  _tweenConfig._tweener.kill(true);
                  _tweenConfig._tweener = null;
               }
               else
               {
                  return;
               }
            }
            _loc1_ = uint(_owner.getProp(2));
            if(_loc1_ != _loc2_.color)
            {
               if(_owner.checkGearController(0,_controller))
               {
                  _tweenConfig._displayLockToken = _owner.addDisplayLock();
               }
               _tweenConfig._tweener = GTween.toColor(_loc1_,_loc2_.color,_tweenConfig.duration).setDelay(_tweenConfig.delay).setEase(_tweenConfig.easeType).setTarget(this).onUpdate(__tweenUpdate).onComplete(__tweenComplete);
            }
         }
         else
         {
            _owner._gearLocked = true;
            _owner.setProp(2,_loc2_.color);
            if(_loc2_.strokeColor != 4278190080)
            {
               _owner.setProp(3,_loc2_.strokeColor);
            }
            _owner._gearLocked = false;
         }
      }
      
      private function __tweenUpdate(param1:GTweener) : void
      {
         _owner._gearLocked = true;
         _owner.setProp(2,param1.value.color);
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
         var _loc1_:GearColorValue = _storage[_controller.selectedPageId];
         if(!_loc1_)
         {
            _loc1_ = new GearColorValue#1005();
            _storage[_controller.selectedPageId] = _loc1_;
         }
         _loc1_.color = _owner.getProp(2);
         _loc1_.strokeColor = _owner.getProp(3);
      }
   }
}

class GearColorValue#1005
{
    
   
   public var color:uint;
   
   public var strokeColor:uint;
   
   function GearColorValue#1005(param1:uint = 0, param2:uint = 0)
   {
      super();
      this.color = param1;
      this.strokeColor = param2;
   }
}
