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
      
      private var itemInfoVer:uint = 0;
      
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
         scrollItemToViewOnClick = false;
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
         if(param1 is GButton && _selectionMode != 3)
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
         var _loc1_:* = null;
         var _loc3_:int = 0;
         var _loc2_:* = null;
         if(_virtual)
         {
            _loc4_ = 0;
            while(_loc4_ < _realNumItems)
            {
               _loc1_ = _virtualItems[_loc4_];
               if(_loc1_.obj is GButton && GButton(_loc1_.obj).selected || _loc1_.obj == null && _loc1_.selected)
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
            _loc3_ = _children.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc2_ = _children[_loc4_].asButton;
               if(_loc2_ != null && _loc2_.selected)
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
      
      public function getSelection(param1:Vector.<int> = null) : Vector.<int>
      {
         var _loc5_:int = 0;
         var _loc2_:* = null;
         var _loc6_:int = 0;
         var _loc4_:int = 0;
         var _loc3_:* = null;
         if(param1 == null)
         {
            param1 = new Vector.<int>();
         }
         if(_virtual)
         {
            _loc5_ = 0;
            for(; _loc5_ < _realNumItems; _loc5_++)
            {
               _loc2_ = _virtualItems[_loc5_];
               if(_loc2_.obj is GButton && GButton(_loc2_.obj).selected || _loc2_.obj == null && _loc2_.selected)
               {
                  if(_loop)
                  {
                     _loc6_ = _loc5_ % _numItems;
                     if(param1.indexOf(_loc6_) == -1)
                     {
                     }
                     continue;
                  }
                  param1.push(_loc5_);
                  continue;
               }
            }
         }
         else
         {
            _loc4_ = _children.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc3_ = _children[_loc5_].asButton;
               if(_loc3_ != null && _loc3_.selected)
               {
                  param1.push(_loc5_);
               }
               _loc5_++;
            }
         }
         return param1;
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
         var _loc1_:* = null;
         var _loc3_:int = 0;
         var _loc2_:* = null;
         if(_virtual)
         {
            _loc4_ = 0;
            while(_loc4_ < _realNumItems)
            {
               _loc1_ = _virtualItems[_loc4_];
               if(_loc1_.obj is GButton)
               {
                  GButton(_loc1_.obj).selected = false;
               }
               _loc1_.selected = false;
               _loc4_++;
            }
         }
         else
         {
            _loc3_ = _children.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc2_ = _children[_loc4_].asButton;
               if(_loc2_ != null)
               {
                  _loc2_.selected = false;
               }
               _loc4_++;
            }
         }
      }
      
      private function clearSelectionExcept(param1:GObject) : void
      {
         var _loc5_:int = 0;
         var _loc2_:* = null;
         var _loc4_:int = 0;
         var _loc3_:* = null;
         if(_virtual)
         {
            _loc5_ = 0;
            while(_loc5_ < _realNumItems)
            {
               _loc2_ = _virtualItems[_loc5_];
               if(_loc2_.obj != param1)
               {
                  if(_loc2_.obj is GButton)
                  {
                     GButton(_loc2_.obj).selected = false;
                  }
                  _loc2_.selected = false;
               }
               _loc5_++;
            }
         }
         else
         {
            _loc4_ = _children.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc3_ = _children[_loc5_].asButton;
               if(_loc3_ != null && _loc3_ != param1)
               {
                  _loc3_.selected = false;
               }
               _loc5_++;
            }
         }
      }
      
      public function selectAll() : void
      {
         var _loc5_:int = 0;
         var _loc1_:* = null;
         var _loc4_:int = 0;
         var _loc3_:* = null;
         checkVirtualList();
         var _loc2_:* = -1;
         if(_virtual)
         {
            _loc5_ = 0;
            while(_loc5_ < _realNumItems)
            {
               _loc1_ = _virtualItems[_loc5_];
               if(_loc1_.obj is GButton && !GButton(_loc1_.obj).selected)
               {
                  GButton(_loc1_.obj).selected = true;
                  _loc2_ = _loc5_;
               }
               _loc1_.selected = true;
               _loc5_++;
            }
         }
         else
         {
            _loc4_ = _children.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc3_ = _children[_loc5_].asButton;
               if(_loc3_ != null && !_loc3_.selected)
               {
                  _loc3_.selected = true;
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
         var _loc1_:* = null;
         var _loc4_:int = 0;
         var _loc3_:* = null;
         checkVirtualList();
         var _loc2_:* = -1;
         if(_virtual)
         {
            _loc5_ = 0;
            while(_loc5_ < _realNumItems)
            {
               _loc1_ = _virtualItems[_loc5_];
               if(_loc1_.obj is GButton)
               {
                  GButton(_loc1_.obj).selected = !GButton(_loc1_.obj).selected;
                  if(GButton(_loc1_.obj).selected)
                  {
                     _loc2_ = _loc5_;
                  }
               }
               _loc1_.selected = !_loc1_.selected;
               _loc5_++;
            }
         }
         else
         {
            _loc4_ = _children.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc3_ = _children[_loc5_].asButton;
               if(_loc3_ != null)
               {
                  _loc3_.selected = !_loc3_.selected;
                  if(_loc3_.selected)
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
         var _loc2_:* = null;
         var _loc7_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:int = this.selectedIndex;
         if(_loc5_ == -1)
         {
            return;
         }
         loop8:
         switch(int(param1) - 1)
         {
            case 0:
               if(_layout == 0 || _layout == 3)
               {
                  _loc5_--;
                  if(_loc5_ >= 0)
                  {
                     clearSelection();
                     addSelection(_loc5_,true);
                  }
               }
               else if(_layout == 2 || _layout == 4)
               {
                  _loc2_ = _children[_loc5_];
                  _loc7_ = 0;
                  _loc6_ = _loc5_ - 1;
                  while(_loc6_ >= 0)
                  {
                     _loc3_ = _children[_loc6_];
                     if(_loc3_.y != _loc2_.y)
                     {
                        _loc2_ = _loc3_;
                        break;
                     }
                     _loc7_++;
                     _loc6_--;
                  }
                  while(_loc6_ >= 0)
                  {
                     _loc3_ = _children[_loc6_];
                     if(_loc3_.y != _loc2_.y)
                     {
                        clearSelection();
                        addSelection(_loc6_ + _loc7_ + 1,true);
                        break;
                     }
                     _loc6_--;
                  }
               }
               break;
            default:
               if(_layout == 0 || _layout == 3)
               {
                  _loc5_--;
                  if(_loc5_ >= 0)
                  {
                     clearSelection();
                     addSelection(_loc5_,true);
                  }
               }
               else if(_layout == 2 || _layout == 4)
               {
                  _loc2_ = _children[_loc5_];
                  _loc7_ = 0;
                  _loc6_ = _loc5_ - 1;
                  while(_loc6_ >= 0)
                  {
                     _loc3_ = _children[_loc6_];
                     if(_loc3_.y != _loc2_.y)
                     {
                        _loc2_ = _loc3_;
                        break;
                     }
                     _loc7_++;
                     _loc6_--;
                  }
                  while(_loc6_ >= 0)
                  {
                     _loc3_ = _children[_loc6_];
                     if(_loc3_.y != _loc2_.y)
                     {
                        clearSelection();
                        addSelection(_loc6_ + _loc7_ + 1,true);
                        break;
                     }
                     _loc6_--;
                  }
               }
               break;
            case 2:
               if(_layout == 1 || _layout == 2 || _layout == 4)
               {
                  _loc5_++;
                  if(_loc5_ < this.numItems)
                  {
                     clearSelection();
                     addSelection(_loc5_,true);
                  }
               }
               else if(_layout == 3)
               {
                  _loc2_ = _children[_loc5_];
                  _loc7_ = 0;
                  _loc4_ = _children.length;
                  _loc6_ = _loc5_ + 1;
                  while(_loc6_ < _loc4_)
                  {
                     _loc3_ = _children[_loc6_];
                     if(_loc3_.x != _loc2_.x)
                     {
                        _loc2_ = _loc3_;
                        break;
                     }
                     _loc7_++;
                     _loc6_++;
                  }
                  while(_loc6_ < _loc4_)
                  {
                     _loc3_ = _children[_loc6_];
                     if(_loc3_.x != _loc2_.x)
                     {
                        clearSelection();
                        addSelection(_loc6_ - _loc7_ - 1,true);
                        break;
                     }
                     _loc6_++;
                  }
               }
               break;
            default:
               if(_layout == 1 || _layout == 2 || _layout == 4)
               {
                  _loc5_++;
                  if(_loc5_ < this.numItems)
                  {
                     clearSelection();
                     addSelection(_loc5_,true);
                  }
               }
               else if(_layout == 3)
               {
                  _loc2_ = _children[_loc5_];
                  _loc7_ = 0;
                  _loc4_ = _children.length;
                  _loc6_ = _loc5_ + 1;
                  while(_loc6_ < _loc4_)
                  {
                     _loc3_ = _children[_loc6_];
                     if(_loc3_.x != _loc2_.x)
                     {
                        _loc2_ = _loc3_;
                        break;
                     }
                     _loc7_++;
                     _loc6_++;
                  }
                  while(_loc6_ < _loc4_)
                  {
                     _loc3_ = _children[_loc6_];
                     if(_loc3_.x != _loc2_.x)
                     {
                        clearSelection();
                        addSelection(_loc6_ - _loc7_ - 1,true);
                        break;
                     }
                     _loc6_++;
                  }
               }
               break;
            case 4:
               if(_layout == 0 || _layout == 3)
               {
                  _loc5_++;
                  if(_loc5_ < this.numItems)
                  {
                     clearSelection();
                     addSelection(_loc5_,true);
                  }
               }
               else if(_layout == 2 || _layout == 4)
               {
                  _loc2_ = _children[_loc5_];
                  _loc7_ = 0;
                  _loc4_ = _children.length;
                  _loc6_ = _loc5_ + 1;
                  while(_loc6_ < _loc4_)
                  {
                     _loc3_ = _children[_loc6_];
                     if(_loc3_.y != _loc2_.y)
                     {
                        _loc2_ = _loc3_;
                        break;
                     }
                     _loc7_++;
                     _loc6_++;
                  }
                  while(_loc6_ < _loc4_)
                  {
                     _loc3_ = _children[_loc6_];
                     if(_loc3_.y != _loc2_.y)
                     {
                        clearSelection();
                        addSelection(_loc6_ - _loc7_ - 1,true);
                        break;
                     }
                     _loc6_++;
                  }
               }
               break;
            default:
               if(_layout == 0 || _layout == 3)
               {
                  _loc5_++;
                  if(_loc5_ < this.numItems)
                  {
                     clearSelection();
                     addSelection(_loc5_,true);
                  }
               }
               else if(_layout == 2 || _layout == 4)
               {
                  _loc2_ = _children[_loc5_];
                  _loc7_ = 0;
                  _loc4_ = _children.length;
                  _loc6_ = _loc5_ + 1;
                  while(_loc6_ < _loc4_)
                  {
                     _loc3_ = _children[_loc6_];
                     if(_loc3_.y != _loc2_.y)
                     {
                        _loc2_ = _loc3_;
                        break;
                     }
                     _loc7_++;
                     _loc6_++;
                  }
                  while(_loc6_ < _loc4_)
                  {
                     _loc3_ = _children[_loc6_];
                     if(_loc3_.y != _loc2_.y)
                     {
                        clearSelection();
                        addSelection(_loc6_ - _loc7_ - 1,true);
                        break;
                     }
                     _loc6_++;
                  }
               }
               break;
            case 6:
               if(_layout == 1 || _layout == 2 || _layout == 4)
               {
                  _loc5_--;
                  if(_loc5_ >= 0)
                  {
                     clearSelection();
                     addSelection(_loc5_,true);
                  }
                  break;
               }
               if(_layout == 3)
               {
                  _loc2_ = _children[_loc5_];
                  _loc7_ = 0;
                  _loc6_ = _loc5_ - 1;
                  while(_loc6_ >= 0)
                  {
                     _loc3_ = _children[_loc6_];
                     if(_loc3_.x != _loc2_.x)
                     {
                        _loc2_ = _loc3_;
                        break;
                     }
                     _loc7_++;
                     _loc6_--;
                  }
                  while(true)
                  {
                     if(_loc6_ >= 0)
                     {
                        _loc3_ = _children[_loc6_];
                        if(_loc3_.x != _loc2_.x)
                        {
                           clearSelection();
                           addSelection(_loc6_ + _loc7_ + 1,true);
                           break loop8;
                        }
                        _loc6_--;
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
         var _loc3_:* = null;
         ensureBoundsCorrect();
         var _loc5_:Array = root.nativeStage.getObjectsUnderPoint(new Point(param1,param2));
         if(!_loc5_ || _loc5_.length == 0)
         {
            return null;
         }
         var _loc7_:int = 0;
         var _loc6_:* = _loc5_;
         for each(var _loc4_ in _loc5_)
         {
            while(_loc4_ != null && !(_loc4_ is Stage))
            {
               if(_loc4_ is UIDisplayObject)
               {
                  _loc3_ = UIDisplayObject(_loc4_).owner;
                  while(_loc3_ != null && _loc3_.parent != this)
                  {
                     _loc3_ = _loc3_.parent;
                  }
                  if(_loc3_ != null)
                  {
                     return _loc3_;
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
         var _loc2_:GObject = GObject(param1.currentTarget);
         setSelectionOnEvent(_loc2_);
         if(_scrollPane != null && scrollItemToViewOnClick)
         {
            _scrollPane.scrollToView(_loc2_,true);
         }
         var _loc3_:ItemEvent = new ItemEvent("itemClick",_loc2_);
         _loc3_.stageX = param1.stageX;
         _loc3_.stageY = param1.stageY;
         _loc3_.clickCount = param1.clickCount;
         dispatchItemEvent(_loc3_);
      }
      
      protected function dispatchItemEvent(param1:ItemEvent) : void
      {
         this.dispatchEvent(param1);
      }
      
      private function __rightClickItem(param1:MouseEvent) : void
      {
         var _loc2_:GObject = GObject(param1.currentTarget);
         if(_loc2_ is GButton && !GButton(_loc2_).selected)
         {
            setSelectionOnEvent(_loc2_);
         }
         if(_scrollPane != null && scrollItemToViewOnClick)
         {
            _scrollPane.scrollToView(_loc2_,true);
         }
         var _loc3_:ItemEvent = new ItemEvent("itemClick",_loc2_);
         _loc3_.stageX = param1.stageX;
         _loc3_.stageY = param1.stageY;
         _loc3_.rightButton = true;
         dispatchItemEvent(_loc3_);
      }
      
      private function setSelectionOnEvent(param1:GObject) : void
      {
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc10_:* = 0;
         var _loc3_:* = null;
         var _loc8_:* = null;
         if(!(param1 is GButton) || _selectionMode == 3)
         {
            return;
         }
         var _loc7_:Boolean = false;
         var _loc2_:GButton = GButton(param1);
         var _loc9_:int = childIndexToItemIndex(getChildIndex(param1));
         if(_selectionMode == 0)
         {
            if(!_loc2_.selected)
            {
               clearSelectionExcept(_loc2_);
               _loc2_.selected = true;
            }
         }
         else
         {
            _loc4_ = this.root;
            if(_loc4_.shiftKeyDown)
            {
               if(!_loc2_.selected)
               {
                  if(_lastSelectedIndex != -1)
                  {
                     _loc5_ = Math.min(_lastSelectedIndex,_loc9_);
                     _loc6_ = Math.max(_lastSelectedIndex,_loc9_);
                     _loc6_ = Math.min(_loc6_,this.numItems - 1);
                     if(_virtual)
                     {
                        _loc10_ = _loc5_;
                        while(_loc10_ <= _loc6_)
                        {
                           _loc3_ = _virtualItems[_loc10_];
                           if(_loc3_.obj is GButton)
                           {
                              GButton(_loc3_.obj).selected = true;
                           }
                           _loc3_.selected = true;
                           _loc10_++;
                        }
                     }
                     else
                     {
                        _loc10_ = _loc5_;
                        while(_loc10_ <= _loc6_)
                        {
                           _loc8_ = getChildAt(_loc10_).asButton;
                           if(_loc8_ != null)
                           {
                              _loc8_.selected = true;
                           }
                           _loc10_++;
                        }
                     }
                     _loc7_ = true;
                  }
                  else
                  {
                     _loc2_.selected = true;
                  }
               }
            }
            else if(_loc4_.ctrlKeyDown || _selectionMode == 2)
            {
               _loc2_.selected = !_loc2_.selected;
            }
            else if(!_loc2_.selected)
            {
               clearSelectionExcept(_loc2_);
               _loc2_.selected = true;
            }
            else
            {
               clearSelectionExcept(_loc2_);
            }
         }
         if(!_loc7_)
         {
            _lastSelectedIndex = _loc9_;
         }
         if(_loc2_.selected)
         {
            updateSelectionController(_loc9_);
         }
      }
      
      public function resizeToFit(param1:int = 2147483647, param2:int = 0) : void
      {
         var _loc7_:int = 0;
         var _loc6_:int = 0;
         var _loc5_:* = null;
         var _loc3_:* = 0;
         ensureBoundsCorrect();
         var _loc4_:int = this.numItems;
         if(param1 > _loc4_)
         {
            param1 = _loc4_;
         }
         if(_virtual)
         {
            _loc7_ = Math.ceil(param1 / _curLineItemCount);
            if(_layout == 0 || _layout == 2)
            {
               this.viewHeight = _loc7_ * _itemSize.y + Math.max(0,_loc7_ - 1) * _lineGap;
            }
            else
            {
               this.viewWidth = _loc7_ * _itemSize.x + Math.max(0,_loc7_ - 1) * _columnGap;
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
            _loc6_ = param1 - 1;
            _loc5_ = null;
            while(_loc6_ >= 0)
            {
               _loc5_ = this.getChildAt(_loc6_);
               if(!(!foldInvisibleItems || _loc5_.visible))
               {
                  _loc6_--;
                  continue;
               }
               break;
            }
            if(_loc6_ < 0)
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
               _loc3_ = int(_loc5_.y + _loc5_.height);
               if(_loc3_ < param2)
               {
                  _loc3_ = param2;
               }
               this.viewHeight = _loc3_;
            }
            else
            {
               _loc3_ = int(_loc5_.x + _loc5_.width);
               if(_loc3_ < param2)
               {
                  _loc3_ = param2;
               }
               this.viewWidth = _loc3_;
            }
         }
      }
      
      public function getMaxItemWidth() : int
      {
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc2_:int = _children.length;
         var _loc1_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = getChildAt(_loc3_);
            if(_loc4_.width > _loc1_)
            {
               _loc1_ = _loc4_.width;
            }
            _loc3_++;
         }
         return _loc1_;
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
         var _loc4_:* = NaN;
         var _loc5_:int = 0;
         if(_virtual)
         {
            if(!param3)
            {
               param3 = new Point();
            }
            if(_layout == 0 || _layout == 2)
            {
               _loc4_ = param2;
               GList.pos_param = param2;
               _loc5_ = getIndexOnPos1(false);
               param2 = GList.pos_param;
               if(_loc5_ < _virtualItems.length && _loc4_ - param2 > _virtualItems[_loc5_].height / 2 && _loc5_ < _realNumItems)
               {
                  param2 = param2 + (_virtualItems[_loc5_].height + _lineGap);
               }
            }
            else if(_layout == 1 || _layout == 3)
            {
               _loc4_ = param1;
               GList.pos_param = param1;
               _loc5_ = getIndexOnPos2(false);
               param1 = GList.pos_param;
               if(_loc5_ < _virtualItems.length && _loc4_ - param1 > _virtualItems[_loc5_].width / 2 && _loc5_ < _realNumItems)
               {
                  param1 = param1 + (_virtualItems[_loc5_].width + _columnGap);
               }
            }
            else
            {
               _loc4_ = param1;
               GList.pos_param = param1;
               _loc5_ = getIndexOnPos3(false);
               param1 = GList.pos_param;
               if(_loc5_ < _virtualItems.length && _loc4_ - param1 > _virtualItems[_loc5_].width / 2 && _loc5_ < _realNumItems)
               {
                  param1 = param1 + (_virtualItems[_loc5_].width + _columnGap);
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
         var _loc5_:* = null;
         var _loc4_:* = null;
         var _loc6_:* = NaN;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc7_:* = null;
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
            _loc4_ = _virtualItems[param1];
            _loc6_ = 0;
            if(_layout == 0 || _layout == 2)
            {
               _loc8_ = _curLineItemCount - 1;
               while(_loc8_ < param1)
               {
                  _loc6_ = Number(_loc6_ + (_virtualItems[_loc8_].height + _lineGap));
                  _loc8_ = _loc8_ + _curLineItemCount;
               }
               _loc5_ = new Rectangle(0,_loc6_,_itemSize.x,_loc4_.height);
            }
            else if(_layout == 1 || _layout == 3)
            {
               _loc8_ = _curLineItemCount - 1;
               while(_loc8_ < param1)
               {
                  _loc6_ = Number(_loc6_ + (_virtualItems[_loc8_].width + _columnGap));
                  _loc8_ = _loc8_ + _curLineItemCount;
               }
               _loc5_ = new Rectangle(_loc6_,0,_loc4_.width,_itemSize.y);
            }
            else
            {
               _loc9_ = param1 / (_curLineItemCount * _curLineItemCount2);
               _loc5_ = new Rectangle(_loc9_ * viewWidth + param1 % _curLineItemCount * (_loc4_.width + _columnGap),param1 / _curLineItemCount % _curLineItemCount2 * (_loc4_.height + _lineGap),_loc4_.width,_loc4_.height);
            }
            if(this.itemProvider != null)
            {
               param3 = true;
            }
            if(_scrollPane != null)
            {
               _scrollPane.scrollToView(_loc5_,param2,param3);
            }
         }
         else
         {
            _loc7_ = getChildAt(param1);
            if(_scrollPane != null)
            {
               _scrollPane.scrollToView(_loc7_,param2,param3);
            }
            else if(parent != null && parent.scrollPane != null)
            {
               parent.scrollPane.scrollToView(_loc7_,param2,param3);
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
               param1 = param1 - _loc2_;
            }
            else
            {
               param1 = _numItems - _loc2_ + param1;
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
               _scrollPane.scrollStep = _itemSize.y;
               if(_loop)
               {
                  this._scrollPane._loop = 2;
               }
            }
            else
            {
               _scrollPane.scrollStep = _itemSize.x;
               if(_loop)
               {
                  this._scrollPane._loop = 1;
               }
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
         var _loc3_:int = 0;
         var _loc2_:* = null;
         var _loc4_:int = 0;
         if(_virtual)
         {
            if(itemRenderer == null)
            {
               throw new Error("FairyGUI: Set itemRenderer first!");
            }
            _numItems = param1;
            if(_loop)
            {
               _realNumItems = _numItems * 6;
            }
            else
            {
               _realNumItems = _numItems;
            }
            _loc3_ = _virtualItems.length;
            if(_realNumItems > _loc3_)
            {
               _loc5_ = _loc3_;
               while(_loc5_ < _realNumItems)
               {
                  _loc2_ = new ItemInfo();
                  _loc2_.width = _itemSize.x;
                  _loc2_.height = _itemSize.y;
                  _virtualItems.push(_loc2_);
                  _loc5_++;
               }
            }
            else
            {
               _loc5_ = int(_realNumItems);
               while(_loc5_ < _loc3_)
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
            _loc4_ = _children.length;
            if(param1 > _loc4_)
            {
               _loc5_ = _loc4_;
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
               removeChildrenToPool(param1,_loc4_);
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
         var _loc6_:int = 0;
         var _loc4_:int = 0;
         var _loc7_:int = 0;
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
         var _loc3_:* = 0;
         if(_realNumItems > 0)
         {
            _loc4_ = Math.ceil(_realNumItems / _curLineItemCount) * _curLineItemCount;
            _loc7_ = Math.min(_curLineItemCount,_realNumItems);
            if(_layout == 0 || _layout == 2)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc4_)
               {
                  _loc5_ = Number(_loc5_ + (_virtualItems[_loc6_].height + _lineGap));
                  _loc6_ = _loc6_ + _curLineItemCount;
               }
               if(_loc5_ > 0)
               {
                  _loc5_ = Number(_loc5_ - _lineGap);
               }
               if(_autoResizeItem)
               {
                  _loc3_ = Number(_scrollPane.viewWidth);
               }
               else
               {
                  _loc6_ = 0;
                  while(_loc6_ < _loc7_)
                  {
                     _loc3_ = Number(_loc3_ + (_virtualItems[_loc6_].width + _columnGap));
                     _loc6_++;
                  }
                  if(_loc3_ > 0)
                  {
                     _loc3_ = Number(_loc3_ - _columnGap);
                  }
               }
            }
            else if(_layout == 1 || _layout == 3)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc4_)
               {
                  _loc3_ = Number(_loc3_ + (_virtualItems[_loc6_].width + _columnGap));
                  _loc6_ = _loc6_ + _curLineItemCount;
               }
               if(_loc3_ > 0)
               {
                  _loc3_ = Number(_loc3_ - _columnGap);
               }
               if(_autoResizeItem)
               {
                  _loc5_ = Number(_scrollPane.viewHeight);
               }
               else
               {
                  _loc6_ = 0;
                  while(_loc6_ < _loc7_)
                  {
                     _loc5_ = Number(_loc5_ + (_virtualItems[_loc6_].height + _lineGap));
                     _loc6_++;
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
               _loc3_ = Number(_loc1_ * viewWidth);
               _loc5_ = Number(viewHeight);
            }
         }
         handleAlign(_loc3_,_loc5_);
         _scrollPane.setContentSize(_loc3_,_loc5_);
         _eventLocked = false;
         handleScroll(true);
      }
      
      private function __scrolled(param1:Event) : void
      {
         handleScroll(false);
      }
      
      private function getIndexOnPos1(param1:Boolean) : int
      {
         var _loc2_:int = 0;
         var _loc3_:* = NaN;
         var _loc4_:Number = NaN;
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
               _loc2_ = _firstIndex - _curLineItemCount;
               while(_loc2_ >= 0)
               {
                  _loc3_ = Number(_loc3_ - (_virtualItems[_loc2_].height + _lineGap));
                  if(_loc3_ <= pos_param)
                  {
                     pos_param = _loc3_;
                     return _loc2_;
                  }
                  _loc2_ = _loc2_ - _curLineItemCount;
               }
               pos_param = 0;
               return 0;
            }
            _loc2_ = _firstIndex;
            while(_loc2_ < _realNumItems)
            {
               _loc4_ = _loc3_ + _virtualItems[_loc2_].height + _lineGap;
               if(_loc4_ > pos_param)
               {
                  pos_param = _loc3_;
                  return _loc2_;
               }
               _loc3_ = _loc4_;
               _loc2_ = _loc2_ + _curLineItemCount;
            }
            pos_param = _loc3_;
            return _realNumItems - _curLineItemCount;
         }
         _loc3_ = 0;
         _loc2_ = 0;
         while(_loc2_ < _realNumItems)
         {
            _loc4_ = _loc3_ + _virtualItems[_loc2_].height + _lineGap;
            if(_loc4_ > pos_param)
            {
               pos_param = _loc3_;
               return _loc2_;
            }
            _loc3_ = _loc4_;
            _loc2_ = _loc2_ + _curLineItemCount;
         }
         pos_param = _loc3_;
         return _realNumItems - _curLineItemCount;
      }
      
      private function getIndexOnPos2(param1:Boolean) : int
      {
         var _loc2_:int = 0;
         var _loc3_:* = NaN;
         var _loc4_:Number = NaN;
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
               _loc2_ = _firstIndex - _curLineItemCount;
               while(_loc2_ >= 0)
               {
                  _loc3_ = Number(_loc3_ - (_virtualItems[_loc2_].width + _columnGap));
                  if(_loc3_ <= pos_param)
                  {
                     pos_param = _loc3_;
                     return _loc2_;
                  }
                  _loc2_ = _loc2_ - _curLineItemCount;
               }
               pos_param = 0;
               return 0;
            }
            _loc2_ = _firstIndex;
            while(_loc2_ < _realNumItems)
            {
               _loc4_ = _loc3_ + _virtualItems[_loc2_].width + _columnGap;
               if(_loc4_ > pos_param)
               {
                  pos_param = _loc3_;
                  return _loc2_;
               }
               _loc3_ = _loc4_;
               _loc2_ = _loc2_ + _curLineItemCount;
            }
            pos_param = _loc3_;
            return _realNumItems - _curLineItemCount;
         }
         _loc3_ = 0;
         _loc2_ = 0;
         while(_loc2_ < _realNumItems)
         {
            _loc4_ = _loc3_ + _virtualItems[_loc2_].width + _columnGap;
            if(_loc4_ > pos_param)
            {
               pos_param = _loc3_;
               return _loc2_;
            }
            _loc3_ = _loc4_;
            _loc2_ = _loc2_ + _curLineItemCount;
         }
         pos_param = _loc3_;
         return _realNumItems - _curLineItemCount;
      }
      
      private function getIndexOnPos3(param1:Boolean) : int
      {
         var _loc4_:int = 0;
         var _loc7_:Number = NaN;
         if(_realNumItems < _curLineItemCount)
         {
            pos_param = 0;
            return 0;
         }
         var _loc3_:Number = this.viewWidth;
         var _loc6_:int = Math.floor(pos_param / _loc3_);
         var _loc2_:int = _loc6_ * (_curLineItemCount * _curLineItemCount2);
         var _loc5_:* = Number(_loc6_ * _loc3_);
         _loc4_ = 0;
         while(_loc4_ < _curLineItemCount)
         {
            _loc7_ = _loc5_ + _virtualItems[_loc2_ + _loc4_].width + _columnGap;
            if(_loc7_ > pos_param)
            {
               pos_param = _loc5_;
               return _loc2_ + _loc4_;
            }
            _loc5_ = _loc7_;
            _loc4_++;
         }
         pos_param = _loc5_;
         return _loc2_ + _curLineItemCount - 1;
      }
      
      private function handleScroll(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         if(_eventLocked)
         {
            return;
         }
         if(_layout == 0 || _layout == 2)
         {
            _loc2_ = 0;
            while(handleScroll1(param1))
            {
               _loc2_++;
               param1 = false;
               if(_loc2_ > 20)
               {
                  trace("FairyGUI: list will never be filled as the item renderer function always returns a different size.");
                  break;
               }
            }
            handleArchOrder1();
         }
         else if(_layout == 1 || _layout == 3)
         {
            _loc2_ = 0;
            while(handleScroll2(param1))
            {
               _loc2_++;
               param1 = false;
               if(_loc2_ > 20)
               {
                  trace("FairyGUI: list will never be filled as the item renderer function always returns a different size.");
                  break;
               }
            }
            handleArchOrder2();
         }
         else
         {
            handleScroll3(param1);
         }
         _boundsChanged = false;
      }
      
      private function handleScroll1(param1:Boolean) : Boolean
      {
         var _loc7_:* = false;
         var _loc13_:* = null;
         var _loc2_:* = null;
         var _loc10_:* = 0;
         var _loc8_:int = 0;
         var _loc17_:* = null;
         var _loc15_:Number = _scrollPane.scrollingPosY;
         var _loc3_:Number = _loc15_ + _scrollPane.viewHeight;
         var _loc20_:* = _loc3_ == _scrollPane.contentHeight;
         GList.pos_param = _loc15_;
         var _loc18_:int = getIndexOnPos1(param1);
         _loc15_ = GList.pos_param;
         if(_loc18_ == _firstIndex && !param1)
         {
            return false;
         }
         var _loc12_:int = _firstIndex;
         _firstIndex = _loc18_;
         var _loc23_:* = _loc18_;
         var _loc5_:* = _loc12_ > _loc18_;
         var _loc9_:int = this.numChildren;
         var _loc22_:int = _loc12_ + _loc9_ - 1;
         var _loc4_:int = !!_loc5_?_loc22_:int(_loc12_);
         var _loc16_:* = 0;
         var _loc19_:* = _loc15_;
         var _loc21_:* = 0;
         var _loc14_:* = 0;
         var _loc11_:String = defaultItem;
         var _loc6_:int = (_scrollPane.viewWidth - _columnGap * (_curLineItemCount - 1)) / _curLineItemCount;
         itemInfoVer = Number(itemInfoVer) + 1;
         while(_loc23_ < _realNumItems && (_loc20_ || _loc19_ < _loc3_))
         {
            _loc2_ = _virtualItems[_loc23_];
            if(_loc2_.obj == null || param1)
            {
               if(itemProvider != null)
               {
                  _loc11_ = itemProvider(_loc23_ % _numItems);
                  if(_loc11_ == null)
                  {
                     _loc11_ = _defaultItem;
                  }
                  _loc11_ = UIPackage.normalizeURL(_loc11_);
               }
               if(_loc2_.obj != null && _loc2_.obj.resourceURL != _loc11_)
               {
                  if(_loc2_.obj is GButton)
                  {
                     _loc2_.selected = GButton(_loc2_.obj).selected;
                  }
                  removeChildToPool(_loc2_.obj);
                  _loc2_.obj = null;
               }
            }
            if(_loc2_.obj == null)
            {
               if(_loc5_)
               {
                  _loc10_ = _loc4_;
                  while(_loc10_ >= _loc12_)
                  {
                     _loc13_ = _virtualItems[_loc10_];
                     if(_loc13_.obj != null && _loc13_.updateFlag != itemInfoVer && _loc13_.obj.resourceURL == _loc11_)
                     {
                        if(_loc13_.obj is GButton)
                        {
                           _loc13_.selected = GButton(_loc13_.obj).selected;
                        }
                        _loc2_.obj = _loc13_.obj;
                        _loc13_.obj = null;
                        if(_loc10_ == _loc4_)
                        {
                           _loc4_--;
                        }
                        break;
                     }
                     _loc10_--;
                  }
               }
               else
               {
                  _loc10_ = _loc4_;
                  while(_loc10_ <= _loc22_)
                  {
                     _loc13_ = _virtualItems[_loc10_];
                     if(_loc13_.obj != null && _loc13_.updateFlag != itemInfoVer && _loc13_.obj.resourceURL == _loc11_)
                     {
                        if(_loc13_.obj is GButton)
                        {
                           _loc13_.selected = GButton(_loc13_.obj).selected;
                        }
                        _loc2_.obj = _loc13_.obj;
                        _loc13_.obj = null;
                        if(_loc10_ == _loc4_)
                        {
                           _loc4_++;
                        }
                        break;
                     }
                     _loc10_++;
                  }
               }
               if(_loc2_.obj != null)
               {
                  setChildIndex(_loc2_.obj,!!_loc5_?_loc23_ - _loc18_:numChildren);
               }
               else
               {
                  _loc2_.obj = _pool.getObject(_loc11_);
                  if(_loc5_)
                  {
                     this.addChildAt(_loc2_.obj,_loc23_ - _loc18_);
                  }
                  else
                  {
                     this.addChild(_loc2_.obj);
                  }
               }
               if(_loc2_.obj is GButton)
               {
                  GButton(_loc2_.obj).selected = _loc2_.selected;
               }
               _loc7_ = true;
            }
            else
            {
               _loc7_ = param1;
            }
            if(_loc7_)
            {
               if(_autoResizeItem && (_layout == 0 || _columnCount > 0))
               {
                  _loc2_.obj.setSize(_loc6_,_loc2_.obj.height,true);
               }
               itemRenderer(_loc23_ % _numItems,_loc2_.obj);
               if(_loc23_ % _curLineItemCount == 0)
               {
                  _loc21_ = Number(_loc21_ + (Math.ceil(_loc2_.obj.height) - _loc2_.height));
                  if(_loc23_ == _loc18_ && _loc12_ > _loc18_)
                  {
                     _loc14_ = Number(Math.ceil(_loc2_.obj.height) - _loc2_.height);
                  }
               }
               _loc2_.width = Math.ceil(_loc2_.obj.width);
               _loc2_.height = Math.ceil(_loc2_.obj.height);
            }
            _loc2_.updateFlag = itemInfoVer;
            _loc2_.obj.setXY(_loc16_,_loc19_);
            if(_loc23_ == _loc18_)
            {
               _loc3_ = _loc3_ + _loc2_.height;
            }
            _loc16_ = Number(_loc16_ + (_loc2_.width + _columnGap));
            if(_loc23_ % _curLineItemCount == _curLineItemCount - 1)
            {
               _loc16_ = 0;
               _loc19_ = Number(_loc19_ + (_loc2_.height + _lineGap));
            }
            _loc23_++;
         }
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc2_ = _virtualItems[_loc12_ + _loc8_];
            if(_loc2_.updateFlag != itemInfoVer && _loc2_.obj != null)
            {
               if(_loc2_.obj is GButton)
               {
                  _loc2_.selected = GButton(_loc2_.obj).selected;
               }
               removeChildToPool(_loc2_.obj);
               _loc2_.obj = null;
            }
            _loc8_++;
         }
         _loc9_ = _children.length;
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc17_ = _virtualItems[_loc18_ + _loc8_].obj;
            if(_children[_loc8_] != _loc17_)
            {
               setChildIndex(_loc17_,_loc8_);
            }
            _loc8_++;
         }
         if(_loc21_ != 0 || _loc14_ != 0)
         {
            _scrollPane.changeContentSizeOnScrolling(0,_loc21_,0,_loc14_);
         }
         if(_loc23_ > 0 && this.numChildren > 0 && _container.y <= 0 && getChildAt(0).y > -_container.y)
         {
            return true;
         }
         return false;
      }
      
      private function handleScroll2(param1:Boolean) : Boolean
      {
         var _loc7_:* = false;
         var _loc13_:* = null;
         var _loc2_:* = null;
         var _loc10_:* = 0;
         var _loc8_:int = 0;
         var _loc17_:* = null;
         var _loc15_:Number = _scrollPane.scrollingPosX;
         var _loc3_:Number = _loc15_ + _scrollPane.viewWidth;
         var _loc20_:* = _loc15_ == _scrollPane.contentWidth;
         GList.pos_param = _loc15_;
         var _loc18_:int = getIndexOnPos2(param1);
         _loc15_ = GList.pos_param;
         if(_loc18_ == _firstIndex && !param1)
         {
            return false;
         }
         var _loc12_:int = _firstIndex;
         _firstIndex = _loc18_;
         var _loc23_:* = _loc18_;
         var _loc5_:* = _loc12_ > _loc18_;
         var _loc9_:int = this.numChildren;
         var _loc22_:int = _loc12_ + _loc9_ - 1;
         var _loc4_:int = !!_loc5_?_loc22_:int(_loc12_);
         var _loc16_:* = _loc15_;
         var _loc19_:* = 0;
         var _loc21_:* = 0;
         var _loc14_:* = 0;
         var _loc11_:String = defaultItem;
         var _loc6_:int = (_scrollPane.viewHeight - _lineGap * (_curLineItemCount - 1)) / _curLineItemCount;
         itemInfoVer = Number(itemInfoVer) + 1;
         while(_loc23_ < _realNumItems && (_loc20_ || _loc16_ < _loc3_))
         {
            _loc2_ = _virtualItems[_loc23_];
            if(_loc2_.obj == null || param1)
            {
               if(itemProvider != null)
               {
                  _loc11_ = itemProvider(_loc23_ % _numItems);
                  if(_loc11_ == null)
                  {
                     _loc11_ = _defaultItem;
                  }
                  _loc11_ = UIPackage.normalizeURL(_loc11_);
               }
               if(_loc2_.obj != null && _loc2_.obj.resourceURL != _loc11_)
               {
                  if(_loc2_.obj is GButton)
                  {
                     _loc2_.selected = GButton(_loc2_.obj).selected;
                  }
                  removeChildToPool(_loc2_.obj);
                  _loc2_.obj = null;
               }
            }
            if(_loc2_.obj == null)
            {
               if(_loc5_)
               {
                  _loc10_ = _loc4_;
                  while(_loc10_ >= _loc12_)
                  {
                     _loc13_ = _virtualItems[_loc10_];
                     if(_loc13_.obj != null && _loc13_.updateFlag != itemInfoVer && _loc13_.obj.resourceURL == _loc11_)
                     {
                        if(_loc13_.obj is GButton)
                        {
                           _loc13_.selected = GButton(_loc13_.obj).selected;
                        }
                        _loc2_.obj = _loc13_.obj;
                        _loc13_.obj = null;
                        if(_loc10_ == _loc4_)
                        {
                           _loc4_--;
                        }
                        break;
                     }
                     _loc10_--;
                  }
               }
               else
               {
                  _loc10_ = _loc4_;
                  while(_loc10_ <= _loc22_)
                  {
                     _loc13_ = _virtualItems[_loc10_];
                     if(_loc13_.obj != null && _loc13_.updateFlag != itemInfoVer && _loc13_.obj.resourceURL == _loc11_)
                     {
                        if(_loc13_.obj is GButton)
                        {
                           _loc13_.selected = GButton(_loc13_.obj).selected;
                        }
                        _loc2_.obj = _loc13_.obj;
                        _loc13_.obj = null;
                        if(_loc10_ == _loc4_)
                        {
                           _loc4_++;
                        }
                        break;
                     }
                     _loc10_++;
                  }
               }
               if(_loc2_.obj != null)
               {
                  setChildIndex(_loc2_.obj,!!_loc5_?_loc23_ - _loc18_:numChildren);
               }
               else
               {
                  _loc2_.obj = _pool.getObject(_loc11_);
                  if(_loc5_)
                  {
                     this.addChildAt(_loc2_.obj,_loc23_ - _loc18_);
                  }
                  else
                  {
                     this.addChild(_loc2_.obj);
                  }
               }
               if(_loc2_.obj is GButton)
               {
                  GButton(_loc2_.obj).selected = _loc2_.selected;
               }
               _loc7_ = true;
            }
            else
            {
               _loc7_ = param1;
            }
            if(_loc7_)
            {
               if(_autoResizeItem && (_layout == 1 || _lineCount > 0))
               {
                  _loc2_.obj.setSize(_loc2_.obj.width,_loc6_,true);
               }
               itemRenderer(_loc23_ % _numItems,_loc2_.obj);
               if(_loc23_ % _curLineItemCount == 0)
               {
                  _loc21_ = Number(_loc21_ + (Math.ceil(_loc2_.obj.width) - _loc2_.width));
                  if(_loc23_ == _loc18_ && _loc12_ > _loc18_)
                  {
                     _loc14_ = Number(Math.ceil(_loc2_.obj.width) - _loc2_.width);
                  }
               }
               _loc2_.width = Math.ceil(_loc2_.obj.width);
               _loc2_.height = Math.ceil(_loc2_.obj.height);
            }
            _loc2_.updateFlag = itemInfoVer;
            _loc2_.obj.setXY(_loc16_,_loc19_);
            if(_loc23_ == _loc18_)
            {
               _loc3_ = _loc3_ + _loc2_.width;
            }
            _loc19_ = Number(_loc19_ + (_loc2_.height + _lineGap));
            if(_loc23_ % _curLineItemCount == _curLineItemCount - 1)
            {
               _loc19_ = 0;
               _loc16_ = Number(_loc16_ + (_loc2_.width + _columnGap));
            }
            _loc23_++;
         }
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc2_ = _virtualItems[_loc12_ + _loc8_];
            if(_loc2_.updateFlag != itemInfoVer && _loc2_.obj != null)
            {
               if(_loc2_.obj is GButton)
               {
                  _loc2_.selected = GButton(_loc2_.obj).selected;
               }
               removeChildToPool(_loc2_.obj);
               _loc2_.obj = null;
            }
            _loc8_++;
         }
         _loc9_ = _children.length;
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc17_ = _virtualItems[_loc18_ + _loc8_].obj;
            if(_children[_loc8_] != _loc17_)
            {
               setChildIndex(_loc17_,_loc8_);
            }
            _loc8_++;
         }
         if(_loc21_ != 0 || _loc14_ != 0)
         {
            _scrollPane.changeContentSizeOnScrolling(_loc21_,0,_loc14_,0);
         }
         if(_loc23_ > 0 && this.numChildren > 0 && _container.x <= 0 && getChildAt(0).x > -_container.x)
         {
            return true;
         }
         return false;
      }
      
      private function handleScroll3(param1:Boolean) : void
      {
         var _loc6_:* = false;
         var _loc18_:* = 0;
         var _loc10_:* = null;
         var _loc13_:* = null;
         var _loc3_:int = 0;
         var _loc11_:Number = _scrollPane.scrollingPosX;
         GList.pos_param = _loc11_;
         var _loc22_:int = getIndexOnPos3(param1);
         _loc11_ = GList.pos_param;
         if(_loc22_ == _firstIndex && !param1)
         {
            return;
         }
         var _loc9_:int = _firstIndex;
         _firstIndex = _loc22_;
         var _loc15_:* = _loc9_;
         var _loc5_:int = _virtualItems.length;
         var _loc7_:int = _curLineItemCount * _curLineItemCount2;
         var _loc4_:int = _loc22_ % _curLineItemCount;
         var _loc17_:Number = this.viewWidth;
         var _loc25_:int = _loc22_ / _loc7_;
         var _loc8_:int = _loc25_ * _loc7_;
         var _loc12_:int = _loc8_ + _loc7_ * 2;
         var _loc19_:String = _defaultItem;
         var _loc16_:int = (_scrollPane.viewWidth - _columnGap * (_curLineItemCount - 1)) / _curLineItemCount;
         var _loc26_:int = (_scrollPane.viewHeight - _lineGap * (_curLineItemCount2 - 1)) / _curLineItemCount2;
         itemInfoVer = Number(itemInfoVer) + 1;
         _loc18_ = _loc8_;
         while(_loc18_ < _loc12_)
         {
            if(_loc18_ < _realNumItems)
            {
               _loc3_ = _loc18_ % _curLineItemCount;
               if(_loc18_ - _loc8_ < _loc7_)
               {
                  if(_loc3_ >= _loc4_)
                  {
                     addr137:
                     _loc13_ = _virtualItems[_loc18_];
                     _loc13_.updateFlag = itemInfoVer;
                  }
               }
               else if(_loc3_ <= _loc4_)
               {
                  §§goto(addr137);
               }
            }
            _loc18_++;
         }
         var _loc21_:GObject = null;
         var _loc23_:int = 0;
         _loc18_ = _loc8_;
         while(_loc18_ < _loc12_)
         {
            if(_loc18_ < _realNumItems)
            {
               _loc13_ = _virtualItems[_loc18_];
               if(_loc13_.updateFlag == itemInfoVer)
               {
                  if(_loc13_.obj == null)
                  {
                     while(_loc15_ < _loc5_)
                     {
                        _loc10_ = _virtualItems[_loc15_];
                        if(_loc10_.obj != null && _loc10_.updateFlag != itemInfoVer)
                        {
                           if(_loc10_.obj is GButton)
                           {
                              _loc10_.selected = GButton(_loc10_.obj).selected;
                           }
                           _loc13_.obj = _loc10_.obj;
                           _loc10_.obj = null;
                           break;
                        }
                        _loc15_++;
                     }
                     if(_loc23_ == -1)
                     {
                        _loc23_ = getChildIndex(_loc21_) + 1;
                     }
                     if(_loc13_.obj == null)
                     {
                        if(itemProvider != null)
                        {
                           _loc19_ = itemProvider(_loc18_ % _numItems);
                           if(_loc19_ == null)
                           {
                              _loc19_ = _defaultItem;
                           }
                           _loc19_ = UIPackage.normalizeURL(_loc19_);
                        }
                        _loc13_.obj = _pool.getObject(_loc19_);
                        this.addChildAt(_loc13_.obj,_loc23_);
                     }
                     else
                     {
                        _loc23_ = setChildIndexBefore(_loc13_.obj,_loc23_);
                     }
                     _loc23_++;
                     if(_loc13_.obj is GButton)
                     {
                        GButton(_loc13_.obj).selected = _loc13_.selected;
                     }
                     _loc6_ = true;
                  }
                  else
                  {
                     _loc6_ = param1;
                     _loc23_ = -1;
                     _loc21_ = _loc13_.obj;
                  }
                  if(_loc6_)
                  {
                     if(_autoResizeItem)
                     {
                        if(_curLineItemCount == _columnCount && _curLineItemCount2 == _lineCount)
                        {
                           _loc13_.obj.setSize(_loc16_,_loc26_,true);
                        }
                        else if(_curLineItemCount == _columnCount)
                        {
                           _loc13_.obj.setSize(_loc16_,_loc13_.obj.height,true);
                        }
                        else if(_curLineItemCount2 == _lineCount)
                        {
                           _loc13_.obj.setSize(_loc13_.obj.width,_loc26_,true);
                        }
                     }
                     itemRenderer(_loc18_ % _numItems,_loc13_.obj);
                     _loc13_.width = Math.ceil(_loc13_.obj.width);
                     _loc13_.height = Math.ceil(_loc13_.obj.height);
                  }
               }
            }
            _loc18_++;
         }
         var _loc20_:int = _loc8_ / _loc7_ * _loc17_;
         var _loc2_:* = _loc20_;
         var _loc14_:int = 0;
         var _loc24_:int = 0;
         _loc18_ = _loc8_;
         while(_loc18_ < _loc12_)
         {
            if(_loc18_ < _realNumItems)
            {
               _loc13_ = _virtualItems[_loc18_];
               if(_loc13_.updateFlag == itemInfoVer)
               {
                  _loc13_.obj.setXY(_loc2_,_loc14_);
               }
               if(_loc13_.height > _loc24_)
               {
                  _loc24_ = _loc13_.height;
               }
               if(_loc18_ % _curLineItemCount == _curLineItemCount - 1)
               {
                  _loc2_ = _loc20_;
                  _loc14_ = _loc14_ + (_loc24_ + _lineGap);
                  _loc24_ = 0;
                  if(_loc18_ == _loc8_ + _loc7_ - 1)
                  {
                     _loc20_ = _loc20_ + _loc17_;
                     _loc2_ = _loc20_;
                     _loc14_ = 0;
                  }
               }
               else
               {
                  _loc2_ = int(_loc2_ + (_loc13_.width + _columnGap));
               }
            }
            _loc18_++;
         }
         _loc18_ = _loc15_;
         while(_loc18_ < _loc5_)
         {
            _loc13_ = _virtualItems[_loc18_];
            if(_loc13_.updateFlag != itemInfoVer && _loc13_.obj != null)
            {
               if(_loc13_.obj is GButton)
               {
                  _loc13_.selected = GButton(_loc13_.obj).selected;
               }
               removeChildToPool(_loc13_.obj);
               _loc13_.obj = null;
            }
            _loc18_++;
         }
      }
      
      private function handleArchOrder1() : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc7_:* = NaN;
         var _loc1_:* = 0;
         var _loc3_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:* = null;
         if(this.childrenRenderOrder == 2)
         {
            _loc4_ = _scrollPane.posY + this.viewHeight / 2;
            _loc7_ = 2147483647;
            _loc1_ = 0;
            _loc3_ = this.numChildren;
            _loc6_ = 0;
            while(_loc6_ < _loc3_)
            {
               _loc2_ = getChildAt(_loc6_);
               if(!foldInvisibleItems || _loc2_.visible)
               {
                  _loc5_ = Math.abs(_loc4_ - _loc2_.y - _loc2_.height / 2);
                  if(_loc5_ < _loc7_)
                  {
                     _loc7_ = _loc5_;
                     _loc1_ = _loc6_;
                  }
               }
               _loc6_++;
            }
            this.apexIndex = _loc1_;
         }
      }
      
      private function handleArchOrder2() : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc7_:* = NaN;
         var _loc1_:* = 0;
         var _loc3_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:* = null;
         if(this.childrenRenderOrder == 2)
         {
            _loc4_ = _scrollPane.posX + this.viewWidth / 2;
            _loc7_ = 2147483647;
            _loc1_ = 0;
            _loc3_ = this.numChildren;
            _loc6_ = 0;
            while(_loc6_ < _loc3_)
            {
               _loc2_ = getChildAt(_loc6_);
               if(!foldInvisibleItems || _loc2_.visible)
               {
                  _loc5_ = Math.abs(_loc4_ - _loc2_.x - _loc2_.width / 2);
                  if(_loc5_ < _loc7_)
                  {
                     _loc7_ = _loc5_;
                     _loc1_ = _loc6_;
                  }
               }
               _loc6_++;
            }
            this.apexIndex = _loc1_;
         }
      }
      
      private function handleAlign(param1:Number, param2:Number) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         if(param2 < viewHeight)
         {
            if(_verticalAlign == 1)
            {
               _loc4_ = Number(int((viewHeight - param2) / 2));
            }
            else if(_verticalAlign == 2)
            {
               _loc4_ = Number(viewHeight - param2);
            }
         }
         if(param1 < this.viewWidth)
         {
            if(_align == 1)
            {
               _loc3_ = Number(int((viewWidth - param1) / 2));
            }
            else if(_align == 2)
            {
               _loc3_ = Number(viewWidth - param1);
            }
         }
         if(_loc3_ != _alignOffset.x || _loc4_ != _alignOffset.y)
         {
            _alignOffset.setTo(_loc3_,_loc4_);
            if(_scrollPane != null)
            {
               _scrollPane.adjustMaskContainer();
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
         var _loc5_:int = 0;
         var _loc16_:* = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc17_:* = 0;
         var _loc12_:* = 0;
         var _loc1_:* = 0;
         var _loc11_:* = 0;
         var _loc18_:Number = NaN;
         var _loc7_:int = 0;
         if(_virtual)
         {
            return;
         }
         var _loc8_:* = 0;
         var _loc15_:int = 0;
         var _loc9_:int = 0;
         var _loc4_:int = _children.length;
         var _loc2_:Number = this.viewWidth;
         var _loc6_:Number = this.viewHeight;
         var _loc10_:* = 0;
         var _loc3_:int = 0;
         if(_layout == 0)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc16_ = getChildAt(_loc5_);
               if(!(foldInvisibleItems && !_loc16_.visible))
               {
                  if(_loc14_ != 0)
                  {
                     _loc14_ = _loc14_ + _lineGap;
                  }
                  _loc16_.y = _loc14_;
                  if(_autoResizeItem)
                  {
                     _loc16_.setSize(_loc2_,_loc16_.height,true);
                  }
                  _loc14_ = _loc14_ + Math.ceil(_loc16_.height);
                  if(_loc16_.width > _loc17_)
                  {
                     _loc17_ = int(_loc16_.width);
                  }
               }
               _loc5_++;
            }
            _loc1_ = _loc14_;
            if(_loc1_ <= _loc6_ && _autoResizeItem && _scrollPane && _scrollPane._displayInDemand && _scrollPane.vtScrollBar)
            {
               _loc2_ = _loc2_ + _scrollPane.vtScrollBar.width;
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  _loc16_ = getChildAt(_loc5_);
                  if(!(foldInvisibleItems && !_loc16_.visible))
                  {
                     _loc16_.setSize(_loc2_,_loc16_.height,true);
                     if(_loc16_.width > _loc17_)
                     {
                        _loc17_ = int(_loc16_.width);
                     }
                  }
                  _loc5_++;
               }
            }
            _loc11_ = int(Math.ceil(_loc17_));
         }
         else if(_layout == 1)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc16_ = getChildAt(_loc5_);
               if(!(foldInvisibleItems && !_loc16_.visible))
               {
                  if(_loc13_ != 0)
                  {
                     _loc13_ = _loc13_ + _columnGap;
                  }
                  _loc16_.x = _loc13_;
                  if(_autoResizeItem)
                  {
                     _loc16_.setSize(_loc16_.width,_loc6_,true);
                  }
                  _loc13_ = _loc13_ + Math.ceil(_loc16_.width);
                  if(_loc16_.height > _loc12_)
                  {
                     _loc12_ = int(_loc16_.height);
                  }
               }
               _loc5_++;
            }
            _loc11_ = _loc13_;
            if(_loc11_ <= _loc2_ && _autoResizeItem && _scrollPane && _scrollPane._displayInDemand && _scrollPane.hzScrollBar)
            {
               _loc6_ = _loc6_ + _scrollPane.hzScrollBar.height;
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  _loc16_ = getChildAt(_loc5_);
                  if(!(foldInvisibleItems && !_loc16_.visible))
                  {
                     _loc16_.setSize(_loc16_.width,_loc6_,true);
                     if(_loc16_.height > _loc12_)
                     {
                        _loc12_ = int(_loc16_.height);
                     }
                  }
                  _loc5_++;
               }
            }
            _loc1_ = int(Math.ceil(_loc12_));
         }
         else if(_layout == 2)
         {
            if(_autoResizeItem && _columnCount > 0)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  _loc16_ = getChildAt(_loc5_);
                  if(!(foldInvisibleItems && !_loc16_.visible))
                  {
                     _loc10_ = Number(_loc10_ + _loc16_.sourceWidth);
                     _loc8_++;
                     if(_loc8_ == _columnCount || _loc5_ == _loc4_ - 1)
                     {
                        _loc18_ = (_loc2_ - _loc10_ - (_loc8_ - 1) * _columnGap) / _loc10_;
                        _loc13_ = 0;
                        _loc8_ = _loc3_;
                        while(_loc8_ <= _loc5_)
                        {
                           _loc16_ = getChildAt(_loc8_);
                           if(!(foldInvisibleItems && !_loc16_.visible))
                           {
                              _loc16_.setXY(_loc13_,_loc14_);
                              if(_loc8_ < _loc5_)
                              {
                                 _loc16_.setSize(_loc16_.sourceWidth + Math.round(_loc16_.sourceWidth * _loc18_),_loc16_.height,true);
                                 _loc13_ = _loc13_ + (Math.ceil(_loc16_.width) + _columnGap);
                              }
                              else
                              {
                                 _loc16_.setSize(_loc2_ - _loc13_,_loc16_.height,true);
                              }
                              if(_loc16_.height > _loc12_)
                              {
                                 _loc12_ = int(_loc16_.height);
                              }
                           }
                           _loc8_++;
                        }
                        _loc14_ = _loc14_ + (Math.ceil(_loc12_) + _lineGap);
                        _loc12_ = 0;
                        _loc8_ = 0;
                        _loc3_ = _loc5_ + 1;
                        _loc10_ = 0;
                     }
                  }
                  _loc5_++;
               }
               _loc1_ = int(_loc14_ + Math.ceil(_loc12_));
               _loc11_ = int(_loc2_);
            }
            else
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  _loc16_ = getChildAt(_loc5_);
                  if(!(foldInvisibleItems && !_loc16_.visible))
                  {
                     if(_loc13_ != 0)
                     {
                        _loc13_ = _loc13_ + _columnGap;
                     }
                     if(_columnCount != 0 && _loc8_ >= _columnCount || _columnCount == 0 && _loc13_ + _loc16_.width > _loc2_ && _loc12_ != 0)
                     {
                        _loc13_ = 0;
                        _loc14_ = _loc14_ + (Math.ceil(_loc12_) + _lineGap);
                        _loc12_ = 0;
                        _loc8_ = 0;
                     }
                     _loc16_.setXY(_loc13_,_loc14_);
                     _loc13_ = _loc13_ + Math.ceil(_loc16_.width);
                     if(_loc13_ > _loc17_)
                     {
                        _loc17_ = _loc13_;
                     }
                     if(_loc16_.height > _loc12_)
                     {
                        _loc12_ = int(_loc16_.height);
                     }
                     _loc8_++;
                  }
                  _loc5_++;
               }
               _loc1_ = int(_loc14_ + Math.ceil(_loc12_));
               _loc11_ = int(Math.ceil(_loc17_));
            }
         }
         else if(_layout == 3)
         {
            if(_autoResizeItem && _lineCount > 0)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  _loc16_ = getChildAt(_loc5_);
                  if(!(foldInvisibleItems && !_loc16_.visible))
                  {
                     _loc10_ = Number(_loc10_ + _loc16_.sourceHeight);
                     _loc8_++;
                     if(_loc8_ == _lineCount || _loc5_ == _loc4_ - 1)
                     {
                        _loc18_ = (_loc6_ - _loc10_ - (_loc8_ - 1) * _lineGap) / _loc10_;
                        _loc14_ = 0;
                        _loc8_ = _loc3_;
                        while(_loc8_ <= _loc5_)
                        {
                           _loc16_ = getChildAt(_loc8_);
                           if(!(foldInvisibleItems && !_loc16_.visible))
                           {
                              _loc16_.setXY(_loc13_,_loc14_);
                              if(_loc8_ < _loc5_)
                              {
                                 _loc16_.setSize(_loc16_.width,_loc16_.sourceHeight + Math.round(_loc16_.sourceHeight * _loc18_),true);
                                 _loc14_ = _loc14_ + (Math.ceil(_loc16_.height) + _lineGap);
                              }
                              else
                              {
                                 _loc16_.setSize(_loc16_.width,_loc6_ - _loc14_,true);
                              }
                              if(_loc16_.width > _loc17_)
                              {
                                 _loc17_ = int(_loc16_.width);
                              }
                           }
                           _loc8_++;
                        }
                        _loc13_ = _loc13_ + (Math.ceil(_loc17_) + _columnGap);
                        _loc17_ = 0;
                        _loc8_ = 0;
                        _loc3_ = _loc5_ + 1;
                        _loc10_ = 0;
                     }
                  }
                  _loc5_++;
               }
               _loc11_ = int(_loc13_ + Math.ceil(_loc17_));
               _loc1_ = int(_loc6_);
            }
            else
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  _loc16_ = getChildAt(_loc5_);
                  if(!(foldInvisibleItems && !_loc16_.visible))
                  {
                     if(_loc14_ != 0)
                     {
                        _loc14_ = _loc14_ + _lineGap;
                     }
                     if(_lineCount != 0 && _loc8_ >= _lineCount || _lineCount == 0 && _loc14_ + _loc16_.height > _loc6_ && _loc17_ != 0)
                     {
                        _loc14_ = 0;
                        _loc13_ = _loc13_ + (Math.ceil(_loc17_) + _columnGap);
                        _loc17_ = 0;
                        _loc8_ = 0;
                     }
                     _loc16_.setXY(_loc13_,_loc14_);
                     _loc14_ = _loc14_ + Math.ceil(_loc16_.height);
                     if(_loc14_ > _loc12_)
                     {
                        _loc12_ = _loc14_;
                     }
                     if(_loc16_.width > _loc17_)
                     {
                        _loc17_ = int(_loc16_.width);
                     }
                     _loc8_++;
                  }
                  _loc5_++;
               }
               _loc11_ = int(_loc13_ + Math.ceil(_loc17_));
               _loc1_ = int(Math.ceil(_loc12_));
            }
         }
         else
         {
            if(_autoResizeItem && _lineCount > 0)
            {
               _loc7_ = Math.floor((_loc6_ - (_lineCount - 1) * _lineGap) / _lineCount);
            }
            if(_autoResizeItem && _columnCount > 0)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  _loc16_ = getChildAt(_loc5_);
                  if(!(foldInvisibleItems && !_loc16_.visible))
                  {
                     if(_loc8_ == 0 && (_lineCount != 0 && _loc9_ >= _lineCount || _lineCount == 0 && _loc14_ + _loc16_.height > _loc6_))
                     {
                        _loc15_++;
                        _loc14_ = 0;
                        _loc9_ = 0;
                     }
                     _loc10_ = Number(_loc10_ + _loc16_.sourceWidth);
                     _loc8_++;
                     if(_loc8_ == _columnCount || _loc5_ == _loc4_ - 1)
                     {
                        _loc18_ = (_loc2_ - _loc10_ - (_loc8_ - 1) * _columnGap) / _loc10_;
                        _loc13_ = 0;
                        _loc8_ = _loc3_;
                        while(_loc8_ <= _loc5_)
                        {
                           _loc16_ = getChildAt(_loc8_);
                           if(!(foldInvisibleItems && !_loc16_.visible))
                           {
                              _loc16_.setXY(_loc15_ * _loc2_ + _loc13_,_loc14_);
                              if(_loc8_ < _loc5_)
                              {
                                 _loc16_.setSize(_loc16_.sourceWidth + Math.round(_loc16_.sourceWidth * _loc18_),_lineCount > 0?_loc7_:_loc16_.height,true);
                                 _loc13_ = _loc13_ + (Math.ceil(_loc16_.width) + _columnGap);
                              }
                              else
                              {
                                 _loc16_.setSize(_loc2_ - _loc13_,_lineCount > 0?_loc7_:_loc16_.height,true);
                              }
                              if(_loc16_.height > _loc12_)
                              {
                                 _loc12_ = int(_loc16_.height);
                              }
                           }
                           _loc8_++;
                        }
                        _loc14_ = _loc14_ + (Math.ceil(_loc12_) + _lineGap);
                        _loc12_ = 0;
                        _loc8_ = 0;
                        _loc3_ = _loc5_ + 1;
                        _loc10_ = 0;
                        _loc9_++;
                     }
                  }
                  _loc5_++;
               }
            }
            else
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  _loc16_ = getChildAt(_loc5_);
                  if(!(foldInvisibleItems && !_loc16_.visible))
                  {
                     if(_loc13_ != 0)
                     {
                        _loc13_ = _loc13_ + _columnGap;
                     }
                     if(_autoResizeItem && _lineCount > 0)
                     {
                        _loc16_.setSize(_loc16_.width,_loc7_,true);
                     }
                     if(_columnCount != 0 && _loc8_ >= _columnCount || _columnCount == 0 && _loc13_ + _loc16_.width > _loc2_ && _loc12_ != 0)
                     {
                        _loc13_ = 0;
                        _loc14_ = _loc14_ + (Math.ceil(_loc12_) + _lineGap);
                        _loc12_ = 0;
                        _loc8_ = 0;
                        _loc9_++;
                        if(_lineCount != 0 && _loc9_ >= _lineCount || _lineCount == 0 && _loc14_ + _loc16_.height > _loc6_ && _loc17_ != 0)
                        {
                           _loc15_++;
                           _loc14_ = 0;
                           _loc9_ = 0;
                        }
                     }
                     _loc16_.setXY(_loc15_ * _loc2_ + _loc13_,_loc14_);
                     _loc13_ = _loc13_ + Math.ceil(_loc16_.width);
                     if(_loc13_ > _loc17_)
                     {
                        _loc17_ = _loc13_;
                     }
                     if(_loc16_.height > _loc12_)
                     {
                        _loc12_ = int(_loc16_.height);
                     }
                     _loc8_++;
                  }
                  _loc5_++;
               }
            }
            _loc1_ = int(_loc15_ > 0?_loc6_:Number(_loc14_ + Math.ceil(_loc12_)));
            _loc11_ = int((_loc15_ + 1) * _loc2_);
         }
         handleAlign(_loc11_,_loc1_);
         setBounds(0,0,_loc11_,_loc1_);
      }
      
      override public function setup_beforeAdd(param1:XML) : void
      {
         var _loc2_:* = null;
         var _loc4_:int = 0;
         var _loc7_:int = 0;
         var _loc11_:int = 0;
         var _loc9_:int = 0;
         var _loc12_:* = null;
         var _loc6_:* = null;
         var _loc10_:* = null;
         var _loc3_:* = null;
         var _loc8_:* = null;
         var _loc5_:* = null;
         super.setup_beforeAdd(param1);
         _loc2_ = param1.@layout;
         if(_loc2_)
         {
            _layout = ListLayoutType.parse(_loc2_);
         }
         _loc2_ = param1.@overflow;
         if(_loc2_)
         {
            _loc4_ = OverflowType.parse(_loc2_);
         }
         else
         {
            _loc4_ = 0;
         }
         _loc2_ = param1.@margin;
         if(_loc2_)
         {
            _margin.parse(_loc2_);
         }
         _loc2_ = param1.@align;
         if(_loc2_)
         {
            _align = AlignType.parse(_loc2_);
         }
         _loc2_ = param1.@vAlign;
         if(_loc2_)
         {
            _verticalAlign = VertAlignType.parse(_loc2_);
         }
         if(_loc4_ == 2)
         {
            _loc2_ = param1.@scroll;
            if(_loc2_)
            {
               _loc7_ = ScrollType.parse(_loc2_);
            }
            else
            {
               _loc7_ = 1;
            }
            _loc2_ = param1.@scrollBar;
            if(_loc2_)
            {
               _loc11_ = ScrollBarDisplayType.parse(_loc2_);
            }
            else
            {
               _loc11_ = 0;
            }
            _loc9_ = parseInt(param1.@scrollBarFlags);
            _loc12_ = new Margin();
            _loc2_ = param1.@scrollBarMargin;
            if(_loc2_)
            {
               _loc12_.parse(_loc2_);
            }
            _loc2_ = param1.@scrollBarRes;
            if(_loc2_)
            {
               _loc3_ = _loc2_.split(",");
               _loc6_ = _loc3_[0];
               _loc10_ = _loc3_[1];
            }
            _loc2_ = param1.@ptrRes;
            if(_loc2_)
            {
               _loc3_ = _loc2_.split(",");
               _loc8_ = _loc3_[0];
               _loc5_ = _loc3_[1];
            }
            setupScroll(_loc12_,_loc7_,_loc11_,_loc9_,_loc6_,_loc10_,_loc8_,_loc5_);
         }
         else
         {
            setupOverflow(_loc4_);
         }
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
         _loc2_ = param1.@lineItemCount;
         if(_loc2_)
         {
            if(_layout == 2 || _layout == 4)
            {
               _columnCount = parseInt(_loc2_);
            }
            else if(_layout == 3)
            {
               _lineCount = parseInt(_loc2_);
            }
         }
         _loc2_ = param1.@lineItemCount2;
         if(_loc2_)
         {
            _lineCount = parseInt(_loc2_);
         }
         _loc2_ = param1.@selectionMode;
         if(_loc2_)
         {
            _selectionMode = ListSelectionMode.parse(_loc2_);
         }
         _loc2_ = param1.@defaultItem;
         if(_loc2_)
         {
            _defaultItem = _loc2_;
         }
         _loc2_ = param1.@autoItemSize;
         if(_layout == 1 || _layout == 0)
         {
            _autoResizeItem = _loc2_ != "false";
         }
         else
         {
            _autoResizeItem = _loc2_ == "true";
         }
         _loc2_ = param1.@renderOrder;
         if(_loc2_)
         {
            _childrenRenderOrder = ChildrenRenderOrder.parse(_loc2_);
            if(_childrenRenderOrder == 2)
            {
               _loc2_ = param1.@apex;
               if(_loc2_)
               {
                  _apexIndex = parseInt(_loc2_);
               }
            }
         }
         _loc2_ = param1.@scrollItemToViewOnClick;
         if(_loc2_)
         {
            scrollItemToViewOnClick = _loc2_ == "true";
         }
         _loc2_ = param1.@foldInvisibleItems;
         if(_loc2_)
         {
            foldInvisibleItems = _loc2_ == "true";
         }
         readItems(param1);
      }
      
      protected function readItems(param1:XML) : void
      {
         var _loc2_:* = null;
         var _loc6_:* = null;
         var _loc4_:* = null;
         var _loc3_:XMLList = param1.item;
         var _loc8_:int = 0;
         var _loc7_:* = _loc3_;
         for each(var _loc5_ in _loc3_)
         {
            _loc6_ = _loc5_.@url;
            if(!_loc6_)
            {
               _loc6_ = _defaultItem;
            }
            if(_loc6_)
            {
               _loc4_ = getFromPool(_loc6_);
               if(_loc4_ != null)
               {
                  addChild(_loc4_);
                  setupItem(_loc5_,_loc4_);
               }
            }
         }
      }
      
      protected function setupItem(param1:XML, param2:GObject) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc8_:int = 0;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc12_:* = null;
         var _loc10_:int = 0;
         var _loc11_:* = null;
         var _loc7_:* = null;
         _loc3_ = param1.@title;
         if(_loc3_)
         {
            param2.text = _loc3_;
         }
         _loc3_ = param1.@icon;
         if(_loc3_)
         {
            param2.icon = _loc3_;
         }
         _loc3_ = param1.@name;
         if(_loc3_)
         {
            param2.name = _loc3_;
         }
         _loc3_ = param1.@selectedIcon;
         if(_loc3_ && param2 is GButton)
         {
            GButton(param2).selectedIcon = _loc3_;
         }
         _loc3_ = param1.@selectedTitle;
         if(_loc3_ && param2 is GButton)
         {
            GButton(param2).selectedTitle = _loc3_;
         }
         if(param2 is GComponent)
         {
            _loc3_ = param1.@controllers;
            if(_loc3_)
            {
               _loc4_ = _loc3_.split(",");
               _loc8_ = 0;
               while(_loc8_ < _loc4_.length)
               {
                  _loc5_ = GComponent(param2).getController(_loc4_[_loc8_]);
                  if(_loc5_ != null)
                  {
                     _loc5_.selectedPageId = _loc4_[_loc8_ + 1];
                  }
                  _loc8_ = _loc8_ + 2;
               }
            }
            _loc6_ = param1.property;
            var _loc14_:int = 0;
            var _loc13_:* = _loc6_;
            for each(var _loc9_ in _loc6_)
            {
               _loc12_ = _loc9_.@target;
               _loc10_ = parseInt(_loc9_.@propertyId);
               _loc11_ = _loc9_.@value;
               _loc7_ = GComponent(param2).getChildByPath(_loc12_);
               if(_loc7_)
               {
                  _loc7_.setProp(_loc10_,_loc11_);
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
