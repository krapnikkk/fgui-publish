package fairygui
{
   import com.greensock.easing.Ease;
   import com.greensock.easing.EaseLookup;
   import com.greensock.easing.Quad;
   
   public class GearBase
   {
      
      public static var disableAllTweenEffect:Boolean = false;
       
      
      protected var _tween:Boolean;
      
      protected var _easeType:Ease;
      
      protected var _tweenTime:Number;
      
      protected var _delay:Number;
      
      protected var _displayLockToken:uint;
      
      protected var _owner:GObject;
      
      protected var _controller:Controller;
      
      public function GearBase(param1:GObject)
      {
         super();
         _owner = param1;
         _easeType = Quad.easeOut;
         _tweenTime = 0.3;
         _delay = 0;
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
      
      public final function get tween() : Boolean
      {
         return _tween;
      }
      
      public function set tween(param1:Boolean) : void
      {
         _tween = param1;
      }
      
      public final function get tweenTime() : Number
      {
         return _tweenTime;
      }
      
      public function set tweenTime(param1:Number) : void
      {
         _tweenTime = param1;
      }
      
      public final function get delay() : Number
      {
         return _delay;
      }
      
      public function set delay(param1:Number) : void
      {
         _delay = param1;
      }
      
      public final function get easeType() : Ease
      {
         return _easeType;
      }
      
      public function set easeType(param1:Ease) : void
      {
         _easeType = param1;
      }
      
      public function setup(param1:XML) : void
      {
         var _loc3_:* = null;
         var _loc7_:int = 0;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc2_:* = null;
         var _loc6_:int = 0;
         _controller = _owner.parent.getController(param1.@controller);
         if(!_controller)
         {
            return;
         }
         init();
         _loc3_ = param1.@tween;
         if(_loc3_)
         {
            _tween = true;
         }
         _loc3_ = param1.@ease;
         if(_loc3_)
         {
            _loc7_ = _loc3_.indexOf(".");
            if(_loc7_ != -1)
            {
               _loc3_ = _loc3_.substr(0,_loc7_) + ".ease" + _loc3_.substr(_loc7_ + 1);
            }
            if(_loc3_ == "Linear")
            {
               _easeType = EaseLookup.find("linear.easenone");
            }
            else
            {
               _easeType = EaseLookup.find(_loc3_);
            }
         }
         _loc3_ = param1.@duration;
         if(_loc3_)
         {
            _tweenTime = parseFloat(_loc3_);
         }
         _loc3_ = param1.@delay;
         if(_loc3_)
         {
            _delay = parseFloat(_loc3_);
         }
         if(this is GearDisplay)
         {
            _loc3_ = param1.@pages;
            if(_loc3_)
            {
               _loc4_ = _loc3_.split(",");
               GearDisplay(this).pages = _loc4_;
            }
         }
         else
         {
            _loc3_ = param1.@pages;
            if(_loc3_)
            {
               _loc5_ = _loc3_.split(",");
            }
            if(_loc5_)
            {
               _loc3_ = param1.@values;
               _loc2_ = _loc3_.split("|");
               _loc6_ = 0;
               while(_loc6_ < _loc5_.length)
               {
                  _loc3_ = _loc2_[_loc6_];
                  if(_loc3_ == null)
                  {
                     _loc3_ = "";
                  }
                  addStatus(_loc5_[_loc6_],_loc3_);
                  _loc6_++;
               }
            }
            _loc3_ = param1["default"];
            if(_loc3_)
            {
               addStatus(null,_loc3_);
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
