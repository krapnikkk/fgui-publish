package fairygui
{
   import fairygui.utils.GTimers;
   
   public class GGroup extends GObject
   {
       
      
      private var _layout:int;
      
      private var _lineGap:int;
      
      private var _columnGap:int;
      
      private var _excludeInvisibles:Boolean;
      
      private var _autoSizeDisabled:Boolean;
      
      private var _mainGridIndex:int;
      
      private var _mainGridMinSize:Number;
      
      private var _boundsChanged:Boolean;
      
      private var _percentReady:Boolean;
      
      private var _mainChildIndex:int;
      
      private var _totalSize:Number;
      
      private var _numChildren:int;
      
      var _updating:int;
      
      public function GGroup()
      {
         super();
         _mainGridIndex = -1;
         _mainGridMinSize = 50;
         _totalSize = 0;
         _numChildren = 0;
      }
      
      override public function dispose() : void
      {
         _boundsChanged = false;
         super.dispose();
      }
      
      public final function get layout() : int
      {
         return _layout;
      }
      
      public final function set layout(param1:int) : void
      {
         if(_layout != param1)
         {
            _layout = param1;
            setBoundsChangedFlag();
         }
      }
      
      public final function get lineGap() : int
      {
         return _lineGap;
      }
      
      public final function set lineGap(param1:int) : void
      {
         if(_lineGap != param1)
         {
            _lineGap = param1;
            setBoundsChangedFlag(true);
         }
      }
      
      public final function get columnGap() : int
      {
         return _columnGap;
      }
      
      public final function set columnGap(param1:int) : void
      {
         if(_columnGap != param1)
         {
            _columnGap = param1;
            setBoundsChangedFlag(true);
         }
      }
      
      public function get excludeInvisibles() : Boolean
      {
         return _excludeInvisibles;
      }
      
      public function set excludeInvisibles(param1:Boolean) : void
      {
         if(_excludeInvisibles != param1)
         {
            _excludeInvisibles = param1;
            setBoundsChangedFlag();
         }
      }
      
      public function get autoSizeDisabled() : Boolean
      {
         return _autoSizeDisabled;
      }
      
      public function set autoSizeDisabled(param1:Boolean) : void
      {
         _autoSizeDisabled = param1;
      }
      
      public function get mainGridMinSize() : Number
      {
         return _mainGridMinSize;
      }
      
      public function set mainGridMinSize(param1:Number) : void
      {
         if(_mainGridMinSize != param1)
         {
            _mainGridMinSize = param1;
            setBoundsChangedFlag();
         }
      }
      
      public function get mainGridIndex() : int
      {
         return _mainGridIndex;
      }
      
      public function set mainGridIndex(param1:int) : void
      {
         if(_mainGridIndex != param1)
         {
            _mainGridIndex = param1;
            setBoundsChangedFlag();
         }
      }
      
      public function setBoundsChangedFlag(param1:Boolean = false) : void
      {
         if(_updating == 0 && parent != null)
         {
            if(!param1)
            {
               _percentReady = false;
            }
            if(!_boundsChanged)
            {
               _boundsChanged = true;
               if(_layout != 0)
               {
                  GTimers.inst.callLater(ensureBoundsCorrect);
               }
            }
         }
      }
      
      override public function ensureSizeCorrect() : void
      {
         if(parent == null || !_boundsChanged || _layout == 0)
         {
            return;
         }
         _boundsChanged = false;
         if(_autoSizeDisabled)
         {
            resizeChildren(0,0);
         }
         else
         {
            handleLayout();
            updateBounds();
         }
      }
      
      public function ensureBoundsCorrect() : void
      {
         if(parent == null || !_boundsChanged)
         {
            return;
         }
         _boundsChanged = false;
         if(_layout == 0)
         {
            updateBounds();
         }
         else if(_autoSizeDisabled)
         {
            resizeChildren(0,0);
         }
         else
         {
            handleLayout();
            updateBounds();
         }
      }
      
      private function updateBounds() : void
      {
         var _loc10_:int = 0;
         var _loc11_:* = null;
         var _loc3_:int = 0;
         var _loc6_:int = _parent.numChildren;
         var _loc4_:* = 2147483647;
         var _loc7_:* = 2147483647;
         var _loc2_:* = -2147483648;
         var _loc1_:* = -2147483648;
         var _loc8_:int = 0;
         _loc10_ = 0;
         while(_loc10_ < _loc6_)
         {
            _loc11_ = _parent.getChildAt(_loc10_);
            if(!(_loc11_.group != this || _excludeInvisibles && !_loc11_.internalVisible3))
            {
               _loc8_++;
               _loc3_ = _loc11_.xMin;
               if(_loc3_ < _loc4_)
               {
                  _loc4_ = _loc3_;
               }
               _loc3_ = _loc11_.yMin;
               if(_loc3_ < _loc7_)
               {
                  _loc7_ = _loc3_;
               }
               _loc3_ = _loc11_.xMin + _loc11_.width;
               if(_loc3_ > _loc2_)
               {
                  _loc2_ = _loc3_;
               }
               _loc3_ = _loc11_.yMin + _loc11_.height;
               if(_loc3_ > _loc1_)
               {
                  _loc1_ = _loc3_;
               }
            }
            _loc10_++;
         }
         var _loc5_:* = 0;
         var _loc9_:* = 0;
         if(_loc8_ > 0)
         {
            _updating = _updating | 1;
            setXY(_loc4_,_loc7_);
            _updating = _updating & 2;
            _loc5_ = Number(_loc2_ - _loc4_);
            _loc9_ = Number(_loc1_ - _loc7_);
         }
         if((_updating & 2) == 0)
         {
            _updating = _updating | 2;
            setSize(_loc5_,_loc9_);
            _updating = _updating & 1;
         }
         else
         {
            _updating = _updating & 1;
            this.resizeChildren(_width - _loc5_,_height - _loc9_);
         }
      }
      
      private function handleLayout() : void
      {
         var _loc5_:* = null;
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         _updating = _updating | 1;
         if(_layout == 1)
         {
            _loc1_ = this.x;
            _loc3_ = parent.numChildren;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = parent.getChildAt(_loc4_);
               if(_loc5_.group == this)
               {
                  if(!(_excludeInvisibles && !_loc5_.internalVisible3))
                  {
                     _loc5_.xMin = _loc1_;
                     if(_loc5_.width != 0)
                     {
                        _loc1_ = _loc1_ + (_loc5_.width + _columnGap);
                     }
                  }
               }
               _loc4_++;
            }
         }
         else if(_layout == 2)
         {
            _loc2_ = this.y;
            _loc3_ = parent.numChildren;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = parent.getChildAt(_loc4_);
               if(_loc5_.group == this)
               {
                  if(!(_excludeInvisibles && !_loc5_.internalVisible3))
                  {
                     _loc5_.yMin = _loc2_;
                     if(_loc5_.height != 0)
                     {
                        _loc2_ = _loc2_ + (_loc5_.height + _lineGap);
                     }
                  }
               }
               _loc4_++;
            }
         }
         _updating = _updating & 2;
      }
      
      function moveChildren(param1:Number, param2:Number) : void
      {
         var _loc4_:int = 0;
         var _loc5_:* = null;
         if((_updating & 1) != 0 || parent == null)
         {
            return;
         }
         _updating = _updating | 1;
         var _loc3_:int = parent.numChildren;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = parent.getChildAt(_loc4_);
            if(_loc5_.group == this)
            {
               _loc5_.setXY(_loc5_.x + param1,_loc5_.y + param2);
            }
            _loc4_++;
         }
         _updating = _updating & 2;
      }
      
      function resizeChildren(param1:Number, param2:Number) : void
      {
         var _loc7_:int = 0;
         var _loc10_:* = null;
         var _loc8_:int = 0;
         var _loc3_:Number = NaN;
         var _loc5_:Number = NaN;
         if(_layout == 0 || (_updating & 2) != 0 || parent == null)
         {
            return;
         }
         _updating = _updating | 2;
         if(_boundsChanged)
         {
            _boundsChanged = false;
            if(!_autoSizeDisabled)
            {
               updateBounds();
               return;
            }
         }
         var _loc6_:int = parent.numChildren;
         if(!_percentReady)
         {
            _percentReady = true;
            _numChildren = 0;
            _totalSize = 0;
            _mainChildIndex = -1;
            _loc8_ = 0;
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc10_ = _parent.getChildAt(_loc7_);
               if(_loc10_.group == this)
               {
                  if(!_excludeInvisibles || _loc10_.internalVisible3)
                  {
                     if(_loc8_ == _mainGridIndex)
                     {
                        _mainChildIndex = _loc7_;
                     }
                     _numChildren = Number(_numChildren) + 1;
                     if(_layout == 1)
                     {
                        _totalSize = _totalSize + _loc10_.width;
                     }
                     else
                     {
                        _totalSize = _totalSize + _loc10_.height;
                     }
                  }
                  _loc8_++;
               }
               _loc7_++;
            }
            if(_mainChildIndex != -1)
            {
               if(_layout == 1)
               {
                  _loc10_ = parent.getChildAt(_mainChildIndex);
                  _totalSize = _totalSize + (_mainGridMinSize - _loc10_.width);
                  _loc10_._sizePercentInGroup = _mainGridMinSize / _totalSize;
               }
               else
               {
                  _loc10_ = parent.getChildAt(_mainChildIndex);
                  _totalSize = _totalSize + (_mainGridMinSize - _loc10_.height);
                  _loc10_._sizePercentInGroup = _mainGridMinSize / _totalSize;
               }
            }
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc10_ = parent.getChildAt(_loc7_);
               if(_loc10_.group == this)
               {
                  if(_loc7_ != _mainChildIndex)
                  {
                     if(_totalSize > 0)
                     {
                        _loc10_._sizePercentInGroup = (_layout == 1?_loc10_.width:Number(_loc10_.height)) / _totalSize;
                     }
                     else
                     {
                        _loc10_._sizePercentInGroup = 0;
                     }
                  }
               }
               _loc7_++;
            }
         }
         var _loc9_:* = 0;
         var _loc11_:* = 1;
         var _loc4_:Boolean = false;
         if(_layout == 1)
         {
            _loc9_ = Number(this.width - (_numChildren - 1) * _columnGap);
            if(_mainChildIndex != -1 && _loc9_ >= _totalSize)
            {
               _loc10_ = parent.getChildAt(_mainChildIndex);
               _loc10_.setSize(_loc9_ - (_totalSize - _mainGridMinSize),_loc10_._rawHeight + param2,true);
               _loc9_ = Number(_loc9_ - _loc10_.width);
               _loc11_ = Number(_loc11_ - _loc10_._sizePercentInGroup);
               _loc4_ = true;
            }
            _loc3_ = this.x;
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc10_ = parent.getChildAt(_loc7_);
               if(_loc10_.group == this)
               {
                  if(_excludeInvisibles && !_loc10_.internalVisible3)
                  {
                     _loc10_.setSize(_loc10_._rawWidth,_loc10_._rawHeight + param2,true);
                  }
                  else
                  {
                     if(!_loc4_ || _loc7_ != _mainChildIndex)
                     {
                        _loc10_.setSize(Math.round(_loc10_._sizePercentInGroup / _loc11_ * _loc9_),_loc10_._rawHeight + param2,true);
                        _loc11_ = Number(_loc11_ - _loc10_._sizePercentInGroup);
                        _loc9_ = Number(_loc9_ - _loc10_.width);
                     }
                     _loc10_.xMin = _loc3_;
                     if(_loc10_.width != 0)
                     {
                        _loc3_ = _loc3_ + (_loc10_.width + _columnGap);
                     }
                  }
               }
               _loc7_++;
            }
         }
         else
         {
            _loc9_ = Number(this.height - (_numChildren - 1) * _lineGap);
            if(_mainChildIndex != -1 && _loc9_ >= _totalSize)
            {
               _loc10_ = parent.getChildAt(_mainChildIndex);
               _loc10_.setSize(_loc10_._rawWidth + param1,_loc9_ - (_totalSize - _mainGridMinSize),true);
               _loc9_ = Number(_loc9_ - _loc10_.height);
               _loc11_ = Number(_loc11_ - _loc10_._sizePercentInGroup);
               _loc4_ = true;
            }
            _loc5_ = this.y;
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc10_ = parent.getChildAt(_loc7_);
               if(_loc10_.group == this)
               {
                  if(_excludeInvisibles && !_loc10_.internalVisible3)
                  {
                     _loc10_.setSize(_loc10_._rawWidth + param1,_loc10_._rawHeight,true);
                  }
                  else
                  {
                     if(!_loc4_ || _loc7_ != _mainChildIndex)
                     {
                        _loc10_.setSize(_loc10_._rawWidth + param1,Math.round(_loc10_._sizePercentInGroup / _loc11_ * _loc9_),true);
                        _loc11_ = Number(_loc11_ - _loc10_._sizePercentInGroup);
                        _loc9_ = Number(_loc9_ - _loc10_.height);
                     }
                     _loc10_.yMin = _loc5_;
                     if(_loc10_.height != 0)
                     {
                        _loc5_ = _loc5_ + (_loc10_.height + _lineGap);
                     }
                  }
               }
               _loc7_++;
            }
         }
         _updating = _updating & 1;
      }
      
      override protected function handleAlphaChanged() : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         if(this._underConstruct)
         {
            return;
         }
         var _loc1_:int = _parent.numChildren;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = _parent.getChildAt(_loc2_);
            if(_loc3_.group == this)
            {
               _loc3_.alpha = this.alpha;
            }
            _loc2_++;
         }
      }
      
      override function handleVisibleChanged() : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         if(!this._parent)
         {
            return;
         }
         var _loc1_:int = _parent.numChildren;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = _parent.getChildAt(_loc2_);
            if(_loc3_.group == this)
            {
               _loc3_.handleVisibleChanged();
            }
            _loc2_++;
         }
      }
      
      override public function setup_beforeAdd(param1:XML) : void
      {
         var _loc2_:* = null;
         super.setup_beforeAdd(param1);
         _loc2_ = param1.@layout;
         if(_loc2_ != null)
         {
            _layout = GroupLayoutType.parse(_loc2_);
            _loc2_ = param1.@lineGap;
            if(_loc2_)
            {
               _lineGap = parseInt(_loc2_);
            }
            _loc2_ = param1.@colGap;
            if(_loc2_)
            {
               _columnGap = parseInt(_loc2_);
            }
            _excludeInvisibles = param1.@excludeInvisibles == "true";
            _autoSizeDisabled = param1.@autoSizeDisabled == "true";
            _loc2_ = param1.@mainGridIndex;
            if(_loc2_)
            {
               _mainGridIndex = parseInt(_loc2_);
            }
         }
      }
      
      override public function setup_afterAdd(param1:XML) : void
      {
         super.setup_afterAdd(param1);
         if(!this.visible)
         {
            handleVisibleChanged();
         }
      }
   }
}
