package fairygui.gears
{
   import fairygui.Controller;
   import fairygui.GObject;
   import fairygui.tween.EaseType;
   
   public class GearBase
   {
      
      public static var disableAllTweenEffect:Boolean = false;
      
      private static var Classes:Array = null;
      
      private static const NameToIndex:Object = {
         "gearDisplay":0,
         "gearXY":1,
         "gearSize":2,
         "gearLook":3,
         "gearColor":4,
         "gearAni":5,
         "gearText":6,
         "gearIcon":7,
         "gearDisplay2":8,
         "gearFontSize":9
      };
       
      
      protected var _owner:GObject;
      
      protected var _controller:Controller;
      
      protected var _tweenConfig:GearTweenConfig;
      
      public function GearBase(param1:GObject)
      {
         super();
         _owner = param1;
      }
      
      public static function create(param1:GObject, param2:int) : GearBase
      {
         if(!Classes)
         {
            Classes = [GearDisplay,GearXY,GearSize,GearLook,GearColor,GearAnimation,GearText,GearIcon,GearDisplay2,GearFontSize];
         }
         return new Classes[param2](param1);
      }
      
      public static function getIndexByName(param1:String) : int
      {
         var _loc2_:* = NameToIndex[param1];
         if(_loc2_ == undefined)
         {
            return -1;
         }
         return int(_loc2_);
      }
      
      public function dispose() : void
      {
         if(_tweenConfig != null && _tweenConfig._tweener != null)
         {
            _tweenConfig._tweener.kill();
            _tweenConfig._tweener = null;
         }
      }
      
      public final function get controller() : Controller
      {
         return _controller;
      }
      
      public function set controller(param1:Controller) : void
      {
         if(param1 != _controller)
         {
            _controller = param1;
            if(_controller)
            {
               init();
            }
         }
      }
      
      public function get tweenConfig() : GearTweenConfig
      {
         if(_tweenConfig == null)
         {
            _tweenConfig = new GearTweenConfig();
         }
         return _tweenConfig;
      }
      
      public function setup(param1:XML) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         _controller = _owner.parent.getController(param1.@controller);
         if(!_controller)
         {
            return;
         }
         init();
         _loc2_ = param1.@tween;
         if(_loc2_)
         {
            _tweenConfig = new GearTweenConfig();
            _loc2_ = param1.@ease;
            if(_loc2_)
            {
               _tweenConfig.easeType = EaseType.parseEaseType(_loc2_);
            }
            _loc2_ = param1.@duration;
            if(_loc2_)
            {
               _tweenConfig.duration = parseFloat(_loc2_);
            }
            _loc2_ = param1.@delay;
            if(_loc2_)
            {
               _tweenConfig.delay = parseFloat(_loc2_);
            }
         }
         _loc2_ = param1.@pages;
         if(_loc2_)
         {
            _loc3_ = _loc2_.split(",");
         }
         if(this is GearDisplay)
         {
            GearDisplay(this).pages = _loc3_;
         }
         else if(this is GearDisplay2)
         {
            GearDisplay2(this).pages = _loc3_;
            GearDisplay2(this).condition = param1.@condition;
         }
         else
         {
            if(_loc3_)
            {
               _loc2_ = param1.@values;
               _loc4_ = _loc2_.split("|");
               _loc5_ = 0;
               while(_loc5_ < _loc3_.length)
               {
                  _loc2_ = _loc4_[_loc5_];
                  if(_loc2_ == null)
                  {
                     _loc2_ = "";
                  }
                  addStatus(_loc3_[_loc5_],_loc2_);
                  _loc5_++;
               }
            }
            _loc2_ = param1["default"];
            if(_loc2_)
            {
               addStatus(null,_loc2_);
            }
         }
      }
      
      public function updateFromRelations(param1:Number, param2:Number) : void
      {
      }
      
      protected function addStatus(param1:String, param2:String) : void
      {
      }
      
      protected function init() : void
      {
      }
      
      public function apply() : void
      {
      }
      
      public function updateState() : void
      {
      }
   }
}
