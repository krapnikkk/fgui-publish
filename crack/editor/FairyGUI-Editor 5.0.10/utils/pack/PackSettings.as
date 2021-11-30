package fairygui.utils.pack
{
   public class PackSettings
   {
       
      
      private var _pot:Boolean;
      
      private var _mof:Boolean;
      
      private var _padding:int;
      
      private var _rotation:Boolean;
      
      private var _minWidth:int;
      
      private var _minHeight:int;
      
      private var _maxWidth:int;
      
      private var _maxHeight:int;
      
      private var _square:Boolean;
      
      private var _fast:Boolean;
      
      private var _edgePadding:Boolean;
      
      private var _duplicatePadding:Boolean;
      
      private var _multiPage:Boolean;
      
      public function PackSettings()
      {
         super();
         this._pot = true;
         this._mof = true;
         this._padding = 2;
         this._rotation = false;
         this._minWidth = 16;
         this._minHeight = 16;
         this._maxWidth = 2048;
         this._maxHeight = 2048;
         this._square = false;
         this._fast = true;
         this._edgePadding = false;
         this._duplicatePadding = false;
         this._multiPage = false;
      }
      
      public function get pot() : Boolean
      {
         return this._pot;
      }
      
      public function set pot(param1:Boolean) : void
      {
         this._pot = param1;
      }
      
      public function get mof() : Boolean
      {
         return this._mof;
      }
      
      public function set mof(param1:Boolean) : void
      {
         this._mof = param1;
      }
      
      public function get padding() : int
      {
         return this._padding;
      }
      
      public function set padding(param1:int) : void
      {
         this._padding = param1;
      }
      
      public function get rotation() : Boolean
      {
         return this._rotation;
      }
      
      public function set rotation(param1:Boolean) : void
      {
         this._rotation = param1;
      }
      
      public function get minWidth() : int
      {
         return this._minWidth;
      }
      
      public function set minWidth(param1:int) : void
      {
         this._minWidth = param1;
      }
      
      public function get minHeight() : int
      {
         return this._minHeight;
      }
      
      public function set minHeight(param1:int) : void
      {
         this._minHeight = param1;
      }
      
      public function get maxWidth() : int
      {
         return this._maxWidth;
      }
      
      public function set maxWidth(param1:int) : void
      {
         this._maxWidth = param1;
      }
      
      public function get maxHeight() : int
      {
         return this._maxHeight;
      }
      
      public function set maxHeight(param1:int) : void
      {
         this._maxHeight = param1;
      }
      
      public function get square() : Boolean
      {
         return this._square;
      }
      
      public function set square(param1:Boolean) : void
      {
         this._square = param1;
      }
      
      public function get fast() : Boolean
      {
         return this._fast;
      }
      
      public function set fast(param1:Boolean) : void
      {
         this._fast = param1;
      }
      
      public function get edgePadding() : Boolean
      {
         return this._edgePadding;
      }
      
      public function set edgePadding(param1:Boolean) : void
      {
         this._edgePadding = param1;
      }
      
      public function get duplicatePadding() : Boolean
      {
         return this._duplicatePadding;
      }
      
      public function set duplicatePadding(param1:Boolean) : void
      {
         this._duplicatePadding = param1;
      }
      
      public function get multiPage() : Boolean
      {
         return this._multiPage;
      }
      
      public function set multiPage(param1:Boolean) : void
      {
         this._multiPage = param1;
      }
      
      public function copyFrom(param1:PackSettings) : void
      {
         this._pot = param1.pot;
         this._padding = param1.padding;
         this._rotation = param1.rotation;
         this._minWidth = param1.minWidth;
         this._minHeight = param1.minHeight;
         this._maxWidth = param1.maxWidth;
         this._maxHeight = param1.maxHeight;
         this._square = param1.square;
         this._fast = param1.fast;
         this._edgePadding = param1.edgePadding;
         this._duplicatePadding = param1.duplicatePadding;
         this._multiPage = param1.multiPage;
      }
   }
}
