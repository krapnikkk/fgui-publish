package fairygui.editor.gui
{
   import fairygui.UIConfig;
   import fairygui.editor.utils.Utils;
   import fairygui.event.GTouchEvent;
   import fairygui.utils.GTimers;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   
   public class EScrollPane
   {
      
      public static const DISPLAY_ON_LEFT:int = 1;
      
      public static const SNAP_TO_ITEM:int = 2;
      
      public static const DISPLAY_IN_DEMAND:int = 4;
      
      public static const PAGE_MODE:int = 8;
      
      public static const TOUCH_EFFECT_ON:int = 16;
      
      public static const TOUCH_EFFECT_OFF:int = 32;
      
      public static const BOUNCE_BACK_EFFECT_ON:int = 64;
      
      public static const BOUNCE_BACK_EFFECT_OFF:int = 128;
      
      public static const INERTIA_DISABLED:int = 256;
      
      public static const MASK_DISABLED:int = 512;
      
      private static const TWEEN_TIME_GO:Number = 0.5;
      
      private static const TWEEN_TIME_DEFAULT:Number = 0.3;
      
      private static const PULL_RATIO:Number = 0.5;
      
      private static var draggingPane:EScrollPane;
      
      private static var _gestureFlag:int;
      
      private static var sHelperPoint:Point = new Point();
      
      private static var sEndPos:Point = new Point();
      
      private static var sOldChange:Point = new Point();
       
      
      private var _owner:EGComponent;
      
      private var _container:Sprite;
      
      private var _maskContainer:Sprite;
      
      private var _alignContainer:Sprite;
      
      private var _scrollType:String;
      
      private var _scrollStep:int;
      
      private var _mouseWheelStep:int;
      
      private var _decelerationRate:Number;
      
      private var _scrollBarMargin:EMargin;
      
      private var _bouncebackEffect:Boolean;
      
      private var _touchEffect:Boolean;
      
      private var _scrollBarDisplay:String;
      
      private var _vScrollNone:Boolean;
      
      private var _hScrollNone:Boolean;
      
      private var _displayOnLeft:Boolean;
      
      private var _snapToItem:Boolean;
      
      private var _displayInDemand:Boolean;
      
      private var _mouseWheelEnabled:Boolean;
      
      private var _pageMode:Boolean;
      
      private var _inertiaDisabled:Boolean;
      
      private var _maskDisabled:Boolean;
      
      private var _yPos:Number;
      
      private var _xPos:Number;
      
      private var _viewSize:Point;
      
      private var _contentSize:Point;
      
      private var _overlapSize:Point;
      
      private var _pageSize:Point;
      
      private var _tweening:int;
      
      private var _tweenTime:Point;
      
      private var _tweenDuration:Point;
      
      private var _tweenStart:Point;
      
      private var _tweenChange:Point;
      
      private var _isMouseMoved:Boolean;
      
      private var _isHoldAreaDone:Boolean;
      
      private var _aniFlag:int;
      
      private var _scrollBarVisible:Boolean;
      
      private var _containerPos:Point;
      
      private var _beginTouchPos:Point;
      
      private var _lastTouchPos:Point;
      
      private var _lastTouchGlobalPos:Point;
      
      private var _velocity:Point;
      
      private var _velocityScale:Number;
      
      private var _lastMoveTime:Number;
      
      private var _loop:int;
      
      private var _needRefresh:Boolean;
      
      private var _pageControllerFlag:Boolean;
      
      private var _hzScrollBar:EGScrollBar;
      
      private var _vtScrollBar:EGScrollBar;
      
      private var _header:EGComponent;
      
      private var _footer:EGComponent;
      
      private var _refreshBarAxis:String;
      
      private var _savedHzScrollBar:EGComponent;
      
      private var _savedVtScrollBar:EGComponent;
      
      private var _installed:Boolean;
      
      public function EScrollPane(param1:EGComponent)
      {
         super();
         this._owner = param1;
         this._maskContainer = new Sprite();
         this._maskContainer.mouseEnabled = false;
         this._xPos = 0;
         this._yPos = 0;
         this._aniFlag = 0;
         this._viewSize = new Point();
         this._contentSize = new Point();
         this._pageSize = new Point(1,1);
         this._overlapSize = new Point();
         this._tweenTime = new Point();
         this._tweenStart = new Point();
         this._tweenDuration = new Point();
         this._tweenChange = new Point();
         this._velocity = new Point();
         this._containerPos = new Point();
         this._beginTouchPos = new Point();
         this._lastTouchPos = new Point();
         this._lastTouchGlobalPos = new Point();
         this._scrollStep = UIConfig.defaultScrollSpeed;
         this._mouseWheelStep = this._scrollStep * 2;
         this._decelerationRate = 0.967;
         draggingPane = null;
         _gestureFlag = 0;
         this.install();
      }
      
      private static function easeFunc(param1:Number, param2:Number) : Number
      {
         param1 = param1 / param2 - 1;
         return (param1 / param2 - 1) * param1 * param1 + 1;
      }
      
      public function install() : void
      {
         if(this._installed)
         {
            return;
         }
         this._installed = true;
         this._owner.displayObject.rootContainer.addChild(this._maskContainer);
         this._container = this._owner.displayObject.container;
         this._container.x = 0;
         this._container.y = 0;
         this._container.mouseEnabled = false;
         this._maskContainer.addChild(this._container);
         var _loc1_:int = this._owner.scrollBarFlags;
         this._displayOnLeft = (_loc1_ & 1) != 0;
         this._snapToItem = (_loc1_ & 2) != 0;
         this._displayInDemand = this.owner.editMode == 1 && (_loc1_ & 4) != 0;
         this._pageMode = (_loc1_ & 8) != 0;
         if(_loc1_ & 32)
         {
            this._touchEffect = false;
         }
         else
         {
            this._touchEffect = true;
         }
         if(_loc1_ & 128)
         {
            this._bouncebackEffect = false;
         }
         else
         {
            this._bouncebackEffect = true;
         }
         this._scrollType = this._owner.scroll;
         this._mouseWheelEnabled = true;
         this._inertiaDisabled = (_loc1_ & 256) != 0;
         this._maskDisabled = (_loc1_ & 512) != 0;
         this._scrollBarMargin = this._owner.scrollBarMargin;
         this._scrollBarVisible = true;
         if(!this._maskDisabled)
         {
            this._maskContainer.scrollRect = new Rectangle();
         }
         this.createScrollBars();
         if(this._owner.editMode == 1)
         {
            if(this._owner.headerRes)
            {
               this._header = this.createHeaderOrFooter(this._owner.headerRes);
            }
            if(this._owner.footerRes)
            {
               this._footer = this.createHeaderOrFooter(this._owner.footerRes);
            }
            if(this._header || this._footer)
            {
               this._refreshBarAxis = this._scrollType == "both" || this._scrollType == "vertical"?"y":"x";
            }
         }
         this.setSize(this.owner.width,this.owner.height);
         if(this.owner.editMode == 1)
         {
            this._owner.displayObject.rootContainer.addEventListener("mouseWheel",this.__mouseWheel);
            this._owner.addEventListener("beginGTouch",this.__mouseDown);
            this._owner.addEventListener("endGTouch",this.__mouseUp);
         }
      }
      
      public function uninstall() : void
      {
         if(!this._installed)
         {
            return;
         }
         this._installed = false;
         if(this.owner.editMode == 1)
         {
            this._owner.displayObject.rootContainer.removeEventListener("mouseWheel",this.__mouseWheel);
            this._owner.removeEventListener("beginGTouch",this.__mouseDown);
            this._owner.removeEventListener("dragGTouch",this.__mouseMove);
            this._owner.removeEventListener("endGTouch",this.__mouseUp);
         }
         this._owner.displayObject.rootContainer.removeChild(this._maskContainer);
         if(this._vtScrollBar)
         {
            this._owner.displayObject.rootContainer.removeChild(this._vtScrollBar.owner.displayObject);
         }
         if(this._hzScrollBar)
         {
            this._owner.displayObject.rootContainer.removeChild(this._hzScrollBar.owner.displayObject);
         }
         this._container.x = 0;
         this._container.y = 0;
         this._owner.displayObject.rootContainer.addChild(this._container);
         if(draggingPane == this)
         {
            draggingPane = null;
         }
      }
      
      public function get installed() : Boolean
      {
         return this._installed;
      }
      
      private function createScrollBars() : void
      {
         var _loc2_:String = null;
         var _loc1_:EGComponent = null;
         if(this._hzScrollBar)
         {
            if(this._hzScrollBar.owner.displayObject.parent)
            {
               this._owner.displayObject.rootContainer.removeChild(this._hzScrollBar.owner.displayObject);
            }
            this._savedHzScrollBar = this._hzScrollBar.owner;
         }
         if(this._vtScrollBar)
         {
            if(this._vtScrollBar.owner.displayObject.parent)
            {
               this._owner.displayObject.rootContainer.removeChild(this._vtScrollBar.owner.displayObject);
            }
            this._savedVtScrollBar = this._vtScrollBar.owner;
         }
         this._hzScrollBar = null;
         this._vtScrollBar = null;
         var _loc3_:String = this._owner.scrollBarDisplay;
         if(_loc3_ == "default")
         {
            _loc3_ = this._owner.pkg.project.settingsCenter.common.defaultScrollBarDisplay;
         }
         if(_loc3_ != "hidden")
         {
            if(this._scrollType == "both" || this._scrollType == "vertical")
            {
               _loc2_ = !!this._owner.vtScrollBarRes?this._owner.vtScrollBarRes:this._owner.pkg.project.settingsCenter.common.verticalScrollBar;
               if(!this._savedVtScrollBar || this._savedVtScrollBar.resourceURL != _loc2_)
               {
                  _loc1_ = this.createScrollBar(_loc2_);
                  if(_loc1_)
                  {
                     this._vtScrollBar = EGScrollBar(_loc1_.extention);
                     this._vtScrollBar.setScrollPane(this,true);
                     this._owner.displayObject.rootContainer.addChild(_loc1_.displayObject);
                  }
               }
               else
               {
                  this._vtScrollBar = EGScrollBar(this._savedVtScrollBar.extention);
                  this._owner.displayObject.rootContainer.addChild(this._vtScrollBar.owner.displayObject);
               }
            }
            if(this._scrollType == "both" || this._scrollType == "horizontal")
            {
               _loc2_ = !!this._owner.hzScrollBarRes?this._owner.hzScrollBarRes:this._owner.pkg.project.settingsCenter.common.horizontalScrollBar;
               if(!this._savedHzScrollBar || this._savedHzScrollBar.resourceURL != _loc2_)
               {
                  _loc1_ = this.createScrollBar(_loc2_);
                  if(_loc1_)
                  {
                     this._hzScrollBar = EGScrollBar(_loc1_.extention);
                     this._hzScrollBar.setScrollPane(this,false);
                     this._owner.displayObject.rootContainer.addChild(_loc1_.displayObject);
                  }
               }
               else
               {
                  this._hzScrollBar = EGScrollBar(this._savedHzScrollBar.extention);
                  this._owner.displayObject.rootContainer.addChild(this._hzScrollBar.owner.displayObject);
               }
            }
            if(this._owner.editMode == 1)
            {
               if(this._scrollBarDisplay == "auto")
               {
                  this._scrollBarVisible = false;
                  if(this._vtScrollBar)
                  {
                     this._vtScrollBar.owner.displayObject.visible = false;
                  }
                  if(this._hzScrollBar)
                  {
                     this._hzScrollBar.owner.displayObject.visible = false;
                  }
                  this._owner.displayObject.rootContainer.addEventListener("rollOver",this.__rollOver);
                  this._owner.displayObject.rootContainer.addEventListener("rollOut",this.__rollOut);
               }
            }
         }
         else
         {
            this._mouseWheelEnabled = false;
         }
      }
      
      private function createScrollBar(param1:String) : EGComponent
      {
         var _loc3_:EPackageItem = null;
         var _loc2_:EGComponent = null;
         if(param1)
         {
            _loc3_ = this._owner.pkg.project.getItemByURL(param1);
            if(_loc3_ == null)
            {
               return null;
            }
            _loc2_ = EUIObjectFactory.createObject(_loc3_,this._owner.editMode == 1?1:0) as EGComponent;
            if(_loc2_ != null && !(_loc2_.extention is EGScrollBar))
            {
               _loc2_.dispose();
               _loc2_ = null;
            }
            return _loc2_;
         }
         return null;
      }
      
      private function createHeaderOrFooter(param1:String) : EGComponent
      {
         var _loc2_:EPackageItem = null;
         if(param1)
         {
            _loc2_ = this._owner.pkg.project.getItemByURL(param1);
            if(_loc2_ == null)
            {
               return null;
            }
            return EUIObjectFactory.createObject(_loc2_,this._owner.editMode == 1?1:0) as EGComponent;
         }
         return null;
      }
      
      public function get owner() : EGComponent
      {
         return this._owner;
      }
      
      public function get percX() : Number
      {
         return this._overlapSize.x == 0?0:Number(this._xPos / this._overlapSize.x);
      }
      
      public function set percX(param1:Number) : void
      {
         this.setPercX(param1,false);
      }
      
      public function setPercX(param1:Number, param2:Boolean = false) : void
      {
         this._owner.ensureBoundsCorrect();
         this.setPosX(this._overlapSize.x * Utils.clamp01(param1),param2);
      }
      
      public function get percY() : Number
      {
         return this._overlapSize.y == 0?0:Number(this._yPos / this._overlapSize.y);
      }
      
      public function set percY(param1:Number) : void
      {
         this.setPercY(param1,false);
      }
      
      public function setPercY(param1:Number, param2:Boolean = false) : void
      {
         this._owner.ensureBoundsCorrect();
         this.setPosY(this._overlapSize.y * Utils.clamp01(param1),param2);
      }
      
      public function get posX() : Number
      {
         return this._xPos;
      }
      
      public function set posX(param1:Number) : void
      {
         this.setPosX(param1,false);
      }
      
      public function setPosX(param1:Number, param2:Boolean = false) : void
      {
         this._owner.ensureBoundsCorrect();
         if(this._loop == 1 && this._overlapSize.x > 0)
         {
            if(param1 < 0.001)
            {
               param1 = param1 + this._contentSize.x / 2;
            }
            else if(param1 >= this._overlapSize.x)
            {
               param1 = param1 - this._contentSize.x / 2;
            }
         }
         param1 = Utils.clamp(param1,0,this._overlapSize.x);
         if(param1 != this._xPos)
         {
            this._xPos = param1;
            if(this._pageMode)
            {
               this.updatePageController();
            }
            this.posChanged(param2);
         }
      }
      
      public function get posY() : Number
      {
         return this._yPos;
      }
      
      public function set posY(param1:Number) : void
      {
         this.setPosY(param1,false);
      }
      
      public function setPosY(param1:Number, param2:Boolean = false) : void
      {
         this._owner.ensureBoundsCorrect();
         if(this._loop == 2 && this._overlapSize.y > 0)
         {
            if(param1 < 0.001)
            {
               param1 = param1 + this._contentSize.y / 2;
            }
            else if(param1 >= this._overlapSize.y)
            {
               param1 = param1 - this._contentSize.y / 2;
            }
         }
         param1 = Utils.clamp(param1,0,this._overlapSize.y);
         if(param1 != this._yPos)
         {
            this._yPos = param1;
            if(this._pageMode)
            {
               this.updatePageController();
            }
            this.posChanged(param2);
         }
      }
      
      public function get contentWidth() : Number
      {
         return this._contentSize.x;
      }
      
      public function get contentHeight() : Number
      {
         return this._contentSize.y;
      }
      
      public function get viewWidth() : int
      {
         return this._viewSize.x;
      }
      
      public function set viewWidth(param1:int) : void
      {
         param1 = param1 + this._owner.margin.left + this._owner.margin.right;
         if(this._vtScrollBar != null)
         {
            param1 = param1 + this._vtScrollBar.owner.width;
         }
         this._owner.width = param1;
      }
      
      public function get viewHeight() : int
      {
         return this._viewSize.y;
      }
      
      public function set viewHeight(param1:int) : void
      {
         param1 = param1 + this._owner.margin.top + this._owner.margin.bottom;
         if(this._hzScrollBar != null)
         {
            param1 = param1 + this._hzScrollBar.owner.height;
         }
         this._owner.height = param1;
      }
      
      public function get currentPageX() : int
      {
         if(!this._pageMode)
         {
            return 0;
         }
         var _loc1_:int = Math.floor(this._xPos / this._pageSize.x);
         if(this._xPos - _loc1_ * this._pageSize.x > this._pageSize.x * 0.5)
         {
            _loc1_++;
         }
         return _loc1_;
      }
      
      public function set currentPageX(param1:int) : void
      {
         if(this._pageMode && this._overlapSize.x > 0)
         {
            this.setPosX(param1 * this._pageSize.x,false);
         }
      }
      
      public function get currentPageY() : int
      {
         if(!this._pageMode)
         {
            return 0;
         }
         var _loc1_:int = Math.floor(this._yPos / this._pageSize.y);
         if(this._yPos - _loc1_ * this._pageSize.y > this._pageSize.y * 0.5)
         {
            _loc1_++;
         }
         return _loc1_;
      }
      
      public function set currentPageY(param1:int) : void
      {
         if(this._pageMode && this._overlapSize.y > 0)
         {
            this.setPosY(param1 * this._pageSize.y,false);
         }
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
         if(this._pageMode)
         {
            this.setPosY(this._yPos - this._pageSize.y * param1,param2);
         }
         else
         {
            this.setPosY(this._yPos - this._scrollStep * param1,param2);
         }
      }
      
      public function scrollDown(param1:Number = 1, param2:Boolean = false) : void
      {
         if(this._pageMode)
         {
            this.setPosY(this._yPos + this._pageSize.y * param1,param2);
         }
         else
         {
            this.setPosY(this._yPos + this._scrollStep * param1,param2);
         }
      }
      
      public function scrollLeft(param1:Number = 1, param2:Boolean = false) : void
      {
         if(this._pageMode)
         {
            this.setPosX(this._xPos - this._pageSize.x * param1,param2);
         }
         else
         {
            this.setPosX(this._xPos - this._scrollStep * param1,param2);
         }
      }
      
      public function scrollRight(param1:Number = 1, param2:Boolean = false) : void
      {
         if(this._pageMode)
         {
            this.setPosX(this._xPos + this._pageSize.x * param1,param2);
         }
         else
         {
            this.setPosX(this._xPos + this._scrollStep * param1,param2);
         }
      }
      
      public function scrollToView(param1:EGObject, param2:Boolean = false, param3:Boolean = false) : void
      {
         this._owner.ensureBoundsCorrect();
         if(this._needRefresh)
         {
            this.refresh();
         }
         var _loc4_:Rectangle = new Rectangle(param1.x,param1.y,param1.width,param1.height);
         this.scrollToView2(_loc4_,param2,param3);
      }
      
      public function scrollToView2(param1:Rectangle, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc5_:Number = NaN;
         var _loc4_:Number = NaN;
         this._owner.ensureBoundsCorrect();
         if(this._needRefresh)
         {
            this.refresh();
         }
         if(this._overlapSize.y > 0)
         {
            _loc5_ = this._yPos + this._viewSize.y;
            if(param3 || param1.y <= this._yPos || param1.height >= this._viewSize.y)
            {
               if(this._pageMode)
               {
                  this.setPosY(Math.floor(param1.y / this._pageSize.y) * this._pageSize.y,param2);
               }
               else
               {
                  this.setPosY(param1.y,param2);
               }
            }
            else if(param1.y + param1.height > _loc5_)
            {
               if(this._pageMode)
               {
                  this.setPosY(Math.floor(param1.y / this._pageSize.y) * this._pageSize.y,param2);
               }
               else if(param1.height <= this._viewSize.y / 2)
               {
                  this.setPosY(param1.y + param1.height * 2 - this._viewSize.y,param2);
               }
               else
               {
                  this.setPosY(param1.y + param1.height - this._viewSize.y,param2);
               }
            }
         }
         if(this._overlapSize.x > 0)
         {
            _loc4_ = this._xPos + this._viewSize.x;
            if(param3 || param1.x <= this._xPos || param1.width >= this._viewSize.x)
            {
               if(this._pageMode)
               {
                  this.setPosX(Math.floor(param1.x / this._pageSize.x) * this._pageSize.x,param2);
               }
               this.setPosX(param1.x,param2);
            }
            else if(param1.x + param1.width > _loc4_)
            {
               if(this._pageMode)
               {
                  this.setPosX(Math.floor(param1.x / this._pageSize.x) * this._pageSize.x,param2);
               }
               else if(param1.width <= this._viewSize.x / 2)
               {
                  this.setPosX(param1.x + param1.width * 2 - this._viewSize.x,param2);
               }
               else
               {
                  this.setPosX(param1.x + param1.width - this._viewSize.x,param2);
               }
            }
         }
         if(!param2 && this._needRefresh)
         {
            this.refresh();
         }
      }
      
      public function OnOwnerSizeChanged() : void
      {
         this.setSize(this._owner.width,this._owner.height);
         this.posChanged(false);
      }
      
      public function onFlagsChanged(param1:Boolean = false) : void
      {
         var _loc2_:int = this._owner.scrollBarFlags;
         this._displayOnLeft = (_loc2_ & 1) != 0;
         this._maskDisabled = (_loc2_ & 512) != 0;
         if(!this._maskDisabled)
         {
            this._maskContainer.scrollRect = new Rectangle();
         }
         else
         {
            this._maskContainer.scrollRect = null;
         }
         if(param1 || this._scrollType != this._owner.scroll || this._owner.scrollBarDisplay != this._scrollBarDisplay)
         {
            this._scrollType = this._owner.scroll;
            this._scrollBarDisplay = this._owner.scrollBarDisplay;
            this.createScrollBars();
         }
         this.setSize(this._owner.width,this._owner.height);
      }
      
      public function validate() : void
      {
         if(this._hzScrollBar)
         {
            this._hzScrollBar.owner.validate();
            if(!(this._hzScrollBar.owner.extention is EGScrollBar))
            {
               this._hzScrollBar = null;
            }
         }
         else if(this._savedHzScrollBar)
         {
            this._savedHzScrollBar.validate();
            if(!(this._savedHzScrollBar.extention is EGScrollBar))
            {
               this._savedHzScrollBar = null;
            }
         }
         if(this._vtScrollBar)
         {
            this._vtScrollBar.owner.validate();
            if(!(this._vtScrollBar.owner.extention is EGScrollBar))
            {
               this._vtScrollBar = null;
            }
         }
         else if(this._savedVtScrollBar)
         {
            this._savedVtScrollBar.validate();
            if(!(this._savedVtScrollBar.extention is EGScrollBar))
            {
               this._savedVtScrollBar = null;
            }
         }
      }
      
      public function updateScrollRect() : void
      {
         var _loc1_:Rectangle = null;
         if(this._displayOnLeft && this._vtScrollBar)
         {
            this._maskContainer.x = int(this._owner.margin.left + this._vtScrollBar.owner.width);
         }
         else
         {
            this._maskContainer.x = int(this._owner.margin.left);
         }
         this._maskContainer.y = int(this._owner.margin.top);
         if(!this._maskDisabled)
         {
            _loc1_ = this._maskContainer.scrollRect;
            _loc1_.width = this._viewSize.x;
            _loc1_.height = this._viewSize.y;
            this._maskContainer.scrollRect = _loc1_;
         }
         if(this._owner.alignOffset.x != 0 || this._owner.alignOffset.y != 0)
         {
            if(this._alignContainer == null)
            {
               this._alignContainer = new Sprite();
               this._alignContainer.mouseEnabled = false;
               this._maskContainer.addChild(this._alignContainer);
               this._alignContainer.addChild(this._container);
            }
            this._alignContainer.x = this._owner.alignOffset.x;
            this._alignContainer.y = this._owner.alignOffset.y;
         }
         else if(this._alignContainer)
         {
            var _loc2_:int = 0;
            this._alignContainer.y = _loc2_;
            this._alignContainer.x = _loc2_;
         }
      }
      
      private function setSize(param1:Number, param2:Number) : void
      {
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         _loc3_ = param1;
         _loc4_ = param2;
         if(this._hzScrollBar)
         {
            this._hzScrollBar.owner.y = param2 - this._hzScrollBar.owner.height;
            if(this._vtScrollBar)
            {
               this._hzScrollBar.owner.width = param1 - this._vtScrollBar.owner.width - this._scrollBarMargin.left - this._scrollBarMargin.right;
               if(this._displayOnLeft)
               {
                  this._hzScrollBar.owner.x = this._scrollBarMargin.left + this._vtScrollBar.owner.width;
               }
               else
               {
                  this._hzScrollBar.owner.x = this._scrollBarMargin.left;
               }
            }
            else
            {
               this._hzScrollBar.owner.width = param1 - this._scrollBarMargin.left - this._scrollBarMargin.right;
               this._hzScrollBar.owner.x = this._scrollBarMargin.left;
            }
         }
         if(this._vtScrollBar)
         {
            if(!this._displayOnLeft)
            {
               this._vtScrollBar.owner.x = param1 - this._vtScrollBar.owner.width;
            }
            else
            {
               this._vtScrollBar.owner.x = 0;
            }
            if(this._hzScrollBar != null)
            {
               this._vtScrollBar.owner.height = param2 - this._hzScrollBar.owner.height - this._scrollBarMargin.top - this._scrollBarMargin.bottom;
            }
            else
            {
               this._vtScrollBar.owner.height = param2 - this._scrollBarMargin.top - this._scrollBarMargin.bottom;
            }
            this._vtScrollBar.owner.y = this._scrollBarMargin.top;
         }
         this._viewSize.x = param1;
         this._viewSize.y = param2;
         if(this._hzScrollBar != null && !this._hScrollNone)
         {
            this._viewSize.y = this._viewSize.y - this._hzScrollBar.owner.height;
         }
         if(this._vtScrollBar != null && !this._vScrollNone)
         {
            this._viewSize.x = this._viewSize.x - this._vtScrollBar.owner.width;
         }
         this._viewSize.x = this._viewSize.x - (this._owner.margin.left + this._owner.margin.right);
         this._viewSize.y = this._viewSize.y - (this._owner.margin.top + this._owner.margin.bottom);
         this._viewSize.x = Math.max(1,this._viewSize.x);
         this._viewSize.y = Math.max(1,this._viewSize.y);
         this._pageSize.x = this._viewSize.x;
         this._pageSize.y = this._viewSize.y;
         this.handleSizeChanged();
      }
      
      function setContentSize(param1:Number, param2:Number) : void
      {
         if(this._contentSize.x == param1 && this._contentSize.y == param2)
         {
            return;
         }
         this._contentSize.x = param1;
         this._contentSize.y = param2;
         if(this._installed)
         {
            this.handleSizeChanged();
         }
      }
      
      private function handleSizeChanged() : void
      {
         if(this._displayInDemand)
         {
            if(this._vtScrollBar)
            {
               if(this._contentSize.y <= this._viewSize.y)
               {
                  if(!this._vScrollNone)
                  {
                     this._vScrollNone = true;
                     this._viewSize.x = this._viewSize.x + this._vtScrollBar.owner.width;
                  }
               }
               else if(this._vScrollNone)
               {
                  this._vScrollNone = false;
                  this._viewSize.x = this._viewSize.x - this._vtScrollBar.owner.width;
               }
            }
            if(this._hzScrollBar)
            {
               if(this._contentSize.x <= this._viewSize.x)
               {
                  if(!this._hScrollNone)
                  {
                     this._hScrollNone = true;
                     this._viewSize.y = this._viewSize.y + this._hzScrollBar.owner.height;
                  }
               }
               else if(this._hScrollNone)
               {
                  this._hScrollNone = false;
                  this._viewSize.y = this._viewSize.y - this._hzScrollBar.owner.height;
               }
            }
         }
         if(this._vtScrollBar)
         {
            if(this._viewSize.y < this._vtScrollBar.minSize)
            {
               this._vtScrollBar.owner.displayObject.visible = false;
            }
            else
            {
               this._vtScrollBar.owner.displayObject.visible = this._scrollBarVisible && !this._vScrollNone;
               if(this._contentSize.y == 0)
               {
                  this._vtScrollBar.displayPerc = 0;
               }
               else
               {
                  this._vtScrollBar.displayPerc = Math.min(1,this._viewSize.y / this._contentSize.y);
               }
            }
         }
         if(this._hzScrollBar)
         {
            if(this._viewSize.x < this._hzScrollBar.minSize)
            {
               this._hzScrollBar.owner.displayObject.visible = false;
            }
            else
            {
               this._hzScrollBar.owner.displayObject.visible = this._scrollBarVisible && !this._hScrollNone;
               if(this._contentSize.x == 0)
               {
                  this._hzScrollBar.displayPerc = 0;
               }
               else
               {
                  this._hzScrollBar.displayPerc = Math.min(1,this._viewSize.x / this._contentSize.x);
               }
            }
         }
         this.updateScrollRect();
         if(this._scrollType == "horizontal" || this._scrollType == "both")
         {
            this._overlapSize.x = Math.ceil(Math.max(0,this._contentSize.x - this._viewSize.x));
         }
         else
         {
            this._overlapSize.x = 0;
         }
         if(this._scrollType == "vertical" || this._scrollType == "both")
         {
            this._overlapSize.y = Math.ceil(Math.max(0,this._contentSize.y - this._viewSize.y));
         }
         else
         {
            this._overlapSize.y = 0;
         }
         this._xPos = Utils.clamp(this._xPos,0,this._overlapSize.x);
         this._yPos = Utils.clamp(this._yPos,0,this._overlapSize.y);
         this._container.x = Utils.clamp(this._container.x,-this._overlapSize.x,0);
         this._container.y = Utils.clamp(this._container.y,-this._overlapSize.y,0);
         if(this._header != null)
         {
            if(this._refreshBarAxis == "x")
            {
               this._header.height = this._viewSize.y;
            }
            else
            {
               this._header.width = this._viewSize.x;
            }
         }
         if(this._footer != null)
         {
            if(this._refreshBarAxis == "x")
            {
               this._footer.height = this._viewSize.y;
            }
            else
            {
               this._footer.width = this._viewSize.x;
            }
         }
         if(this._pageMode)
         {
            this.updatePageController();
         }
         this.syncScrollBar();
      }
      
      private function posChanged(param1:Boolean) : void
      {
         if(this.owner.editMode != 1)
         {
            return;
         }
         if(this._aniFlag == 0)
         {
            this._aniFlag = !!param1?1:-1;
         }
         else if(this._aniFlag == 1 && !param1)
         {
            this._aniFlag = -1;
         }
         this._needRefresh = true;
         GTimers.inst.callLater(this.refresh);
      }
      
      private function updatePageController() : void
      {
         var _loc1_:int = 0;
         if(this._pageMode && this.owner.editMode == 1 && this.owner.pageControllerObj && !this._pageControllerFlag)
         {
            _loc1_ = this._overlapSize.y > 0?int(this.currentPageY):int(this.currentPageX);
            if(_loc1_ < this.owner.pageControllerObj.pageCount)
            {
               this._pageControllerFlag = true;
               this.owner.pageControllerObj.selectedIndex = _loc1_;
               this._pageControllerFlag = false;
            }
         }
      }
      
      public function handleControllerChanged(param1:EController) : void
      {
         if(this._pageMode && this.owner.editMode == 1 && !this._pageControllerFlag)
         {
            this._pageControllerFlag = true;
            if(this._scrollType == "horizontal")
            {
               this.currentPageX = param1.selectedIndex;
            }
            else
            {
               this.currentPageY = param1.selectedIndex;
            }
            this._pageControllerFlag = false;
         }
      }
      
      private function refresh() : void
      {
         if(this._owner == null)
         {
            return;
         }
         this._needRefresh = false;
         if(this._pageMode || this._snapToItem)
         {
            sEndPos.setTo(-this._xPos,-this._yPos);
            this.alignPosition(sEndPos,false);
            this._xPos = -sEndPos.x;
            this._yPos = -sEndPos.y;
            if(this._pageMode)
            {
               this.updatePageController();
            }
         }
         if(this._isMouseMoved)
         {
            GTimers.inst.callLater(this.refresh);
            return;
         }
         this.refresh2();
         if(this._needRefresh)
         {
            this._needRefresh = false;
            GTimers.inst.remove(this.refresh);
            this.refresh2();
         }
         this.syncScrollBar();
         this._aniFlag = 0;
      }
      
      private function refresh2() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         if(this._aniFlag == 1 && !this._isMouseMoved)
         {
            if(this._overlapSize.x > 0)
            {
               _loc2_ = -int(this._xPos);
            }
            else
            {
               if(this._container.x != 0)
               {
                  this._container.x = 0;
               }
               _loc2_ = this._container.x;
            }
            if(this._overlapSize.y > 0)
            {
               _loc1_ = -int(this._yPos);
            }
            else
            {
               if(this._container.y != 0)
               {
                  this._container.y = 0;
               }
               _loc1_ = this._container.y;
            }
            if(_loc2_ != this._container.x || _loc1_ != this._container.y)
            {
               this._tweening = 1;
               this._tweenTime.setTo(0,0);
               this._tweenDuration.setTo(0.5,0.5);
               this._tweenStart.setTo(this._container.x,this._container.y);
               this._tweenChange.setTo(_loc2_ - this._tweenStart.x,_loc1_ - this._tweenStart.y);
               GTimers.inst.add(1,0,this.__tweenUpdate);
            }
            else if(this._tweening != 0)
            {
               this.killTween();
            }
         }
         else
         {
            if(this._tweening != 0)
            {
               this.killTween();
            }
            this._container.x = int(-this._xPos);
            this._container.y = int(-this._yPos);
            this.loopCheckingCurrent();
         }
      }
      
      private function syncScrollBar(param1:Boolean = false) : void
      {
         if(this._vtScrollBar != null)
         {
            this._vtScrollBar.scrollPerc = this._overlapSize.y == 0?0:Number(Utils.clamp(-this._container.y,0,this._overlapSize.y) / this._overlapSize.y);
            if(this._scrollBarDisplay == "auto")
            {
               this.showScrollBar(!param1);
            }
         }
         if(this._hzScrollBar != null)
         {
            this._hzScrollBar.scrollPerc = this._overlapSize.x == 0?0:Number(Utils.clamp(-this._container.x,0,this._overlapSize.x) / this._overlapSize.x);
            if(this._scrollBarDisplay == "auto")
            {
               this.showScrollBar(!param1);
            }
         }
      }
      
      private function __mouseDown(param1:GTouchEvent) : void
      {
         if(!this._touchEffect)
         {
            return;
         }
         if(this._tweening != 0)
         {
            this.killTween();
         }
         sHelperPoint.setTo(param1.stageX,param1.stageY);
         var _loc2_:Point = this._owner.displayObject.globalToLocal(sHelperPoint);
         this._containerPos.setTo(this._container.x,this._container.y);
         this._beginTouchPos.copyFrom(_loc2_);
         this._lastTouchPos.copyFrom(_loc2_);
         this._lastTouchGlobalPos.copyFrom(sHelperPoint);
         this._isHoldAreaDone = false;
         this._isMouseMoved = false;
         this._velocity.setTo(0,0);
         this._velocityScale = 1;
         this._lastMoveTime = getTimer();
         this._owner.addEventListener("dragGTouch",this.__mouseMove);
      }
      
      private function __mouseMove(param1:GTouchEvent) : void
      {
         var _loc8_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc11_:Number = NaN;
         if(this._owner == null || !this._touchEffect)
         {
            return;
         }
         sHelperPoint.setTo(param1.stageX,param1.stageY);
         var _loc9_:Point = this._owner.displayObject.globalToLocal(sHelperPoint);
         var _loc7_:int = 8;
         var _loc13_:Boolean = false;
         var _loc16_:Boolean = false;
         if(this._scrollType == "vertical")
         {
            if(!this._isHoldAreaDone)
            {
               _gestureFlag = _gestureFlag | 1;
               _loc8_ = Math.abs(this._beginTouchPos.y - _loc9_.y);
               if(_loc8_ < _loc7_)
               {
                  return;
               }
               if((_gestureFlag & 2) != 0)
               {
                  _loc12_ = Math.abs(this._beginTouchPos.x - _loc9_.x);
                  if(_loc8_ < _loc12_)
                  {
                     return;
                  }
               }
            }
            _loc13_ = true;
         }
         else if(this._scrollType == "horizontal")
         {
            if(!this._isHoldAreaDone)
            {
               _gestureFlag = _gestureFlag | 2;
               _loc8_ = Math.abs(this._beginTouchPos.x - _loc9_.x);
               if(_loc8_ < _loc7_)
               {
                  return;
               }
               if((_gestureFlag & 1) != 0)
               {
                  _loc12_ = Math.abs(this._beginTouchPos.y - _loc9_.y);
                  if(_loc8_ < _loc12_)
                  {
                     return;
                  }
               }
            }
            _loc16_ = true;
         }
         else
         {
            _gestureFlag = 3;
            if(!this._isHoldAreaDone)
            {
               _loc8_ = Math.abs(this._beginTouchPos.y - _loc9_.y);
               if(_loc8_ < _loc7_)
               {
                  _loc8_ = Math.abs(this._beginTouchPos.x - _loc9_.x);
                  if(_loc8_ < _loc7_)
                  {
                     return;
                  }
               }
            }
            _loc16_ = true;
            _loc13_ = _loc16_;
         }
         var _loc14_:int = this._containerPos.x + _loc9_.x - this._beginTouchPos.x;
         var _loc15_:int = this._containerPos.y + _loc9_.y - this._beginTouchPos.y;
         if(_loc13_)
         {
            if(_loc15_ > 0)
            {
               if(!this._bouncebackEffect || this._inertiaDisabled)
               {
                  this._container.y = 0;
               }
               else if(this._header && this._header.maxHeight > 0)
               {
                  this._container.y = int(Math.min(_loc15_ / 2,this._header.maxHeight));
               }
               else
               {
                  this._container.y = int(Math.min(_loc15_ / 2,this._viewSize.y * 0.5));
               }
            }
            else if(_loc15_ < -this._overlapSize.y)
            {
               if(!this._bouncebackEffect || this._inertiaDisabled)
               {
                  this._container.y = -this._overlapSize.y;
               }
               else if(this._footer && this._footer.maxHeight > 0)
               {
                  this._container.y = int(Math.max((_loc15_ + this._overlapSize.y) / 2,-this._footer.maxHeight)) - this._overlapSize.y;
               }
               else
               {
                  this._container.y = int(Math.max((_loc15_ + this._overlapSize.y) / 2,-this._viewSize.y * 0.5)) - this._overlapSize.y;
               }
            }
            else
            {
               this._container.y = _loc15_;
            }
         }
         if(_loc16_)
         {
            if(_loc14_ > 0)
            {
               if(!this._bouncebackEffect || this._inertiaDisabled)
               {
                  this._container.x = 0;
               }
               else if(this._header && this._header.maxWidth > 0)
               {
                  this._container.x = int(Math.min(_loc14_,this._header.maxWidth) * 0.5);
               }
               else
               {
                  this._container.x = int(Math.min(_loc14_,this._viewSize.x) * 0.5);
               }
            }
            else if(_loc14_ < 0 - this._overlapSize.x)
            {
               if(!this._bouncebackEffect || this._inertiaDisabled)
               {
                  this._container.x = -this._overlapSize.x;
               }
               else if(this._footer && this._footer.maxWidth > 0)
               {
                  this._container.x = int(Math.max(_loc14_ + this._overlapSize.x,-this._footer.maxWidth) * 0.5) - this._overlapSize.x;
               }
               else
               {
                  this._container.x = int(Math.max(_loc14_ + this._overlapSize.x,-this._viewSize.x) * 0.5) - this._overlapSize.x;
               }
            }
            else
            {
               this._container.x = _loc14_;
            }
         }
         var _loc3_:* = Number((getTimer() - this._lastMoveTime) / 1000);
         if(_loc3_ == 0)
         {
            _loc3_ = 0.001;
         }
         var _loc5_:Number = _loc3_ * 60 - 1;
         if(_loc5_ > 1)
         {
            _loc11_ = Math.pow(0.833,_loc5_);
            this._velocity.x = this._velocity.x * _loc11_;
            this._velocity.y = this._velocity.y * _loc11_;
         }
         var _loc4_:* = Number(_loc9_.x - this._lastTouchPos.x);
         var _loc6_:* = Number(_loc9_.y - this._lastTouchPos.y);
         if(!_loc16_)
         {
            _loc4_ = 0;
         }
         if(!_loc13_)
         {
            _loc6_ = 0;
         }
         this._velocity.x = this._velocity.x + (_loc4_ / _loc3_ - this._velocity.x) * _loc3_ * 10;
         this._velocity.y = this._velocity.y + (_loc6_ / _loc3_ - this._velocity.y) * _loc3_ * 10;
         var _loc2_:Number = this._lastTouchGlobalPos.x - sHelperPoint.x;
         var _loc10_:Number = this._lastTouchGlobalPos.y - sHelperPoint.y;
         if(_loc4_ != 0)
         {
            this._velocityScale = Math.abs(_loc2_ / _loc4_);
         }
         else if(_loc6_ != 0)
         {
            this._velocityScale = Math.abs(_loc10_ / _loc6_);
         }
         this._lastTouchPos.copyFrom(_loc9_);
         this._lastTouchGlobalPos.setTo(param1.stageX,param1.stageY);
         this._lastMoveTime = getTimer();
         if(this._overlapSize.x > 0)
         {
            this._xPos = Utils.clamp(-this._container.x,0,this._overlapSize.x);
         }
         if(this._overlapSize.y > 0)
         {
            this._yPos = Utils.clamp(-this._container.y,0,this._overlapSize.y);
         }
         if(this._pageMode)
         {
            this.updatePageController();
         }
         if(this._loop != 0)
         {
            _loc14_ = this._container.x;
            _loc15_ = this._container.y;
            if(this.loopCheckingCurrent())
            {
               this._containerPos.x = this._containerPos.x + (this._container.x - _loc14_);
               this._containerPos.y = this._containerPos.y + (this._container.y - _loc15_);
            }
         }
         draggingPane = this;
         this._isHoldAreaDone = true;
         if(!this._isMouseMoved)
         {
            this._isMouseMoved = true;
            this._owner.cancelChildrenClickEvent();
         }
         this.syncScrollBar();
         this.checkRefreshBar();
      }
      
      private function __mouseUp(param1:GTouchEvent) : void
      {
         var _loc2_:Number = NaN;
         if(this._owner == null)
         {
            return;
         }
         if(draggingPane == this)
         {
            draggingPane = null;
         }
         _gestureFlag = 0;
         if(!this._isMouseMoved || !this._touchEffect || this._inertiaDisabled)
         {
            this._isMouseMoved = false;
            return;
         }
         this._isMouseMoved = false;
         var _loc3_:Number = (getTimer() - this._lastMoveTime) / 1000 * 60 - 1;
         if(_loc3_ > 1)
         {
            _loc2_ = Math.pow(0.833,_loc3_);
            this._velocity.x = this._velocity.x * _loc2_;
            this._velocity.y = this._velocity.y * _loc2_;
         }
         this._tweenStart.setTo(this._container.x,this._container.y);
         this.updateTargetAndDuration(this._tweenStart,sEndPos);
         sOldChange.setTo(sEndPos.x - this._tweenStart.x,sEndPos.y - this._tweenStart.y);
         this.loopCheckingTarget(sEndPos);
         if(this._pageMode || this._snapToItem)
         {
            this.alignPosition(sEndPos,true);
         }
         this._tweenChange.setTo(sEndPos.x - this._tweenStart.x,sEndPos.y - this._tweenStart.y);
         if(this._tweenChange.x == 0 && this._tweenChange.y == 0)
         {
            return;
         }
         if(this._pageMode || this._snapToItem)
         {
            this.fixDuration("x",sOldChange.x);
            this.fixDuration("y",sOldChange.y);
         }
         this._tweening = 2;
         this._tweenTime.setTo(0,0);
         GTimers.inst.add(1,0,this.__tweenUpdate);
      }
      
      private function __mouseWheel(param1:MouseEvent) : void
      {
         if(!this._mouseWheelEnabled)
         {
            return;
         }
         var _loc2_:Number = param1.delta;
         _loc2_ = _loc2_ > 0?-1:1;
         if(this._overlapSize.x > 0 && this._overlapSize.y == 0)
         {
            if(this._pageMode)
            {
               this.setPosX(this._xPos + this._pageSize.x * _loc2_,false);
            }
            else
            {
               this.setPosX(this._xPos + this._mouseWheelStep * _loc2_,false);
            }
         }
         else if(this._pageMode)
         {
            this.setPosY(this._yPos + this._pageSize.y * _loc2_,false);
         }
         else
         {
            this.setPosY(this._yPos + this._mouseWheelStep * _loc2_,false);
         }
      }
      
      private function __rollOver(param1:Event) : void
      {
         this.showScrollBar(true);
      }
      
      private function __rollOut(param1:Event) : void
      {
         this.showScrollBar(false);
      }
      
      private function showScrollBar(param1:Boolean) : void
      {
         if(param1)
         {
            this.__showScrollBar(true);
            GTimers.inst.remove(this.__showScrollBar);
         }
         else
         {
            GTimers.inst.add(500,1,this.__showScrollBar,param1);
         }
      }
      
      private function __showScrollBar(param1:Boolean) : void
      {
         if(this._owner == null)
         {
            return;
         }
         this._scrollBarVisible = param1 && this._viewSize.x > 0 && this._viewSize.y > 0;
         if(this._vtScrollBar)
         {
            this._vtScrollBar.owner.displayObject.visible = this._scrollBarVisible && !this._vScrollNone;
         }
         if(this._hzScrollBar)
         {
            this._hzScrollBar.owner.displayObject.visible = this._scrollBarVisible && !this._hScrollNone;
         }
      }
      
      private function loopCheckingCurrent() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this._loop == 1 && this._overlapSize.x > 0)
         {
            if(this._xPos < 0.001)
            {
               this._xPos = this._xPos + this._contentSize.x / 2;
               _loc1_ = true;
            }
            else if(this._xPos >= this._overlapSize.x)
            {
               this._xPos = this._xPos - this._contentSize.x / 2;
               _loc1_ = true;
            }
         }
         else if(this._loop == 2 && this._overlapSize.y > 0)
         {
            if(this._yPos < 0.001)
            {
               this._yPos = this._yPos + this._contentSize.y / 2;
               _loc1_ = true;
            }
            else if(this._yPos >= this._overlapSize.y)
            {
               this._yPos = this._yPos + (this._contentSize.y / 2 - this._overlapSize.y);
               _loc1_ = true;
            }
         }
         if(_loc1_)
         {
            this._container.x = int(-this._xPos);
            this._container.y = int(-this._yPos);
            if(this._pageMode)
            {
               this.updatePageController();
            }
         }
         return _loc1_;
      }
      
      private function loopCheckingTarget(param1:Point) : void
      {
         if(this._loop == 1)
         {
            this.loopCheckingTarget2(param1,"x");
         }
         if(this._loop == 2)
         {
            this.loopCheckingTarget2(param1,"y");
         }
      }
      
      private function loopCheckingTarget2(param1:Point, param2:String) : void
      {
         var _loc3_:Number = NaN;
         if(param1[param2] > 0)
         {
            _loc3_ = this._tweenStart[param2] - this._contentSize[param2] / 2;
            if(_loc3_ <= 0 && _loc3_ >= -this._overlapSize[param2])
            {
               param1[param2] = param1[param2] - this._contentSize[param2] / 2;
               this._tweenStart[param2] = _loc3_;
            }
         }
         else if(param1[param2] < -this._overlapSize[param2])
         {
            _loc3_ = this._tweenStart[param2] + this._contentSize[param2] / 2;
            if(_loc3_ <= 0 && _loc3_ >= -this._overlapSize.x)
            {
               param1[param2] = param1[param2] + this._contentSize[param2] / 2;
               this._tweenStart[param2] = _loc3_;
            }
         }
      }
      
      private function alignPosition(param1:Point, param2:Boolean) : void
      {
         var _loc3_:Point = null;
         if(this._pageMode)
         {
            param1.x = this.alignByPage(param1.x,"x",param2);
            param1.y = this.alignByPage(param1.y,"y",param2);
         }
         else if(this._snapToItem)
         {
            _loc3_ = this._owner.getSnappingPosition(-param1.x,-param1.y,sHelperPoint);
            if(param1.x < 0 && param1.x > -this._overlapSize.x)
            {
               param1.x = -_loc3_.x;
            }
            if(param1.y < 0 && param1.y > -this._overlapSize.y)
            {
               param1.y = -_loc3_.y;
            }
         }
      }
      
      private function alignByPage(param1:Number, param2:String, param3:Boolean) : Number
      {
         var _loc10_:int = 0;
         var _loc4_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc7_:int = 0;
         var _loc5_:int = 0;
         if(param1 > 0)
         {
            _loc10_ = 0;
         }
         else if(param1 < -this._overlapSize[param2])
         {
            _loc10_ = Math.ceil(this._contentSize[param2] / this._pageSize[param2]) - 1;
         }
         else
         {
            _loc10_ = Math.floor(-param1 / this._pageSize[param2]);
            _loc4_ = !!param3?Number(param1 - this._containerPos[param2]):Number(param1 - this._container[param2]);
            _loc6_ = Math.min(this._pageSize[param2],this._contentSize[param2] - (_loc10_ + 1) * this._pageSize[param2]);
            _loc9_ = -param1 - _loc10_ * this._pageSize[param2];
            if(Math.abs(_loc4_) > this._pageSize[param2])
            {
               if(_loc9_ > _loc6_ * 0.5)
               {
                  _loc10_++;
               }
            }
            else if(_loc9_ > _loc6_ * (_loc4_ < 0?0.3:0.7))
            {
               _loc10_++;
            }
            param1 = -_loc10_ * this._pageSize[param2];
            if(param1 < -this._overlapSize[param2])
            {
               param1 = -this._overlapSize[param2];
            }
         }
         if(param3)
         {
            _loc8_ = this._tweenStart[param2];
            if(_loc8_ > 0)
            {
               _loc7_ = 0;
            }
            else if(_loc8_ < -this._overlapSize[param2])
            {
               _loc7_ = Math.ceil(this._contentSize[param2] / this._pageSize[param2]) - 1;
            }
            else
            {
               _loc7_ = Math.floor(-_loc8_ / this._pageSize[param2]);
            }
            _loc5_ = Math.floor(-this._containerPos[param2] / this._pageSize[param2]);
            if(Math.abs(_loc10_ - _loc5_) > 1 && Math.abs(_loc7_ - _loc5_) <= 1)
            {
               if(_loc10_ > _loc5_)
               {
                  _loc10_ = _loc5_ + 1;
               }
               else
               {
                  _loc10_ = _loc5_ - 1;
               }
               param1 = -_loc10_ * this._pageSize[param2];
            }
         }
         return param1;
      }
      
      private function updateTargetAndDuration(param1:Point, param2:Point) : void
      {
         param2.x = this.updateTargetAndDuration2(param1.x,"x");
         param2.y = this.updateTargetAndDuration2(param1.y,"y");
      }
      
      private function updateTargetAndDuration2(param1:Number, param2:String) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:Boolean = false;
         var _loc6_:* = NaN;
         var _loc5_:int = 0;
         var _loc7_:Number = this._velocity[param2];
         var _loc8_:* = 0;
         if(param1 > 0)
         {
            param1 = 0;
         }
         else if(param1 < -this._overlapSize[param2])
         {
            param1 = Number(-this._overlapSize[param2]);
         }
         else
         {
            _loc3_ = Math.abs(_loc7_) * this._velocityScale;
            _loc4_ = false;
            _loc6_ = 0;
            if(this._pageMode || !_loc4_)
            {
               if(_loc3_ > 500)
               {
                  _loc6_ = Number(Math.pow((_loc3_ - 500) / 500,2));
               }
            }
            else if(_loc3_ > 1000)
            {
               _loc6_ = Number(Math.pow((_loc3_ - 1000) / 1000,2));
            }
            if(_loc6_ != 0)
            {
               if(_loc6_ > 1)
               {
                  _loc6_ = 1;
               }
               _loc3_ = _loc3_ * _loc6_;
               _loc7_ = _loc7_ * _loc6_;
               this._velocity[param2] = _loc7_;
               _loc8_ = Number(Math.log(60 / _loc3_) / Math.log(this._decelerationRate) / 60);
               _loc5_ = _loc7_ * _loc8_ * 0.4;
               param1 = Number(param1 + _loc5_);
            }
         }
         if(_loc8_ < 0.3)
         {
            _loc8_ = 0.3;
         }
         this._tweenDuration[param2] = _loc8_;
         return param1;
      }
      
      private function fixDuration(param1:String, param2:Number) : void
      {
         if(this._tweenChange[param1] == 0 || Math.abs(this._tweenChange[param1]) >= Math.abs(param2))
         {
            return;
         }
         var _loc3_:* = Number(Math.abs(this._tweenChange[param1] / param2) * this._tweenDuration[param1]);
         if(_loc3_ < 0.3)
         {
            _loc3_ = 0.3;
         }
         this._tweenDuration[param1] = _loc3_;
      }
      
      private function killTween() : void
      {
         if(this._tweening == 1)
         {
            this._container.x = this._tweenStart.x + this._tweenChange.x;
            this._container.y = this._tweenStart.y + this._tweenChange.y;
         }
         this._tweening = 0;
         GTimers.inst.remove(this.__tweenUpdate);
      }
      
      private function checkRefreshBar() : void
      {
         var _loc2_:Point = null;
         var _loc1_:Number = NaN;
         if(this._header == null && this._footer == null)
         {
            return;
         }
         var _loc3_:Number = this._container[this._refreshBarAxis];
         if(this._header != null)
         {
            if(_loc3_ > 0)
            {
               if(this._header.displayObject.parent == null)
               {
                  this._maskContainer.addChildAt(this._header.displayObject,0);
               }
               _loc2_ = sHelperPoint;
               _loc2_.setTo(this._header.width,this._header.height);
               _loc2_[this._refreshBarAxis] = _loc3_;
               this._header.setSize(_loc2_.x,_loc2_.y);
            }
            else if(this._header.displayObject.parent != null)
            {
               this._maskContainer.removeChild(this._header.displayObject);
            }
         }
         if(this._footer != null)
         {
            _loc1_ = this._overlapSize[this._refreshBarAxis];
            if(_loc3_ < -_loc1_)
            {
               if(this._footer.displayObject.parent == null)
               {
                  this._maskContainer.addChildAt(this._footer.displayObject,0);
               }
               _loc2_ = sHelperPoint;
               _loc2_.setTo(this._footer.x,this._footer.y);
               if(_loc1_ > 0)
               {
                  _loc2_[this._refreshBarAxis] = _loc3_ + this._contentSize[this._refreshBarAxis];
               }
               else
               {
                  _loc2_[this._refreshBarAxis] = Math.max(Math.min(_loc3_ + this._viewSize[this._refreshBarAxis],this._viewSize[this._refreshBarAxis]),this._viewSize[this._refreshBarAxis] - this._contentSize[this._refreshBarAxis]);
               }
               this._footer.setXY(_loc2_.x,_loc2_.y);
               _loc2_.setTo(this._footer.width,this._footer.height);
               if(_loc1_ > 0)
               {
                  _loc2_[this._refreshBarAxis] = -_loc1_ - _loc3_;
               }
               else
               {
                  _loc2_[this._refreshBarAxis] = this._viewSize[this._refreshBarAxis] - this._footer[this._refreshBarAxis];
               }
               this._footer.setSize(_loc2_.x,_loc2_.y);
            }
            else if(this._footer.displayObject.parent != null)
            {
               this._maskContainer.removeChild(this._footer.displayObject);
            }
         }
      }
      
      private function __tweenUpdate() : void
      {
         if(this._owner == null)
         {
            GTimers.inst.remove(this.__tweenUpdate);
            return;
         }
         var _loc2_:Number = this.runTween("x");
         var _loc1_:Number = this.runTween("y");
         this._container.x = _loc2_;
         this._container.y = _loc1_;
         if(this._tweening == 2)
         {
            if(this._overlapSize.x > 0)
            {
               this._xPos = Utils.clamp(-_loc2_,0,this._overlapSize.x);
            }
            if(this._overlapSize.y > 0)
            {
               this._yPos = Utils.clamp(-_loc1_,0,this._overlapSize.y);
            }
            if(this._pageMode)
            {
               this.updatePageController();
            }
         }
         if(this._tweenChange.x == 0 && this._tweenChange.y == 0)
         {
            this._tweening = 0;
            GTimers.inst.remove(this.__tweenUpdate);
            this.loopCheckingCurrent();
            this.syncScrollBar(true);
            this.checkRefreshBar();
         }
         else
         {
            this.syncScrollBar(false);
            this.checkRefreshBar();
         }
      }
      
      private function runTween(param1:String) : Number
      {
         var _loc3_:* = NaN;
         var _loc2_:Number = NaN;
         if(this._tweenChange[param1] != 0)
         {
            this._tweenTime[param1] = this._tweenTime[param1] + GTimers.deltaTime / 1000;
            if(this._tweenTime[param1] >= this._tweenDuration[param1])
            {
               _loc3_ = Number(this._tweenStart[param1] + this._tweenChange[param1]);
               this._tweenChange[param1] = 0;
            }
            else
            {
               _loc2_ = easeFunc(this._tweenTime[param1],this._tweenDuration[param1]);
               _loc3_ = Number(this._tweenStart[param1] + int(this._tweenChange[param1] * _loc2_));
            }
            if(this._tweening == 2 && this._bouncebackEffect)
            {
               if(_loc3_ > 20 && this._tweenChange[param1] > 0 || _loc3_ > 0 && this._tweenChange[param1] == 0)
               {
                  this._tweenTime[param1] = 0;
                  this._tweenDuration[param1] = 0.3;
                  this._tweenChange[param1] = -_loc3_;
                  this._tweenStart[param1] = _loc3_;
               }
               else if(_loc3_ < -this._overlapSize[param1] - 20 && this._tweenChange[param1] < 0 || _loc3_ < -this._overlapSize[param1] && this._tweenChange[param1] == 0)
               {
                  this._tweenTime[param1] = 0;
                  this._tweenDuration[param1] = 0.3;
                  this._tweenChange[param1] = -this._overlapSize[param1] - _loc3_;
                  this._tweenStart[param1] = _loc3_;
               }
            }
            else if(_loc3_ > 0)
            {
               _loc3_ = 0;
               this._tweenChange[param1] = 0;
            }
            else if(_loc3_ < -this._overlapSize[param1])
            {
               _loc3_ = Number(-this._overlapSize[param1]);
               this._tweenChange[param1] = 0;
            }
         }
         else
         {
            _loc3_ = Number(this._container[param1]);
         }
         return _loc3_;
      }
   }
}
