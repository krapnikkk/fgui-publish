package fairygui.editor.gui.gear
{
   import fairygui.editor.gui.FObject;
   
   public class FGearDisplay extends FGearBase
   {
       
      
      private var _visible:int;
      
      public function FGearDisplay(param1:FObject)
      {
         super(param1);
         _gearIndex = 0;
         _displayLockToken = 1;
      }
      
      public function get pages() : Array
      {
         return _storage as Array;
      }
      
      public function set pages(param1:Array) : void
      {
         _storage = param1;
         this.apply();
         _owner.checkGearDisplay();
      }
      
      override protected function init() : void
      {
         _storage = [];
      }
      
      public function addLock() : uint
      {
         this._visible++;
         return _displayLockToken;
      }
      
      public function releaseLock(param1:uint) : void
      {
         if(param1 == _displayLockToken)
         {
            this._visible--;
         }
      }
      
      public function get connected() : Boolean
      {
         return _controller == null || this._visible > 0;
      }
      
      override public function apply() : void
      {
         var _loc1_:* = false;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         _displayLockToken++;
         if(_displayLockToken == 0)
         {
            _displayLockToken = 1;
         }
         if(_controller == null || _controller.parent == null || _storage == null || _storage.length == 0)
         {
            this._visible = 1;
         }
         else if(_storage != null && _storage.length)
         {
            _loc1_ = _storage.indexOf(_controller.selectedPageId) != -1;
            if(_loc1_)
            {
               this._visible = 1;
            }
            else
            {
               _loc2_ = false;
               _loc3_ = 0;
               while(_loc3_ < _storage.length)
               {
                  if(_controller.hasPageId(_storage[_loc3_]))
                  {
                     _loc2_ = true;
                     break;
                  }
                  _loc3_++;
               }
               if(_loc2_)
               {
                  this._visible = 0;
               }
               else
               {
                  this._visible = 1;
               }
            }
         }
      }
   }
}
