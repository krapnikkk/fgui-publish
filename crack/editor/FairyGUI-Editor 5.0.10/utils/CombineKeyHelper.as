package fairygui.utils
{
   import flash.events.KeyboardEvent;
   
   public class CombineKeyHelper
   {
       
      
      private var _keyStatus:int;
      
      private var _keyCodes:Array;
      
      private var _keysCount:int;
      
      private var _keyMapping:Object;
      
      private var _combineKeyCode:int;
      
      private var _needReset:Boolean;
      
      public function CombineKeyHelper()
      {
         super();
         this._keyCodes = [];
         this._keyMapping = {};
      }
      
      public function onKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:int = this._keyCodes[param1.keyCode];
         if(_loc2_)
         {
            if(this._needReset)
            {
               this._keyStatus = 0;
            }
            this._keyStatus = this._keyStatus | _loc2_;
            if(this._keyStatus)
            {
               this._combineKeyCode = this._keyMapping[this._keyStatus];
            }
            else
            {
               this._combineKeyCode = 0;
            }
         }
         this._needReset = param1.ctrlKey || param1.commandKey;
      }
      
      public function onKeyUp(param1:KeyboardEvent) : void
      {
         var _loc2_:int = this._keyCodes[param1.keyCode];
         if(_loc2_)
         {
            this._keyStatus = this._keyStatus & ~_loc2_;
            if(this._keyStatus)
            {
               this._combineKeyCode = this._keyMapping[this._keyStatus];
            }
            else
            {
               this._combineKeyCode = 0;
            }
         }
      }
      
      public function get keyCode() : int
      {
         return this._combineKeyCode;
      }
      
      public function defineKey(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         _loc4_ = int(this._keyCodes[param1]);
         if(!_loc4_)
         {
            _loc4_ = 1 << this._keysCount;
            this._keysCount++;
            this._keyCodes[param1] = _loc4_;
         }
         if(param2)
         {
            _loc5_ = int(this._keyCodes[param2]);
            if(!_loc5_)
            {
               _loc5_ = 1 << this._keysCount;
               this._keysCount++;
               this._keyCodes[param2] = _loc5_;
            }
         }
         this._keyMapping[_loc4_ + _loc5_] = param3;
      }
   }
}
