package fairygui.editor.gui.gear
{
   import fairygui.editor.gui.FObject;
   
   public class FGearDisplay2 extends FGearBase
   {
       
      
      private var _visible:int;
      
      public function FGearDisplay2(param1:FObject)
      {
         super(param1);
         _gearIndex = 8;
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
      
      public function evaluate(param1:Boolean) : Boolean
      {
         var _loc2_:Boolean = _controller == null || this._visible > 0;
         if(_condition == 0)
         {
            _loc2_ = _loc2_ && param1;
         }
         else
         {
            _loc2_ = _loc2_ || param1;
         }
         return _loc2_;
      }
      
      override public function apply() : void
      {
         var _loc1_:* = false;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         if(_controller == null || _controller.parent == null || _storage == null || _storage.length == 0)
         {
            this._visible = 1;
         }
         else if(_storage != null && _storage.length)
         {
            _loc1_ = _storage.indexOf(_controller.selectedPageId) != -1;
            if(!_loc1_)
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
            else
            {
               this._visible = 1;
            }
         }
      }
   }
}
