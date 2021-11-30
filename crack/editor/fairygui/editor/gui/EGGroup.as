package fairygui.editor.gui
{
   import fairygui.utils.GTimers;
   
   public class EGGroup extends EGObject
   {
      
      public static const HORIZONTAL:String = "hz";
      
      public static const VERTICAL:String = "vt";
       
      
      private var _empty:Boolean;
      
      private var _advanced:Boolean;
      
      private var _layout:String;
      
      private var _lineGap:int;
      
      private var _columnGap:int;
      
      private var _boundsChanged:Boolean;
      
      private var _percentReady:Boolean;
      
      public var opened:Boolean;
      
      public var needUpdate:Boolean;
      
      public var updating:int;
      
      public var displayCollapsed:Boolean;
      
      public function EGGroup()
      {
         super();
         this.objectType = "group";
         _useSourceSize = false;
         this._layout = "none";
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
            this.updateImmdediately(true);
            if(!this._advanced)
            {
               _internalVisible = true;
               if(parent)
               {
                  parent.updateDisplayList();
               }
            }
            else
            {
               checkGearDisplay();
            }
         }
      }
      
      public function get layout() : String
      {
         return this._layout;
      }
      
      public function set layout(param1:String) : void
      {
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:EGObject = null;
         var _loc2_:* = null;
         if(this._layout != param1)
         {
            this._layout = param1;
            this._percentReady = false;
            if(this._layout == "hz")
            {
               if(this._columnGap == 0)
               {
                  _loc5_ = parent.numChildren;
                  _loc3_ = 0;
                  while(_loc3_ < _loc5_)
                  {
                     _loc4_ = parent.getChildAt(_loc3_);
                     if(_loc4_._group == this)
                     {
                        if(!_loc2_)
                        {
                           _loc2_ = _loc4_;
                        }
                        else
                        {
                           setProperty("columnGap",int(_loc4_.x - _loc2_.x - _loc2_.width));
                           break;
                        }
                     }
                     _loc3_++;
                  }
               }
            }
            else if(this._layout == "vt")
            {
               if(this._lineGap == 0)
               {
                  _loc5_ = parent.numChildren;
                  _loc3_ = 0;
                  while(_loc3_ < _loc5_)
                  {
                     _loc4_ = parent.getChildAt(_loc3_);
                     if(_loc4_._group == this)
                     {
                        if(!_loc2_)
                        {
                           _loc2_ = _loc4_;
                        }
                        else
                        {
                           setProperty("lineGap",int(_loc4_.y - _loc2_.y - _loc2_.height));
                           break;
                        }
                     }
                     _loc3_++;
                  }
               }
            }
            this.updateImmdediately(true);
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
            this.update();
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
            this.update();
         }
      }
      
      public function update(param1:Boolean = false) : void
      {
         if(this.updating != 0 || !parent || !this._advanced && EUIObjectFactory.constructingDepth != 0 || this._advanced && this.underConstruct)
         {
            return;
         }
         if(param1)
         {
            this._percentReady = false;
         }
         if(!this.needUpdate)
         {
            this.needUpdate = true;
            if(!this.opened)
            {
               GTimers.inst.callLater(this.updateImmdediately);
            }
         }
      }
      
      private function updatePercent() : void
      {
         var _loc3_:int = 0;
         var _loc1_:EGObject = null;
         this._percentReady = true;
         var _loc4_:int = parent.numChildren;
         var _loc2_:* = 0;
         if(this._layout == "hz")
         {
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc1_ = parent.getChildAt(_loc3_);
               if(_loc1_._group == this)
               {
                  _loc2_ = Number(_loc2_ + _loc1_.width);
               }
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc1_ = parent.getChildAt(_loc3_);
               if(_loc1_._group == this)
               {
                  if(_loc2_ > 0)
                  {
                     _loc1_.sizePercent = _loc1_.width / _loc2_;
                  }
                  else
                  {
                     _loc1_.sizePercent = 0;
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
               _loc1_ = parent.getChildAt(_loc3_);
               if(_loc1_._group == this)
               {
                  _loc2_ = Number(_loc2_ + _loc1_.height);
               }
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc1_ = parent.getChildAt(_loc3_);
               if(_loc1_._group == this)
               {
                  if(_loc2_ > 0)
                  {
                     _loc1_.sizePercent = _loc1_.height / _loc2_;
                  }
                  else
                  {
                     _loc1_.sizePercent = 0;
                  }
               }
               _loc3_++;
            }
         }
      }
      
      public function updateImmdediately(param1:Boolean = false) : void
      {
         var _loc9_:int = 0;
         var _loc10_:EGObject = null;
         var _loc7_:int = 0;
         this.needUpdate = false;
         if(parent == null)
         {
            return;
         }
         if(this._advanced)
         {
            this.handleLayout(param1);
         }
         var _loc11_:int = parent.numChildren;
         var _loc2_:* = 2147483647;
         var _loc4_:* = 2147483647;
         var _loc8_:* = -2147483648;
         var _loc6_:* = -2147483648;
         var _loc3_:int = 0;
         _loc9_ = 0;
         while(_loc9_ < _loc11_)
         {
            _loc10_ = parent.getChildAt(_loc9_);
            if(_loc10_._group == this)
            {
               _loc7_ = _loc10_.x;
               if(_loc7_ < _loc2_)
               {
                  _loc2_ = _loc7_;
               }
               _loc7_ = _loc10_.y;
               if(_loc7_ < _loc4_)
               {
                  _loc4_ = _loc7_;
               }
               _loc7_ = _loc10_.x + _loc10_.width;
               if(_loc7_ > _loc8_)
               {
                  _loc8_ = _loc7_;
               }
               _loc7_ = _loc10_.y + _loc10_.height;
               if(_loc7_ > _loc6_)
               {
                  _loc6_ = _loc7_;
               }
               _loc3_++;
            }
            _loc9_++;
         }
         this._empty = _loc3_ == 0;
         var _loc5_:Boolean = _settingManually;
         _settingManually = false;
         if(!this._empty)
         {
            this.updating = 1;
            setXY(_loc2_,_loc4_);
            this.updating = 2;
            setSize(_loc8_ - _loc2_,_loc6_ - _loc4_);
         }
         else
         {
            this.updating = 2;
            setSize(0,0);
         }
         this.updating = 0;
         _settingManually = _loc5_;
      }
      
      private function handleLayout(param1:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:EGObject = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc6_:int = parent.numChildren;
         this.updating = this.updating | 1;
         if(this._layout == "hz")
         {
            _loc2_ = NaN;
            _loc4_ = 0;
            while(_loc4_ < _loc6_)
            {
               _loc5_ = parent.getChildAt(_loc4_);
               if(_loc5_._group == this)
               {
                  if(isNaN(_loc2_))
                  {
                     _loc2_ = int(_loc5_.x);
                  }
                  else if(param1)
                  {
                     _loc5_.setProperty("x",_loc2_);
                  }
                  else
                  {
                     _loc5_.x = _loc2_;
                  }
                  if(_loc5_.width != 0)
                  {
                     _loc2_ = _loc2_ + (int(_loc5_.width + this._columnGap));
                  }
               }
               _loc4_++;
            }
            if(!this._percentReady)
            {
               this.updatePercent();
            }
         }
         else if(this._layout == "vt")
         {
            _loc3_ = NaN;
            _loc4_ = 0;
            while(_loc4_ < _loc6_)
            {
               _loc5_ = parent.getChildAt(_loc4_);
               if(_loc5_._group == this)
               {
                  if(isNaN(_loc3_))
                  {
                     _loc3_ = int(_loc5_.y);
                  }
                  else if(param1)
                  {
                     _loc5_.setProperty("y",_loc3_);
                  }
                  else
                  {
                     _loc5_.y = _loc3_;
                  }
                  if(_loc5_.height != 0)
                  {
                     _loc3_ = _loc3_ + (int(_loc5_.height + this._lineGap));
                  }
               }
               _loc4_++;
            }
            if(!this._percentReady)
            {
               this.updatePercent();
            }
         }
         this.updating = this.updating & 2;
      }
      
      public function moveChildren(param1:Number, param2:Number) : void
      {
         var _loc5_:int = 0;
         var _loc3_:EGObject = null;
         if((this.updating & 1) != 0 || !parent)
         {
            return;
         }
         this.updating = this.updating | 1;
         var _loc4_:int = parent.numChildren;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = parent.getChildAt(_loc5_);
            if(_loc3_._group == this)
            {
               _loc3_.setXY(_loc3_.x + param1,_loc3_.y + param2);
            }
            _loc5_++;
         }
         this.updating = this.updating & 2;
      }
      
      public function resizeChildren(param1:Number, param2:Number) : void
      {
         var _loc9_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:EGObject = null;
         var _loc5_:Number = NaN;
         var _loc7_:* = NaN;
         var _loc3_:Number = NaN;
         var _loc10_:* = NaN;
         if((this.updating & 2) != 0 || !parent)
         {
            return;
         }
         var _loc8_:int = parent.numChildren;
         var _loc15_:int = 0;
         var _loc13_:* = -1;
         var _loc14_:* = 0;
         var _loc4_:* = 0;
         var _loc6_:Boolean = false;
         _loc9_ = 0;
         while(_loc9_ < _loc8_)
         {
            _loc12_ = parent.getChildAt(_loc9_);
            if(_loc12_._group == this)
            {
               _loc13_ = _loc9_;
               _loc15_++;
            }
            _loc9_++;
         }
         if(_loc15_ == 0)
         {
            return;
         }
         this.updating = this.updating | 2;
         if(this._layout == "hz")
         {
            if(!this._percentReady)
            {
               this.updatePercent();
            }
            _loc14_ = Number(this.width - (_loc15_ - 1) * this._columnGap);
            _loc4_ = Number(this.width - (_loc15_ - 1) * this._columnGap);
            _loc5_ = NaN;
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc12_ = parent.getChildAt(_loc9_);
               if(_loc12_._group == this)
               {
                  if(isNaN(_loc5_))
                  {
                     _loc5_ = int(_loc12_.x);
                  }
                  else
                  {
                     _loc12_.x = _loc5_;
                  }
                  if(_loc13_ == _loc9_)
                  {
                     _loc7_ = _loc4_;
                  }
                  else
                  {
                     _loc7_ = Number(Math.round(_loc12_.sizePercent * _loc14_));
                  }
                  _loc12_.setSize(_loc7_,_loc12_._rawHeight + param2,true,true);
                  _loc4_ = Number(_loc4_ - _loc12_.width);
                  if(_loc13_ == _loc9_)
                  {
                     if(_loc4_ > 0)
                     {
                        _loc11_ = 0;
                        while(_loc11_ <= _loc9_)
                        {
                           _loc12_ = parent.getChildAt(_loc11_);
                           if(_loc12_._group == this)
                           {
                              if(!_loc6_)
                              {
                                 _loc7_ = Number(_loc12_.width + _loc4_);
                                 if((_loc12_.maxWidth == 0 || _loc7_ < _loc12_.maxWidth) && (_loc12_.minWidth == 0 || _loc7_ > _loc12_.minWidth))
                                 {
                                    _loc12_.setSize(_loc7_,_loc12_.height,true,true);
                                    _loc6_ = true;
                                 }
                              }
                              else
                              {
                                 _loc12_.x = _loc12_.x + _loc4_;
                              }
                           }
                           _loc11_++;
                        }
                     }
                  }
                  else
                  {
                     _loc5_ = _loc5_ + (_loc12_.width + this._columnGap);
                  }
               }
               _loc9_++;
            }
         }
         else if(this._layout == "vt")
         {
            if(!this._percentReady)
            {
               this.updatePercent();
            }
            _loc14_ = Number(this.height - (_loc15_ - 1) * this._lineGap);
            _loc4_ = Number(this.height - (_loc15_ - 1) * this._lineGap);
            _loc3_ = NaN;
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc12_ = parent.getChildAt(_loc9_);
               if(_loc12_._group == this)
               {
                  if(isNaN(_loc3_))
                  {
                     _loc3_ = int(_loc12_.y);
                  }
                  else
                  {
                     _loc12_.y = _loc3_;
                  }
                  if(_loc13_ == _loc9_)
                  {
                     _loc10_ = _loc4_;
                  }
                  else
                  {
                     _loc10_ = Number(Math.round(_loc12_.sizePercent * _loc14_));
                  }
                  _loc12_.setSize(_loc12_._rawWidth + param1,_loc10_,true,true);
                  _loc4_ = Number(_loc4_ - _loc12_.height);
                  if(_loc13_ == _loc9_)
                  {
                     if(_loc4_ > 0)
                     {
                        _loc11_ = 0;
                        while(_loc11_ <= _loc9_)
                        {
                           _loc12_ = parent.getChildAt(_loc11_);
                           if(_loc12_._group == this)
                           {
                              if(!_loc6_)
                              {
                                 _loc10_ = Number(_loc12_.height + _loc4_);
                                 if((_loc12_.maxHeight == 0 || _loc10_ < _loc12_.maxHeight) && (_loc12_.minHeight == 0 || _loc10_ > _loc12_.minHeight))
                                 {
                                    _loc12_.setSize(_loc12_.width,_loc10_,true,true);
                                    _loc6_ = true;
                                 }
                              }
                              else
                              {
                                 _loc12_.y = _loc12_.y + _loc4_;
                              }
                           }
                           _loc11_++;
                        }
                     }
                  }
                  else
                  {
                     _loc3_ = _loc3_ + (_loc12_.height + this._lineGap);
                  }
               }
               _loc9_++;
            }
         }
         else
         {
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc12_ = parent.getChildAt(_loc9_);
               if(_loc12_._group == this)
               {
                  _loc12_.setSize(_loc12_._rawWidth + param1,_loc12_._rawHeight + param2,true,true);
               }
               _loc9_++;
            }
         }
         this.updating = this.updating & 1;
      }
      
      public function get empty() : Boolean
      {
         return this._empty;
      }
      
      override protected function updateAlpha() : void
      {
         var _loc2_:int = 0;
         var _loc1_:EGObject = null;
         super.updateAlpha();
         if(this.underConstruct)
         {
            return;
         }
         var _loc3_:int = parent.numChildren;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = parent.getChildAt(_loc2_);
            if(_loc1_._group == this)
            {
               _loc1_.alpha = this.alpha;
            }
            _loc2_++;
         }
      }
      
      override public function handleControllerChanged(param1:EController) : void
      {
         if(this._advanced)
         {
            super.handleControllerChanged(param1);
         }
      }
      
      override public function fromXML_beforeAdd(param1:XML) : void
      {
         var _loc2_:String = null;
         super.fromXML_beforeAdd(param1);
         this._advanced = param1.@advanced == "true";
         this.displayCollapsed = param1.@collapsed == "true";
         if(this._advanced)
         {
            _loc2_ = param1.@layout;
            if(_loc2_)
            {
               this._layout = _loc2_;
            }
            _loc2_ = param1.@lineGap;
            if(_loc2_)
            {
               this._lineGap = parseInt(_loc2_);
            }
            else
            {
               this._lineGap = 0;
            }
            _loc2_ = param1.@colGap;
            if(_loc2_)
            {
               this._columnGap = parseInt(_loc2_);
            }
            else
            {
               this._columnGap = 0;
            }
         }
      }
      
      override public function toXML() : XML
      {
         var _loc1_:XML = super.toXML();
         if(this._advanced)
         {
            _loc1_.@advanced = "true";
         }
         if(this.displayCollapsed)
         {
            _loc1_.@collapsed = "true";
         }
         if(this._advanced && this._layout != "none")
         {
            _loc1_.@layout = this._layout;
            if(this._lineGap != 0)
            {
               _loc1_.@lineGap = this._lineGap;
            }
            if(this._columnGap != 0)
            {
               _loc1_.@colGap = this._columnGap;
            }
         }
         return _loc1_;
      }
   }
}
