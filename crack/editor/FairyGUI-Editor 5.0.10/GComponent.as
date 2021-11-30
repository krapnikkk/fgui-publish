package fairygui
{
   import fairygui.display.UISprite;
   import fairygui.utils.GTimers;
   import fairygui.utils.PixelHitTest;
   import fairygui.utils.PixelHitTestData;
   import fairygui.utils.ToolSet;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class GComponent extends GObject
   {
       
      
      private var _sortingChildCount:int;
      
      private var _opaque:Boolean;
      
      private var _applyingController:Controller;
      
      protected var _margin:Margin;
      
      protected var _trackBounds:Boolean;
      
      protected var _boundsChanged:Boolean;
      
      protected var _childrenRenderOrder:int;
      
      protected var _apexIndex:int;
      
      var _buildingDisplayList:Boolean;
      
      var _children:Vector.<GObject>;
      
      var _controllers:Vector.<Controller>;
      
      var _transitions:Vector.<Transition>;
      
      var _rootContainer:Sprite;
      
      var _container:Sprite;
      
      var _scrollPane:ScrollPane;
      
      var _alignOffset:Point;
      
      public function GComponent()
      {
         super();
         _children = new Vector.<GObject>();
         _controllers = new Vector.<Controller>();
         _transitions = new Vector.<Transition>();
         _margin = new Margin();
         _alignOffset = new Point();
      }
      
      override protected function createDisplayObject() : void
      {
         _rootContainer = new UISprite(this);
         _rootContainer.mouseEnabled = false;
         setDisplayObject(_rootContainer);
         _container = _rootContainer;
      }
      
      override public function dispose() : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         var _loc4_:* = null;
         var _loc1_:* = null;
         _loc2_ = _transitions.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _transitions[_loc3_];
            _loc4_.dispose();
            _loc3_++;
         }
         if(_scrollPane)
         {
            _scrollPane.dispose();
         }
         _loc2_ = _children.length;
         _loc3_ = _loc2_ - 1;
         while(_loc3_ >= 0)
         {
            _loc1_ = _children[_loc3_];
            _loc1_.parent = null;
            _loc1_.dispose();
            _loc3_--;
         }
         _boundsChanged = false;
         super.dispose();
      }
      
      public final function get displayListContainer() : DisplayObjectContainer
      {
         return _container;
      }
      
      public function addChild(param1:GObject) : GObject
      {
         addChildAt(param1,_children.length);
         return param1;
      }
      
      public function addChildAt(param1:GObject, param2:int) : GObject
      {
         var _loc3_:int = 0;
         if(!param1)
         {
            throw new Error("child is null");
         }
         if(param2 >= 0 && param2 <= _children.length)
         {
            if(param1.parent == this)
            {
               setChildIndex(param1,param2);
            }
            else
            {
               param1.removeFromParent();
               param1.parent = this;
               _loc3_ = _children.length;
               if(param1.sortingOrder != 0)
               {
                  _sortingChildCount = Number(_sortingChildCount) + 1;
                  param2 = getInsertPosForSortingChild(param1);
               }
               else if(_sortingChildCount > 0)
               {
                  if(param2 > _loc3_ - _sortingChildCount)
                  {
                     param2 = _loc3_ - _sortingChildCount;
                  }
               }
               if(param2 == _loc3_)
               {
                  _children.push(param1);
               }
               else
               {
                  _children.splice(param2,0,param1);
               }
               childStateChanged(param1);
               if(param1.group)
               {
                  param1.group.setBoundsChangedFlag();
               }
               setBoundsChangedFlag();
            }
            return param1;
         }
         throw new RangeError("Invalid child index");
      }
      
      private function getInsertPosForSortingChild(param1:GObject) : int
      {
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc2_:int = _children.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _children[_loc3_];
            if(_loc4_ != param1)
            {
               if(param1.sortingOrder < _loc4_.sortingOrder)
               {
                  break;
               }
            }
            _loc3_++;
         }
         return _loc3_;
      }
      
      public function removeChild(param1:GObject, param2:Boolean = false) : GObject
      {
         var _loc3_:int = _children.indexOf(param1);
         if(_loc3_ != -1)
         {
            removeChildAt(_loc3_,param2);
         }
         return param1;
      }
      
      public function removeChildAt(param1:int, param2:Boolean = false) : GObject
      {
         var _loc3_:* = null;
         if(param1 >= 0 && param1 < numChildren)
         {
            _loc3_ = _children[param1];
            _loc3_.parent = null;
            if(_loc3_.sortingOrder != 0)
            {
               _sortingChildCount = Number(_sortingChildCount) - 1;
            }
            _children.splice(param1,1);
            if(_loc3_.inContainer)
            {
               _container.removeChild(_loc3_.displayObject);
               if(_childrenRenderOrder == 2)
               {
                  GTimers.inst.callLater(buildNativeDisplayList);
               }
            }
            if(_loc3_.group)
            {
               _loc3_.group.setBoundsChangedFlag();
               _loc3_.group = null;
            }
            if(param2)
            {
               _loc3_.dispose();
            }
            setBoundsChangedFlag();
            return _loc3_;
         }
         throw new RangeError("Invalid child index");
      }
      
      public function removeChildren(param1:int = 0, param2:int = -1, param3:Boolean = false) : void
      {
         var _loc4_:* = 0;
         if(param2 < 0 || param2 >= numChildren)
         {
            param2 = numChildren - 1;
         }
         _loc4_ = param1;
         while(_loc4_ <= param2)
         {
            removeChildAt(param1,param3);
            _loc4_++;
         }
      }
      
      public function getChildAt(param1:int) : GObject
      {
         if(param1 >= 0 && param1 < numChildren)
         {
            return _children[param1];
         }
         throw new RangeError("Invalid child index");
      }
      
      public function getChild(param1:String) : GObject
      {
         var _loc3_:int = 0;
         var _loc2_:int = _children.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(_children[_loc3_].name == param1)
            {
               return _children[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getChildByPath(param1:String) : GObject
      {
         var _loc3_:* = null;
         var _loc5_:int = 0;
         var _loc2_:Array = param1.split(".");
         var _loc4_:int = _loc2_.length;
         var _loc6_:* = this;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = _loc6_.getChild(_loc2_[_loc5_]);
            if(_loc3_)
            {
               if(_loc5_ != _loc4_ - 1)
               {
                  _loc6_ = _loc3_ as GComponent;
                  if(!_loc6_)
                  {
                     _loc3_ = null;
                     break;
                  }
               }
               _loc5_++;
               continue;
            }
            break;
         }
         return _loc3_;
      }
      
      public function getChildren() : Vector.<GObject>
      {
         return _children.concat();
      }
      
      public function getVisibleChild(param1:String) : GObject
      {
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc2_:int = _children.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _children[_loc3_];
            if(_loc4_.internalVisible && _loc4_.internalVisible2 && _loc4_.name == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getChildInGroup(param1:String, param2:GGroup) : GObject
      {
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc3_:int = _children.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _children[_loc4_];
            if(_loc5_.group == param2 && _loc5_.name == param1)
            {
               return _loc5_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function getChildById(param1:String) : GObject
      {
         var _loc3_:int = 0;
         var _loc2_:int = _children.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(_children[_loc3_]._id == param1)
            {
               return _children[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getChildIndex(param1:GObject) : int
      {
         return _children.indexOf(param1);
      }
      
      public function setChildIndex(param1:GObject, param2:int) : void
      {
         var _loc4_:int = _children.indexOf(param1);
         if(_loc4_ == -1)
         {
            throw new ArgumentError("Not a child of this container");
         }
         if(param1.sortingOrder != 0)
         {
            return;
         }
         var _loc3_:int = _children.length;
         if(_sortingChildCount > 0)
         {
            if(param2 > _loc3_ - _sortingChildCount - 1)
            {
               param2 = _loc3_ - _sortingChildCount - 1;
            }
         }
         _setChildIndex(param1,_loc4_,param2);
      }
      
      public function setChildIndexBefore(param1:GObject, param2:int) : int
      {
         var _loc4_:int = _children.indexOf(param1);
         if(_loc4_ == -1)
         {
            throw new ArgumentError("Not a child of this container");
         }
         if(param1.sortingOrder != 0)
         {
            return _loc4_;
         }
         var _loc3_:int = _children.length;
         if(_sortingChildCount > 0)
         {
            if(param2 > _loc3_ - _sortingChildCount - 1)
            {
               param2 = _loc3_ - _sortingChildCount - 1;
            }
         }
         if(_loc4_ < param2)
         {
            return _setChildIndex(param1,_loc4_,param2 - 1);
         }
         return _setChildIndex(param1,_loc4_,param2);
      }
      
      private function _setChildIndex(param1:GObject, param2:int, param3:int) : int
      {
         var _loc7_:int = 0;
         var _loc4_:* = null;
         var _loc6_:int = 0;
         var _loc5_:int = _children.length;
         if(param3 > _loc5_)
         {
            param3 = _loc5_;
         }
         if(param2 == param3)
         {
            return param3;
         }
         _children.splice(param2,1);
         _children.splice(param3,0,param1);
         if(param1.inContainer)
         {
            if(_childrenRenderOrder == 0)
            {
               _loc6_ = 0;
               while(_loc6_ < param3)
               {
                  _loc4_ = _children[_loc6_];
                  if(_loc4_.inContainer)
                  {
                     _loc7_++;
                  }
                  _loc6_++;
               }
               if(_loc7_ == _container.numChildren)
               {
                  _loc7_--;
               }
               _container.setChildIndex(param1.displayObject,_loc7_);
            }
            else if(_childrenRenderOrder == 1)
            {
               _loc6_ = _loc5_ - 1;
               while(_loc6_ > param3)
               {
                  _loc4_ = _children[_loc6_];
                  if(_loc4_.inContainer)
                  {
                     _loc7_++;
                  }
                  _loc6_--;
               }
               if(_loc7_ == _container.numChildren)
               {
                  _loc7_--;
               }
               _container.setChildIndex(param1.displayObject,_loc7_);
            }
            else
            {
               GTimers.inst.callLater(buildNativeDisplayList);
            }
            setBoundsChangedFlag();
         }
         return param3;
      }
      
      public function swapChildren(param1:GObject, param2:GObject) : void
      {
         var _loc3_:int = _children.indexOf(param1);
         var _loc4_:int = _children.indexOf(param2);
         if(_loc3_ == -1 || _loc4_ == -1)
         {
            throw new ArgumentError("Not a child of this container");
         }
         swapChildrenAt(_loc3_,_loc4_);
      }
      
      public function swapChildrenAt(param1:int, param2:int) : void
      {
         var _loc4_:GObject = _children[param1];
         var _loc3_:GObject = _children[param2];
         setChildIndex(_loc4_,param2);
         setChildIndex(_loc3_,param1);
      }
      
      public function sortChildren(param1:Function) : void
      {
         _children.sort(param1);
         buildNativeDisplayList();
         setBoundsChangedFlag();
      }
      
      public final function get numChildren() : int
      {
         return _children.length;
      }
      
      public function isAncestorOf(param1:GObject) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         var _loc2_:GComponent = param1.parent;
         while(_loc2_)
         {
            if(_loc2_ == this)
            {
               return true;
            }
            _loc2_ = _loc2_.parent;
         }
         return false;
      }
      
      public function addController(param1:Controller) : void
      {
         _controllers.push(param1);
         param1._parent = this;
         applyController(param1);
      }
      
      public function getControllerAt(param1:int) : Controller
      {
         return _controllers[param1];
      }
      
      public function getController(param1:String) : Controller
      {
         var _loc4_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = _controllers.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = _controllers[_loc4_];
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function removeController(param1:Controller) : void
      {
         var _loc2_:int = _controllers.indexOf(param1);
         if(_loc2_ == -1)
         {
            throw new Error("controller not exists");
         }
         param1._parent = null;
         _controllers.splice(_loc2_,1);
         var _loc5_:int = 0;
         var _loc4_:* = _children;
         for each(var _loc3_ in _children)
         {
            _loc3_.handleControllerChanged(param1);
         }
      }
      
      public final function get controllers() : Vector.<Controller>
      {
         return _controllers;
      }
      
      function childStateChanged(param1:GObject) : void
      {
         var _loc2_:* = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(_buildingDisplayList)
         {
            return;
         }
         var _loc3_:int = _children.length;
         if(param1 is GGroup)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc2_ = _children[_loc4_];
               if(_loc2_.group == param1)
               {
                  childStateChanged(_loc2_);
               }
               _loc4_++;
            }
            return;
         }
         if(!param1.displayObject)
         {
            return;
         }
         if(param1.internalVisible)
         {
            if(!param1.displayObject.parent)
            {
               if(_childrenRenderOrder == 0)
               {
                  _loc4_ = 0;
                  while(_loc4_ < _loc3_)
                  {
                     _loc2_ = _children[_loc4_];
                     if(_loc2_ != param1)
                     {
                        if(_loc2_.displayObject != null && _loc2_.displayObject.parent != null)
                        {
                           _loc5_++;
                        }
                        _loc4_++;
                        continue;
                     }
                     break;
                  }
                  _container.addChildAt(param1.displayObject,_loc5_);
               }
               else if(_childrenRenderOrder == 1)
               {
                  _loc4_ = _loc3_ - 1;
                  while(_loc4_ >= 0)
                  {
                     _loc2_ = _children[_loc4_];
                     if(_loc2_ != param1)
                     {
                        if(_loc2_.displayObject != null && _loc2_.displayObject.parent != null)
                        {
                           _loc5_++;
                        }
                        _loc4_--;
                        continue;
                     }
                     break;
                  }
                  _container.addChildAt(param1.displayObject,_loc5_);
               }
               else
               {
                  _container.addChild(param1.displayObject);
                  GTimers.inst.callLater(buildNativeDisplayList);
               }
            }
         }
         else if(param1.displayObject.parent)
         {
            _container.removeChild(param1.displayObject);
            if(_childrenRenderOrder == 2)
            {
               GTimers.inst.callLater(buildNativeDisplayList);
            }
         }
      }
      
      private function buildNativeDisplayList() : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc1_:int = _children.length;
         if(_loc1_ == 0)
         {
            return;
         }
         loop4:
         switch(int(_childrenRenderOrder))
         {
            case 0:
               _loc2_ = 0;
               while(_loc2_ < _loc1_)
               {
                  _loc3_ = _children[_loc2_];
                  if(_loc3_.displayObject != null && _loc3_.internalVisible)
                  {
                     _container.addChild(_loc3_.displayObject);
                  }
                  _loc2_++;
               }
               break;
            case 1:
               _loc2_ = _loc1_ - 1;
               while(_loc2_ >= 0)
               {
                  _loc3_ = _children[_loc2_];
                  if(_loc3_.displayObject != null && _loc3_.internalVisible)
                  {
                     _container.addChild(_loc3_.displayObject);
                  }
                  _loc2_--;
               }
               break;
            case 2:
               _loc4_ = ToolSet.clamp(_apexIndex,0,_loc1_);
               _loc2_ = 0;
               while(_loc2_ < _loc4_)
               {
                  _loc3_ = _children[_loc2_];
                  if(_loc3_.displayObject != null && _loc3_.internalVisible)
                  {
                     _container.addChild(_loc3_.displayObject);
                  }
                  _loc2_++;
               }
               _loc2_ = _loc1_ - 1;
               while(true)
               {
                  if(_loc2_ < _loc4_)
                  {
                     break loop4;
                  }
                  _loc3_ = _children[_loc2_];
                  if(_loc3_.displayObject != null && _loc3_.internalVisible)
                  {
                     _container.addChild(_loc3_.displayObject);
                  }
                  _loc2_--;
               }
         }
      }
      
      function applyController(param1:Controller) : void
      {
         _applyingController = param1;
         var _loc4_:int = 0;
         var _loc3_:* = _children;
         for each(var _loc2_ in _children)
         {
            _loc2_.handleControllerChanged(param1);
         }
         _applyingController = null;
         param1.runActions();
      }
      
      function applyAllControllers() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = _controllers.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            applyController(_controllers[_loc2_]);
            _loc2_++;
         }
      }
      
      function adjustRadioGroupDepth(param1:GObject, param2:Controller) : void
      {
         var _loc5_:int = 0;
         var _loc6_:* = null;
         var _loc4_:int = _children.length;
         var _loc7_:* = -1;
         var _loc3_:* = -1;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _children[_loc5_];
            if(_loc6_ == param1)
            {
               _loc7_ = _loc5_;
            }
            else if(_loc6_ is GButton && GButton(_loc6_).relatedController == param2)
            {
               if(_loc5_ > _loc3_)
               {
                  _loc3_ = _loc5_;
               }
            }
            _loc5_++;
         }
         if(_loc7_ < _loc3_)
         {
            if(_applyingController != null)
            {
               _children[_loc3_].handleControllerChanged(_applyingController);
            }
            this.swapChildrenAt(_loc7_,_loc3_);
         }
      }
      
      public function getTransitionAt(param1:int) : Transition
      {
         return _transitions[param1];
      }
      
      public function getTransition(param1:String) : Transition
      {
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc2_:int = _transitions.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _transitions[_loc3_];
            if(_loc4_.name == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public final function get scrollPane() : ScrollPane
      {
         return _scrollPane;
      }
      
      public function isChildInView(param1:GObject) : Boolean
      {
         if(_scrollPane != null)
         {
            return _scrollPane.isChildInView(param1);
         }
         if(_container.scrollRect != null)
         {
            return param1.x + param1.width >= 0 && param1.x <= this.width && param1.y + param1.height >= 0 && param1.y <= this.height;
         }
         return true;
      }
      
      public function getFirstChildInView() : int
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc1_:int = _children.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = _children[_loc2_];
            if(isChildInView(_loc3_))
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public final function get opaque() : Boolean
      {
         return _opaque;
      }
      
      public function set opaque(param1:Boolean) : void
      {
         if(_opaque != param1)
         {
            _opaque = param1;
            if(_opaque)
            {
               updateOpaque();
            }
            else
            {
               _rootContainer.graphics.clear();
            }
            _rootContainer.mouseEnabled = this.touchable && (_opaque || _rootContainer.hitArea != null);
         }
      }
      
      public final function get hitArea() : Sprite
      {
         return _rootContainer.hitArea;
      }
      
      public function set hitArea(param1:Sprite) : void
      {
         if(_rootContainer.hitArea != null)
         {
            _rootContainer.removeChild(_rootContainer.hitArea);
         }
         if(param1 != null)
         {
            _rootContainer.hitArea = param1;
            _rootContainer.addChild(_rootContainer.hitArea);
            _rootContainer.mouseChildren = false;
         }
         else
         {
            _rootContainer.hitArea = null;
            _rootContainer.mouseChildren = this.touchable;
         }
         _rootContainer.mouseEnabled = this.touchable && (_opaque || param1 != null);
      }
      
      function handleTouchable(param1:Boolean) : void
      {
         _rootContainer.mouseEnabled = param1 && (_opaque || _rootContainer.hitArea != null);
         _rootContainer.mouseChildren = param1 && _rootContainer.hitArea == null;
      }
      
      public function get margin() : Margin
      {
         return _margin;
      }
      
      public function set margin(param1:Margin) : void
      {
         _margin.copy(param1);
         if(_container.scrollRect != null)
         {
            _container.x = _margin.left + _alignOffset.x;
            _container.y = _margin.top + _alignOffset.y;
         }
         handleSizeChanged();
      }
      
      public function get childrenRenderOrder() : int
      {
         return _childrenRenderOrder;
      }
      
      public function set childrenRenderOrder(param1:int) : void
      {
         if(_childrenRenderOrder != param1)
         {
            _childrenRenderOrder = param1;
            buildNativeDisplayList();
         }
      }
      
      public function get apexIndex() : int
      {
         return _apexIndex;
      }
      
      public function set apexIndex(param1:int) : void
      {
         if(_apexIndex != param1)
         {
            _apexIndex = param1;
            if(_childrenRenderOrder == 2)
            {
               buildNativeDisplayList();
            }
         }
      }
      
      public function get mask() : DisplayObject
      {
         return _container.mask;
      }
      
      public function set mask(param1:DisplayObject) : void
      {
         _container.mask = param1;
      }
      
      protected function updateOpaque() : void
      {
         var _loc1_:* = Number(this.width);
         var _loc3_:* = Number(this.height);
         if(_loc1_ == 0)
         {
            _loc1_ = 1;
         }
         if(_loc3_ == 0)
         {
            _loc3_ = 1;
         }
         var _loc2_:Graphics = _rootContainer.graphics;
         _loc2_.clear();
         _loc2_.lineStyle(0,0,0);
         _loc2_.beginFill(0,0);
         _loc2_.drawRect(0,0,_loc1_,_loc3_);
         _loc2_.endFill();
      }
      
      protected function updateClipRect() : void
      {
         var _loc1_:Rectangle = _container.scrollRect;
         var _loc2_:* = Number(this.width - (_margin.left + _margin.right));
         var _loc3_:* = Number(this.height - (_margin.top + _margin.bottom));
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
         _container.scrollRect = _loc1_;
      }
      
      protected function setupScroll(param1:Margin, param2:int, param3:int, param4:int, param5:String, param6:String, param7:String, param8:String) : void
      {
         if(_rootContainer == _container)
         {
            _container = new Sprite();
            _rootContainer.addChild(_container);
         }
         _scrollPane = new ScrollPane(this,param2,param1,param3,param4,param5,param6,param7,param8);
      }
      
      protected function setupOverflow(param1:int) : void
      {
         if(param1 == 1)
         {
            if(_rootContainer == _container)
            {
               _container = new Sprite();
               _rootContainer.addChild(_container);
            }
            _container.scrollRect = new Rectangle();
            updateClipRect();
            _container.x = _margin.left;
            _container.y = _margin.top;
         }
         else if(_margin.left != 0 || _margin.top != 0)
         {
            if(_rootContainer == _container)
            {
               _container = new Sprite();
               _rootContainer.addChild(_container);
            }
            _container.x = _margin.left;
            _container.y = _margin.top;
         }
      }
      
      override protected function handleSizeChanged() : void
      {
         if(_scrollPane)
         {
            _scrollPane.onOwnerSizeChanged();
         }
         if(_container.scrollRect)
         {
            updateClipRect();
         }
         if(_opaque)
         {
            updateOpaque();
         }
      }
      
      override protected function handleGrayedChanged() : void
      {
         var _loc4_:int = 0;
         var _loc1_:Controller = getController("grayed");
         if(_loc1_ != null)
         {
            _loc1_.selectedIndex = !!this.grayed?1:0;
            return;
         }
         var _loc2_:Boolean = this.grayed;
         var _loc3_:int = _children.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _children[_loc4_].grayed = _loc2_;
            _loc4_++;
         }
      }
      
      override public function handleControllerChanged(param1:Controller) : void
      {
         super.handleControllerChanged(param1);
         if(_scrollPane != null)
         {
            _scrollPane.handleControllerChanged(param1);
         }
      }
      
      public function setBoundsChangedFlag() : void
      {
         if(!_scrollPane && !_trackBounds)
         {
            return;
         }
         if(!_boundsChanged)
         {
            _boundsChanged = true;
            GTimers.inst.add(0,1,__render);
         }
      }
      
      private function __render() : void
      {
         if(_boundsChanged)
         {
            var _loc3_:int = 0;
            var _loc2_:* = _children;
            for each(var _loc1_ in _children)
            {
               _loc1_.ensureSizeCorrect();
            }
            updateBounds();
         }
      }
      
      public function ensureBoundsCorrect() : void
      {
         var _loc3_:int = 0;
         var _loc2_:* = _children;
         for each(var _loc1_ in _children)
         {
            _loc1_.ensureSizeCorrect();
         }
         if(_boundsChanged)
         {
            updateBounds();
         }
      }
      
      protected function updateBounds() : void
      {
         var _loc7_:* = 0;
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = 0;
         var _loc2_:* = 0;
         var _loc4_:int = 0;
         if(_children.length > 0)
         {
            _loc6_ = 2147483647;
            _loc7_ = int(2147483647);
            2147483647;
            _loc2_ = -2147483648;
            var _loc1_:* = -2147483648;
            var _loc10_:int = 0;
            var _loc9_:* = _children;
            for each(var _loc8_ in _children)
            {
               _loc4_ = _loc8_.x;
               if(_loc4_ < _loc6_)
               {
                  _loc6_ = _loc4_;
               }
               _loc4_ = _loc8_.y;
               if(_loc4_ < _loc7_)
               {
                  _loc7_ = _loc4_;
               }
               _loc4_ = _loc8_.x + _loc8_.actualWidth;
               if(_loc4_ > _loc2_)
               {
                  _loc2_ = _loc4_;
               }
               _loc4_ = _loc8_.y + _loc8_.actualHeight;
               if(_loc4_ > _loc1_)
               {
                  _loc1_ = _loc4_;
               }
            }
            _loc3_ = _loc2_ - _loc6_;
            _loc5_ = _loc1_ - _loc7_;
         }
         else
         {
            _loc6_ = 0;
            _loc7_ = 0;
            _loc3_ = 0;
            _loc5_ = 0;
         }
         setBounds(_loc6_,_loc7_,_loc3_,_loc5_);
      }
      
      protected function setBounds(param1:int, param2:int, param3:int, param4:int) : void
      {
         _boundsChanged = false;
         if(_scrollPane)
         {
            _scrollPane.setContentSize(Math.round(param1 + param3),Math.round(param2 + param4));
         }
      }
      
      public function get viewWidth() : int
      {
         if(_scrollPane != null)
         {
            return _scrollPane.viewWidth;
         }
         return this.width - _margin.left - _margin.right;
      }
      
      public function set viewWidth(param1:int) : void
      {
         if(_scrollPane != null)
         {
            _scrollPane.viewWidth = param1;
         }
         else
         {
            this.width = param1 + _margin.left + _margin.right;
         }
      }
      
      public function get viewHeight() : int
      {
         if(_scrollPane != null)
         {
            return _scrollPane.viewHeight;
         }
         return this.height - _margin.top - _margin.bottom;
      }
      
      public function set viewHeight(param1:int) : void
      {
         if(_scrollPane != null)
         {
            _scrollPane.viewHeight = param1;
         }
         else
         {
            this.height = param1 + _margin.top + _margin.bottom;
         }
      }
      
      public function getSnappingPosition(param1:Number, param2:Number, param3:Point = null) : Point
      {
         var _loc5_:* = null;
         if(!param3)
         {
            param3 = new Point();
         }
         var _loc6_:int = _children.length;
         if(_loc6_ == 0)
         {
            param3.x = param1;
            param3.y = param2;
            return param3;
         }
         ensureBoundsCorrect();
         var _loc4_:GObject = null;
         var _loc7_:int = 0;
         if(param2 != 0)
         {
            while(_loc7_ < _loc6_)
            {
               _loc4_ = _children[_loc7_];
               if(param2 < _loc4_.y)
               {
                  if(_loc7_ == 0)
                  {
                     param2 = 0;
                     break;
                  }
                  _loc5_ = _children[_loc7_ - 1];
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
               _loc7_++;
            }
            if(_loc7_ == _loc6_)
            {
               param2 = Number(_loc4_.y);
            }
         }
         if(param1 != 0)
         {
            if(_loc7_ > 0)
            {
               _loc7_--;
            }
            while(_loc7_ < _loc6_)
            {
               _loc4_ = _children[_loc7_];
               if(param1 < _loc4_.x)
               {
                  if(_loc7_ == 0)
                  {
                     param1 = 0;
                     break;
                  }
                  _loc5_ = _children[_loc7_ - 1];
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
               _loc7_++;
            }
            if(_loc7_ == _loc6_)
            {
               param1 = Number(_loc4_.x);
            }
         }
         param3.x = param1;
         param3.y = param2;
         return param3;
      }
      
      function childSortingOrderChanged(param1:GObject, param2:int, param3:int) : void
      {
         var _loc5_:int = 0;
         var _loc4_:int = 0;
         if(param3 == 0)
         {
            _sortingChildCount = Number(_sortingChildCount) - 1;
            setChildIndex(param1,_children.length);
         }
         else
         {
            if(param2 == 0)
            {
               _sortingChildCount = Number(_sortingChildCount) + 1;
            }
            _loc5_ = _children.indexOf(param1);
            _loc4_ = getInsertPosForSortingChild(param1);
            if(_loc5_ < _loc4_)
            {
               _setChildIndex(param1,_loc5_,_loc4_ - 1);
            }
            else
            {
               _setChildIndex(param1,_loc5_,_loc4_);
            }
         }
      }
      
      override public function constructFromResource() : void
      {
         constructFromResource2(null,0);
      }
      
      function constructFromResource2(param1:Vector.<GObject>, param2:int) : void
      {
         var _loc20_:* = null;
         var _loc11_:* = null;
         var _loc7_:int = 0;
         var _loc14_:int = 0;
         var _loc23_:int = 0;
         var _loc18_:int = 0;
         var _loc6_:* = null;
         var _loc9_:* = null;
         var _loc19_:* = null;
         var _loc10_:* = null;
         var _loc21_:* = null;
         var _loc12_:* = null;
         var _loc24_:* = null;
         var _loc15_:int = 0;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc25_:* = null;
         var _loc13_:PackageItem = packageItem.getBranch();
         var _loc8_:XML = _loc13_.owner.getComponentData(_loc13_);
         _underConstruct = true;
         _loc20_ = _loc8_.@size;
         _loc11_ = _loc20_.split(",");
         sourceWidth = int(_loc11_[0]);
         sourceHeight = int(_loc11_[1]);
         initWidth = sourceWidth;
         initHeight = sourceHeight;
         setSize(sourceWidth,sourceHeight);
         _loc20_ = _loc8_.@pivot;
         if(_loc20_)
         {
            _loc11_ = _loc20_.split(",");
            _loc20_ = _loc8_.@anchor;
            internalSetPivot(parseFloat(_loc11_[0]),parseFloat(_loc11_[1]),_loc20_ == "true");
         }
         _loc20_ = _loc8_.@restrictSize;
         if(_loc20_)
         {
            _loc11_ = _loc20_.split(",");
            minWidth = parseInt(_loc11_[0]);
            maxWidth = parseInt(_loc11_[1]);
            minHeight = parseInt(_loc11_[2]);
            maxHeight = parseInt(_loc11_[3]);
         }
         _loc20_ = _loc8_.@opaque;
         if(_loc20_ != "false")
         {
            this.opaque = true;
         }
         _loc20_ = _loc8_.@overflow;
         if(_loc20_)
         {
            _loc7_ = OverflowType.parse(_loc20_);
         }
         else
         {
            _loc7_ = 0;
         }
         _loc20_ = _loc8_.@margin;
         if(_loc20_)
         {
            _margin.parse(_loc20_);
         }
         if(_loc7_ == 2)
         {
            _loc20_ = _loc8_.@scroll;
            if(_loc20_)
            {
               _loc14_ = ScrollType.parse(_loc20_);
            }
            else
            {
               _loc14_ = 1;
            }
            _loc20_ = _loc8_.@scrollBar;
            if(_loc20_)
            {
               _loc23_ = ScrollBarDisplayType.parse(_loc20_);
            }
            else
            {
               _loc23_ = 0;
            }
            _loc18_ = parseInt(_loc8_.@scrollBarFlags);
            _loc6_ = new Margin();
            _loc20_ = _loc8_.@scrollBarMargin;
            if(_loc20_)
            {
               _loc6_.parse(_loc20_);
            }
            _loc20_ = _loc8_.@scrollBarRes;
            if(_loc20_)
            {
               _loc11_ = _loc20_.split(",");
               _loc9_ = _loc11_[0];
               _loc19_ = _loc11_[1];
            }
            _loc20_ = _loc8_.@ptrRes;
            if(_loc20_)
            {
               _loc11_ = _loc20_.split(",");
               _loc10_ = _loc11_[0];
               _loc21_ = _loc11_[1];
            }
            setupScroll(_loc6_,_loc14_,_loc23_,_loc18_,_loc9_,_loc19_,_loc10_,_loc21_);
         }
         else
         {
            setupOverflow(_loc7_);
         }
         _buildingDisplayList = true;
         var _loc3_:XMLList = _loc8_.controller;
         var _loc27_:int = 0;
         var _loc26_:* = _loc3_;
         for each(var _loc22_ in _loc3_)
         {
            _loc12_ = new Controller();
            _controllers.push(_loc12_);
            _loc12_._parent = this;
            _loc12_.setup(_loc22_);
         }
         var _loc17_:Vector.<DisplayListItem> = _loc13_.displayList;
         var _loc16_:int = _loc17_.length;
         _loc15_ = 0;
         while(_loc15_ < _loc16_)
         {
            _loc4_ = _loc17_[_loc15_];
            if(param1 != null)
            {
               _loc24_ = param1[param2 + _loc15_];
            }
            else if(_loc4_.packageItem)
            {
               _loc24_ = UIObjectFactory.newObject(_loc4_.packageItem);
               _loc24_.packageItem = _loc4_.packageItem;
               _loc24_.constructFromResource();
            }
            else
            {
               _loc24_ = UIObjectFactory.newObject2(_loc4_.type);
            }
            _loc24_._underConstruct = true;
            _loc24_.setup_beforeAdd(_loc4_.desc);
            _loc24_.parent = this;
            _children.push(_loc24_);
            _loc15_++;
         }
         this.relations.setup(_loc8_);
         _loc15_ = 0;
         while(_loc15_ < _loc16_)
         {
            _children[_loc15_].relations.setup(_loc17_[_loc15_].desc);
            _loc15_++;
         }
         _loc15_ = 0;
         while(_loc15_ < _loc16_)
         {
            _loc24_ = _children[_loc15_];
            _loc24_.setup_afterAdd(_loc17_[_loc15_].desc);
            _loc24_._underConstruct = false;
            _loc15_++;
         }
         _loc20_ = _loc8_.@mask;
         if(_loc20_)
         {
            this.mask = getChildById(_loc20_).displayObject;
         }
         _loc20_ = _loc8_.@hitTest;
         if(_loc20_)
         {
            _loc11_ = _loc20_.split(",");
            if(_loc11_.length == 1)
            {
               _loc24_ = getChildById(_loc20_);
               if(_loc24_)
               {
                  this.hitArea = Sprite(_loc24_.displayObject);
               }
            }
            else
            {
               _loc5_ = _loc13_.owner.getPixelHitTestData(_loc11_[0]);
               if(_loc5_ != null)
               {
                  this.hitArea = new PixelHitTest(_loc5_,parseInt(_loc11_[1]),parseInt(_loc11_[2])).createHitAreaSprite();
               }
            }
         }
         _loc3_ = _loc8_.transition;
         var _loc29_:int = 0;
         var _loc28_:* = _loc3_;
         for each(_loc22_ in _loc3_)
         {
            _loc25_ = new Transition(this);
            _transitions.push(_loc25_);
            _loc25_.setup(_loc22_);
         }
         if(_transitions.length > 0)
         {
            this.addEventListener("addedToStage",__addedToStage);
            this.addEventListener("removedFromStage",__removedFromStage);
         }
         applyAllControllers();
         _buildingDisplayList = false;
         _underConstruct = false;
         buildNativeDisplayList();
         setBoundsChangedFlag();
         constructFromXML(_loc8_);
      }
      
      protected function constructFromXML(param1:XML) : void
      {
      }
      
      override public function setup_afterAdd(param1:XML) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc7_:int = 0;
         var _loc4_:* = null;
         var _loc11_:* = null;
         var _loc9_:int = 0;
         var _loc10_:* = null;
         var _loc6_:* = null;
         super.setup_afterAdd(param1);
         if(scrollPane)
         {
            _loc2_ = param1.@pageController;
            if(_loc2_)
            {
               scrollPane.pageController = parent.getController(_loc2_);
            }
         }
         _loc2_ = param1.@controller;
         if(_loc2_)
         {
            _loc3_ = _loc2_.split(",");
            _loc7_ = 0;
            while(_loc7_ < _loc3_.length)
            {
               _loc4_ = getController(_loc3_[_loc7_]);
               if(_loc4_)
               {
                  _loc4_.selectedPageId = _loc3_[_loc7_ + 1];
               }
               _loc7_ = _loc7_ + 2;
            }
         }
         var _loc5_:XMLList = param1.property;
         var _loc13_:int = 0;
         var _loc12_:* = _loc5_;
         for each(var _loc8_ in _loc5_)
         {
            _loc11_ = _loc8_.@target;
            _loc9_ = parseInt(_loc8_.@propertyId);
            _loc10_ = _loc8_.@value;
            _loc6_ = getChildByPath(_loc11_);
            if(_loc6_)
            {
               _loc6_.setProp(_loc9_,_loc10_);
            }
         }
      }
      
      private function __addedToStage(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = _transitions.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _transitions[_loc3_].onOwnerAddedToStage();
            _loc3_++;
         }
      }
      
      private function __removedFromStage(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = _transitions.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _transitions[_loc3_].onOwnerRemovedFromStage();
            _loc3_++;
         }
      }
   }
}
