package fairygui.utils
{
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class GTimers
   {
      
      public static var deltaTime:int;
      
      public static var time:Number;
      
      public static var workCount:uint;
      
      public static const inst:GTimers = new GTimers();
      
      private static const FPS24:int = 41;
       
      
      private var _items:Object;
      
      private var _itemMap:Dictionary;
      
      private var _itemPool:Object;
      
      private var _timer:Timer;
      
      private var _lastTime:Number;
      
      private var _enumI:int;
      
      private var _enumCount:int;
      
      public function GTimers()
      {
         super();
         _items = new Vector.<TimerItem>();
         _itemMap = new Dictionary();
         _itemPool = new Vector.<TimerItem>();
         deltaTime = 1;
         _lastTime = getTimer();
         time = _lastTime;
         _timer = new Timer(10);
         _timer.addEventListener("timer",__timer);
         _timer.start();
      }
      
      private function getItem() : TimerItem
      {
         if(_itemPool.length)
         {
            return _itemPool.pop();
         }
         return new TimerItem();
      }
      
      public function add(param1:int, param2:int, param3:Function, param4:Object = null) : void
      {
         var _loc5_:TimerItem = _itemMap[param3];
         if(!_loc5_)
         {
            _loc5_ = getItem();
            _loc5_.callback = param3;
            _loc5_.hasParam = param3.length == 1;
            _itemMap[param3] = _loc5_;
            _items.push(_loc5_);
         }
         _loc5_.delay = param1;
         _loc5_.counter = 0;
         _loc5_.repeat = param2;
         _loc5_.param = param4;
         _loc5_.end = false;
      }
      
      public function callLater(param1:Function, param2:Object = null) : void
      {
         add(1,1,param1,param2);
      }
      
      public function callDelay(param1:int, param2:Function, param3:Object = null) : void
      {
         add(param1,1,param2,param3);
      }
      
      public function callBy24Fps(param1:Function, param2:Object = null) : void
      {
         add(41,0,param1,param2);
      }
      
      public function exists(param1:Function) : Boolean
      {
         return _itemMap[param1] != undefined;
      }
      
      public function remove(param1:Function) : void
      {
         var _loc3_:int = 0;
         var _loc2_:TimerItem = _itemMap[param1];
         if(_loc2_)
         {
            _loc3_ = _items.indexOf(_loc2_);
            _items.splice(_loc3_,1);
            if(_loc3_ < _enumI)
            {
               _enumI = Number(_enumI) - 1;
            }
            _enumCount = Number(_enumCount) - 1;
            _loc2_.callback = null;
            _loc2_.param = null;
            delete _itemMap[param1];
            _itemPool.push(_loc2_);
         }
      }
      
      private function __timer(param1:TimerEvent) : void
      {
         var _loc2_:* = null;
         time = getTimer();
         workCount = Number(workCount) + 1;
         deltaTime = time - _lastTime;
         _lastTime = time;
         if(deltaTime > 125)
         {
            deltaTime = 125;
         }
         _enumI = 0;
         _enumCount = _items.length;
         while(_enumI < _enumCount)
         {
            _loc2_ = _items[_enumI];
            _enumI = Number(_enumI) + 1;
            if(_loc2_.advance(deltaTime))
            {
               if(_loc2_.end)
               {
                  _enumI = Number(_enumI) - 1;
                  _enumCount = Number(_enumCount) - 1;
                  _items.splice(_enumI,1);
                  delete _itemMap[_loc2_.callback];
                  _itemPool.push(_loc2_);
               }
               if(_loc2_.hasParam)
               {
                  _loc2_.callback(_loc2_.param);
               }
               else
               {
                  _loc2_.callback();
               }
            }
         }
      }
   }
}

class TimerItem
{
    
   
   public var delay:int;
   
   public var counter:int;
   
   public var repeat:int;
   
   public var callback:Function;
   
   public var param:Object;
   
   public var hasParam:Boolean;
   
   public var end:Boolean;
   
   function TimerItem()
   {
      super();
   }
   
   public function advance(param1:int) : Boolean
   {
      counter = counter + param1;
      if(counter >= delay)
      {
         counter = counter - delay;
         if(counter > delay)
         {
            counter = delay;
         }
         if(repeat > 0)
         {
            repeat = Number(repeat) - 1;
            if(repeat == 0)
            {
               end = true;
            }
         }
         return true;
      }
      return false;
   }
}
