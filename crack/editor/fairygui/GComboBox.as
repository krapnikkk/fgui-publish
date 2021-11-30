package fairygui
{
   import fairygui.event.GTouchEvent;
   import fairygui.event.ItemEvent;
   import fairygui.event.StateChangeEvent;
   import fairygui.utils.ToolSet;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class GComboBox extends GComponent
   {
       
      
      public var dropdown:GComponent;
      
      protected var _titleObject:GObject;
      
      protected var _iconObject:GObject;
      
      protected var _list:GList;
      
      protected var _items:Array;
      
      protected var _icons:Array;
      
      protected var _values:Array;
      
      protected var _popupDownward:Object;
      
      private var _visibleItemCount:int;
      
      private var _itemsUpdated:Boolean;
      
      private var _selectedIndex:int;
      
      private var _buttonController:Controller;
      
      private var _over:Boolean;
      
      private var _selectionController:Controller;
      
      public function GComboBox()
      {
         super();
         _visibleItemCount = UIConfig.defaultComboBoxVisibleItemCount;
         _itemsUpdated = true;
         _selectedIndex = -1;
         _items = [];
         _values = [];
         _popupDownward = null;
      }
      
      override public final function get text() : String
      {
         if(_titleObject)
         {
            return _titleObject.text;
         }
         return null;
      }
      
      override public function set text(param1:String) : void
      {
         if(_titleObject)
         {
            _titleObject.text = param1;
         }
         updateGear(6);
      }
      
      public final function get titleColor() : uint
      {
         if(_titleObject is GTextField)
         {
            return GTextField(_titleObject).color;
         }
         if(_titleObject is GLabel)
         {
            return GLabel(_titleObject).titleColor;
         }
         if(_titleObject is GButton)
         {
            return GButton(_titleObject).titleColor;
         }
         return 0;
      }
      
      public function set titleColor(param1:uint) : void
      {
         if(_titleObject is GTextField)
         {
            GTextField(_titleObject).color = param1;
         }
         else if(_titleObject is GLabel)
         {
            GLabel(_titleObject).titleColor = param1;
         }
         else if(_titleObject is GButton)
         {
            GButton(_titleObject).titleColor = param1;
         }
      }
      
      override public final function get icon() : String
      {
         if(_iconObject)
         {
            return _iconObject.icon;
         }
         return null;
      }
      
      override public function set icon(param1:String) : void
      {
         if(_iconObject)
         {
            _iconObject.icon = param1;
         }
         updateGear(7);
      }
      
      public final function get visibleItemCount() : int
      {
         return _visibleItemCount;
      }
      
      public function set visibleItemCount(param1:int) : void
      {
         _visibleItemCount = param1;
      }
      
      public function get popupDownward() : Object
      {
         return _popupDownward;
      }
      
      public function set popupDownward(param1:Object) : void
      {
         _popupDownward = param1;
      }
      
      public final function get items() : Array
      {
         return _items;
      }
      
      public function set items(param1:Array) : void
      {
         if(!param1)
         {
            _items.length = 0;
         }
         else
         {
            _items = param1.concat();
         }
         if(_items.length > 0)
         {
            if(_selectedIndex >= _items.length)
            {
               _selectedIndex = _items.length - 1;
            }
            else if(_selectedIndex == -1)
            {
               _selectedIndex = 0;
            }
            this.text = _items[_selectedIndex];
            if(_icons != null && _selectedIndex < _icons.length)
            {
               this.icon = _icons[_selectedIndex];
            }
         }
         else
         {
            this.text = "";
            if(_icons != null)
            {
               this.icon = null;
            }
            _selectedIndex = -1;
         }
         _itemsUpdated = true;
      }
      
      public final function get icons() : Array
      {
         return _icons;
      }
      
      public function set icons(param1:Array) : void
      {
         _icons = param1;
         if(_icons != null && _selectedIndex != -1 && _selectedIndex < _icons.length)
         {
            this.icon = _icons[_selectedIndex];
         }
      }
      
      public final function get values() : Array
      {
         return _values;
      }
      
      public function set values(param1:Array) : void
      {
         if(!param1)
         {
            _values.length = 0;
         }
         else
         {
            _values = param1.concat();
         }
      }
      
      public final function get selectedIndex() : int
      {
         return _selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(_selectedIndex == param1)
         {
            return;
         }
         _selectedIndex = param1;
         if(_selectedIndex >= 0 && _selectedIndex < _items.length)
         {
            this.text = _items[_selectedIndex];
            if(_icons != null && _selectedIndex < _icons.length)
            {
               this.icon = _icons[_selectedIndex];
            }
         }
         else
         {
            this.text = "";
            if(_icons != null)
            {
               this.icon = null;
            }
         }
         updateSelectionController();
      }
      
      public function get value() : String
      {
         return _values[_selectedIndex];
      }
      
      public function set value(param1:String) : void
      {
         var _loc2_:int = _values.indexOf(param1);
         if(_loc2_ == -1 && param1 == null)
         {
            _loc2_ = _values.indexOf("");
         }
         this.selectedIndex = _loc2_;
      }
      
      public function get selectionController() : Controller
      {
         return _selectionController;
      }
      
      public function set selectionController(param1:Controller) : void
      {
         _selectionController = param1;
      }
      
      protected function setState(param1:String) : void
      {
         if(_buttonController)
         {
            _buttonController.selectedPage = param1;
         }
      }
      
      protected function setCurrentState() : void
      {
         if(this.grayed && _buttonController && _buttonController.hasPage("disabled"))
         {
            setState("disabled");
         }
         else
         {
            setState(!!_over?"over":"up");
         }
      }
      
      override protected function handleGrayedChanged() : void
      {
         if(_buttonController && _buttonController.hasPage("disabled"))
         {
            if(this.grayed)
            {
               setState("disabled");
            }
            else
            {
               setState("up");
            }
         }
         else
         {
            super.handleGrayedChanged();
         }
      }
      
      override public function handleControllerChanged(param1:Controller) : void
      {
         super.handleControllerChanged(param1);
         if(_selectionController == param1)
         {
            this.selectedIndex = param1.selectedIndex;
         }
      }
      
      private function updateSelectionController() : void
      {
         var _loc1_:* = null;
         if(_selectionController != null && !_selectionController.changing && _selectedIndex < _selectionController.pageCount)
         {
            _loc1_ = _selectionController;
            _selectionController = null;
            _loc1_.selectedIndex = _selectedIndex;
            _selectionController = _loc1_;
         }
      }
      
      override public function dispose() : void
      {
         if(dropdown)
         {
            dropdown.dispose();
            dropdown = null;
         }
         super.dispose();
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         var _loc2_:* = null;
         super.constructFromXML(param1);
         param1 = param1.ComboBox[0];
         _buttonController = getController("button");
         _titleObject = getChild("title");
         _iconObject = getChild("icon");
         _loc2_ = param1.@dropdown;
         if(_loc2_)
         {
            dropdown = UIPackage.createObjectFromURL(_loc2_) as GComponent;
            if(!dropdown)
            {
               return;
               §§push(trace("下拉框必须为元件"));
            }
            else
            {
               _list = dropdown.getChild("list").asList;
               if(_list == null)
               {
                  return;
                  §§push(trace(this.resourceURL + ": 下拉框的弹出元件里必须包含名为list的列表"));
               }
               else
               {
                  _list.addEventListener("itemClick",__clickItem);
                  _list.addRelation(dropdown,14);
                  _list.removeRelation(dropdown,15);
                  dropdown.addRelation(_list,15);
                  dropdown.removeRelation(_list,14);
                  dropdown.displayObject.addEventListener("removedFromStage",__popupWinClosed);
               }
            }
         }
         this.opaque = true;
         if(!GRoot.touchScreen)
         {
            displayObject.addEventListener("rollOver",__rollover);
            displayObject.addEventListener("rollOut",__rollout);
         }
         this.addEventListener("beginGTouch",__mousedown);
         this.addEventListener("endGTouch",__mouseup);
      }
      
      override public function setup_afterAdd(param1:XML) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc5_:int = 0;
         super.setup_afterAdd(param1);
         param1 = param1.ComboBox[0];
         if(param1)
         {
            _loc3_ = param1.@titleColor;
            if(_loc3_)
            {
               this.titleColor = ToolSet.convertFromHtmlColor(_loc3_);
            }
            _loc3_ = param1.@visibleItemCount;
            if(_loc3_)
            {
               _visibleItemCount = parseInt(_loc3_);
            }
            _loc2_ = param1.item;
            _loc5_ = 0;
            var _loc7_:int = 0;
            var _loc6_:* = _loc2_;
            for each(var _loc4_ in _loc2_)
            {
               _items.push(String(_loc4_.@title));
               _values.push(String(_loc4_.@value));
               _loc3_ = _loc4_.@icon;
               if(_loc3_)
               {
                  if(!_icons)
                  {
                     _icons = new Array(_loc2_.length());
                  }
                  _icons[_loc5_] = _loc3_;
               }
               _loc5_++;
            }
            _loc3_ = param1.@title;
            if(_loc3_)
            {
               this.text = _loc3_;
               _selectedIndex = _items.indexOf(_loc3_);
            }
            else if(_items.length > 0)
            {
               _selectedIndex = 0;
               this.text = _items[0];
            }
            else
            {
               _selectedIndex = -1;
            }
            _loc3_ = param1.@icon;
            if(_loc3_)
            {
               this.icon = _loc3_;
            }
            _loc3_ = param1.@direction;
            if(_loc3_)
            {
               if(_loc3_ == "up")
               {
                  _popupDownward = false;
               }
               else if(_loc3_ == "down")
               {
                  _popupDownward = true;
               }
            }
            _loc3_ = param1.@selectionController;
            if(_loc3_)
            {
               _selectionController = parent.getController(_loc3_);
            }
         }
      }
      
      protected function showDropdown() : void
      {
         var _loc1_:int = 0;
         var _loc3_:int = 0;
         var _loc2_:* = null;
         if(_itemsUpdated)
         {
            _itemsUpdated = false;
            _list.removeChildrenToPool();
            _loc1_ = _items.length;
            _loc3_ = 0;
            while(_loc3_ < _loc1_)
            {
               _loc2_ = _list.addItemFromPool();
               _loc2_.name = _loc3_ < _values.length?_values[_loc3_]:"";
               _loc2_.text = _items[_loc3_];
               _loc2_.icon = _icons != null && _loc3_ < _icons.length?_icons[_loc3_]:null;
               _loc3_++;
            }
            _list.resizeToFit(_visibleItemCount);
         }
         _list.selectedIndex = -1;
         dropdown.width = this.width;
         this.root.togglePopup(dropdown,this,_popupDownward);
         if(dropdown.parent)
         {
            setState("down");
         }
      }
      
      private function __popupWinClosed(param1:Event) : void
      {
         setCurrentState();
      }
      
      private function __clickItem(param1:ItemEvent) : void
      {
         if(dropdown.parent is GRoot)
         {
            GRoot(dropdown.parent).hidePopup(dropdown);
         }
         _selectedIndex = -2147483648;
         this.selectedIndex = _list.getChildIndex(param1.itemObject);
         dispatchEvent(new StateChangeEvent("stateChanged"));
      }
      
      private function __rollover(param1:Event) : void
      {
         _over = true;
         if(this.isDown || dropdown && dropdown.parent)
         {
            return;
         }
         setCurrentState();
      }
      
      private function __rollout(param1:Event) : void
      {
         _over = false;
         if(this.isDown || dropdown && dropdown.parent)
         {
            return;
         }
         setCurrentState();
      }
      
      private function __mousedown(param1:GTouchEvent) : void
      {
         if(param1.realTarget is TextField && TextField(param1.realTarget).type == "input")
         {
            return;
         }
         if(dropdown)
         {
            showDropdown();
         }
      }
      
      private function __mouseup(param1:Event) : void
      {
         if(dropdown && !dropdown.parent)
         {
            setCurrentState();
         }
      }
   }
}
