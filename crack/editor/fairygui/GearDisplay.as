package fairygui
{
   public class GearDisplay extends GearBase
   {
       
      
      public var pages:Array;
      
      private var _visible:int;
      
      public function GearDisplay(param1:GObject)
      {
         super(param1);
         _displayLockToken = 1;
      }
      
      override protected function init() : void
      {
         pages = null;
      }
      
      public function addLock() : uint
      {
         _visible = Number(_visible) + 1;
         return _displayLockToken;
      }
      
      public function releaseLock(param1:uint) : void
      {
         if(param1 == _displayLockToken)
         {
            _visible = Number(_visible) - 1;
         }
      }
      
      public function get connected() : Boolean
      {
         return _controller == null || _visible > 0;
      }
      
      override public function apply() : void
      {
         _displayLockToken = Number(_displayLockToken) + 1;
         if(_displayLockToken == 0)
         {
            _displayLockToken = 1;
         }
         if(pages == null || pages.length == 0 || pages.indexOf(_controller.selectedPageId) != -1)
         {
            _visible = 1;
         }
         else
         {
            _visible = 0;
         }
      }
   }
}
