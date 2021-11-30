package fairygui.editor.gui
{
   import fairygui.GButton;
   import fairygui.ObjectPropID;
   import fairygui.utils.UtilsStr;
   import fairygui.utils.XData;
   import fairygui.utils.XDataEnumerator;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class FComboBox extends ComExtention
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
      
      private var _selectionController:FController;
      
      private var _buttonController:FController;
      
      private var _titleObject:FObject;
      
      private var _iconObject:FObject;
      
      private var _dropdownObject:FComponent;
      
      private var _list:FList;
      
      private var _itemsUpdated:Boolean;
      
      private var _controllerFlag:Boolean;
      
      private var _down:Boolean;
      
      private var _over:Boolean;
      
      public var clearOnPublish:Boolean;
      
      public function FComboBox()
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
               if(this._titleObject is FTextField)
               {
                  FTextField(this._titleObject).color = this._titleColor;
               }
               else if(this._titleObject is FComponent)
               {
                  if(FComponent(this._titleObject).extentionId == "Label")
                  {
                     FLabel(FComponent(this._titleObject).extention).titleColor = this._titleColor;
                  }
                  else if(FComponent(this._titleObject).extentionId == "Button")
                  {
                     FButton(FComponent(this._titleObject).extention).titleColor = this._titleColor;
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
            if(this._titleObject is FTextField)
            {
               FTextField(this._titleObject).color = _loc2_;
            }
            else if(this._titleObject is FComponent)
            {
               if(FComponent(this._titleObject).extentionId == "Label")
               {
                  FLabel(FComponent(this._titleObject).extention).titleColor = _loc2_;
               }
               else if(FComponent(this._titleObject).extentionId == "Button")
               {
                  FButton(FComponent(this._titleObject).extention).titleColor = _loc2_;
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
         var _loc2_:FController = null;
         if(param1)
         {
            _loc2_ = owner._parent.getController(param1);
         }
         this._selectionController = _loc2_;
      }
      
      public function get selectionControllerObj() : FController
      {
         return this._selectionController;
      }
      
      override public function handleControllerChanged(param1:FController) : void
      {
         super.handleControllerChanged(param1);
         if(this._selectionController == param1 && !this._controllerFlag)
         {
            this._controllerFlag = true;
            this.selectedIndex = param1.selectedIndex;
            this._controllerFlag = false;
         }
      }
      
      public function getTextField() : FTextField
      {
         if(this._titleObject is FTextField)
         {
            return FTextField(this._titleObject);
         }
         if(this._titleObject is FLabel)
         {
            return FLabel(this._titleObject).getTextField();
         }
         if(this._titleObject is FButton)
         {
            return FButton(this._titleObject).getTextField();
         }
         return null;
      }
      
      override public function getProp(param1:int) : *
      {
         var _loc2_:FTextField = null;
         switch(param1)
         {
            case ObjectPropID.Color:
               return this.titleColor;
            case ObjectPropID.OutlineColor:
               _loc2_ = this.getTextField();
               if(_loc2_)
               {
                  return _loc2_.strokeColor;
               }
               return 0;
            case ObjectPropID.FontSize:
               _loc2_ = this.getTextField();
               if(_loc2_)
               {
                  return _loc2_.fontSize;
               }
               return 0;
            default:
               return super.getProp(param1);
         }
      }
      
      override public function setProp(param1:int, param2:*) : void
      {
         var _loc3_:FTextField = null;
         switch(param1)
         {
            case ObjectPropID.Color:
               this.titleColor = param2;
               break;
            case ObjectPropID.OutlineColor:
               _loc3_ = this.getTextField();
               if(_loc3_)
               {
                  _loc3_.strokeColor = param2;
               }
               break;
            case ObjectPropID.FontSize:
               _loc3_ = this.getTextField();
               if(_loc3_)
               {
                  _loc3_.fontSize = param2;
               }
               break;
            default:
               super.setProp(param1,param2);
         }
      }
      
      override public function create() : void
      {
         var _loc1_:FPackageItem = null;
         var _loc2_:FObject = null;
         if((_owner._flags & FObjectFlags.IN_TEST) != 0)
         {
            _owner.displayObject.addEventListener(MouseEvent.ROLL_OVER,this.__rollover);
            _owner.displayObject.addEventListener(MouseEvent.ROLL_OUT,this.__rollout);
            _owner.displayObject.addEventListener(MouseEvent.MOUSE_DOWN,this.__mousedown);
         }
         this._buttonController = _owner.getController("button");
         this._titleObject = owner.getChild("title");
         this._iconObject = owner.getChild("icon");
         if(this._titleObject)
         {
            if(this._titleObject is FTextField)
            {
               this._originColor = FTextField(this._titleObject).color;
            }
            else if(this._titleObject is FComponent)
            {
               if(FComponent(this._titleObject).extentionId == "Label")
               {
                  this._originColor = FLabel(FComponent(this._titleObject).extention).titleColor;
               }
               else if(FComponent(this._titleObject).extentionId == "Button")
               {
                  this._originColor = FButton(FComponent(this._titleObject).extention).titleColor;
               }
            }
         }
         this._list = null;
         if(this._dropdown && (_owner._flags & FObjectFlags.IN_TEST) != 0)
         {
            _loc1_ = this.owner._pkg.project.getItemByURL(this._dropdown);
            if(_loc1_ != null)
            {
               _loc2_ = FObjectFactory.createObject(_loc1_,_owner._flags & 255);
               if(_loc2_ is FComponent)
               {
                  this._dropdownObject = FComponent(_loc2_);
                  this._list = FList(this._dropdownObject.getChild("list"));
                  if(this._list != null)
                  {
                     this._list.addEventListener(FItemEvent.CLICK,this.__clickItem);
                     this._list.relations.addItem2(this._dropdownObject,"width-width");
                     this._dropdownObject.relations.addItem2(this._list,"height-height");
                     this._dropdownObject.displayObject.addEventListener(Event.REMOVED_FROM_STAGE,this.__popupWinClosed);
                  }
               }
               else
               {
                  _loc2_.dispose();
               }
            }
         }
      }
      
      override public function dispose() : void
      {
         if((_owner._flags & FObjectFlags.IN_TEST) != 0)
         {
            _owner.displayObject.removeEventListener(MouseEvent.ROLL_OVER,this.__rollover);
            _owner.displayObject.removeEventListener(MouseEvent.ROLL_OUT,this.__rollout);
            _owner.displayObject.removeEventListener(MouseEvent.MOUSE_DOWN,this.__mousedown);
         }
      }
      
      override public function read_editMode(param1:XData) : void
      {
         this._dropdown = param1.getAttribute("dropdown");
      }
      
      override public function write_editMode() : XData
      {
         var _loc1_:XData = XData.create("ComboBox");
         if(this._dropdown)
         {
            _loc1_.setAttribute("dropdown",this._dropdown);
         }
         return _loc1_;
      }
      
      override public function read(param1:XData, param2:Object) : void
      {
         var _loc3_:String = null;
         var _loc7_:XData = null;
         var _loc8_:Object = null;
         var _loc9_:* = undefined;
         _loc3_ = param1.getAttribute("titleColor");
         if(_loc3_)
         {
            this.titleColor = UtilsStr.convertFromHtmlColor(_loc3_);
            this._titleColorSet = true;
         }
         this._visibleItemCount = param1.getAttributeInt("visibleItemCount",10);
         this._direction = param1.getAttribute("direction","auto");
         var _loc4_:XDataEnumerator = param1.getEnumerator("item");
         var _loc5_:Array = [];
         var _loc6_:int = 0;
         while(_loc4_.moveNext())
         {
            _loc7_ = _loc4_.current;
            _loc8_ = [_loc7_.getAttribute("title",""),_loc7_.getAttribute("value",""),_loc7_.getAttribute("icon","")];
            _loc5_.push(_loc8_);
            if(param2)
            {
               _loc9_ = param2[_owner.id + "-" + _loc6_];
               if(_loc9_ != undefined)
               {
                  _loc8_[0] = _loc9_;
               }
            }
            _loc6_++;
         }
         this.items = _loc5_;
         _loc3_ = param1.getAttribute("title");
         if(param2)
         {
            _loc9_ = param2[_owner.id];
            if(_loc9_ != undefined)
            {
               _loc3_ = _loc9_;
            }
         }
         if((_owner._flags & FObjectFlags.IN_TEST) != 0)
         {
            if(_loc3_)
            {
               this.title = _loc3_;
            }
            else if(_loc5_.length > 0)
            {
               this.title = _loc5_[0][0];
            }
         }
         else if(_loc3_)
         {
            this.title = _loc3_;
         }
         _loc3_ = param1.getAttribute("icon");
         if((_owner._flags & FObjectFlags.IN_TEST) != 0)
         {
            if(_loc3_)
            {
               this.icon = _loc3_;
            }
            else if(_loc5_.length > 0)
            {
               this.icon = _loc5_[0][2];
            }
         }
         else if(_loc3_)
         {
            this.icon = _loc3_;
         }
         _loc3_ = param1.getAttribute("selectionController");
         if(_loc3_)
         {
            this._selectionController = owner._parent.getController(_loc3_);
         }
         else
         {
            this._selectionController = null;
         }
         this.clearOnPublish = param1.getAttributeBool("autoClearItems");
      }
      
      override public function write() : XData
      {
         var _loc2_:Array = null;
         var _loc3_:XData = null;
         var _loc1_:XData = XData.create("ComboBox");
         if(this._title)
         {
            _loc1_.setAttribute("title",this._title);
         }
         if(this._icon)
         {
            _loc1_.setAttribute("icon",this._icon);
         }
         if(this._titleColorSet)
         {
            _loc1_.setAttribute("titleColor",UtilsStr.convertToHtmlColor(this._titleColor));
         }
         if(this._visibleItemCount)
         {
            _loc1_.setAttribute("visibleItemCount",this._visibleItemCount);
         }
         if(this._direction != "auto")
         {
            _loc1_.setAttribute("direction",this._direction);
         }
         if(this._selectionController && this._selectionController.parent)
         {
            _loc1_.setAttribute("selectionController",this._selectionController.name);
         }
         if(this.clearOnPublish)
         {
            _loc1_.setAttribute("autoClearItems",this.clearOnPublish);
         }
         if(this._items.length)
         {
            for each(_loc2_ in this._items)
            {
               _loc3_ = XData.create("item");
               if(_loc2_[0])
               {
                  _loc3_.setAttribute("title",_loc2_[0]);
               }
               if(_loc2_[1])
               {
                  _loc3_.setAttribute("value",_loc2_[1]);
               }
               if(_loc2_[2])
               {
                  _loc3_.setAttribute("icon",_loc2_[2]);
               }
               _loc1_.appendChild(_loc3_);
            }
         }
         if(_loc1_.hasAttributes() || this._items.length > 0)
         {
            return _loc1_;
         }
         return null;
      }
      
      private function __rollover(param1:Event) : void
      {
         this._over = true;
         if(this._down || this._dropdownObject && this._dropdownObject.displayObject.parent)
         {
            return;
         }
         this.setState(FButton.OVER);
      }
      
      private function __rollout(param1:Event) : void
      {
         this._over = false;
         if(this._down || this._dropdownObject && this._dropdownObject.displayObject.parent)
         {
            return;
         }
         this.setState(FButton.UP);
      }
      
      private function __mousedown(param1:MouseEvent) : void
      {
         this._down = true;
         _owner.displayObject.stage.addEventListener(MouseEvent.MOUSE_UP,this.__mouseup);
         this.setState(FButton.DOWN);
         if(this._dropdownObject)
         {
            this.showDropdown();
         }
      }
      
      private function __mouseup(param1:MouseEvent) : void
      {
         if(this._dropdownObject && !this._dropdownObject.displayObject.parent)
         {
            owner.editor.groot.nativeStage.removeEventListener(MouseEvent.MOUSE_UP,this.__mouseup);
            this._down = false;
            if(this._over)
            {
               this.setState(FButton.OVER);
            }
            else
            {
               this.setState(FButton.UP);
            }
         }
      }
      
      protected function showDropdown() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:FObject = null;
         if(this._itemsUpdated)
         {
            this._itemsUpdated = false;
            this._list.removeChildren();
            _loc1_ = this._items.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this._list.addItem(this._list.defaultItem);
               if(_loc3_ is FComponent && FComponent(_loc3_).extention is FButton)
               {
                  FButton(FComponent(_loc3_).extention).title = this._items[_loc2_][0];
                  FButton(FComponent(_loc3_).extention).icon = this._items[_loc2_][2];
               }
               _loc2_++;
            }
            this._list.resizeToFit(this._visibleItemCount,10);
         }
         this._list.clearSelection();
         this._dropdownObject.width = this.owner.width;
         this._list.ensureBoundsCorrect();
         this.setState(GButton.DOWN);
         _owner.editor.testView.togglePopup(this._dropdownObject,this.owner,this._direction);
      }
      
      private function __popupWinClosed(param1:Event) : void
      {
         if(this._over)
         {
            this.setState(GButton.OVER);
         }
         else
         {
            this.setState(GButton.UP);
         }
      }
      
      private function __clickItem(param1:FItemEvent) : void
      {
         _owner.editor.testView.hidePopup();
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
