package fairygui
{
   import fairygui.utils.GTimers;
   
   public class GGroup extends GObject
   {
       
      
      private var _layout:int;
      
      private var _lineGap:int;
      
      private var _columnGap:int;
      
      private var _percentReady:Boolean;
      
      private var _boundsChanged:Boolean;
      
      var _updating:int;
      
      public function GGroup()
      {
         super();
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
            setBoundsChangedFlag(true);
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
            setBoundsChangedFlag();
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
            setBoundsChangedFlag();
         }
      }
      
      public function setBoundsChangedFlag(param1:Boolean = false) : void
      {
         if(_updating == 0 && parent != null)
         {
            if(param1)
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
      
      public function ensureBoundsCorrect() : void
      {
         if(_boundsChanged)
         {
            updateBounds();
         }
      }
      
      private function updateBounds() : void
      {
         var _loc9_:int = 0;
         var _loc1_:* = null;
         var _loc5_:int = 0;
         GTimers.inst.remove(ensureBoundsCorrect);
         _boundsChanged = false;
         if(parent == null)
         {
            return;
         }
         handleLayout();
         var _loc3_:int = _parent.numChildren;
         var _loc8_:* = 2147483647;
         var _loc2_:* = 2147483647;
         var _loc6_:* = -2147483648;
         var _loc7_:* = -2147483648;
         var _loc4_:Boolean = true;
         _loc9_ = 0;
         while(_loc9_ < _loc3_)
         {
            _loc1_ = _parent.getChildAt(_loc9_);
            if(_loc1_.group == this)
            {
               _loc5_ = _loc1_.x;
               if(_loc5_ < _loc8_)
               {
                  _loc8_ = _loc5_;
               }
               _loc5_ = _loc1_.y;
               if(_loc5_ < _loc2_)
               {
                  _loc2_ = _loc5_;
               }
               _loc5_ = _loc1_.x + _loc1_.width;
               if(_loc5_ > _loc6_)
               {
                  _loc6_ = _loc5_;
               }
               _loc5_ = _loc1_.y + _loc1_.height;
               if(_loc5_ > _loc7_)
               {
                  _loc7_ = _loc5_;
               }
               _loc4_ = false;
            }
            _loc9_++;
         }
         if(!_loc4_)
         {
            _updating = 1;
            setXY(_loc8_,_loc2_);
            _updating = 2;
            setSize(_loc6_ - _loc8_,_loc7_ - _loc2_);
         }
         else
         {
            _updating = 2;
            setSize(0,0);
         }
         _updating = 0;
      }
      
      private function handleLayout() : void
      {
         var _loc2_:* = null;
         var _loc5_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:Number = NaN;
         var _loc3_:Number = NaN;
         _updating = _updating | 1;
         if(_layout == 1)
         {
            _loc1_ = NaN;
            _loc4_ = parent.numChildren;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc2_ = parent.getChildAt(_loc5_);
               if(_loc2_.group == this)
               {
                  if(isNaN(_loc1_))
                  {
                     _loc1_ = int(_loc2_.x);
                  }
                  else
                  {
                     _loc2_.x = _loc1_;
                  }
                  if(_loc2_.width != 0)
                  {
                     _loc1_ = _loc1_ + (int(_loc2_.width + _columnGap));
                  }
               }
               _loc5_++;
            }
            if(!_percentReady)
            {
               updatePercent();
            }
         }
         else if(_layout == 2)
         {
            _loc3_ = NaN;
            _loc4_ = parent.numChildren;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc2_ = parent.getChildAt(_loc5_);
               if(_loc2_.group == this)
               {
                  if(isNaN(_loc3_))
                  {
                     _loc3_ = int(_loc2_.y);
                  }
                  else
                  {
                     _loc2_.y = _loc3_;
                  }
                  if(_loc2_.height != 0)
                  {
                     _loc3_ = _loc3_ + (int(_loc2_.height + _lineGap));
                  }
               }
               _loc5_++;
            }
            if(!_percentReady)
            {
               updatePercent();
            }
         }
         _updating = _updating & 2;
      }
      
      private function updatePercent() : void
      {
         var _loc4_:int = 0;
         var _loc1_:* = null;
         _percentReady = true;
         var _loc2_:int = parent.numChildren;
         var _loc3_:* = 0;
         if(_layout == 1)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc1_ = parent.getChildAt(_loc4_);
               if(_loc1_.group == this)
               {
                  _loc3_ = Number(_loc3_ + _loc1_.width);
               }
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc1_ = parent.getChildAt(_loc4_);
               if(_loc1_.group == this)
               {
                  if(_loc3_ > 0)
                  {
                     _loc1_._sizePercentInGroup = _loc1_.width / _loc3_;
                  }
                  else
                  {
                     _loc1_._sizePercentInGroup = 0;
                  }
               }
               _loc4_++;
            }
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc1_ = parent.getChildAt(_loc4_);
               if(_loc1_.group == this)
               {
                  _loc3_ = Number(_loc3_ + _loc1_.height);
               }
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc1_ = parent.getChildAt(_loc4_);
               if(_loc1_.group == this)
               {
                  if(_loc3_ > 0)
                  {
                     _loc1_._sizePercentInGroup = _loc1_.height / _loc3_;
                  }
                  else
                  {
                     _loc1_._sizePercentInGroup = 0;
                  }
               }
               _loc4_++;
            }
         }
      }
      
      function moveChildren(param1:Number, param2:Number) : void
      {
         var _loc5_:int = 0;
         var _loc3_:* = null;
         if((_updating & 1) != 0 || parent == null)
         {
            return;
         }
         _updating = _updating | 1;
         var _loc4_:int = parent.numChildren;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = parent.getChildAt(_loc5_);
            if(_loc3_.group == this)
            {
               _loc3_.setXY(_loc3_.x + param1,_loc3_.y + param2);
            }
            _loc5_++;
         }
         _updating = _updating & 2;
      }
      
      function resizeChildren(param1:Number, param2:Number) : void
      {
         var _loc8_:int = 0;
         var _loc5_:int = 0;
         var _loc9_:* = null;
         var _loc10_:Number = NaN;
         var _loc7_:* = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:* = NaN;
         if(_layout == 0 || (_updating & 2) != 0 || parent == null)
         {
            return;
         }
         _updating = _updating | 2;
         if(!_percentReady)
         {
            updatePercent();
         }
         var _loc3_:int = parent.numChildren;
         var _loc4_:* = -1;
         var _loc13_:int = 0;
         var _loc6_:* = 0;
         var _loc14_:* = 0;
         var _loc15_:Boolean = false;
         _loc8_ = 0;
         while(_loc8_ < _loc3_)
         {
            _loc9_ = parent.getChildAt(_loc8_);
            if(_loc9_.group == this)
            {
               _loc4_ = _loc8_;
               _loc13_++;
            }
            _loc8_++;
         }
         if(_layout == 1)
         {
            _loc6_ = Number(this.width - (_loc13_ - 1) * _columnGap);
            _loc14_ = Number(this.width - (_loc13_ - 1) * _columnGap);
            _loc10_ = NaN;
            _loc8_ = 0;
            while(_loc8_ < _loc3_)
            {
               _loc9_ = parent.getChildAt(_loc8_);
               if(_loc9_.group == this)
               {
                  if(isNaN(_loc10_))
                  {
                     _loc10_ = int(_loc9_.x);
                  }
                  else
                  {
                     _loc9_.x = _loc10_;
                  }
                  if(_loc4_ == _loc8_)
                  {
                     _loc7_ = _loc14_;
                  }
                  else
                  {
                     _loc7_ = Number(Math.round(_loc9_._sizePercentInGroup * _loc6_));
                  }
                  _loc9_.setSize(_loc7_,_loc9_._rawHeight + param2,true);
                  _loc14_ = Number(_loc14_ - _loc9_.width);
                  if(_loc4_ == _loc8_)
                  {
                     if(_loc14_ >= 1)
                     {
                        _loc5_ = 0;
                        while(_loc5_ <= _loc8_)
                        {
                           _loc9_ = parent.getChildAt(_loc5_);
                           if(_loc9_.group == this)
                           {
                              if(!_loc15_)
                              {
                                 _loc7_ = Number(_loc9_.width + _loc14_);
                                 if((_loc9_.maxWidth == 0 || _loc7_ < _loc9_.maxWidth) && (_loc9_.minWidth == 0 || _loc7_ > _loc9_.minWidth))
                                 {
                                    _loc9_.setSize(_loc7_,_loc9_.height,true);
                                    _loc15_ = true;
                                 }
                              }
                              else
                              {
                                 _loc9_.x = _loc9_.x + _loc14_;
                              }
                           }
                           _loc5_++;
                        }
                     }
                  }
                  else
                  {
                     _loc10_ = _loc10_ + (_loc9_.width + _columnGap);
                  }
               }
               _loc8_++;
            }
         }
         else if(_layout == 2)
         {
            _loc6_ = Number(this.height - (_loc13_ - 1) * _lineGap);
            _loc14_ = Number(this.height - (_loc13_ - 1) * _lineGap);
            _loc11_ = NaN;
            _loc8_ = 0;
            while(_loc8_ < _loc3_)
            {
               _loc9_ = parent.getChildAt(_loc8_);
               if(_loc9_.group == this)
               {
                  if(isNaN(_loc11_))
                  {
                     _loc11_ = int(_loc9_.y);
                  }
                  else
                  {
                     _loc9_.y = _loc11_;
                  }
                  if(_loc4_ == _loc8_)
                  {
                     _loc12_ = _loc14_;
                  }
                  else
                  {
                     _loc12_ = Number(Math.round(_loc9_._sizePercentInGroup * _loc6_));
                  }
                  _loc9_.setSize(_loc9_._rawWidth + param1,_loc12_,true);
                  _loc14_ = Number(_loc14_ - _loc9_.height);
                  if(_loc4_ == _loc8_)
                  {
                     if(_loc14_ >= 1)
                     {
                        _loc5_ = 0;
                        while(_loc5_ <= _loc8_)
                        {
                           _loc9_ = parent.getChildAt(_loc5_);
                           if(_loc9_.group == this)
                           {
                              if(!_loc15_)
                              {
                                 _loc12_ = Number(_loc9_.height + _loc14_);
                                 if((_loc9_.maxHeight == 0 || _loc12_ < _loc9_.maxHeight) && (_loc9_.minHeight == 0 || _loc12_ > _loc9_.minHeight))
                                 {
                                    _loc9_.setSize(_loc9_.width,_loc12_,true);
                                    _loc15_ = true;
                                 }
                              }
                              else
                              {
                                 _loc9_.y = _loc9_.y + _loc14_;
                              }
                           }
                           _loc5_++;
                        }
                     }
                  }
                  else
                  {
                     _loc11_ = _loc11_ + (_loc9_.height + _lineGap);
                  }
               }
               _loc8_++;
            }
         }
         _updating = _updating & 1;
      }
      
      override protected function updateAlpha() : void
      {
         var _loc3_:int = 0;
         var _loc1_:* = null;
         super.updateAlpha();
         if(this._underConstruct)
         {
            return;
         }
         var _loc2_:int = _parent.numChildren;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = _parent.getChildAt(_loc3_);
            if(_loc1_.group == this)
            {
               _loc1_.alpha = this.alpha;
            }
            _loc3_++;
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
         }
      }
   }
}
