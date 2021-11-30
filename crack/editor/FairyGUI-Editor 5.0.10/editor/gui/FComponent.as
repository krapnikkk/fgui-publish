package fairygui.editor.gui
{
   import fairygui.editor.Consts;
   import fairygui.editor.settings.Preferences;
   import fairygui.utils.GTimers;
   import fairygui.utils.ToolSet;
   import fairygui.utils.UtilsStr;
   import fairygui.utils.XData;
   import fairygui.utils.XDataEnumerator;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class FComponent extends FObject
   {
       
      
      public var customExtentionId:String;
      
      public var initName:String;
      
      public var designImage:String;
      
      public var designImageOffsetX:int;
      
      public var designImageOffsetY:int;
      
      public var designImageAlpha:int;
      
      public var designImageLayer:int;
      
      public var designImageForTest:Boolean;
      
      public var bgColor:uint;
      
      public var bgColorEnabled:Boolean;
      
      public var hitTestSource:FObject;
      
      public var mask:FObject;
      
      public var reversedMask:Boolean;
      
      public var remark:String;
      
      protected var _children:Vector.<FObject>;
      
      protected var _controllers:Vector.<FController>;
      
      protected var _transitions:FTransitions;
      
      protected var _instNextId:uint;
      
      protected var _dislayListChanged:Boolean;
      
      protected var _bounds:Rectangle;
      
      protected var _boundsChanged:Boolean;
      
      protected var _applyingController:FController;
      
      protected var _extentionId:String;
      
      protected var _extention:ComExtention;
      
      protected var _overflow:String;
      
      protected var _scroll:String;
      
      protected var _opaque:Boolean;
      
      protected var _margin:FMargin;
      
      protected var _clipSoftnessX:int;
      
      protected var _clipSoftnessY:int;
      
      protected var _scrollBarDisplay:String;
      
      protected var _scrollBarFlags:int;
      
      protected var _scrollBarMargin:FMargin;
      
      protected var _hzScrollBarRes:String;
      
      protected var _vtScrollBarRes:String;
      
      protected var _headerRes:String;
      
      protected var _footerRes:String;
      
      protected var _childrenRenderOrder:String;
      
      protected var _apexIndex:int;
      
      protected var _pageController:FController;
      
      protected var _scrollPane:FScrollPane;
      
      protected var _customProperties:Vector.<ComProperty>;
      
      public var _alignOffset:Point;
      
      public var _buildingDisplayList:Boolean;
      
      public function FComponent()
      {
         super();
         this._objectType = FObjectType.COMPONENT;
         this._children = new Vector.<FObject>();
         this._controllers = new Vector.<FController>();
         this._overflow = OverflowConst.VISIBLE;
         this._scroll = ScrollConst.VERTICAL;
         this._scrollBarDisplay = ScrollBarDisplayConst.DEFAULT;
         this._bounds = new Rectangle();
         this._margin = new FMargin();
         this._scrollBarMargin = new FMargin();
         this.initName = "";
         this.designImage = "";
         this.designImageAlpha = 50;
         this.bgColor = 16777215;
         this._opaque = true;
         this._transitions = new FTransitions(this);
         this._alignOffset = new Point();
         this._childrenRenderOrder = "ascent";
         this._customProperties = new Vector.<ComProperty>();
      }
      
      public function addChild(param1:FObject) : FObject
      {
         this.addChildAt(param1,this._children.length);
         return param1;
      }
      
      public function addChildAt(param1:FObject, param2:int) : FObject
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:FObject = null;
         var _loc10_:int = 0;
         var _loc3_:int = this._children.length;
         if(!param1._id)
         {
            param1._id = this.getNextId();
         }
         if(!param1.name && (param1._flags & FObjectFlags.INSPECTING) != 0)
         {
            if(Preferences.meaningfullChildName)
            {
               _loc4_ = FObjectType.NAME_PREFIX[param1._objectType];
               if(!_loc4_)
               {
                  param1.name = UtilsStr.getNameFromId(param1._id);
               }
               else
               {
                  if(param1 is FComponent && FComponent(param1).extentionId)
                  {
                     _loc8_ = FObjectType.NAME_PREFIX[FComponent(param1).extentionId];
                     if(_loc8_)
                     {
                        _loc4_ = _loc8_;
                     }
                  }
                  _loc5_ = _loc4_.length;
                  _loc6_ = 0;
                  _loc7_ = 0;
                  while(_loc7_ < _loc3_)
                  {
                     _loc9_ = this._children[_loc7_];
                     if(UtilsStr.startsWith(_loc9_.name,_loc4_))
                     {
                        _loc10_ = parseInt(_loc9_.name.substr(_loc5_));
                        if(_loc10_ >= _loc6_)
                        {
                           _loc6_ = _loc10_ + 1;
                        }
                     }
                     _loc7_++;
                  }
                  param1.name = _loc4_ + _loc6_;
               }
            }
            else
            {
               param1.name = UtilsStr.getNameFromId(param1._id);
            }
         }
         if(param2 >= 0 && param2 <= _loc3_)
         {
            param1.removeFromParent();
            param1._parent = this;
            if(param2 == _loc3_)
            {
               this._children.push(param1);
            }
            else
            {
               this._children.splice(param2,0,param1);
            }
            if(param1.internalVisible)
            {
               this.updateDisplayList();
            }
            if(param1._group)
            {
               param1._group._childrenDirty = true;
               param1._group.refresh();
            }
            this.setBoundsChangedFlag();
            return param1;
         }
         throw new RangeError("Invalid child index");
      }
      
      public function removeChild(param1:FObject, param2:Boolean = false) : FObject
      {
         var _loc3_:int = this.getChildIndex(param1);
         if(_loc3_ != -1)
         {
            this.removeChildAt(_loc3_,param2);
         }
         return param1;
      }
      
      public function removeChildAt(param1:int, param2:Boolean = false) : FObject
      {
         var _loc3_:FObject = null;
         if(param1 >= 0 && param1 < this.numChildren)
         {
            _loc3_ = this._children[param1];
            _loc3_._parent = null;
            _loc3_.dispatcher.emit(_loc3_,REMOVED);
            this._children.splice(param1,1);
            if(_loc3_.displayObject.parent)
            {
               _displayObject.container.removeChild(_loc3_.displayObject);
               if(this._childrenRenderOrder == "arch")
               {
                  this.updateDisplayList();
               }
            }
            if(_loc3_._group)
            {
               _loc3_._group._childrenDirty = true;
               _loc3_._group.refresh();
            }
            if(_loc3_ is FGroup)
            {
               FGroup(_loc3_).freeChildrenArray();
            }
            this.setBoundsChangedFlag();
            if(param2)
            {
               _loc3_.dispose();
            }
            return _loc3_;
         }
         throw new RangeError("Invalid child index");
      }
      
      public function removeChildren(param1:int = 0, param2:int = -1, param3:Boolean = false) : void
      {
         if(param2 < 0 || param2 >= this.numChildren)
         {
            param2 = this.numChildren - 1;
         }
         var _loc4_:int = param1;
         while(_loc4_ <= param2)
         {
            this.removeChildAt(param1,param3);
            _loc4_++;
         }
      }
      
      public function getChildAt(param1:int) : FObject
      {
         if(param1 >= 0 && param1 < this.numChildren)
         {
            return this._children[param1];
         }
         throw new RangeError("Invalid child index");
      }
      
      public function getChild(param1:String) : FObject
      {
         var _loc2_:int = this._children.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._children[_loc3_].name == param1)
            {
               return this._children[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getChildByPath(param1:String) : FObject
      {
         var _loc5_:FObject = null;
         var _loc2_:Array = param1.split(".");
         var _loc3_:int = _loc2_.length;
         var _loc4_:FComponent = this;
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_)
         {
            _loc5_ = _loc4_.getChild(_loc2_[_loc6_]);
            if(!_loc5_)
            {
               break;
            }
            if(_loc6_ != _loc3_ - 1)
            {
               _loc4_ = _loc5_ as FComponent;
               if(!_loc4_)
               {
                  _loc5_ = null;
                  break;
               }
            }
            _loc6_++;
         }
         return _loc5_;
      }
      
      public function getChildById(param1:String) : FObject
      {
         var _loc2_:int = this._children.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._children[_loc3_]._id == param1)
            {
               return this._children[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getChildIndex(param1:FObject) : int
      {
         return this._children.indexOf(param1);
      }
      
      public function setChildIndex(param1:FObject, param2:int) : void
      {
         var _loc3_:int = this.getChildIndex(param1);
         if(_loc3_ == -1)
         {
            throw new ArgumentError("Not a child of this container");
         }
         this._children.splice(_loc3_,1);
         this._children.splice(param2,0,param1);
         if(param1._group)
         {
            param1._group._childrenDirty = true;
         }
         this.updateDisplayList();
         this.setBoundsChangedFlag();
      }
      
      public function swapChildren(param1:FObject, param2:FObject) : void
      {
         var _loc3_:int = this._children.indexOf(param1);
         var _loc4_:int = this._children.indexOf(param2);
         if(_loc3_ == -1 || _loc4_ == -1)
         {
            throw new ArgumentError("Not a child of this container");
         }
         this.swapChildrenAt(_loc3_,_loc4_);
      }
      
      public function swapChildrenAt(param1:int, param2:int) : void
      {
         var _loc3_:FObject = this._children[param1];
         var _loc4_:FObject = this._children[param2];
         this._children[param1] = _loc4_;
         this._children[param2] = _loc3_;
         if(_loc3_._group)
         {
            _loc3_._group._childrenDirty = true;
         }
         if(_loc4_._group)
         {
            _loc4_._group._childrenDirty = true;
         }
         this.updateDisplayList();
      }
      
      public function get numChildren() : int
      {
         return this._children.length;
      }
      
      public function get children() : Vector.<FObject>
      {
         return this._children;
      }
      
      public function addController(param1:FController, param2:Boolean = true) : void
      {
         this._controllers.push(param1);
         param1.parent = this;
         if(param2)
         {
            this.applyController(param1);
         }
      }
      
      public function getController(param1:String) : FController
      {
         var _loc2_:int = this._controllers.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._controllers[_loc3_].name == param1)
            {
               return this._controllers[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function removeController(param1:FController) : void
      {
         var _loc2_:int = this._controllers.indexOf(param1);
         if(_loc2_ == -1)
         {
            throw new Error("controller not found");
         }
         param1.parent = null;
         this._controllers.splice(_loc2_,1);
         var _loc3_:int = this._children.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            this._children[_loc4_].handleControllerChanged(param1);
            _loc4_++;
         }
      }
      
      public function get controllers() : Vector.<FController>
      {
         return this._controllers;
      }
      
      public function updateChildrenVisible() : void
      {
         var _loc2_:int = 0;
         var _loc3_:FObject = null;
         var _loc1_:int = this._children.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._children[_loc2_];
            _loc3_.handleVisibleChanged();
            _loc2_++;
         }
      }
      
      public function updateDisplayList(param1:Boolean = false) : void
      {
         var _loc4_:int = 0;
         var _loc5_:FObject = null;
         var _loc7_:int = 0;
         if(!param1)
         {
            if(!this._dislayListChanged)
            {
               this._dislayListChanged = true;
               GTimers.inst.callLater(this.delayUpdate);
            }
            return;
         }
         this._dislayListChanged = false;
         var _loc2_:Boolean = false;
         if(docElement)
         {
            _loc2_ = docElement.owner.getVar("showAllInvisibles");
         }
         var _loc3_:int = this._children.length;
         var _loc6_:Sprite = _displayObject.container;
         switch(this._childrenRenderOrder)
         {
            case "ascent":
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  _loc5_ = this._children[_loc4_];
                  if(_loc2_ || _loc5_.internalVisible)
                  {
                     _loc6_.addChild(_loc5_.displayObject);
                  }
                  else if(_loc5_.displayObject.parent)
                  {
                     _loc5_.displayObject.parent.removeChild(_loc5_.displayObject);
                  }
                  _loc4_++;
               }
               break;
            case "descent":
               _loc4_ = _loc3_ - 1;
               while(_loc4_ >= 0)
               {
                  _loc5_ = this._children[_loc4_];
                  if(_loc2_ || _loc5_.internalVisible)
                  {
                     _loc6_.addChild(_loc5_.displayObject);
                  }
                  else if(_loc5_.displayObject.parent)
                  {
                     _loc5_.displayObject.parent.removeChild(_loc5_.displayObject);
                  }
                  _loc4_--;
               }
               break;
            case "arch":
               _loc7_ = ToolSet.clamp(this._apexIndex,0,_loc3_);
               _loc4_ = 0;
               while(_loc4_ < _loc7_)
               {
                  _loc5_ = this._children[_loc4_];
                  if(_loc2_ || _loc5_.internalVisible)
                  {
                     _loc6_.addChild(_loc5_.displayObject);
                  }
                  else if(_loc5_.displayObject.parent)
                  {
                     _loc5_.displayObject.parent.removeChild(_loc5_.displayObject);
                  }
                  _loc4_++;
               }
               _loc4_ = _loc3_ - 1;
               while(_loc4_ >= _loc7_)
               {
                  _loc5_ = this._children[_loc4_];
                  if(_loc2_ || _loc5_.internalVisible)
                  {
                     _loc6_.addChild(_loc5_.displayObject);
                  }
                  else if(_loc5_.displayObject.parent)
                  {
                     _loc5_.displayObject.parent.removeChild(_loc5_.displayObject);
                  }
                  _loc4_--;
               }
         }
         if(FObjectFlags.isDocRoot(_flags))
         {
            this.renderOpenedChildren();
         }
      }
      
      private function renderOpenedChildren() : void
      {
         var _loc1_:FObject = null;
         var _loc3_:int = 0;
         var _loc4_:FObject = null;
         var _loc8_:FSprite = null;
         var _loc9_:int = 0;
         var _loc2_:int = 0;
         var _loc5_:int = this._children.length;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc4_ = this._children[_loc3_];
            if(_loc4_._group == null && _loc4_._opened)
            {
               _loc1_ = _loc4_;
            }
            _loc4_._renderDepth = 0;
            _loc3_++;
         }
         if(_loc1_)
         {
            if(_loc1_ is FGroup)
            {
               _loc2_ = this.updateGroupChildrenDepth(FGroup(_loc1_),1);
            }
            else
            {
               _loc1_._renderDepth = _loc2_ = 1;
            }
         }
         var _loc6_:Sprite = _displayObject.container;
         _loc5_ = _loc6_.numChildren;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc8_ = _loc6_.getChildAt(_loc3_) as FSprite;
            if(_loc8_)
            {
               _loc8_.alpha = _loc8_.owner._renderDepth < _loc2_?Number(0.3):Number(1);
            }
            _loc3_++;
         }
         var _loc7_:int = 1;
         while(_loc7_ <= _loc2_)
         {
            _loc3_ = 0;
            _loc9_ = _loc5_;
            while(_loc3_ < _loc9_)
            {
               _loc8_ = _loc6_.getChildAt(_loc3_) as FSprite;
               if(_loc8_ && _loc8_.owner._renderDepth == _loc7_)
               {
                  _loc6_.addChild(_loc8_);
                  _loc9_--;
               }
               else
               {
                  _loc3_++;
               }
            }
            _loc7_++;
         }
      }
      
      private function updateGroupChildrenDepth(param1:FGroup, param2:int) : int
      {
         var _loc5_:FObject = null;
         var _loc7_:FObject = null;
         var _loc3_:Vector.<FObject> = param1.children;
         var _loc4_:int = _loc3_.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = _loc3_[_loc6_];
            _loc7_._renderDepth = param2;
            if(_loc7_._opened)
            {
               _loc5_ = _loc7_;
            }
            else if(_loc7_ is FGroup)
            {
               this.updateGroupChildrenDepth(FGroup(_loc7_),param2);
            }
            _loc6_++;
         }
         if(_loc5_)
         {
            param2++;
            if(_loc5_ is FGroup)
            {
               param2 = this.updateGroupChildrenDepth(FGroup(_loc5_),param2);
            }
            else
            {
               _loc5_._renderDepth = param2;
            }
         }
         return param2;
      }
      
      private function delayUpdate() : void
      {
         if(_disposed)
         {
            return;
         }
         if(this._dislayListChanged)
         {
            this.updateDisplayList(true);
         }
         if(this._boundsChanged)
         {
            this.updateBounds();
         }
      }
      
      public function getSnappingPosition(param1:Number, param2:Number, param3:Point = null) : Point
      {
         if(!param3)
         {
            param3 = new Point();
         }
         var _loc4_:int = this._children.length;
         if(_loc4_ == 0)
         {
            param3.x = param1;
            param3.y = param2;
            return param3;
         }
         this.ensureBoundsCorrect();
         var _loc5_:FObject = null;
         var _loc6_:FObject = null;
         var _loc7_:int = 0;
         if(param2 != 0)
         {
            while(_loc7_ < _loc4_)
            {
               _loc5_ = this._children[_loc7_];
               if(param2 < _loc5_.y)
               {
                  if(_loc7_ == 0)
                  {
                     param2 = 0;
                     break;
                  }
                  _loc6_ = this._children[_loc7_ - 1];
                  if(param2 < _loc6_.y + _loc6_.height / 2)
                  {
                     param2 = _loc6_.y;
                  }
                  else
                  {
                     param2 = _loc5_.y;
                  }
                  break;
               }
               _loc7_++;
            }
            if(_loc7_ == _loc4_)
            {
               param2 = _loc5_.y;
            }
         }
         if(param1 != 0)
         {
            if(_loc7_ > 0)
            {
               _loc7_--;
            }
            while(_loc7_ < _loc4_)
            {
               _loc5_ = this._children[_loc7_];
               if(param1 < _loc5_.x)
               {
                  if(_loc7_ == 0)
                  {
                     param1 = 0;
                     break;
                  }
                  _loc6_ = this._children[_loc7_ - 1];
                  if(param1 < _loc6_.x + _loc6_.width / 2)
                  {
                     param1 = _loc6_.x;
                  }
                  else
                  {
                     param1 = _loc5_.x;
                  }
                  break;
               }
               _loc7_++;
            }
            if(_loc7_ == _loc4_)
            {
               param1 = _loc5_.x;
            }
         }
         param3.x = param1;
         param3.y = param2;
         return param3;
      }
      
      public function ensureBoundsCorrect() : void
      {
         if(this._boundsChanged)
         {
            this.updateBounds();
         }
      }
      
      public function get bounds() : Rectangle
      {
         return this._bounds;
      }
      
      function setBoundsChangedFlag() : void
      {
         if(!this._boundsChanged)
         {
            this._boundsChanged = true;
            GTimers.inst.callLater(this.delayUpdate);
         }
      }
      
      protected function updateBounds() : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:FObject = null;
         var _loc1_:int = this._children.length;
         if(_loc1_ == 0)
         {
            this.setBounds(0,0,0,0);
            return;
         }
         var _loc2_:int = int.MAX_VALUE;
         var _loc3_:int = int.MAX_VALUE;
         var _loc4_:int = int.MIN_VALUE;
         var _loc5_:int = int.MIN_VALUE;
         _loc7_ = 0;
         while(_loc7_ < _loc1_)
         {
            _loc8_ = this._children[_loc7_];
            _loc6_ = _loc8_.x;
            if(_loc6_ < _loc2_)
            {
               _loc2_ = _loc6_;
            }
            _loc6_ = _loc8_.y;
            if(_loc6_ < _loc3_)
            {
               _loc3_ = _loc6_;
            }
            _loc6_ = _loc8_.x + _loc8_.actualWidth;
            if(_loc6_ > _loc4_)
            {
               _loc4_ = _loc6_;
            }
            _loc6_ = _loc8_.y + _loc8_.actualHeight;
            if(_loc6_ > _loc5_)
            {
               _loc5_ = _loc6_;
            }
            _loc7_++;
         }
         this.setBounds(_loc2_,_loc3_,_loc4_ - _loc2_,_loc5_ - _loc3_);
      }
      
      public function getBounds() : Rectangle
      {
         if(this._boundsChanged)
         {
            this.updateBounds();
         }
         return this._bounds.clone();
      }
      
      public function setBounds(param1:int, param2:int, param3:int, param4:int) : void
      {
         this._boundsChanged = false;
         this._bounds.x = param1;
         this._bounds.y = param2;
         this._bounds.width = param3;
         this._bounds.height = param4;
         if(this._scrollPane)
         {
            this._scrollPane.setContentSize(this._bounds.x + this._bounds.width,this._bounds.y + this._bounds.height);
         }
      }
      
      public function applyController(param1:FController) : void
      {
         var _loc3_:int = 0;
         var _loc4_:FObject = null;
         this._applyingController = param1;
         var _loc2_:int = this._children.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._children[_loc3_];
            _loc4_.handleControllerChanged(param1);
            _loc3_++;
         }
         param1.runActions();
         this._applyingController = null;
         if(this._dislayListChanged)
         {
            this.updateDisplayList(true);
         }
      }
      
      public function applyAllControllers() : void
      {
         var _loc3_:FController = null;
         var _loc1_:int = this._controllers.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._controllers[_loc2_];
            this.applyController(_loc3_);
            _loc2_++;
         }
      }
      
      public function adjustRadioGroupDepth(param1:FObject, param2:FController) : void
      {
         var _loc4_:int = 0;
         var _loc5_:FObject = null;
         var _loc3_:int = this._children.length;
         var _loc6_:int = -1;
         var _loc7_:int = -1;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._children[_loc4_];
            if(_loc5_ == param1)
            {
               _loc6_ = _loc4_;
            }
            else if(_loc5_ is FComponent && FComponent(_loc5_)._extention is FButton && FButton(FComponent(_loc5_)._extention).controllerObj == param2)
            {
               if(_loc4_ > _loc7_)
               {
                  _loc7_ = _loc4_;
               }
            }
            _loc4_++;
         }
         if(_loc6_ < _loc7_)
         {
            if(this._applyingController != null)
            {
               this._children[_loc7_].handleControllerChanged(this._applyingController);
            }
            this.swapChildrenAt(_loc6_,_loc7_);
         }
      }
      
      override public function handleSizeChanged() : void
      {
         super.handleSizeChanged();
         if(_displayObject.container.scrollRect)
         {
            this.updateClipRect();
         }
         if(this._scrollPane && this._scrollPane.installed)
         {
            this._scrollPane.OnOwnerSizeChanged();
         }
      }
      
      override public function handleControllerChanged(param1:FController) : void
      {
         super.handleControllerChanged(param1);
         if(this._extention)
         {
            this._extention.handleControllerChanged(param1);
         }
         if(this._pageController == param1 && this._scrollPane && this._scrollPane.installed)
         {
            this._scrollPane.handleControllerChanged(param1);
         }
      }
      
      override public function handleGrayedChanged() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:FObject = null;
         if(this._extention is FButton)
         {
            if(FButton(this._extention).handleGrayChanged())
            {
               return;
            }
         }
         var _loc1_:FController = this.getController("grayed");
         if(_loc1_ != null)
         {
            _loc2_ = this._children.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = this._children[_loc3_];
               if(!_loc4_.checkGearController(3,_loc1_))
               {
                  this._children[_loc3_].grayed = false;
               }
               _loc3_++;
            }
            _loc1_.selectedIndex = !!this.grayed?1:0;
            return;
         }
         _loc2_ = this._children.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this._children[_loc3_].grayed = this.grayed;
            _loc3_++;
         }
      }
      
      public function get extention() : ComExtention
      {
         return this._extention;
      }
      
      public function get extentionId() : String
      {
         return this._extentionId;
      }
      
      public function set extentionId(param1:String) : void
      {
         if(this._extentionId != param1)
         {
            if(this._extention)
            {
               this._extention.dispose();
            }
            if(param1 == "")
            {
               param1 = null;
            }
            this._extentionId = param1;
            if(this._extentionId)
            {
               this._extention = FObjectFactory.newExtention(_pkg,this._extentionId);
               if(this._extention)
               {
                  this._extention.owner = this;
                  this._extention.create();
               }
            }
            else
            {
               this._extention = null;
            }
         }
      }
      
      public function get scrollPane() : FScrollPane
      {
         return this._scrollPane;
      }
      
      public function get overflow() : String
      {
         return this._overflow;
      }
      
      public function set overflow(param1:String) : void
      {
         if(this._overflow != param1)
         {
            this._overflow = param1;
            this.updateOverflow();
         }
      }
      
      public function get overflow2() : String
      {
         if(this._overflow == "scroll")
         {
            return "scroll-" + this.scroll;
         }
         return this._overflow;
      }
      
      public function set overflow2(param1:String) : void
      {
         if(UtilsStr.startsWith(param1,"scroll-"))
         {
            this._scroll = param1.substr(7);
            this._overflow = "scroll";
            this.updateOverflow();
         }
         else
         {
            this.overflow = param1;
         }
      }
      
      public function get scroll() : String
      {
         return this._scroll;
      }
      
      public function set scroll(param1:String) : void
      {
         if(this._scroll != param1)
         {
            this._scroll = param1;
            this.updateOverflow();
         }
      }
      
      public function get scrollBarFlags() : int
      {
         return this._scrollBarFlags;
      }
      
      public function set scrollBarFlags(param1:int) : void
      {
         if(this._scrollBarFlags != param1)
         {
            this._scrollBarFlags = param1;
            this.onScrollFlagsChanged();
         }
      }
      
      public function get scrollBarDisplay() : String
      {
         return this._scrollBarDisplay;
      }
      
      public function set scrollBarDisplay(param1:String) : void
      {
         if(this._scrollBarDisplay != param1)
         {
            this._scrollBarDisplay = param1;
            this.updateOverflow();
         }
      }
      
      public function get margin() : FMargin
      {
         return this._margin;
      }
      
      public function get marginStr() : String
      {
         return this._margin.toString();
      }
      
      public function set marginStr(param1:String) : void
      {
         this._margin.parse(param1);
         this.updateOverflow();
         this.setBoundsChangedFlag();
         this.handleSizeChanged();
      }
      
      public function get scrollBarMargin() : FMargin
      {
         return this._scrollBarMargin;
      }
      
      public function get scrollBarMarginStr() : String
      {
         return this._scrollBarMargin.toString();
      }
      
      public function set scrollBarMarginStr(param1:String) : void
      {
         this._scrollBarMargin.parse(param1);
         this.onScrollFlagsChanged();
      }
      
      public function get hzScrollBarRes() : String
      {
         return this._hzScrollBarRes;
      }
      
      public function set hzScrollBarRes(param1:String) : void
      {
         this._hzScrollBarRes = param1;
         if(this._scrollPane)
         {
            this._scrollPane.onFlagsChanged(true);
         }
      }
      
      public function get vtScrollBarRes() : String
      {
         return this._vtScrollBarRes;
      }
      
      public function set vtScrollBarRes(param1:String) : void
      {
         this._vtScrollBarRes = param1;
         this.onScrollFlagsChanged();
      }
      
      public function get headerRes() : String
      {
         return this._headerRes;
      }
      
      public function set headerRes(param1:String) : void
      {
         this._headerRes = param1;
      }
      
      public function get footerRes() : String
      {
         return this._footerRes;
      }
      
      public function set footerRes(param1:String) : void
      {
         this._footerRes = param1;
      }
      
      public function get clipSoftnessX() : int
      {
         return this._clipSoftnessX;
      }
      
      public function get clipSoftnessY() : int
      {
         return this._clipSoftnessY;
      }
      
      public function set clipSoftnessX(param1:int) : void
      {
         this._clipSoftnessX = param1;
      }
      
      public function set clipSoftnessY(param1:int) : void
      {
         this._clipSoftnessY = param1;
      }
      
      public function get viewWidth() : Number
      {
         if(this._scrollPane && this._scrollPane.installed)
         {
            return this._scrollPane.viewWidth;
         }
         return this.width - this._margin.left - this._margin.right;
      }
      
      public function get viewHeight() : Number
      {
         if(this._scrollPane && this._scrollPane.installed)
         {
            return this._scrollPane.viewHeight;
         }
         return this.height - this._margin.top - this._margin.bottom;
      }
      
      public function set viewWidth(param1:Number) : void
      {
         if(this._scrollPane && this._scrollPane.installed)
         {
            this._scrollPane.viewWidth = param1;
         }
         else
         {
            this.width = param1 + this._margin.left + this._margin.right;
         }
      }
      
      public function set viewHeight(param1:Number) : void
      {
         if(this._scrollPane && this._scrollPane.installed)
         {
            this._scrollPane.viewHeight = param1;
         }
         else
         {
            this.height = param1 + this._margin.top + this._margin.bottom;
         }
      }
      
      public function get transitions() : FTransitions
      {
         return this._transitions;
      }
      
      public function get opaque() : Boolean
      {
         return this._opaque;
      }
      
      public function set opaque(param1:Boolean) : void
      {
         if(this._opaque != param1)
         {
            this._opaque = param1;
            this.handleSizeChanged();
         }
      }
      
      override public final function get text() : String
      {
         if(this._extention != null)
         {
            return this._extention.title;
         }
         return "";
      }
      
      override public function set text(param1:String) : void
      {
         if(this._extention != null)
         {
            this._extention.title = param1;
         }
      }
      
      override public final function get icon() : String
      {
         if(this._extention != null)
         {
            return this._extention.icon;
         }
         return "";
      }
      
      override public function set icon(param1:String) : void
      {
         if(this._extention != null)
         {
            this._extention.icon = param1;
         }
      }
      
      override public function getProp(param1:int) : *
      {
         var _loc2_:* = undefined;
         if(this._extention)
         {
            _loc2_ = this._extention.getProp(param1);
            if(_loc2_ != undefined)
            {
               return _loc2_;
            }
         }
         return super.getProp(param1);
      }
      
      override public function setProp(param1:int, param2:*) : void
      {
         if(this._extention)
         {
            this._extention.setProp(param1,param2);
         }
         else
         {
            super.setProp(param1,param2);
         }
      }
      
      public function get childrenRenderOrder() : String
      {
         return this._childrenRenderOrder;
      }
      
      public function set childrenRenderOrder(param1:String) : void
      {
         if(this._childrenRenderOrder != param1)
         {
            this._childrenRenderOrder = param1;
            this.updateDisplayList();
         }
      }
      
      public function get apexIndex() : int
      {
         return this._apexIndex;
      }
      
      public function set apexIndex(param1:int) : void
      {
         if(this._apexIndex != param1)
         {
            this._apexIndex = param1;
            if(this._childrenRenderOrder == "arch")
            {
               this.updateDisplayList();
            }
         }
      }
      
      public function get pageController() : String
      {
         if(this._pageController && this._pageController.parent)
         {
            return this._pageController.name;
         }
         return null;
      }
      
      public function set pageController(param1:String) : void
      {
         var _loc2_:FController = null;
         if(param1)
         {
            _loc2_ = _parent.getController(param1);
         }
         this._pageController = _loc2_;
      }
      
      public function get customProperties() : Vector.<ComProperty>
      {
         return this._customProperties;
      }
      
      public function set customProperties(param1:Vector.<ComProperty>) : void
      {
         this._customProperties = param1;
      }
      
      public function getCustomProperty(param1:String, param2:int) : ComProperty
      {
         var _loc5_:ComProperty = null;
         var _loc3_:int = this._customProperties.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._customProperties[_loc4_];
            if(_loc5_.target == param1 && _loc5_.propertyId == param2)
            {
               return _loc5_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function applyCustomProperty(param1:ComProperty) : void
      {
         var _loc2_:FController = null;
         var _loc3_:FObject = null;
         if(param1.value == undefined)
         {
            return;
         }
         if(param1.propertyId == -1)
         {
            _loc2_ = this.getController(param1.target);
            if(_loc2_ != null)
            {
               _loc2_.selectedPageId = param1.value;
            }
         }
         else
         {
            _loc3_ = this.getChildByPath(param1.target);
            if(_loc3_)
            {
               _loc3_.setProp(param1.propertyId,param1.value);
            }
         }
      }
      
      public function get pageControllerObj() : FController
      {
         return this._pageController;
      }
      
      private function updateClipRect() : void
      {
         var _loc1_:Rectangle = _displayObject.container.scrollRect;
         var _loc2_:Number = this.width - (this._margin.left + this._margin.right);
         var _loc3_:Number = this.height - (this._margin.top + this._margin.bottom);
         if(_loc2_ <= 0)
         {
            _loc2_ = 0;
         }
         if(_loc3_ <= 0)
         {
            _loc3_ = 0;
         }
         _loc1_.width = _loc2_;
         _loc1_.height = _loc3_;
         _displayObject.container.scrollRect = _loc1_;
      }
      
      protected function onScrollFlagsChanged() : void
      {
         if(this._scrollPane && this._scrollPane.installed)
         {
            this._scrollPane.onFlagsChanged();
            this.handleSizeChanged();
         }
      }
      
      public function updateOverflow() : void
      {
         if(FObjectFlags.isDocRoot(_flags))
         {
            return;
         }
         if(this._overflow == OverflowConst.HIDDEN)
         {
            if(this._scrollPane)
            {
               this._scrollPane.uninstall();
            }
            _displayObject.container.scrollRect = new Rectangle();
            this.updateClipRect();
            _displayObject.container.x = this._margin.left + this._alignOffset.x;
            _displayObject.container.y = this._margin.top + this._alignOffset.y;
         }
         else if(this._overflow == OverflowConst.SCROLL)
         {
            if(!this._scrollPane)
            {
               this._scrollPane = new FScrollPane(this);
            }
            else if(this._scrollPane.installed)
            {
               this.onScrollFlagsChanged();
            }
            else
            {
               this._scrollPane.install();
               this.handleSizeChanged();
            }
         }
         else
         {
            _displayObject.container.scrollRect = null;
            if(this._scrollPane)
            {
               this._scrollPane.uninstall();
            }
            _displayObject.container.x = this._margin.left + this._alignOffset.x;
            _displayObject.container.y = this._margin.top + this._alignOffset.y;
         }
      }
      
      override protected function handleCreate() : void
      {
         var strings:Object = null;
         var str:String = null;
         var arr:Array = null;
         var maskId:String = null;
         var hitTestId:String = null;
         var it:XDataEnumerator = null;
         var controller:FController = null;
         var child:FObject = null;
         var displayList:Vector.<FDisplayListItem> = null;
         var childCount:int = 0;
         var i:int = 0;
         var di:FDisplayListItem = null;
         var intId:int = 0;
         var ni:int = 0;
         var extNode:XData = null;
         var cxml:XData = null;
         var cp:ComProperty = null;
         this._children.length = 0;
         _displayObject.container.removeChildren();
         this._controllers.length = 0;
         if(!_res || _res.isMissing)
         {
            if(!(this is FList))
            {
               this.errorStatus = true;
            }
            return;
         }
         var pi:FPackageItem = _res.displayItem;
         if(pi.getVar("creatingObject"))
         {
            _pkg.project.editor.alert(UtilsStr.formatString(Consts.strings.text344,pi.name));
            setSize(pi.width,pi.height);
            this.errorStatus = true;
            return;
         }
         var comData:ComponentData = pi.getComponentData();
         if(!comData || !comData.xml)
         {
            setSize(pi.width,pi.height);
            this.errorStatus = true;
            return;
         }
         var xml:XData = comData.xml;
         this.errorStatus = false;
         _underConstruct = true;
         pi.setVar("creatingObject",true);
         this._customProperties.length = 0;
         try
         {
            if(_flags & FObjectFlags.IN_TEST)
            {
               strings = _pkg.strings;
               if(strings)
               {
                  strings = strings[pi.id];
               }
            }
            str = xml.getAttribute("size","");
            arr = str.split(",");
            sourceWidth = int(arr[0]);
            sourceHeight = int(arr[1]);
            this._overflow = xml.getAttribute("overflow","visible");
            this._opaque = xml.getAttributeBool("opaque",true);
            str = xml.getAttribute("margin");
            if(str)
            {
               this._margin.parse(str);
            }
            str = xml.getAttribute("clipSoftness");
            if(str)
            {
               arr = str.split(",");
               this._clipSoftnessX = int(arr[0]);
               this._clipSoftnessY = int(arr[1]);
            }
            this._scroll = xml.getAttribute("scroll",ScrollConst.VERTICAL);
            this._scrollBarFlags = xml.getAttributeInt("scrollBarFlags");
            this._scrollBarDisplay = xml.getAttribute("scrollBar",ScrollBarDisplayConst.DEFAULT);
            str = xml.getAttribute("scrollBarMargin");
            if(str)
            {
               this._scrollBarMargin.parse(str);
            }
            str = xml.getAttribute("scrollBarRes");
            if(str)
            {
               arr = str.split(",");
               this._vtScrollBarRes = arr[0];
               this._hzScrollBarRes = arr[1];
            }
            str = xml.getAttribute("ptrRes");
            if(str)
            {
               arr = str.split(",");
               this._headerRes = arr[0];
               this._footerRes = arr[1];
            }
            this.remark = xml.getAttribute("remark");
            this._instNextId = 0;
            setSize(sourceWidth,sourceHeight);
            aspectLocked = true;
            this.updateOverflow();
            str = xml.getAttribute("pivot");
            if(str)
            {
               _anchor = xml.getAttributeBool("anchor");
               arr = str.split(",");
               _pivotX = parseFloat(arr[0]);
               _pivotY = parseFloat(arr[1]);
               _pivotFromSource = true;
            }
            str = xml.getAttribute("restrictSize");
            if(str)
            {
               arr = str.split(",");
               _minWidth = int(arr[0]);
               _maxWidth = int(arr[1]);
               _minHeight = int(arr[2]);
               _maxHeight = int(arr[3]);
               _restrictSizeFromSource = true;
            }
            maskId = null;
            hitTestId = null;
            maskId = xml.getAttribute("mask");
            hitTestId = xml.getAttribute("hitTest");
            this.reversedMask = xml.getAttributeBool("reversedMask");
            this._buildingDisplayList = true;
            it = xml.getEnumerator("controller");
            while(it.moveNext())
            {
               controller = new FController();
               this._controllers.push(controller);
               controller.parent = this;
               controller.read(it.current);
               if(controller.exported && !FObjectFlags.isDocRoot(_flags))
               {
                  this._customProperties.push(new ComProperty(controller.name,-1,controller.alias));
               }
            }
            displayList = comData.displayList;
            childCount = displayList.length;
            i = 0;
            while(i < childCount)
            {
               di = displayList[i];
               child = di.existingInstance;
               if(!child)
               {
                  child = FObjectFactory.createObject3(di,_flags & 255 | (!!FObjectFlags.isDocRoot(_flags)?FObjectFlags.INSPECTING:0));
               }
               child._underConstruct = true;
               child.read_beforeAdd(di.desc,strings);
               if((child._flags & FObjectFlags.INSPECTING) != 0)
               {
                  if(child._id.charCodeAt(0) == 110)
                  {
                     ni = child._id.indexOf("_");
                     if(ni != -1)
                     {
                        intId = parseInt(child._id.substring(1,ni));
                     }
                     else
                     {
                        intId = parseInt(child._id.substring(1));
                     }
                     if(intId >= this._instNextId)
                     {
                        this._instNextId = intId + 1;
                     }
                  }
               }
               this.addChild(child);
               i++;
            }
            _relations.read(xml,true);
            i = 0;
            while(i < childCount)
            {
               child = this._children[i];
               child.relations.read(displayList[i].desc,false);
               i++;
            }
            i = 0;
            while(i < childCount)
            {
               child = this._children[i];
               child.read_afterAdd(displayList[i].desc,strings);
               child._underConstruct = false;
               i++;
            }
            if(maskId != null)
            {
               this.mask = this.getChildById(maskId);
            }
            if(hitTestId != null)
            {
               this.hitTestSource = this.getChildById(hitTestId);
            }
            this._extentionId = null;
            this.customExtentionId = null;
            if(this._extention)
            {
               this._extention.dispose();
               this._extention = null;
            }
            if((_flags & FObjectFlags.IN_PREVIEW) == 0 || (_flags & FObjectFlags.ROOT) == 0)
            {
               str = xml.getAttribute("extention");
               if(str)
               {
                  this._extention = FObjectFactory.newExtention(_pkg,str);
                  if(this._extention)
                  {
                     this._extentionId = str;
                     extNode = xml.getChild(str);
                     if(!extNode)
                     {
                        extNode = XData.create(str);
                     }
                     this._extention.owner = this;
                     this._extention.read_editMode(extNode);
                     this._extention.create();
                  }
               }
               this.customExtentionId = xml.getAttribute("customExtention");
            }
            this.initName = xml.getAttribute("initName","");
            if((_flags & FObjectFlags.ROOT) != 0 && ((_flags & FObjectFlags.IN_DOC) != 0 || (_flags & FObjectFlags.IN_TEST) != 0))
            {
               this.designImage = xml.getAttribute("designImage","");
               this.designImageOffsetX = xml.getAttributeInt("designImageOffsetX");
               this.designImageOffsetY = xml.getAttributeInt("designImageOffsetY");
               this.designImageAlpha = xml.getAttributeInt("designImageAlpha",50);
               this.designImageLayer = xml.getAttributeInt("designImageLayer");
               this.designImageForTest = xml.getAttributeBool("designImageForTest");
               this.bgColorEnabled = xml.getAttributeBool("bgColorEnabled");
               this.bgColor = xml.getAttributeColor("bgColor",false,16777215);
            }
            if((_flags & FObjectFlags.IN_PREVIEW) == 0)
            {
               this._transitions.read(xml);
            }
            it = xml.getEnumerator("customProperty");
            while(it.moveNext())
            {
               cxml = it.current;
               cp = new ComProperty(cxml.getAttribute("target"),cxml.getAttributeInt("propertyId"),cxml.getAttribute("label"));
               this._customProperties.push(cp);
            }
            this.applyAllControllers();
         }
         finally
         {
            this._buildingDisplayList = false;
            _underConstruct = false;
            pi.setVar("creatingObject",undefined);
         }
         this.updateDisplayList();
         this.setBoundsChangedFlag();
         if(!FObjectFlags.isDocRoot(_flags))
         {
            if(this.mask)
            {
               displayObject.setMask(this.mask);
            }
            if(this.hitTestSource && (_flags & FObjectFlags.IN_PREVIEW) == 0)
            {
               displayObject.setHitArea(this.hitTestSource);
            }
         }
      }
      
      public function write_editMode() : XData
      {
         var _loc2_:FObject = null;
         var _loc3_:XData = null;
         var _loc4_:int = 0;
         var _loc6_:Vector.<String> = null;
         var _loc8_:ComProperty = null;
         var _loc1_:XData = XData.create("component");
         _loc1_.setAttribute("size",int(_width) + "," + int(_height));
         if(_minWidth != 0 || _maxWidth != 0 || _minHeight != 0 || _maxHeight != 0)
         {
            _loc1_.setAttribute("restrictSize",_minWidth + "," + _maxWidth + "," + _minHeight + "," + _maxHeight);
         }
         if(_pivotX != 0 || _pivotY != 0)
         {
            _loc1_.setAttribute("pivot",UtilsStr.toFixed(_pivotX) + "," + UtilsStr.toFixed(_pivotY));
         }
         if(_anchor)
         {
            _loc1_.setAttribute("anchor",true);
         }
         if(this._overflow != OverflowConst.VISIBLE)
         {
            _loc1_.setAttribute("overflow",this._overflow);
         }
         if(!this._opaque)
         {
            _loc1_.setAttribute("opaque",this._opaque);
         }
         if(this._scroll != ScrollConst.VERTICAL)
         {
            _loc1_.setAttribute("scroll",this._scroll);
         }
         if(this._overflow == OverflowConst.SCROLL)
         {
            if(this._scrollBarFlags)
            {
               _loc1_.setAttribute("scrollBarFlags",this._scrollBarFlags);
            }
            if(this._scrollBarDisplay != ScrollBarDisplayConst.DEFAULT)
            {
               _loc1_.setAttribute("scrollBar",this._scrollBarDisplay);
            }
         }
         if(!this._margin.empty)
         {
            _loc1_.setAttribute("margin",this._margin.toString());
         }
         if(!this._scrollBarMargin.empty)
         {
            _loc1_.setAttribute("scrollBarMargin",this._scrollBarMargin.toString());
         }
         if(this._vtScrollBarRes || this._hzScrollBarRes)
         {
            _loc1_.setAttribute("scrollBarRes",(!!this._vtScrollBarRes?this._vtScrollBarRes:"") + "," + (!!this._hzScrollBarRes?this._hzScrollBarRes:""));
         }
         if(this._headerRes || this._footerRes)
         {
            _loc1_.setAttribute("ptrRes",(!!this._headerRes?this._headerRes:"") + "," + (!!this._footerRes?this._footerRes:""));
         }
         if(this._clipSoftnessX != 0 || this._clipSoftnessY != 0)
         {
            _loc1_.setAttribute("clipSoftness",this._clipSoftnessX + "," + this._clipSoftnessY);
         }
         var _loc5_:int = this._controllers.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = this._controllers[_loc4_].write();
            if(_loc3_)
            {
               _loc1_.appendChild(_loc3_);
            }
            _loc4_++;
         }
         _loc5_ = this._children.length;
         var _loc7_:XData = XData.create("displayList");
         _loc1_.appendChild(_loc7_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc2_ = this._children[_loc4_];
            if(!(_loc2_ is FGroup && FGroup(_loc2_).empty))
            {
               _loc3_ = _loc2_.write();
               _loc7_.appendChild(_loc3_);
            }
            _loc4_++;
         }
         if(this._extention)
         {
            _loc1_.setAttribute("extention",this._extentionId);
            _loc3_ = this._extention.write_editMode();
            if(_loc3_)
            {
               _loc1_.appendChild(_loc3_);
            }
         }
         if(this.customExtentionId)
         {
            _loc1_.setAttribute("customExtention",this.customExtentionId);
         }
         if(this.mask != null && this.mask._parent)
         {
            _loc1_.setAttribute("mask",this.mask._id);
            if(this.reversedMask)
            {
               _loc1_.setAttribute("reversedMask",this.reversedMask);
            }
         }
         if(this.hitTestSource != null && this.hitTestSource._parent)
         {
            _loc1_.setAttribute("hitTest",this.hitTestSource._id);
         }
         if(this.initName)
         {
            _loc1_.setAttribute("initName",this.initName);
         }
         if(this.designImage)
         {
            _loc1_.setAttribute("designImage",this.designImage);
         }
         if(this.designImageOffsetX)
         {
            _loc1_.setAttribute("designImageOffsetX",this.designImageOffsetX);
         }
         if(this.designImageOffsetY)
         {
            _loc1_.setAttribute("designImageOffsetY",this.designImageOffsetY);
         }
         if(this.designImageAlpha != 50)
         {
            _loc1_.setAttribute("designImageAlpha",this.designImageAlpha);
         }
         if(this.designImageLayer != 0)
         {
            _loc1_.setAttribute("designImageLayer",this.designImageLayer);
         }
         if(this.designImageForTest)
         {
            _loc1_.setAttribute("designImageForTest",this.designImageForTest);
         }
         if(this.bgColorEnabled)
         {
            _loc1_.setAttribute("bgColorEnabled",this.bgColorEnabled);
         }
         if(this.bgColor != 16777215)
         {
            _loc1_.setAttribute("bgColor",UtilsStr.convertToHtmlColor(this.bgColor));
         }
         if(this.remark)
         {
            _loc1_.setAttribute("remark",this.remark);
         }
         if(!_relations.isEmpty)
         {
            _relations.write(_loc1_);
         }
         if(!this._transitions.isEmpty)
         {
            this._transitions.write(_loc1_);
         }
         if(this._customProperties.length)
         {
            for each(_loc8_ in this._customProperties)
            {
               if(_loc8_.propertyId >= 0)
               {
                  _loc7_ = XData.create("customProperty");
                  _loc7_.setAttribute("target",_loc8_.target);
                  _loc7_.setAttribute("propertyId",_loc8_.propertyId);
                  if(_loc8_.label)
                  {
                     _loc7_.setAttribute("label",_loc8_.label);
                  }
                  _loc1_.appendChild(_loc7_);
               }
            }
         }
         return _loc1_;
      }
      
      override public function read_afterAdd(param1:XData, param2:Object) : void
      {
         var _loc3_:XData = null;
         var _loc4_:String = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:ComProperty = null;
         var _loc9_:XDataEnumerator = null;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc12_:* = undefined;
         super.read_afterAdd(param1,param2);
         if(this._extention)
         {
            _loc3_ = param1.getChild(this._extentionId);
            if(!_loc3_)
            {
               _loc3_ = XData.create("Extention");
            }
            this._extention.read(_loc3_,param2);
         }
         _loc4_ = param1.getAttribute("pageController");
         if(_loc4_)
         {
            this._pageController = _parent.getController(_loc4_);
         }
         else
         {
            this._pageController = null;
         }
         _loc4_ = param1.getAttribute("controller");
         if(_loc4_)
         {
            _loc6_ = _loc4_.split(",");
            _loc7_ = 0;
            while(_loc7_ < _loc6_.length)
            {
               _loc8_ = this.getCustomProperty(_loc6_[_loc7_],-1);
               if(_loc8_)
               {
                  _loc8_.value = _loc6_[_loc7_ + 1];
                  this.applyCustomProperty(_loc8_);
               }
               _loc7_ = _loc7_ + 2;
            }
         }
         var _loc5_:int = this._customProperties.length;
         if(_loc5_ > 0)
         {
            _loc9_ = param1.getEnumerator("property");
            while(_loc9_.moveNext())
            {
               _loc10_ = _loc9_.current.getAttribute("target");
               _loc11_ = _loc9_.current.getAttributeInt("propertyId");
               _loc8_ = this.getCustomProperty(_loc10_,_loc11_);
               if(_loc8_)
               {
                  _loc8_.value = _loc9_.current.getAttribute("value");
                  if(param2)
                  {
                     _loc12_ = param2[_id + "-cp-" + _loc8_.target];
                     if(_loc12_ != undefined)
                     {
                        _loc8_.value = _loc12_;
                     }
                  }
                  this.applyCustomProperty(_loc8_);
               }
            }
         }
      }
      
      override public function write() : XData
      {
         var _loc3_:XData = null;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:ComProperty = null;
         var _loc1_:XData = super.write();
         if(this._extention)
         {
            _loc3_ = this._extention.write();
            if(_loc3_)
            {
               _loc1_.appendChild(_loc3_);
            }
         }
         if(this._pageController && this._pageController.parent)
         {
            _loc1_.setAttribute("pageController",this._pageController.name);
         }
         var _loc2_:int = this._customProperties.length;
         if(_loc2_ > 0)
         {
            _loc4_ = null;
            _loc5_ = 0;
            while(_loc5_ < _loc2_)
            {
               _loc6_ = this._customProperties[_loc5_];
               if(_loc6_.value != undefined)
               {
                  if(_loc6_.propertyId == -1)
                  {
                     if(_loc4_ == null)
                     {
                        _loc4_ = "";
                     }
                     else
                     {
                        _loc4_ = _loc4_ + ",";
                     }
                     _loc4_ = _loc4_ + (_loc6_.target + "," + _loc6_.value);
                  }
                  else
                  {
                     _loc3_ = XData.create("property");
                     _loc3_.setAttribute("target",_loc6_.target);
                     _loc3_.setAttribute("propertyId",_loc6_.propertyId);
                     _loc3_.setAttribute("value",String(_loc6_.value));
                     _loc1_.appendChild(_loc3_);
                  }
               }
               _loc5_++;
            }
            if(_loc4_ != null)
            {
               _loc1_.setAttribute("controller",_loc4_);
            }
         }
         return _loc1_;
      }
      
      public function validateChildren(param1:Boolean = false) : Boolean
      {
         var _loc4_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:int = this._children.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(this._children[_loc4_].validate(param1))
            {
               _loc2_ = true;
            }
            _loc4_++;
         }
         if(this._scrollPane && this._scrollPane.validate(param1))
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      public function createChild(param1:XData) : FObject
      {
         var _loc3_:FPackage = null;
         var _loc4_:FPackageItem = null;
         var _loc5_:String = null;
         var _loc2_:String = param1.getAttribute("pkg");
         if(_loc2_ && _loc2_ != _pkg.id)
         {
            _loc3_ = _pkg.project.getPackage(_loc2_) as FPackage;
         }
         else
         {
            _loc3_ = _pkg;
         }
         if(_loc3_ != null)
         {
            _loc5_ = param1.getAttribute("src");
            if(_loc5_)
            {
               _loc4_ = _loc3_.getItem(_loc5_);
               if(_loc4_ && _loc3_ != _pkg && !_loc4_.exported)
               {
                  _loc4_ = null;
               }
            }
         }
         else
         {
            _loc3_ = _pkg;
         }
         if(_loc4_ != null)
         {
            return FObjectFactory.createObject(_loc4_,FObjectFlags.IN_DOC | FObjectFlags.INSPECTING);
         }
         return FObjectFactory.createObject2(_loc3_,param1.getName(),null,FObjectFlags.IN_DOC | FObjectFlags.INSPECTING);
      }
      
      public function getChildrenInfo() : String
      {
         var _loc3_:FObject = null;
         var _loc5_:DisplayObject = null;
         var _loc1_:* = "==============\n";
         var _loc2_:int = this._children.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = this._children[_loc4_];
            _loc1_ = _loc1_ + (_loc3_.toString() + "\n");
            _loc4_++;
         }
         _loc1_ = _loc1_ + "----------\n";
         _loc2_ = _displayObject.container.numChildren;
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = _displayObject.container.getChildAt(_loc4_);
            if(_loc5_ is FSprite)
            {
               _loc1_ = _loc1_ + (FSprite(_loc5_).owner.toString() + "\n");
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function getNextId() : String
      {
         return "n" + this._instNextId++ + "_" + _pkg.project.serialNumberSeed;
      }
      
      public function isIdInUse(param1:String) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:FObject = null;
         var _loc2_:int = this._children.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._children[_loc3_];
            if(_loc4_._id == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function containsComponent(param1:FPackageItem) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:FComponent = null;
         var _loc2_:int = this._children.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._children[_loc3_] as FComponent;
            if(_loc4_)
            {
               if(_loc4_._res && (_loc4_._res.packageItem == param1 || _loc4_._res.displayItem == param1))
               {
                  return true;
               }
               if(_loc4_.containsComponent(param1))
               {
                  return true;
               }
            }
            _loc3_++;
         }
         return false;
      }
      
      override protected function handleDispose() : void
      {
         var _loc1_:int = 0;
         var _loc3_:FObject = null;
         if(this._scrollPane)
         {
            this._scrollPane.dispose();
         }
         this._transitions.dispose();
         var _loc2_:int = this._children.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this._children[_loc1_];
            _loc3_.dispose();
            _loc1_++;
         }
      }
      
      public function handleTextBitmapMode(param1:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc5_:FObject = null;
         var _loc2_:Boolean = param1 || _displayObject._deformation;
         var _loc4_:int = this._children.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this._children[_loc3_];
            if(_loc5_ is FTextField)
            {
               FTextField(_loc5_).bitmapMode = _loc2_ || _loc5_.displayObject._deformation;
            }
            else if(_loc5_ is FComponent)
            {
               FComponent(_loc5_).handleTextBitmapMode(_loc2_);
            }
            _loc3_++;
         }
      }
      
      public function notifyChildReplaced(param1:FObject, param2:FObject) : void
      {
         var _loc3_:int = this._children.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            this._children[_loc4_].relations.replaceTarget(param1,param2);
            _loc4_++;
         }
         relations.replaceTarget(param1,param2);
         if(this.mask == param1)
         {
            this.mask = param2;
         }
         if(this.hitTestSource == param1)
         {
            this.hitTestSource = param2;
         }
      }
      
      public function collectLoadingImages(param1:Vector.<FPackageItem>) : void
      {
         var _loc2_:int = 0;
         var _loc4_:FObject = null;
         var _loc5_:FPackageItem = null;
         var _loc3_:int = this._children.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this._children[_loc2_];
            if(_loc4_ is FComponent)
            {
               FComponent(_loc4_).collectLoadingImages(param1);
            }
            else if(_loc4_._res)
            {
               _loc5_ = _loc4_._res.displayItem;
               if(_loc5_ && _loc5_.type == FPackageItemType.IMAGE && _loc5_.loading)
               {
                  param1.push(_loc5_);
               }
            }
            _loc2_++;
         }
      }
      
      public function playAutoPlayTransitions() : void
      {
         var _loc1_:FTransition = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:FObject = null;
         for each(_loc1_ in this._transitions.items)
         {
            if(_loc1_.autoPlay && !_loc1_.playing)
            {
               _loc1_.play(null,null,_loc1_.autoPlayRepeat,_loc1_.autoPlayDelay);
            }
         }
         _loc2_ = this._children.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._children[_loc3_];
            if(_loc4_ is FComponent)
            {
               FComponent(_loc4_).playAutoPlayTransitions();
            }
            _loc3_++;
         }
      }
   }
}
