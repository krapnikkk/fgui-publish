package fairygui.editor.gui
{
   import fairygui.editor.ComDocument;
   import fairygui.editor.gui.gear.EIColorGear;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.utils.GTimers;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class EGComponent extends EGObject implements EIColorGear
   {
       
      
      private var _extentionId:String;
      
      private var _extention:ComExtention;
      
      private var _customExtentionId:String;
      
      private var _initName:String;
      
      private var _designImage:String;
      
      private var _designImageOffsetX:int;
      
      private var _designImageOffsetY:int;
      
      private var _designImageAlpha:int;
      
      private var _designImageLayer:int;
      
      private var _bgColor:uint;
      
      private var _bgColorEnabled:Boolean;
      
      private var _children:Vector.<EGObject>;
      
      private var _controllers:Vector.<EController>;
      
      private var _transitions:ETransitions;
      
      private var _instNextId:uint;
      
      private var _dislayListChanged:Boolean;
      
      private var _bounds:Rectangle;
      
      private var _boundsChanged:Boolean;
      
      private var _snapshot:Vector.<ObjectSnapshot>;
      
      private var _controllerSnapshot:Vector.<String>;
      
      private var _applyingController:EController;
      
      protected var _overflow:String;
      
      protected var _scroll:String;
      
      protected var _opaque:Boolean;
      
      protected var _margin:EMargin;
      
      protected var _clipSoftness:Point;
      
      protected var _scrollBarDisplay:String;
      
      protected var _scrollBarFlags:int;
      
      protected var _scrollBarMargin:EMargin;
      
      protected var _hzScrollBarRes:String;
      
      protected var _vtScrollBarRes:String;
      
      protected var _headerRes:String;
      
      protected var _footerRes:String;
      
      protected var _childrenRenderOrder:String;
      
      protected var _apexIndex:int;
      
      protected var _pageController:EController;
      
      public var scrollPane:EScrollPane;
      
      public var editingTransition:ETransition;
      
      public var alignOffset:Point;
      
      public var remark:String;
      
      public var adaptationTest:String;
      
      public var hitTestSource:EGObject;
      
      public var mask:EGObject;
      
      public var reversedMask:Boolean;
      
      public var disabled_displayController:Boolean;
      
      public var disabled_relations:Boolean;
      
      public var buildingDisplayList:Boolean;
      
      public var namesChanged:Boolean;
      
      public var nameMap:Object;
      
      public var nameConflicts:Array;
      
      public function EGComponent()
      {
         super();
         this.objectType = "component";
         this._children = new Vector.<EGObject>();
         this._controllers = new Vector.<EController>();
         this._overflow = "visible";
         this._scroll = "vertical";
         this._scrollBarDisplay = "default";
         this._bounds = new Rectangle();
         this._margin = new EMargin();
         this._scrollBarMargin = new EMargin();
         this._clipSoftness = new Point();
         this._initName = "";
         this._designImage = "";
         this._designImageAlpha = 50;
         this._bgColor = 16777215;
         this._opaque = true;
         this._transitions = new ETransitions(this);
         this._snapshot = new Vector.<ObjectSnapshot>();
         this._controllerSnapshot = new Vector.<String>();
         this.alignOffset = new Point();
         this._childrenRenderOrder = "ascent";
      }
      
      public function addChild(param1:EGObject) : EGObject
      {
         this.addChildAt(param1,this._children.length);
         return param1;
      }
      
      public function addChildAt(param1:EGObject, param2:int) : EGObject
      {
         if(!param1._id)
         {
            param1._id = this.getNextId();
         }
         if(!param1._name)
         {
            param1._name = UtilsStr.getNameFromId(param1._id);
         }
         this.namesChanged = true;
         var _loc3_:int = this._children.length;
         if(param2 >= 0 && param2 <= _loc3_)
         {
            param1.removeFromParent();
            param1.parent = this;
            if(param2 == _loc3_)
            {
               this._children.push(param1);
            }
            else
            {
               this._children.splice(param2,0,param1);
            }
            if(param1.finalVisible)
            {
               this.updateDisplayList();
            }
            if(param1._group)
            {
               param1._group.update(true);
            }
            this.setBoundsChangedFlag();
            return param1;
         }
         throw new RangeError("Invalid child index");
      }
      
      public function removeChild(param1:EGObject) : EGObject
      {
         var _loc2_:int = this.getChildIndex(param1);
         if(_loc2_ != -1)
         {
            this.removeChildAt(_loc2_);
         }
         return param1;
      }
      
      public function removeChildAt(param1:int) : EGObject
      {
         var _loc2_:EGObject = null;
         if(param1 >= 0 && param1 < this.numChildren)
         {
            _loc2_ = this._children[param1];
            _loc2_.parent = null;
            _loc2_.statusDispatcher.dispatch(_loc2_,0);
            this._children.splice(param1,1);
            if(_loc2_.displayObject.parent)
            {
               _displayObject.container.removeChild(_loc2_.displayObject);
               if(this._childrenRenderOrder == "arch")
               {
                  this.updateDisplayList();
               }
            }
            if(_loc2_._group)
            {
               _loc2_._group.update(true);
            }
            this.setBoundsChangedFlag();
            this.namesChanged = true;
            return _loc2_;
         }
         throw new RangeError("Invalid child index");
      }
      
      public function removeChildren(param1:int = 0, param2:int = -1) : void
      {
         if(param2 < 0 || param2 >= this.numChildren)
         {
            param2 = this.numChildren - 1;
         }
         var _loc3_:* = param1;
         while(_loc3_ <= param2)
         {
            this.removeChildAt(param1);
            _loc3_++;
         }
      }
      
      public function getChildAt(param1:int) : EGObject
      {
         if(param1 >= 0 && param1 < this.numChildren)
         {
            return this._children[param1];
         }
         throw new RangeError("Invalid child index");
      }
      
      public function getChild(param1:String) : EGObject
      {
         var _loc3_:int = this._children.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._children[_loc2_].name == param1)
            {
               return this._children[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getChildById(param1:String) : EGObject
      {
         var _loc3_:int = this._children.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._children[_loc2_]._id == param1)
            {
               return this._children[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getChildIndex(param1:EGObject) : int
      {
         return this._children.indexOf(param1);
      }
      
      public function setChildIndex(param1:EGObject, param2:int) : void
      {
         var _loc3_:int = this.getChildIndex(param1);
         if(_loc3_ == -1)
         {
            throw new ArgumentError("Not a child of this container");
         }
         this._children.splice(_loc3_,1);
         this._children.splice(param2,0,param1);
         this.updateDisplayList();
         this.setBoundsChangedFlag();
      }
      
      public function swapChildren(param1:EGObject, param2:EGObject) : void
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
         var _loc3_:EGObject = this._children[param1];
         var _loc4_:EGObject = this._children[param2];
         this._children[param1] = _loc4_;
         this._children[param2] = _loc3_;
         this.updateDisplayList();
      }
      
      public function get numChildren() : int
      {
         return this._children.length;
      }
      
      public function addController(param1:EController, param2:Boolean = true) : void
      {
         this._controllers.push(param1);
         param1.parent = this;
         if(param2)
         {
            this.applyController(param1);
         }
      }
      
      public function getController(param1:String) : EController
      {
         var _loc3_:int = this._controllers.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._controllers[_loc2_].name == param1)
            {
               return this._controllers[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function removeController(param1:EController) : void
      {
         var _loc3_:int = this._controllers.indexOf(param1);
         if(_loc3_ == -1)
         {
            throw new Error("controller not found");
         }
         param1.parent = null;
         this._controllers.splice(_loc3_,1);
         var _loc2_:int = 0;
         while(_loc2_ < this.numChildren)
         {
            this._children[_loc2_].handleControllerChanged(param1);
            _loc2_++;
         }
      }
      
      public function get controllers() : Vector.<EController>
      {
         return this._controllers;
      }
      
      public function updateDisplayList(param1:Boolean = false) : void
      {
         var _loc8_:int = 0;
         var _loc9_:EGObject = null;
         var _loc4_:Boolean = false;
         var _loc7_:int = 0;
         var _loc6_:int = 0;
         var _loc5_:DisplayObject = null;
         var _loc3_:EGGroup = null;
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
         var _loc10_:int = this._children.length;
         var _loc2_:Sprite = _displayObject.container;
         var _loc11_:* = this._childrenRenderOrder;
         if("ascent" !== _loc11_)
         {
            if("descent" !== _loc11_)
            {
               if("arch" === _loc11_)
               {
                  _loc8_ = 0;
                  while(_loc8_ < this._apexIndex)
                  {
                     _loc9_ = this._children[_loc8_];
                     if(_loc9_.finalVisible)
                     {
                        _loc2_.addChild(_loc9_.displayObject);
                     }
                     else if(_loc9_.displayObject.parent)
                     {
                        _loc9_.displayObject.parent.removeChild(_loc9_.displayObject);
                     }
                     _loc8_++;
                  }
                  _loc8_ = _loc10_ - 1;
                  while(_loc8_ >= this._apexIndex)
                  {
                     _loc9_ = this._children[_loc8_];
                     if(_loc9_.finalVisible)
                     {
                        _loc2_.addChild(_loc9_.displayObject);
                     }
                     else if(_loc9_.displayObject.parent)
                     {
                        _loc9_.displayObject.parent.removeChild(_loc9_.displayObject);
                     }
                     _loc8_--;
                  }
               }
            }
            else
            {
               _loc8_ = _loc10_ - 1;
               while(_loc8_ >= 0)
               {
                  _loc9_ = this._children[_loc8_];
                  if(_loc9_.finalVisible)
                  {
                     _loc2_.addChild(_loc9_.displayObject);
                  }
                  else if(_loc9_.displayObject.parent)
                  {
                     _loc9_.displayObject.parent.removeChild(_loc9_.displayObject);
                  }
                  _loc8_--;
               }
            }
         }
         else
         {
            _loc8_ = 0;
            while(_loc8_ < _loc10_)
            {
               _loc9_ = this._children[_loc8_];
               if(_loc9_.finalVisible)
               {
                  _loc2_.addChild(_loc9_.displayObject);
               }
               else if(_loc9_.displayObject.parent)
               {
                  _loc9_.displayObject.parent.removeChild(_loc9_.displayObject);
               }
               _loc8_++;
            }
         }
         if(editMode == 3)
         {
            _loc8_ = _loc10_ - 1;
            while(_loc8_ >= 0)
            {
               _loc9_ = this._children[_loc8_];
               if(!(!(_loc9_ is EGGroup) || !EGGroup(_loc9_).opened))
               {
                  if(_loc9_.displayObject.parent)
                  {
                     _loc2_.addChild(_loc9_.displayObject);
                  }
                  _loc4_ = false;
                  _loc7_ = 1;
                  _loc3_ = EGGroup(_loc9_);
                  _loc6_ = 0;
                  while(_loc6_ < _loc8_)
                  {
                     _loc9_ = this._children[_loc6_];
                     if(!_loc4_)
                     {
                        if(_loc9_.inGroup(_loc3_))
                        {
                           _loc4_ = true;
                        }
                     }
                     if(_loc4_)
                     {
                        if(_loc9_.displayObject.parent)
                        {
                           _loc2_.addChild(_loc9_.displayObject);
                           _loc7_++;
                        }
                     }
                     _loc6_++;
                  }
               }
               _loc8_--;
            }
            _loc10_ = _loc2_.numChildren;
            if(_loc7_ > 0)
            {
               _loc7_ = _loc10_ - _loc7_;
               _loc8_ = 0;
               while(_loc8_ < _loc10_)
               {
                  _loc5_ = _loc2_.getChildAt(_loc8_);
                  if(_loc8_ < _loc7_)
                  {
                     _loc5_.alpha = 0.3;
                  }
                  else
                  {
                     _loc5_.alpha = 1;
                  }
                  _loc8_++;
               }
            }
            else
            {
               _loc8_ = 0;
               while(_loc8_ < _loc10_)
               {
                  _loc5_ = _loc2_.getChildAt(_loc8_);
                  _loc5_.alpha = 1;
                  _loc8_++;
               }
            }
         }
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
         var _loc7_:int = this._children.length;
         if(_loc7_ == 0)
         {
            param3.x = param1;
            param3.y = param2;
            return param3;
         }
         this.ensureBoundsCorrect();
         var _loc4_:EGObject = null;
         var _loc5_:EGObject = null;
         var _loc6_:int = 0;
         if(param2 != 0)
         {
            while(_loc6_ < _loc7_)
            {
               _loc4_ = this._children[_loc6_];
               if(param2 < _loc4_.y)
               {
                  if(_loc6_ == 0)
                  {
                     param2 = 0;
                     break;
                  }
                  _loc5_ = this._children[_loc6_ - 1];
                  if(param2 < _loc5_.y + _loc5_.height / 2)
                  {
                     param2 = Number(_loc5_.y);
                  }
                  else
                  {
                     param2 = Number(_loc4_.y);
                  }
                  break;
               }
               _loc6_++;
            }
            if(_loc6_ == _loc7_)
            {
               param2 = Number(_loc4_.y);
            }
         }
         if(param1 != 0)
         {
            if(_loc6_ > 0)
            {
               _loc6_--;
            }
            while(_loc6_ < _loc7_)
            {
               _loc4_ = this._children[_loc6_];
               if(param1 < _loc4_.x)
               {
                  if(_loc6_ == 0)
                  {
                     param1 = 0;
                     break;
                  }
                  _loc5_ = this._children[_loc6_ - 1];
                  if(param1 < _loc5_.x + _loc5_.width / 2)
                  {
                     param1 = Number(_loc5_.x);
                  }
                  else
                  {
                     param1 = Number(_loc4_.x);
                  }
                  break;
               }
               _loc6_++;
            }
            if(_loc6_ == _loc7_)
            {
               param1 = Number(_loc4_.x);
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
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         var _loc3_:EGObject = null;
         var _loc8_:int = this._children.length;
         if(_loc8_ == 0)
         {
            this.setBounds(0,0,0,0);
            return;
         }
         var _loc7_:* = 2147483647;
         var _loc5_:* = 2147483647;
         var _loc6_:* = -2147483648;
         var _loc1_:* = -2147483648;
         _loc4_ = 0;
         while(_loc4_ < _loc8_)
         {
            _loc3_ = this._children[_loc4_];
            _loc2_ = _loc3_.x;
            if(_loc2_ < _loc7_)
            {
               _loc7_ = _loc2_;
            }
            _loc2_ = _loc3_.y;
            if(_loc2_ < _loc5_)
            {
               _loc5_ = _loc2_;
            }
            _loc2_ = _loc3_.x + _loc3_.actualWidth;
            if(_loc2_ > _loc6_)
            {
               _loc6_ = _loc2_;
            }
            _loc2_ = _loc3_.y + _loc3_.actualHeight;
            if(_loc2_ > _loc1_)
            {
               _loc1_ = _loc2_;
            }
            _loc4_++;
         }
         this.setBounds(_loc7_,_loc5_,_loc6_ - _loc7_,_loc1_ - _loc5_);
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
         if(this.scrollPane)
         {
            this.scrollPane.setContentSize(this._bounds.x + this._bounds.width,this._bounds.y + this._bounds.height);
         }
      }
      
      public function getGroupTopIndex(param1:EGGroup) : int
      {
         var _loc2_:int = 0;
         var _loc3_:EGObject = null;
         var _loc4_:int = this._children.length;
         _loc2_ = _loc4_ - 1;
         while(_loc2_ >= 0)
         {
            _loc3_ = this._children[_loc2_];
            if(_loc3_.inGroup(param1))
            {
               return _loc2_;
            }
            _loc2_--;
         }
         return -1;
      }
      
      public function getGroupBottomIndex(param1:EGGroup) : int
      {
         var _loc2_:int = 0;
         var _loc3_:EGObject = null;
         var _loc4_:int = this._children.length;
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = this._children[_loc2_];
            if(_loc3_.inGroup(param1))
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function getGroupContent(param1:EGGroup) : Vector.<EGObject>
      {
         var _loc4_:int = 0;
         var _loc2_:EGObject = null;
         var _loc5_:Vector.<EGObject> = new Vector.<EGObject>();
         var _loc3_:int = this._children.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this._children[_loc4_];
            if(_loc2_.inGroup(param1))
            {
               _loc5_.push(_loc2_);
            }
            _loc4_++;
         }
         return _loc5_;
      }
      
      public function applyController(param1:EController) : void
      {
         var _loc2_:int = 0;
         var _loc3_:EGObject = null;
         this._applyingController = param1;
         var _loc4_:int = this._children.length;
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = this._children[_loc2_];
            _loc3_.handleControllerChanged(param1);
            _loc2_++;
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
         var _loc1_:EController = null;
         var _loc3_:int = this._controllers.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this._controllers[_loc2_];
            this.applyController(_loc1_);
            _loc2_++;
         }
      }
      
      public function adjustRadioGroupDepth(param1:EGObject, param2:EController) : void
      {
         var _loc7_:int = 0;
         var _loc3_:EGObject = null;
         var _loc6_:int = this._children.length;
         var _loc4_:* = -1;
         var _loc5_:* = -1;
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc3_ = this._children[_loc7_];
            if(_loc3_ == param1)
            {
               _loc4_ = _loc7_;
            }
            else if(_loc3_ is EGComponent && EGComponent(_loc3_)._extention is EGButton && EGButton(EGComponent(_loc3_)._extention).controllerObj == param2)
            {
               if(_loc7_ > _loc5_)
               {
                  _loc5_ = _loc7_;
               }
            }
            _loc7_++;
         }
         if(_loc4_ < _loc5_)
         {
            if(this._applyingController != null)
            {
               this._children[_loc5_].handleControllerChanged(this._applyingController);
            }
            this.swapChildrenAt(_loc4_,_loc5_);
         }
      }
      
      override protected function handleSizeChanged() : void
      {
         super.handleSizeChanged();
         if(_displayObject.container.scrollRect)
         {
            this.updateClipRect();
         }
         if(this.scrollPane && this.scrollPane.installed)
         {
            this.scrollPane.OnOwnerSizeChanged();
         }
      }
      
      override public function handleControllerChanged(param1:EController) : void
      {
         super.handleControllerChanged(param1);
         if(this._extention)
         {
            this._extention.handleControllerChanged(param1);
         }
         if(this._pageController == param1 && this.scrollPane && this.scrollPane.installed)
         {
            this.scrollPane.handleControllerChanged(param1);
         }
      }
      
      override protected function handleGrayedChanged() : void
      {
         var _loc3_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:EGObject = null;
         if(this._extention is EGButton)
         {
            if(EGButton(this._extention).handleGrayChanged())
            {
               return;
            }
         }
         var _loc4_:EController = this.getController("grayed");
         if(_loc4_ != null)
         {
            _loc3_ = this._children.length;
            _loc1_ = 0;
            while(_loc1_ < _loc3_)
            {
               _loc2_ = this._children[_loc1_];
               if(!_loc2_._gears[3] || _loc2_._gears[3].controllerObject != _loc4_)
               {
                  this._children[_loc1_].grayed = false;
               }
               _loc1_++;
            }
            _loc4_.selectedIndex = !!this.grayed?1:0;
            return;
         }
         _loc3_ = this._children.length;
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            this._children[_loc1_].grayed = this.grayed;
            _loc1_++;
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
               this._extention.owner = null;
            }
            if(param1 == "")
            {
               param1 = null;
            }
            this._extentionId = param1;
            if(this._extentionId)
            {
               this._extention = EUIObjectFactory.createExtention(pkg,this._extentionId);
               if(this._extention)
               {
                  this._extention.owner = this;
                  if(this._extention is EGButton && this.grayed)
                  {
                     this.handleGrayedChanged();
                  }
               }
            }
            else
            {
               this._extention = null;
            }
         }
      }
      
      public function get customExtentionId() : String
      {
         return this._customExtentionId;
      }
      
      public function set customExtentionId(param1:String) : void
      {
         this._customExtentionId = param1;
      }
      
      public function get initName() : String
      {
         return this._initName;
      }
      
      public function set initName(param1:String) : void
      {
         if(param1 != null)
         {
            param1 = UtilsStr.trim(param1);
         }
         this._initName = param1;
      }
      
      private function updateDesignImage() : void
      {
         var _loc1_:ComDocument = null;
         if(this.editMode == 3)
         {
            _loc1_ = pkg.project.editorWindow.mainPanel.editPanel.findComDocument(this.pkg,packageItem.id);
            if(_loc1_ != null)
            {
               _loc1_.updateDesignImage();
            }
         }
      }
      
      public function get designImage() : String
      {
         return this._designImage;
      }
      
      public function set designImage(param1:String) : void
      {
         this._designImage = param1;
         this.updateDesignImage();
      }
      
      public function get designImageOffsetX() : int
      {
         return this._designImageOffsetX;
      }
      
      public function set designImageOffsetX(param1:int) : void
      {
         this._designImageOffsetX = param1;
         this.updateDesignImage();
      }
      
      public function get designImageOffsetY() : int
      {
         return this._designImageOffsetY;
      }
      
      public function set designImageOffsetY(param1:int) : void
      {
         this._designImageOffsetY = param1;
         this.updateDesignImage();
      }
      
      public function get designImageAlpha() : int
      {
         return this._designImageAlpha;
      }
      
      public function set designImageAlpha(param1:int) : void
      {
         this._designImageAlpha = param1;
         this.updateDesignImage();
      }
      
      public function get designImageLayer() : int
      {
         return this._designImageLayer;
      }
      
      public function set designImageLayer(param1:int) : void
      {
         this._designImageLayer = param1;
         this.updateDesignImage();
      }
      
      private function updateBgColor() : void
      {
         var _loc1_:ComDocument = null;
         if(this.editMode == 3)
         {
            _loc1_ = pkg.project.editorWindow.activeComDocument;
            if(_loc1_ != null)
            {
               _loc1_.drawBackground();
            }
         }
      }
      
      public function get bgColor() : uint
      {
         return this._bgColor;
      }
      
      public function set bgColor(param1:uint) : void
      {
         this._bgColor = param1;
         this.updateBgColor();
      }
      
      public function get bgColorEnabled() : Boolean
      {
         return this._bgColorEnabled;
      }
      
      public function set bgColorEnabled(param1:Boolean) : void
      {
         this._bgColorEnabled = param1;
         this.updateBgColor();
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
            this.scroll = param1.substr(7);
            this.overflow = "scroll";
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
            if(this.scrollPane && this.scrollPane.installed)
            {
               this.scrollPane.onFlagsChanged();
            }
         }
      }
      
      public function get scrollBarOnLeft() : Boolean
      {
         return (this._scrollBarFlags & 1) != 0;
      }
      
      public function set scrollBarOnLeft(param1:Boolean) : void
      {
         if(param1)
         {
            this.scrollBarFlags = this._scrollBarFlags | 1;
         }
         else
         {
            this.scrollBarFlags = this._scrollBarFlags & ~1;
         }
      }
      
      public function get scrollSnapping() : Boolean
      {
         return (this._scrollBarFlags & 2) != 0;
      }
      
      public function set scrollSnapping(param1:Boolean) : void
      {
         if(param1)
         {
            this.scrollBarFlags = this._scrollBarFlags | 2;
         }
         else
         {
            this.scrollBarFlags = this._scrollBarFlags & ~2;
         }
      }
      
      public function get scrollBarInDemand() : Boolean
      {
         return (this._scrollBarFlags & 4) != 0;
      }
      
      public function set scrollBarInDemand(param1:Boolean) : void
      {
         if(param1)
         {
            this.scrollBarFlags = this._scrollBarFlags | 4;
         }
         else
         {
            this.scrollBarFlags = this._scrollBarFlags & ~4;
         }
      }
      
      public function get scrollPageMode() : Boolean
      {
         return (this._scrollBarFlags & 8) != 0;
      }
      
      public function set scrollPageMode(param1:Boolean) : void
      {
         if(param1)
         {
            this.scrollBarFlags = this._scrollBarFlags | 8;
         }
         else
         {
            this.scrollBarFlags = this._scrollBarFlags & ~8;
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
      
      public function get scrollTouchEffect() : String
      {
         return !!(this._scrollBarFlags & 16)?"enabled":!!(this._scrollBarFlags & 32)?"disabled":"default";
      }
      
      public function set scrollTouchEffect(param1:String) : void
      {
         if(param1 == "enabled")
         {
            this._scrollBarFlags = this._scrollBarFlags | 16;
            this._scrollBarFlags = this._scrollBarFlags & ~32;
         }
         else if(param1 == "disabled")
         {
            this._scrollBarFlags = this._scrollBarFlags & ~16;
            this._scrollBarFlags = this._scrollBarFlags | 32;
         }
         else
         {
            this._scrollBarFlags = this._scrollBarFlags & ~16;
            this._scrollBarFlags = this._scrollBarFlags & ~32;
         }
      }
      
      public function get scrollBounceBackEffect() : String
      {
         return !!(this._scrollBarFlags & 64)?"enabled":!!(this._scrollBarFlags & 128)?"disabled":"default";
      }
      
      public function set scrollBounceBackEffect(param1:String) : void
      {
         if(param1 == "enabled")
         {
            this.scrollBarFlags = this._scrollBarFlags | 64;
            this.scrollBarFlags = this._scrollBarFlags & ~128;
         }
         else if(param1 == "disabled")
         {
            this.scrollBarFlags = this._scrollBarFlags & ~64;
            this.scrollBarFlags = this._scrollBarFlags | 128;
         }
         else
         {
            this.scrollBarFlags = this._scrollBarFlags & ~64;
            this.scrollBarFlags = this._scrollBarFlags & ~128;
         }
      }
      
      public function get inertiaDisabled() : Boolean
      {
         return (this._scrollBarFlags & 256) != 0;
      }
      
      public function set inertiaDisabled(param1:Boolean) : void
      {
         if(param1)
         {
            this.scrollBarFlags = this._scrollBarFlags | 256;
         }
         else
         {
            this.scrollBarFlags = this._scrollBarFlags & ~256;
         }
      }
      
      public function get maskDisabled() : Boolean
      {
         return (this._scrollBarFlags & 512) != 0;
      }
      
      public function set maskDisabled(param1:Boolean) : void
      {
         if(param1)
         {
            this.scrollBarFlags = this._scrollBarFlags | 512;
         }
         else
         {
            this.scrollBarFlags = this._scrollBarFlags & ~512;
         }
      }
      
      public function get margin() : EMargin
      {
         return this._margin;
      }
      
      public function set margin(param1:EMargin) : void
      {
         this._margin = param1;
         this.updateOverflow();
         this.setBoundsChangedFlag();
         this.handleSizeChanged();
      }
      
      public function get marginLeft() : String
      {
         return "" + this._margin.left;
      }
      
      public function get marginRight() : String
      {
         return "" + this._margin.right;
      }
      
      public function get marginTop() : String
      {
         return "" + this._margin.top;
      }
      
      public function get marginBottom() : String
      {
         return "" + this._margin.bottom;
      }
      
      public function set marginLeft(param1:String) : void
      {
         this._margin.left = parseInt(param1);
         this.margin = this._margin;
      }
      
      public function set marginRight(param1:String) : void
      {
         this._margin.right = parseInt(param1);
         this.margin = this._margin;
      }
      
      public function set marginTop(param1:String) : void
      {
         this._margin.top = parseInt(param1);
         this.margin = this._margin;
      }
      
      public function set marginBottom(param1:String) : void
      {
         this._margin.bottom = parseInt(param1);
         this.margin = this._margin;
      }
      
      public function get scrollBarMargin() : EMargin
      {
         return this._scrollBarMargin;
      }
      
      public function set scrollBarMargin(param1:EMargin) : void
      {
         this._scrollBarMargin = param1;
         if(this.scrollPane && this.scrollPane.installed)
         {
            this.scrollPane.onFlagsChanged();
         }
      }
      
      public function get scrollBarMarginLeft() : String
      {
         return "" + this._scrollBarMargin.left;
      }
      
      public function get scrollBarMarginRight() : String
      {
         return "" + this._scrollBarMargin.right;
      }
      
      public function get scrollBarMarginTop() : String
      {
         return "" + this._scrollBarMargin.top;
      }
      
      public function get scrollBarMarginBottom() : String
      {
         return "" + this._scrollBarMargin.bottom;
      }
      
      public function set scrollBarMarginLeft(param1:String) : void
      {
         this._scrollBarMargin.left = parseInt(param1);
         this.scrollBarMargin = this._scrollBarMargin;
      }
      
      public function set scrollBarMarginRight(param1:String) : void
      {
         this._scrollBarMargin.right = parseInt(param1);
         this.scrollBarMargin = this._scrollBarMargin;
      }
      
      public function set scrollBarMarginTop(param1:String) : void
      {
         this._scrollBarMargin.top = parseInt(param1);
         this.scrollBarMargin = this._scrollBarMargin;
      }
      
      public function set scrollBarMarginBottom(param1:String) : void
      {
         this._scrollBarMargin.bottom = parseInt(param1);
         this.scrollBarMargin = this._scrollBarMargin;
      }
      
      public function get hzScrollBarRes() : String
      {
         return this._hzScrollBarRes;
      }
      
      public function set hzScrollBarRes(param1:String) : void
      {
         this._hzScrollBarRes = param1;
         if(this.scrollPane)
         {
            this.scrollPane.onFlagsChanged(true);
         }
      }
      
      public function get vtScrollBarRes() : String
      {
         return this._vtScrollBarRes;
      }
      
      public function set vtScrollBarRes(param1:String) : void
      {
         this._vtScrollBarRes = param1;
         if(this.scrollPane)
         {
            this.scrollPane.onFlagsChanged(true);
         }
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
      
      public function get clipSoftness() : Point
      {
         return this._clipSoftness;
      }
      
      public function set clipSoftness(param1:Point) : void
      {
         this._clipSoftness = param1;
      }
      
      public function get clipSoftnessX() : int
      {
         return this._clipSoftness.x;
      }
      
      public function get clipSoftnessY() : int
      {
         return this._clipSoftness.y;
      }
      
      public function set clipSoftnessX(param1:int) : void
      {
         this._clipSoftness.x = param1;
         this.clipSoftness = this._clipSoftness;
      }
      
      public function set clipSoftnessY(param1:int) : void
      {
         this._clipSoftness.y = param1;
         this.clipSoftness = this._clipSoftness;
      }
      
      public function get viewWidth() : Number
      {
         if(this.scrollPane && this.scrollPane.installed)
         {
            return this.scrollPane.viewWidth;
         }
         return this.width - this._margin.left - this._margin.right;
      }
      
      public function get viewHeight() : Number
      {
         if(this.scrollPane && this.scrollPane.installed)
         {
            return this.scrollPane.viewHeight;
         }
         return this.height - this._margin.top - this._margin.bottom;
      }
      
      public function set viewWidth(param1:Number) : void
      {
         if(this.scrollPane && this.scrollPane.installed)
         {
            this.scrollPane.viewWidth = param1;
         }
         else
         {
            this.width = param1 + this._margin.left + this._margin.right;
         }
      }
      
      public function set viewHeight(param1:Number) : void
      {
         if(this.scrollPane && this.scrollPane.installed)
         {
            this.scrollPane.viewHeight = param1;
         }
         else
         {
            this.height = param1 + this._margin.top + this._margin.bottom;
         }
      }
      
      public function get transitions() : ETransitions
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
      
      public function get clickThrough() : Boolean
      {
         return !this._opaque;
      }
      
      public function set clickThrough(param1:Boolean) : void
      {
         this._opaque = !param1;
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
      
      public function get color() : uint
      {
         if(this._extention != null)
         {
            return this._extention.color;
         }
         return 0;
      }
      
      public function set color(param1:uint) : void
      {
         if(this._extention != null)
         {
            this._extention.color = param1;
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
         var _loc2_:EController = null;
         if(param1)
         {
            _loc2_ = parent.getController(param1);
         }
         this._pageController = _loc2_;
      }
      
      public function get pageControllerObj() : EController
      {
         return this._pageController;
      }
      
      private function updateClipRect() : void
      {
         var _loc3_:Rectangle = _displayObject.container.scrollRect;
         var _loc2_:* = Number(this.width - (this._margin.left + this._margin.right));
         var _loc1_:* = Number(this.height - (this._margin.top + this._margin.bottom));
         if(_loc2_ <= 0)
         {
            _loc2_ = 0;
         }
         if(_loc1_ <= 0)
         {
            _loc1_ = 0;
         }
         _loc3_.width = _loc2_;
         _loc3_.height = _loc1_;
         _displayObject.container.scrollRect = _loc3_;
      }
      
      public function updateOverflow() : void
      {
         if(editMode == 3)
         {
            return;
         }
         if(this._overflow == "hidden")
         {
            if(this.scrollPane)
            {
               this.scrollPane.uninstall();
            }
            _displayObject.container.scrollRect = new Rectangle();
            this.updateClipRect();
            _displayObject.container.x = this._margin.left + this.alignOffset.x;
            _displayObject.container.y = this._margin.top + this.alignOffset.y;
         }
         else if(this._overflow == "scroll")
         {
            if(!this.scrollPane)
            {
               this.scrollPane = new EScrollPane(this);
            }
            else if(this.scrollPane.installed)
            {
               this.scrollPane.onFlagsChanged();
            }
            else
            {
               this.scrollPane.install();
            }
         }
         else
         {
            _displayObject.container.scrollRect = null;
            if(this.scrollPane)
            {
               this.scrollPane.uninstall();
            }
            _displayObject.container.x = this._margin.left + this.alignOffset.x;
            _displayObject.container.y = this._margin.top + this.alignOffset.y;
         }
      }
      
      override public function create() : void
      {
         var _loc8_:String = null;
         var _loc14_:EController = null;
         var _loc12_:XML = null;
         var _loc13_:String = null;
         var _loc2_:EGObject = null;
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:int = 0;
         this._children.length = 0;
         _displayObject.container.removeChildren();
         this._controllers.length = 0;
         this.namesChanged = true;
         if(packageItem == null)
         {
            if(!(this is EGList))
            {
               setError(true);
            }
            return;
         }
         var _loc9_:XML = pkg.getComponentXML(packageItem,editMode == 3?false:true);
         if(!_loc9_)
         {
            setSize(packageItem.width,packageItem.height);
            setError(true);
            return;
         }
         setError(false);
         underConstruct = true;
         _loc8_ = _loc9_.@size;
         var _loc6_:Array = _loc8_.split(",");
         _sourceWidth = int(_loc6_[0]);
         _sourceHeight = int(_loc6_[1]);
         _loc8_ = _loc9_.@overflow;
         if(_loc8_)
         {
            this._overflow = _loc8_;
         }
         else
         {
            this._overflow = "visible";
         }
         this._opaque = _loc9_.@opaque != "false";
         _loc8_ = _loc9_.@margin;
         if(_loc8_)
         {
            this._margin.parse(_loc8_);
         }
         _loc8_ = _loc9_.@clipSoftness;
         if(_loc8_)
         {
            _loc6_ = _loc8_.split(",");
            this._clipSoftness.x = int(_loc6_[0]);
            this._clipSoftness.y = int(_loc6_[1]);
         }
         _loc8_ = _loc9_.@scroll;
         if(_loc8_)
         {
            this._scroll = _loc8_;
         }
         else
         {
            this._scroll = "vertical";
         }
         this._scrollBarFlags = parseInt(_loc9_.@scrollBarFlags);
         _loc8_ = _loc9_.@scrollBar;
         if(_loc8_)
         {
            this._scrollBarDisplay = _loc8_;
         }
         else
         {
            this._scrollBarDisplay = "default";
         }
         _loc8_ = _loc9_.@scrollBarMargin;
         if(_loc8_)
         {
            this._scrollBarMargin.parse(_loc8_);
         }
         _loc8_ = _loc9_.@scrollBarRes;
         if(_loc8_)
         {
            _loc6_ = _loc8_.split(",");
            this._vtScrollBarRes = _loc6_[0];
            this._hzScrollBarRes = _loc6_[1];
         }
         _loc8_ = _loc9_.@ptrRes;
         if(_loc8_)
         {
            _loc6_ = _loc8_.split(",");
            this._headerRes = _loc6_[0];
            this._footerRes = _loc6_[1];
         }
         this.remark = _loc9_.@remark;
         this.adaptationTest = _loc9_.@adaptationTest;
         this._instNextId = 0;
         setSize(_sourceWidth,_sourceHeight);
         aspectLocked = true;
         this.updateOverflow();
         _loc8_ = _loc9_.@pivot;
         if(_loc8_)
         {
            _anchor = _loc9_.@anchor == "true";
            _loc6_ = _loc8_.split(",");
            _pivotX = parseFloat(_loc6_[0]);
            _pivotY = parseFloat(_loc6_[1]);
            _pivotFromSource = true;
         }
         _loc8_ = _loc9_.@restrictSize;
         if(_loc8_)
         {
            _loc6_ = _loc8_.split(",");
            _minWidth = int(_loc6_[0]);
            _maxWidth = int(_loc6_[1]);
            _minHeight = int(_loc6_[2]);
            _maxHeight = int(_loc6_[3]);
            _restrictSizeFromSource = true;
         }
         var _loc7_:* = null;
         var _loc10_:* = null;
         _loc8_ = _loc9_.@mask;
         if(_loc8_)
         {
            _loc7_ = _loc8_;
         }
         _loc8_ = _loc9_.@hitTest;
         if(_loc8_)
         {
            _loc10_ = _loc8_;
         }
         this.reversedMask = _loc9_.@reversedMask == "true";
         this.buildingDisplayList = true;
         var _loc11_:XMLList = _loc9_.controller;
         var _loc16_:int = 0;
         var _loc15_:* = _loc11_;
         for each(_loc12_ in _loc11_)
         {
            _loc14_ = new EController();
            this._controllers.push(_loc14_);
            _loc14_.parent = this;
            _loc14_.fromXML(_loc12_);
         }
         _loc11_ = _loc9_.displayList.elements();
         var _loc18_:int = 0;
         var _loc17_:* = _loc11_;
         for each(_loc12_ in _loc11_)
         {
            _loc2_ = this.xmlCreateChild(_loc12_);
            if(_loc2_)
            {
               _loc2_.underConstruct = true;
               _loc2_.constructingData = _loc12_;
               _loc2_.fromXML_beforeAdd(_loc12_);
               if(_loc7_ != null && _loc7_ == _loc2_.id)
               {
                  this.mask = _loc2_;
               }
               if(_loc10_ != null && _loc10_ == _loc2_.id)
               {
                  this.hitTestSource = _loc2_;
               }
               if(editMode == 3)
               {
                  if(_loc2_.id.charAt(0) == "n")
                  {
                     _loc1_ = _loc2_.id.indexOf("_");
                     if(_loc1_ != -1)
                     {
                        _loc5_ = parseInt(_loc2_._id.substring(1,_loc1_));
                     }
                     else
                     {
                        _loc5_ = parseInt(_loc2_._id.substring(1));
                     }
                     if(_loc5_ >= this._instNextId)
                     {
                        this._instNextId = _loc5_ + 1;
                     }
                  }
               }
               this.addChild(_loc2_);
            }
         }
         _relations.fromXML(_loc9_,true);
         _loc4_ = this._children.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = this._children[_loc3_];
            _loc2_.relations.fromXML(_loc2_.constructingData,false);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = this._children[_loc3_];
            _loc2_.fromXML_afterAdd(_loc2_.constructingData);
            _loc2_.underConstruct = false;
            _loc2_.constructingData = null;
            _loc3_++;
         }
         _loc8_ = _loc9_.@extention;
         if(_loc8_)
         {
            this._extention = EUIObjectFactory.createExtention(pkg,_loc8_);
            if(this._extention)
            {
               this._extentionId = _loc8_;
            }
            this._extention.load(_loc9_[_loc8_][0]);
            this._extention.owner = this;
         }
         else if(this._extention)
         {
            this._extention.owner = null;
            this._extention = null;
         }
         _loc8_ = _loc9_.@customExtention;
         if(_loc8_)
         {
            this._customExtentionId = _loc8_;
         }
         else
         {
            this._customExtentionId = null;
         }
         this._initName = _loc9_.@initName;
         this._designImage = _loc9_.@designImage;
         _loc8_ = _loc9_.@designImageOffsetX;
         if(_loc8_)
         {
            this._designImageOffsetX = parseInt(_loc8_);
         }
         _loc8_ = _loc9_.@designImageOffsetY;
         if(_loc8_)
         {
            this._designImageOffsetY = parseInt(_loc8_);
         }
         _loc8_ = _loc9_.@designImageAlpha;
         if(_loc8_)
         {
            this._designImageAlpha = parseInt(_loc8_);
         }
         _loc8_ = _loc9_.@designImageLayer;
         if(_loc8_)
         {
            this._designImageLayer = parseInt(_loc8_);
         }
         _loc8_ = _loc9_.@bgColorEnabled;
         this._bgColorEnabled = _loc8_ == "true";
         _loc8_ = _loc9_.@bgColor;
         if(_loc8_)
         {
            this._bgColor = UtilsStr.convertFromHtmlColor(_loc8_);
         }
         this._transitions.fromXML(_loc9_);
         this.applyAllControllers();
         this.buildingDisplayList = false;
         underConstruct = false;
         this.updateDisplayList();
         this.setBoundsChangedFlag();
         if(editMode != 3 && this.mask)
         {
            displayObject.setMask(this.mask);
         }
         if(editMode != 3 && this.hitTestSource)
         {
            displayObject.setHitArea(this.hitTestSource);
         }
      }
      
      public function serialize() : XML
      {
         var _loc6_:EGObject = null;
         var _loc4_:XML = null;
         var _loc5_:int = 0;
         var _loc2_:Vector.<String> = null;
         var _loc7_:XML = <component/>;
         _loc7_.@size = int(_width) + "," + int(_height);
         if(_minWidth != 0 || _maxWidth != 0 || _minHeight != 0 || _maxHeight != 0)
         {
            _loc7_.@restrictSize = _minWidth + "," + _maxWidth + "," + _minHeight + "," + _maxHeight;
         }
         if(_pivotX != 0 || _pivotY != 0)
         {
            _loc7_.@pivot = UtilsStr.toFixed(_pivotX) + "," + UtilsStr.toFixed(_pivotY);
         }
         if(_anchor)
         {
            _loc7_.@anchor = true;
         }
         if(this._overflow != "visible")
         {
            _loc7_.@overflow = this._overflow;
         }
         if(!this._opaque)
         {
            _loc7_.@opaque = this._opaque;
         }
         if(this._scroll != "vertical")
         {
            _loc7_.@scroll = this._scroll;
         }
         if(this._overflow == "scroll")
         {
            if(this._scrollBarFlags)
            {
               _loc7_.@scrollBarFlags = this._scrollBarFlags;
            }
            if(this._scrollBarDisplay != "default")
            {
               _loc7_.@scrollBar = this._scrollBarDisplay;
            }
         }
         if(!this._margin.empty)
         {
            _loc7_.@margin = this._margin.toString();
         }
         if(!this._scrollBarMargin.empty)
         {
            _loc7_.@scrollBarMargin = this._scrollBarMargin.toString();
         }
         if(this._vtScrollBarRes || this._hzScrollBarRes)
         {
            _loc7_.@scrollBarRes = (!!this._vtScrollBarRes?this._vtScrollBarRes:"") + "," + (!!this._hzScrollBarRes?this._hzScrollBarRes:"");
         }
         if(this._headerRes || this._footerRes)
         {
            _loc7_.@ptrRes = (!!this._headerRes?this._headerRes:"") + "," + (!!this._footerRes?this._footerRes:"");
         }
         if(this._clipSoftness.x != 0 || this._clipSoftness.y != 0)
         {
            _loc7_.@clipSoftness = this._clipSoftness.x + "," + this._clipSoftness.y;
         }
         var _loc1_:int = this._controllers.length;
         _loc5_ = 0;
         while(_loc5_ < _loc1_)
         {
            _loc4_ = this._controllers[_loc5_].toXML();
            if(_loc4_)
            {
               _loc7_.appendChild(_loc4_);
            }
            _loc5_++;
         }
         _loc1_ = this._children.length;
         var _loc3_:XML = <displayList/>;
         _loc7_.appendChild(_loc3_);
         _loc5_ = 0;
         while(_loc5_ < _loc1_)
         {
            _loc6_ = this._children[_loc5_];
            if(!(_loc6_ is EGGroup && EGGroup(_loc6_).empty))
            {
               _loc4_ = _loc6_.toXML();
               _loc3_.appendChild(_loc4_);
            }
            _loc5_++;
         }
         if(this._extention)
         {
            _loc7_.@extention = this._extentionId;
            _loc4_ = this._extention.serialize();
            if(_loc4_)
            {
               _loc7_.appendChild(_loc4_);
            }
         }
         if(this._customExtentionId)
         {
            _loc7_.@customExtention = this._customExtentionId;
         }
         if(this.mask != null && this.mask.parent)
         {
            _loc7_.@mask = this.mask.id;
            if(this.reversedMask)
            {
               _loc7_.@reversedMask = this.reversedMask;
            }
         }
         if(this.hitTestSource != null && this.hitTestSource.parent)
         {
            _loc7_.@hitTest = this.hitTestSource.id;
         }
         if(this._initName)
         {
            _loc7_.@initName = this._initName;
         }
         if(this._designImage)
         {
            _loc7_.@designImage = this._designImage;
         }
         if(this._designImageOffsetX)
         {
            _loc7_.@designImageOffsetX = this._designImageOffsetX;
         }
         if(this._designImageOffsetY)
         {
            _loc7_.@designImageOffsetY = this._designImageOffsetY;
         }
         if(this._designImageAlpha != 50)
         {
            _loc7_.@designImageAlpha = this._designImageAlpha;
         }
         if(this._designImageLayer != 0)
         {
            _loc7_.@designImageLayer = this._designImageLayer;
         }
         if(this._bgColorEnabled)
         {
            _loc7_.@bgColorEnabled = this._bgColorEnabled;
         }
         if(this._bgColor != 16777215)
         {
            _loc7_.@bgColor = UtilsStr.convertToHtmlColor(this._bgColor);
         }
         if(this.remark)
         {
            _loc7_.@remark = this.remark;
         }
         if(this.adaptationTest)
         {
            _loc7_.@adaptationTest = this.adaptationTest;
         }
         if(!_relations.isEmpty)
         {
            _loc7_.appendChild(_relations.toXML().relation);
         }
         if(!this._transitions.isEmpty)
         {
            _loc7_.appendChild(this._transitions.toXML(true).transition);
         }
         return _loc7_;
      }
      
      override public function fromXML_afterAdd(param1:XML) : void
      {
         var _loc6_:XML = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:EController = null;
         super.fromXML_afterAdd(param1);
         if(this._extention)
         {
            _loc6_ = param1.elements(this._extentionId)[0];
            if(!_loc6_)
            {
               _loc6_ = <Extention/>;
            }
            this._extention.fromXML(_loc6_);
         }
         _loc4_ = param1.@pageController;
         if(_loc4_)
         {
            this._pageController = parent.getController(_loc4_);
         }
         else
         {
            this._pageController = null;
         }
         _loc4_ = param1.@controller;
         if(_loc4_)
         {
            _loc5_ = _loc4_.split(",");
            _loc2_ = 0;
            while(_loc2_ < _loc5_.length)
            {
               _loc3_ = this.getController(_loc5_[_loc2_]);
               if(_loc3_ != null)
               {
                  _loc3_.selectedPageId = _loc5_[_loc2_ + 1];
               }
               _loc2_ = _loc2_ + 2;
            }
         }
      }
      
      override public function toXML() : XML
      {
         var _loc1_:EController = null;
         var _loc2_:XML = null;
         var _loc4_:XML = super.toXML();
         if(this._extention)
         {
            _loc2_ = this._extention.toXML();
            if(_loc2_)
            {
               _loc4_.appendChild(_loc2_);
            }
         }
         if(this._pageController && this._pageController.parent)
         {
            _loc4_.@pageController = this._pageController.name;
         }
         var _loc3_:* = "";
         var _loc6_:int = 0;
         var _loc5_:* = this._controllers;
         for each(_loc1_ in this._controllers)
         {
            if(_loc1_.exported)
            {
               if(_loc3_)
               {
                  _loc3_ = _loc3_ + ",";
               }
               _loc3_ = _loc3_ + (_loc1_.name + "," + _loc1_.selectedPageId);
            }
         }
         if(_loc3_)
         {
            _loc4_.@controller = _loc3_;
         }
         return _loc4_;
      }
      
      public function validateChildren() : void
      {
         var _loc2_:int = this._children.length;
         var _loc1_:int = 0;
         while(_loc1_ < _loc2_)
         {
            this._children[_loc1_].validate();
            _loc1_++;
         }
         if(this.scrollPane)
         {
            this.scrollPane.validate();
         }
      }
      
      public function xmlCreateChild(param1:XML) : EGObject
      {
         var _loc3_:EUIPackage = null;
         var _loc4_:EPackageItem = null;
         var _loc2_:String = null;
         var _loc5_:String = param1.@pkg;
         if(_loc5_ && _loc5_ != pkg.id)
         {
            _loc3_ = pkg.project.getPackage(_loc5_);
         }
         else
         {
            _loc3_ = pkg;
         }
         if(_loc3_ != null)
         {
            _loc2_ = param1.@src;
            if(_loc2_)
            {
               _loc4_ = _loc3_.getItem(_loc2_);
               if(_loc4_ && _loc3_ != pkg && !_loc4_.exported)
               {
                  _loc4_ = null;
               }
            }
         }
         else
         {
            _loc3_ = pkg;
         }
         if(_loc4_ != null)
         {
            return EUIObjectFactory.createObject(_loc4_,editMode == 1?1:editMode == 3?2:0);
         }
         return EUIObjectFactory.createObject2(_loc3_,param1.name(),editMode == 1?1:editMode == 3?2:0);
      }
      
      public function getChildrenInfo() : String
      {
         var _loc2_:EGObject = null;
         var _loc1_:DisplayObject = null;
         var _loc5_:* = "==============\n";
         var _loc4_:int = this._children.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = this._children[_loc3_];
            _loc5_ = _loc5_ + (_loc2_.toString() + "\n");
            _loc3_++;
         }
         _loc5_ = _loc5_ + "----------\n";
         _loc4_ = _displayObject.container.numChildren;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc1_ = _displayObject.container.getChildAt(_loc3_);
            if(_loc1_ is EUISprite)
            {
               _loc5_ = _loc5_ + (EUISprite(_loc1_).owner.toString() + "\n");
            }
            _loc3_++;
         }
         return _loc5_;
      }
      
      public function getNextId() : String
      {
         var _loc1_:Number = this._instNextId;
         this._instNextId++;
         return "n" + _loc1_ + "_" + EUIProject.devCode;
      }
      
      public function isIdInUse(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:EGObject = null;
         var _loc4_:int = this._children.length;
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = this._children[_loc2_];
            if(_loc3_.id == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function containsComponent(param1:EPackageItem) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:EGComponent = null;
         var _loc4_:int = this._children.length;
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = this._children[_loc2_] as EGComponent;
            if(_loc3_)
            {
               if(_loc3_.packageItem == param1)
               {
                  return true;
               }
               if(_loc3_.containsComponent(param1))
               {
                  return true;
               }
            }
            _loc2_++;
         }
         return false;
      }
      
      public function takeSnapshot() : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         _loc3_ = this._children.length;
         this._snapshot.length = _loc3_ + 1;
         var _loc1_:ObjectSnapshot = this._snapshot[0];
         if(!_loc1_)
         {
            _loc1_ = new ObjectSnapshot();
            this._snapshot[0] = _loc1_;
         }
         this.__takeSnapshot(_loc1_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this._snapshot[_loc2_ + 1];
            if(!_loc1_)
            {
               _loc1_ = new ObjectSnapshot();
               this._snapshot[_loc2_ + 1] = _loc1_;
            }
            this._children[_loc2_].__takeSnapshot(_loc1_);
            _loc2_++;
         }
         _loc3_ = this._controllers.length;
         this._controllerSnapshot.length = _loc3_;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this._controllerSnapshot[_loc2_] = this._controllers[_loc2_].selectedPageId;
            _loc2_++;
         }
      }
      
      public function readSnapshot(param1:Boolean = true) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:ObjectSnapshot = null;
         if(param1)
         {
            _loc4_ = this._controllers.length;
            _loc2_ = 0;
            while(_loc2_ < _loc4_)
            {
               this._controllers[_loc2_].selectedPageId = this._controllerSnapshot[_loc2_];
               _loc2_++;
            }
         }
         _loc4_ = this._children.length;
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = this._snapshot[_loc2_ + 1];
            this._children[_loc2_].__readSnapshot(_loc3_);
            _loc2_++;
         }
         _loc3_ = this._snapshot[0];
         this.__readSnapshot(_loc3_);
      }
      
      public function getObjectSnapshot(param1:EGObject) : ObjectSnapshot
      {
         var _loc2_:int = 0;
         if(param1 == null)
         {
            return this._snapshot[0];
         }
         _loc2_ = this.getChildIndex(param1);
         return this._snapshot[_loc2_ + 1];
      }
      
      public function getControllerSnapshot(param1:EController) : String
      {
         var _loc2_:int = this._controllers.indexOf(param1);
         return this._controllerSnapshot[_loc2_];
      }
      
      override protected function handleDispose() : void
      {
         var _loc3_:int = 0;
         var _loc1_:EGObject = null;
         var _loc2_:int = this._children.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this._children[_loc3_];
            _loc1_.dispose();
            _loc3_++;
         }
      }
      
      private function handleTextChildrenBitmapMode(param1:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc2_:EGObject = null;
         var _loc5_:Boolean = param1 || _displayObject.deformation;
         var _loc4_:int = this._children.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = this._children[_loc3_];
            if(_loc2_ is EGTextField)
            {
               EGTextField(_loc2_).bitmapMode = _loc5_ || _loc2_.displayObject.deformation;
            }
            else if(_loc2_ is EGComponent)
            {
               EGComponent(_loc2_).handleTextChildrenBitmapMode(_loc5_);
            }
            _loc3_++;
         }
      }
      
      public function onDocumentUpdate() : void
      {
         var _loc4_:* = null;
         var _loc3_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:EGObject = null;
         this.handleTextChildrenBitmapMode(false);
         if(!this.nameMap)
         {
            this.nameMap = {};
            this.nameConflicts = [];
         }
         if(this.namesChanged && editMode == 3)
         {
            this.namesChanged = false;
            var _loc6_:int = 0;
            var _loc5_:* = this.nameMap;
            for(_loc4_ in this.nameMap)
            {
               this.nameMap[_loc4_] = 0;
            }
            _loc1_ = this._children.length;
            _loc3_ = 0;
            while(_loc3_ < _loc1_)
            {
               _loc2_ = this._children[_loc3_];
               if(_loc2_.name)
               {
                  this.nameMap[_loc2_.name] = int(this.nameMap[_loc2_.name]) + 1;
               }
               _loc3_++;
            }
            this.nameConflicts.length = 0;
            var _loc8_:int = 0;
            var _loc7_:* = this.nameMap;
            for(_loc4_ in this.nameMap)
            {
               if(this.nameMap[_loc4_] > 1)
               {
                  this.nameConflicts.push(_loc4_);
               }
            }
         }
      }
      
      public function notifyChildReplaced(param1:EGObject, param2:EGObject) : void
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
   }
}
