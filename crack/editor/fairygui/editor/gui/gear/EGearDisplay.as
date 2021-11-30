package fairygui.editor.gui.gear
{
   import fairygui.editor.gui.EGObject;
   
   public class EGearDisplay extends EGearBase
   {
       
      
      private var _pages:Array;
      
      private var _visible:int;
      
      public function EGearDisplay(param1:EGObject)
      {
         super(param1);
         gearIndex = 0;
         this._pages = [];
         _displayLockToken = 1;
      }
      
      public function get pages() : Array
      {
         return this._pages;
      }
      
      public function set pages(param1:Array) : void
      {
         this._pages = param1;
         this.apply();
         owner.checkGearDisplay();
      }
      
      override protected function init() : void
      {
         this._pages.length = 0;
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
         return _controller == null || !_controller.parent || _controller.parent.disabled_displayController || this._visible > 0;
      }
      
      override public function apply() : void
      {
         var _loc3_:* = false;
         var _loc2_:Boolean = false;
         var _loc1_:int = 0;
         _displayLockToken = Number(_displayLockToken) + 1;
         if(_displayLockToken == 0)
         {
            _displayLockToken = 1;
         }
         if(_controller == null || this._pages == null || this._pages.length == 0)
         {
            this._visible = 1;
         }
         else if(this._pages != null && this._pages.length)
         {
            _loc3_ = this._pages.indexOf(_controller.selectedPageId) != -1;
            if(!_loc3_)
            {
               _loc2_ = false;
               _loc1_ = 0;
               while(_loc1_ < this._pages.length)
               {
                  if(_controller.hasPageId(this._pages[_loc1_]))
                  {
                     _loc2_ = true;
                     break;
                  }
                  _loc1_++;
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
            else
            {
               this._visible = 1;
            }
         }
      }
   }
}
