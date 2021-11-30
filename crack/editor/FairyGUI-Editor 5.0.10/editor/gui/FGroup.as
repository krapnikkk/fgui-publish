package fairygui.editor.gui
{
   import fairygui.utils.GTimers;
   import fairygui.utils.XData;
   
   public class FGroup extends FObject
   {
      
      public static const HORIZONTAL:String = "hz";
      
      public static const VERTICAL:String = "vt";
       
      
      private var _advanced:Boolean;
      
      private var _layout:String;
      
      private var _lineGap:int;
      
      private var _columnGap:int;
      
      private var _boundsChanged:Boolean;
      
      private var _percentReady:Boolean;
      
      private var _excludeInvisibles:Boolean;
      
      private var _autoSizeDisabled:Boolean;
      
      private var _mainGridIndex:int;
      
      private var _mainGridMinSize:Number;
      
      private var _hasMainGrid:Boolean;
      
      private var _collapsed:Boolean;
      
      private var _children:Vector.<FObject>;
      
      private var _gapInited:Boolean;
      
      private var _mainChildIndex:int;
      
      private var _totalSize:Number;
      
      private var _numChildren:int;
      
      public var _updating:int;
      
      public var _childrenDirty:Boolean;
      
      public function FGroup()
      {
         super();
         this._objectType = FObjectType.GROUP;
         _useSourceSize = false;
         this._layout = "none";
         this._excludeInvisibles = true;
         this._autoSizeDisabled = false;
         this._mainGridMinSize = 10;
         this._hasMainGrid = false;
         this._mainGridIndex = 0;
         this._childrenDirty = true;
         this._children = new Vector.<FObject>();
      }
      
      override protected function handleDispose() : void
      {
         super.handleDispose();
         GTimers.inst.remove(this.updateImmdediately);
      }
      
      public function get advanced() : Boolean
      {
         return this._advanced;
      }
      
      public function set advanced(param1:Boolean) : void
      {
         if(this._advanced != param1)
         {
            this._advanced = param1;
            this._percentReady = false;
            this.updateImmdediately();
            if(!this._advanced)
            {
               _internalVisible = true;
               if(_parent)
               {
                  _parent.updateDisplayList();
               }
            }
            else
            {
               checkGearDisplay();
            }
         }
      }
      
      public function get excludeInvisibles() : Boolean
      {
         return this._excludeInvisibles;
      }
      
      public function set excludeInvisibles(param1:Boolean) : void
      {
         if(this._excludeInvisibles != param1)
         {
            this._excludeInvisibles = param1;
            this._percentReady = false;
            this.updateImmdediately();
         }
      }
      
      public function get autoSizeDisabled() : Boolean
      {
         return this._autoSizeDisabled;
      }
      
      public function set autoSizeDisabled(param1:Boolean) : void
      {
         if(this._autoSizeDisabled != param1)
         {
            this._autoSizeDisabled = param1;
         }
      }
      
      public function get mainGridMinSize() : Number
      {
         return this._mainGridMinSize;
      }
      
      public function set mainGridMinSize(param1:Number) : void
      {
         if(this._mainGridMinSize != param1)
         {
            this._mainGridMinSize = param1;
            this.refresh();
         }
      }
      
      public function get mainGridIndex() : int
      {
         return this._mainGridIndex;
      }
      
      public function set mainGridIndex(param1:int) : void
      {
         if(this._mainGridIndex != param1)
         {
            this._mainGridIndex = param1;
            this.refresh();
         }
      }
      
      public function get hasMainGrid() : Boolean
      {
         return this._hasMainGrid;
      }
      
      public function set hasMainGrid(param1:Boolean) : void
      {
         if(this._hasMainGrid != param1)
         {
            this._hasMainGrid = param1;
            this.refresh();
         }
      }
      
      public function get collapsed() : Boolean
      {
         return this._collapsed;
      }
      
      public function set collapsed(param1:Boolean) : void
      {
         this._collapsed = param1;
      }
      
      public function get layout() : String
      {
         return this._layout;
      }
      
      public function set layout(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:FObject = null;
         var _loc5_:FObject = null;
         var _loc6_:Boolean = false;
         if(this._layout != param1)
         {
            this._layout = param1;
            this._percentReady = false;
            this.ensureChildren();
            if(!this._gapInited && (this._layout == "hz" || this._layout == "vt"))
            {
               this._gapInited = true;
               _loc6_ = this._excludeInvisibles && (_flags & FObjectFlags.INSPECTING) == 0;
               _loc2_ = this._children.length;
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  _loc4_ = this._children[_loc3_];
                  if(!(_loc6_ && !_loc4_.internalVisible3))
                  {
                     if(!_loc5_)
                     {
                        _loc5_ = _loc4_;
                     }
                     else
                     {
                        this._columnGap = int(_loc4_.x - _loc5_.x - _loc5_.width);
                        break;
                     }
                  }
                  _loc3_++;
               }
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  _loc4_ = this._children[_loc3_];
                  if(!(_loc6_ && !_loc4_.internalVisible3))
                  {
                     if(!_loc5_)
                     {
                        _loc5_ = _loc4_;
                     }
                     else
                     {
                        this._lineGap = int(_loc4_.y - _loc5_.y - _loc5_.height);
                        break;
                     }
                  }
                  _loc3_++;
               }
               if(this._columnGap < 0)
               {
                  this._columnGap = 0;
               }
               if(this._lineGap < 0)
               {
                  this._lineGap = 0;
               }
            }
            this.updateImmdediately();
         }
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
            this.refresh();
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
            this.refresh();
         }
      }
      
      public function get boundsChanged() : Boolean
      {
         return this._boundsChanged;
      }
      
      public function refresh(param1:Boolean = false) : void
      {
         if(this._updating != 0 || !_parent || !this._advanced && FObjectFactory.constructingDepth != 0 || this._advanced && _underConstruct && (_flags & FObjectFlags.INSPECTING) != 0)
         {
            return;
         }
         if(!param1)
         {
            this._percentReady = false;
         }
         if(!this._boundsChanged)
         {
            this._boundsChanged = true;
            if(!_opened)
            {
               GTimers.inst.callLater(this.updateImmdediately);
            }
         }
      }
      
      public function get children() : Vector.<FObject>
      {
         this.ensureChildren();
         return this._children;
      }
      
      public function freeChildrenArray() : void
      {
         this._children.length = 0;
         this._childrenDirty = true;
      }
      
      private function ensureChildren() : void
      {
         var _loc2_:int = 0;
         var _loc3_:FObject = null;
         if(!this._childrenDirty)
         {
            return;
         }
         this._childrenDirty = false;
         this._children.length = 0;
         var _loc1_:int = _parent.numChildren;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = _parent.getChildAt(_loc2_);
            if(_loc3_._group == this)
            {
               this._children.push(_loc3_);
            }
            _loc2_++;
         }
      }
      
      public function getStartIndex() : int
      {
         this.ensureChildren();
         if(this._children.length == 0)
         {
            return -1;
         }
         var _loc1_:FObject = this._children[0];
         if(_loc1_ is FGroup)
         {
            return FGroup(_loc1_).getStartIndex();
         }
         return _parent.getChildIndex(_loc1_);
      }
      
      public function updateImmdediately() : void
      {
         this._boundsChanged = false;
         if(_parent == null)
         {
            return;
         }
         this.ensureChildren();
         if(this._advanced)
         {
            if(this._layout != "none")
            {
               if(this._autoSizeDisabled)
               {
                  this.resizeChildren(0,0);
               }
               else
               {
                  this.handleLayout();
                  this.updateBounds();
               }
            }
            else
            {
               this.updateBounds();
            }
         }
         else
         {
            this.updateBounds();
         }
      }
      
      private function updateBounds() : void
      {
         var _loc2_:int = 0;
         var _loc3_:FObject = null;
         var _loc8_:int = 0;
         var _loc1_:int = this._children.length;
         var _loc4_:int = int.MAX_VALUE;
         var _loc5_:int = int.MAX_VALUE;
         var _loc6_:int = int.MIN_VALUE;
         var _loc7_:int = int.MIN_VALUE;
         var _loc9_:Boolean = true;
         var _loc10_:Boolean = this._layout != "none" && this._excludeInvisibles;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._children[_loc2_];
            if(!(_loc10_ && !_loc3_.internalVisible3))
            {
               _loc8_ = _loc3_.xMin;
               if(_loc8_ < _loc4_)
               {
                  _loc4_ = _loc8_;
               }
               _loc8_ = _loc3_.yMin;
               if(_loc8_ < _loc5_)
               {
                  _loc5_ = _loc8_;
               }
               _loc8_ = _loc3_.xMax;
               if(_loc8_ > _loc6_)
               {
                  _loc6_ = _loc8_;
               }
               _loc8_ = _loc3_.yMax;
               if(_loc8_ > _loc7_)
               {
                  _loc7_ = _loc8_;
               }
               _loc9_ = false;
            }
            _loc2_++;
         }
         var _loc11_:Number = 0;
         var _loc12_:Number = 0;
         if(!_loc9_)
         {
            this._updating = this._updating | 1;
            setXY(_loc4_,_loc5_);
            this._updating = this._updating & 2;
            _loc11_ = _loc6_ - _loc4_;
            _loc12_ = _loc7_ - _loc5_;
         }
         if((this._updating & 2) == 0)
         {
            this._updating = this._updating | 2;
            setSize(_loc11_,_loc12_);
            this._updating = this._updating & 1;
         }
         else
         {
            this._updating = this._updating & 1;
            this.resizeChildren(_width - _loc11_,_height - _loc12_);
         }
      }
      
      private function handleLayout() : void
      {
         var _loc2_:int = 0;
         var _loc3_:FObject = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc1_:int = this._children.length;
         if(_loc1_ == 0)
         {
            return;
         }
         var _loc4_:Boolean = this._excludeInvisibles;
         this._updating = this._updating | 1;
         if(this._layout == "hz")
         {
            _loc5_ = this.x;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this._children[_loc2_];
               if(!(_loc4_ && !_loc3_.internalVisible3))
               {
                  _loc3_.xMin = _loc5_;
                  if(_loc3_.width != 0)
                  {
                     _loc5_ = _loc5_ + (_loc3_.width + this._columnGap);
                  }
               }
               _loc2_++;
            }
         }
         else if(this._layout == "vt")
         {
            _loc6_ = this.y;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this._children[_loc2_];
               if(!(_loc4_ && !_loc3_.internalVisible3))
               {
                  _loc3_.yMin = _loc6_;
                  if(_loc3_.height != 0)
                  {
                     _loc6_ = _loc6_ + (_loc3_.height + this._lineGap);
                  }
               }
               _loc2_++;
            }
         }
         this._updating = this._updating & 2;
      }
      
      public function moveChildren(param1:Number, param2:Number) : void
      {
         var _loc4_:int = 0;
         var _loc5_:FObject = null;
         if((this._updating & 1) != 0 || !_parent)
         {
            return;
         }
         this.ensureChildren();
         var _loc3_:int = this._children.length;
         if(_loc3_ == 0)
         {
            return;
         }
         this._updating = this._updating | 1;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._children[_loc4_];
            _loc5_.setXY(_loc5_.x + param1,_loc5_.y + param2);
            _loc4_++;
         }
         this._updating = this._updating & 2;
      }
      
      public function resizeChildren(param1:Number, param2:Number) : void
      {
         var _loc3_:int = 0;
         var _loc5_:FObject = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         if(this._layout == "none" && (_flags & FObjectFlags.INSPECTING) == 0)
         {
            return;
         }
         if((this._updating & 2) != 0 || !_parent)
         {
            return;
         }
         this.ensureChildren();
         this._updating = this._updating | 2;
         if(this._boundsChanged)
         {
            this._boundsChanged = false;
            if(!this._autoSizeDisabled)
            {
               this.updateBounds();
               return;
            }
         }
         var _loc4_:int = this._children.length;
         var _loc6_:Number = 0;
         var _loc7_:Number = 1;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = this._excludeInvisibles;
         if(this._layout != "none" && !this._percentReady)
         {
            this._percentReady = true;
            this._numChildren = 0;
            this._totalSize = 0;
            this._mainChildIndex = -1;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = this._children[_loc3_];
               if(!_loc9_ || _loc5_.internalVisible3)
               {
                  if(this._hasMainGrid && _loc3_ == this._mainGridIndex)
                  {
                     this._mainChildIndex = _loc3_;
                  }
                  this._numChildren++;
                  if(this._layout == "hz")
                  {
                     this._totalSize = this._totalSize + _loc5_.width;
                  }
                  else
                  {
                     this._totalSize = this._totalSize + _loc5_.height;
                  }
               }
               _loc3_++;
            }
            if(this._mainChildIndex != -1)
            {
               if(this._layout == "hz")
               {
                  _loc5_ = this._children[this._mainChildIndex];
                  this._totalSize = this._totalSize + (this._mainGridMinSize - _loc5_.width);
                  _loc5_._sizePercentInGroup = this._mainGridMinSize / this._totalSize;
               }
               else
               {
                  _loc5_ = this._children[this._mainChildIndex];
                  this._totalSize = this._totalSize + (this._mainGridMinSize - _loc5_.height);
                  _loc5_._sizePercentInGroup = this._mainGridMinSize / this._totalSize;
               }
            }
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = this._children[_loc3_];
               if(_loc3_ != this._mainChildIndex)
               {
                  if(this._totalSize > 0)
                  {
                     _loc5_._sizePercentInGroup = (this._layout == "hz"?_loc5_.width:_loc5_.height) / this._totalSize;
                  }
                  else
                  {
                     _loc5_._sizePercentInGroup = 0;
                  }
               }
               _loc3_++;
            }
         }
         if(this._layout == "hz")
         {
            _loc6_ = this.width - (this._numChildren - 1) * this._columnGap;
            if(this._mainChildIndex != -1 && _loc6_ >= this._totalSize)
            {
               _loc5_ = this._children[this._mainChildIndex];
               _loc5_.setSize(_loc6_ - (this._totalSize - this._mainGridMinSize),_loc5_._rawHeight + param2,true);
               _loc6_ = _loc6_ - _loc5_.width;
               _loc7_ = _loc7_ - _loc5_._sizePercentInGroup;
               _loc8_ = true;
            }
            _loc10_ = this.x;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = this._children[_loc3_];
               if(_loc9_ && !_loc5_.internalVisible3)
               {
                  _loc5_.setSize(_loc5_._rawWidth,_loc5_._rawHeight + param2,true);
               }
               else
               {
                  if(!_loc8_ || _loc3_ != this._mainChildIndex)
                  {
                     _loc5_.setSize(Math.round(_loc5_._sizePercentInGroup / _loc7_ * _loc6_),_loc5_._rawHeight + param2,true);
                     _loc7_ = _loc7_ - _loc5_._sizePercentInGroup;
                     _loc6_ = _loc6_ - _loc5_.width;
                  }
                  _loc5_.xMin = _loc10_;
                  if(_loc5_.width != 0)
                  {
                     _loc10_ = _loc10_ + (_loc5_.width + this._columnGap);
                  }
               }
               _loc3_++;
            }
         }
         else if(this._layout == "vt")
         {
            _loc6_ = this.height - (this._numChildren - 1) * this._lineGap;
            if(this._mainChildIndex != -1 && _loc6_ >= this._totalSize)
            {
               _loc5_ = this._children[this._mainChildIndex];
               _loc5_.setSize(_loc5_._rawWidth + param1,_loc6_ - (this._totalSize - this._mainGridMinSize),true);
               _loc6_ = _loc6_ - _loc5_.height;
               _loc7_ = _loc7_ - _loc5_._sizePercentInGroup;
               _loc8_ = true;
            }
            _loc11_ = this.y;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = this._children[_loc3_];
               if(_loc9_ && !_loc5_.internalVisible3)
               {
                  _loc5_.setSize(_loc5_._rawWidth + param1,_loc5_._rawHeight,true);
               }
               else
               {
                  if(!_loc8_ || _loc3_ != this._mainChildIndex)
                  {
                     _loc5_.setSize(_loc5_._rawWidth + param1,Math.round(_loc5_._sizePercentInGroup / _loc7_ * _loc6_),true);
                     _loc7_ = _loc7_ - _loc5_._sizePercentInGroup;
                     _loc6_ = _loc6_ - _loc5_.height;
                  }
                  _loc5_.yMin = _loc11_;
                  if(_loc5_.height != 0)
                  {
                     _loc11_ = _loc11_ + (_loc5_.height + this._lineGap);
                  }
               }
               _loc3_++;
            }
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = this._children[_loc3_];
               _loc5_.setSize(_loc5_._rawWidth + param1,_loc5_._rawHeight + param2,true);
               _loc3_++;
            }
         }
         this._updating = this._updating & 1;
      }
      
      public function get empty() : Boolean
      {
         return this.children.length == 0;
      }
      
      override public function handleAlphaChanged() : void
      {
         var _loc2_:int = 0;
         var _loc3_:FObject = null;
         super.handleAlphaChanged();
         if(this._underConstruct)
         {
            return;
         }
         this.ensureChildren();
         var _loc1_:int = this._children.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._children[_loc2_];
            _loc3_.alpha = this.alpha;
            _loc2_++;
         }
      }
      
      override public function handleControllerChanged(param1:FController) : void
      {
         if(this._advanced)
         {
            super.handleControllerChanged(param1);
         }
      }
      
      override public function handleVisibleChanged() : void
      {
         var _loc3_:FObject = null;
         if(!_parent)
         {
            return;
         }
         this.ensureChildren();
         var _loc1_:int = this._children.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._children[_loc2_];
            _loc3_.handleVisibleChanged();
            _loc2_++;
         }
      }
      
      override protected function handleCreate() : void
      {
         this.touchDisabled = true;
      }
      
      override public function read_beforeAdd(param1:XData, param2:Object) : void
      {
         super.read_beforeAdd(param1,param2);
         this._advanced = param1.getAttributeBool("advanced");
         if(this._advanced)
         {
            this._layout = param1.getAttribute("layout","none");
            this._lineGap = param1.getAttributeInt("lineGap");
            this._columnGap = param1.getAttributeInt("colGap");
            this._excludeInvisibles = param1.getAttributeBool("excludeInvisibles");
            this._autoSizeDisabled = param1.getAttributeBool("autoSizeDisabled");
            this._mainGridIndex = param1.getAttributeInt("mainGridIndex",-1);
            if(this._mainGridIndex == -1)
            {
               this._hasMainGrid = false;
               this._mainGridIndex = 0;
            }
            else
            {
               this._hasMainGrid = true;
            }
         }
      }
      
      override public function read_afterAdd(param1:XData, param2:Object) : void
      {
         super.read_afterAdd(param1,param2);
         if(!_visible)
         {
            this.handleVisibleChanged();
         }
      }
      
      override public function write() : XData
      {
         var _loc1_:XData = super.write();
         if(this._advanced)
         {
            _loc1_.setAttribute("advanced",true);
         }
         if(this._advanced && this._layout != "none")
         {
            _loc1_.setAttribute("layout",this._layout);
            if(this._lineGap != 0)
            {
               _loc1_.setAttribute("lineGap",this._lineGap);
            }
            if(this._columnGap != 0)
            {
               _loc1_.setAttribute("colGap",this._columnGap);
            }
            if(this._excludeInvisibles)
            {
               _loc1_.setAttribute("excludeInvisibles",this._excludeInvisibles);
            }
            if(this._autoSizeDisabled)
            {
               _loc1_.setAttribute("autoSizeDisabled",this._autoSizeDisabled);
            }
            if(this._hasMainGrid)
            {
               _loc1_.setAttribute("mainGridIndex",this._mainGridIndex);
            }
         }
         return _loc1_;
      }
   }
}
