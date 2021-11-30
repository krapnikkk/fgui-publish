package fairygui
{
   import fairygui.display.UIDisplayObject;
   import fairygui.event.GTouchEvent;
   import fairygui.event.ItemEvent;
   import fairygui.utils.GTimers;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class GList extends GComponent
   {
      
      private static var itemInfoVer:uint = 0;
      
      private static var enterCounter:uint = 0;
      
      private static var pos_param:Number;
       
      
      public var itemRenderer:Function;
      
      public var itemProvider:Function;
      
      public var scrollItemToViewOnClick:Boolean;
      
      public var foldInvisibleItems:Boolean;
      
      private var _layout:int;
      
      private var _lineCount:int;
      
      private var _columnCount:int;
      
      private var _lineGap:int;
      
      private var _columnGap:int;
      
      private var _defaultItem:String;
      
      private var _autoResizeItem:Boolean;
      
      private var _selectionMode:int;
      
      private var _align:int;
      
      private var _verticalAlign:int;
      
      private var _selectionController:Controller;
      
      private var _lastSelectedIndex:int;
      
      private var _pool:GObjectPool;
      
      private var _virtual:Boolean;
      
      private var _loop:Boolean;
      
      private var _numItems:int;
      
      private var _realNumItems:int;
      
      private var _firstIndex:int;
      
      private var _curLineItemCount:int;
      
      private var _curLineItemCount2:int;
      
      private var _itemSize:Point;
      
      private var _virtualListChanged:int;
      
      private var _eventLocked:Boolean;
      
      private var _virtualItems:Vector.<ItemInfo>;
      
      public function GList()
      {
         super();
         _trackBounds = true;
         _pool = new GObjectPool();
         _layout = 0;
         _autoResizeItem = true;
         _lastSelectedIndex = -1;
         this.opaque = true;
         scrollItemToViewOnClick = true;
         _align = 0;
         _verticalAlign = 0;
         _container = new Sprite();
         _rootContainer.addChild(_container);
      }
      
      override public function dispose() : void
      {
         _pool.clear();
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
            if(_virtual)
            {
               setVirtualListChangedFlag(true);
            }
         }
      }
      
      public final function get lineCount() : int
      {
         return _lineCount;
      }
      
      public final function set lineCount(param1:int) : void
      {
         if(_lineCount != param1)
         {
            _lineCount = param1;
            if(_layout == 3 || _layout == 4)
            {
               setBoundsChangedFlag();
               if(_virtual)
               {
                  setVirtualListChangedFlag(true);
               }
            }
         }
      }
      
      public final function get columnCount() : int
      {
         return _columnCount;
      }
      
      public final function set columnCount(param1:int) : void
      {
         if(_columnCount != param1)
         {
            _columnCount = param1;
            if(_layout == 2 || _layout == 4)
            {
               setBoundsChangedFlag();
               if(_virtual)
               {
                  setVirtualListChangedFlag(true);
               }
            }
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
            if(_virtual)
            {
               setVirtualListChangedFlag(true);
            }
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
            if(_virtual)
            {
               setVirtualListChangedFlag(true);
            }
         }
      }
      
      public function get align() : int
      {
         return _align;
      }
      
      public function set align(param1:int) : void
      {
         if(_align != param1)
         {
            _align = param1;
            setBoundsChangedFlag();
            if(_virtual)
            {
               setVirtualListChangedFlag(true);
            }
         }
      }
      
      public final function get verticalAlign() : int
      {
         return _verticalAlign;
      }
      
      public function set verticalAlign(param1:int) : void
      {
         if(_verticalAlign != param1)
         {
            _verticalAlign = param1;
            setBoundsChangedFlag();
            if(_virtual)
            {
               setVirtualListChangedFlag(true);
            }
         }
      }
      
      public final function get virtualItemSize() : Point
      {
         return _itemSize;
      }
      
      public final function set virtualItemSize(param1:Point) : void
      {
         if(_virtual)
         {
            if(_itemSize == null)
            {
               _itemSize = new Point();
            }
            _itemSize.copyFrom(param1);
            setVirtualListChangedFlag(true);
         }
      }
      
      public final function get defaultItem() : String
      {
         return _defaultItem;
      }
      
      public final function set defaultItem(param1:String) : void
      {
         _defaultItem = param1;
      }
      
      public final function get autoResizeItem() : Boolean
      {
         return _autoResizeItem;
      }
      
      public final function set autoResizeItem(param1:Boolean) : void
      {
         if(_autoResizeItem != param1)
         {
            _autoResizeItem = param1;
            setBoundsChangedFlag();
            if(_virtual)
            {
               setVirtualListChangedFlag(true);
            }
         }
      }
      
      public final function get selectionMode() : int
      {
         return _selectionMode;
      }
      
      public final function set selectionMode(param1:int) : void
      {
         _selectionMode = param1;
      }
      
      public final function get selectionController() : Controller
      {
         return _selectionController;
      }
      
      public final function set selectionController(param1:Controller) : void
      {
         _selectionController = param1;
      }
      
      public function get itemPool() : GObjectPool
      {
         return _pool;
      }
      
      public function getFromPool(param1:String = null) : GObject
      {
         if(!param1)
         {
            param1 = _defaultItem;
         }
         var _loc2_:GObject = _pool.getObject(param1);
         if(_loc2_ != null)
         {
            _loc2_.visible = true;
         }
         return _loc2_;
      }
      
      public function returnToPool(param1:GObject) : void
      {
         _pool.returnObject(param1);
      }
      
      override public function addChildAt(param1:GObject, param2:int) : GObject
      {
         var _loc3_:* = null;
         super.addChildAt(param1,param2);
         if(param1 is GButton)
         {
            _loc3_ = GButton(param1);
            _loc3_.selected = false;
            _loc3_.changeStateOnClick = false;
            _loc3_.useHandCursor = false;
         }
         param1.addEventListener("clickGTouch",__clickItem);
         param1.addEventListener("rightClick",__rightClickItem);
         return param1;
      }
      
      public function addItem(param1:String = null) : GObject
      {
         if(!param1)
         {
            param1 = _defaultItem;
         }
         return addChild(UIPackage.createObjectFromURL(param1));
      }
      
      public function addItemFromPool(param1:String = null) : GObject
      {
         return addChild(getFromPool(param1));
      }
      
      override public function removeChildAt(param1:int, param2:Boolean = false) : GObject
      {
         var _loc3_:GObject = super.removeChildAt(param1,param2);
         _loc3_.removeEventListener("clickGTouch",__clickItem);
         _loc3_.removeEventListener("rightClick",__rightClickItem);
         return _loc3_;
      }
      
      public function removeChildToPoolAt(param1:int) : void
      {
         var _loc2_:GObject = super.removeChildAt(param1);
         returnToPool(_loc2_);
      }
      
      public function removeChildToPool(param1:GObject) : void
      {
         super.removeChild(param1);
         returnToPool(param1);
      }
      
      public function removeChildrenToPool(param1:int = 0, param2:int = -1) : void
      {
         var _loc3_:* = 0;
         if(param2 < 0 || param2 >= _children.length)
         {
            param2 = _children.length - 1;
         }
         _loc3_ = param1;
         while(_loc3_ <= param2)
         {
            removeChildToPoolAt(param1);
            _loc3_++;
         }
      }
      
      public function get selectedIndex() : int
      {
         var _loc4_:int = 0;
         var _loc2_:* = null;
         var _loc1_:int = 0;
         var _loc3_:* = null;
         if(_virtual)
         {
            _loc4_ = 0;
            while(_loc4_ < _realNumItems)
            {
               _loc2_ = _virtualItems[_loc4_];
               if(_loc2_.obj is GButton && GButton(_loc2_.obj).selected || _loc2_.obj == null && _loc2_.selected)
               {
                  if(_loop)
                  {
                     return _loc4_ % _numItems;
                  }
                  return _loc4_;
               }
               _loc4_++;
            }
         }
         else
         {
            _loc1_ = _children.length;
            _loc4_ = 0;
            while(_loc4_ < _loc1_)
            {
               _loc3_ = _children[_loc4_].asButton;
               if(_loc3_ != null && _loc3_.selected)
               {
                  return _loc4_;
               }
               _loc4_++;
            }
         }
         return -1;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(param1 >= 0 && param1 < this.numItems)
         {
            if(_selectionMode != 0)
            {
               clearSelection();
            }
            addSelection(param1);
         }
         else
         {
            clearSelection();
         }
      }
      
      public function getSelection() : Vector.<int>
      {
         var _loc5_:int = 0;
         var _loc3_:* = null;
         var _loc2_:int = 0;
         var _loc4_:* = null;
         var _loc1_:Vector.<int> = new Vector.<int>();
         if(_virtual)
         {
            _loc5_ = 0;
            for(; _loc5_ < _realNumItems; _loc5_++)
            {
               _loc3_ = _virtualItems[_loc5_];
               if(_loc3_.obj is GButton && GButton(_loc3_.obj).selected || _loc3_.obj == null && _loc3_.selected)
               {
                  if(_loop)
                  {
                     _loc5_ = _loc5_ % _numItems;
                     if(_loc1_.indexOf(_loc5_) == -1)
                     {
                     }
                     continue;
                  }
                  _loc1_.push(_loc5_);
                  continue;
               }
            }
         }
         else
         {
            _loc2_ = _children.length;
            _loc5_ = 0;
            while(_loc5_ < _loc2_)
            {
               _loc4_ = _children[_loc5_].asButton;
               if(_loc4_ != null && _loc4_.selected)
               {
                  _loc1_.push(_loc5_);
               }
               _loc5_++;
            }
         }
         return _loc1_;
      }
      
      public function addSelection(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:* = null;
         if(_selectionMode == 3)
         {
            return;
         }
         checkVirtualList();
         if(_selectionMode == 0)
         {
            clearSelection();
         }
         if(param2)
         {
            scrollToView(param1);
         }
         _lastSelectedIndex = param1;
         var _loc4_:GButton = null;
         if(_virtual)
         {
            _loc3_ = _virtualItems[param1];
            if(_loc3_.obj != null)
            {
               _loc4_ = _loc3_.obj.asButton;
            }
            _loc3_.selected = true;
         }
         else
         {
            _loc4_ = getChildAt(param1).asButton;
         }
         if(_loc4_ != null && !_loc4_.selected)
         {
            _loc4_.selected = true;
            updateSelectionController(param1);
         }
      }
      
      public function removeSelection(param1:int) : void
      {
         var _loc2_:* = null;
         if(_selectionMode == 3)
         {
            return;
         }
         var _loc3_:GButton = null;
         if(_virtual)
         {
            _loc2_ = _virtualItems[param1];
            if(_loc2_.obj != null)
            {
               _loc3_ = _loc2_.obj.asButton;
            }
            _loc2_.selected = false;
         }
         else
         {
            _loc3_ = getChildAt(param1).asButton;
         }
         if(_loc3_ != null)
         {
            _loc3_.selected = false;
         }
      }
      
      public function clearSelection() : void
      {
         var _loc4_:int = 0;
         var _loc2_:* = null;
         var _loc1_:int = 0;
         var _loc3_:* = null;
         if(_virtual)
         {
            _loc4_ = 0;
            while(_loc4_ < _realNumItems)
            {
               _loc2_ = _virtualItems[_loc4_];
               if(_loc2_.obj is GButton)
               {
                  GButton(_loc2_.obj).selected = false;
               }
               _loc2_.selected = false;
               _loc4_++;
            }
         }
         else
         {
            _loc1_ = _children.length;
            _loc4_ = 0;
            while(_loc4_ < _loc1_)
            {
               _loc3_ = _children[_loc4_].asButton;
               if(_loc3_ != null)
               {
                  _loc3_.selected = false;
               }
               _loc4_++;
            }
         }
      }
      
      private function clearSelectionExcept(param1:GObject) : void
      {
         var _loc5_:int = 0;
         var _loc3_:* = null;
         var _loc2_:int = 0;
         var _loc4_:* = null;
         if(_virtual)
         {
            _loc5_ = 0;
            while(_loc5_ < _realNumItems)
            {
               _loc3_ = _virtualItems[_loc5_];
               if(_loc3_.obj != param1)
               {
                  if(_loc3_.obj is GButton)
                  {
                     GButton(_loc3_.obj).selected = false;
                  }
                  _loc3_.selected = false;
               }
               _loc5_++;
            }
         }
         else
         {
            _loc2_ = _children.length;
            _loc5_ = 0;
            while(_loc5_ < _loc2_)
            {
               _loc4_ = _children[_loc5_].asButton;
               if(_loc4_ != null && _loc4_ != param1)
               {
                  _loc4_.selected = false;
               }
               _loc5_++;
            }
         }
      }
      
      public function selectAll() : void
      {
         var _loc5_:int = 0;
         var _loc3_:* = null;
         var _loc1_:int = 0;
         var _loc4_:* = null;
         checkVirtualList();
         var _loc2_:* = -1;
         if(_virtual)
         {
            _loc5_ = 0;
            while(_loc5_ < _realNumItems)
            {
               _loc3_ = _virtualItems[_loc5_];
               if(_loc3_.obj is GButton && !GButton(_loc3_.obj).selected)
               {
                  GButton(_loc3_.obj).selected = true;
                  _loc2_ = _loc5_;
               }
               _loc3_.selected = true;
               _loc5_++;
            }
         }
         else
         {
            _loc1_ = _children.length;
            _loc5_ = 0;
            while(_loc5_ < _loc1_)
            {
               _loc4_ = _children[_loc5_].asButton;
               if(_loc4_ != null && !_loc4_.selected)
               {
                  _loc4_.selected = true;
                  _loc2_ = _loc5_;
               }
               _loc5_++;
            }
         }
         if(_loc2_ != -1)
         {
            updateSelectionController(_loc2_);
         }
      }
      
      public function selectNone() : void
      {
         clearSelection();
      }
      
      public function selectReverse() : void
      {
         var _loc5_:int = 0;
         var _loc3_:* = null;
         var _loc1_:int = 0;
         var _loc4_:* = null;
         checkVirtualList();
         var _loc2_:* = -1;
         if(_virtual)
         {
            _loc5_ = 0;
            while(_loc5_ < _realNumItems)
            {
               _loc3_ = _virtualItems[_loc5_];
               if(_loc3_.obj is GButton)
               {
                  GButton(_loc3_.obj).selected = !GButton(_loc3_.obj).selected;
                  if(GButton(_loc3_.obj).selected)
                  {
                     _loc2_ = _loc5_;
                  }
               }
               _loc3_.selected = !_loc3_.selected;
               _loc5_++;
            }
         }
         else
         {
            _loc1_ = _children.length;
            _loc5_ = 0;
            while(_loc5_ < _loc1_)
            {
               _loc4_ = _children[_loc5_].asButton;
               if(_loc4_ != null)
               {
                  _loc4_.selected = !_loc4_.selected;
                  if(_loc4_.selected)
                  {
                     _loc2_ = _loc5_;
                  }
               }
               _loc5_++;
            }
         }
         if(_loc2_ != -1)
         {
            updateSelectionController(_loc2_);
         }
      }
      
      public function handleArrowKey(param1:int) : void
      {
         var _loc4_:* = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc5_:* = null;
         var _loc3_:int = 0;
         var _loc2_:int = this.selectedIndex;
         if(_loc2_ == -1)
         {
            return;
         }
         loop8:
         switch(int(param1) - 1)
         {
            case 0:
               if(_layout == 0 || _layout == 3)
               {
                  _loc2_--;
                  if(_loc2_ >= 0)
                  {
                     clearSelection();
                     addSelection(_loc2_,true);
                  }
               }
               else if(_layout == 2 || _layout == 4)
               {
                  _loc4_ = _children[_loc2_];
                  _loc6_ = 0;
                  _loc7_ = _loc2_ - 1;
                  while(_loc7_ >= 0)
                  {
                     _loc5_ = _children[_loc7_];
                     if(_loc5_.y != _loc4_.y)
                     {
                        _loc4_ = _loc5_;
                        break;
                     }
                     _loc6_++;
                     _loc7_--;
                  }
                  while(_loc7_ >= 0)
                  {
                     _loc5_ = _children[_loc7_];
                     if(_loc5_.y != _loc4_.y)
                     {
                        clearSelection();
                        addSelection(_loc7_ + _loc6_ + 1,true);
                        break;
                     }
                     _loc7_--;
                  }
               }
               break;
            default:
               if(_layout == 0 || _layout == 3)
               {
                  _loc2_--;
                  if(_loc2_ >= 0)
                  {
                     clearSelection();
                     addSelection(_loc2_,true);
                  }
               }
               else if(_layout == 2 || _layout == 4)
               {
                  _loc4_ = _children[_loc2_];
                  _loc6_ = 0;
                  _loc7_ = _loc2_ - 1;
                  while(_loc7_ >= 0)
                  {
                     _loc5_ = _children[_loc7_];
                     if(_loc5_.y != _loc4_.y)
                     {
                        _loc4_ = _loc5_;
                        break;
                     }
                     _loc6_++;
                     _loc7_--;
                  }
                  while(_loc7_ >= 0)
                  {
                     _loc5_ = _children[_loc7_];
                     if(_loc5_.y != _loc4_.y)
                     {
                        clearSelection();
                        addSelection(_loc7_ + _loc6_ + 1,true);
                        break;
                     }
                     _loc7_--;
                  }
               }
               break;
            case 2:
               if(_layout == 1 || _layout == 2 || _layout == 4)
               {
                  _loc2_++;
                  if(_loc2_ < _children.length)
                  {
                     clearSelection();
                     addSelection(_loc2_,true);
                  }
               }
               else if(_layout == 3)
               {
                  _loc4_ = _children[_loc2_];
                  _loc6_ = 0;
                  _loc3_ = _children.length;
                  _loc7_ = _loc2_ + 1;
                  while(_loc7_ < _loc3_)
                  {
                     _loc5_ = _children[_loc7_];
                     if(_loc5_.x != _loc4_.x)
                     {
                        _loc4_ = _loc5_;
                        break;
                     }
                     _loc6_++;
                     _loc7_++;
                  }
                  while(_loc7_ < _loc3_)
                  {
                     _loc5_ = _children[_loc7_];
                     if(_loc5_.x != _loc4_.x)
                     {
                        clearSelection();
                        addSelection(_loc7_ - _loc6_ - 1,true);
                        break;
                     }
                     _loc7_++;
                  }
               }
               break;
            default:
               if(_layout == 1 || _layout == 2 || _layout == 4)
               {
                  _loc2_++;
                  if(_loc2_ < _children.length)
                  {
                     clearSelection();
                     addSelection(_loc2_,true);
                  }
               }
               else if(_layout == 3)
               {
                  _loc4_ = _children[_loc2_];
                  _loc6_ = 0;
                  _loc3_ = _children.length;
                  _loc7_ = _loc2_ + 1;
                  while(_loc7_ < _loc3_)
                  {
                     _loc5_ = _children[_loc7_];
                     if(_loc5_.x != _loc4_.x)
                     {
                        _loc4_ = _loc5_;
                        break;
                     }
                     _loc6_++;
                     _loc7_++;
                  }
                  while(_loc7_ < _loc3_)
                  {
                     _loc5_ = _children[_loc7_];
                     if(_loc5_.x != _loc4_.x)
                     {
                        clearSelection();
                        addSelection(_loc7_ - _loc6_ - 1,true);
                        break;
                     }
                     _loc7_++;
                  }
               }
               break;
            case 4:
               if(_layout == 0 || _layout == 3)
               {
                  _loc2_++;
                  if(_loc2_ < _children.length)
                  {
                     clearSelection();
                     addSelection(_loc2_,true);
                  }
               }
               else if(_layout == 2 || _layout == 4)
               {
                  _loc4_ = _children[_loc2_];
                  _loc6_ = 0;
                  _loc3_ = _children.length;
                  _loc7_ = _loc2_ + 1;
                  while(_loc7_ < _loc3_)
                  {
                     _loc5_ = _children[_loc7_];
                     if(_loc5_.y != _loc4_.y)
                     {
                        _loc4_ = _loc5_;
                        break;
                     }
                     _loc6_++;
                     _loc7_++;
                  }
                  while(_loc7_ < _loc3_)
                  {
                     _loc5_ = _children[_loc7_];
                     if(_loc5_.y != _loc4_.y)
                     {
                        clearSelection();
                        addSelection(_loc7_ - _loc6_ - 1,true);
                        break;
                     }
                     _loc7_++;
                  }
               }
               break;
            default:
               if(_layout == 0 || _layout == 3)
               {
                  _loc2_++;
                  if(_loc2_ < _children.length)
                  {
                     clearSelection();
                     addSelection(_loc2_,true);
                  }
               }
               else if(_layout == 2 || _layout == 4)
               {
                  _loc4_ = _children[_loc2_];
                  _loc6_ = 0;
                  _loc3_ = _children.length;
                  _loc7_ = _loc2_ + 1;
                  while(_loc7_ < _loc3_)
                  {
                     _loc5_ = _children[_loc7_];
                     if(_loc5_.y != _loc4_.y)
                     {
                        _loc4_ = _loc5_;
                        break;
                     }
                     _loc6_++;
                     _loc7_++;
                  }
                  while(_loc7_ < _loc3_)
                  {
                     _loc5_ = _children[_loc7_];
                     if(_loc5_.y != _loc4_.y)
                     {
                        clearSelection();
                        addSelection(_loc7_ - _loc6_ - 1,true);
                        break;
                     }
                     _loc7_++;
                  }
               }
               break;
            case 6:
               if(_layout == 1 || _layout == 2 || _layout == 4)
               {
                  _loc2_--;
                  if(_loc2_ >= 0)
                  {
                     clearSelection();
                     addSelection(_loc2_,true);
                  }
                  break;
               }
               if(_layout == 3)
               {
                  _loc4_ = _children[_loc2_];
                  _loc6_ = 0;
                  _loc7_ = _loc2_ - 1;
                  while(_loc7_ >= 0)
                  {
                     _loc5_ = _children[_loc7_];
                     if(_loc5_.x != _loc4_.x)
                     {
                        _loc4_ = _loc5_;
                        break;
                     }
                     _loc6_++;
                     _loc7_--;
                  }
                  while(true)
                  {
                     if(_loc7_ >= 0)
                     {
                        _loc5_ = _children[_loc7_];
                        if(_loc5_.x != _loc4_.x)
                        {
                           clearSelection();
                           addSelection(_loc7_ + _loc6_ + 1,true);
                           break loop8;
                        }
                        _loc7_--;
                        continue;
                     }
                     break loop8;
                  }
                  break;
               }
               break;
         }
      }
      
      public function getItemNear(param1:Number, param2:Number) : GObject
      {
         var _loc5_:* = null;
         ensureBoundsCorrect();
         var _loc3_:Array = root.nativeStage.getObjectsUnderPoint(new Point(param1,param2));
         if(!_loc3_ || _loc3_.length == 0)
         {
            return null;
         }
         var _loc7_:int = 0;
         var _loc6_:* = _loc3_;
         for each(var _loc4_ in _loc3_)
         {
            while(_loc4_ != null && !(_loc4_ is Stage))
            {
               if(_loc4_ is UIDisplayObject)
               {
                  _loc5_ = UIDisplayObject(_loc4_).owner;
                  while(_loc5_ != null && _loc5_.parent != this)
                  {
                     _loc5_ = _loc5_.parent;
                  }
                  if(_loc5_ != null)
                  {
                     return _loc5_;
                  }
               }
               _loc4_ = _loc4_.parent;
            }
         }
         return null;
      }
      
      private function __clickItem(param1:GTouchEvent) : void
      {
         if(this._scrollPane != null && this._scrollPane.isDragged)
         {
            return;
         }
         var _loc3_:GObject = GObject(param1.currentTarget);
         setSelectionOnEvent(_loc3_);
         if(scrollPane != null && scrollItemToViewOnClick)
         {
            scrollPane.scrollToView(_loc3_,true);
         }
         var _loc2_:ItemEvent = new ItemEvent("itemClick",_loc3_);
         _loc2_.stageX = param1.stageX;
         _loc2_.stageY = param1.stageY;
         _loc2_.clickCount = param1.clickCount;
         this.dispatchEvent(_loc2_);
      }
      
      private function __rightClickItem(param1:MouseEvent) : void
      {
         var _loc3_:GObject = GObject(param1.currentTarget);
         if(_loc3_ is GButton && !GButton(_loc3_).selected)
         {
            setSelectionOnEvent(_loc3_);
         }
         if(scrollPane != null && scrollItemToViewOnClick)
         {
            scrollPane.scrollToView(_loc3_,true);
         }
         var _loc2_:ItemEvent = new ItemEvent("itemClick",_loc3_);
         _loc2_.stageX = param1.stageX;
         _loc2_.stageY = param1.stageY;
         _loc2_.rightButton = true;
         this.dispatchEvent(_loc2_);
      }
      
      private function setSelectionOnEvent(param1:GObject) : void
      {
         var _loc6_:* = null;
         var _loc2_:int = 0;
         var _loc5_:int = 0;
         var _loc10_:* = 0;
         var _loc8_:* = null;
         var _loc9_:* = null;
         if(!(param1 is GButton) || _selectionMode == 3)
         {
            return;
         }
         var _loc4_:Boolean = false;
         var _loc7_:GButton = GButton(param1);
         var _loc3_:int = childIndexToItemIndex(getChildIndex(param1));
         if(_selectionMode == 0)
         {
            if(!_loc7_.selected)
            {
               clearSelectionExcept(_loc7_);
               _loc7_.selected = true;
            }
         }
         else
         {
            _loc6_ = this.root;
            if(_loc6_.shiftKeyDown)
            {
               if(!_loc7_.selected)
               {
                  if(_lastSelectedIndex != -1)
                  {
                     _loc2_ = Math.min(_lastSelectedIndex,_loc3_);
                     _loc5_ = Math.max(_lastSelectedIndex,_loc3_);
                     _loc5_ = Math.min(_loc5_,this.numItems - 1);
                     if(_virtual)
                     {
                        _loc10_ = _loc2_;
                        while(_loc10_ <= _loc5_)
                        {
                           _loc8_ = _virtualItems[_loc10_];
                           if(_loc8_.obj is GButton)
                           {
                              GButton(_loc8_.obj).selected = true;
                           }
                           _loc8_.selected = true;
                           _loc10_++;
                        }
                     }
                     else
                     {
                        _loc10_ = _loc2_;
                        while(_loc10_ <= _loc5_)
                        {
                           _loc9_ = getChildAt(_loc10_).asButton;
                           if(_loc9_ != null)
                           {
                              _loc9_.selected = true;
                           }
                           _loc10_++;
                        }
                     }
                     _loc4_ = true;
                  }
                  else
                  {
                     _loc7_.selected = true;
                  }
               }
            }
            else if(_loc6_.ctrlKeyDown || _selectionMode == 2)
            {
               _loc7_.selected = !_loc7_.selected;
            }
            else if(!_loc7_.selected)
            {
               clearSelectionExcept(_loc7_);
               _loc7_.selected = true;
            }
            else
            {
               clearSelectionExcept(_loc7_);
            }
         }
         if(!_loc4_)
         {
            _lastSelectedIndex = _loc3_;
         }
         if(_loc7_.selected)
         {
            updateSelectionController(_loc3_);
         }
      }
      
      public function resizeToFit(param1:int = 2147483647, param2:int = 0) : void
      {
         var _loc4_:int = 0;
         var _loc7_:int = 0;
         var _loc5_:* = null;
         var _loc6_:* = 0;
         ensureBoundsCorrect();
         var _loc3_:int = this.numItems;
         if(param1 > _loc3_)
         {
            param1 = _loc3_;
         }
         if(_virtual)
         {
            _loc4_ = Math.ceil(param1 / _curLineItemCount);
            if(_layout == 0 || _layout == 2)
            {
               this.viewHeight = _loc4_ * _itemSize.y + Math.max(0,_loc4_ - 1) * _lineGap;
            }
            else
            {
               this.viewWidth = _loc4_ * _itemSize.x + Math.max(0,_loc4_ - 1) * _columnGap;
            }
         }
         else if(param1 == 0)
         {
            if(_layout == 0 || _layout == 2)
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
            _loc7_ = param1 - 1;
            _loc5_ = null;
            while(_loc7_ >= 0)
            {
               _loc5_ = this.getChildAt(_loc7_);
               if(!(!foldInvisibleItems || _loc5_.visible))
               {
                  _loc7_--;
                  continue;
               }
               break;
            }
            if(_loc7_ < 0)
            {
               if(_layout == 0 || _layout == 2)
               {
                  this.viewHeight = param2;
               }
               else
               {
                  this.viewWidth = param2;
               }
            }
            else if(_layout == 0 || _layout == 2)
            {
               _loc6_ = int(_loc5_.y + _loc5_.height);
               if(_loc6_ < param2)
               {
                  _loc6_ = param2;
               }
               this.viewHeight = _loc6_;
            }
            else
            {
               _loc6_ = int(_loc5_.x + _loc5_.width);
               if(_loc6_ < param2)
               {
                  _loc6_ = param2;
               }
               this.viewWidth = _loc6_;
            }
         }
      }
      
      public function getMaxItemWidth() : int
      {
         var _loc4_:int = 0;
         var _loc1_:* = null;
         var _loc3_:int = _children.length;
         var _loc2_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc1_ = getChildAt(_loc4_);
            if(_loc1_.width > _loc2_)
            {
               _loc2_ = _loc1_.width;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      override protected function handleSizeChanged() : void
      {
         super.handleSizeChanged();
         setBoundsChangedFlag();
         if(_virtual)
         {
            setVirtualListChangedFlag(true);
         }
      }
      
      override public function handleControllerChanged(param1:Controller) : void
      {
         super.handleControllerChanged(param1);
         if(_selectionController == param1)
         {
            this.selectedIndex = param1.selectedIndex;
         }
      }
      
      private function updateSelectionController(param1:int) : void
      {
         var _loc2_:* = null;
         if(_selectionController != null && !_selectionController.changing && param1 < _selectionController.pageCount)
         {
            _loc2_ = _selectionController;
            _selectionController = null;
            _loc2_.selectedIndex = param1;
            _selectionController = _loc2_;
         }
      }
      
      override public function getSnappingPosition(param1:Number, param2:Number, param3:Point = null) : Point
      {
         var _loc5_:* = NaN;
         var _loc4_:int = 0;
         if(_virtual)
         {
            if(!param3)
            {
               param3 = new Point();
            }
            if(_layout == 0 || _layout == 2)
            {
               _loc5_ = param2;
               GList.pos_param = param2;
               _loc4_ = getIndexOnPos1(false);
               param2 = GList.pos_param;
               if(_loc4_ < _virtualItems.length && _loc5_ - param2 > _virtualItems[_loc4_].height / 2 && _loc4_ < _realNumItems)
               {
                  param2 = param2 + (_virtualItems[_loc4_].height + _lineGap);
               }
            }
            else if(_layout == 1 || _layout == 3)
            {
               _loc5_ = param1;
               GList.pos_param = param1;
               _loc4_ = getIndexOnPos2(false);
               param1 = GList.pos_param;
               if(_loc4_ < _virtualItems.length && _loc5_ - param1 > _virtualItems[_loc4_].width / 2 && _loc4_ < _realNumItems)
               {
                  param1 = param1 + (_virtualItems[_loc4_].width + _columnGap);
               }
            }
            else
            {
               _loc5_ = param1;
               GList.pos_param = param1;
               _loc4_ = getIndexOnPos3(false);
               param1 = GList.pos_param;
               if(_loc4_ < _virtualItems.length && _loc5_ - param1 > _virtualItems[_loc4_].width / 2 && _loc4_ < _realNumItems)
               {
                  param1 = param1 + (_virtualItems[_loc4_].width + _columnGap);
               }
            }
            param3.x = param1;
            param3.y = param2;
            return param3;
         }
         return super.getSnappingPosition(param1,param2,param3);
      }
      
      public function scrollToView(param1:int, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc7_:* = null;
         var _loc5_:* = null;
         var _loc9_:* = NaN;
         var _loc8_:int = 0;
         var _loc4_:int = 0;
         var _loc6_:* = null;
         if(_virtual)
         {
            if(_numItems == 0)
            {
               return;
            }
            checkVirtualList();
            if(param1 >= _virtualItems.length)
            {
               throw new Error("Invalid child index: " + param1 + ">" + _virtualItems.length);
            }
            if(_loop)
            {
               param1 = Math.floor(_firstIndex / _numItems) * _numItems + param1;
            }
            _loc5_ = _virtualItems[param1];
            _loc9_ = 0;
            if(_layout == 0 || _layout == 2)
            {
               _loc8_ = 0;
               while(_loc8_ < param1)
               {
                  _loc9_ = Number(_loc9_ + (_virtualItems[_loc8_].height + _lineGap));
                  _loc8_ = _loc8_ + _curLineItemCount;
               }
               _loc7_ = new Rectangle(0,_loc9_,_itemSize.x,_loc5_.height);
            }
            else if(_layout == 1 || _layout == 3)
            {
               _loc8_ = 0;
               while(_loc8_ < param1)
               {
                  _loc9_ = Number(_loc9_ + (_virtualItems[_loc8_].width + _columnGap));
                  _loc8_ = _loc8_ + _curLineItemCount;
               }
               _loc7_ = new Rectangle(_loc9_,0,_loc5_.width,_itemSize.y);
            }
            else
            {
               _loc4_ = param1 / (_curLineItemCount * _curLineItemCount2);
               _loc7_ = new Rectangle(_loc4_ * viewWidth + param1 % _curLineItemCount * (_loc5_.width + _columnGap),param1 / _curLineItemCount % _curLineItemCount2 * (_loc5_.height + _lineGap),_loc5_.width,_loc5_.height);
            }
            param3 = true;
            if(_scrollPane != null)
            {
               scrollPane.scrollToView(_loc7_,param2,param3);
            }
         }
         else
         {
            _loc6_ = getChildAt(param1);
            if(_scrollPane != null)
            {
               scrollPane.scrollToView(_loc6_,param2,param3);
            }
            else if(parent != null && parent.scrollPane != null)
            {
               parent.scrollPane.scrollToView(_loc6_,param2,param3);
            }
         }
      }
      
      override public function getFirstChildInView() : int
      {
         return childIndexToItemIndex(super.getFirstChildInView());
      }
      
      public function childIndexToItemIndex(param1:int) : int
      {
         var _loc2_:int = 0;
         if(!_virtual)
         {
            return param1;
         }
         if(_layout == 4)
         {
            _loc2_ = _firstIndex;
            while(_loc2_ < _realNumItems)
            {
               if(_virtualItems[_loc2_].obj != null)
               {
                  param1--;
                  if(param1 < 0)
                  {
                     return _loc2_;
                  }
               }
               _loc2_++;
            }
            return param1;
         }
         param1 = param1 + _firstIndex;
         if(_loop && _numItems > 0)
         {
            param1 = param1 % _numItems;
         }
         return param1;
      }
      
      public function itemIndexToChildIndex(param1:int) : int
      {
         var _loc2_:int = 0;
         if(!_virtual)
         {
            return param1;
         }
         if(_layout == 4)
         {
            return getChildIndex(_virtualItems[param1].obj);
         }
         if(_loop && _numItems > 0)
         {
            _loc2_ = _firstIndex % _numItems;
            if(param1 >= _loc2_)
            {
               param1 = _firstIndex + (param1 - _loc2_);
            }
            else
            {
               param1 = _firstIndex + _numItems + (_loc2_ - param1);
            }
         }
         else
         {
            param1 = param1 - _firstIndex;
         }
         return param1;
      }
      
      public function setVirtual() : void
      {
         _setVirtual(false);
      }
      
      public function setVirtualAndLoop() : void
      {
         _setVirtual(true);
      }
      
      private function _setVirtual(param1:Boolean) : void
      {
         var _loc2_:* = null;
         if(!_virtual)
         {
            if(_scrollPane == null)
            {
               throw new Error("FairyGUI: Virtual list must be scrollable!");
            }
            if(param1)
            {
               if(_layout == 2 || _layout == 3)
               {
                  throw new Error("FairyGUI: Loop list is not supported for FlowHorizontal or FlowVertical layout!");
               }
               _scrollPane.bouncebackEffect = false;
            }
            _virtual = true;
            _loop = param1;
            _virtualItems = new Vector.<ItemInfo>();
            removeChildrenToPool();
            if(_itemSize == null)
            {
               _itemSize = new Point();
               _loc2_ = getFromPool(null);
               if(_loc2_ == null)
               {
                  throw new Error("FairyGUI: Virtual List must have a default list item resource.");
               }
               _itemSize.x = _loc2_.width;
               _itemSize.y = _loc2_.height;
               returnToPool(_loc2_);
            }
            if(_layout == 0 || _layout == 2)
            {
               _scrollPane.scrollSpeed = _itemSize.y;
            }
            else
            {
               _scrollPane.scrollSpeed = _itemSize.x;
            }
            _scrollPane.addEventListener("scroll",__scrolled);
            setVirtualListChangedFlag(true);
         }
      }
      
      public function get numItems() : int
      {
         if(_virtual)
         {
            return _numItems;
         }
         return _children.length;
      }
      
      public function set numItems(param1:int) : void
      {
         var _loc5_:* = 0;
         var _loc2_:int = 0;
         var _loc4_:* = null;
         var _loc3_:int = 0;
         if(_virtual)
         {
            if(itemRenderer == null)
            {
               throw new Error("FairyGUI: Set itemRenderer first!");
            }
            _numItems = param1;
            if(_loop)
            {
               _realNumItems = _numItems * 5;
            }
            else
            {
               _realNumItems = _numItems;
            }
            _loc2_ = _virtualItems.length;
            if(_realNumItems > _loc2_)
            {
               _loc5_ = _loc2_;
               while(_loc5_ < _realNumItems)
               {
                  _loc4_ = new ItemInfo();
                  _loc4_.width = _itemSize.x;
                  _loc4_.height = _itemSize.y;
                  _virtualItems.push(_loc4_);
                  _loc5_++;
               }
            }
            else
            {
               _loc5_ = int(_realNumItems);
               while(_loc5_ < _loc2_)
               {
                  _virtualItems[_loc5_].selected = false;
                  _loc5_++;
               }
            }
            if(this._virtualListChanged != 0)
            {
               GTimers.inst.remove(_refreshVirtualList);
            }
            _refreshVirtualList();
         }
         else
         {
            _loc3_ = _children.length;
            if(param1 > _loc3_)
            {
               _loc5_ = _loc3_;
               while(_loc5_ < param1)
               {
                  if(itemProvider == null)
                  {
                     addItemFromPool();
                  }
                  else
                  {
                     addItemFromPool(itemProvider(_loc5_));
                  }
                  _loc5_++;
               }
            }
            else
            {
               removeChildrenToPool(param1,_loc3_);
            }
            if(itemRenderer != null)
            {
               _loc5_ = 0;
               while(_loc5_ < param1)
               {
                  itemRenderer(_loc5_,getChildAt(_loc5_));
                  _loc5_++;
               }
            }
         }
      }
      
      public function refreshVirtualList() : void
      {
         setVirtualListChangedFlag(false);
      }
      
      private function checkVirtualList() : void
      {
         if(this._virtualListChanged != 0)
         {
            this._refreshVirtualList();
            GTimers.inst.remove(_refreshVirtualList);
         }
      }
      
      private function setVirtualListChangedFlag(param1:Boolean = false) : void
      {
         if(param1)
         {
            _virtualListChanged = 2;
         }
         else if(_virtualListChanged == 0)
         {
            _virtualListChanged = 1;
         }
         GTimers.inst.callLater(_refreshVirtualList);
      }
      
      private function _refreshVirtualList() : void
      {
         var _loc7_:int = 0;
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:* = _virtualListChanged == 2;
         _virtualListChanged = 0;
         _eventLocked = true;
         if(_loc2_)
         {
            if(_layout == 0 || _layout == 1)
            {
               _curLineItemCount = 1;
            }
            else if(_layout == 2)
            {
               if(_columnCount > 0)
               {
                  _curLineItemCount = _columnCount;
               }
               else
               {
                  _curLineItemCount = Math.floor((_scrollPane.viewWidth + _columnGap) / (_itemSize.x + _columnGap));
                  if(_curLineItemCount <= 0)
                  {
                     _curLineItemCount = 1;
                  }
               }
            }
            else if(_layout == 3)
            {
               if(_lineCount > 0)
               {
                  _curLineItemCount = _lineCount;
               }
               else
               {
                  _curLineItemCount = Math.floor((_scrollPane.viewHeight + _lineGap) / (_itemSize.y + _lineGap));
                  if(_curLineItemCount <= 0)
                  {
                     _curLineItemCount = 1;
                  }
               }
            }
            else
            {
               if(_columnCount > 0)
               {
                  _curLineItemCount = _columnCount;
               }
               else
               {
                  _curLineItemCount = Math.floor((_scrollPane.viewWidth + _columnGap) / (_itemSize.x + _columnGap));
                  if(_curLineItemCount <= 0)
                  {
                     _curLineItemCount = 1;
                  }
               }
               if(_lineCount > 0)
               {
                  _curLineItemCount2 = _lineCount;
               }
               else
               {
                  _curLineItemCount2 = Math.floor((_scrollPane.viewHeight + _lineGap) / (_itemSize.y + _lineGap));
                  if(_curLineItemCount2 <= 0)
                  {
                     _curLineItemCount2 = 1;
                  }
               }
            }
         }
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         if(_realNumItems > 0)
         {
            _loc4_ = Math.ceil(_realNumItems / _curLineItemCount) * _curLineItemCount;
            _loc3_ = Math.min(_curLineItemCount,_realNumItems);
            if(_layout == 0 || _layout == 2)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc4_)
               {
                  _loc5_ = Number(_loc5_ + (_virtualItems[_loc7_].height + _lineGap));
                  _loc7_ = _loc7_ + _curLineItemCount;
               }
               if(_loc5_ > 0)
               {
                  _loc5_ = Number(_loc5_ - _lineGap);
               }
               if(_autoResizeItem)
               {
                  _loc6_ = Number(scrollPane.viewWidth);
               }
               else
               {
                  _loc7_ = 0;
                  while(_loc7_ < _loc3_)
                  {
                     _loc6_ = Number(_loc6_ + (_virtualItems[_loc7_].width + _columnGap));
                     _loc7_++;
                  }
                  if(_loc6_ > 0)
                  {
                     _loc6_ = Number(_loc6_ - _columnGap);
                  }
               }
            }
            else if(_layout == 1 || _layout == 3)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc4_)
               {
                  _loc6_ = Number(_loc6_ + (_virtualItems[_loc7_].width + _columnGap));
                  _loc7_ = _loc7_ + _curLineItemCount;
               }
               if(_loc6_ > 0)
               {
                  _loc6_ = Number(_loc6_ - _columnGap);
               }
               if(_autoResizeItem)
               {
                  _loc5_ = Number(this.scrollPane.viewHeight);
               }
               else
               {
                  _loc7_ = 0;
                  while(_loc7_ < _loc3_)
                  {
                     _loc5_ = Number(_loc5_ + (_virtualItems[_loc7_].height + _lineGap));
                     _loc7_++;
                  }
                  if(_loc5_ > 0)
                  {
                     _loc5_ = Number(_loc5_ - _lineGap);
                  }
               }
            }
            else
            {
               _loc1_ = Math.ceil(_loc4_ / (_curLineItemCount * _curLineItemCount2));
               _loc6_ = Number(_loc1_ * viewWidth);
               _loc5_ = Number(viewHeight);
            }
         }
         handleAlign(_loc6_,_loc5_);
         _scrollPane.setContentSize(_loc6_,_loc5_);
         _eventLocked = false;
         handleScroll(true);
      }
      
      private function __scrolled(param1:Event) : void
      {
         handleScroll(false);
      }
      
      private function getIndexOnPos1(param1:Boolean) : int
      {
         var _loc4_:int = 0;
         var _loc3_:* = NaN;
         var _loc2_:Number = NaN;
         if(_realNumItems < _curLineItemCount)
         {
            pos_param = 0;
            return 0;
         }
         if(numChildren > 0 && !param1)
         {
            _loc3_ = Number(this.getChildAt(0).y);
            if(_loc3_ > pos_param)
            {
               _loc4_ = _firstIndex - _curLineItemCount;
               while(_loc4_ >= 0)
               {
                  _loc3_ = Number(_loc3_ - (_virtualItems[_loc4_].height + _lineGap));
                  if(_loc3_ <= pos_param)
                  {
                     pos_param = _loc3_;
                     return _loc4_;
                  }
                  _loc4_ = _loc4_ - _curLineItemCount;
               }
               pos_param = 0;
               return 0;
            }
            _loc4_ = _firstIndex;
            while(_loc4_ < _realNumItems)
            {
               _loc2_ = _loc3_ + _virtualItems[_loc4_].height + _lineGap;
               if(_loc2_ > pos_param)
               {
                  pos_param = _loc3_;
                  return _loc4_;
               }
               _loc3_ = _loc2_;
               _loc4_ = _loc4_ + _curLineItemCount;
            }
            pos_param = _loc3_;
            return _realNumItems - _curLineItemCount;
         }
         _loc3_ = 0;
         _loc4_ = 0;
         while(_loc4_ < _realNumItems)
         {
            _loc2_ = _loc3_ + _virtualItems[_loc4_].height + _lineGap;
            if(_loc2_ > pos_param)
            {
               pos_param = _loc3_;
               return _loc4_;
            }
            _loc3_ = _loc2_;
            _loc4_ = _loc4_ + _curLineItemCount;
         }
         pos_param = _loc3_;
         return _realNumItems - _curLineItemCount;
      }
      
      private function getIndexOnPos2(param1:Boolean) : int
      {
         var _loc4_:int = 0;
         var _loc3_:* = NaN;
         var _loc2_:Number = NaN;
         if(_realNumItems < _curLineItemCount)
         {
            pos_param = 0;
            return 0;
         }
         if(numChildren > 0 && !param1)
         {
            _loc3_ = Number(this.getChildAt(0).x);
            if(_loc3_ > pos_param)
            {
               _loc4_ = _firstIndex - _curLineItemCount;
               while(_loc4_ >= 0)
               {
                  _loc3_ = Number(_loc3_ - (_virtualItems[_loc4_].width + _columnGap));
                  if(_loc3_ <= pos_param)
                  {
                     pos_param = _loc3_;
                     return _loc4_;
                  }
                  _loc4_ = _loc4_ - _curLineItemCount;
               }
               pos_param = 0;
               return 0;
            }
            _loc4_ = _firstIndex;
            while(_loc4_ < _realNumItems)
            {
               _loc2_ = _loc3_ + _virtualItems[_loc4_].width + _columnGap;
               if(_loc2_ > pos_param)
               {
                  pos_param = _loc3_;
                  return _loc4_;
               }
               _loc3_ = _loc2_;
               _loc4_ = _loc4_ + _curLineItemCount;
            }
            pos_param = _loc3_;
            return _realNumItems - _curLineItemCount;
         }
         _loc3_ = 0;
         _loc4_ = 0;
         while(_loc4_ < _realNumItems)
         {
            _loc2_ = _loc3_ + _virtualItems[_loc4_].width + _columnGap;
            if(_loc2_ > pos_param)
            {
               pos_param = _loc3_;
               return _loc4_;
            }
            _loc3_ = _loc2_;
            _loc4_ = _loc4_ + _curLineItemCount;
         }
         pos_param = _loc3_;
         return _realNumItems - _curLineItemCount;
      }
      
      private function getIndexOnPos3(param1:Boolean) : int
      {
         var _loc6_:int = 0;
         var _loc2_:Number = NaN;
         if(_realNumItems < _curLineItemCount)
         {
            pos_param = 0;
            return 0;
         }
         var _loc7_:Number = this.viewWidth;
         var _loc5_:int = Math.floor(pos_param / _loc7_);
         var _loc4_:int = _loc5_ * (_curLineItemCount * _curLineItemCount2);
         var _loc3_:* = Number(_loc5_ * _loc7_);
         _loc6_ = 0;
         while(_loc6_ < _curLineItemCount)
         {
            _loc2_ = _loc3_ + _virtualItems[_loc4_ + _loc6_].width + _columnGap;
            if(_loc2_ > pos_param)
            {
               pos_param = _loc3_;
               return _loc4_ + _loc6_;
            }
            _loc3_ = _loc2_;
            _loc6_++;
         }
         pos_param = _loc3_;
         return _loc4_ + _curLineItemCount - 1;
      }
      
      private function handleScroll(param1:Boolean) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:int = 0;
         if(_eventLocked)
         {
            return;
         }
         if(_layout == 0 || _layout == 2)
         {
            if(_loop)
            {
               _loc3_ = scrollPane.scrollingPosY;
               _loc2_ = _numItems * (_itemSize.y + _lineGap);
               if(_loc3_ == 0)
               {
                  scrollPane.posY = _loc2_;
               }
               else if(_loc3_ == scrollPane.contentHeight - scrollPane.viewHeight)
               {
                  scrollPane.posY = scrollPane.contentHeight - _loc2_ - this.viewHeight;
               }
            }
            handleScroll1(param1);
            handleArchOrder1();
         }
         else if(_layout == 1 || _layout == 3)
         {
            if(_loop)
            {
               _loc3_ = scrollPane.scrollingPosX;
               _loc2_ = _numItems * (_itemSize.x + _columnGap);
               if(_loc3_ == 0)
               {
                  scrollPane.posX = _loc2_;
               }
               else if(_loc3_ == scrollPane.contentWidth - scrollPane.viewWidth)
               {
                  scrollPane.posX = scrollPane.contentWidth - _loc2_ - this.viewWidth;
               }
            }
            handleScroll2(param1);
            handleArchOrder2();
         }
         else
         {
            if(_loop)
            {
               _loc3_ = scrollPane.scrollingPosX;
               _loc2_ = int(_numItems / (_curLineItemCount * _curLineItemCount2)) * viewWidth;
               if(_loc3_ == 0)
               {
                  scrollPane.posX = _loc2_;
               }
               else if(_loc3_ == scrollPane.contentWidth - scrollPane.viewWidth)
               {
                  scrollPane.posX = scrollPane.contentWidth - _loc2_ - this.viewWidth;
               }
            }
            handleScroll3(param1);
         }
         _boundsChanged = false;
      }
      
      private function handleScroll1(param1:Boolean) : void
      {
         var _loc15_:* = false;
         var _loc17_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = 0;
         var _loc9_:int = 0;
         enterCounter = Number(enterCounter) + 1;
         if(enterCounter > 3)
         {
            return;
         }
         var _loc10_:Number = scrollPane.scrollingPosY;
         var _loc3_:Number = _loc10_ + scrollPane.viewHeight;
         var _loc20_:* = _loc3_ == scrollPane.contentHeight;
         GList.pos_param = _loc10_;
         var _loc21_:int = getIndexOnPos1(param1);
         _loc10_ = GList.pos_param;
         if(_loc21_ == _firstIndex && !param1)
         {
            enterCounter = Number(enterCounter) - 1;
            return;
         }
         var _loc22_:int = _firstIndex;
         _firstIndex = _loc21_;
         var _loc4_:* = _loc21_;
         var _loc18_:* = _loc22_ > _loc21_;
         var _loc13_:int = this.numChildren;
         var _loc11_:int = _loc22_ + _loc13_ - 1;
         var _loc19_:* = !!_loc18_?_loc11_:_loc22_;
         var _loc12_:* = 0;
         var _loc14_:* = _loc10_;
         var _loc2_:* = 0;
         var _loc5_:* = 0;
         var _loc8_:String = defaultItem;
         var _loc16_:int = (scrollPane.viewWidth - _columnGap * (_curLineItemCount - 1)) / _curLineItemCount;
         itemInfoVer = Number(itemInfoVer) + 1;
         while(_loc4_ < _realNumItems && (_loc20_ || _loc14_ < _loc3_))
         {
            _loc6_ = _virtualItems[_loc4_];
            if(_loc6_.obj == null || param1)
            {
               if(itemProvider != null)
               {
                  _loc8_ = itemProvider(_loc4_ % _numItems);
                  if(_loc8_ == null)
                  {
                     _loc8_ = _defaultItem;
                  }
                  _loc8_ = UIPackage.normalizeURL(_loc8_);
               }
               if(_loc6_.obj != null && _loc6_.obj.resourceURL != _loc8_)
               {
                  if(_loc6_.obj is GButton)
                  {
                     _loc6_.selected = GButton(_loc6_.obj).selected;
                  }
                  removeChildToPool(_loc6_.obj);
                  _loc6_.obj = null;
               }
            }
            if(_loc6_.obj == null)
            {
               if(_loc18_)
               {
                  _loc7_ = _loc19_;
                  while(_loc7_ >= _loc22_)
                  {
                     _loc17_ = _virtualItems[_loc7_];
                     if(_loc17_.obj != null && _loc17_.updateFlag != itemInfoVer && _loc17_.obj.resourceURL == _loc8_)
                     {
                        if(_loc17_.obj is GButton)
                        {
                           _loc17_.selected = GButton(_loc17_.obj).selected;
                        }
                        _loc6_.obj = _loc17_.obj;
                        _loc17_.obj = null;
                        if(_loc7_ == _loc19_)
                        {
                           _loc19_--;
                        }
                        break;
                     }
                     _loc7_--;
                  }
               }
               else
               {
                  _loc7_ = _loc19_;
                  while(_loc7_ <= _loc11_)
                  {
                     _loc17_ = _virtualItems[_loc7_];
                     if(_loc17_.obj != null && _loc17_.updateFlag != itemInfoVer && _loc17_.obj.resourceURL == _loc8_)
                     {
                        if(_loc17_.obj is GButton)
                        {
                           _loc17_.selected = GButton(_loc17_.obj).selected;
                        }
                        _loc6_.obj = _loc17_.obj;
                        _loc17_.obj = null;
                        if(_loc7_ == _loc19_)
                        {
                           _loc19_++;
                        }
                        break;
                     }
                     _loc7_++;
                  }
               }
               if(_loc6_.obj != null)
               {
                  setChildIndex(_loc6_.obj,!!_loc18_?_loc4_ - _loc21_:numChildren);
               }
               else
               {
                  _loc6_.obj = _pool.getObject(_loc8_);
                  if(_loc18_)
                  {
                     this.addChildAt(_loc6_.obj,_loc4_ - _loc21_);
                  }
                  else
                  {
                     this.addChild(_loc6_.obj);
                  }
               }
               if(_loc6_.obj is GButton)
               {
                  GButton(_loc6_.obj).selected = _loc6_.selected;
               }
               _loc15_ = true;
            }
            else
            {
               _loc15_ = param1;
            }
            if(_loc15_)
            {
               if(_autoResizeItem && (_layout == 0 || _columnCount > 0))
               {
                  _loc6_.obj.setSize(_loc16_,_loc6_.obj.height,true);
               }
               itemRenderer(_loc4_ % _numItems,_loc6_.obj);
               if(_loc4_ % _curLineItemCount == 0)
               {
                  _loc2_ = Number(_loc2_ + (Math.ceil(_loc6_.obj.height) - _loc6_.height));
                  if(_loc4_ == _loc21_ && _loc22_ > _loc21_)
                  {
                     _loc5_ = Number(Math.ceil(_loc6_.obj.height) - _loc6_.height);
                  }
               }
               _loc6_.width = Math.ceil(_loc6_.obj.width);
               _loc6_.height = Math.ceil(_loc6_.obj.height);
            }
            _loc6_.updateFlag = itemInfoVer;
            _loc6_.obj.setXY(_loc12_,_loc14_);
            if(_loc4_ == _loc21_)
            {
               _loc3_ = _loc3_ + _loc6_.height;
            }
            _loc12_ = Number(_loc12_ + (_loc6_.width + _columnGap));
            if(_loc4_ % _curLineItemCount == _curLineItemCount - 1)
            {
               _loc12_ = 0;
               _loc14_ = Number(_loc14_ + (_loc6_.height + _lineGap));
            }
            _loc4_++;
         }
         _loc9_ = 0;
         while(_loc9_ < _loc13_)
         {
            _loc6_ = _virtualItems[_loc22_ + _loc9_];
            if(_loc6_.updateFlag != itemInfoVer && _loc6_.obj != null)
            {
               if(_loc6_.obj is GButton)
               {
                  _loc6_.selected = GButton(_loc6_.obj).selected;
               }
               removeChildToPool(_loc6_.obj);
               _loc6_.obj = null;
            }
            _loc9_++;
         }
         if(_loc2_ != 0 || _loc5_ != 0)
         {
            _scrollPane.changeContentSizeOnScrolling(0,_loc2_,0,_loc5_);
         }
         if(_loc4_ > 0 && this.numChildren > 0 && _container.y < 0 && getChildAt(0).y > -_container.y)
         {
            handleScroll1(false);
         }
         enterCounter = Number(enterCounter) - 1;
      }
      
      private function handleScroll2(param1:Boolean) : void
      {
         var _loc15_:* = false;
         var _loc17_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = 0;
         var _loc9_:int = 0;
         enterCounter = Number(enterCounter) + 1;
         if(enterCounter > 3)
         {
            return;
         }
         var _loc10_:Number = scrollPane.scrollingPosX;
         var _loc3_:Number = _loc10_ + scrollPane.viewWidth;
         var _loc20_:* = _loc10_ == scrollPane.contentWidth;
         GList.pos_param = _loc10_;
         var _loc21_:int = getIndexOnPos2(param1);
         _loc10_ = GList.pos_param;
         if(_loc21_ == _firstIndex && !param1)
         {
            enterCounter = Number(enterCounter) - 1;
            return;
         }
         var _loc22_:int = _firstIndex;
         _firstIndex = _loc21_;
         var _loc4_:* = _loc21_;
         var _loc18_:* = _loc22_ > _loc21_;
         var _loc13_:int = this.numChildren;
         var _loc11_:int = _loc22_ + _loc13_ - 1;
         var _loc19_:* = !!_loc18_?_loc11_:_loc22_;
         var _loc12_:* = _loc10_;
         var _loc14_:* = 0;
         var _loc2_:* = 0;
         var _loc5_:* = 0;
         var _loc8_:String = defaultItem;
         var _loc16_:int = (scrollPane.viewHeight - _lineGap * (_curLineItemCount - 1)) / _curLineItemCount;
         itemInfoVer = Number(itemInfoVer) + 1;
         while(_loc4_ < _realNumItems && (_loc20_ || _loc12_ < _loc3_))
         {
            _loc6_ = _virtualItems[_loc4_];
            if(_loc6_.obj == null || param1)
            {
               if(itemProvider != null)
               {
                  _loc8_ = itemProvider(_loc4_ % _numItems);
                  if(_loc8_ == null)
                  {
                     _loc8_ = _defaultItem;
                  }
                  _loc8_ = UIPackage.normalizeURL(_loc8_);
               }
               if(_loc6_.obj != null && _loc6_.obj.resourceURL != _loc8_)
               {
                  if(_loc6_.obj is GButton)
                  {
                     _loc6_.selected = GButton(_loc6_.obj).selected;
                  }
                  removeChildToPool(_loc6_.obj);
                  _loc6_.obj = null;
               }
            }
            if(_loc6_.obj == null)
            {
               if(_loc18_)
               {
                  _loc7_ = _loc19_;
                  while(_loc7_ >= _loc22_)
                  {
                     _loc17_ = _virtualItems[_loc7_];
                     if(_loc17_.obj != null && _loc17_.updateFlag != itemInfoVer && _loc17_.obj.resourceURL == _loc8_)
                     {
                        if(_loc17_.obj is GButton)
                        {
                           _loc17_.selected = GButton(_loc17_.obj).selected;
                        }
                        _loc6_.obj = _loc17_.obj;
                        _loc17_.obj = null;
                        if(_loc7_ == _loc19_)
                        {
                           _loc19_--;
                        }
                        break;
                     }
                     _loc7_--;
                  }
               }
               else
               {
                  _loc7_ = _loc19_;
                  while(_loc7_ <= _loc11_)
                  {
                     _loc17_ = _virtualItems[_loc7_];
                     if(_loc17_.obj != null && _loc17_.updateFlag != itemInfoVer && _loc17_.obj.resourceURL == _loc8_)
                     {
                        if(_loc17_.obj is GButton)
                        {
                           _loc17_.selected = GButton(_loc17_.obj).selected;
                        }
                        _loc6_.obj = _loc17_.obj;
                        _loc17_.obj = null;
                        if(_loc7_ == _loc19_)
                        {
                           _loc19_++;
                        }
                        break;
                     }
                     _loc7_++;
                  }
               }
               if(_loc6_.obj != null)
               {
                  setChildIndex(_loc6_.obj,!!_loc18_?_loc4_ - _loc21_:numChildren);
               }
               else
               {
                  _loc6_.obj = _pool.getObject(_loc8_);
                  if(_loc18_)
                  {
                     this.addChildAt(_loc6_.obj,_loc4_ - _loc21_);
                  }
                  else
                  {
                     this.addChild(_loc6_.obj);
                  }
               }
               if(_loc6_.obj is GButton)
               {
                  GButton(_loc6_.obj).selected = _loc6_.selected;
               }
               _loc15_ = true;
            }
            else
            {
               _loc15_ = param1;
            }
            if(_loc15_)
            {
               if(_autoResizeItem && (_layout == 1 || _lineCount > 0))
               {
                  _loc6_.obj.setSize(_loc6_.obj.width,_loc16_,true);
               }
               itemRenderer(_loc4_ % _numItems,_loc6_.obj);
               if(_loc4_ % _curLineItemCount == 0)
               {
                  _loc2_ = Number(_loc2_ + (Math.ceil(_loc6_.obj.width) - _loc6_.width));
                  if(_loc4_ == _loc21_ && _loc22_ > _loc21_)
                  {
                     _loc5_ = Number(Math.ceil(_loc6_.obj.width) - _loc6_.width);
                  }
               }
               _loc6_.width = Math.ceil(_loc6_.obj.width);
               _loc6_.height = Math.ceil(_loc6_.obj.height);
            }
            _loc6_.updateFlag = itemInfoVer;
            _loc6_.obj.setXY(_loc12_,_loc14_);
            if(_loc4_ == _loc21_)
            {
               _loc3_ = _loc3_ + _loc6_.width;
            }
            _loc14_ = Number(_loc14_ + (_loc6_.height + _lineGap));
            if(_loc4_ % _curLineItemCount == _curLineItemCount - 1)
            {
               _loc14_ = 0;
               _loc12_ = Number(_loc12_ + (_loc6_.width + _columnGap));
            }
            _loc4_++;
         }
         _loc9_ = 0;
         while(_loc9_ < _loc13_)
         {
            _loc6_ = _virtualItems[_loc22_ + _loc9_];
            if(_loc6_.updateFlag != itemInfoVer && _loc6_.obj != null)
            {
               if(_loc6_.obj is GButton)
               {
                  _loc6_.selected = GButton(_loc6_.obj).selected;
               }
               removeChildToPool(_loc6_.obj);
               _loc6_.obj = null;
            }
            _loc9_++;
         }
         if(_loc2_ != 0 || _loc5_ != 0)
         {
            _scrollPane.changeContentSizeOnScrolling(_loc2_,0,_loc5_,0);
         }
         if(_loc4_ > 0 && this.numChildren > 0 && _container.x < 0 && getChildAt(0).x > -_container.x)
         {
            handleScroll2(false);
         }
         enterCounter = Number(enterCounter) - 1;
      }
      
      private function handleScroll3(param1:Boolean) : void
      {
         var _loc9_:* = false;
         var _loc21_:* = 0;
         var _loc11_:* = null;
         var _loc17_:* = null;
         var _loc3_:int = 0;
         var _loc6_:Number = scrollPane.scrollingPosX;
         GList.pos_param = _loc6_;
         var _loc26_:int = getIndexOnPos3(param1);
         _loc6_ = GList.pos_param;
         if(_loc26_ == _firstIndex && !param1)
         {
            return;
         }
         var _loc25_:int = _firstIndex;
         _firstIndex = _loc26_;
         var _loc13_:* = _loc25_;
         var _loc4_:int = _virtualItems.length;
         var _loc16_:int = _curLineItemCount * _curLineItemCount2;
         var _loc8_:int = _loc26_ % _curLineItemCount;
         var _loc20_:Number = this.viewWidth;
         var _loc10_:int = _loc26_ / _loc16_;
         var _loc14_:int = _loc10_ * _loc16_;
         var _loc22_:int = _loc14_ + _loc16_ * 2;
         var _loc18_:String = _defaultItem;
         var _loc15_:int = (scrollPane.viewWidth - _columnGap * (_curLineItemCount - 1)) / _curLineItemCount;
         var _loc12_:int = (scrollPane.viewHeight - _lineGap * (_curLineItemCount2 - 1)) / _curLineItemCount2;
         itemInfoVer = Number(itemInfoVer) + 1;
         _loc21_ = _loc14_;
         while(_loc21_ < _loc22_)
         {
            if(_loc21_ < _realNumItems)
            {
               _loc3_ = _loc21_ % _curLineItemCount;
               if(_loc21_ - _loc14_ < _loc16_)
               {
                  if(_loc3_ >= _loc8_)
                  {
                     addr139:
                     _loc17_ = _virtualItems[_loc21_];
                     _loc17_.updateFlag = itemInfoVer;
                  }
               }
               else if(_loc3_ <= _loc8_)
               {
                  §§goto(addr139);
               }
            }
            _loc21_++;
         }
         var _loc24_:GObject = null;
         var _loc7_:int = 0;
         _loc21_ = _loc14_;
         while(_loc21_ < _loc22_)
         {
            if(_loc21_ < _realNumItems)
            {
               _loc17_ = _virtualItems[_loc21_];
               if(_loc17_.updateFlag == itemInfoVer)
               {
                  if(_loc17_.obj == null)
                  {
                     while(_loc13_ < _loc4_)
                     {
                        _loc11_ = _virtualItems[_loc13_];
                        if(_loc11_.obj != null && _loc11_.updateFlag != itemInfoVer)
                        {
                           if(_loc11_.obj is GButton)
                           {
                              _loc11_.selected = GButton(_loc11_.obj).selected;
                           }
                           _loc17_.obj = _loc11_.obj;
                           _loc11_.obj = null;
                           break;
                        }
                        _loc13_++;
                     }
                     if(_loc7_ == -1)
                     {
                        _loc7_ = getChildIndex(_loc24_) + 1;
                     }
                     if(_loc17_.obj == null)
                     {
                        if(itemProvider != null)
                        {
                           _loc18_ = itemProvider(_loc21_ % _numItems);
                           if(_loc18_ == null)
                           {
                              _loc18_ = _defaultItem;
                           }
                           _loc18_ = UIPackage.normalizeURL(_loc18_);
                        }
                        _loc17_.obj = _pool.getObject(_loc18_);
                        this.addChildAt(_loc17_.obj,_loc7_);
                     }
                     else
                     {
                        _loc7_ = setChildIndexBefore(_loc17_.obj,_loc7_);
                     }
                     _loc7_++;
                     if(_loc17_.obj is GButton)
                     {
                        GButton(_loc17_.obj).selected = _loc17_.selected;
                     }
                     _loc9_ = true;
                  }
                  else
                  {
                     _loc9_ = param1;
                     _loc7_ = -1;
                     _loc24_ = _loc17_.obj;
                  }
                  if(_loc9_)
                  {
                     if(_autoResizeItem)
                     {
                        if(_curLineItemCount == _columnCount && _curLineItemCount2 == _lineCount)
                        {
                           _loc17_.obj.setSize(_loc15_,_loc12_,true);
                        }
                        else if(_curLineItemCount == _columnCount)
                        {
                           _loc17_.obj.setSize(_loc15_,_loc17_.obj.height,true);
                        }
                        else if(_curLineItemCount2 == _lineCount)
                        {
                           _loc17_.obj.setSize(_loc17_.obj.width,_loc12_,true);
                        }
                     }
                     itemRenderer(_loc21_ % _numItems,_loc17_.obj);
                     _loc17_.width = Math.ceil(_loc17_.obj.width);
                     _loc17_.height = Math.ceil(_loc17_.obj.height);
                  }
               }
            }
            _loc21_++;
         }
         var _loc23_:int = _loc14_ / _loc16_ * _loc20_;
         var _loc19_:* = _loc23_;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         _loc21_ = _loc14_;
         while(_loc21_ < _loc22_)
         {
            if(_loc21_ < _realNumItems)
            {
               _loc17_ = _virtualItems[_loc21_];
               if(_loc17_.updateFlag == itemInfoVer)
               {
                  _loc17_.obj.setXY(_loc19_,_loc5_);
               }
               if(_loc17_.height > _loc2_)
               {
                  _loc2_ = _loc17_.height;
               }
               if(_loc21_ % _curLineItemCount == _curLineItemCount - 1)
               {
                  _loc19_ = _loc23_;
                  _loc5_ = _loc5_ + (_loc2_ + _lineGap);
                  _loc2_ = 0;
                  if(_loc21_ == _loc14_ + _loc16_ - 1)
                  {
                     _loc23_ = _loc23_ + _loc20_;
                     _loc19_ = _loc23_;
                     _loc5_ = 0;
                  }
               }
               else
               {
                  _loc19_ = int(_loc19_ + (_loc17_.width + _columnGap));
               }
            }
            _loc21_++;
         }
         _loc21_ = _loc13_;
         while(_loc21_ < _loc4_)
         {
            _loc17_ = _virtualItems[_loc21_];
            if(_loc17_.updateFlag != itemInfoVer && _loc17_.obj != null)
            {
               if(_loc17_.obj is GButton)
               {
                  _loc17_.selected = GButton(_loc17_.obj).selected;
               }
               removeChildToPool(_loc17_.obj);
               _loc17_.obj = null;
            }
            _loc21_++;
         }
      }
      
      private function handleArchOrder1() : void
      {
         var _loc4_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc5_:* = NaN;
         var _loc3_:* = 0;
         var _loc1_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:* = null;
         if(this.childrenRenderOrder == 2)
         {
            _loc4_ = _scrollPane.posY + this.viewHeight / 2;
            _loc5_ = 2147483647;
            _loc3_ = 0;
            _loc1_ = this.numChildren;
            _loc6_ = 0;
            while(_loc6_ < _loc1_)
            {
               _loc2_ = getChildAt(_loc6_);
               if(!foldInvisibleItems || _loc2_.visible)
               {
                  _loc7_ = Math.abs(_loc4_ - _loc2_.y - _loc2_.height / 2);
                  if(_loc7_ < _loc5_)
                  {
                     _loc5_ = _loc7_;
                     _loc3_ = _loc6_;
                  }
               }
               _loc6_++;
            }
            this.apexIndex = _loc3_;
         }
      }
      
      private function handleArchOrder2() : void
      {
         var _loc4_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc5_:* = NaN;
         var _loc3_:* = 0;
         var _loc1_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:* = null;
         if(this.childrenRenderOrder == 2)
         {
            _loc4_ = _scrollPane.posX + this.viewWidth / 2;
            _loc5_ = 2147483647;
            _loc3_ = 0;
            _loc1_ = this.numChildren;
            _loc6_ = 0;
            while(_loc6_ < _loc1_)
            {
               _loc2_ = getChildAt(_loc6_);
               if(!foldInvisibleItems || _loc2_.visible)
               {
                  _loc7_ = Math.abs(_loc4_ - _loc2_.x - _loc2_.width / 2);
                  if(_loc7_ < _loc5_)
                  {
                     _loc5_ = _loc7_;
                     _loc3_ = _loc6_;
                  }
               }
               _loc6_++;
            }
            this.apexIndex = _loc3_;
         }
      }
      
      private function handleAlign(param1:Number, param2:Number) : void
      {
         var _loc4_:* = 0;
         var _loc3_:* = 0;
         if(param2 < viewHeight)
         {
            if(_verticalAlign == 1)
            {
               _loc3_ = Number(int((viewHeight - param2) / 2));
            }
            else if(_verticalAlign == 2)
            {
               _loc3_ = Number(viewHeight - param2);
            }
         }
         if(param1 < this.viewWidth)
         {
            if(_align == 1)
            {
               _loc4_ = Number(int((viewWidth - param1) / 2));
            }
            else if(_align == 2)
            {
               _loc4_ = Number(viewWidth - param1);
            }
         }
         if(_loc4_ != _alignOffset.x || _loc3_ != _alignOffset.y)
         {
            _alignOffset.setTo(_loc4_,_loc3_);
            if(scrollPane != null)
            {
               scrollPane.adjustMaskContainer();
            }
            else
            {
               _container.x = _margin.left + _alignOffset.x;
               _container.y = _margin.top + _alignOffset.y;
            }
         }
      }
      
      override protected function updateBounds() : void
      {
         var _loc7_:int = 0;
         var _loc9_:* = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc16_:* = 0;
         var _loc17_:* = 0;
         var _loc18_:* = 0;
         var _loc3_:* = 0;
         var _loc13_:Number = NaN;
         var _loc12_:int = 0;
         if(_virtual)
         {
            return;
         }
         var _loc4_:* = 0;
         var _loc14_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:int = _children.length;
         var _loc8_:Number = this.viewWidth;
         var _loc2_:Number = this.viewHeight;
         var _loc6_:* = 0;
         var _loc15_:int = 0;
         if(_layout == 0)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc1_)
            {
               _loc9_ = getChildAt(_loc7_);
               if(!(foldInvisibleItems && !_loc9_.visible))
               {
                  if(_loc11_ != 0)
                  {
                     _loc11_ = _loc11_ + _lineGap;
                  }
                  _loc9_.y = _loc11_;
                  if(_autoResizeItem)
                  {
                     _loc9_.setSize(_loc8_,_loc9_.height,true);
                  }
                  _loc11_ = _loc11_ + Math.ceil(_loc9_.height);
                  if(_loc9_.width > _loc16_)
                  {
                     _loc16_ = int(_loc9_.width);
                  }
               }
               _loc7_++;
            }
            _loc3_ = int(Math.ceil(_loc16_));
            _loc18_ = _loc11_;
         }
         else if(_layout == 1)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc1_)
            {
               _loc9_ = getChildAt(_loc7_);
               if(!(foldInvisibleItems && !_loc9_.visible))
               {
                  if(_loc10_ != 0)
                  {
                     _loc10_ = _loc10_ + _columnGap;
                  }
                  _loc9_.x = _loc10_;
                  if(_autoResizeItem)
                  {
                     _loc9_.setSize(_loc9_.width,_loc2_,true);
                  }
                  _loc10_ = _loc10_ + Math.ceil(_loc9_.width);
                  if(_loc9_.height > _loc17_)
                  {
                     _loc17_ = int(_loc9_.height);
                  }
               }
               _loc7_++;
            }
            _loc3_ = _loc10_;
            _loc18_ = int(Math.ceil(_loc17_));
         }
         else if(_layout == 2)
         {
            if(_autoResizeItem && _columnCount > 0)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc1_)
               {
                  _loc9_ = getChildAt(_loc7_);
                  if(!(foldInvisibleItems && !_loc9_.visible))
                  {
                     _loc6_ = Number(_loc6_ + _loc9_.sourceWidth);
                     _loc4_++;
                     if(_loc4_ == _columnCount || _loc7_ == _loc1_ - 1)
                     {
                        _loc13_ = (_loc8_ - _loc6_ - (_loc4_ - 1) * _columnGap) / _loc6_;
                        _loc10_ = 0;
                        _loc4_ = _loc15_;
                        while(_loc4_ <= _loc7_)
                        {
                           _loc9_ = getChildAt(_loc4_);
                           if(!(foldInvisibleItems && !_loc9_.visible))
                           {
                              _loc9_.setXY(_loc10_,_loc11_);
                              if(_loc4_ < _loc7_)
                              {
                                 _loc9_.setSize(_loc9_.sourceWidth + Math.round(_loc9_.sourceWidth * _loc13_),_loc9_.height,true);
                                 _loc10_ = _loc10_ + (Math.ceil(_loc9_.width) + _columnGap);
                              }
                              else
                              {
                                 _loc9_.setSize(_loc8_ - _loc10_,_loc9_.height,true);
                              }
                              if(_loc9_.height > _loc17_)
                              {
                                 _loc17_ = int(_loc9_.height);
                              }
                           }
                           _loc4_++;
                        }
                        _loc11_ = _loc11_ + (Math.ceil(_loc17_) + _lineGap);
                        _loc17_ = 0;
                        _loc4_ = 0;
                        _loc15_ = _loc7_ + 1;
                        _loc6_ = 0;
                     }
                  }
                  _loc7_++;
               }
               _loc18_ = int(_loc11_ + Math.ceil(_loc17_));
               _loc3_ = int(_loc8_);
            }
            else
            {
               _loc7_ = 0;
               while(_loc7_ < _loc1_)
               {
                  _loc9_ = getChildAt(_loc7_);
                  if(!(foldInvisibleItems && !_loc9_.visible))
                  {
                     if(_loc10_ != 0)
                     {
                        _loc10_ = _loc10_ + _columnGap;
                     }
                     if(_columnCount != 0 && _loc4_ >= _columnCount || _columnCount == 0 && _loc10_ + _loc9_.width > _loc8_ && _loc17_ != 0)
                     {
                        _loc10_ = 0;
                        _loc11_ = _loc11_ + (Math.ceil(_loc17_) + _lineGap);
                        _loc17_ = 0;
                        _loc4_ = 0;
                     }
                     _loc9_.setXY(_loc10_,_loc11_);
                     _loc10_ = _loc10_ + Math.ceil(_loc9_.width);
                     if(_loc10_ > _loc16_)
                     {
                        _loc16_ = _loc10_;
                     }
                     if(_loc9_.height > _loc17_)
                     {
                        _loc17_ = int(_loc9_.height);
                     }
                     _loc4_++;
                  }
                  _loc7_++;
               }
               _loc18_ = int(_loc11_ + Math.ceil(_loc17_));
               _loc3_ = int(Math.ceil(_loc16_));
            }
         }
         else if(_layout == 3)
         {
            if(_autoResizeItem && _lineCount > 0)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc1_)
               {
                  _loc9_ = getChildAt(_loc7_);
                  if(!(foldInvisibleItems && !_loc9_.visible))
                  {
                     _loc6_ = Number(_loc6_ + _loc9_.sourceHeight);
                     _loc4_++;
                     if(_loc4_ == _lineCount || _loc7_ == _loc1_ - 1)
                     {
                        _loc13_ = (_loc2_ - _loc6_ - (_loc4_ - 1) * _lineGap) / _loc6_;
                        _loc11_ = 0;
                        _loc4_ = _loc15_;
                        while(_loc4_ <= _loc7_)
                        {
                           _loc9_ = getChildAt(_loc4_);
                           if(!(foldInvisibleItems && !_loc9_.visible))
                           {
                              _loc9_.setXY(_loc10_,_loc11_);
                              if(_loc4_ < _loc7_)
                              {
                                 _loc9_.setSize(_loc9_.width,_loc9_.sourceHeight + Math.round(_loc9_.sourceHeight * _loc13_),true);
                                 _loc11_ = _loc11_ + (Math.ceil(_loc9_.height) + _lineGap);
                              }
                              else
                              {
                                 _loc9_.setSize(_loc9_.width,_loc2_ - _loc11_,true);
                              }
                              if(_loc9_.width > _loc16_)
                              {
                                 _loc16_ = int(_loc9_.width);
                              }
                           }
                           _loc4_++;
                        }
                        _loc10_ = _loc10_ + (Math.ceil(_loc16_) + _columnGap);
                        _loc16_ = 0;
                        _loc4_ = 0;
                        _loc15_ = _loc7_ + 1;
                        _loc6_ = 0;
                     }
                  }
                  _loc7_++;
               }
               _loc3_ = int(_loc10_ + Math.ceil(_loc16_));
               _loc18_ = int(_loc2_);
            }
            else
            {
               _loc7_ = 0;
               while(_loc7_ < _loc1_)
               {
                  _loc9_ = getChildAt(_loc7_);
                  if(!(foldInvisibleItems && !_loc9_.visible))
                  {
                     if(_loc11_ != 0)
                     {
                        _loc11_ = _loc11_ + _lineGap;
                     }
                     if(_lineCount != 0 && _loc4_ >= _lineCount || _lineCount == 0 && _loc11_ + _loc9_.height > _loc2_ && _loc16_ != 0)
                     {
                        _loc11_ = 0;
                        _loc10_ = _loc10_ + (Math.ceil(_loc16_) + _columnGap);
                        _loc16_ = 0;
                        _loc4_ = 0;
                     }
                     _loc9_.setXY(_loc10_,_loc11_);
                     _loc11_ = _loc11_ + Math.ceil(_loc9_.height);
                     if(_loc11_ > _loc17_)
                     {
                        _loc17_ = _loc11_;
                     }
                     if(_loc9_.width > _loc16_)
                     {
                        _loc16_ = int(_loc9_.width);
                     }
                     _loc4_++;
                  }
                  _loc7_++;
               }
               _loc3_ = int(_loc10_ + Math.ceil(_loc16_));
               _loc18_ = int(Math.ceil(_loc17_));
            }
         }
         else
         {
            if(_autoResizeItem && _lineCount > 0)
            {
               _loc12_ = Math.floor((_loc2_ - (_lineCount - 1) * _lineGap) / _lineCount);
            }
            if(_autoResizeItem && _columnCount > 0)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc1_)
               {
                  _loc9_ = getChildAt(_loc7_);
                  if(!(foldInvisibleItems && !_loc9_.visible))
                  {
                     _loc6_ = Number(_loc6_ + _loc9_.sourceWidth);
                     _loc4_++;
                     if(_loc4_ == _columnCount || _loc7_ == _loc1_ - 1)
                     {
                        _loc13_ = (_loc8_ - _loc6_ - (_loc4_ - 1) * _columnGap) / _loc6_;
                        _loc10_ = 0;
                        _loc4_ = _loc15_;
                        while(_loc4_ <= _loc7_)
                        {
                           _loc9_ = getChildAt(_loc4_);
                           if(!(foldInvisibleItems && !_loc9_.visible))
                           {
                              _loc9_.setXY(_loc14_ * _loc8_ + _loc10_,_loc11_);
                              if(_loc4_ < _loc7_)
                              {
                                 _loc9_.setSize(_loc9_.sourceWidth + Math.round(_loc9_.sourceWidth * _loc13_),_lineCount > 0?_loc12_:_loc9_.height,true);
                                 _loc10_ = _loc10_ + (Math.ceil(_loc9_.width) + _columnGap);
                              }
                              else
                              {
                                 _loc9_.setSize(_loc8_ - _loc10_,_lineCount > 0?_loc12_:_loc9_.height,true);
                              }
                              if(_loc9_.height > _loc17_)
                              {
                                 _loc17_ = int(_loc9_.height);
                              }
                           }
                           _loc4_++;
                        }
                        _loc11_ = _loc11_ + (Math.ceil(_loc17_) + _lineGap);
                        _loc17_ = 0;
                        _loc4_ = 0;
                        _loc15_ = _loc7_ + 1;
                        _loc6_ = 0;
                        _loc5_++;
                        if(_lineCount != 0 && _loc5_ >= _lineCount || _lineCount == 0 && _loc11_ + _loc9_.height > _loc2_)
                        {
                           _loc14_++;
                           _loc11_ = 0;
                           _loc5_ = 0;
                        }
                     }
                  }
                  _loc7_++;
               }
            }
            else
            {
               _loc7_ = 0;
               while(_loc7_ < _loc1_)
               {
                  _loc9_ = getChildAt(_loc7_);
                  if(!(foldInvisibleItems && !_loc9_.visible))
                  {
                     if(_loc10_ != 0)
                     {
                        _loc10_ = _loc10_ + _columnGap;
                     }
                     if(_autoResizeItem && _lineCount > 0)
                     {
                        _loc9_.setSize(_loc9_.width,_loc12_,true);
                     }
                     if(_columnCount != 0 && _loc4_ >= _columnCount || _columnCount == 0 && _loc10_ + _loc9_.width > _loc8_ && _loc17_ != 0)
                     {
                        _loc10_ = 0;
                        _loc11_ = _loc11_ + (Math.ceil(_loc17_) + _lineGap);
                        _loc17_ = 0;
                        _loc4_ = 0;
                        _loc5_++;
                        if(_lineCount != 0 && _loc5_ >= _lineCount || _lineCount == 0 && _loc11_ + _loc9_.height > _loc2_ && _loc16_ != 0)
                        {
                           _loc14_++;
                           _loc11_ = 0;
                           _loc5_ = 0;
                        }
                     }
                     _loc9_.setXY(_loc14_ * _loc8_ + _loc10_,_loc11_);
                     _loc10_ = _loc10_ + Math.ceil(_loc9_.width);
                     if(_loc10_ > _loc16_)
                     {
                        _loc16_ = _loc10_;
                     }
                     if(_loc9_.height > _loc17_)
                     {
                        _loc17_ = int(_loc9_.height);
                     }
                     _loc4_++;
                  }
                  _loc7_++;
               }
            }
            _loc18_ = int(_loc14_ > 0?_loc2_:_loc11_ + Math.ceil(_loc17_));
            _loc3_ = int((_loc14_ + 1) * _loc8_);
         }
         handleAlign(_loc3_,_loc18_);
         setBounds(0,0,_loc3_,_loc18_);
      }
      
      override public function setup_beforeAdd(param1:XML) : void
      {
         var _loc10_:* = null;
         var _loc11_:int = 0;
         var _loc3_:int = 0;
         var _loc14_:int = 0;
         var _loc5_:int = 0;
         var _loc8_:* = null;
         var _loc6_:* = null;
         var _loc9_:* = null;
         var _loc4_:* = null;
         var _loc7_:* = null;
         var _loc12_:* = null;
         super.setup_beforeAdd(param1);
         _loc10_ = param1.@layout;
         if(_loc10_)
         {
            _layout = ListLayoutType.parse(_loc10_);
         }
         _loc10_ = param1.@overflow;
         if(_loc10_)
         {
            _loc11_ = OverflowType.parse(_loc10_);
         }
         else
         {
            _loc11_ = 0;
         }
         _loc10_ = param1.@margin;
         if(_loc10_)
         {
            _margin.parse(_loc10_);
         }
         _loc10_ = param1.@align;
         if(_loc10_)
         {
            _align = AlignType.parse(_loc10_);
         }
         _loc10_ = param1.@vAlign;
         if(_loc10_)
         {
            _verticalAlign = VertAlignType.parse(_loc10_);
         }
         if(_loc11_ == 2)
         {
            _loc10_ = param1.@scroll;
            if(_loc10_)
            {
               _loc3_ = ScrollType.parse(_loc10_);
            }
            else
            {
               _loc3_ = 1;
            }
            _loc10_ = param1.@scrollBar;
            if(_loc10_)
            {
               _loc14_ = ScrollBarDisplayType.parse(_loc10_);
            }
            else
            {
               _loc14_ = 0;
            }
            _loc5_ = parseInt(param1.@scrollBarFlags);
            _loc8_ = new Margin();
            _loc10_ = param1.@scrollBarMargin;
            if(_loc10_)
            {
               _loc8_.parse(_loc10_);
            }
            _loc10_ = param1.@scrollBarRes;
            if(_loc10_)
            {
               _loc4_ = _loc10_.split(",");
               _loc6_ = _loc4_[0];
               _loc9_ = _loc4_[1];
            }
            setupScroll(_loc8_,_loc3_,_loc14_,_loc5_,_loc6_,_loc9_);
         }
         else
         {
            setupOverflow(_loc11_);
         }
         _loc10_ = param1.@lineGap;
         if(_loc10_)
         {
            _lineGap = parseInt(_loc10_);
         }
         _loc10_ = param1.@colGap;
         if(_loc10_)
         {
            _columnGap = parseInt(_loc10_);
         }
         _loc10_ = param1.@lineItemCount;
         if(_loc10_)
         {
            if(_layout == 2 || _layout == 4)
            {
               _columnCount = parseInt(_loc10_);
            }
            else if(_layout == 3)
            {
               _lineCount = parseInt(_loc10_);
            }
         }
         _loc10_ = param1.@lineItemCount2;
         if(_loc10_)
         {
            _lineCount = parseInt(_loc10_);
         }
         _loc10_ = param1.@selectionMode;
         if(_loc10_)
         {
            _selectionMode = ListSelectionMode.parse(_loc10_);
         }
         _loc10_ = param1.@defaultItem;
         if(_loc10_)
         {
            _defaultItem = _loc10_;
         }
         _loc10_ = param1.@autoItemSize;
         if(_layout == 1 || _layout == 0)
         {
            _autoResizeItem = _loc10_ != "false";
         }
         else
         {
            _autoResizeItem = _loc10_ == "true";
         }
         _loc10_ = param1.@renderOrder;
         if(_loc10_)
         {
            _childrenRenderOrder = ChildrenRenderOrder.parse(_loc10_);
            if(_childrenRenderOrder == 2)
            {
               _loc10_ = param1.@apex;
               if(_loc10_)
               {
                  _apexIndex = parseInt(_loc10_);
               }
            }
         }
         var _loc2_:XMLList = param1.item;
         var _loc16_:int = 0;
         var _loc15_:* = _loc2_;
         for each(var _loc13_ in _loc2_)
         {
            _loc7_ = _loc13_.@url;
            if(!_loc7_)
            {
               _loc7_ = _defaultItem;
            }
            if(_loc7_)
            {
               _loc12_ = getFromPool(_loc7_);
               if(_loc12_ != null)
               {
                  addChild(_loc12_);
                  _loc10_ = _loc13_.@title;
                  if(_loc10_)
                  {
                     _loc12_.text = _loc10_;
                  }
                  _loc10_ = _loc13_.@icon;
                  if(_loc10_)
                  {
                     _loc12_.icon = _loc10_;
                  }
                  _loc10_ = _loc13_.@name;
                  if(_loc10_)
                  {
                     _loc12_.name = _loc10_;
                  }
               }
            }
         }
      }
      
      override public function setup_afterAdd(param1:XML) : void
      {
         var _loc2_:* = null;
         super.setup_afterAdd(param1);
         _loc2_ = param1.@selectionController;
         if(_loc2_)
         {
            _selectionController = parent.getController(_loc2_);
         }
      }
   }
}

import fairygui.GObject;

class ItemInfo
{
    
   
   public var width:Number = 0;
   
   public var height:Number = 0;
   
   public var obj:GObject;
   
   public var updateFlag:uint;
   
   public var selected:Boolean;
   
   function ItemInfo()
   {
      super();
   }
}
