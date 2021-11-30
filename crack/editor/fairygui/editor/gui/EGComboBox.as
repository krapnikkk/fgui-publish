package fairygui.editor.gui
{
   import fairygui.editor.utils.UtilsStr;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class EGComboBox extends ComExtention
   {
       
      
      private var _title:String;
      
      private var _icon:String;
      
      private var _titleColor:uint;
      
      private var _titleColorSet:Boolean;
      
      private var _originColor:uint;
      
      private var _dropdown:String;
      
      private var _items:Array;
      
      private var _visibleItemCount:int;
      
      private var _direction:String;
      
      private var _selectionController:EController;
      
      private var _buttonController:EController;
      
      private var _titleObject:EGObject;
      
      private var _iconObject:EGObject;
      
      private var _dropdownObject:EGComponent;
      
      private var _list:EGList;
      
      private var _itemsUpdated:Boolean;
      
      private var _controllerFlag:Boolean;
      
      private var _down:Boolean;
      
      private var _over:Boolean;
      
      public function EGComboBox()
      {
         super();
         this._title = "";
         this._items = [];
         this._itemsUpdated = true;
         this._visibleItemCount = 10;
         this._direction = "auto";
      }
      
      override public function get title() : String
      {
         return this._title;
      }
      
      override public function set title(param1:String) : void
      {
         this._title = param1;
         if(this._titleObject)
         {
            this._titleObject.text = this._title;
         }
         _owner.updateGear(6);
      }
      
      override public function get icon() : String
      {
         return this._icon;
      }
      
      override public function set icon(param1:String) : void
      {
         this._icon = param1;
         if(this._iconObject)
         {
            this._iconObject.icon = param1;
         }
         _owner.updateGear(7);
      }
      
      public function get titleColor() : uint
      {
         return this._titleColor;
      }
      
      public function set titleColor(param1:uint) : void
      {
         if(this._titleColor != param1)
         {
            this._titleColor = param1;
            if(this._titleObject)
            {
               if(this._titleObject is EGTextField)
               {
                  EGTextField(this._titleObject).color = this._titleColor;
               }
               else if(this._titleObject is EGComponent)
               {
                  if(EGComponent(this._titleObject).extentionId == "Label")
                  {
                     EGLabel(EGComponent(this._titleObject).extention).titleColor = this._titleColor;
                  }
                  else if(EGComponent(this._titleObject).extentionId == "Button")
                  {
                     EGButton(EGComponent(this._titleObject).extention).titleColor = this._titleColor;
                  }
               }
            }
         }
      }
      
      public function get titleColorSet() : Boolean
      {
         return this._titleColorSet;
      }
      
      public function set titleColorSet(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         this._titleColorSet = param1;
         if(!this._titleColorSet)
         {
            _loc2_ = this._originColor;
         }
         else
         {
            _loc2_ = this._titleColor;
         }
         if(this._titleObject)
         {
            if(this._titleObject is EGTextField)
            {
               EGTextField(this._titleObject).color = _loc2_;
            }
            else if(this._titleObject is EGComponent)
            {
               if(EGComponent(this._titleObject).extentionId == "Label")
               {
                  EGLabel(EGComponent(this._titleObject).extention).titleColor = _loc2_;
               }
               else if(EGComponent(this._titleObject).extentionId == "Button")
               {
                  EGButton(EGComponent(this._titleObject).extention).titleColor = _loc2_;
               }
            }
         }
      }
      
      public function get dropdown() : String
      {
         return this._dropdown;
      }
      
      public function set dropdown(param1:String) : void
      {
         this._dropdown = param1;
      }
      
      public function get visibleItemCount() : int
      {
         return this._visibleItemCount;
      }
      
      public function set visibleItemCount(param1:int) : void
      {
         this._visibleItemCount = param1;
         this._itemsUpdated = true;
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(param1:String) : void
      {
         this._direction = param1;
      }
      
      public function get items() : Array
      {
         return this._items;
      }
      
      public function set items(param1:Array) : void
      {
         this._items = param1;
         this._itemsUpdated = true;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(param1 < this._items.length)
         {
            this.title = this._items[param1][0];
            this.icon = this._items[param1][2];
         }
      }
      
      private function setState(param1:String) : void
      {
         if(this._buttonController)
         {
            this._buttonController.selectedPage = param1;
         }
      }
      
      public function get selectionController() : String
      {
         if(this._selectionController && this._selectionController.parent)
         {
            return this._selectionController.name;
         }
         return null;
      }
      
      public function set selectionController(param1:String) : void
      {
         var _loc2_:EController = null;
         if(param1)
         {
            _loc2_ = owner.parent.getController(param1);
         }
         this._selectionController = _loc2_;
      }
      
      public function get selectionControllerObj() : EController
      {
         return this._selectionController;
      }
      
      override public function handleControllerChanged(param1:EController) : void
      {
         super.handleControllerChanged(param1);
         if(this._selectionController == param1 && !this._controllerFlag)
         {
            this._controllerFlag = true;
            this.selectedIndex = param1.selectedIndex;
            this._controllerFlag = false;
         }
      }
      
      override protected function install() : void
      {
         var _loc2_:EPackageItem = null;
         var _loc1_:EGObject = null;
         if(_owner.editMode == 1)
         {
            _owner.displayObject.addEventListener("rollOver",this.__rollover);
            _owner.displayObject.addEventListener("rollOut",this.__rollout);
            _owner.displayObject.addEventListener("mouseDown",this.__mousedown);
         }
         this._buttonController = _owner.getController("button");
         this._titleObject = owner.getChild("title");
         this._iconObject = owner.getChild("icon");
         if(this._titleObject)
         {
            if(this._titleObject is EGTextField)
            {
               this._originColor = EGTextField(this._titleObject).color;
            }
            else if(this._titleObject is EGComponent)
            {
               if(EGComponent(this._titleObject).extentionId == "Label")
               {
                  this._originColor = EGLabel(EGComponent(this._titleObject).extention).titleColor;
               }
               else if(EGComponent(this._titleObject).extentionId == "Button")
               {
                  this._originColor = EGButton(EGComponent(this._titleObject).extention).titleColor;
               }
            }
         }
         this._list = null;
         if(this._dropdown && this.owner.editMode == 1)
         {
            _loc2_ = this.owner.pkg.project.getItemByURL(this._dropdown);
            if(_loc2_ != null)
            {
               _loc1_ = EUIObjectFactory.createObject(_loc2_,owner.editMode == 1?1:0);
               if(_loc1_ is EGComponent)
               {
                  this._dropdownObject = EGComponent(_loc1_);
                  this._list = EGList(this._dropdownObject.getChild("list"));
                  if(this._list != null)
                  {
                     this._list.addEventListener("___itemClick",this.__clickItem);
                     this._list.relations.addItem2(this._dropdownObject,"width","width");
                     this._list.relations.removeItem2(this._dropdownObject,"height","height");
                     this._dropdownObject.relations.addItem2(this._list,"height","height");
                     this._dropdownObject.relations.removeItem2(this._list,"width","width");
                     this._dropdownObject.displayObject.addEventListener("removedFromStage",this.__popupWinClosed);
                  }
               }
               else
               {
                  _loc1_.dispose();
               }
            }
         }
      }
      
      override protected function uninstall() : void
      {
         if(_owner.editMode == 1)
         {
            _owner.displayObject.removeEventListener("rollOver",this.__rollover);
            _owner.displayObject.removeEventListener("rollOut",this.__rollout);
            _owner.displayObject.removeEventListener("mouseDown",this.__mousedown);
         }
         this._buttonController = null;
         this._titleObject = null;
      }
      
      override public function load(param1:XML) : void
      {
         this._dropdown = param1.@dropdown;
      }
      
      override public function serialize() : XML
      {
         var _loc1_:XML = <ComboBox/>;
         if(this._dropdown)
         {
            _loc1_.@dropdown = this._dropdown;
         }
         return _loc1_;
      }
      
      override public function fromXML(param1:XML) : void
      {
         var _loc5_:String = null;
         var _loc2_:XML = null;
         _loc5_ = param1.@titleColor;
         if(_loc5_)
         {
            this.titleColor = UtilsStr.convertFromHtmlColor(_loc5_);
            this._titleColorSet = true;
         }
         _loc5_ = param1.@visibleItemCount;
         if(_loc5_)
         {
            this._visibleItemCount = parseInt(_loc5_);
         }
         _loc5_ = param1.@direction;
         if(_loc5_)
         {
            this._direction = _loc5_;
         }
         var _loc3_:XMLList = param1.item;
         var _loc4_:Array = [];
         var _loc7_:int = 0;
         var _loc6_:* = _loc3_;
         for each(_loc2_ in _loc3_)
         {
            _loc4_.push([String(_loc2_.@title),String(_loc2_.@value),String(_loc2_.@icon)]);
         }
         this.items = _loc4_;
         _loc5_ = param1.@title;
         if(this.owner.editMode == 1)
         {
            if(_loc5_)
            {
               this.title = _loc5_;
            }
            else if(_loc4_.length > 0)
            {
               this.title = _loc4_[0][0];
            }
         }
         else if(_loc5_)
         {
            this.title = _loc5_;
         }
         _loc5_ = param1.@icon;
         if(this.owner.editMode == 1)
         {
            if(_loc5_)
            {
               this.icon = _loc5_;
            }
            else if(_loc4_.length > 0)
            {
               this.icon = _loc4_[0][2];
            }
         }
         else if(_loc5_)
         {
            this.icon = _loc5_;
         }
         _loc5_ = param1.@selectionController;
         if(_loc5_)
         {
            this._selectionController = owner.parent.getController(_loc5_);
         }
         else
         {
            this._selectionController = null;
         }
      }
      
      override public function toXML() : XML
      {
         var _loc2_:Array = null;
         var _loc1_:XML = null;
         var _loc3_:XML = <ComboBox/>;
         if(this._title)
         {
            _loc3_.@title = this._title;
         }
         if(this._icon)
         {
            _loc3_.@icon = this._icon;
         }
         if(this._titleColorSet)
         {
            _loc3_.@titleColor = UtilsStr.convertToHtmlColor(this._titleColor);
         }
         if(this._visibleItemCount)
         {
            _loc3_.@visibleItemCount = this._visibleItemCount;
         }
         if(this._direction != "auto")
         {
            _loc3_.@direction = this._direction;
         }
         if(this._selectionController && this._selectionController.parent)
         {
            _loc3_.@selectionController = this._selectionController.name;
         }
         if(this._items.length)
         {
            var _loc5_:int = 0;
            var _loc4_:* = this._items;
            for each(_loc2_ in this._items)
            {
               _loc1_ = <item/>;
               if(_loc2_[0])
               {
                  _loc1_.@title = _loc2_[0];
               }
               if(_loc2_[1])
               {
                  _loc1_.@value = _loc2_[1];
               }
               if(_loc2_[2])
               {
                  _loc1_.@icon = _loc2_[2];
               }
               _loc3_.appendChild(_loc1_);
            }
         }
         if(_loc3_.attributes().length() == 0 && this._items.length == 0)
         {
            return null;
         }
         return _loc3_;
      }
      
      private function __rollover(param1:Event) : void
      {
         this._over = true;
         if(this._down || this._dropdownObject && this._dropdownObject.displayObject.parent)
         {
            return;
         }
         this.setState("over");
      }
      
      private function __rollout(param1:Event) : void
      {
         this._over = false;
         if(this._down || this._dropdownObject && this._dropdownObject.displayObject.parent)
         {
            return;
         }
         this.setState("up");
      }
      
      private function __mousedown(param1:MouseEvent) : void
      {
         this._down = true;
         _owner.displayObject.stage.addEventListener("mouseUp",this.__mouseup);
         this.setState("down");
         if(this._dropdownObject)
         {
            this.showDropdown();
         }
      }
      
      private function __mouseup(param1:MouseEvent) : void
      {
         if(this._dropdownObject && !this._dropdownObject.displayObject.parent)
         {
            this.owner.pkg.project.editorWindow.stage.removeEventListener("mouseUp",this.__mouseup);
            this._down = false;
            if(this._over)
            {
               this.setState("over");
            }
            else
            {
               this.setState("up");
            }
         }
      }
      
      protected function showDropdown() : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         var _loc1_:EGObject = null;
         if(this._itemsUpdated)
         {
            this._itemsUpdated = false;
            this._list.removeChildren();
            _loc3_ = this._items.length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc1_ = this._list.addItem(this._list.defaultItem);
               if(_loc1_ is EGComponent && EGComponent(_loc1_).extention is EGButton)
               {
                  EGButton(EGComponent(_loc1_).extention).title = this._items[_loc2_][0];
                  EGButton(EGComponent(_loc1_).extention).icon = this._items[_loc2_][2];
               }
               _loc2_++;
            }
            this._list.resizeToFit(this._visibleItemCount,10);
         }
         this._list.clearSelection();
         this._dropdownObject.width = this.owner.width;
         this.setState("down");
         this.owner.pkg.project.editorWindow.mainPanel.testPanel.togglePopup(this._dropdownObject,this.owner,this._direction);
      }
      
      private function __popupWinClosed(param1:Event) : void
      {
         if(this._over)
         {
            this.setState("over");
         }
         else
         {
            this.setState("up");
         }
      }
      
      private function __clickItem(param1:EItemEvent) : void
      {
         this.owner.pkg.project.editorWindow.mainPanel.testPanel.hidePopup();
         var _loc2_:int = this._list.getChildIndex(param1.itemObject);
         this.selectedIndex = _loc2_;
         if(this._selectionController && _loc2_ < this._selectionController.pageCount && !this._controllerFlag)
         {
            this._controllerFlag = true;
            this._selectionController.selectedIndex = _loc2_;
            this._controllerFlag = false;
         }
      }
   }
}
