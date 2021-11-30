package fairygui
{
   import fairygui.event.GTouchEvent;
   import fairygui.tween.GTween;
   import fairygui.tween.GTweener;
   import fairygui.utils.GTimers;
   import fairygui.utils.ToolSet;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.ui.Mouse;
   import flash.utils.getTimer;
   
   public class ScrollPane extends EventDispatcher
   {
      
      public static var draggingPane:ScrollPane;
      
      private static var _gestureFlag:int = 0;
      
      private static var sHelperPoint:Point = new Point();
      
      private static var sHelperRect:Rectangle = new Rectangle();
      
      private static var sEndPos:Point = new Point();
      
      private static var sOldChange:Point = new Point();
      
      public static const SCROLL_END:String = "scrollEnd";
      
      public static const PULL_DOWN_RELEASE:String = "pullDownRelease";
      
      public static const PULL_UP_RELEASE:String = "pullUpRelease";
      
      public static const TWEEN_TIME_GO:Number = 0.5;
      
      public static const TWEEN_TIME_DEFAULT:Number = 0.3;
      
      public static const PULL_RATIO:Number = 0.5;
       
      
      private var _owner:GComponent;
      
      private var _container:Sprite;
      
      private var _maskContainer:Sprite;
      
      private var _alignContainer:Sprite;
      
      private var _scrollType:int;
      
      private var _scrollStep:int;
      
      private var _mouseWheelStep:int;
      
      private var _decelerationRate:Number;
      
      private var _scrollBarMargin:Margin;
      
      private var _bouncebackEffect:Boolean;
      
      private var _touchEffect:Boolean;
      
      private var _scrollBarDisplayAuto:Boolean;
      
      private var _vScrollNone:Boolean;
      
      private var _hScrollNone:Boolean;
      
      private var _needRefresh:Boolean;
      
      private var _refreshBarAxis:String;
      
      private var _displayOnLeft:Boolean;
      
      private var _snapToItem:Boolean;
      
      var _displayInDemand:Boolean;
      
      private var _mouseWheelEnabled:Boolean;
      
      private var _pageMode:Boolean;
      
      private var _inertiaDisabled:Boolean;
      
      private var _floating:Boolean;
      
      private var _xPos:Number;
      
      private var _yPos:Number;
      
      private var _viewSize:Point;
      
      private var _contentSize:Point;
      
      private var _overlapSize:Point;
      
      private var _pageSize:Point;
      
      private var _containerPos:Point;
      
      private var _beginTouchPos:Point;
      
      private var _lastTouchPos:Point;
      
      private var _lastTouchGlobalPos:Point;
      
      private var _velocity:Point;
      
      private var _velocityScale:Number;
      
      private var _lastMoveTime:Number;
      
      private var _isHoldAreaDone:Boolean;
      
      private var _aniFlag:int;
      
      var _loop:int;
      
      private var _headerLockedSize:int;
      
      private var _footerLockedSize:int;
      
      private var _refreshEventDispatching:Boolean;
      
      private var _hover:Boolean;
      
      private var _tweening:int;
      
      private var _tweenTime:Point;
      
      private var _tweenDuration:Point;
      
      private var _tweenStart:Point;
      
      private var _tweenChange:Point;
      
      private var _pageController:Controller;
      
      private var _hzScrollBar:GScrollBar;
      
      private var _vtScrollBar:GScrollBar;
      
      private var _header:GComponent;
      
      private var _footer:GComponent;
      
      public var isDragged:Boolean;
      
      public function ScrollPane(param1:GComponent, param2:int, param3:Margin, param4:int, param5:int, param6:String, param7:String, param8:String, param9:String)
      {
         var _loc10_:* = null;
         super();
         _owner = param1;
         param1.opaque = true;
         _maskContainer = new Sprite();
         _maskContainer.mouseEnabled = false;
         _owner._rootContainer.addChild(_maskContainer);
         _container = _owner._container;
         _container.x = 0;
         _container.y = 0;
         _container.mouseEnabled = false;
         _maskContainer.addChild(_container);
         _scrollBarMargin = param3;
         _scrollType = param2;
         _scrollStep = UIConfig.defaultScrollStep;
         _mouseWheelStep = _scrollStep * 2;
         _decelerationRate = UIConfig.defaultScrollDecelerationRate;
         _displayOnLeft = (param5 & 1) != 0;
         _snapToItem = (param5 & 2) != 0;
         _displayInDemand = (param5 & 4) != 0;
         _pageMode = (param5 & 8) != 0;
         if(param5 & 16)
         {
            _touchEffect = true;
         }
         else if(param5 & 32)
         {
            _touchEffect = false;
         }
         else
         {
            _touchEffect = UIConfig.defaultScrollTouchEffect;
         }
         if(param5 & 64)
         {
            _bouncebackEffect = true;
         }
         else if(param5 & 128)
         {
            _bouncebackEffect = false;
         }
         else
         {
            _bouncebackEffect = UIConfig.defaultScrollBounceEffect;
         }
         _inertiaDisabled = (param5 & 256) != 0;
         _floating = (param5 & 1024) != 0;
         if((param5 & 512) == 0)
         {
            _maskContainer.scrollRect = new Rectangle();
         }
         _mouseWheelEnabled = true;
         _xPos = 0;
         _yPos = 0;
         _aniFlag = 0;
         _footerLockedSize = 0;
         _headerLockedSize = 0;
         if(param4 == 0)
         {
            param4 = UIConfig.defaultScrollBarDisplay;
         }
         _viewSize = new Point();
         _contentSize = new Point();
         _pageSize = new Point(1,1);
         _overlapSize = new Point();
         _tweenTime = new Point();
         _tweenStart = new Point();
         _tweenDuration = new Point();
         _tweenChange = new Point();
         _velocity = new Point();
         _containerPos = new Point();
         _beginTouchPos = new Point();
         _lastTouchPos = new Point();
         _lastTouchGlobalPos = new Point();
         if(param4 != 3)
         {
            if(_scrollType == 2 || _scrollType == 1)
            {
               _loc10_ = !!param6?param6:UIConfig.verticalScrollBar;
               if(_loc10_)
               {
                  _vtScrollBar = UIPackage.createObjectFromURL(_loc10_) as GScrollBar;
                  if(!_vtScrollBar)
                  {
                     throw new Error("cannot create scrollbar from " + _loc10_);
                  }
                  _vtScrollBar.setScrollPane(this,true);
                  _owner._rootContainer.addChild(_vtScrollBar.displayObject);
               }
            }
            if(_scrollType == 2 || _scrollType == 0)
            {
               _loc10_ = !!param7?param7:UIConfig.horizontalScrollBar;
               if(_loc10_)
               {
                  _hzScrollBar = UIPackage.createObjectFromURL(_loc10_) as GScrollBar;
                  if(!_hzScrollBar)
                  {
                     throw new Error("cannot create scrollbar from " + _loc10_);
                  }
                  _hzScrollBar.setScrollPane(this,false);
                  _owner._rootContainer.addChild(_hzScrollBar.displayObject);
               }
            }
            _scrollBarDisplayAuto = param4 == 2;
            if(_scrollBarDisplayAuto)
            {
               if(_vtScrollBar)
               {
                  _vtScrollBar.displayObject.visible = false;
               }
               if(_hzScrollBar)
               {
                  _hzScrollBar.displayObject.visible = false;
               }
               if(Mouse.supportsCursor)
               {
                  _owner._rootContainer.addEventListener("rollOver",__rollOver);
                  _owner._rootContainer.addEventListener("rollOut",__rollOut);
               }
            }
         }
         else
         {
            _mouseWheelEnabled = false;
         }
         if(param8)
         {
            _header = UIPackage.createObjectFromURL(param8) as GComponent;
            if(_header == null)
            {
               throw new Error("FairyGUI: cannot create scrollPane header from " + param8);
            }
         }
         if(param9)
         {
            _footer = UIPackage.createObjectFromURL(param9) as GComponent;
            if(_footer == null)
            {
               throw new Error("FairyGUI: cannot create scrollPane footer from " + param9);
            }
         }
         if(_header != null || _footer != null)
         {
            _refreshBarAxis = _scrollType == 2 || _scrollType == 1?"y":"x";
         }
         setSize(param1.width,param1.height);
         _owner._rootContainer.addEventListener("mouseWheel",__mouseWheel);
         _owner.addEventListener("beginGTouch",__mouseDown);
         _owner.addEventListener("endGTouch",__mouseUp);
      }
      
      private static function easeFunc(param1:Number, param2:Number) : Number
      {
         param1 = param1 / param2 - 1;
         return (param1 / param2 - 1) * param1 * param1 + 1;
      }
      
      public function dispose() : void
      {
         if(_tweening != 0)
         {
            GTimers.inst.remove(tweenUpdate);
         }
         _pageController = null;
         if(_hzScrollBar != null)
         {
            _hzScrollBar.dispose();
         }
         if(_vtScrollBar != null)
         {
            _vtScrollBar.dispose();
         }
         if(_header != null)
         {
            _header.dispose();
         }
         if(_footer != null)
         {
            _footer.dispose();
         }
      }
      
      public function get owner() : GComponent
      {
         return _owner;
      }
      
      public function get hzScrollBar() : GScrollBar
      {
         return this._hzScrollBar;
      }
      
      public function get vtScrollBar() : GScrollBar
      {
         return this._vtScrollBar;
      }
      
      public function get header() : GComponent
      {
         return _header;
      }
      
      public function get footer() : GComponent
      {
         return _footer;
      }
      
      public function get bouncebackEffect() : Boolean
      {
         return _bouncebackEffect;
      }
      
      public function set bouncebackEffect(param1:Boolean) : void
      {
         _bouncebackEffect = param1;
      }
      
      public function get touchEffect() : Boolean
      {
         return _touchEffect;
      }
      
      public function set touchEffect(param1:Boolean) : void
      {
         _touchEffect = param1;
      }
      
      public function set scrollSpeed(param1:int) : void
      {
         this.scrollStep = param1;
      }
      
      public function get scrollSpeed() : int
      {
         return this.scrollStep;
      }
      
      public function set scrollStep(param1:int) : void
      {
         _scrollStep = param1;
         if(_scrollStep == 0)
         {
            _scrollStep = UIConfig.defaultScrollStep;
         }
         _mouseWheelStep = _scrollStep * 2;
      }
      
      public function get scrollStep() : int
      {
         return _scrollStep;
      }
      
      public function get snapToItem() : Boolean
      {
         return _snapToItem;
      }
      
      public function set snapToItem(param1:Boolean) : void
      {
         _snapToItem = param1;
      }
      
      public function get mouseWheelEnabled() : Boolean
      {
         return _mouseWheelEnabled;
      }
      
      public function set mouseWheelEnabled(param1:Boolean) : void
      {
         _mouseWheelEnabled = param1;
      }
      
      public function get decelerationRate() : Number
      {
         return _decelerationRate;
      }
      
      public function set decelerationRate(param1:Number) : void
      {
         _decelerationRate = param1;
      }
      
      public function get percX() : Number
      {
         return _overlapSize.x == 0?0:Number(_xPos / _overlapSize.x);
      }
      
      public function set percX(param1:Number) : void
      {
         setPercX(param1,false);
      }
      
      public function setPercX(param1:Number, param2:Boolean = false) : void
      {
         _owner.ensureBoundsCorrect();
         setPosX(_overlapSize.x * ToolSet.clamp01(param1),param2);
      }
      
      public function get percY() : Number
      {
         return _overlapSize.y == 0?0:Number(_yPos / _overlapSize.y);
      }
      
      public function set percY(param1:Number) : void
      {
         setPercY(param1,false);
      }
      
      public function setPercY(param1:Number, param2:Boolean = false) : void
      {
         _owner.ensureBoundsCorrect();
         setPosY(_overlapSize.y * ToolSet.clamp01(param1),param2);
      }
      
      public function get posX() : Number
      {
         return _xPos;
      }
      
      public function set posX(param1:Number) : void
      {
         setPosX(param1,false);
      }
      
      public function setPosX(param1:Number, param2:Boolean = false) : void
      {
         _owner.ensureBoundsCorrect();
         if(_loop == 1)
         {
            param1 = loopCheckingNewPos(param1,"x");
         }
         param1 = ToolSet.clamp(param1,0,_overlapSize.x);
         if(param1 != _xPos)
         {
            _xPos = param1;
            posChanged(param2);
         }
      }
      
      public function get posY() : Number
      {
         return _yPos;
      }
      
      public function set posY(param1:Number) : void
      {
         setPosY(param1,false);
      }
      
      public function setPosY(param1:Number, param2:Boolean = false) : void
      {
         _owner.ensureBoundsCorrect();
         if(_loop == 1)
         {
            param1 = loopCheckingNewPos(param1,"y");
         }
         param1 = ToolSet.clamp(param1,0,_overlapSize.y);
         if(param1 != _yPos)
         {
            _yPos = param1;
            posChanged(param2);
         }
      }
      
      public function get contentWidth() : Number
      {
         return _contentSize.x;
      }
      
      public function get contentHeight() : Number
      {
         return _contentSize.y;
      }
      
      public function get viewWidth() : Number
      {
         return _viewSize.x;
      }
      
      public function set viewWidth(param1:Number) : void
      {
         param1 = param1 + _owner.margin.left + _owner.margin.right;
         if(_vtScrollBar != null && !_floating)
         {
            param1 = param1 + _vtScrollBar.width;
         }
         _owner.width = param1;
      }
      
      public function get viewHeight() : Number
      {
         return _viewSize.y;
      }
      
      public function set viewHeight(param1:Number) : void
      {
         param1 = param1 + _owner.margin.top + _owner.margin.bottom;
         if(_hzScrollBar != null && !_floating)
         {
            param1 = param1 + _hzScrollBar.height;
         }
         _owner.height = param1;
      }
      
      public function get currentPageX() : int
      {
         if(!_pageMode)
         {
            return 0;
         }
         var _loc1_:int = Math.floor(_xPos / _pageSize.x);
         if(_xPos - _loc1_ * _pageSize.x > _pageSize.x * 0.5)
         {
            _loc1_++;
         }
         return _loc1_;
      }
      
      public function set currentPageX(param1:int) : void
      {
         setCurrentPageX(param1,false);
      }
      
      public function get currentPageY() : int
      {
         if(!_pageMode)
         {
            return 0;
         }
         var _loc1_:int = Math.floor(_yPos / _pageSize.y);
         if(_yPos - _loc1_ * _pageSize.y > _pageSize.y * 0.5)
         {
            _loc1_++;
         }
         return _loc1_;
      }
      
      public function set currentPageY(param1:int) : void
      {
         setCurrentPageY(param1,false);
      }
      
      public function setCurrentPageX(param1:int, param2:Boolean) : void
      {
         _owner.ensureBoundsCorrect();
         if(_pageMode && _overlapSize.x > 0)
         {
            this.setPosX(param1 * _pageSize.x,param2);
         }
      }
      
      public function setCurrentPageY(param1:int, param2:Boolean) : void
      {
         _owner.ensureBoundsCorrect();
         if(_pageMode && _overlapSize.y > 0)
         {
            this.setPosY(param1 * _pageSize.y,param2);
         }
      }
      
      public function get isBottomMost() : Boolean
      {
         return _yPos == _overlapSize.y || _overlapSize.y == 0;
      }
      
      public function get isRightMost() : Boolean
      {
         return _xPos == _overlapSize.x || _overlapSize.x == 0;
      }
      
      public function get pageController() : Controller
      {
         return _pageController;
      }
      
      public function set pageController(param1:Controller) : void
      {
         _pageController = param1;
      }
      
      public function get scrollingPosX() : Number
      {
         return ToolSet.clamp(-_container.x,0,_overlapSize.x);
      }
      
      public function get scrollingPosY() : Number
      {
         return ToolSet.clamp(-_container.y,0,_overlapSize.y);
      }
      
      public function scrollTop(param1:Boolean = false) : void
      {
         this.setPercY(0,param1);
      }
      
      public function scrollBottom(param1:Boolean = false) : void
      {
         this.setPercY(1,param1);
      }
      
      public function scrollUp(param1:Number = 1, param2:Boolean = false) : void
      {
         if(_pageMode)
         {
            setPosY(_yPos - _pageSize.y * param1,param2);
         }
         else
         {
            setPosY(_yPos - _scrollStep * param1,param2);
         }
      }
      
      public function scrollDown(param1:Number = 1, param2:Boolean = false) : void
      {
         if(_pageMode)
         {
            setPosY(_yPos + _pageSize.y * param1,param2);
         }
         else
         {
            setPosY(_yPos + _scrollStep * param1,param2);
         }
      }
      
      public function scrollLeft(param1:Number = 1, param2:Boolean = false) : void
      {
         if(_pageMode)
         {
            setPosX(_xPos - _pageSize.x * param1,param2);
         }
         else
         {
            setPosX(_xPos - _scrollStep * param1,param2);
         }
      }
      
      public function scrollRight(param1:Number = 1, param2:Boolean = false) : void
      {
         if(_pageMode)
         {
            setPosX(_xPos + _pageSize.x * param1,param2);
         }
         else
         {
            setPosX(_xPos + _scrollStep * param1,param2);
         }
      }
      
      public function scrollToView(param1:*, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc4_:* = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         _owner.ensureBoundsCorrect();
         if(_needRefresh)
         {
            refresh();
         }
         if(param1 is GObject)
         {
            if(param1.parent != _owner)
            {
               GObject(param1).parent.localToGlobalRect(param1.x,param1.y,param1.width,param1.height,sHelperRect);
               _loc4_ = _owner.globalToLocalRect(sHelperRect.x,sHelperRect.y,sHelperRect.width,sHelperRect.height,sHelperRect);
            }
            else
            {
               _loc4_ = sHelperRect;
               _loc4_.setTo(param1.x,param1.y,param1.width,param1.height);
            }
         }
         else
         {
            _loc4_ = Rectangle(param1);
         }
         if(_overlapSize.y > 0)
         {
            _loc5_ = _yPos + _viewSize.y;
            if(param3 || _loc4_.y <= _yPos || _loc4_.height >= _viewSize.y)
            {
               if(_pageMode)
               {
                  this.setPosY(Math.floor(_loc4_.y / _pageSize.y) * _pageSize.y,param2);
               }
               else
               {
                  this.setPosY(_loc4_.y,param2);
               }
            }
            else if(_loc4_.y + _loc4_.height > _loc5_)
            {
               if(_pageMode)
               {
                  this.setPosY(Math.floor(_loc4_.y / _pageSize.y) * _pageSize.y,param2);
               }
               else if(_loc4_.height <= _viewSize.y / 2)
               {
                  this.setPosY(_loc4_.y + _loc4_.height * 2 - _viewSize.y,param2);
               }
               else
               {
                  this.setPosY(_loc4_.y + _loc4_.height - _viewSize.y,param2);
               }
            }
         }
         if(_overlapSize.x > 0)
         {
            _loc6_ = _xPos + _viewSize.x;
            if(param3 || _loc4_.x <= _xPos || _loc4_.width >= _viewSize.x)
            {
               if(_pageMode)
               {
                  this.setPosX(Math.floor(_loc4_.x / _pageSize.x) * _pageSize.x,param2);
               }
               else
               {
                  this.setPosX(_loc4_.x,param2);
               }
            }
            else if(_loc4_.x + _loc4_.width > _loc6_)
            {
               if(_pageMode)
               {
                  this.setPosX(Math.floor(_loc4_.x / _pageSize.x) * _pageSize.x,param2);
               }
               else if(_loc4_.width <= _viewSize.x / 2)
               {
                  this.setPosX(_loc4_.x + _loc4_.width * 2 - _viewSize.x,param2);
               }
               else
               {
                  this.setPosX(_loc4_.x + _loc4_.width - _viewSize.x,param2);
               }
            }
         }
         if(!param2 && _needRefresh)
         {
            refresh();
         }
      }
      
      public function isChildInView(param1:GObject) : Boolean
      {
         var _loc2_:Number = NaN;
         if(_overlapSize.y > 0)
         {
            _loc2_ = param1.y + _container.y;
            if(_loc2_ < -param1.height || _loc2_ > _viewSize.y)
            {
               return false;
            }
         }
         if(_overlapSize.x > 0)
         {
            _loc2_ = param1.x + _container.x;
            if(_loc2_ < -param1.width || _loc2_ > _viewSize.x)
            {
               return false;
            }
         }
         return true;
      }
      
      public function cancelDragging() : void
      {
         _owner.removeEventListener("dragGTouch",__mouseMove);
         if(draggingPane == this)
         {
            draggingPane = null;
         }
         _gestureFlag = 0;
         isDragged = false;
         _maskContainer.mouseChildren = true;
      }
      
      public function lockHeader(param1:int) : void
      {
         if(_headerLockedSize == param1)
         {
            return;
         }
         _headerLockedSize = param1;
         if(!_refreshEventDispatching && _container[_refreshBarAxis] >= 0)
         {
            _tweenStart.setTo(_container.x,_container.y);
            _tweenChange.setTo(0,0);
            _tweenChange[_refreshBarAxis] = _headerLockedSize - _tweenStart[_refreshBarAxis];
            _tweenDuration.setTo(0.3,0.3);
            startTween(2);
         }
      }
      
      public function lockFooter(param1:int) : void
      {
         var _loc2_:Number = NaN;
         if(_footerLockedSize == param1)
         {
            return;
         }
         _footerLockedSize = param1;
         if(!_refreshEventDispatching && _container[_refreshBarAxis] <= -_overlapSize[_refreshBarAxis])
         {
            _tweenStart.setTo(_container.x,_container.y);
            _tweenChange.setTo(0,0);
            _loc2_ = _overlapSize[_refreshBarAxis];
            if(_loc2_ == 0)
            {
               _loc2_ = Math.max(_contentSize[_refreshBarAxis] + _footerLockedSize - _viewSize[_refreshBarAxis],0);
            }
            else
            {
               _loc2_ = _loc2_ + _footerLockedSize;
            }
            _tweenChange[_refreshBarAxis] = -_loc2_ - _tweenStart[_refreshBarAxis];
            _tweenDuration.setTo(0.3,0.3);
            startTween(2);
         }
      }
      
      function onOwnerSizeChanged() : void
      {
         setSize(_owner.width,_owner.height);
         posChanged(false);
      }
      
      function handleControllerChanged(param1:Controller) : void
      {
         if(_pageController == param1)
         {
            if(_scrollType == 0)
            {
               this.setCurrentPageX(param1.selectedIndex,true);
            }
            else
            {
               this.setCurrentPageY(param1.selectedIndex,true);
            }
         }
      }
      
      private function updatePageController() : void
      {
         var _loc2_:int = 0;
         var _loc1_:* = null;
         if(_pageController != null && !_pageController.changing)
         {
            if(_scrollType == 0)
            {
               _loc2_ = this.currentPageX;
            }
            else
            {
               _loc2_ = this.currentPageY;
            }
            if(_loc2_ < _pageController.pageCount)
            {
               _loc1_ = _pageController;
               _pageController = null;
               _loc1_.selectedIndex = _loc2_;
               _pageController = _loc1_;
            }
         }
      }
      
      function adjustMaskContainer() : void
      {
         var _loc2_:Number = NaN;
         var _loc1_:Number = NaN;
         if(_displayOnLeft && _vtScrollBar != null && !_floating)
         {
            _loc1_ = Math.floor(_owner.margin.left + _vtScrollBar.width);
         }
         else
         {
            _loc1_ = Math.floor(_owner.margin.left);
         }
         _loc2_ = Math.floor(_owner.margin.top);
         _maskContainer.x = _loc1_;
         _maskContainer.y = _loc2_;
         if(_owner._alignOffset.x != 0 || _owner._alignOffset.y != 0)
         {
            if(_alignContainer == null)
            {
               _alignContainer = new Sprite();
               _alignContainer.mouseEnabled = false;
               _maskContainer.addChild(_alignContainer);
               _alignContainer.addChild(_container);
            }
            _alignContainer.x = _owner._alignOffset.x;
            _alignContainer.y = _owner._alignOffset.y;
         }
         else if(_alignContainer)
         {
            var _loc3_:int = 0;
            _alignContainer.y = _loc3_;
            _alignContainer.x = _loc3_;
         }
      }
      
      private function setSize(param1:Number, param2:Number) : void
      {
         adjustMaskContainer();
         if(_hzScrollBar)
         {
            _hzScrollBar.y = param2 - _hzScrollBar.height;
            if(_vtScrollBar)
            {
               _hzScrollBar.width = param1 - _vtScrollBar.width - _scrollBarMargin.left - _scrollBarMargin.right;
               if(_displayOnLeft)
               {
                  _hzScrollBar.x = _scrollBarMargin.left + _vtScrollBar.width;
               }
               else
               {
                  _hzScrollBar.x = _scrollBarMargin.left;
               }
            }
            else
            {
               _hzScrollBar.width = param1 - _scrollBarMargin.left - _scrollBarMargin.right;
               _hzScrollBar.x = _scrollBarMargin.left;
            }
         }
         if(_vtScrollBar)
         {
            if(!_displayOnLeft)
            {
               _vtScrollBar.x = param1 - _vtScrollBar.width;
            }
            if(_hzScrollBar)
            {
               _vtScrollBar.height = param2 - _hzScrollBar.height - _scrollBarMargin.top - _scrollBarMargin.bottom;
            }
            else
            {
               _vtScrollBar.height = param2 - _scrollBarMargin.top - _scrollBarMargin.bottom;
            }
            _vtScrollBar.y = _scrollBarMargin.top;
         }
         _viewSize.x = param1;
         _viewSize.y = param2;
         if(_hzScrollBar && !_floating)
         {
            _viewSize.y = _viewSize.y - _hzScrollBar.height;
         }
         if(_vtScrollBar && !_floating)
         {
            _viewSize.x = _viewSize.x - _vtScrollBar.width;
         }
         _viewSize.x = _viewSize.x - (_owner.margin.left + _owner.margin.right);
         _viewSize.y = _viewSize.y - (_owner.margin.top + _owner.margin.bottom);
         _viewSize.x = Math.max(1,_viewSize.x);
         _viewSize.y = Math.max(1,_viewSize.y);
         _pageSize.x = _viewSize.x;
         _pageSize.y = _viewSize.y;
         handleSizeChanged();
      }
      
      function setContentSize(param1:Number, param2:Number) : void
      {
         if(_contentSize.x == param1 && _contentSize.y == param2)
         {
            return;
         }
         _contentSize.x = param1;
         _contentSize.y = param2;
         handleSizeChanged();
      }
      
      function changeContentSizeOnScrolling(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:* = _xPos == _overlapSize.x;
         var _loc6_:* = _yPos == _overlapSize.y;
         _contentSize.x = _contentSize.x + param1;
         _contentSize.y = _contentSize.y + param2;
         handleSizeChanged();
         if(_tweening == 1)
         {
            if(param1 != 0 && _loc5_ && _tweenChange.x < 0)
            {
               _xPos = _overlapSize.x;
               _tweenChange.x = -_xPos - _tweenStart.x;
            }
            if(param2 != 0 && _loc6_ && _tweenChange.y < 0)
            {
               _yPos = _overlapSize.y;
               _tweenChange.y = -_yPos - _tweenStart.y;
            }
         }
         else if(_tweening == 2)
         {
            if(param3 != 0)
            {
               _container.x = _container.x - param3;
               _tweenStart.x = _tweenStart.x - param3;
               _xPos = -_container.x;
            }
            if(param4 != 0)
            {
               _container.y = _container.y - param4;
               _tweenStart.y = _tweenStart.y - param4;
               _yPos = -_container.y;
            }
         }
         else if(isDragged)
         {
            if(param3 != 0)
            {
               _container.x = _container.x - param3;
               _containerPos.x = _containerPos.x - param3;
               _xPos = -_container.x;
            }
            if(param4 != 0)
            {
               _container.y = _container.y - param4;
               _containerPos.y = _containerPos.y - param4;
               _yPos = -_container.y;
            }
         }
         else
         {
            if(param1 != 0 && _loc5_)
            {
               _xPos = _overlapSize.x;
               _container.x = -_xPos;
            }
            if(param2 != 0 && _loc6_)
            {
               _yPos = _overlapSize.y;
               _container.y = -_yPos;
            }
         }
         if(_pageMode)
         {
            updatePageController();
         }
      }
      
      private function handleSizeChanged(param1:Boolean = false) : void
      {
         var _loc3_:Number = NaN;
         if(_displayInDemand)
         {
            _vScrollNone = _contentSize.y <= _viewSize.y;
            _hScrollNone = _contentSize.x <= _viewSize.x;
         }
         if(_vtScrollBar)
         {
            if(_contentSize.y == 0)
            {
               _vtScrollBar.setDisplayPerc(0);
            }
            else
            {
               _vtScrollBar.setDisplayPerc(Math.min(1,_viewSize.y / _contentSize.y));
            }
         }
         if(_hzScrollBar)
         {
            if(_contentSize.x == 0)
            {
               _hzScrollBar.setDisplayPerc(0);
            }
            else
            {
               _hzScrollBar.setDisplayPerc(Math.min(1,_viewSize.x / _contentSize.x));
            }
         }
         updateScrollBarVisible();
         var _loc2_:Rectangle = _maskContainer.scrollRect;
         if(_loc2_)
         {
            _loc2_.width = _viewSize.x;
            _loc2_.height = _viewSize.y;
            if(_vScrollNone && _vtScrollBar)
            {
               _loc2_.width = _loc2_.width + _vtScrollBar.width;
            }
            if(_hScrollNone && _hzScrollBar)
            {
               _loc2_.height = _loc2_.height + _hzScrollBar.height;
            }
            _maskContainer.scrollRect = _loc2_;
         }
         if(_scrollType == 0 || _scrollType == 2)
         {
            _overlapSize.x = Math.ceil(Math.max(0,_contentSize.x - _viewSize.x));
         }
         else
         {
            _overlapSize.x = 0;
         }
         if(_scrollType == 1 || _scrollType == 2)
         {
            _overlapSize.y = Math.ceil(Math.max(0,_contentSize.y - _viewSize.y));
         }
         else
         {
            _overlapSize.y = 0;
         }
         _xPos = ToolSet.clamp(_xPos,0,_overlapSize.x);
         _yPos = ToolSet.clamp(_yPos,0,_overlapSize.y);
         if(_refreshBarAxis != null)
         {
            _loc3_ = _overlapSize[_refreshBarAxis];
            if(_loc3_ == 0)
            {
               _loc3_ = Math.max(_contentSize[_refreshBarAxis] + _footerLockedSize - _viewSize[_refreshBarAxis],0);
            }
            else
            {
               _loc3_ = _loc3_ + _footerLockedSize;
            }
            if(_refreshBarAxis == "x")
            {
               _container.x = ToolSet.clamp(_container.x,-_loc3_,_headerLockedSize);
               _container.y = ToolSet.clamp(_container.y,-_overlapSize.y,0);
            }
            else
            {
               _container.x = ToolSet.clamp(_container.x,-_overlapSize.x,0);
               _container.y = ToolSet.clamp(_container.y,-_loc3_,_headerLockedSize);
            }
            if(_header != null)
            {
               if(_refreshBarAxis == "x")
               {
                  _header.height = _viewSize.y;
               }
               else
               {
                  _header.width = _viewSize.x;
               }
            }
            if(_footer != null)
            {
               if(_refreshBarAxis == "y")
               {
                  _footer.height = _viewSize.y;
               }
               else
               {
                  _footer.width = _viewSize.x;
               }
            }
         }
         else
         {
            _container.x = ToolSet.clamp(_container.x,-_overlapSize.x,0);
            _container.y = ToolSet.clamp(_container.y,-_overlapSize.y,0);
         }
         updateScrollBarPos();
         if(_pageMode)
         {
            updatePageController();
         }
      }
      
      private function posChanged(param1:Boolean) : void
      {
         if(_aniFlag == 0)
         {
            _aniFlag = !!param1?1:-1;
         }
         else if(_aniFlag == 1 && !param1)
         {
            _aniFlag = -1;
         }
         _needRefresh = true;
         GTimers.inst.callLater(refresh);
      }
      
      private function refresh() : void
      {
         _needRefresh = false;
         GTimers.inst.remove(refresh);
         if(_pageMode || _snapToItem)
         {
            sEndPos.setTo(-_xPos,-_yPos);
            alignPosition(sEndPos,false);
            _xPos = -sEndPos.x;
            _yPos = -sEndPos.y;
         }
         refresh2();
         dispatchEvent(new Event("scroll"));
         if(_needRefresh)
         {
            _needRefresh = false;
            GTimers.inst.remove(refresh);
            refresh2();
         }
         updateScrollBarPos();
         _aniFlag = 0;
      }
      
      private function refresh2() : void
      {
         var _loc1_:* = NaN;
         var _loc2_:* = NaN;
         if(_aniFlag == 1 && !isDragged)
         {
            if(_overlapSize.x > 0)
            {
               _loc1_ = Number(-int(_xPos));
            }
            else
            {
               if(_container.x != 0)
               {
                  _container.x = 0;
               }
               _loc1_ = 0;
            }
            if(_overlapSize.y > 0)
            {
               _loc2_ = Number(-int(_yPos));
            }
            else
            {
               if(_container.y != 0)
               {
                  _container.y = 0;
               }
               _loc2_ = 0;
            }
            if(_loc1_ != _container.x || _loc2_ != _container.y)
            {
               _tweenDuration.setTo(0.5,0.5);
               _tweenStart.setTo(_container.x,_container.y);
               _tweenChange.setTo(_loc1_ - _tweenStart.x,_loc2_ - _tweenStart.y);
               startTween(1);
            }
            else if(_tweening != 0)
            {
               killTween();
            }
         }
         else
         {
            if(_tweening != 0)
            {
               killTween();
            }
            _container.x = int(-_xPos);
            _container.y = int(-_yPos);
            loopCheckingCurrent();
         }
         if(_pageMode)
         {
            updatePageController();
         }
      }
      
      private function __mouseDown(param1:GTouchEvent) : void
      {
         if(!_touchEffect)
         {
            return;
         }
         if(_tweening != 0)
         {
            killTween();
            isDragged = true;
         }
         else
         {
            isDragged = false;
         }
         var _loc2_:Point = _owner.globalToLocal(param1.stageX,param1.stageY);
         _containerPos.setTo(_container.x,_container.y);
         _beginTouchPos.copyFrom(_loc2_);
         _lastTouchPos.copyFrom(_loc2_);
         _lastTouchGlobalPos.setTo(param1.stageX,param1.stageY);
         _isHoldAreaDone = false;
         _velocity.setTo(0,0);
         _velocityScale = 1;
         _lastMoveTime = getTimer() / 1000;
         _owner.addEventListener("dragGTouch",__mouseMove);
      }
      
      private function __mouseMove(param1:GTouchEvent) : void
      {
         var _loc15_:int = 0;
         var _loc19_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc9_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc7_:Number = NaN;
         var _loc17_:Number = NaN;
         if(!_touchEffect)
         {
            return;
         }
         if(draggingPane != null && draggingPane != this || GObject.draggingObject != null)
         {
            return;
         }
         var _loc4_:Point = _owner.globalToLocal(param1.stageX,param1.stageY);
         if(GRoot.touchScreen)
         {
            _loc15_ = UIConfig.touchScrollSensitivity;
         }
         else
         {
            _loc15_ = 8;
         }
         if(_scrollType == 1)
         {
            if(!_isHoldAreaDone)
            {
               _gestureFlag = _gestureFlag | 1;
               _loc6_ = Math.abs(_beginTouchPos.y - _loc4_.y);
               if(_loc6_ < _loc15_)
               {
                  return;
               }
               if((_gestureFlag & 2) != 0)
               {
                  _loc19_ = Math.abs(_beginTouchPos.x - _loc4_.x);
                  if(_loc6_ < _loc19_)
                  {
                     return;
                  }
               }
            }
            _loc3_ = true;
         }
         else if(_scrollType == 0)
         {
            if(!_isHoldAreaDone)
            {
               _gestureFlag = _gestureFlag | 2;
               _loc6_ = Math.abs(_beginTouchPos.x - _loc4_.x);
               if(_loc6_ < _loc15_)
               {
                  return;
               }
               if((_gestureFlag & 1) != 0)
               {
                  _loc19_ = Math.abs(_beginTouchPos.y - _loc4_.y);
                  if(_loc6_ < _loc19_)
                  {
                     return;
                  }
               }
            }
            _loc9_ = true;
         }
         else
         {
            _gestureFlag = 3;
            if(!_isHoldAreaDone)
            {
               _loc6_ = Math.abs(_beginTouchPos.y - _loc4_.y);
               if(_loc6_ < _loc15_)
               {
                  _loc6_ = Math.abs(_beginTouchPos.x - _loc4_.x);
                  if(_loc6_ < _loc15_)
                  {
                     return;
                  }
               }
            }
            _loc9_ = true;
            _loc3_ = _loc9_;
         }
         var _loc18_:Number = int(_containerPos.x + _loc4_.x - _beginTouchPos.x);
         var _loc16_:Number = int(_containerPos.y + _loc4_.y - _beginTouchPos.y);
         if(_loc3_)
         {
            if(_loc16_ > 0)
            {
               if(!_bouncebackEffect)
               {
                  _container.y = 0;
               }
               else if(_header != null && _header.maxHeight != 0)
               {
                  _container.y = int(Math.min(_loc16_ * 0.5,_header.maxHeight));
               }
               else
               {
                  _container.y = int(Math.min(_loc16_ * 0.5,_viewSize.y * 0.5));
               }
            }
            else if(_loc16_ < -_overlapSize.y)
            {
               if(!_bouncebackEffect)
               {
                  _container.y = -_overlapSize.y;
               }
               else if(_footer != null && _footer.maxHeight > 0)
               {
                  _container.y = int(Math.max((_loc16_ + _overlapSize.y) * 0.5,-_footer.maxHeight) - _overlapSize.y);
               }
               else
               {
                  _container.y = int(Math.max((_loc16_ + _overlapSize.y) * 0.5,-_viewSize.y * 0.5) - _overlapSize.y);
               }
            }
            else
            {
               _container.y = _loc16_;
            }
         }
         if(_loc9_)
         {
            if(_loc18_ > 0)
            {
               if(!_bouncebackEffect)
               {
                  _container.x = 0;
               }
               else if(_header != null && _header.maxWidth != 0)
               {
                  _container.x = int(Math.min(_loc18_ * 0.5,_header.maxWidth));
               }
               else
               {
                  _container.x = int(Math.min(_loc18_ * 0.5,_viewSize.x * 0.5));
               }
            }
            else if(_loc18_ < 0 - _overlapSize.x)
            {
               if(!_bouncebackEffect)
               {
                  _container.x = -_overlapSize.x;
               }
               else if(_footer != null && _footer.maxWidth > 0)
               {
                  _container.x = int(Math.max((_loc18_ + _overlapSize.x) * 0.5,-_footer.maxWidth) - _overlapSize.x);
               }
               else
               {
                  _container.x = int(Math.max((_loc18_ + _overlapSize.x) * 0.5,-_viewSize.x * 0.5) - _overlapSize.x);
               }
            }
            else
            {
               _container.x = _loc18_;
            }
         }
         var _loc8_:Number = _owner.displayObject.stage.frameRate;
         var _loc11_:Number = getTimer() / 1000;
         var _loc5_:Number = Math.max(_loc11_ - _lastMoveTime,1 / _loc8_);
         var _loc14_:* = Number(_loc4_.x - _lastTouchPos.x);
         var _loc10_:* = Number(_loc4_.y - _lastTouchPos.y);
         if(!_loc9_)
         {
            _loc14_ = 0;
         }
         if(!_loc3_)
         {
            _loc10_ = 0;
         }
         if(_loc5_ != 0)
         {
            _loc7_ = _loc5_ * _loc8_ - 1;
            if(_loc7_ > 1)
            {
               _loc17_ = Math.pow(0.833,_loc7_);
               _velocity.x = _velocity.x * _loc17_;
               _velocity.y = _velocity.y * _loc17_;
            }
            _velocity.x = ToolSet.lerp(_velocity.x,_loc14_ * 60 / _loc8_ / _loc5_,_loc5_ * 10);
            _velocity.y = ToolSet.lerp(_velocity.y,_loc10_ * 60 / _loc8_ / _loc5_,_loc5_ * 10);
         }
         var _loc12_:Number = _lastTouchGlobalPos.x - param1.stageX;
         var _loc13_:Number = _lastTouchGlobalPos.y - param1.stageY;
         if(_loc14_ != 0)
         {
            _velocityScale = Math.abs(_loc12_ / _loc14_);
         }
         else if(_loc10_ != 0)
         {
            _velocityScale = Math.abs(_loc13_ / _loc10_);
         }
         _lastTouchPos.setTo(_loc4_.x,_loc4_.y);
         _lastTouchGlobalPos.setTo(param1.stageX,param1.stageY);
         _lastMoveTime = _loc11_;
         if(_overlapSize.x > 0)
         {
            _xPos = ToolSet.clamp(-_container.x,0,_overlapSize.x);
         }
         if(_overlapSize.y > 0)
         {
            _yPos = ToolSet.clamp(-_container.y,0,_overlapSize.y);
         }
         if(_loop != 0)
         {
            _loc18_ = _container.x;
            _loc16_ = _container.y;
            if(loopCheckingCurrent())
            {
               _containerPos.x = _containerPos.x + (_container.x - _loc18_);
               _containerPos.y = _containerPos.y + (_container.y - _loc16_);
            }
         }
         draggingPane = this;
         _isHoldAreaDone = true;
         isDragged = true;
         _maskContainer.mouseChildren = false;
         updateScrollBarPos();
         updateScrollBarVisible();
         if(_pageMode)
         {
            updatePageController();
         }
         dispatchEvent(new Event("scroll"));
      }
      
      private function __mouseUp(param1:Event) : void
      {
         var _loc5_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc6_:Number = NaN;
         _owner.removeEventListener("dragGTouch",__mouseMove);
         if(draggingPane == this)
         {
            draggingPane = null;
         }
         _gestureFlag = 0;
         if(!isDragged || !_touchEffect)
         {
            isDragged = false;
            _maskContainer.mouseChildren = true;
            return;
         }
         isDragged = false;
         _maskContainer.mouseChildren = true;
         _tweenStart.setTo(_container.x,_container.y);
         sEndPos.copyFrom(_tweenStart);
         var _loc4_:Boolean = false;
         if(_container.x > 0)
         {
            sEndPos.x = 0;
            _loc4_ = true;
         }
         else if(_container.x < -_overlapSize.x)
         {
            sEndPos.x = -_overlapSize.x;
            _loc4_ = true;
         }
         if(_container.y > 0)
         {
            sEndPos.y = 0;
            _loc4_ = true;
         }
         else if(_container.y < -_overlapSize.y)
         {
            sEndPos.y = -_overlapSize.y;
            _loc4_ = true;
         }
         if(_loc4_)
         {
            _tweenChange.setTo(sEndPos.x - _tweenStart.x,sEndPos.y - _tweenStart.y);
            if(_tweenChange.x < -UIConfig.touchDragSensitivity || _tweenChange.y < -UIConfig.touchDragSensitivity)
            {
               _refreshEventDispatching = true;
               dispatchEvent(new Event("pullDownRelease"));
               _refreshEventDispatching = false;
            }
            else if(_tweenChange.x > UIConfig.touchDragSensitivity || _tweenChange.y > UIConfig.touchDragSensitivity)
            {
               _refreshEventDispatching = true;
               dispatchEvent(new Event("pullUpRelease"));
               _refreshEventDispatching = false;
            }
            if(_headerLockedSize > 0 && sEndPos[_refreshBarAxis] == 0)
            {
               sEndPos[_refreshBarAxis] = _headerLockedSize;
               _tweenChange.x = sEndPos.x - _tweenStart.x;
               _tweenChange.y = sEndPos.y - _tweenStart.y;
            }
            else if(_footerLockedSize > 0 && sEndPos[_refreshBarAxis] == -_overlapSize[_refreshBarAxis])
            {
               _loc5_ = _overlapSize[_refreshBarAxis];
               if(_loc5_ == 0)
               {
                  _loc5_ = Math.max(_contentSize[_refreshBarAxis] + _footerLockedSize - _viewSize[_refreshBarAxis],0);
               }
               else
               {
                  _loc5_ = _loc5_ + _footerLockedSize;
               }
               sEndPos[_refreshBarAxis] = -_loc5_;
               _tweenChange.x = sEndPos.x - _tweenStart.x;
               _tweenChange.y = sEndPos.y - _tweenStart.y;
            }
            _tweenDuration.setTo(0.3,0.3);
         }
         else
         {
            if(!_inertiaDisabled)
            {
               _loc3_ = _owner.displayObject.stage.frameRate;
               _loc2_ = (getTimer() / 1000 - _lastMoveTime) * _loc3_ - 1;
               if(_loc2_ > 1)
               {
                  _loc6_ = Math.pow(0.833,_loc2_);
                  _velocity.x = _velocity.x * _loc6_;
                  _velocity.y = _velocity.y * _loc6_;
               }
               updateTargetAndDuration(_tweenStart,sEndPos);
            }
            else
            {
               _tweenDuration.setTo(0.3,0.3);
            }
            sOldChange.setTo(sEndPos.x - _tweenStart.x,sEndPos.y - _tweenStart.y);
            loopCheckingTarget(sEndPos);
            if(_pageMode || _snapToItem)
            {
               alignPosition(sEndPos,true);
            }
            _tweenChange.x = sEndPos.x - _tweenStart.x;
            _tweenChange.y = sEndPos.y - _tweenStart.y;
            if(_tweenChange.x == 0 && _tweenChange.y == 0)
            {
               updateScrollBarVisible();
               return;
            }
            if(_pageMode || _snapToItem)
            {
               fixDuration("x",sOldChange.x);
               fixDuration("y",sOldChange.y);
            }
         }
         startTween(2);
      }
      
      private function __mouseWheel(param1:MouseEvent) : void
      {
         if(!_mouseWheelEnabled && (!_vtScrollBar || !_vtScrollBar._rootContainer.hitTestObject(DisplayObject(param1.target))) && (!_hzScrollBar || !_hzScrollBar._rootContainer.hitTestObject(DisplayObject(param1.target))))
         {
            return;
         }
         var _loc3_:DisplayObject = _owner.displayObject.stage.focus;
         if(_loc3_ is TextField && TextField(_loc3_).type == "input")
         {
            return;
         }
         var _loc2_:Number = param1.delta;
         _loc2_ = _loc2_ > 0?-1:Number(_loc2_ < 0?1:0);
         if(_overlapSize.x > 0 && _overlapSize.y == 0)
         {
            if(_pageMode)
            {
               setPosX(_xPos + _pageSize.x * _loc2_,false);
            }
            else
            {
               setPosX(_xPos + _mouseWheelStep * _loc2_,false);
            }
         }
         else if(_pageMode)
         {
            setPosY(_yPos + _pageSize.y * _loc2_,false);
         }
         else
         {
            setPosY(_yPos + _mouseWheelStep * _loc2_,false);
         }
      }
      
      private function __rollOver(param1:Event) : void
      {
         _hover = true;
         updateScrollBarVisible();
      }
      
      private function __rollOut(param1:Event) : void
      {
         _hover = false;
         updateScrollBarVisible();
      }
      
      private function updateScrollBarPos() : void
      {
         if(_vtScrollBar != null)
         {
            _vtScrollBar.setScrollPerc(_overlapSize.y == 0?0:Number(ToolSet.clamp(-_container.y,0,_overlapSize.y) / _overlapSize.y));
         }
         if(_hzScrollBar != null)
         {
            _hzScrollBar.setScrollPerc(_overlapSize.x == 0?0:Number(ToolSet.clamp(-_container.x,0,_overlapSize.x) / _overlapSize.x));
         }
         checkRefreshBar();
      }
      
      function updateScrollBarVisible() : void
      {
         if(_vtScrollBar)
         {
            if(_viewSize.y <= _vtScrollBar.minSize || _vScrollNone)
            {
               _vtScrollBar.displayObject.visible = false;
            }
            else
            {
               updateScrollBarVisible2(_vtScrollBar);
            }
         }
         if(_hzScrollBar)
         {
            if(_viewSize.x <= _hzScrollBar.minSize || _hScrollNone)
            {
               _hzScrollBar.displayObject.visible = false;
            }
            else
            {
               updateScrollBarVisible2(_hzScrollBar);
            }
         }
      }
      
      private function updateScrollBarVisible2(param1:GScrollBar) : void
      {
         if(_scrollBarDisplayAuto)
         {
            GTween.kill(param1,false,"alpha");
         }
         if(_scrollBarDisplayAuto && !_hover && _tweening == 0 && !isDragged && !param1.gripDragging)
         {
            if(param1.displayObject.visible)
            {
               GTween.to(1,0,0.5).setDelay(0.5).onComplete(__barTweenComplete).setTarget(param1,"alpha");
            }
         }
         else
         {
            param1.alpha = 1;
            param1.displayObject.visible = true;
         }
      }
      
      private function __barTweenComplete(param1:GTweener) : void
      {
         var _loc2_:GObject = GObject(param1.target);
         _loc2_.alpha = 1;
         _loc2_.displayObject.visible = false;
      }
      
      private function getLoopPartSize(param1:Number, param2:String) : Number
      {
         return (_contentSize[param2] + (param2 == "x"?GList(_owner).columnGap:int(GList(_owner).lineGap))) / param1;
      }
      
      private function loopCheckingCurrent() : Boolean
      {
         var _loc1_:Boolean = false;
         if(_loop == 1 && _overlapSize.x > 0)
         {
            if(_xPos < 0.001)
            {
               _xPos = _xPos + getLoopPartSize(2,"x");
               _loc1_ = true;
            }
            else if(_xPos >= _overlapSize.x)
            {
               _xPos = _xPos - getLoopPartSize(2,"x");
               _loc1_ = true;
            }
         }
         else if(_loop == 2 && _overlapSize.y > 0)
         {
            if(_yPos < 0.001)
            {
               _yPos = _yPos + getLoopPartSize(2,"y");
               _loc1_ = true;
            }
            else if(_yPos >= _overlapSize.y)
            {
               _yPos = _yPos - getLoopPartSize(2,"y");
               _loc1_ = true;
            }
         }
         if(_loc1_)
         {
            _container.x = int(-_xPos);
            _container.y = int(-_yPos);
         }
         return _loc1_;
      }
      
      private function loopCheckingTarget(param1:Point) : void
      {
         if(_loop == 1)
         {
            loopCheckingTarget2(param1,"x");
         }
         if(_loop == 2)
         {
            loopCheckingTarget2(param1,"y");
         }
      }
      
      private function loopCheckingTarget2(param1:Point, param2:String) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(param1[param2] > 0)
         {
            _loc3_ = getLoopPartSize(2,param2);
            _loc4_ = _tweenStart[param2] - _loc3_;
            if(_loc4_ <= 0 && _loc4_ >= -_overlapSize[param2])
            {
               var _loc5_:* = param2;
               var _loc6_:* = param1[_loc5_] - _loc3_;
               param1[_loc5_] = _loc6_;
               _tweenStart[param2] = _loc4_;
            }
         }
         else if(param1[param2] < -_overlapSize[param2])
         {
            _loc3_ = getLoopPartSize(2,param2);
            _loc4_ = _tweenStart[param2] + _loc3_;
            if(_loc4_ <= 0 && _loc4_ >= -_overlapSize[param2])
            {
               _loc6_ = param2;
               _loc5_ = param1[_loc6_] + _loc3_;
               param1[_loc6_] = _loc5_;
               _tweenStart[param2] = _loc4_;
            }
         }
      }
      
      private function loopCheckingNewPos(param1:Number, param2:String) : Number
      {
         var _loc4_:Number = NaN;
         if(_overlapSize[param2] == 0)
         {
            return param1;
         }
         var _loc3_:Number = param2 == "x"?_xPos:Number(_yPos);
         var _loc5_:Boolean = false;
         if(param1 < 0.001)
         {
            param1 = param1 + getLoopPartSize(2,param2);
            if(param1 > _loc3_)
            {
               _loc4_ = getLoopPartSize(6,param2);
               _loc4_ = Math.ceil((param1 - _loc3_) / _loc4_) * _loc4_;
               _loc3_ = ToolSet.clamp(_loc3_ + _loc4_,0,_overlapSize[param2]);
               _loc5_ = true;
            }
         }
         else if(param1 >= _overlapSize[param2])
         {
            param1 = param1 - getLoopPartSize(2,param2);
            if(param1 < _loc3_)
            {
               _loc4_ = getLoopPartSize(6,param2);
               _loc4_ = Math.ceil((_loc3_ - param1) / _loc4_) * _loc4_;
               _loc3_ = ToolSet.clamp(_loc3_ - _loc4_,0,_overlapSize[param2]);
               _loc5_ = true;
            }
         }
         if(_loc5_)
         {
            if(param2 == "x")
            {
               _container.x = -int(_loc3_);
            }
            else
            {
               _container.y = -int(_loc3_);
            }
         }
         return param1;
      }
      
      private function alignPosition(param1:Point, param2:Boolean) : void
      {
         var _loc3_:* = null;
         if(_pageMode)
         {
            param1.x = alignByPage(param1.x,"x",param2);
            param1.y = alignByPage(param1.y,"y",param2);
         }
         else if(_snapToItem)
         {
            _loc3_ = _owner.getSnappingPosition(-param1.x,-param1.y,sHelperPoint);
            if(param1.x < 0 && param1.x > -_overlapSize.x)
            {
               param1.x = -_loc3_.x;
            }
            if(param1.y < 0 && param1.y > -_overlapSize.y)
            {
               param1.y = -_loc3_.y;
            }
         }
      }
      
      private function alignByPage(param1:Number, param2:String, param3:Boolean) : Number
      {
         var _loc9_:int = 0;
         var _loc6_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 > 0)
         {
            _loc9_ = 0;
         }
         else if(param1 < -_overlapSize[param2])
         {
            _loc9_ = Math.ceil(_contentSize[param2] / _pageSize[param2]) - 1;
         }
         else
         {
            _loc9_ = Math.floor(-param1 / _pageSize[param2]);
            _loc6_ = !!param3?param1 - _containerPos[param2]:Number(param1 - _container[param2]);
            _loc10_ = Math.min(_pageSize[param2],_contentSize[param2] - (_loc9_ + 1) * _pageSize[param2]);
            _loc8_ = -param1 - _loc9_ * _pageSize[param2];
            if(Math.abs(_loc6_) > _pageSize[param2])
            {
               if(_loc8_ > _loc10_ * 0.5)
               {
                  _loc9_++;
               }
            }
            else if(_loc8_ > _loc10_ * (_loc6_ < 0?0.3:0.7))
            {
               _loc9_++;
            }
            param1 = -_loc9_ * _pageSize[param2];
            if(param1 < -_overlapSize[param2])
            {
               param1 = -_overlapSize[param2];
            }
         }
         if(param3)
         {
            _loc7_ = _tweenStart[param2];
            if(_loc7_ > 0)
            {
               _loc4_ = 0;
            }
            else if(_loc7_ < -_overlapSize[param2])
            {
               _loc4_ = Math.ceil(_contentSize[param2] / _pageSize[param2]) - 1;
            }
            else
            {
               _loc4_ = Math.floor(-_loc7_ / _pageSize[param2]);
            }
            _loc5_ = Math.floor(-_containerPos[param2] / _pageSize[param2]);
            if(Math.abs(_loc9_ - _loc5_) > 1 && Math.abs(_loc4_ - _loc5_) <= 1)
            {
               if(_loc9_ > _loc5_)
               {
                  _loc9_ = _loc5_ + 1;
               }
               else
               {
                  _loc9_ = _loc5_ - 1;
               }
               param1 = -_loc9_ * _pageSize[param2];
            }
         }
         return param1;
      }
      
      private function updateTargetAndDuration(param1:Point, param2:Point) : void
      {
         param2.x = updateTargetAndDuration2(param1.x,"x");
         param2.y = updateTargetAndDuration2(param1.y,"y");
      }
      
      private function updateTargetAndDuration2(param1:Number, param2:String) : Number
      {
         var _loc6_:Number = NaN;
         var _loc7_:* = NaN;
         var _loc5_:int = 0;
         var _loc4_:Number = _velocity[param2];
         var _loc3_:* = 0;
         if(param1 > 0)
         {
            param1 = 0;
         }
         else if(param1 < -_overlapSize[param2])
         {
            param1 = Number(-_overlapSize[param2]);
         }
         else
         {
            _loc6_ = Math.abs(_loc4_) * _velocityScale;
            if(GRoot.touchPointInput)
            {
               _loc6_ = _loc6_ * (1136 / Math.max(GRoot.inst.nativeStage.stageWidth,GRoot.inst.nativeStage.stageHeight));
            }
            _loc7_ = 0;
            if(_pageMode || !GRoot.touchPointInput)
            {
               if(_loc6_ > 500)
               {
                  _loc7_ = Number(Math.pow((_loc6_ - 500) / 500,2));
               }
            }
            else if(_loc6_ > 1000)
            {
               _loc7_ = Number(Math.pow((_loc6_ - 1000) / 1000,2));
            }
            if(_loc7_ != 0)
            {
               if(_loc7_ > 1)
               {
                  _loc7_ = 1;
               }
               _loc6_ = _loc6_ * _loc7_;
               _loc4_ = _loc4_ * _loc7_;
               _velocity[param2] = _loc4_;
               _loc3_ = Number(Math.log(60 / _loc6_) / Math.log(_decelerationRate) / 60);
               _loc5_ = _loc4_ * _loc3_ * 0.4;
               param1 = Number(param1 + _loc5_);
            }
         }
         if(_loc3_ < 0.3)
         {
            _loc3_ = 0.3;
         }
         _tweenDuration[param2] = _loc3_;
         return param1;
      }
      
      private function fixDuration(param1:String, param2:Number) : void
      {
         if(_tweenChange[param1] == 0 || Math.abs(_tweenChange[param1]) >= Math.abs(param2))
         {
            return;
         }
         var _loc3_:* = Number(Math.abs(_tweenChange[param1] / param2) * _tweenDuration[param1]);
         if(_loc3_ < 0.3)
         {
            _loc3_ = 0.3;
         }
         _tweenDuration[param1] = _loc3_;
      }
      
      private function startTween(param1:int) : void
      {
         _tweenTime.setTo(0,0);
         _tweening = param1;
         GTimers.inst.callBy60Fps(tweenUpdate);
         updateScrollBarVisible();
      }
      
      private function killTween() : void
      {
         if(_tweening == 1)
         {
            _container.x = _tweenStart.x + _tweenChange.x;
            _container.y = _tweenStart.y + _tweenChange.y;
            dispatchEvent(new Event("scroll"));
         }
         _tweening = 0;
         GTimers.inst.remove(tweenUpdate);
         updateScrollBarVisible();
         dispatchEvent(new Event("scrollEnd"));
      }
      
      private function checkRefreshBar() : void
      {
         var _loc1_:* = null;
         var _loc3_:Number = NaN;
         if(_header == null && _footer == null)
         {
            return;
         }
         var _loc2_:Number = _container[_refreshBarAxis];
         if(_header != null)
         {
            if(_loc2_ > 0)
            {
               if(_header.displayObject.parent == null)
               {
                  _maskContainer.addChildAt(_header.displayObject,0);
               }
               _loc1_ = sHelperPoint;
               _loc1_.setTo(_header.width,_header.height);
               _loc1_[_refreshBarAxis] = _loc2_;
               _header.setSize(_loc1_.x,_loc1_.y);
            }
            else if(_header.displayObject.parent != null)
            {
               _maskContainer.removeChild(_header.displayObject);
            }
         }
         if(_footer != null)
         {
            _loc3_ = _overlapSize[_refreshBarAxis];
            if(_loc2_ < -_loc3_ || _loc3_ == 0 && _footerLockedSize > 0)
            {
               if(_footer.displayObject.parent == null)
               {
                  _maskContainer.addChildAt(_footer.displayObject,0);
               }
               _loc1_ = sHelperPoint;
               _loc1_.setTo(_footer.x,_footer.y);
               if(_loc3_ > 0)
               {
                  _loc1_[_refreshBarAxis] = _loc2_ + _contentSize[_refreshBarAxis];
               }
               else
               {
                  _loc1_[_refreshBarAxis] = Math.max(Math.min(_loc2_ + _viewSize[_refreshBarAxis],_viewSize[_refreshBarAxis] - _footerLockedSize),_viewSize[_refreshBarAxis] - _contentSize[_refreshBarAxis]);
               }
               _footer.setXY(_loc1_.x,_loc1_.y);
               _loc1_.setTo(_footer.width,_footer.height);
               if(_loc3_ > 0)
               {
                  _loc1_[_refreshBarAxis] = -_loc3_ - _loc2_;
               }
               else
               {
                  _loc1_[_refreshBarAxis] = _viewSize[_refreshBarAxis] - _footer[_refreshBarAxis];
               }
               _footer.setSize(_loc1_.x,_loc1_.y);
            }
            else if(_footer.displayObject.parent != null)
            {
               _maskContainer.removeChild(_footer.displayObject);
            }
         }
      }
      
      private function tweenUpdate() : void
      {
         var _loc1_:Number = runTween("x");
         var _loc2_:Number = runTween("y");
         _container.x = _loc1_;
         _container.y = _loc2_;
         if(_tweening == 2)
         {
            if(_overlapSize.x > 0)
            {
               _xPos = ToolSet.clamp(-_loc1_,0,_overlapSize.x);
            }
            if(_overlapSize.y > 0)
            {
               _yPos = ToolSet.clamp(-_loc2_,0,_overlapSize.y);
            }
            if(_pageMode)
            {
               updatePageController();
            }
         }
         if(_tweenChange.x == 0 && _tweenChange.y == 0)
         {
            _tweening = 0;
            GTimers.inst.remove(tweenUpdate);
            loopCheckingCurrent();
            updateScrollBarPos();
            updateScrollBarVisible();
            dispatchEvent(new Event("scroll"));
            dispatchEvent(new Event("scrollEnd"));
         }
         else
         {
            updateScrollBarPos();
            dispatchEvent(new Event("scroll"));
         }
      }
      
      private function runTween(param1:String) : Number
      {
         var _loc2_:* = NaN;
         var _loc6_:Number = NaN;
         var _loc4_:* = NaN;
         var _loc5_:Number = NaN;
         var _loc3_:Number = NaN;
         if(_tweenChange[param1] != 0)
         {
            var _loc7_:* = param1;
            var _loc8_:* = _tweenTime[_loc7_] + GTimers.deltaTime / 1000;
            _tweenTime[_loc7_] = _loc8_;
            if(_tweenTime[param1] >= _tweenDuration[param1])
            {
               _loc2_ = Number(_tweenStart[param1] + _tweenChange[param1]);
               _tweenChange[param1] = 0;
            }
            else
            {
               _loc6_ = easeFunc(_tweenTime[param1],_tweenDuration[param1]);
               _loc2_ = Number(_tweenStart[param1] + int(_tweenChange[param1] * _loc6_));
            }
            _loc4_ = 0;
            _loc5_ = -_overlapSize[param1];
            if(_headerLockedSize > 0 && _refreshBarAxis == param1)
            {
               _loc4_ = Number(_headerLockedSize);
            }
            if(_footerLockedSize > 0 && _refreshBarAxis == param1)
            {
               _loc3_ = _overlapSize[_refreshBarAxis];
               if(_loc3_ == 0)
               {
                  _loc3_ = Math.max(_contentSize[_refreshBarAxis] + _footerLockedSize - _viewSize[_refreshBarAxis],0);
               }
               else
               {
                  _loc3_ = _loc3_ + _footerLockedSize;
               }
               _loc5_ = -_loc3_;
            }
            if(_tweening == 2 && _bouncebackEffect)
            {
               if(_loc2_ > 20 + _loc4_ && _tweenChange[param1] > 0 || _loc2_ > _loc4_ && _tweenChange[param1] == 0)
               {
                  _tweenTime[param1] = 0;
                  _tweenDuration[param1] = 0.3;
                  _tweenChange[param1] = -_loc2_ + _loc4_;
                  _tweenStart[param1] = _loc2_;
               }
               else if(_loc2_ < _loc5_ - 20 && _tweenChange[param1] < 0 || _loc2_ < _loc5_ && _tweenChange[param1] == 0)
               {
                  _tweenTime[param1] = 0;
                  _tweenDuration[param1] = 0.3;
                  _tweenChange[param1] = _loc5_ - _loc2_;
                  _tweenStart[param1] = _loc2_;
               }
            }
            else if(_loc2_ > _loc4_)
            {
               _loc2_ = _loc4_;
               _tweenChange[param1] = 0;
            }
            else if(_loc2_ < _loc5_)
            {
               _loc2_ = _loc5_;
               _tweenChange[param1] = 0;
            }
         }
         else
         {
            _loc2_ = Number(_container[param1]);
         }
         return _loc2_;
      }
   }
}
