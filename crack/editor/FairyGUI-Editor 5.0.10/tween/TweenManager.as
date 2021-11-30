package fairygui.tween
{
   import fairygui.GObject;
   import flash.events.Event;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class TweenManager
   {
      
      private static var _activeTweens:Array = new Array(30);
      
      private static var _tweenerPool:Vector.<GTweener> = new Vector.<GTweener>();
      
      private static var _totalActiveTweens:int = 0;
      
      private static var _timer:Timer = null;
      
      private static var _lastTime:int;
       
      
      public function TweenManager()
      {
         super();
      }
      
      static function createTween() : GTweener
      {
         var _loc2_:* = null;
         if(!_timer)
         {
            _timer = new Timer(10);
            _timer.addEventListener("timer",update);
            _timer.start();
            _lastTime = getTimer();
         }
         var _loc1_:int = _tweenerPool.length;
         if(_loc1_ > 0)
         {
            _loc2_ = _tweenerPool.pop();
         }
         else
         {
            _loc2_ = new GTweener();
         }
         _loc2_._init();
         _totalActiveTweens = Number(_totalActiveTweens) + 1;
         _activeTweens[Number(_totalActiveTweens)] = _loc2_;
         return _loc2_;
      }
      
      static function isTweening(param1:Object, param2:Object) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:* = null;
         if(param1 == null)
         {
            return false;
         }
         var _loc3_:* = param2 == null;
         _loc4_ = 0;
         while(_loc4_ < _totalActiveTweens)
         {
            _loc5_ = _activeTweens[_loc4_];
            if(_loc5_ != null && _loc5_.target == param1 && !_loc5_._killed && (_loc3_ || _loc5_._propType == param2))
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      static function killTweens(param1:Object, param2:Boolean, param3:Object) : Boolean
      {
         var _loc7_:int = 0;
         var _loc8_:* = null;
         if(param1 == null)
         {
            return false;
         }
         var _loc4_:Boolean = false;
         var _loc6_:int = _totalActiveTweens;
         var _loc5_:* = param3 == null;
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = _activeTweens[_loc7_];
            if(_loc8_ != null && _loc8_.target == param1 && !_loc8_._killed && (_loc5_ || _loc8_._propType == param3))
            {
               _loc8_.kill(param2);
               _loc4_ = true;
            }
            _loc7_++;
         }
         return _loc4_;
      }
      
      static function getTween(param1:Object, param2:Object) : GTweener
      {
         var _loc5_:int = 0;
         var _loc6_:* = null;
         if(param1 == null)
         {
            return null;
         }
         var _loc4_:int = _totalActiveTweens;
         var _loc3_:* = param2 == null;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _activeTweens[_loc5_];
            if(_loc6_ != null && _loc6_.target == param1 && !_loc6_._killed && (_loc3_ || _loc6_._propType == param2))
            {
               return _loc6_;
            }
            _loc5_++;
         }
         return null;
      }
      
      static function update(param1:Event) : void
      {
         var _loc5_:int = 0;
         var _loc6_:* = null;
         var _loc7_:* = 0;
         var _loc8_:int = getTimer();
         var _loc2_:Number = _loc8_ - _lastTime;
         _lastTime = _loc8_;
         _loc2_ = _loc2_ / 1000;
         var _loc4_:int = _totalActiveTweens;
         var _loc3_:* = -1;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _activeTweens[_loc5_];
            if(_loc6_ == null)
            {
               if(_loc3_ == -1)
               {
                  _loc3_ = _loc5_;
               }
            }
            else if(_loc6_._killed)
            {
               _loc6_._reset();
               _tweenerPool.push(_loc6_);
               _activeTweens[_loc5_] = null;
               if(_loc3_ == -1)
               {
                  _loc3_ = _loc5_;
               }
            }
            else
            {
               if(_loc6_._target is GObject && GObject(_loc6_._target).isDisposed)
               {
                  _loc6_._killed = true;
               }
               else if(!_loc6_._paused)
               {
                  _loc6_._update(_loc2_);
               }
               if(_loc3_ != -1)
               {
                  _activeTweens[_loc3_] = _loc6_;
                  _activeTweens[_loc5_] = null;
                  _loc3_++;
               }
            }
            _loc5_++;
         }
         if(_loc3_ >= 0)
         {
            if(_totalActiveTweens != _loc4_)
            {
               _loc7_ = _loc4_;
               _loc4_ = _totalActiveTweens - _loc4_;
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  _loc3_++;
                  _loc7_++;
                  _activeTweens[_loc3_] = _activeTweens[_loc7_];
                  _loc5_++;
               }
            }
            _totalActiveTweens = _loc3_;
         }
      }
   }
}
