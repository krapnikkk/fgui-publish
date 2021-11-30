package fairygui
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Ease;
   import com.greensock.easing.EaseLookup;
   import fairygui.event.GTouchEvent;
   import fairygui.utils.GTimers;
   import fairygui.utils.ToolSet;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Mouse;
   import flash.utils.getTimer;
   
   public class ScrollPane extends EventDispatcher
   {
      
      private static var _easeTypeFunc:Ease;
      
      public static var draggingPane:ScrollPane;
      
      private static var _gestureFlag:int = 0;
      
      private static var sHelperPoint:Point = new Point();
      
      private static var sHelperRect:Rectangle = new Rectangle();
      
      public static const SCROLL_END:String = "scrollEnd";
      
      public static const PULL_DOWN_RELEASE:String = "pullDownRelease";
      
      public static const PULL_UP_RELEASE:String = "pullUpRelease";
       
      
      private var _owner:GComponent;
      
      private var _container:Sprite;
      
      private var _maskContainer:Sprite;
      
      private var _alignContainer:Sprite;
      
      private var _viewWidth:Number;
      
      private var _viewHeight:Number;
      
      private var _contentWidth:Number;
      
      private var _contentHeight:Number;
      
      private var _scrollType:int;
      
      private var _scrollSpeed:int;
      
      private var _mouseWheelSpeed:int;
      
      private var _scrollBarMargin:Margin;
      
      private var _bouncebackEffect:Boolean;
      
      private var _touchEffect:Boolean;
      
      private var _scrollBarDisplayAuto:Boolean;
      
      private var _vScrollNone:Boolean;
      
      private var _hScrollNone:Boolean;
      
      private var _displayOnLeft:Boolean;
      
      private var _snapToItem:Boolean;
      
      private var _displayInDemand:Boolean;
      
      private var _mouseWheelEnabled:Boolean;
      
      private var _pageMode:Boolean;
      
      private var _pageSizeH:Number;
      
      private var _pageSizeV:Number;
      
      private var _inertiaDisabled:Boolean;
      
      private var _maskDisabled:Boolean;
      
      private var _xPerc:Number;
      
      private var _yPerc:Number;
      
      private var _xPos:Number;
      
      private var _yPos:Number;
      
      private var _xOverlap:Number;
      
      private var _yOverlap:Number;
      
      private var _throwTween:ThrowTween;
      
      private var _tweening:int;
      
      private var _tweener:TweenLite;
      
      private var _time1:uint;
      
      private var _time2:uint;
      
      private var _y1:Number;
      
      private var _y2:Number;
      
      private var _x1:Number;
      
      private var _x2:Number;
      
      private var _xOffset:Number;
      
      private var _yOffset:Number;
      
      private var _needRefresh:Boolean;
      
      private var _holdAreaPoint:Point;
      
      private var _isHoldAreaDone:Boolean;
      
      private var _aniFlag:int;
      
      private var _scrollBarVisible:Boolean;
      
      private var _pageController:Controller;
      
      private var _hzScrollBar:GScrollBar;
      
      private var _vtScrollBar:GScrollBar;
      
      public var isDragged:Boolean;
      
      public function ScrollPane(param1:GComponent, param2:int, param3:Margin, param4:int, param5:int, param6:String, param7:String)
      {
         var _loc8_:* = null;
         super();
         if(_easeTypeFunc == null)
         {
            _easeTypeFunc = EaseLookup.find("Cubic.easeOut");
         }
         _throwTween = new ThrowTween();
         _owner = param1;
         param1.opaque = true;
         _scrollBarMargin = param3;
         _scrollType = param2;
         _scrollSpeed = UIConfig.defaultScrollSpeed;
         _mouseWheelSpeed = _scrollSpeed * 2;
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
         _maskDisabled = (param5 & 512) != 0;
         if(param4 == 0)
         {
            param4 = UIConfig.defaultScrollBarDisplay;
         }
         _xPerc = 0;
         _yPerc = 0;
         _xPos = 0;
         _yPos = 0;
         _xOverlap = 0;
         _yOverlap = 0;
         _scrollBarVisible = true;
         _mouseWheelEnabled = true;
         _holdAreaPoint = new Point();
         _pageSizeH = 1;
         _pageSizeV = 1;
         _maskContainer = new Sprite();
         _maskContainer.mouseEnabled = false;
         _owner._rootContainer.addChild(_maskContainer);
         _container = _owner._container;
         _container.x = 0;
         _container.y = 0;
         _container.mouseEnabled = false;
         _maskContainer.addChild(_container);
         if(!_maskDisabled)
         {
            _maskContainer.scrollRect = new Rectangle();
         }
         if(param4 != 3)
         {
            if(_scrollType == 2 || _scrollType == 1)
            {
               _loc8_ = !!param6?param6:UIConfig.verticalScrollBar;
               if(_loc8_)
               {
                  _vtScrollBar = UIPackage.createObjectFromURL(_loc8_) as GScrollBar;
                  if(!_vtScrollBar)
                  {
                     throw new Error("cannot create scrollbar from " + _loc8_);
                  }
                  _vtScrollBar.setScrollPane(this,true);
                  _owner._rootContainer.addChild(_vtScrollBar.displayObject);
               }
            }
            if(_scrollType == 2 || _scrollType == 0)
            {
               _loc8_ = !!param7?param7:UIConfig.horizontalScrollBar;
               if(_loc8_)
               {
                  _hzScrollBar = UIPackage.createObjectFromURL(_loc8_) as GScrollBar;
                  if(!_hzScrollBar)
                  {
                     throw new Error("cannot create scrollbar from " + _loc8_);
                  }
                  _hzScrollBar.setScrollPane(this,false);
                  _owner._rootContainer.addChild(_hzScrollBar.displayObject);
               }
            }
            _scrollBarDisplayAuto = param4 == 2;
            if(_scrollBarDisplayAuto)
            {
               _scrollBarVisible = false;
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
         _contentWidth = 0;
         _contentHeight = 0;
         setSize(param1.width,param1.height);
         _owner._rootContainer.addEventListener("mouseWheel",__mouseWheel);
         _owner.addEventListener("beginGTouch",__mouseDown);
         _owner.addEventListener("endGTouch",__mouseUp);
      }
      
      public function get owner() : GComponent
      {
         return _owner;
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
         _scrollSpeed = param1;
         if(_scrollSpeed == 0)
         {
            _scrollSpeed = UIConfig.defaultScrollSpeed;
         }
         _mouseWheelSpeed = _scrollSpeed * 2;
      }
      
      public function get scrollSpeed() : int
      {
         return _scrollSpeed;
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
      
      public function get percX() : Number
      {
         return _xPerc;
      }
      
      public function set percX(param1:Number) : void
      {
         setPercX(param1,false);
      }
      
      public function setPercX(param1:Number, param2:Boolean = false) : void
      {
         _owner.ensureBoundsCorrect();
         param1 = ToolSet.clamp01(param1);
         if(param1 != _xPerc)
         {
            _xPerc = param1;
            _xPos = _xPerc * _xOverlap;
            posChanged(param2);
         }
      }
      
      public function get percY() : Number
      {
         return _yPerc;
      }
      
      public function set percY(param1:Number) : void
      {
         setPercY(param1,false);
      }
      
      public function setPercY(param1:Number, param2:Boolean = false) : void
      {
         _owner.ensureBoundsCorrect();
         param1 = ToolSet.clamp01(param1);
         if(param1 != _yPerc)
         {
            _yPerc = param1;
            _yPos = _yPerc * _yOverlap;
            posChanged(param2);
         }
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
         param1 = ToolSet.clamp(param1,0,_xOverlap);
         if(param1 != _xPos)
         {
            _xPos = param1;
            _xPerc = _xOverlap == 0?0:_xPos / _xOverlap;
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
         param1 = ToolSet.clamp(param1,0,_yOverlap);
         if(param1 != _yPos)
         {
            _yPos = param1;
            _yPerc = _yOverlap == 0?0:_yPos / _yOverlap;
            posChanged(param2);
         }
      }
      
      public function get isBottomMost() : Boolean
      {
         return _yPerc == 1 || _yOverlap == 0;
      }
      
      public function get isRightMost() : Boolean
      {
         return _xPerc == 1 || _xOverlap == 0;
      }
      
      public function get currentPageX() : int
      {
         if(!_pageMode)
         {
            return 0;
         }
         var _loc1_:int = Math.floor(_xPos / _pageSizeH);
         if(_xPos - _loc1_ * _pageSizeH > _pageSizeH * 0.5)
         {
            _loc1_++;
         }
         return _loc1_;
      }
      
      public function set currentPageX(param1:int) : void
      {
         if(_pageMode && _xOverlap > 0)
         {
            this.setPosX(param1 * _pageSizeH,false);
         }
      }
      
      public function get currentPageY() : int
      {
         if(!_pageMode)
         {
            return 0;
         }
         var _loc1_:int = Math.floor(_yPos / _pageSizeV);
         if(_yPos - _loc1_ * _pageSizeV > _pageSizeV * 0.5)
         {
            _loc1_++;
         }
         return _loc1_;
      }
      
      public function set currentPageY(param1:int) : void
      {
         if(_pageMode && _yOverlap > 0)
         {
            this.setPosY(param1 * _pageSizeV,false);
         }
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
         return ToolSet.clamp(-_container.x,0,_xOverlap);
      }
      
      public function get scrollingPosY() : Number
      {
         return ToolSet.clamp(-_container.y,0,_yOverlap);
      }
      
      public function get contentWidth() : Number
      {
         return _contentWidth;
      }
      
      public function get contentHeight() : Number
      {
         return _contentHeight;
      }
      
      public function get viewWidth() : int
      {
         return _viewWidth;
      }
      
      public function set viewWidth(param1:int) : void
      {
         param1 = param1 + _owner.margin.left + _owner.margin.right;
         if(_vtScrollBar != null)
         {
            param1 = param1 + _vtScrollBar.width;
         }
         _owner.width = param1;
      }
      
      public function get viewHeight() : int
      {
         return _viewHeight;
      }
      
      public function set viewHeight(param1:int) : void
      {
         param1 = param1 + _owner.margin.top + _owner.margin.bottom;
         if(_hzScrollBar != null)
         {
            param1 = param1 + _hzScrollBar.height;
         }
         _owner.height = param1;
      }
      
      private function getDeltaX(param1:Number) : Number
      {
         return (!!_pageMode?_pageSizeH:param1) / (_contentWidth - _viewWidth);
      }
      
      private function getDeltaY(param1:Number) : Number
      {
         return (!!_pageMode?_pageSizeV:param1) / (_contentHeight - _viewHeight);
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
         this.setPercY(_yPerc - getDeltaY(_scrollSpeed * param1),param2);
      }
      
      public function scrollDown(param1:Number = 1, param2:Boolean = false) : void
      {
         this.setPercY(_yPerc + getDeltaY(_scrollSpeed * param1),param2);
      }
      
      public function scrollLeft(param1:Number = 1, param2:Boolean = false) : void
      {
         this.setPercX(_xPerc - getDeltaX(_scrollSpeed * param1),param2);
      }
      
      public function scrollRight(param1:Number = 1, param2:Boolean = false) : void
      {
         this.setPercX(_xPerc + getDeltaX(_scrollSpeed * param1),param2);
      }
      
      public function scrollToView(param1:*, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc5_:* = null;
         var _loc4_:Number = NaN;
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
               _loc5_ = _owner.globalToLocalRect(sHelperRect.x,sHelperRect.y,sHelperRect.width,sHelperRect.height,sHelperRect);
            }
            else
            {
               _loc5_ = sHelperRect;
               _loc5_.setTo(param1.x,param1.y,param1.width,param1.height);
            }
         }
         else
         {
            _loc5_ = Rectangle(param1);
         }
         if(_yOverlap > 0)
         {
            _loc4_ = _yPos + _viewHeight;
            if(param3 || _loc5_.y <= _yPos || _loc5_.height >= _viewHeight)
            {
               if(_pageMode)
               {
                  this.setPosY(Math.floor(_loc5_.y / _pageSizeV) * _pageSizeV,param2);
               }
               else
               {
                  this.setPosY(_loc5_.y,param2);
               }
            }
            else if(_loc5_.y + _loc5_.height > _loc4_)
            {
               if(_pageMode)
               {
                  this.setPosY(Math.floor(_loc5_.y / _pageSizeV) * _pageSizeV,param2);
               }
               else if(_loc5_.height <= _viewHeight / 2)
               {
                  this.setPosY(_loc5_.y + _loc5_.height * 2 - _viewHeight,param2);
               }
               else
               {
                  this.setPosY(_loc5_.y + _loc5_.height - _viewHeight,param2);
               }
            }
         }
         if(_xOverlap > 0)
         {
            _loc6_ = _xPos + _viewWidth;
            if(param3 || _loc5_.x <= _xPos || _loc5_.width >= _viewWidth)
            {
               if(_pageMode)
               {
                  this.setPosX(Math.floor(_loc5_.x / _pageSizeH) * _pageSizeH,param2);
               }
               else
               {
                  this.setPosX(_loc5_.x,param2);
               }
            }
            else if(_loc5_.x + _loc5_.width > _loc6_)
            {
               if(_pageMode)
               {
                  this.setPosX(Math.floor(_loc5_.x / _pageSizeH) * _pageSizeH,param2);
               }
               else if(_loc5_.width <= _viewWidth / 2)
               {
                  this.setPosX(_loc5_.x + _loc5_.width * 2 - _viewWidth,param2);
               }
               else
               {
                  this.setPosX(_loc5_.x + _loc5_.width - _viewWidth,param2);
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
         if(_yOverlap > 0)
         {
            _loc2_ = param1.y + _container.y;
            if(_loc2_ < -param1.height - 20 || _loc2_ > _viewHeight + 20)
            {
               return false;
            }
         }
         if(_xOverlap > 0)
         {
            _loc2_ = param1.x + _container.x;
            if(_loc2_ < -param1.width - 20 || _loc2_ > _viewWidth + 20)
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
               this.currentPageX = param1.selectedIndex;
            }
            else
            {
               this.currentPageY = param1.selectedIndex;
            }
         }
      }
      
      private function updatePageController() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         if(_pageController != null && !_pageController.changing)
         {
            if(_scrollType == 0)
            {
               _loc1_ = this.currentPageX;
            }
            else
            {
               _loc1_ = this.currentPageY;
            }
            if(_loc1_ < _pageController.pageCount)
            {
               _loc2_ = _pageController;
               _pageController = null;
               _loc2_.selectedIndex = _loc1_;
               _pageController = _loc2_;
            }
         }
      }
      
      function adjustMaskContainer() : void
      {
         var _loc2_:Number = NaN;
         var _loc1_:Number = NaN;
         if(_displayOnLeft && _vtScrollBar != null)
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
         _viewWidth = param1;
         _viewHeight = param2;
         if(_hzScrollBar && !_hScrollNone)
         {
            _viewHeight = _viewHeight - _hzScrollBar.height;
         }
         if(_vtScrollBar && !_vScrollNone)
         {
            _viewWidth = _viewWidth - _vtScrollBar.width;
         }
         _viewWidth = _viewWidth - (_owner.margin.left + _owner.margin.right);
         _viewHeight = _viewHeight - (_owner.margin.top + _owner.margin.bottom);
         _viewWidth = Math.max(1,_viewWidth);
         _viewHeight = Math.max(1,_viewHeight);
         _pageSizeH = _viewWidth;
         _pageSizeV = _viewHeight;
         handleSizeChanged();
      }
      
      function setContentSize(param1:Number, param2:Number) : void
      {
         if(_contentWidth == param1 && _contentHeight == param2)
         {
            return;
         }
         _contentWidth = param1;
         _contentHeight = param2;
         handleSizeChanged();
      }
      
      function changeContentSizeOnScrolling(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:Number = NaN;
         _contentWidth = _contentWidth + param1;
         _contentHeight = _contentHeight + param2;
         if(isDragged)
         {
            if(param3 != 0)
            {
               _container.x = _container.x - param3;
            }
            if(param4 != 0)
            {
               _container.y = _container.y - param4;
            }
            validateHolderPos();
            _xOffset = _xOffset + param3;
            _yOffset = _yOffset + param4;
            _loc5_ = _y2 - _y1;
            _y1 = _container.y;
            _y2 = _y1 + _loc5_;
            _loc5_ = _x2 - _x1;
            _x1 = _container.x;
            _x2 = _x1 + _loc5_;
            _yPos = -_container.y;
            _xPos = -_container.x;
         }
         else if(_tweening == 2)
         {
            if(param3 != 0)
            {
               _container.x = _container.x - param3;
               _throwTween.start.x = _throwTween.start.x - param3;
            }
            if(param4 != 0)
            {
               _container.y = _container.y - param4;
               _throwTween.start.y = _throwTween.start.y - param4;
            }
         }
         handleSizeChanged(true);
      }
      
      private function handleSizeChanged(param1:Boolean = false) : void
      {
         var _loc2_:* = null;
         if(_displayInDemand)
         {
            if(_vtScrollBar)
            {
               if(_contentHeight <= _viewHeight)
               {
                  if(!_vScrollNone)
                  {
                     _vScrollNone = true;
                     _viewWidth = _viewWidth + _vtScrollBar.width;
                  }
               }
               else if(_vScrollNone)
               {
                  _vScrollNone = false;
                  _viewWidth = _viewWidth - _vtScrollBar.width;
               }
            }
            if(_hzScrollBar)
            {
               if(_contentWidth <= _viewWidth)
               {
                  if(!_hScrollNone)
                  {
                     _hScrollNone = true;
                     _viewHeight = _viewHeight + _hzScrollBar.height;
                  }
               }
               else if(_hScrollNone)
               {
                  _hScrollNone = false;
                  _viewHeight = _viewHeight - _hzScrollBar.height;
               }
            }
         }
         if(_vtScrollBar)
         {
            if(_viewHeight < _vtScrollBar.minSize)
            {
               _vtScrollBar.displayObject.visible = false;
            }
            else
            {
               _vtScrollBar.displayObject.visible = _scrollBarVisible && !_vScrollNone;
               if(_contentHeight == 0)
               {
                  _vtScrollBar.displayPerc = 0;
               }
               else
               {
                  _vtScrollBar.displayPerc = Math.min(1,_viewHeight / _contentHeight);
               }
            }
         }
         if(_hzScrollBar)
         {
            if(_viewWidth < _hzScrollBar.minSize)
            {
               _hzScrollBar.displayObject.visible = false;
            }
            else
            {
               _hzScrollBar.displayObject.visible = _scrollBarVisible && !_hScrollNone;
               if(_contentWidth == 0)
               {
                  _hzScrollBar.displayPerc = 0;
               }
               else
               {
                  _hzScrollBar.displayPerc = Math.min(1,_viewWidth / _contentWidth);
               }
            }
         }
         if(!_maskDisabled)
         {
            _loc2_ = _maskContainer.scrollRect;
            _loc2_.width = _viewWidth;
            _loc2_.height = _viewHeight;
            _maskContainer.scrollRect = _loc2_;
         }
         if(_scrollType == 0 || _scrollType == 2)
         {
            _xOverlap = Math.ceil(Math.max(0,_contentWidth - _viewWidth));
         }
         else
         {
            _xOverlap = 0;
         }
         if(_scrollType == 1 || _scrollType == 2)
         {
            _yOverlap = Math.ceil(Math.max(0,_contentHeight - _viewHeight));
         }
         else
         {
            _yOverlap = 0;
         }
         if(_tweening == 0 && param1)
         {
            if(_xPerc == 0 || _xPerc == 1)
            {
               _xPos = _xPerc * _xOverlap;
               _container.x = -_xPos;
            }
            if(_yPerc == 0 || _yPerc == 1)
            {
               _yPos = _yPerc * _yOverlap;
               _container.y = -_yPos;
            }
         }
         else
         {
            _xPos = ToolSet.clamp(_xPos,0,_xOverlap);
            _xPerc = _xOverlap > 0?_xPos / _xOverlap:0;
            _yPos = ToolSet.clamp(_yPos,0,_yOverlap);
            _yPerc = _yOverlap > 0?_yPos / _yOverlap:0;
         }
         validateHolderPos();
         if(_vtScrollBar != null)
         {
            _vtScrollBar.scrollPerc = _yPerc;
         }
         if(_hzScrollBar != null)
         {
            _hzScrollBar.scrollPerc = _xPerc;
         }
         if(_pageMode)
         {
            updatePageController();
         }
      }
      
      private function validateHolderPos() : void
      {
         _container.x = ToolSet.clamp(_container.x,-_xOverlap,0);
         _container.y = ToolSet.clamp(_container.y,-_yOverlap,0);
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
         if(_tweening == 2)
         {
            killTween();
         }
      }
      
      private function killTween() : void
      {
         if(_tweening == 1)
         {
            _tweener.totalTime(_tweener.totalDuration());
         }
         else if(_tweening == 2)
         {
            _tweener.kill();
            _tweener = null;
            _tweening = 0;
            validateHolderPos();
            syncScrollBar(true);
            dispatchEvent(new Event("scrollEnd"));
         }
      }
      
      private function refresh() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         var _loc3_:* = null;
         _needRefresh = false;
         GTimers.inst.remove(refresh);
         if(_pageMode)
         {
            if(_yOverlap > 0 && _yPerc != 1 && _yPerc != 0)
            {
               _loc1_ = Math.floor(_yPos / _pageSizeV);
               _loc2_ = _yPos - _loc1_ * _pageSizeV;
               if(_loc2_ > _pageSizeV / 2)
               {
                  _loc1_++;
               }
               _yPos = _loc1_ * _pageSizeV;
               if(_yPos > _yOverlap)
               {
                  _yPos = _yOverlap;
                  _yPerc = 1;
               }
               else
               {
                  _yPerc = _yPos / _yOverlap;
               }
            }
            if(_xOverlap > 0 && _xPerc != 1 && _xPerc != 0)
            {
               _loc1_ = Math.floor(_xPos / _pageSizeH);
               _loc2_ = _xPos - _loc1_ * _pageSizeH;
               if(_loc2_ > _pageSizeH / 2)
               {
                  _loc1_++;
               }
               _xPos = _loc1_ * _pageSizeH;
               if(_xPos > _xOverlap)
               {
                  _xPos = _xOverlap;
                  _xPerc = 1;
               }
               else
               {
                  _xPerc = _xPos / _xOverlap;
               }
            }
         }
         else if(_snapToItem)
         {
            _loc3_ = _owner.getSnappingPosition(_xPerc == 1?0:_xPos,_yPerc == 1?0:_yPos,sHelperPoint);
            if(_xPerc != 1 && _loc3_.x != _xPos)
            {
               _xPos = _loc3_.x;
               _xPerc = _xPos / _xOverlap;
               if(_xPerc > 1)
               {
                  _xPerc = 1;
                  _xPos = _xOverlap;
               }
            }
            if(_yPerc != 1 && _loc3_.y != _yPos)
            {
               _yPos = _loc3_.y;
               _yPerc = _yPos / _yOverlap;
               if(_yPerc > 1)
               {
                  _yPerc = 1;
                  _yPos = _yOverlap;
               }
            }
         }
         refresh2();
         dispatchEvent(new Event("scroll"));
         if(_needRefresh)
         {
            _needRefresh = false;
            GTimers.inst.remove(refresh);
            refresh2();
         }
         _aniFlag = 0;
      }
      
      private function refresh2() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc4_:int = _xPos;
         var _loc3_:int = _yPos;
         if(_aniFlag == 1 && !isDragged)
         {
            _loc1_ = _container.x;
            _loc2_ = _container.y;
            if(_yOverlap > 0)
            {
               _loc2_ = -_loc3_;
            }
            else if(_container.y != 0)
            {
               _container.y = 0;
            }
            if(_xOverlap > 0)
            {
               _loc1_ = -_loc4_;
            }
            else if(_container.x != 0)
            {
               _container.x = 0;
            }
            if(_loc1_ != _container.x || _loc2_ != _container.y)
            {
               if(_tweener != null)
               {
                  _tweener.kill();
               }
               _maskContainer.mouseChildren = false;
               _tweening = 1;
               _tweener = TweenLite.to(_container,0.5,{
                  "x":_loc1_,
                  "y":_loc2_,
                  "onUpdate":__tweenUpdate,
                  "onComplete":__tweenComplete,
                  "ease":_easeTypeFunc
               });
            }
         }
         else
         {
            if(_tweener != null)
            {
               killTween();
            }
            if(isDragged)
            {
               _xOffset = _xOffset + (_container.x - -_loc4_);
               _yOffset = _yOffset + (_container.y - -_loc3_);
            }
            _container.y = -_loc3_;
            _container.x = -_loc4_;
            if(isDragged)
            {
               _y2 = _container.y;
               _y1 = _container.y;
               _x2 = _container.x;
               _x1 = _container.x;
            }
            if(_vtScrollBar)
            {
               _vtScrollBar.scrollPerc = _yPerc;
            }
            if(_hzScrollBar)
            {
               _hzScrollBar.scrollPerc = _xPerc;
            }
         }
         if(_pageMode)
         {
            updatePageController();
         }
      }
      
      private function syncPos() : void
      {
         if(_xOverlap > 0)
         {
            _xPos = ToolSet.clamp(-_container.x,0,_xOverlap);
            _xPerc = _xPos / _xOverlap;
         }
         if(_yOverlap > 0)
         {
            _yPos = ToolSet.clamp(-_container.y,0,_yOverlap);
            _yPerc = _yPos / _yOverlap;
         }
         if(_pageMode)
         {
            updatePageController();
         }
      }
      
      private function syncScrollBar(param1:Boolean = false) : void
      {
         if(param1)
         {
            if(_vtScrollBar)
            {
               if(_scrollBarDisplayAuto)
               {
                  showScrollBar(false);
               }
            }
            if(_hzScrollBar)
            {
               if(_scrollBarDisplayAuto)
               {
                  showScrollBar(false);
               }
            }
            _maskContainer.mouseChildren = true;
         }
         else
         {
            if(_vtScrollBar)
            {
               _vtScrollBar.scrollPerc = _yOverlap == 0?0:ToolSet.clamp(-_container.y,0,_yOverlap) / _yOverlap;
               if(_scrollBarDisplayAuto)
               {
                  showScrollBar(true);
               }
            }
            if(_hzScrollBar)
            {
               _hzScrollBar.scrollPerc = _xOverlap == 0?0:ToolSet.clamp(-_container.x,0,_xOverlap) / _xOverlap;
               if(_scrollBarDisplayAuto)
               {
                  showScrollBar(true);
               }
            }
         }
      }
      
      private function __mouseDown(param1:Event) : void
      {
         if(!_touchEffect)
         {
            return;
         }
         if(_tweener != null)
         {
            killTween();
            isDragged = true;
         }
         else
         {
            isDragged = false;
         }
         _x2 = _container.x;
         _x1 = _container.x;
         _y2 = _container.y;
         _y1 = _container.y;
         _xOffset = _maskContainer.mouseX - _container.x;
         _yOffset = _maskContainer.mouseY - _container.y;
         _time2 = getTimer();
         _time1 = getTimer();
         _holdAreaPoint.x = _maskContainer.mouseX;
         _holdAreaPoint.y = _maskContainer.mouseY;
         _isHoldAreaDone = false;
         _owner.addEventListener("dragGTouch",__mouseMove);
      }
      
      private function __mouseMove(param1:GTouchEvent) : void
      {
         var _loc5_:int = 0;
         var _loc4_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc8_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(!_touchEffect)
         {
            return;
         }
         if(draggingPane != null && draggingPane != this || GObject.draggingObject != null)
         {
            return;
         }
         if(GRoot.touchScreen)
         {
            _loc5_ = UIConfig.touchScrollSensitivity;
         }
         else
         {
            _loc5_ = 8;
         }
         if(_scrollType == 1)
         {
            if(!_isHoldAreaDone)
            {
               _gestureFlag = _gestureFlag | 1;
               _loc3_ = Math.abs(_holdAreaPoint.y - _maskContainer.mouseY);
               if(_loc3_ < _loc5_)
               {
                  return;
               }
               if((_gestureFlag & 2) != 0)
               {
                  _loc4_ = Math.abs(_holdAreaPoint.x - _maskContainer.mouseX);
                  if(_loc3_ < _loc4_)
                  {
                     return;
                  }
               }
            }
            _loc6_ = true;
         }
         else if(_scrollType == 0)
         {
            if(!_isHoldAreaDone)
            {
               _gestureFlag = _gestureFlag | 2;
               _loc3_ = Math.abs(_holdAreaPoint.x - _maskContainer.mouseX);
               if(_loc3_ < _loc5_)
               {
                  return;
               }
               if((_gestureFlag & 1) != 0)
               {
                  _loc4_ = Math.abs(_holdAreaPoint.y - _maskContainer.mouseY);
                  if(_loc3_ < _loc4_)
                  {
                     return;
                  }
               }
            }
            _loc8_ = true;
         }
         else
         {
            _gestureFlag = 3;
            if(!_isHoldAreaDone)
            {
               _loc3_ = Math.abs(_holdAreaPoint.y - _maskContainer.mouseY);
               if(_loc3_ < _loc5_)
               {
                  _loc3_ = Math.abs(_holdAreaPoint.x - _maskContainer.mouseX);
                  if(_loc3_ < _loc5_)
                  {
                     return;
                  }
               }
            }
            _loc8_ = true;
            _loc6_ = _loc8_;
         }
         var _loc2_:uint = getTimer();
         if(_loc2_ - _time2 > 50)
         {
            _time2 = _time1;
            _time1 = _loc2_;
            _loc7_ = true;
         }
         if(_loc6_)
         {
            _loc9_ = _maskContainer.mouseY - _yOffset;
            if(_loc9_ > 0)
            {
               if(!_bouncebackEffect || _inertiaDisabled)
               {
                  _container.y = 0;
               }
               else
               {
                  _container.y = int(_loc9_ * 0.5);
               }
            }
            else if(_loc9_ < -_yOverlap)
            {
               if(!_bouncebackEffect || _inertiaDisabled)
               {
                  _container.y = -int(_yOverlap);
               }
               else
               {
                  _container.y = int((_loc9_ - _yOverlap) * 0.5);
               }
            }
            else
            {
               _container.y = _loc9_;
            }
            if(_loc7_)
            {
               _y2 = _y1;
               _y1 = _container.y;
            }
         }
         if(_loc8_)
         {
            _loc10_ = _maskContainer.mouseX - _xOffset;
            if(_loc10_ > 0)
            {
               if(!_bouncebackEffect || _inertiaDisabled)
               {
                  _container.x = 0;
               }
               else
               {
                  _container.x = int(_loc10_ * 0.5);
               }
            }
            else if(_loc10_ < 0 - _xOverlap)
            {
               if(!_bouncebackEffect || _inertiaDisabled)
               {
                  _container.x = -int(_xOverlap);
               }
               else
               {
                  _container.x = int((_loc10_ - _xOverlap) * 0.5);
               }
            }
            else
            {
               _container.x = _loc10_;
            }
            if(_loc7_)
            {
               _x2 = _x1;
               _x1 = _container.x;
            }
         }
         draggingPane = this;
         _maskContainer.mouseChildren = false;
         _isHoldAreaDone = true;
         isDragged = true;
         syncPos();
         syncScrollBar();
         dispatchEvent(new Event("scroll"));
      }
      
      private function __mouseUp(param1:Event) : void
      {
         var _loc11_:int = 0;
         var _loc6_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc12_:* = null;
         _owner.removeEventListener("dragGTouch",__mouseMove);
         if(draggingPane == this)
         {
            draggingPane = null;
         }
         _gestureFlag = 0;
         if(!isDragged || !_touchEffect || _inertiaDisabled)
         {
            isDragged = false;
            _maskContainer.mouseChildren = true;
            return;
         }
         isDragged = false;
         _maskContainer.mouseChildren = true;
         var _loc8_:* = Number((getTimer() - _time2) / 1000);
         if(_loc8_ == 0)
         {
            _loc8_ = 0.001;
         }
         var _loc4_:Number = (_container.y - _y2) / _loc8_ * 2 * UIConfig.defaultTouchScrollSpeedRatio;
         var _loc7_:Number = (_container.x - _x2) / _loc8_ * 2 * UIConfig.defaultTouchScrollSpeedRatio;
         var _loc9_:* = 0.3;
         _throwTween.start.x = _container.x;
         _throwTween.start.y = _container.y;
         var _loc13_:Point = _throwTween.change1;
         var _loc14_:Point = _throwTween.change2;
         var _loc2_:* = 0;
         var _loc5_:* = 0;
         var _loc10_:int = 0;
         if(_scrollType == 2 || _scrollType == 0)
         {
            if(_container.x > UIConfig.touchDragSensitivity)
            {
               _loc10_ = 1;
            }
            else if(_container.x < -_xOverlap - UIConfig.touchDragSensitivity)
            {
               _loc10_ = 2;
            }
            _loc13_.x = ThrowTween.calculateChange(_loc7_,_loc9_);
            _loc14_.x = 0;
            _loc2_ = Number(_container.x + _loc13_.x);
            if(_pageMode && _loc2_ < 0 && _loc2_ > -_xOverlap)
            {
               _loc11_ = Math.floor(-_loc2_ / _pageSizeH);
               _loc3_ = Math.min(_pageSizeH,_contentWidth - (_loc11_ + 1) * _pageSizeH);
               _loc6_ = -_loc2_ - _loc11_ * _pageSizeH;
               if(Math.abs(_loc13_.x) > _pageSizeH)
               {
                  if(_loc6_ > _loc3_ * 0.5)
                  {
                     _loc11_++;
                  }
               }
               else if(_loc6_ > _loc3_ * (_loc13_.x < 0?0.3:0.7))
               {
                  _loc11_++;
               }
               _loc2_ = Number(-_loc11_ * _pageSizeH);
               if(_loc2_ < -_xOverlap)
               {
                  _loc2_ = Number(-_xOverlap);
               }
               _loc13_.x = _loc2_ - _container.x;
            }
         }
         else
         {
            var _loc15_:int = 0;
            _loc14_.x = _loc15_;
            _loc13_.x = _loc15_;
         }
         if(_scrollType == 2 || _scrollType == 1)
         {
            if(_container.y > UIConfig.touchDragSensitivity)
            {
               _loc10_ = 1;
            }
            else if(_container.y < -_yOverlap - UIConfig.touchDragSensitivity)
            {
               _loc10_ = 2;
            }
            _loc13_.y = ThrowTween.calculateChange(_loc4_,_loc9_);
            _loc14_.y = 0;
            _loc5_ = Number(_container.y + _loc13_.y);
            if(_pageMode && _loc5_ < 0 && _loc5_ > -_yOverlap)
            {
               _loc11_ = Math.floor(-_loc5_ / _pageSizeV);
               _loc3_ = Math.min(_pageSizeV,_contentHeight - (_loc11_ + 1) * _pageSizeV);
               _loc6_ = -_loc5_ - _loc11_ * _pageSizeV;
               if(Math.abs(_loc13_.y) > _pageSizeV)
               {
                  if(_loc6_ > _loc3_ * 0.5)
                  {
                     _loc11_++;
                  }
               }
               else if(_loc6_ > _loc3_ * (_loc13_.y < 0?0.3:0.7))
               {
                  _loc11_++;
               }
               _loc5_ = Number(-_loc11_ * _pageSizeV);
               if(_loc5_ < -_yOverlap)
               {
                  _loc5_ = Number(-_yOverlap);
               }
               _loc13_.y = _loc5_ - _container.y;
            }
         }
         else
         {
            _loc15_ = 0;
            _loc14_.y = _loc15_;
            _loc13_.y = _loc15_;
         }
         if(_snapToItem && !_pageMode)
         {
            _loc2_ = Number(-_loc2_);
            _loc5_ = Number(-_loc5_);
            _loc12_ = _owner.getSnappingPosition(_loc2_,_loc5_,sHelperPoint);
            _loc2_ = Number(-_loc12_.x);
            _loc5_ = Number(-_loc12_.y);
            _loc13_.x = _loc2_ - _container.x;
            _loc13_.y = _loc5_ - _container.y;
         }
         if(_bouncebackEffect)
         {
            if(_loc2_ > 0)
            {
               _loc14_.x = 0 - _container.x - _loc13_.x;
            }
            else if(_loc2_ < -_xOverlap)
            {
               _loc14_.x = -_xOverlap - _container.x - _loc13_.x;
            }
            if(_loc5_ > 0)
            {
               _loc14_.y = 0 - _container.y - _loc13_.y;
            }
            else if(_loc5_ < -_yOverlap)
            {
               _loc14_.y = -_yOverlap - _container.y - _loc13_.y;
            }
         }
         else
         {
            if(_loc2_ > 0)
            {
               _loc13_.x = 0 - _container.x;
            }
            else if(_loc2_ < -_xOverlap)
            {
               _loc13_.x = -_xOverlap - _container.x;
            }
            if(_loc5_ > 0)
            {
               _loc13_.y = 0 - _container.y;
            }
            else if(_loc5_ < -_yOverlap)
            {
               _loc13_.y = -_yOverlap - _container.y;
            }
         }
         _throwTween.value = 0;
         _throwTween.change1 = _loc13_;
         _throwTween.change2 = _loc14_;
         if(_tweener != null)
         {
            killTween();
         }
         _tweening = 2;
         _tweener = TweenLite.to(_throwTween,_loc9_,{
            "value":1,
            "onUpdate":__tweenUpdate2,
            "onComplete":__tweenComplete2,
            "ease":_easeTypeFunc
         });
         if(_loc10_ == 1)
         {
            dispatchEvent(new Event("pullDownRelease"));
         }
         else if(_loc10_ == 2)
         {
            dispatchEvent(new Event("pullUpRelease"));
         }
      }
      
      private function __mouseWheel(param1:MouseEvent) : void
      {
         if(!_mouseWheelEnabled && (!_vtScrollBar || !_vtScrollBar._rootContainer.hitTestObject(DisplayObject(param1.target))) && (!_hzScrollBar || !_hzScrollBar._rootContainer.hitTestObject(DisplayObject(param1.target))))
         {
            return;
         }
         var _loc2_:Number = param1.delta;
         if(_xOverlap > 0 && _yOverlap == 0)
         {
            if(_loc2_ < 0)
            {
               this.setPercX(_xPerc + getDeltaX(_mouseWheelSpeed),false);
            }
            else
            {
               this.setPercX(_xPerc - getDeltaX(_mouseWheelSpeed),false);
            }
         }
         else if(_loc2_ < 0)
         {
            this.setPercY(_yPerc + getDeltaY(_mouseWheelSpeed),false);
         }
         else
         {
            this.setPercY(_yPerc - getDeltaY(_mouseWheelSpeed),false);
         }
      }
      
      private function __rollOver(param1:Event) : void
      {
         showScrollBar(true);
      }
      
      private function __rollOut(param1:Event) : void
      {
         showScrollBar(false);
      }
      
      private function showScrollBar(param1:Boolean) : void
      {
         if(param1)
         {
            __showScrollBar(true);
            GTimers.inst.remove(__showScrollBar);
         }
         else
         {
            GTimers.inst.add(500,1,__showScrollBar,param1);
         }
      }
      
      private function __showScrollBar(param1:Boolean) : void
      {
         _scrollBarVisible = param1 && _viewWidth > 0 && _viewHeight > 0;
         if(_vtScrollBar)
         {
            _vtScrollBar.displayObject.visible = _scrollBarVisible && !_vScrollNone;
         }
         if(_hzScrollBar)
         {
            _hzScrollBar.displayObject.visible = _scrollBarVisible && !_hScrollNone;
         }
      }
      
      private function __tweenUpdate() : void
      {
         syncScrollBar();
         dispatchEvent(new Event("scroll"));
      }
      
      private function __tweenComplete() : void
      {
         _tweener = null;
         _tweening = 0;
         validateHolderPos();
         syncScrollBar(true);
         dispatchEvent(new Event("scroll"));
      }
      
      private function __tweenUpdate2() : void
      {
         _throwTween.update(_container);
         syncPos();
         syncScrollBar();
         dispatchEvent(new Event("scroll"));
      }
      
      private function __tweenComplete2() : void
      {
         _tweener = null;
         _tweening = 0;
         validateHolderPos();
         syncPos();
         syncScrollBar(true);
         dispatchEvent(new Event("scroll"));
         dispatchEvent(new Event("scrollEnd"));
      }
   }
}

import flash.display.DisplayObject;
import flash.geom.Point;

class ThrowTween
{
   
   private static var checkpoint:Number = 0.05;
    
   
   public var value:Number;
   
   public var start:Point;
   
   public var change1:Point;
   
   public var change2:Point;
   
   function ThrowTween()
   {
      super();
      start = new Point();
      change1 = new Point();
      change2 = new Point();
   }
   
   public static function calculateChange(param1:Number, param2:Number) : Number
   {
      return param2 * checkpoint * param1 / easeOutCubic(checkpoint,0,1,1);
   }
   
   public static function easeOutCubic(param1:Number, param2:Number, param3:Number, param4:Number) : Number
   {
      param1 = param1 / param4 - 1;
      return param3 * ((param1 / param4 - 1) * param1 * param1 + 1) + param2;
   }
   
   public function update(param1:DisplayObject) : void
   {
      param1.x = int(start.x + change1.x * value + change2.x * value * value);
      param1.y = int(start.y + change1.y * value + change2.y * value * value);
   }
}
