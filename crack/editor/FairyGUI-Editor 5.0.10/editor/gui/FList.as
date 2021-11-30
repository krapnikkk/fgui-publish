package fairygui.editor.gui
{
   import fairygui.GRoot;
   import fairygui.Margin;
   import fairygui.ObjectPropID;
   import fairygui.event.GTouchEvent;
   import fairygui.utils.XData;
   import fairygui.utils.XDataEnumerator;
   
   public class FList extends FComponent
   {
      
      public static const SINGLE_COLUMN:String = "column";
      
      public static const SINGLE_ROW:String = "row";
      
      public static const FLOW_HZ:String = "flow_hz";
      
      public static const FLOW_VT:String = "flow_vt";
      
      public static const PAGINATION:String = "pagination";
       
      
      private var _layout:String;
      
      private var _selectionMode:String;
      
      private var _lineGap:int;
      
      private var _columnGap:int;
      
      private var _items:Vector.<ListItemData>;
      
      private var _defaultItem:String;
      
      private var _clipSharpness:Margin;
      
      private var _autoResizeItem1:Boolean;
      
      private var _autoResizeItem2:Boolean;
      
      private var _repeatX:int;
      
      private var _repeatY:int;
      
      private var _align:String;
      
      private var _verticalAlign:String;
      
      private var _lastSelectedIndex:int;
      
      private var _selectionController:FController;
      
      private var _selectionControllerFlag:Boolean;
      
      private var _treeView:§_-BR§;
      
      private var _treeViewEnabled:Boolean;
      
      private var _indent:int;
      
      public var clearOnPublish:Boolean;
      
      public var scrollItemToViewOnClick:Boolean;
      
      public var foldInvisibleItems:Boolean;
      
      public var clickToExpand:int;
      
      public function FList()
      {
         super();
         this._items = new Vector.<ListItemData>();
         this._layout = SINGLE_COLUMN;
         this._selectionMode = "single";
         this._autoResizeItem1 = true;
         this._autoResizeItem2 = false;
         this._align = "left";
         this._verticalAlign = "top";
         this._lastSelectedIndex = -1;
         _useSourceSize = false;
         this.scrollItemToViewOnClick = true;
         this.indent = 15;
         this._objectType = FObjectType.LIST;
      }
      
      public function get layout() : String
      {
         return this._layout;
      }
      
      public function set layout(param1:String) : void
      {
         if(this._layout != param1)
         {
            this._layout = param1;
            this.buildItems();
         }
      }
      
      public function get selectionMode() : String
      {
         return this._selectionMode;
      }
      
      public function set selectionMode(param1:String) : void
      {
         this._selectionMode = param1;
      }
      
      public function get lineGap() : int
      {
         return this._lineGap;
      }
      
      public function set lineGap(param1:int) : void
      {
         if(this._lineGap != param1)
         {
            this._lineGap = param1;
            setBoundsChangedFlag();
         }
      }
      
      public function get columnGap() : int
      {
         return this._columnGap;
      }
      
      public function set columnGap(param1:int) : void
      {
         if(this._columnGap != param1)
         {
            this._columnGap = param1;
            setBoundsChangedFlag();
         }
      }
      
      public function get repeatX() : int
      {
         return this._repeatX;
      }
      
      public function set repeatX(param1:int) : void
      {
         if(this._repeatX != param1)
         {
            if(this._autoResizeItem2 && (this._repeatX == 0 || param1 == 0))
            {
               this._repeatX = param1;
               this.buildItems();
            }
            else
            {
               this._repeatX = param1;
               setBoundsChangedFlag();
            }
         }
      }
      
      public function get repeatY() : int
      {
         return this._repeatY;
      }
      
      public function set repeatY(param1:int) : void
      {
         if(this._repeatY != param1)
         {
            if(this._autoResizeItem2 && (this._repeatY == 0 || param1 == 0))
            {
               this._repeatY = param1;
               this.buildItems();
            }
            else
            {
               this._repeatY = param1;
               setBoundsChangedFlag();
            }
         }
      }
      
      public function get defaultItem() : String
      {
         return this._defaultItem;
      }
      
      public function set defaultItem(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         var _loc4_:ListItemData = null;
         if(param1)
         {
            _loc2_ = this._defaultItem;
            this._defaultItem = param1;
            _loc3_ = false;
            for each(_loc4_ in this._items)
            {
               if(_loc4_.url == _loc2_)
               {
                  _loc4_.url = param1;
                  _loc3_ = true;
               }
            }
            if(_loc3_)
            {
               this.buildItems();
            }
         }
         else
         {
            this._defaultItem = param1;
         }
      }
      
      public function get autoResizeItem() : Boolean
      {
         if(this._layout == SINGLE_COLUMN || this._layout == SINGLE_ROW)
         {
            return this._autoResizeItem1;
         }
         return this._autoResizeItem2;
      }
      
      public function set autoResizeItem(param1:Boolean) : void
      {
         if(this._layout == SINGLE_COLUMN || this._layout == SINGLE_ROW)
         {
            if(this._autoResizeItem1 != param1)
            {
               this._autoResizeItem1 = param1;
               this.buildItems();
            }
         }
         else if(this._autoResizeItem2 != param1)
         {
            this._autoResizeItem2 = param1;
            this.buildItems();
         }
      }
      
      public function get autoResizeItem1() : Boolean
      {
         return this._autoResizeItem1;
      }
      
      public function set autoResizeItem1(param1:Boolean) : void
      {
         if(this._autoResizeItem1 != param1)
         {
            this._autoResizeItem1 = param1;
            this.buildItems();
         }
      }
      
      public function get autoResizeItem2() : Boolean
      {
         return this._autoResizeItem2;
      }
      
      public function set autoResizeItem2(param1:Boolean) : void
      {
         if(this._autoResizeItem2 != param1)
         {
            this._autoResizeItem2 = param1;
            this.buildItems();
         }
      }
      
      public function get treeViewEnabled() : Boolean
      {
         return this._treeViewEnabled;
      }
      
      public function set treeViewEnabled(param1:Boolean) : void
      {
         if(this._treeViewEnabled != param1)
         {
            this._treeViewEnabled = param1;
            this.buildItems();
         }
      }
      
      public function get indent() : int
      {
         return this._indent;
      }
      
      public function set indent(param1:int) : void
      {
         if(this._indent != param1)
         {
            this._indent = param1;
            if(this._treeView)
            {
               this._treeView.indent = param1;
            }
         }
      }
      
      public function get items() : Vector.<ListItemData>
      {
         return this._items;
      }
      
      public function set items(param1:Vector.<ListItemData>) : void
      {
         this._items = param1;
         this.buildItems();
         _displayObject.handleSizeChanged();
      }
      
      public function get align() : String
      {
         return this._align;
      }
      
      public function set align(param1:String) : void
      {
         if(this._align != param1)
         {
            this._align = param1;
            this.setBoundsChangedFlag();
         }
      }
      
      public function get verticalAlign() : String
      {
         return this._verticalAlign;
      }
      
      public function set verticalAlign(param1:String) : void
      {
         if(this._verticalAlign != param1)
         {
            this._verticalAlign = param1;
            this.setBoundsChangedFlag();
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
            _loc2_ = _parent.getController(param1);
         }
         this._selectionController = _loc2_;
      }
      
      public function get selectionControllerObj() : FController
      {
         return this._selectionController;
      }
      
      public function get selectedIndex() : int
      {
         var _loc1_:int = 0;
         var _loc3_:FObject = null;
         var _loc2_:int = _children.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _children[_loc1_];
            if(_loc3_.getProp(ObjectPropID.Selected))
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return -1;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(param1 >= 0 && param1 < this.numChildren)
         {
            if(this._selectionMode != "single")
            {
               this.clearSelection();
            }
            this.addSelection(param1);
         }
         else
         {
            this.clearSelection();
         }
      }
      
      public function getSelection(param1:Vector.<int> = null) : Vector.<int>
      {
         var _loc2_:int = 0;
         var _loc4_:FObject = null;
         if(param1 == null)
         {
            param1 = new Vector.<int>();
         }
         var _loc3_:int = _children.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _children[_loc2_];
            if(_loc4_.getProp(ObjectPropID.Selected))
            {
               param1.push(_loc2_);
            }
            _loc2_++;
         }
         return param1;
      }
      
      public function addSelection(param1:int, param2:Boolean = false) : void
      {
         if(this._selectionMode == "none")
         {
            return;
         }
         if(this._selectionMode == "single")
         {
            this.clearSelection();
         }
         if(param1 < 0 || param1 >= numChildren)
         {
            return;
         }
         this._lastSelectedIndex = param1;
         var _loc3_:FObject = getChildAt(param1);
         if(_scrollPane && param2)
         {
            _scrollPane.scrollToView(_loc3_);
         }
         if(!_loc3_.getProp(ObjectPropID.Selected))
         {
            _loc3_.setProp(ObjectPropID.Selected,true);
            this.updateSelectionController(param1);
         }
      }
      
      public function removeSelection(param1:int) : void
      {
         if(this._selectionMode == "none")
         {
            return;
         }
         var _loc2_:FObject = getChildAt(param1);
         _loc2_.setProp(ObjectPropID.Selected,false);
      }
      
      public function clearSelection() : void
      {
         var _loc1_:int = 0;
         var _loc3_:FObject = null;
         var _loc2_:int = _children.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _children[_loc1_];
            _loc3_.setProp(ObjectPropID.Selected,false);
            _loc1_++;
         }
      }
      
      private function clearSelectionExcept(param1:FObject) : void
      {
         var _loc2_:int = 0;
         var _loc4_:FObject = null;
         var _loc3_:int = _children.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _children[_loc2_];
            if(_loc4_ != param1)
            {
               _loc4_.setProp(ObjectPropID.Selected,false);
            }
            _loc2_++;
         }
      }
      
      override public function addChildAt(param1:FObject, param2:int) : FObject
      {
         var _loc3_:FButton = null;
         super.addChildAt(param1,param2);
         if(param1 is FComponent)
         {
            _loc3_ = FComponent(param1).extention as FButton;
            if(_loc3_ != null)
            {
               _loc3_.changeStageOnClick = false;
            }
            param1.addEventListener(GTouchEvent.CLICK,this.__clickItem);
         }
         return param1;
      }
      
      public function addItem(param1:String) : FObject
      {
         return this.addItemAt(param1,numChildren);
      }
      
      public function addItemAt(param1:String, param2:int) : FObject
      {
         var _loc3_:FObject = null;
         var _loc4_:FPackageItem = _pkg.project.getItemByURL(param1);
         if(_loc4_ == null)
         {
            _loc3_ = FObjectFactory.createObject2(_pkg,"component",MissingInfo.create2(_pkg,param1),_flags);
         }
         else
         {
            _loc3_ = FObjectFactory.createObject(_loc4_,_flags & 255);
         }
         return this.addChildAt(_loc3_,param2);
      }
      
      private function __clickItem(param1:GTouchEvent) : void
      {
         var _loc3_:FTreeNode = null;
         var _loc2_:FObject = FObject(param1.currentTarget);
         this.setSelectionOnEvent(_loc2_);
         if(_scrollPane != null)
         {
            _scrollPane.scrollToView(_loc2_,true);
         }
         if(this._treeViewEnabled && this.clickToExpand != 0)
         {
            _loc3_ = _loc2_._treeNode;
            if(_loc3_ && this._treeView._expandedStatusInEvt == _loc3_.expanded)
            {
               if(this.clickToExpand == 2)
               {
                  if(param1.clickCount == 2)
                  {
                     _loc3_.expanded = !_loc3_.expanded;
                  }
               }
               else
               {
                  _loc3_.expanded = !_loc3_.expanded;
               }
            }
         }
         this.dispatchEvent(new FItemEvent(FItemEvent.CLICK,_loc2_));
      }
      
      private function setSelectionOnEvent(param1:FObject) : void
      {
         var _loc5_:GRoot = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:FComponent = null;
         var _loc10_:FButton = null;
         if(!(param1 is FComponent) || !(FComponent(param1).extention is FButton) || this._selectionMode == "none")
         {
            return;
         }
         var _loc2_:Boolean = false;
         var _loc3_:FButton = FComponent(param1).extention as FButton;
         var _loc4_:int = getChildIndex(param1);
         if(this._selectionMode == "single")
         {
            if(!_loc3_.selected)
            {
               this.clearSelectionExcept(param1);
               _loc3_.selected = true;
            }
         }
         else
         {
            _loc5_ = _pkg.project.editor.groot;
            if(_loc5_.shiftKeyDown)
            {
               if(!_loc3_.selected)
               {
                  if(this._lastSelectedIndex != -1)
                  {
                     _loc6_ = Math.min(this._lastSelectedIndex,_loc4_);
                     _loc7_ = Math.max(this._lastSelectedIndex,_loc4_);
                     _loc7_ = Math.min(_loc7_,numChildren - 1);
                     _loc8_ = _loc6_;
                     while(_loc8_ <= _loc7_)
                     {
                        _loc9_ = getChildAt(_loc8_) as FComponent;
                        if(_loc9_ != null)
                        {
                           _loc10_ = _loc9_.extention as FButton;
                           if(_loc10_ != null && !_loc10_.selected)
                           {
                              _loc10_.selected = true;
                           }
                        }
                        _loc8_++;
                     }
                     _loc2_ = true;
                  }
                  else
                  {
                     _loc3_.selected = true;
                  }
               }
            }
            else if(_loc5_.ctrlKeyDown || this._selectionMode == "multipleSingleClick")
            {
               _loc3_.selected = !_loc3_.selected;
            }
            else if(!_loc3_.selected)
            {
               this.clearSelectionExcept(param1);
               _loc3_.selected = true;
            }
            else
            {
               this.clearSelectionExcept(param1);
            }
         }
         if(!_loc2_)
         {
            this._lastSelectedIndex = _loc4_;
         }
         if(_loc3_.selected)
         {
            this.updateSelectionController(_loc4_);
         }
      }
      
      public function resizeToFit(param1:int = 2147483647, param2:int = 0) : void
      {
         var _loc4_:int = 0;
         var _loc5_:FObject = null;
         var _loc6_:int = 0;
         ensureBoundsCorrect();
         var _loc3_:int = this.numChildren;
         if(param1 > _loc3_)
         {
            param1 = _loc3_;
         }
         if(param1 == 0)
         {
            if(this._layout == SINGLE_COLUMN || this._layout == FLOW_HZ)
            {
               this.viewHeight = param2;
            }
            else
            {
               this.viewWidth = param2;
            }
         }
         else
         {
            _loc4_ = param1 - 1;
            _loc5_ = null;
            while(_loc4_ >= 0)
            {
               _loc5_ = this.getChildAt(_loc4_);
               if(_loc5_.visible)
               {
                  break;
               }
               _loc4_--;
            }
            if(_loc4_ < 0)
            {
               if(this._layout == SINGLE_COLUMN || this._layout == FLOW_HZ)
               {
                  this.viewHeight = param2;
               }
               else
               {
                  this.viewWidth = param2;
               }
            }
            else if(this._layout == SINGLE_COLUMN || this._layout == FLOW_HZ)
            {
               _loc6_ = _loc5_.y + _loc5_.height;
               if(_loc6_ < param2)
               {
                  _loc6_ = param2;
               }
               this.viewHeight = _loc6_;
            }
            else
            {
               _loc6_ = _loc5_.x + _loc5_.width;
               if(_loc6_ < param2)
               {
                  _loc6_ = param2;
               }
               this.viewWidth = _loc6_;
            }
         }
      }
      
      override public function handleSizeChanged() : void
      {
         super.handleSizeChanged();
         setBoundsChangedFlag();
      }
      
      override public function handleControllerChanged(param1:FController) : void
      {
         super.handleControllerChanged(param1);
         if(this._selectionController == param1 && !this._selectionControllerFlag)
         {
            this._selectionControllerFlag = true;
            this.selectedIndex = this._selectionController.selectedIndex;
            this._selectionControllerFlag = false;
         }
      }
      
      private function updateSelectionController(param1:int) : void
      {
         if(this._selectionController && !this._selectionControllerFlag && param1 < this._selectionController.pageCount)
         {
            this._selectionControllerFlag = true;
            this._selectionController.selectedIndex = param1;
            this._selectionControllerFlag = false;
         }
      }
      
      private function buildItems() : void
      {
         var _loc2_:int = 0;
         var _loc3_:ListItemData = null;
         var _loc4_:FObject = null;
         var _loc5_:FTreeNode = null;
         var _loc6_:FTreeNode = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         removeChildren(0,-1,true);
         var _loc1_:int = this._items.length;
         if(this._treeViewEnabled)
         {
            if(!this._treeView)
            {
               this._treeView = new §_-BR§(this);
            }
            else
            {
               this._treeView.removeChildren();
            }
            this._treeView.indent = this._indent;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this._items[_loc2_];
               _loc6_ = new FTreeNode(_loc2_ < _loc1_ - 1 && this._items[_loc2_ + 1].level > _loc3_.level,_loc3_.url);
               _loc6_.expanded = true;
               if(_loc2_ == 0)
               {
                  this._treeView.addChild(_loc6_);
               }
               else
               {
                  _loc7_ = this._items[_loc2_ - 1].level;
                  if(_loc3_.level > _loc7_)
                  {
                     _loc5_.addChild(_loc6_);
                  }
                  else if(_loc3_.level < _loc7_)
                  {
                     _loc8_ = _loc3_.level;
                     while(_loc8_ <= _loc7_)
                     {
                        _loc5_ = _loc5_.parent;
                        _loc8_++;
                     }
                     _loc5_.addChild(_loc6_);
                  }
                  else
                  {
                     _loc5_.parent.addChild(_loc6_);
                  }
               }
               _loc5_ = _loc6_;
               if(_loc6_.cell)
               {
                  this.initItem(_loc3_,_loc6_.cell);
               }
               _loc2_++;
            }
         }
         else
         {
            if(this._treeView)
            {
               this._treeView.removeChildren();
            }
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this._items[_loc2_];
               _loc4_ = this.addItem(_loc3_.url);
               if(_loc4_)
               {
                  this.initItem(_loc3_,_loc4_ as FComponent);
               }
               _loc2_++;
            }
         }
      }
      
      private function initItem(param1:ListItemData, param2:FComponent) : void
      {
         var _loc5_:ComProperty = null;
         if(!param2)
         {
            return;
         }
         if(param2.extention is FButton)
         {
            if(param1.title)
            {
               FButton(param2.extention).title = param1.title;
            }
            if(param1.icon)
            {
               FButton(param2.extention).icon = param1.icon;
            }
            if(param1.selectedIcon)
            {
               FButton(param2.extention).selectedIcon = param1.selectedIcon;
            }
            if(param1.selectedTitle)
            {
               FButton(param2.extention).selectedTitle = param1.selectedTitle;
            }
         }
         else if(FComponent(param2).extention is FLabel)
         {
            if(param1.title)
            {
               FLabel(param2.extention).title = param1.title;
            }
            if(param1.icon)
            {
               FLabel(param2.extention).icon = param1.icon;
            }
         }
         var _loc3_:int = param1.properties.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1.properties[_loc4_];
            if(param2.getCustomProperty(_loc5_.target,_loc5_.propertyId))
            {
               param2.applyCustomProperty(_loc5_);
            }
            _loc4_++;
         }
      }
      
      override public function validateChildren(param1:Boolean = false) : Boolean
      {
         var _loc4_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:int = _children.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(_children[_loc4_].validate(true))
            {
               _loc2_ = true;
            }
            _loc4_++;
         }
         if(_loc2_ && !param1)
         {
            this.buildItems();
         }
         if(_scrollPane && _scrollPane.validate(param1))
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      override protected function updateBounds() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:FObject = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc12_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc1_:int = numChildren;
         var _loc11_:Number = 0;
         var _loc13_:Number = 1;
         var _loc15_:int = this.viewWidth;
         var _loc16_:int = this.viewHeight;
         if(this._layout == SINGLE_COLUMN)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc4_ = getChildAt(_loc2_);
               if(_loc2_ != 0)
               {
                  _loc6_ = _loc6_ + this._lineGap;
               }
               _loc4_.setXY(0,_loc6_);
               if(this._autoResizeItem1)
               {
                  _loc4_.setSize(_loc15_,_loc4_.height,true);
               }
               _loc6_ = _loc6_ + Math.ceil(_loc4_.height);
               if(_loc4_.width > _loc9_)
               {
                  _loc9_ = _loc4_.width;
               }
               _loc2_++;
            }
            _loc8_ = _loc6_;
            if(_loc8_ <= _loc16_ && this._autoResizeItem1 && _scrollPane && _scrollPane._displayInDemand && _scrollPane.vtScrollBar)
            {
               _loc15_ = _loc15_ + _scrollPane.vtScrollBar.owner.width;
               _loc2_ = 0;
               while(_loc2_ < _loc1_)
               {
                  _loc4_ = getChildAt(_loc2_);
                  if(!(this.foldInvisibleItems && !_loc4_.visible))
                  {
                     _loc4_.setSize(_loc15_,_loc4_.height,true);
                     if(_loc4_.width > _loc9_)
                     {
                        _loc9_ = _loc4_.width;
                     }
                  }
                  _loc2_++;
               }
            }
            _loc7_ = Math.ceil(_loc9_);
         }
         else if(this._layout == SINGLE_ROW)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc4_ = getChildAt(_loc2_);
               if(_loc2_ != 0)
               {
                  _loc5_ = _loc5_ + this._columnGap;
               }
               _loc4_.setXY(_loc5_,0);
               if(this._autoResizeItem1)
               {
                  _loc4_.setSize(_loc4_.width,_loc16_,true);
               }
               _loc5_ = _loc5_ + Math.ceil(_loc4_.width);
               if(_loc4_.height > _loc10_)
               {
                  _loc10_ = _loc4_.height;
               }
               _loc2_++;
            }
            _loc7_ = _loc5_;
            if(_loc7_ <= _loc15_ && this._autoResizeItem1 && _scrollPane && _scrollPane._displayInDemand && _scrollPane.hzScrollBar)
            {
               _loc16_ = _loc16_ + _scrollPane.hzScrollBar.owner.height;
               _loc2_ = 0;
               while(_loc2_ < _loc1_)
               {
                  _loc4_ = getChildAt(_loc2_);
                  if(!(this.foldInvisibleItems && !_loc4_.visible))
                  {
                     _loc4_.setSize(_loc4_.width,_loc16_,true);
                     if(_loc4_.height > _loc10_)
                     {
                        _loc10_ = _loc4_.height;
                     }
                  }
                  _loc2_++;
               }
            }
            _loc8_ = Math.ceil(_loc10_);
         }
         else if(this._layout == FLOW_HZ)
         {
            _loc3_ = 0;
            if(this._autoResizeItem2 && this._repeatX > 0)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc1_)
               {
                  _loc4_ = getChildAt(_loc2_);
                  _loc11_ = _loc11_ + _loc4_.sourceWidth;
                  _loc3_++;
                  if(_loc3_ == this._repeatX || _loc2_ == _loc1_ - 1)
                  {
                     _loc5_ = 0;
                     _loc12_ = _loc15_ - (_loc3_ - 1) * this._columnGap;
                     _loc13_ = 1;
                     _loc3_ = _loc2_ - _loc3_ + 1;
                     while(_loc3_ <= _loc2_)
                     {
                        _loc4_ = getChildAt(_loc3_);
                        _loc4_.setXY(_loc5_,_loc6_);
                        _loc14_ = _loc4_.sourceWidth / _loc11_;
                        _loc4_.setSize(Math.round(_loc14_ / _loc13_ * _loc12_),_loc4_.height,true);
                        _loc12_ = _loc12_ - _loc4_.width;
                        _loc13_ = _loc13_ - _loc14_;
                        _loc5_ = _loc5_ + (_loc4_.width + this._columnGap);
                        if(_loc4_.height > _loc10_)
                        {
                           _loc10_ = _loc4_.height;
                        }
                        _loc3_++;
                     }
                     _loc6_ = _loc6_ + (Math.ceil(_loc10_) + this._lineGap);
                     _loc10_ = 0;
                     _loc3_ = 0;
                     _loc11_ = 0;
                  }
                  _loc2_++;
               }
               _loc8_ = _loc6_ + Math.ceil(_loc10_);
               _loc7_ = _loc15_;
            }
            else
            {
               _loc2_ = 0;
               while(_loc2_ < _loc1_)
               {
                  _loc4_ = getChildAt(_loc2_);
                  if(_loc5_ != 0)
                  {
                     _loc5_ = _loc5_ + this._columnGap;
                  }
                  if(this._repeatX != 0 && _loc3_ >= this._repeatX || this._repeatX == 0 && _loc5_ + _loc4_.width > _loc15_ && _loc10_ != 0)
                  {
                     _loc5_ = 0;
                     _loc6_ = _loc6_ + (Math.ceil(_loc10_) + this._lineGap);
                     _loc10_ = 0;
                     _loc3_ = 0;
                  }
                  _loc4_.setXY(_loc5_,_loc6_);
                  _loc5_ = _loc5_ + Math.ceil(_loc4_.width);
                  if(_loc5_ > _loc9_)
                  {
                     _loc9_ = _loc5_;
                  }
                  if(_loc4_.height > _loc10_)
                  {
                     _loc10_ = _loc4_.height;
                  }
                  _loc3_++;
                  _loc2_++;
               }
               _loc8_ = _loc6_ + Math.ceil(_loc10_);
               _loc7_ = Math.ceil(_loc9_);
            }
         }
         else if(this._layout == FLOW_VT)
         {
            _loc3_ = 0;
            if(this._autoResizeItem2 && this._repeatY > 0)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc1_)
               {
                  _loc4_ = getChildAt(_loc2_);
                  _loc11_ = _loc11_ + _loc4_.sourceHeight;
                  _loc3_++;
                  if(_loc3_ == this._repeatY || _loc2_ == _loc1_ - 1)
                  {
                     _loc6_ = 0;
                     _loc12_ = _loc16_ - (_loc3_ - 1) * this._lineGap;
                     _loc13_ = 1;
                     _loc3_ = _loc2_ - _loc3_ + 1;
                     while(_loc3_ <= _loc2_)
                     {
                        _loc4_ = getChildAt(_loc3_);
                        _loc4_.setXY(_loc5_,_loc6_);
                        _loc14_ = _loc4_.sourceHeight / _loc11_;
                        _loc4_.setSize(_loc4_.width,Math.round(_loc14_ / _loc13_ * _loc12_),true);
                        _loc12_ = _loc12_ - _loc4_.height;
                        _loc13_ = _loc13_ - _loc14_;
                        _loc6_ = _loc6_ + (_loc4_.height + this._lineGap);
                        if(_loc4_.width > _loc9_)
                        {
                           _loc9_ = _loc4_.width;
                        }
                        _loc3_++;
                     }
                     _loc5_ = _loc5_ + (Math.ceil(_loc9_) + this._columnGap);
                     _loc9_ = 0;
                     _loc3_ = 0;
                     _loc11_ = 0;
                  }
                  _loc2_++;
               }
               _loc7_ = _loc5_ + Math.ceil(_loc9_);
               _loc8_ = _loc16_;
            }
            else
            {
               _loc2_ = 0;
               while(_loc2_ < _loc1_)
               {
                  _loc4_ = getChildAt(_loc2_);
                  if(_loc6_ != 0)
                  {
                     _loc6_ = _loc6_ + this._lineGap;
                  }
                  if(this._repeatY != 0 && _loc3_ >= this._repeatY || this._repeatY == 0 && _loc6_ + _loc4_.height > _loc16_ && _loc9_ != 0)
                  {
                     _loc6_ = 0;
                     _loc5_ = _loc5_ + (Math.ceil(_loc9_) + this._columnGap);
                     _loc9_ = 0;
                     _loc3_ = 0;
                  }
                  _loc4_.setXY(_loc5_,_loc6_);
                  _loc6_ = _loc6_ + _loc4_.height;
                  if(_loc6_ > _loc10_)
                  {
                     _loc10_ = _loc6_;
                  }
                  if(_loc4_.width > _loc9_)
                  {
                     _loc9_ = _loc4_.width;
                  }
                  _loc3_++;
                  _loc2_++;
               }
               _loc7_ = _loc5_ + Math.ceil(_loc9_);
               _loc8_ = Math.ceil(_loc10_);
            }
         }
         else
         {
            _loc3_ = 0;
            _loc19_ = 0;
            _loc20_ = 0;
            if(this._autoResizeItem2 && this._repeatY > 0)
            {
               _loc21_ = (_loc16_ - (this._repeatY - 1) * this._lineGap) / this._repeatY;
            }
            if(this._autoResizeItem2 && this._repeatX > 0)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc1_)
               {
                  _loc4_ = getChildAt(_loc2_);
                  if(_loc3_ == 0 && (this._repeatY != 0 && _loc19_ >= this._repeatY || this._repeatY == 0 && _loc6_ + (this._repeatY > 0?_loc21_:_loc4_.height) > _loc16_))
                  {
                     _loc20_++;
                     _loc6_ = 0;
                     _loc19_ = 0;
                  }
                  _loc11_ = _loc11_ + _loc4_.sourceWidth;
                  _loc3_++;
                  if(_loc3_ == this._repeatX || _loc2_ == _loc1_ - 1)
                  {
                     _loc5_ = 0;
                     _loc12_ = _loc15_ - (_loc3_ - 1) * this._columnGap;
                     _loc13_ = 1;
                     _loc3_ = _loc2_ - _loc3_ + 1;
                     while(_loc3_ <= _loc2_)
                     {
                        _loc4_ = getChildAt(_loc3_);
                        _loc4_.setXY(_loc20_ * _loc15_ + _loc5_,_loc6_);
                        _loc14_ = _loc4_.sourceWidth / _loc11_;
                        _loc4_.setSize(Math.round(_loc14_ / _loc13_ * _loc12_),this._repeatY > 0?Number(_loc21_):Number(_loc4_.height),true);
                        _loc12_ = _loc12_ - _loc4_.width;
                        _loc13_ = _loc13_ - _loc14_;
                        _loc5_ = _loc5_ + (_loc4_.width + this._columnGap);
                        if(_loc4_.height > _loc10_)
                        {
                           _loc10_ = _loc4_.height;
                        }
                        _loc3_++;
                     }
                     _loc6_ = _loc6_ + (Math.ceil(_loc10_) + this._lineGap);
                     _loc10_ = 0;
                     _loc3_ = 0;
                     _loc11_ = 0;
                     _loc19_++;
                  }
                  _loc2_++;
               }
            }
            else
            {
               _loc2_ = 0;
               while(_loc2_ < _loc1_)
               {
                  _loc4_ = getChildAt(_loc2_);
                  if(_loc3_ != 0)
                  {
                     _loc5_ = _loc5_ + this._columnGap;
                  }
                  if(this._repeatX != 0 && _loc3_ >= this._repeatX || this._repeatX == 0 && _loc5_ + _loc4_.width > _loc15_ && _loc10_ != 0)
                  {
                     _loc5_ = 0;
                     _loc6_ = _loc6_ + (Math.ceil(_loc10_) + this._lineGap);
                     _loc10_ = 0;
                     _loc3_ = 0;
                     _loc19_++;
                     if(this._repeatY != 0 && _loc19_ >= this._repeatY || this._repeatY == 0 && _loc6_ + _loc4_.height > _loc16_ && _loc9_ != 0)
                     {
                        _loc20_++;
                        _loc6_ = 0;
                        _loc19_ = 0;
                     }
                  }
                  _loc4_.setXY(_loc20_ * _loc15_ + _loc5_,_loc6_);
                  _loc5_ = _loc5_ + Math.ceil(_loc4_.width);
                  if(_loc5_ > _loc9_)
                  {
                     _loc9_ = _loc5_;
                  }
                  if(_loc4_.height > _loc10_)
                  {
                     _loc10_ = _loc4_.height;
                  }
                  _loc3_++;
                  _loc2_++;
               }
            }
            _loc8_ = _loc20_ > 0?int(_loc16_):int(_loc6_ + Math.ceil(_loc10_));
            _loc7_ = (_loc20_ + 1) * _loc15_;
         }
         setBounds(0,0,_loc7_,_loc8_);
         var _loc17_:Number = _alignOffset.x;
         var _loc18_:Number = _alignOffset.y;
         _alignOffset.x = 0;
         _alignOffset.y = 0;
         if(_loc8_ < _loc16_)
         {
            if(this._verticalAlign == "middle")
            {
               _alignOffset.y = int((_loc16_ - _loc8_) / 2);
            }
            else if(this._verticalAlign == "bottom")
            {
               _alignOffset.y = _loc16_ - _loc8_;
            }
         }
         if(_loc7_ < _loc15_)
         {
            if(this._align == "center")
            {
               _alignOffset.x = int((_loc15_ - _loc7_) / 2);
            }
            else if(this._align == "right")
            {
               _alignOffset.x = _loc15_ - _loc7_;
            }
         }
         if(_alignOffset.x != _loc17_ || _alignOffset.y != _loc18_)
         {
            updateOverflow();
         }
      }
      
      override public function read_beforeAdd(param1:XData, param2:Object) : void
      {
         var _loc3_:String = null;
         var _loc6_:XData = null;
         var _loc7_:String = null;
         var _loc8_:ListItemData = null;
         var _loc9_:XDataEnumerator = null;
         var _loc10_:* = undefined;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc13_:XData = null;
         var _loc14_:ComProperty = null;
         super.read_beforeAdd(param1,param2);
         this._layout = param1.getAttribute("layout",SINGLE_COLUMN);
         this._selectionMode = param1.getAttribute("selectionMode","single");
         _loc3_ = param1.getAttribute("margin");
         if(_loc3_)
         {
            _margin.parse(_loc3_);
         }
         _loc3_ = param1.getAttribute("clipSoftness");
         if(_loc3_)
         {
            _loc11_ = _loc3_.split(",");
            _clipSoftnessX = int(_loc11_[0]);
            _clipSoftnessY = int(_loc11_[1]);
         }
         _overflow = param1.getAttribute("overflow",OverflowConst.VISIBLE);
         _scroll = param1.getAttribute("scroll",ScrollConst.VERTICAL);
         _scrollBarFlags = param1.getAttributeInt("scrollBarFlags");
         _scrollBarDisplay = param1.getAttribute("scrollBar",ScrollBarDisplayConst.DEFAULT);
         _loc3_ = param1.getAttribute("scrollBarMargin");
         if(_loc3_)
         {
            _scrollBarMargin.parse(_loc3_);
         }
         _loc3_ = param1.getAttribute("scrollBarRes");
         if(_loc3_)
         {
            _loc11_ = _loc3_.split(",");
            _vtScrollBarRes = _loc11_[0];
            _hzScrollBarRes = _loc11_[1];
         }
         _loc3_ = param1.getAttribute("ptrRes");
         if(_loc3_)
         {
            _loc11_ = _loc3_.split(",");
            _headerRes = _loc11_[0];
            _footerRes = _loc11_[1];
         }
         this._lineGap = param1.getAttributeInt("lineGap");
         this._columnGap = param1.getAttributeInt("colGap");
         this._repeatX = this._repeatY = 0;
         _loc3_ = param1.getAttribute("lineItemCount");
         if(_loc3_)
         {
            if(this._layout == FLOW_HZ || this._layout == PAGINATION)
            {
               this._repeatX = parseInt(_loc3_);
            }
            else if(this._layout == FLOW_VT)
            {
               this._repeatY = parseInt(_loc3_);
            }
         }
         this._repeatY = param1.getAttributeInt("lineItemCount2",this._repeatY);
         this._defaultItem = param1.getAttribute("defaultItem");
         if(this._layout == SINGLE_ROW || this._layout == SINGLE_COLUMN)
         {
            this._autoResizeItem1 = param1.getAttributeBool("autoItemSize",true);
         }
         else
         {
            this._autoResizeItem2 = param1.getAttributeBool("autoItemSize",false);
         }
         this._align = param1.getAttribute("align","left");
         this._verticalAlign = param1.getAttribute("vAlign","top");
         updateOverflow();
         _childrenRenderOrder = param1.getAttribute("renderOrder","ascent");
         if(_childrenRenderOrder == "arch")
         {
            _apexIndex = param1.getAttributeInt("apex");
         }
         this.clearOnPublish = param1.getAttributeBool("autoClearItems");
         this.scrollItemToViewOnClick = param1.getAttributeBool("scrollItemToViewOnClick",true);
         this.foldInvisibleItems = param1.getAttributeBool("foldInvisibleItems");
         this._treeViewEnabled = param1.getAttributeBool("treeView");
         this._indent = param1.getAttributeInt("indent",15);
         this.clickToExpand = param1.getAttributeInt("clickToExpand");
         var _loc4_:XDataEnumerator = param1.getEnumerator("item");
         this._items.length = 0;
         var _loc5_:int = 0;
         while(_loc4_.moveNext())
         {
            _loc6_ = _loc4_.current;
            _loc7_ = _loc6_.getAttribute("url");
            if(!_loc7_)
            {
               _loc7_ = this._defaultItem;
            }
            _loc8_ = new ListItemData();
            _loc8_.url = _loc7_;
            _loc8_.title = _loc6_.getAttribute("title","");
            _loc8_.icon = _loc6_.getAttribute("icon","");
            _loc8_.name = _loc6_.getAttribute("name","");
            _loc8_.selectedIcon = _loc6_.getAttribute("selectedIcon","");
            _loc8_.selectedTitle = _loc6_.getAttribute("selectedTitle","");
            if(param2)
            {
               _loc10_ = param2[_id + "-" + _loc5_];
               if(_loc10_ != undefined)
               {
                  _loc8_.title = _loc10_;
               }
               _loc10_ = param2[_id + "-" + _loc5_ + "-0"];
               if(_loc10_ != undefined)
               {
                  _loc8_.selectedTitle = _loc10_;
               }
            }
            if(this._treeViewEnabled)
            {
               _loc8_.level = _loc6_.getAttributeInt("level",0);
            }
            _loc3_ = _loc6_.getAttribute("controllers");
            if(_loc3_)
            {
               _loc11_ = _loc3_.split(",");
               _loc12_ = _loc11_.length;
               _loc5_ = 0;
               while(_loc5_ < _loc12_)
               {
                  _loc8_.properties.push(new ComProperty(_loc11_[_loc5_],-1,null,_loc11_[_loc5_ + 1]));
                  _loc5_ = _loc5_ + 2;
               }
            }
            _loc9_ = _loc6_.getEnumerator("property");
            while(_loc9_.moveNext())
            {
               _loc13_ = _loc9_.current;
               _loc14_ = new ComProperty(_loc13_.getAttribute("target"),_loc13_.getAttributeInt("propertyId"),null,_loc13_.getAttribute("value"));
               if(param2 && _loc14_.propertyId == 0)
               {
                  _loc10_ = param2[_id + "-" + _loc5_ + "-" + _loc14_.target];
                  if(_loc10_ != undefined)
                  {
                     _loc14_.value = _loc10_;
                  }
               }
               _loc8_.properties.push(_loc14_);
            }
            this.items.push(_loc8_);
            _loc5_++;
         }
         this.buildItems();
      }
      
      override public function read_afterAdd(param1:XData, param2:Object) : void
      {
         super.read_afterAdd(param1,param2);
         var _loc3_:String = param1.getAttribute("selectionController");
         if(_loc3_)
         {
            this._selectionController = _parent.getController(_loc3_);
         }
         else
         {
            this._selectionController = null;
         }
      }
      
      override public function write() : XData
      {
         var _loc2_:ListItemData = null;
         var _loc3_:XData = null;
         var _loc4_:Vector.<ComProperty> = null;
         var _loc5_:* = null;
         var _loc6_:ComProperty = null;
         var _loc7_:XData = null;
         var _loc1_:XData = super.write();
         if(this._layout != SINGLE_COLUMN)
         {
            _loc1_.setAttribute("layout",this._layout);
         }
         if(this._selectionMode != "single")
         {
            _loc1_.setAttribute("selectionMode",this._selectionMode);
         }
         if(_overflow != OverflowConst.VISIBLE)
         {
            _loc1_.setAttribute("overflow",_overflow);
         }
         if(_scroll != ScrollConst.VERTICAL)
         {
            _loc1_.setAttribute("scroll",_scroll);
         }
         if(_overflow == OverflowConst.SCROLL)
         {
            if(_scrollBarFlags)
            {
               _loc1_.setAttribute("scrollBarFlags",_scrollBarFlags);
            }
            if(_scrollBarDisplay != ScrollBarDisplayConst.DEFAULT)
            {
               _loc1_.setAttribute("scrollBar",_scrollBarDisplay);
            }
         }
         if(!_margin.empty)
         {
            _loc1_.setAttribute("margin",_margin);
         }
         if(!_scrollBarMargin.empty)
         {
            _loc1_.setAttribute("scrollBarMargin",_scrollBarMargin.toString());
         }
         if(_vtScrollBarRes || _hzScrollBarRes)
         {
            _loc1_.setAttribute("scrollBarRes",(!!_vtScrollBarRes?_vtScrollBarRes:"") + "," + (!!_hzScrollBarRes?_hzScrollBarRes:""));
         }
         if(_headerRes || _footerRes)
         {
            _loc1_.setAttribute("ptrRes",(!!_headerRes?_headerRes:"") + "," + (!!_footerRes?_footerRes:""));
         }
         if(_clipSoftnessX != 0 || _clipSoftnessY != 0)
         {
            _loc1_.setAttribute("clipSoftness",_clipSoftnessX + "," + _clipSoftnessY);
         }
         if(this._lineGap != 0)
         {
            _loc1_.setAttribute("lineGap",this._lineGap);
         }
         if(this._columnGap != 0)
         {
            _loc1_.setAttribute("colGap",this._columnGap);
         }
         if(this._layout == FLOW_HZ)
         {
            if(this._repeatX != 0)
            {
               _loc1_.setAttribute("lineItemCount",this._repeatX);
            }
         }
         else if(this._layout == FLOW_VT)
         {
            if(this._repeatY != 0)
            {
               _loc1_.setAttribute("lineItemCount",this._repeatY);
            }
         }
         else if(this._layout == PAGINATION)
         {
            if(this._repeatX != 0)
            {
               _loc1_.setAttribute("lineItemCount",this._repeatX);
            }
            if(this._repeatY != 0)
            {
               _loc1_.setAttribute("lineItemCount2",this._repeatY);
            }
         }
         if(this._defaultItem)
         {
            _loc1_.setAttribute("defaultItem",this._defaultItem);
         }
         if(this._layout == SINGLE_ROW || this._layout == SINGLE_COLUMN)
         {
            if(!this._autoResizeItem1)
            {
               _loc1_.setAttribute("autoItemSize",false);
            }
         }
         else if(this._autoResizeItem2)
         {
            _loc1_.setAttribute("autoItemSize",true);
         }
         if(this._align != "left")
         {
            _loc1_.setAttribute("align",this._align);
         }
         if(this._verticalAlign != "top")
         {
            _loc1_.setAttribute("vAlign",this._verticalAlign);
         }
         if(_childrenRenderOrder != "ascent")
         {
            _loc1_.setAttribute("renderOrder",_childrenRenderOrder);
            if(_childrenRenderOrder == "arch" && _apexIndex != 0)
            {
               _loc1_.setAttribute("apex",_apexIndex);
            }
         }
         if(this._selectionController && this._selectionController.parent)
         {
            _loc1_.setAttribute("selectionController",this._selectionController.name);
         }
         if(this.clearOnPublish)
         {
            _loc1_.setAttribute("autoClearItems",this.clearOnPublish);
         }
         if(!this.scrollItemToViewOnClick)
         {
            _loc1_.setAttribute("scrollItemToViewOnClick",this.scrollItemToViewOnClick);
         }
         if(this.foldInvisibleItems)
         {
            _loc1_.setAttribute("foldInvisibleItems",this.foldInvisibleItems);
         }
         if(this._treeViewEnabled)
         {
            _loc1_.setAttribute("treeView",this._treeViewEnabled);
            _loc1_.setAttribute("indent",this._indent);
            _loc1_.setAttribute("clickToExpand",this.clickToExpand);
         }
         if(this._items.length)
         {
            for each(_loc2_ in this._items)
            {
               _loc3_ = XData.create("item");
               if(_loc2_.url && _loc2_.url != this._defaultItem)
               {
                  _loc3_.setAttribute("url",_loc2_.url);
               }
               if(_loc2_.title)
               {
                  _loc3_.setAttribute("title",_loc2_.title);
               }
               if(_loc2_.icon)
               {
                  _loc3_.setAttribute("icon",_loc2_.icon);
               }
               if(_loc2_.name)
               {
                  _loc3_.setAttribute("name",_loc2_.name);
               }
               if(_loc2_.selectedIcon)
               {
                  _loc3_.setAttribute("selectedIcon",_loc2_.selectedIcon);
               }
               if(_loc2_.selectedTitle)
               {
                  _loc3_.setAttribute("selectedTitle",_loc2_.selectedTitle);
               }
               _loc4_ = _loc2_.properties;
               if(_loc4_.length)
               {
                  _loc5_ = null;
                  for each(_loc6_ in _loc4_)
                  {
                     if(_loc6_.value != undefined)
                     {
                        if(_loc6_.propertyId == -1)
                        {
                           if(_loc5_ == null)
                           {
                              _loc5_ = "";
                           }
                           else
                           {
                              _loc5_ = _loc5_ + ",";
                           }
                           _loc5_ = _loc5_ + (_loc6_.target + "," + _loc6_.value);
                        }
                        else
                        {
                           _loc7_ = XData.create("property");
                           _loc7_.setAttribute("target",_loc6_.target);
                           _loc7_.setAttribute("propertyId",_loc6_.propertyId);
                           _loc7_.setAttribute("value",_loc6_.value);
                           _loc3_.appendChild(_loc7_);
                        }
                     }
                  }
                  if(_loc5_ != null)
                  {
                     _loc3_.setAttribute("controllers",_loc5_);
                  }
               }
               if(this._treeViewEnabled)
               {
                  _loc3_.setAttribute("level",_loc2_.level);
               }
               _loc1_.appendChild(_loc3_);
            }
         }
         return _loc1_;
      }
   }
}
