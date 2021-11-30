package fairygui.editor.gui
{
   import fairygui.GRoot;
   import fairygui.Margin;
   import flash.events.Event;
   
   public class EGList extends EGComponent
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
      
      private var _items:Array;
      
      private var _defaultItem:String;
      
      private var _clipSharpness:Margin;
      
      private var _autoResizeItem1:Boolean;
      
      private var _autoResizeItem2:Boolean;
      
      private var _repeatX:int;
      
      private var _repeatY:int;
      
      private var _align:String;
      
      private var _verticalAlign:String;
      
      private var _lastSelectedIndex:int;
      
      private var _selectionController:EController;
      
      private var _selectionControllerFlag:Boolean;
      
      public function EGList()
      {
         super();
         this._items = [];
         this._layout = "column";
         this._selectionMode = "single";
         this._autoResizeItem1 = true;
         this._autoResizeItem2 = false;
         this._align = "left";
         this._verticalAlign = "top";
         this._lastSelectedIndex = -1;
         this.objectType = "list";
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
            this._repeatX = param1;
            setBoundsChangedFlag();
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
            this._repeatY = param1;
            setBoundsChangedFlag();
         }
      }
      
      public function get defaultItem() : String
      {
         return this._defaultItem;
      }
      
      public function set defaultItem(param1:String) : void
      {
         var _loc4_:String = null;
         var _loc2_:Boolean = false;
         var _loc3_:Object = null;
         if(param1)
         {
            _loc4_ = this._defaultItem;
            this._defaultItem = param1;
            _loc2_ = false;
            var _loc6_:int = 0;
            var _loc5_:* = this._items;
            for each(_loc3_ in this._items)
            {
               if(_loc3_[0] == _loc4_)
               {
                  _loc3_[0] = param1;
                  _loc2_ = true;
               }
            }
            if(_loc2_)
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
         if(this._layout == "column" || this._layout == "row")
         {
            return this._autoResizeItem1;
         }
         return this._autoResizeItem2;
      }
      
      public function set autoResizeItem(param1:Boolean) : void
      {
         if(this._layout == "column" || this._layout == "row")
         {
            if(this._autoResizeItem1 != param1)
            {
               this._autoResizeItem1 = param1;
               setBoundsChangedFlag();
            }
         }
         else if(this._autoResizeItem2 != param1)
         {
            this._autoResizeItem2 = param1;
            setBoundsChangedFlag();
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
            setBoundsChangedFlag();
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
            setBoundsChangedFlag();
         }
      }
      
      public function get items() : Array
      {
         return this._items;
      }
      
      public function set items(param1:Array) : void
      {
         this._items = param1;
         this.buildItems();
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
         var _loc2_:EController = null;
         if(param1)
         {
            _loc2_ = parent.getController(param1);
         }
         this._selectionController = _loc2_;
      }
      
      public function get selectionControllerObj() : EController
      {
         return this._selectionController;
      }
      
      public function setSelection(param1:int) : void
      {
         if(this._selectionMode == "none")
         {
            return;
         }
         this.clearSelection();
         if(param1 < 0 || param1 >= numChildren)
         {
            return;
         }
         var _loc2_:EGObject = getChildAt(param1);
         if(_loc2_ is EGComponent && EGComponent(_loc2_).extention is EGButton)
         {
            EGButton(EGComponent(_loc2_).extention).selected = true;
         }
      }
      
      public function clearSelection() : void
      {
         var _loc1_:EGObject = null;
         var _loc3_:int = this.numChildren;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = getChildAt(_loc2_);
            if(_loc1_ is EGComponent && EGComponent(_loc1_).extention is EGButton)
            {
               EGButton(EGComponent(_loc1_).extention).selected = false;
            }
            _loc2_++;
         }
      }
      
      public function addItem(param1:String) : EGObject
      {
         return this.addItemAt(param1,numChildren);
      }
      
      public function addItemAt(param1:String, param2:int) : EGObject
      {
         var _loc3_:EGButton = null;
         var _loc4_:EPackageItem = pkg.project.getItemByURL(param1);
         if(_loc4_ == null)
         {
            return null;
         }
         var _loc5_:EGObject = EUIObjectFactory.createObject(_loc4_,editMode == 1?1:0);
         if(_loc5_ is EGComponent)
         {
            _loc3_ = EGComponent(_loc5_).extention as EGButton;
            if(_loc3_ != null)
            {
               _loc3_.changeStageOnClick = false;
            }
            _loc5_.addEventListener("clickGTouch",this.__clickItem);
         }
         return addChildAt(_loc5_,param2);
      }
      
      private function __clickItem(param1:Event) : void
      {
         var _loc2_:EGObject = EGObject(param1.currentTarget);
         this.setSelectionOnEvent(_loc2_);
         if(scrollPane != null)
         {
            scrollPane.scrollToView(_loc2_,true);
         }
         this.dispatchEvent(new EItemEvent("___itemClick",_loc2_));
      }
      
      private function setSelectionOnEvent(param1:EGObject) : void
      {
         var _loc2_:GRoot = null;
         var _loc4_:int = 0;
         var _loc7_:int = 0;
         var _loc6_:* = 0;
         var _loc5_:EGComponent = null;
         var _loc3_:EGButton = null;
         if(!(param1 is EGComponent) || !(EGComponent(param1).extention is EGButton) || this._selectionMode == "none")
         {
            return;
         }
         var _loc10_:Boolean = false;
         var _loc8_:EGButton = EGComponent(param1).extention as EGButton;
         var _loc9_:int = getChildIndex(param1);
         if(this._selectionMode == "single")
         {
            if(!_loc8_.selected)
            {
               this.clearSelectionExcept(param1);
               _loc8_.selected = true;
            }
         }
         else
         {
            _loc2_ = pkg.project.editorWindow.groot;
            if(_loc2_.shiftKeyDown)
            {
               if(!_loc8_.selected)
               {
                  if(this._lastSelectedIndex != -1)
                  {
                     _loc4_ = Math.min(this._lastSelectedIndex,_loc9_);
                     _loc7_ = Math.max(this._lastSelectedIndex,_loc9_);
                     _loc7_ = Math.min(_loc7_,numChildren - 1);
                     _loc6_ = _loc4_;
                     while(_loc6_ <= _loc7_)
                     {
                        _loc5_ = getChildAt(_loc6_) as EGComponent;
                        if(_loc5_ != null)
                        {
                           _loc3_ = _loc5_.extention as EGButton;
                           if(_loc3_ != null && !_loc3_.selected)
                           {
                              _loc3_.selected = true;
                           }
                        }
                        _loc6_++;
                     }
                     _loc10_ = true;
                  }
                  else
                  {
                     _loc8_.selected = true;
                  }
               }
            }
            else if(_loc2_.ctrlKeyDown || this._selectionMode == "multipleSingleClick")
            {
               _loc8_.selected = !_loc8_.selected;
            }
            else if(!_loc8_.selected)
            {
               this.clearSelectionExcept(param1);
               _loc8_.selected = true;
            }
            else
            {
               this.clearSelectionExcept(param1);
            }
         }
         if(!_loc10_)
         {
            this._lastSelectedIndex = _loc9_;
         }
         if(_loc8_.selected)
         {
            this.updateSelectionController(_loc9_);
         }
      }
      
      private function clearSelectionExcept(param1:EGObject) : void
      {
         var _loc4_:EGComponent = null;
         var _loc2_:EGButton = null;
         var _loc5_:int = numChildren;
         var _loc3_:int = 0;
         while(_loc3_ < _loc5_)
         {
            _loc4_ = getChildAt(_loc3_) as EGComponent;
            if(_loc4_ != null)
            {
               _loc2_ = _loc4_.extention as EGButton;
               if(_loc2_ != null && _loc4_ != param1 && _loc2_.selected)
               {
                  _loc2_.selected = false;
               }
            }
            _loc3_++;
         }
      }
      
      public function resizeToFit(param1:int = 2147483647, param2:int = 0) : void
      {
         var _loc6_:int = 0;
         var _loc3_:EGObject = null;
         var _loc4_:* = 0;
         ensureBoundsCorrect();
         var _loc5_:int = this.numChildren;
         if(param1 > _loc5_)
         {
            param1 = _loc5_;
         }
         if(param1 == 0)
         {
            if(this._layout == "column" || this._layout == "flow_hz")
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
            _loc6_ = param1 - 1;
            _loc3_ = null;
            while(_loc6_ >= 0)
            {
               _loc3_ = this.getChildAt(_loc6_);
               if(!_loc3_.visible)
               {
                  _loc6_--;
                  continue;
               }
               break;
            }
            if(_loc6_ < 0)
            {
               if(this._layout == "column" || this._layout == "flow_hz")
               {
                  this.viewHeight = param2;
               }
               else
               {
                  this.viewWidth = param2;
               }
            }
            else if(this._layout == "column" || this._layout == "flow_hz")
            {
               _loc4_ = int(_loc3_.y + _loc3_.height);
               if(_loc4_ < param2)
               {
                  _loc4_ = param2;
               }
               this.viewHeight = _loc4_;
            }
            else
            {
               _loc4_ = int(_loc3_.x + _loc3_.width);
               if(_loc4_ < param2)
               {
                  _loc4_ = param2;
               }
               this.viewWidth = _loc4_;
            }
         }
      }
      
      override protected function handleSizeChanged() : void
      {
         super.handleSizeChanged();
         setBoundsChangedFlag();
      }
      
      override public function handleControllerChanged(param1:EController) : void
      {
         super.handleControllerChanged(param1);
         if(this._selectionController == param1 && !this._selectionControllerFlag)
         {
            this._selectionControllerFlag = true;
            this.setSelection(this._selectionController.selectedIndex);
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
         var _loc1_:Array = null;
         var _loc2_:EGObject = null;
         var _loc4_:int = this._items.length;
         this.removeChildren();
         var _loc3_:int = 0;
         while(_loc3_ < _loc4_)
         {
            _loc1_ = this._items[_loc3_];
            _loc2_ = this.addItem(_loc1_[0]);
            if(_loc2_ is EGComponent && EGComponent(_loc2_).extention)
            {
               if(EGComponent(_loc2_).extention is EGButton)
               {
                  if(_loc1_[1])
                  {
                     EGButton(EGComponent(_loc2_).extention).title = _loc1_[1];
                  }
                  if(_loc1_[2])
                  {
                     EGButton(EGComponent(_loc2_).extention).icon = _loc1_[2];
                  }
               }
               else if(EGComponent(_loc2_).extention is EGLabel)
               {
                  if(_loc1_[1])
                  {
                     EGLabel(EGComponent(_loc2_).extention).title = _loc1_[1];
                  }
                  if(_loc1_[2])
                  {
                     EGLabel(EGComponent(_loc2_).extention).icon = _loc1_[2];
                  }
               }
            }
            _loc3_++;
         }
      }
      
      override protected function updateBounds() : void
      {
         var _loc10_:int = 0;
         var _loc7_:int = 0;
         var _loc9_:EGObject = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc18_:* = 0;
         var _loc16_:* = 0;
         var _loc17_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:Number = NaN;
         var _loc8_:int = 0;
         var _loc6_:int = 0;
         var _loc19_:int = 0;
         var _loc12_:int = numChildren;
         var _loc4_:* = 0;
         var _loc5_:int = this.viewWidth;
         var _loc1_:int = this.viewHeight;
         if(this._layout == "column")
         {
            _loc10_ = 0;
            while(_loc10_ < _loc12_)
            {
               _loc9_ = getChildAt(_loc10_);
               if(_loc10_ != 0)
               {
                  _loc15_ = _loc15_ + this._lineGap;
               }
               _loc9_.setXY(0,_loc15_);
               if(this._autoResizeItem1)
               {
                  _loc9_.setSize(_loc5_,_loc9_.height,true);
               }
               else
               {
                  _loc9_.setSize(_loc9_.sourceWidth,_loc9_.height,true);
               }
               _loc15_ = _loc15_ + Math.ceil(_loc9_.height);
               if(_loc9_.width > _loc17_)
               {
                  _loc17_ = int(_loc9_.width);
               }
               _loc10_++;
            }
            _loc18_ = int(Math.ceil(_loc17_));
            _loc16_ = _loc15_;
         }
         else if(this._layout == "row")
         {
            _loc10_ = 0;
            while(_loc10_ < _loc12_)
            {
               _loc9_ = getChildAt(_loc10_);
               if(_loc10_ != 0)
               {
                  _loc14_ = _loc14_ + this._columnGap;
               }
               _loc9_.setXY(_loc14_,0);
               if(this._autoResizeItem1)
               {
                  _loc9_.setSize(_loc9_.width,_loc1_,true);
               }
               else
               {
                  _loc9_.setSize(_loc9_.width,_loc9_.sourceHeight,true);
               }
               _loc14_ = _loc14_ + Math.ceil(_loc9_.width);
               if(_loc9_.height > _loc2_)
               {
                  _loc2_ = int(_loc9_.height);
               }
               _loc10_++;
            }
            _loc18_ = _loc14_;
            _loc16_ = int(Math.ceil(_loc2_));
         }
         else if(this._layout == "flow_hz")
         {
            _loc7_ = 0;
            if(this._autoResizeItem2 && this._repeatX > 0)
            {
               _loc10_ = 0;
               while(_loc10_ < _loc12_)
               {
                  _loc9_ = getChildAt(_loc10_);
                  _loc4_ = Number(_loc4_ + _loc9_.sourceWidth);
                  _loc7_++;
                  if(_loc7_ == this._repeatX || _loc10_ == _loc12_ - 1)
                  {
                     _loc3_ = (_loc5_ - _loc4_ - (_loc7_ - 1) * this._columnGap) / _loc4_;
                     _loc14_ = 0;
                     _loc7_ = _loc10_ - _loc7_ + 1;
                     while(_loc7_ <= _loc10_)
                     {
                        _loc9_ = getChildAt(_loc7_);
                        _loc9_.setXY(_loc14_,_loc15_);
                        if(_loc7_ < _loc10_)
                        {
                           _loc9_.setSize(_loc9_.sourceWidth + Math.round(_loc9_.sourceWidth * _loc3_),_loc9_.height,true);
                           _loc14_ = _loc14_ + (Math.ceil(_loc9_.width) + this._columnGap);
                        }
                        else
                        {
                           _loc9_.setSize(_loc5_ - _loc14_,_loc9_.height,true);
                        }
                        if(_loc9_.height > _loc2_)
                        {
                           _loc2_ = int(_loc9_.height);
                        }
                        _loc7_++;
                     }
                     _loc15_ = _loc15_ + (Math.ceil(_loc2_) + this._lineGap);
                     _loc2_ = 0;
                     _loc7_ = 0;
                     _loc4_ = 0;
                  }
                  _loc10_++;
               }
               _loc16_ = int(_loc15_ + Math.ceil(_loc2_));
               _loc18_ = _loc5_;
            }
            else
            {
               _loc10_ = 0;
               while(_loc10_ < _loc12_)
               {
                  _loc9_ = getChildAt(_loc10_);
                  if(_loc14_ != 0)
                  {
                     _loc14_ = _loc14_ + this._columnGap;
                  }
                  _loc9_.setSize(_loc9_.sourceWidth,_loc9_.height,true);
                  if(this._repeatX != 0 && _loc7_ >= this._repeatX || this._repeatX == 0 && _loc14_ + _loc9_.width > _loc5_ && _loc2_ != 0)
                  {
                     _loc14_ = 0;
                     _loc15_ = _loc15_ + (Math.ceil(_loc2_) + this._lineGap);
                     _loc2_ = 0;
                     _loc7_ = 0;
                  }
                  _loc9_.setXY(_loc14_,_loc15_);
                  _loc14_ = _loc14_ + Math.ceil(_loc9_.width);
                  if(_loc14_ > _loc17_)
                  {
                     _loc17_ = _loc14_;
                  }
                  if(_loc9_.height > _loc2_)
                  {
                     _loc2_ = int(_loc9_.height);
                  }
                  _loc7_++;
                  _loc10_++;
               }
               _loc16_ = int(_loc15_ + Math.ceil(_loc2_));
               _loc18_ = int(Math.ceil(_loc17_));
            }
         }
         else if(this._layout == "flow_vt")
         {
            _loc7_ = 0;
            if(this._autoResizeItem2 && this._repeatY > 0)
            {
               _loc10_ = 0;
               while(_loc10_ < _loc12_)
               {
                  _loc9_ = getChildAt(_loc10_);
                  _loc4_ = Number(_loc4_ + _loc9_.sourceHeight);
                  _loc7_++;
                  if(_loc7_ == this._repeatY || _loc10_ == _loc12_ - 1)
                  {
                     _loc3_ = (_loc1_ - _loc4_ - (_loc7_ - 1) * this._lineGap) / _loc4_;
                     _loc15_ = 0;
                     _loc7_ = _loc10_ - _loc7_ + 1;
                     while(_loc7_ <= _loc10_)
                     {
                        _loc9_ = getChildAt(_loc7_);
                        _loc9_.setXY(_loc14_,_loc15_);
                        if(_loc7_ < _loc10_)
                        {
                           _loc9_.setSize(_loc9_.width,_loc9_.sourceHeight + Math.round(_loc9_.sourceHeight * _loc3_),true);
                           _loc15_ = _loc15_ + (Math.ceil(_loc9_.height) + this._lineGap);
                        }
                        else
                        {
                           _loc9_.setSize(_loc9_.width,_loc1_ - _loc15_,true);
                        }
                        if(_loc9_.width > _loc17_)
                        {
                           _loc17_ = int(_loc9_.width);
                        }
                        _loc7_++;
                     }
                     _loc14_ = _loc14_ + (Math.ceil(_loc17_) + this._columnGap);
                     _loc17_ = 0;
                     _loc7_ = 0;
                     _loc4_ = 0;
                  }
                  _loc10_++;
               }
               _loc18_ = int(_loc14_ + Math.ceil(_loc17_));
               _loc16_ = _loc1_;
            }
            else
            {
               _loc10_ = 0;
               while(_loc10_ < _loc12_)
               {
                  _loc9_ = getChildAt(_loc10_);
                  if(_loc15_ != 0)
                  {
                     _loc15_ = _loc15_ + this._lineGap;
                  }
                  _loc9_.setSize(_loc9_.width,_loc9_.sourceHeight,true);
                  if(this._repeatY != 0 && _loc7_ >= this._repeatY || this._repeatY == 0 && _loc15_ + _loc9_.height > _loc1_ && _loc17_ != 0)
                  {
                     _loc15_ = 0;
                     _loc14_ = _loc14_ + (Math.ceil(_loc17_) + this._columnGap);
                     _loc17_ = 0;
                     _loc7_ = 0;
                  }
                  _loc9_.setXY(_loc14_,_loc15_);
                  _loc15_ = _loc15_ + _loc9_.height;
                  if(_loc15_ > _loc2_)
                  {
                     _loc2_ = _loc15_;
                  }
                  if(_loc9_.width > _loc17_)
                  {
                     _loc17_ = int(_loc9_.width);
                  }
                  _loc7_++;
                  _loc10_++;
               }
               _loc18_ = int(_loc14_ + Math.ceil(_loc17_));
               _loc16_ = int(Math.ceil(_loc2_));
            }
         }
         else
         {
            _loc7_ = 0;
            _loc8_ = 0;
            _loc6_ = 0;
            if(this._autoResizeItem2 && this._repeatY > 0)
            {
               _loc19_ = (_loc1_ - (this._repeatY - 1) * this._lineGap) / this._repeatY;
            }
            if(this._autoResizeItem2 && this._repeatX > 0)
            {
               _loc10_ = 0;
               while(_loc10_ < _loc12_)
               {
                  _loc9_ = getChildAt(_loc10_);
                  _loc4_ = Number(_loc4_ + _loc9_.sourceWidth);
                  _loc7_++;
                  if(_loc7_ == this._repeatX || _loc10_ == _loc12_ - 1)
                  {
                     _loc3_ = (_loc5_ - _loc4_ - (_loc7_ - 1) * this._columnGap) / _loc4_;
                     _loc14_ = 0;
                     _loc7_ = _loc10_ - _loc7_ + 1;
                     while(_loc7_ <= _loc10_)
                     {
                        _loc9_ = getChildAt(_loc7_);
                        _loc9_.setXY(_loc6_ * _loc5_ + _loc14_,_loc15_);
                        if(_loc7_ < _loc10_)
                        {
                           _loc9_.setSize(_loc9_.sourceWidth + Math.round(_loc9_.sourceWidth * _loc3_),this._repeatY > 0?Number(_loc19_):Number(_loc9_.height),true);
                           _loc14_ = _loc14_ + (Math.ceil(_loc9_.width) + this._columnGap);
                        }
                        else
                        {
                           _loc9_.setSize(_loc5_ - _loc14_,this._repeatY > 0?Number(_loc19_):Number(_loc9_.height),true);
                        }
                        if(_loc9_.height > _loc2_)
                        {
                           _loc2_ = int(_loc9_.height);
                        }
                        _loc7_++;
                     }
                     _loc15_ = _loc15_ + (Math.ceil(_loc2_) + this._lineGap);
                     _loc2_ = 0;
                     _loc7_ = 0;
                     _loc4_ = 0;
                     _loc8_++;
                     if(this._repeatY != 0 && _loc8_ >= this._repeatY || this._repeatY == 0 && _loc15_ + _loc9_.height > _loc1_)
                     {
                        _loc6_++;
                        _loc15_ = 0;
                        _loc8_ = 0;
                     }
                  }
                  _loc10_++;
               }
            }
            else
            {
               _loc10_ = 0;
               while(_loc10_ < _loc12_)
               {
                  _loc9_ = getChildAt(_loc10_);
                  if(_loc7_ != 0)
                  {
                     _loc14_ = _loc14_ + this._columnGap;
                  }
                  _loc9_.setSize(_loc9_.sourceWidth,(this._autoResizeItem2 && this._repeatY) > 0?Number(_loc19_):Number(_loc9_.sourceHeight),true);
                  if(this._repeatX != 0 && _loc7_ >= this._repeatX || this._repeatX == 0 && _loc14_ + _loc9_.width > _loc5_ && _loc2_ != 0)
                  {
                     _loc14_ = 0;
                     _loc15_ = _loc15_ + (Math.ceil(_loc2_) + this._lineGap);
                     _loc2_ = 0;
                     _loc7_ = 0;
                     _loc8_++;
                     if(this._repeatY != 0 && _loc8_ >= this._repeatY || this._repeatY == 0 && _loc15_ + _loc9_.height > _loc1_ && _loc17_ != 0)
                     {
                        _loc6_++;
                        _loc15_ = 0;
                        _loc8_ = 0;
                     }
                  }
                  _loc9_.setXY(_loc6_ * _loc5_ + _loc14_,_loc15_);
                  _loc14_ = _loc14_ + Math.ceil(_loc9_.width);
                  if(_loc14_ > _loc17_)
                  {
                     _loc17_ = _loc14_;
                  }
                  if(_loc9_.height > _loc2_)
                  {
                     _loc2_ = int(_loc9_.height);
                  }
                  _loc7_++;
                  _loc10_++;
               }
            }
            _loc16_ = int(_loc6_ > 0?int(_loc1_):int(_loc15_ + Math.ceil(_loc2_)));
            _loc18_ = int((_loc6_ + 1) * _loc5_);
         }
         setBounds(0,0,_loc18_,_loc16_);
         var _loc11_:Number = alignOffset.x;
         var _loc13_:Number = alignOffset.y;
         alignOffset.x = 0;
         alignOffset.y = 0;
         if(_loc16_ < _loc1_)
         {
            if(this._verticalAlign == "middle")
            {
               alignOffset.y = int((_loc1_ - _loc16_) / 2);
            }
            else if(this._verticalAlign == "bottom")
            {
               alignOffset.y = _loc1_ - _loc16_;
            }
         }
         if(_loc18_ < _loc5_)
         {
            if(this._align == "center")
            {
               alignOffset.x = int((_loc5_ - _loc18_) / 2);
            }
            else if(this._align == "right")
            {
               alignOffset.x = _loc5_ - _loc18_;
            }
         }
         if(alignOffset.x != _loc11_ || alignOffset.y != _loc13_)
         {
            updateOverflow();
         }
      }
      
      override public function create() : void
      {
         super.create();
         if(editMode == 2)
         {
            _displayObject.setDashedRect(true,"List");
         }
      }
      
      override public function fromXML_beforeAdd(param1:XML) : void
      {
         var _loc6_:String = null;
         var _loc5_:Array = null;
         var _loc2_:XML = null;
         var _loc3_:String = null;
         super.fromXML_beforeAdd(param1);
         _loc6_ = param1.@layout;
         if(_loc6_)
         {
            this._layout = _loc6_;
         }
         else
         {
            this._layout = "column";
         }
         _loc6_ = param1.@selectionMode;
         if(_loc6_)
         {
            this._selectionMode = _loc6_;
         }
         else
         {
            this._selectionMode = "single";
         }
         _loc6_ = param1.@margin;
         if(_loc6_)
         {
            _margin.parse(_loc6_);
         }
         _loc6_ = param1.@clipSoftness;
         if(_loc6_)
         {
            _loc5_ = _loc6_.split(",");
            _clipSoftness.x = int(_loc5_[0]);
            _clipSoftness.y = int(_loc5_[1]);
         }
         _loc6_ = param1.@overflow;
         if(_loc6_)
         {
            _overflow = _loc6_;
         }
         else
         {
            _overflow = "visible";
         }
         _loc6_ = param1.@scroll;
         if(_loc6_)
         {
            _scroll = _loc6_;
         }
         else
         {
            _scroll = "vertical";
         }
         _scrollBarFlags = parseInt(param1.@scrollBarFlags);
         _loc6_ = param1.@scrollBar;
         if(_loc6_)
         {
            _scrollBarDisplay = _loc6_;
         }
         else
         {
            _scrollBarDisplay = "default";
         }
         _loc6_ = param1.@scrollBarMargin;
         if(_loc6_)
         {
            _scrollBarMargin.parse(_loc6_);
         }
         _loc6_ = param1.@scrollBarRes;
         if(_loc6_)
         {
            _loc5_ = _loc6_.split(",");
            _vtScrollBarRes = _loc5_[0];
            _hzScrollBarRes = _loc5_[1];
         }
         _loc6_ = param1.@ptrRes;
         if(_loc6_)
         {
            _loc5_ = _loc6_.split(",");
            _headerRes = _loc5_[0];
            _footerRes = _loc5_[1];
         }
         _loc6_ = param1.@lineGap;
         if(_loc6_)
         {
            this._lineGap = parseInt(_loc6_);
         }
         else
         {
            this._lineGap = 0;
         }
         _loc6_ = param1.@colGap;
         if(_loc6_)
         {
            this._columnGap = parseInt(_loc6_);
         }
         else
         {
            this._columnGap = 0;
         }
         var _loc7_:int = 0;
         this._repeatY = _loc7_;
         this._repeatX = _loc7_;
         _loc6_ = param1.@lineItemCount;
         if(_loc6_)
         {
            if(this._layout == "flow_hz" || this._layout == "pagination")
            {
               this._repeatX = parseInt(_loc6_);
            }
            else if(this._layout == "flow_vt")
            {
               this._repeatY = parseInt(_loc6_);
            }
         }
         _loc6_ = param1.@lineItemCount2;
         if(_loc6_)
         {
            this._repeatY = parseInt(_loc6_);
         }
         _loc6_ = param1.@defaultItem;
         if(_loc6_)
         {
            this._defaultItem = _loc6_;
         }
         _loc6_ = param1.@autoItemSize;
         if(this._layout == "row" || this._layout == "column")
         {
            this._autoResizeItem1 = _loc6_ != "false";
         }
         else
         {
            this._autoResizeItem2 = _loc6_ == "true";
         }
         _loc6_ = param1.@align;
         if(_loc6_)
         {
            this._align = _loc6_;
         }
         else
         {
            this._align = "left";
         }
         _loc6_ = param1.@vAlign;
         if(_loc6_)
         {
            this._verticalAlign = _loc6_;
         }
         else
         {
            this._verticalAlign = "top";
         }
         updateOverflow();
         _loc6_ = param1.@renderOrder;
         if(_loc6_)
         {
            _childrenRenderOrder = _loc6_;
            if(_childrenRenderOrder == "arch")
            {
               _loc6_ = param1.@apex;
               if(_loc6_)
               {
                  _apexIndex = parseInt(_loc6_);
               }
            }
         }
         var _loc4_:XMLList = param1.item;
         _loc5_ = [];
         var _loc9_:int = 0;
         var _loc8_:* = _loc4_;
         for each(_loc2_ in _loc4_)
         {
            _loc3_ = String(_loc2_.@url);
            if(!_loc3_)
            {
               _loc3_ = this._defaultItem;
            }
            _loc5_.push([_loc3_,String(_loc2_.@title),String(_loc2_.@icon),String(_loc2_.@name)]);
         }
         this.items = _loc5_;
      }
      
      override public function fromXML_afterAdd(param1:XML) : void
      {
         super.fromXML_afterAdd(param1);
         var _loc2_:String = param1.@selectionController;
         if(_loc2_)
         {
            this._selectionController = parent.getController(_loc2_);
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
         var _loc3_:XML = super.toXML();
         if(this._layout != "column")
         {
            _loc3_.@layout = this._layout;
         }
         if(this._selectionMode != "single")
         {
            _loc3_.@selectionMode = this._selectionMode;
         }
         if(_overflow != "visible")
         {
            _loc3_.@overflow = _overflow;
         }
         if(_scroll != "vertical")
         {
            _loc3_.@scroll = _scroll;
         }
         if(_overflow == "scroll")
         {
            if(_scrollBarFlags)
            {
               _loc3_.@scrollBarFlags = _scrollBarFlags;
            }
            if(_scrollBarDisplay != "default")
            {
               _loc3_.@scrollBar = _scrollBarDisplay;
            }
         }
         if(!_margin.empty)
         {
            _loc3_.@margin = _margin;
         }
         if(!_scrollBarMargin.empty)
         {
            _loc3_.@scrollBarMargin = _scrollBarMargin.toString();
         }
         if(_vtScrollBarRes || _hzScrollBarRes)
         {
            _loc3_.@scrollBarRes = (!!_vtScrollBarRes?_vtScrollBarRes:"") + "," + (!!_hzScrollBarRes?_hzScrollBarRes:"");
         }
         if(_headerRes || _footerRes)
         {
            _loc3_.@ptrRes = (!!_headerRes?_headerRes:"") + "," + (!!_footerRes?_footerRes:"");
         }
         if(_clipSoftness.x != 0 || _clipSoftness.y != 0)
         {
            _loc3_.@clipSoftness = _clipSoftness.x + "," + _clipSoftness.y;
         }
         if(this._lineGap != 0)
         {
            _loc3_.@lineGap = this._lineGap;
         }
         if(this._columnGap != 0)
         {
            _loc3_.@colGap = this._columnGap;
         }
         if(this._layout == "flow_hz")
         {
            if(this._repeatX != 0)
            {
               _loc3_.@lineItemCount = this._repeatX;
            }
         }
         else if(this._layout == "flow_vt")
         {
            if(this._repeatY != 0)
            {
               _loc3_.@lineItemCount = this._repeatY;
            }
         }
         else if(this._layout == "pagination")
         {
            if(this._repeatX != 0)
            {
               _loc3_.@lineItemCount = this._repeatX;
            }
            if(this._repeatY != 0)
            {
               _loc3_.@lineItemCount2 = this._repeatY;
            }
         }
         if(this._defaultItem)
         {
            _loc3_.@defaultItem = this._defaultItem;
         }
         if(this._layout == "row" || this._layout == "column")
         {
            if(!this._autoResizeItem1)
            {
               _loc3_.@autoItemSize = false;
            }
         }
         else if(this._autoResizeItem2)
         {
            _loc3_.@autoItemSize = true;
         }
         if(this._align != "left")
         {
            _loc3_.@align = this._align;
         }
         if(this._verticalAlign != "top")
         {
            _loc3_.@vAlign = this._verticalAlign;
         }
         if(_childrenRenderOrder != "ascent")
         {
            _loc3_.@renderOrder = _childrenRenderOrder;
            if(_childrenRenderOrder == "arch" && _apexIndex != 0)
            {
               _loc3_.@apex = _apexIndex;
            }
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
               if(_loc2_[0] && _loc2_[0] != this._defaultItem)
               {
                  _loc1_.@url = _loc2_[0];
               }
               if(_loc2_[1])
               {
                  _loc1_.@title = _loc2_[1];
               }
               if(_loc2_[2])
               {
                  _loc1_.@icon = _loc2_[2];
               }
               if(_loc2_[3])
               {
                  _loc1_.@name = _loc2_[3];
               }
               _loc3_.appendChild(_loc1_);
            }
         }
         return _loc3_;
      }
   }
}
