package fairygui
{
   import fairygui.event.DragEvent;
   import fairygui.event.GTouchEvent;
   import fairygui.event.IBubbleEvent;
   import fairygui.utils.ColorMatrix;
   import fairygui.utils.GTimers;
   import fairygui.utils.SimpleDispatcher;
   import fairygui.utils.ToolSet;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TouchEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.ui.Mouse;
   import flash.utils.getTimer;
   
   public class GObject extends EventDispatcher
   {
      
      public static var draggingObject:GObject;
      
      static var _gInstanceCounter:uint;
      
      static const XY_CHANGED:int = 1;
      
      static const SIZE_CHANGED:int = 2;
      
      static const SIZE_DELAY_CHANGE:int = 3;
      
      private static var GearXMLKeys:Object = {
         "gearDisplay":0,
         "gearXY":1,
         "gearSize":2,
         "gearLook":3,
         "gearColor":4,
         "gearAni":5,
         "gearText":6,
         "gearIcon":7
      };
      
      private static const MTOUCH_EVENTS:Array = ["beginGTouch","dragGTouch","endGTouch","clickGTouch"];
      
      private static var sGlobalDragStart:Point = new Point();
      
      private static var sGlobalRect:Rectangle = new Rectangle();
      
      private static var sHelperPoint:Point = new Point();
      
      private static var sDragHelperRect:Rectangle = new Rectangle();
      
      private static var sUpdateInDragging:Boolean;
       
      
      public var data:Object;
      
      public var packageItem:PackageItem;
      
      public var sourceWidth:Number;
      
      public var sourceHeight:Number;
      
      public var initWidth:Number;
      
      public var initHeight:Number;
      
      public var minWidth:Number;
      
      public var minHeight:Number;
      
      public var maxWidth:Number;
      
      public var maxHeight:Number;
      
      private var _x:Number;
      
      private var _y:Number;
      
      private var _alpha:Number;
      
      private var _rotation:Number;
      
      private var _visible:Boolean;
      
      private var _touchable:Boolean;
      
      private var _grayed:Boolean;
      
      private var _draggable:Boolean;
      
      private var _scaleX:Number;
      
      private var _scaleY:Number;
      
      private var _pivotX:Number;
      
      private var _pivotY:Number;
      
      private var _pivotAsAnchor:Boolean;
      
      private var _pivotOffsetX:Number;
      
      private var _pivotOffsetY:Number;
      
      private var _sortingOrder:int;
      
      private var _internalVisible:Boolean;
      
      private var _handlingController:Boolean;
      
      private var _focusable:Boolean;
      
      private var _tooltips:String;
      
      private var _pixelSnapping:Boolean;
      
      private var _relations:Relations;
      
      private var _group:GGroup;
      
      private var _gears:Vector.<GearBase>;
      
      private var _displayObject:DisplayObject;
      
      private var _dragBounds:Rectangle;
      
      protected var _yOffset:int;
      
      protected var _sizeImplType:int;
      
      var _parent:GComponent;
      
      var _dispatcher:SimpleDispatcher;
      
      var _width:Number;
      
      var _height:Number;
      
      var _rawWidth:Number;
      
      var _rawHeight:Number;
      
      var _id:String;
      
      var _name:String;
      
      var _underConstruct:Boolean;
      
      var _gearLocked:Boolean;
      
      var _sizePercentInGroup:Number;
      
      private var _touchPointId:int;
      
      private var _lastClick:int;
      
      private var _buttonStatus:int;
      
      private var _touchDownPoint:Point;
      
      public function GObject()
      {
         super();
         _x = 0;
         _y = 0;
         _width = 0;
         _height = 0;
         _rawWidth = 0;
         _rawHeight = 0;
         sourceWidth = 0;
         sourceHeight = 0;
         initWidth = 0;
         initHeight = 0;
         minWidth = 0;
         minHeight = 0;
         maxWidth = 0;
         maxHeight = 0;
         _gInstanceCounter = Number(_gInstanceCounter) + 1;
         _id = "_n" + Number(_gInstanceCounter);
         _name = "";
         _alpha = 1;
         _rotation = 0;
         _visible = true;
         _internalVisible = true;
         _touchable = true;
         _scaleX = 1;
         _scaleY = 1;
         _pivotX = 0;
         _pivotY = 0;
         _pivotOffsetX = 0;
         _pivotOffsetY = 0;
         createDisplayObject();
         _relations = new Relations(this);
         _dispatcher = new SimpleDispatcher();
         _gears = new Vector.<GearBase>(8,true);
      }
      
      public final function get id() : String
      {
         return _id;
      }
      
      public final function get name() : String
      {
         return _name;
      }
      
      public final function set name(param1:String) : void
      {
         _name = param1;
      }
      
      public final function get x() : Number
      {
         return _x;
      }
      
      public final function set x(param1:Number) : void
      {
         setXY(param1,_y);
      }
      
      public final function get y() : Number
      {
         return _y;
      }
      
      public final function set y(param1:Number) : void
      {
         setXY(_x,param1);
      }
      
      public final function setXY(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(_x != param1 || _y != param2)
         {
            _loc3_ = param1 - _x;
            _loc4_ = param2 - _y;
            _x = param1;
            _y = param2;
            handlePositionChanged();
            if(this is GGroup)
            {
               GGroup(this).moveChildren(_loc3_,_loc4_);
            }
            updateGear(1);
            if(parent != null && !(parent is GList))
            {
               _parent.setBoundsChangedFlag();
               if(_group != null)
               {
                  _group.setBoundsChangedFlag();
               }
               _dispatcher.dispatch(this,1);
            }
            if(draggingObject == this && !sUpdateInDragging)
            {
               this.localToGlobalRect(0,0,this.width,this.height,sGlobalRect);
            }
         }
      }
      
      public function get pixelSnapping() : Boolean
      {
         return _pixelSnapping;
      }
      
      public function set pixelSnapping(param1:Boolean) : void
      {
         if(_pixelSnapping != param1)
         {
            _pixelSnapping = param1;
            handlePositionChanged();
         }
      }
      
      public function center(param1:Boolean = false) : void
      {
         var _loc2_:* = null;
         if(parent != null)
         {
            _loc2_ = parent;
         }
         else
         {
            _loc2_ = this.root;
         }
         this.setXY(int((_loc2_.width - this.width) / 2),int((_loc2_.height - this.height) / 2));
         if(param1)
         {
            this.addRelation(_loc2_,3);
            this.addRelation(_loc2_,10);
         }
      }
      
      public final function get width() : Number
      {
         if(!this._underConstruct)
         {
            ensureSizeCorrect();
            if(_relations.sizeDirty)
            {
               _relations.ensureRelationsSizeCorrect();
            }
         }
         return _width;
      }
      
      public final function set width(param1:Number) : void
      {
         setSize(param1,_rawHeight);
      }
      
      public final function get height() : Number
      {
         if(!this._underConstruct)
         {
            ensureSizeCorrect();
            if(_relations.sizeDirty)
            {
               _relations.ensureRelationsSizeCorrect();
            }
         }
         return _height;
      }
      
      public final function set height(param1:Number) : void
      {
         setSize(_rawWidth,param1);
      }
      
      public function setSize(param1:Number, param2:Number, param3:Boolean = false) : void
      {
         var _loc5_:Number = NaN;
         var _loc4_:Number = NaN;
         if(_rawWidth != param1 || _rawHeight != param2)
         {
            _rawWidth = param1;
            _rawHeight = param2;
            if(param1 < minWidth)
            {
               param1 = minWidth;
            }
            if(param2 < minHeight)
            {
               param2 = minHeight;
            }
            if(maxWidth > 0 && param1 > maxWidth)
            {
               param1 = maxWidth;
            }
            if(maxHeight > 0 && param2 > maxHeight)
            {
               param2 = maxHeight;
            }
            _loc5_ = param1 - _width;
            _loc4_ = param2 - _height;
            _width = param1;
            _height = param2;
            handleSizeChanged();
            if(_pivotX != 0 || _pivotY != 0)
            {
               if(!_pivotAsAnchor)
               {
                  if(!param3)
                  {
                     this.setXY(this.x - _pivotX * _loc5_,this.y - _pivotY * _loc4_);
                  }
                  updatePivotOffset();
               }
               else
               {
                  applyPivot();
               }
            }
            if(this is GGroup)
            {
               GGroup(this).resizeChildren(_loc5_,_loc4_);
            }
            updateGear(2);
            if(_parent)
            {
               _parent.setBoundsChangedFlag();
               _relations.onOwnerSizeChanged(_loc5_,_loc4_);
               if(_group != null)
               {
                  _group.setBoundsChangedFlag(true);
               }
            }
            _dispatcher.dispatch(this,2);
         }
      }
      
      public function ensureSizeCorrect() : void
      {
      }
      
      public final function get actualWidth() : Number
      {
         return this.width * _scaleX;
      }
      
      public final function get actualHeight() : Number
      {
         return this.height * _scaleY;
      }
      
      public final function get scaleX() : Number
      {
         return _scaleX;
      }
      
      public final function set scaleX(param1:Number) : void
      {
         setScale(param1,_scaleY);
      }
      
      public final function get scaleY() : Number
      {
         return _scaleY;
      }
      
      public final function set scaleY(param1:Number) : void
      {
         setScale(_scaleX,param1);
      }
      
      public final function setScale(param1:Number, param2:Number) : void
      {
         if(_scaleX != param1 || _scaleY != param2)
         {
            _scaleX = param1;
            _scaleY = param2;
            handleScaleChanged();
            applyPivot();
            updateGear(2);
         }
      }
      
      public final function get pivotX() : Number
      {
         return _pivotX;
      }
      
      public final function set pivotX(param1:Number) : void
      {
         setPivot(param1,_pivotY);
      }
      
      public final function get pivotY() : Number
      {
         return _pivotY;
      }
      
      public final function set pivotY(param1:Number) : void
      {
         setPivot(_pivotX,param1);
      }
      
      public final function setPivot(param1:Number, param2:Number, param3:Boolean = false) : void
      {
         if(_pivotX != param1 || _pivotY != param2 || _pivotAsAnchor != param3)
         {
            _pivotX = param1;
            _pivotY = param2;
            _pivotAsAnchor = param3;
            updatePivotOffset();
            handlePositionChanged();
         }
      }
      
      protected function internalSetPivot(param1:Number, param2:Number, param3:Boolean) : void
      {
         _pivotX = param1;
         _pivotY = param2;
         _pivotAsAnchor = param3;
         if(_pivotAsAnchor)
         {
            handlePositionChanged();
         }
      }
      
      private function updatePivotOffset() : void
      {
         var _loc2_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc1_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc5_:Number = NaN;
         if(_pivotX != 0 || _pivotY != 0)
         {
            _loc2_ = this.normalizeRotation;
            if(_loc2_ != 0 || _scaleX != 1 || _scaleY != 1)
            {
               _loc10_ = _loc2_ * 0.0174532925199433;
               _loc7_ = Math.cos(_loc10_);
               _loc8_ = Math.sin(_loc10_);
               _loc9_ = _scaleX * _loc7_;
               _loc4_ = _scaleX * _loc8_;
               _loc6_ = _scaleY * -_loc8_;
               _loc1_ = _scaleY * _loc7_;
               _loc3_ = _pivotX * _width;
               _loc5_ = _pivotY * _height;
               _pivotOffsetX = _loc3_ - (_loc9_ * _loc3_ + _loc6_ * _loc5_);
               _pivotOffsetY = _loc5_ - (_loc1_ * _loc5_ + _loc4_ * _loc3_);
            }
            else
            {
               _pivotOffsetX = 0;
               _pivotOffsetY = 0;
            }
         }
         else
         {
            _pivotOffsetX = 0;
            _pivotOffsetY = 0;
         }
      }
      
      private function applyPivot() : void
      {
         if(_pivotX != 0 || _pivotY != 0)
         {
            updatePivotOffset();
            handlePositionChanged();
         }
      }
      
      public final function get touchable() : Boolean
      {
         return _touchable;
      }
      
      public function set touchable(param1:Boolean) : void
      {
         if(_touchable != param1)
         {
            _touchable = param1;
            updateGear(3);
            if(this is GImage || this is GMovieClip || this is GTextField && !(this is GTextInput) && !(this is GRichTextField))
            {
               return;
            }
            if(_displayObject is InteractiveObject)
            {
               if(this is GComponent)
               {
                  GComponent(this).handleTouchable(_touchable);
               }
               else
               {
                  InteractiveObject(_displayObject).mouseEnabled = _touchable;
                  if(_displayObject is DisplayObjectContainer)
                  {
                     DisplayObjectContainer(_displayObject).mouseChildren = _touchable;
                  }
               }
            }
         }
      }
      
      public final function get grayed() : Boolean
      {
         return _grayed;
      }
      
      public function set grayed(param1:Boolean) : void
      {
         if(_grayed != param1)
         {
            _grayed = param1;
            handleGrayedChanged();
            updateGear(3);
         }
      }
      
      public final function get enabled() : Boolean
      {
         return !_grayed && _touchable;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         this.grayed = !param1;
         this.touchable = param1;
      }
      
      public final function get rotation() : Number
      {
         return _rotation;
      }
      
      public function set rotation(param1:Number) : void
      {
         if(_rotation != param1)
         {
            _rotation = param1;
            if(_displayObject)
            {
               _displayObject.rotation = this.normalizeRotation;
            }
            applyPivot();
            updateGear(3);
         }
      }
      
      public function get normalizeRotation() : Number
      {
         var _loc1_:Number = _rotation % 360;
         if(_loc1_ > 180)
         {
            _loc1_ = _loc1_ - 360;
         }
         else if(_loc1_ < -180)
         {
            _loc1_ = 360 + _loc1_;
         }
         return _loc1_;
      }
      
      public final function get alpha() : Number
      {
         return _alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         if(_alpha != param1)
         {
            _alpha = param1;
            updateAlpha();
         }
      }
      
      protected function updateAlpha() : void
      {
         if(_displayObject)
         {
            _displayObject.alpha = _alpha;
         }
         updateGear(3);
      }
      
      public final function get visible() : Boolean
      {
         return _visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         if(_visible != param1)
         {
            _visible = param1;
            if(_displayObject)
            {
               _displayObject.visible = _visible;
            }
            if(_parent)
            {
               _parent.childStateChanged(this);
               _parent.setBoundsChangedFlag();
            }
         }
      }
      
      public function get finalVisible() : Boolean
      {
         return _visible && _internalVisible && (!_group || _group.finalVisible);
      }
      
      public final function get sortingOrder() : int
      {
         return _sortingOrder;
      }
      
      public function set sortingOrder(param1:int) : void
      {
         var _loc2_:int = 0;
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(_sortingOrder != param1)
         {
            _loc2_ = _sortingOrder;
            _sortingOrder = param1;
            if(_parent != null)
            {
               _parent.childSortingOrderChanged(this,_loc2_,_sortingOrder);
            }
         }
      }
      
      public final function get focusable() : Boolean
      {
         return _focusable;
      }
      
      public function set focusable(param1:Boolean) : void
      {
         _focusable = param1;
      }
      
      public function get focused() : Boolean
      {
         return this.root.focus == this;
      }
      
      public function requestFocus() : void
      {
         var _loc1_:* = this;
         while(_loc1_ && !_loc1_._focusable)
         {
            _loc1_ = _loc1_.parent;
         }
         if(_loc1_ != null)
         {
            this.root.focus = _loc1_;
         }
      }
      
      public final function get tooltips() : String
      {
         return _tooltips;
      }
      
      public function set tooltips(param1:String) : void
      {
         if(_tooltips && Mouse.supportsCursor)
         {
            this.removeEventListener("rollOver",__rollOver);
            this.removeEventListener("rollOut",__rollOut);
         }
         _tooltips = param1;
         if(_tooltips && Mouse.supportsCursor)
         {
            this.addEventListener("rollOver",__rollOver);
            this.addEventListener("rollOut",__rollOut);
         }
      }
      
      private function __rollOver(param1:Event) : void
      {
         GTimers.inst.callDelay(100,__doShowTooltips);
      }
      
      private function __doShowTooltips() : void
      {
         var _loc1_:GRoot = this.root;
         if(_loc1_)
         {
            this.root.showTooltips(_tooltips);
         }
      }
      
      private function __rollOut(param1:Event) : void
      {
         GTimers.inst.remove(__doShowTooltips);
         this.root.hideTooltips();
      }
      
      public function get blendMode() : String
      {
         return _displayObject.blendMode;
      }
      
      public function set blendMode(param1:String) : void
      {
         _displayObject.blendMode = param1;
      }
      
      public function get filters() : Array
      {
         return _displayObject.filters;
      }
      
      public function set filters(param1:Array) : void
      {
         _displayObject.filters = param1;
      }
      
      public final function get inContainer() : Boolean
      {
         return _displayObject != null && _displayObject.parent != null;
      }
      
      public final function get onStage() : Boolean
      {
         return _displayObject != null && _displayObject.stage != null;
      }
      
      public final function get resourceURL() : String
      {
         if(packageItem != null)
         {
            return "ui://" + packageItem.owner.id + packageItem.id;
         }
         return null;
      }
      
      public final function set group(param1:GGroup) : void
      {
         if(_group != param1)
         {
            if(_group != null)
            {
               _group.setBoundsChangedFlag(true);
            }
            _group = param1;
            if(_group != null)
            {
               _group.setBoundsChangedFlag(true);
            }
         }
      }
      
      public final function get group() : GGroup
      {
         return _group;
      }
      
      public final function getGear(param1:int) : GearBase
      {
         var _loc2_:GearBase = _gears[param1];
         if(_loc2_ == null)
         {
            switch(int(param1))
            {
               case 0:
                  _loc2_ = new GearDisplay(this);
                  break;
               case 1:
                  _loc2_ = new GearXY(this);
                  break;
               case 2:
                  _loc2_ = new GearSize(this);
                  break;
               case 3:
                  _loc2_ = new GearLook(this);
                  break;
               case 4:
                  _loc2_ = new GearColor(this);
                  break;
               case 5:
                  _loc2_ = new GearAnimation(this);
                  break;
               case 6:
                  _loc2_ = new GearText(this);
                  break;
               case 7:
                  _loc2_ = new GearIcon(this);
            }
            _gears[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      protected function updateGear(param1:int) : void
      {
         if(_underConstruct || _gearLocked)
         {
            return;
         }
         var _loc2_:GearBase = _gears[param1];
         if(_loc2_ != null && _loc2_.controller != null)
         {
            _loc2_.updateState();
         }
      }
      
      function checkGearController(param1:int, param2:Controller) : Boolean
      {
         return _gears[param1] != null && _gears[param1].controller == param2;
      }
      
      function updateGearFromRelations(param1:int, param2:Number, param3:Number) : void
      {
         if(_gears[param1] != null)
         {
            _gears[param1].updateFromRelations(param2,param3);
         }
      }
      
      function addDisplayLock() : uint
      {
         var _loc1_:* = 0;
         var _loc2_:GearDisplay = GearDisplay(_gears[0]);
         if(_loc2_ && _loc2_.controller)
         {
            _loc1_ = uint(_loc2_.addLock());
            checkGearDisplay();
            return _loc1_;
         }
         return 0;
      }
      
      function releaseDisplayLock(param1:uint) : void
      {
         var _loc2_:GearDisplay = GearDisplay(_gears[0]);
         if(_loc2_ && _loc2_.controller)
         {
            _loc2_.releaseLock(param1);
            checkGearDisplay();
         }
      }
      
      private function checkGearDisplay() : void
      {
         if(_handlingController)
         {
            return;
         }
         var _loc1_:Boolean = _gears[0] == null || GearDisplay(_gears[0]).connected;
         if(_loc1_ != _internalVisible)
         {
            _internalVisible = _loc1_;
            if(_parent)
            {
               _parent.childStateChanged(this);
            }
         }
      }
      
      public final function get gearXY() : GearXY
      {
         return GearXY(getGear(1));
      }
      
      public final function get gearSize() : GearSize
      {
         return GearSize(getGear(2));
      }
      
      public final function get gearLook() : GearLook
      {
         return GearLook(getGear(3));
      }
      
      public final function get relations() : Relations
      {
         return _relations;
      }
      
      public final function addRelation(param1:GObject, param2:int, param3:Boolean = false) : void
      {
         _relations.add(param1,param2,param3);
      }
      
      public final function removeRelation(param1:GObject, param2:int) : void
      {
         _relations.remove(param1,param2);
      }
      
      public final function get displayObject() : DisplayObject
      {
         return _displayObject;
      }
      
      protected final function setDisplayObject(param1:DisplayObject) : void
      {
         _displayObject = param1;
      }
      
      public final function get parent() : GComponent
      {
         return _parent;
      }
      
      public final function set parent(param1:GComponent) : void
      {
         _parent = param1;
      }
      
      public final function removeFromParent() : void
      {
         if(_parent)
         {
            _parent.removeChild(this);
         }
      }
      
      public function get root() : GRoot
      {
         if(this is GRoot)
         {
            return GRoot(this);
         }
         var _loc1_:GObject = _parent;
         while(_loc1_)
         {
            if(_loc1_ is GRoot)
            {
               return GRoot(_loc1_);
            }
            _loc1_ = _loc1_.parent;
         }
         return GRoot.inst;
      }
      
      public final function get asCom() : GComponent
      {
         return this as GComponent;
      }
      
      public final function get asButton() : GButton
      {
         return this as GButton;
      }
      
      public final function get asLabel() : GLabel
      {
         return this as GLabel;
      }
      
      public final function get asProgress() : GProgressBar
      {
         return this as GProgressBar;
      }
      
      public final function get asTextField() : GTextField
      {
         return this as GTextField;
      }
      
      public final function get asRichTextField() : GRichTextField
      {
         return this as GRichTextField;
      }
      
      public final function get asTextInput() : GTextInput
      {
         return this as GTextInput;
      }
      
      public final function get asLoader() : GLoader
      {
         return this as GLoader;
      }
      
      public final function get asList() : GList
      {
         return this as GList;
      }
      
      public final function get asGraph() : GGraph
      {
         return this as GGraph;
      }
      
      public final function get asGroup() : GGroup
      {
         return this as GGroup;
      }
      
      public final function get asSlider() : GSlider
      {
         return this as GSlider;
      }
      
      public final function get asComboBox() : GComboBox
      {
         return this as GComboBox;
      }
      
      public final function get asImage() : GImage
      {
         return this as GImage;
      }
      
      public final function get asMovieClip() : GMovieClip
      {
         return this as GMovieClip;
      }
      
      public function get text() : String
      {
         return null;
      }
      
      public function set text(param1:String) : void
      {
      }
      
      public function get icon() : String
      {
         return null;
      }
      
      public function set icon(param1:String) : void
      {
      }
      
      public function dispose() : void
      {
         removeFromParent();
         _relations.dispose();
      }
      
      public function addClickListener(param1:Function) : void
      {
         addEventListener("clickGTouch",param1);
      }
      
      public function removeClickListener(param1:Function) : void
      {
         removeEventListener("clickGTouch",param1);
      }
      
      public function hasClickListener() : Boolean
      {
         return hasEventListener("clickGTouch");
      }
      
      public function addXYChangeCallback(param1:Function) : void
      {
         _dispatcher.addListener(1,param1);
      }
      
      public function addSizeChangeCallback(param1:Function) : void
      {
         _dispatcher.addListener(2,param1);
      }
      
      function addSizeDelayChangeCallback(param1:Function) : void
      {
         _dispatcher.addListener(3,param1);
      }
      
      public function removeXYChangeCallback(param1:Function) : void
      {
         _dispatcher.removeListener(1,param1);
      }
      
      public function removeSizeChangeCallback(param1:Function) : void
      {
         _dispatcher.removeListener(2,param1);
      }
      
      function removeSizeDelayChangeCallback(param1:Function) : void
      {
         _dispatcher.removeListener(3,param1);
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         super.addEventListener(param1,param2,false,param4,param5);
         if(_displayObject != null)
         {
            if(MTOUCH_EVENTS.indexOf(param1) != -1)
            {
               initMTouch();
            }
            else
            {
               if(param1 == "rightClick" && this is GComponent)
               {
                  GComponent(this).opaque = true;
               }
               _displayObject.addEventListener(param1,_reDispatch,param3,param4,param5);
            }
         }
      }
      
      override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         super.removeEventListener(param1,param2,false);
         if(_displayObject != null && !this.hasEventListener(param1))
         {
            _displayObject.removeEventListener(param1,_reDispatch,true);
            _displayObject.removeEventListener(param1,_reDispatch,false);
         }
      }
      
      private function _reDispatch(param1:Event) : void
      {
         var _loc2_:Event = param1.clone();
         this.dispatchEvent(_loc2_);
         if(param1.bubbles && _loc2_ is IBubbleEvent && IBubbleEvent(_loc2_).propagationStopped)
         {
            param1.stopPropagation();
         }
      }
      
      public final function get draggable() : Boolean
      {
         return _draggable;
      }
      
      public final function set draggable(param1:Boolean) : void
      {
         if(_draggable != param1)
         {
            _draggable = param1;
            initDrag();
         }
      }
      
      public final function get dragBounds() : Rectangle
      {
         return _dragBounds;
      }
      
      public final function set dragBounds(param1:Rectangle) : void
      {
         _dragBounds = param1;
      }
      
      public function startDrag(param1:int = -1) : void
      {
         if(_displayObject.stage == null)
         {
            return;
         }
         dragBegin(null);
         triggerDown(param1);
      }
      
      public function stopDrag() : void
      {
         dragEnd();
      }
      
      public function get dragging() : Boolean
      {
         return draggingObject == this;
      }
      
      public function localToGlobal(param1:Number = 0, param2:Number = 0) : Point
      {
         if(_pivotAsAnchor)
         {
            param1 = param1 + _pivotX * _width;
            param2 = param2 + _pivotY * _height;
         }
         sHelperPoint.x = param1;
         sHelperPoint.y = param2;
         return _displayObject.localToGlobal(sHelperPoint);
      }
      
      public function globalToLocal(param1:Number = 0, param2:Number = 0) : Point
      {
         sHelperPoint.x = param1;
         sHelperPoint.y = param2;
         var _loc3_:Point = _displayObject.globalToLocal(sHelperPoint);
         if(_pivotAsAnchor)
         {
            _loc3_.x = _loc3_.x - _pivotX * _width;
            _loc3_.y = _loc3_.y - _pivotY * _height;
         }
         return _loc3_;
      }
      
      public function localToRoot(param1:Number = 0, param2:Number = 0) : Point
      {
         if(_pivotAsAnchor)
         {
            param1 = param1 + _pivotX * _width;
            param2 = param2 + _pivotY * _height;
         }
         sHelperPoint.x = param1;
         sHelperPoint.y = param2;
         var _loc3_:Point = _displayObject.localToGlobal(sHelperPoint);
         _loc3_.x = _loc3_.x / GRoot.contentScaleFactor;
         _loc3_.y = _loc3_.y / GRoot.contentScaleFactor;
         return _loc3_;
      }
      
      public function rootToLocal(param1:Number = 0, param2:Number = 0) : Point
      {
         sHelperPoint.x = param1;
         sHelperPoint.y = param2;
         sHelperPoint.x = sHelperPoint.x * GRoot.contentScaleFactor;
         sHelperPoint.y = sHelperPoint.y * GRoot.contentScaleFactor;
         var _loc3_:Point = _displayObject.globalToLocal(sHelperPoint);
         if(_pivotAsAnchor)
         {
            _loc3_.x = _loc3_.x - _pivotX * _width;
            _loc3_.y = _loc3_.y - _pivotY * _height;
         }
         return _loc3_;
      }
      
      public function localToGlobalRect(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Rectangle = null) : Rectangle
      {
         if(param5 == null)
         {
            param5 = new Rectangle();
         }
         var _loc6_:Point = this.localToGlobal(param1,param2);
         param5.x = _loc6_.x;
         param5.y = _loc6_.y;
         _loc6_ = this.localToGlobal(param1 + param3,param2 + param4);
         param5.right = _loc6_.x;
         param5.bottom = _loc6_.y;
         return param5;
      }
      
      public function globalToLocalRect(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Rectangle = null) : Rectangle
      {
         if(param5 == null)
         {
            param5 = new Rectangle();
         }
         var _loc6_:Point = this.globalToLocal(param1,param2);
         param5.x = _loc6_.x;
         param5.y = _loc6_.y;
         _loc6_ = this.globalToLocal(param1 + param3,param2 + param4);
         param5.right = _loc6_.x;
         param5.bottom = _loc6_.y;
         return param5;
      }
      
      protected function createDisplayObject() : void
      {
      }
      
      protected function switchDisplayObject(param1:DisplayObject) : void
      {
         var _loc3_:int = 0;
         if(param1 == _displayObject)
         {
            return;
         }
         var _loc2_:DisplayObject = _displayObject;
         if(_displayObject.parent != null)
         {
            _loc3_ = _displayObject.parent.getChildIndex(_displayObject);
            _displayObject.parent.addChildAt(param1,_loc3_);
            _displayObject.parent.removeChild(_displayObject);
         }
         _displayObject = param1;
         _displayObject.x = _loc2_.x;
         _displayObject.y = _loc2_.y;
         _displayObject.rotation = _loc2_.rotation;
         _displayObject.alpha = _loc2_.alpha;
         _displayObject.visible = _loc2_.visible;
         _displayObject.scaleX = _loc2_.scaleX;
         _displayObject.scaleY = _loc2_.scaleY;
         _displayObject.filters = _loc2_.filters;
         _loc2_.filters = null;
         if(_displayObject is InteractiveObject && _loc2_ is InteractiveObject)
         {
            InteractiveObject(_displayObject).mouseEnabled = InteractiveObject(_loc2_).mouseEnabled;
            if(_displayObject is DisplayObjectContainer)
            {
               DisplayObjectContainer(_displayObject).mouseChildren = DisplayObjectContainer(_loc2_).mouseChildren;
            }
         }
      }
      
      protected function handlePositionChanged() : void
      {
         var _loc2_:Number = NaN;
         var _loc1_:Number = NaN;
         if(_displayObject)
         {
            _loc2_ = _x;
            _loc1_ = _y + _yOffset;
            if(_pivotAsAnchor)
            {
               _loc2_ = _loc2_ - _pivotX * _width;
               _loc1_ = _loc1_ - _pivotY * _height;
            }
            if(_pixelSnapping)
            {
               _loc2_ = Math.round(_loc2_);
               _loc1_ = Math.round(_loc1_);
            }
            _displayObject.x = _loc2_ + _pivotOffsetX;
            _displayObject.y = _loc1_ + _pivotOffsetY;
         }
      }
      
      protected function handleSizeChanged() : void
      {
         if(_displayObject != null && _sizeImplType == 1 && sourceWidth != 0 && sourceHeight != 0)
         {
            _displayObject.scaleX = _width / sourceWidth * _scaleX;
            _displayObject.scaleY = _height / sourceHeight * _scaleY;
         }
      }
      
      protected function handleScaleChanged() : void
      {
         if(_displayObject != null)
         {
            if(_sizeImplType == 0 || sourceWidth == 0 || sourceHeight == 0)
            {
               _displayObject.scaleX = _scaleX;
               _displayObject.scaleY = _scaleY;
            }
            else
            {
               _displayObject.scaleX = _width / sourceWidth * _scaleX;
               _displayObject.scaleY = _height / sourceHeight * _scaleY;
            }
         }
      }
      
      public function handleControllerChanged(param1:Controller) : void
      {
         var _loc3_:int = 0;
         var _loc2_:* = null;
         _handlingController = true;
         _loc3_ = 0;
         while(_loc3_ < 8)
         {
            _loc2_ = _gears[_loc3_];
            if(_loc2_ != null && _loc2_.controller == param1)
            {
               _loc2_.apply();
            }
            _loc3_++;
         }
         _handlingController = false;
         checkGearDisplay();
      }
      
      protected function handleGrayedChanged() : void
      {
         if(_displayObject)
         {
            if(_grayed)
            {
               _displayObject.filters = ToolSet.GRAY_FILTERS;
            }
            else
            {
               _displayObject.filters = null;
            }
         }
      }
      
      public function constructFromResource() : void
      {
      }
      
      public function setup_beforeAdd(param1:XML) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc5_:* = null;
         _id = param1.@id;
         _name = param1.@name;
         _loc3_ = param1.@xy;
         _loc4_ = _loc3_.split(",");
         this.setXY(parseInt(_loc4_[0]),parseInt(_loc4_[1]));
         _loc3_ = param1.@size;
         if(_loc3_)
         {
            _loc4_ = _loc3_.split(",");
            initWidth = parseInt(_loc4_[0]);
            initHeight = parseInt(_loc4_[1]);
            setSize(initWidth,initHeight,true);
         }
         _loc3_ = param1.@restrictSize;
         if(_loc3_)
         {
            _loc4_ = _loc3_.split(",");
            minWidth = parseInt(_loc4_[0]);
            maxWidth = parseInt(_loc4_[1]);
            minHeight = parseInt(_loc4_[2]);
            maxHeight = parseInt(_loc4_[3]);
         }
         _loc3_ = param1.@scale;
         if(_loc3_)
         {
            _loc4_ = _loc3_.split(",");
            setScale(parseFloat(_loc4_[0]),parseFloat(_loc4_[1]));
         }
         _loc3_ = param1.@rotation;
         if(_loc3_)
         {
            this.rotation = parseInt(_loc3_);
         }
         _loc3_ = param1.@alpha;
         if(_loc3_)
         {
            this.alpha = parseFloat(_loc3_);
         }
         _loc3_ = param1.@pivot;
         if(_loc3_)
         {
            _loc4_ = _loc3_.split(",");
            _loc3_ = param1.@anchor;
            this.setPivot(parseFloat(_loc4_[0]),parseFloat(_loc4_[1]),_loc3_ == "true");
         }
         if(param1.@touchable == "false")
         {
            this.touchable = false;
         }
         if(param1.@visible == "false")
         {
            this.visible = false;
         }
         if(param1.@grayed == "true")
         {
            this.grayed = true;
         }
         this.tooltips = param1.@tooltips;
         _loc3_ = param1.@blend;
         if(_loc3_)
         {
            this.blendMode = _loc3_;
         }
         _loc3_ = param1.@filter;
         if(_loc3_)
         {
            var _loc6_:* = _loc3_;
            if("color" === _loc6_)
            {
               _loc3_ = param1.@filterData;
               _loc4_ = _loc3_.split(",");
               _loc2_ = new ColorMatrix();
               _loc2_.adjustBrightness(parseFloat(_loc4_[0]));
               _loc2_.adjustContrast(parseFloat(_loc4_[1]));
               _loc2_.adjustSaturation(parseFloat(_loc4_[2]));
               _loc2_.adjustHue(parseFloat(_loc4_[3]));
               _loc5_ = new ColorMatrixFilter(_loc2_);
               this.filters = [_loc5_];
            }
         }
      }
      
      public function setup_afterAdd(param1:XML) : void
      {
         var _loc2_:* = undefined;
         var _loc4_:String = param1.@group;
         if(_loc4_)
         {
            _group = _parent.getChildById(_loc4_) as GGroup;
         }
         var _loc3_:Object = param1.elements();
         var _loc7_:int = 0;
         var _loc6_:* = _loc3_;
         for each(var _loc5_ in _loc3_)
         {
            _loc2_ = GearXMLKeys[_loc5_.name().localName];
            if(_loc2_ != undefined)
            {
               getGear(int(_loc2_)).setup(_loc5_);
            }
         }
      }
      
      public function get isDown() : Boolean
      {
         return _buttonStatus == 1;
      }
      
      public function triggerDown(param1:int = -1) : void
      {
         var _loc2_:Stage = _displayObject.stage;
         if(_loc2_ != null)
         {
            _buttonStatus = 1;
            if(!GRoot.touchPointInput)
            {
               _displayObject.stage.addEventListener("mouseUp",__stageMouseup,false,20);
               if(hasEventListener("dragGTouch"))
               {
                  _displayObject.stage.addEventListener("mouseMove",__mousemove);
               }
            }
            else
            {
               _touchPointId = param1;
               _displayObject.stage.addEventListener("touchEnd",__stageMouseup,false,20);
               if(hasEventListener("dragGTouch"))
               {
                  _displayObject.stage.addEventListener("touchMove",__mousemove);
               }
            }
         }
      }
      
      private function initMTouch() : void
      {
         if(this is GComponent)
         {
            GComponent(this).opaque = true;
         }
         if(!GRoot.touchPointInput)
         {
            _displayObject.addEventListener("mouseDown",__mousedown);
            _displayObject.addEventListener("mouseUp",__mouseup);
         }
         else
         {
            _displayObject.addEventListener("touchBegin",__mousedown);
            _displayObject.addEventListener("touchEnd",__mouseup);
         }
      }
      
      private function __mousedown(param1:Event) : void
      {
         var _loc2_:GTouchEvent = new GTouchEvent("beginGTouch");
         _loc2_.copyFrom(param1);
         this.dispatchEvent(_loc2_);
         if(_loc2_.isPropagationStop)
         {
            param1.stopPropagation();
         }
         if(_touchDownPoint == null)
         {
            _touchDownPoint = new Point();
         }
         if(!GRoot.touchPointInput)
         {
            _touchDownPoint.x = MouseEvent(param1).stageX;
            _touchDownPoint.y = MouseEvent(param1).stageY;
            triggerDown();
         }
         else
         {
            _touchDownPoint.x = TouchEvent(param1).stageX;
            _touchDownPoint.y = TouchEvent(param1).stageY;
            triggerDown(TouchEvent(param1).touchPointID);
         }
      }
      
      private function __mousemove(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(_buttonStatus != 1 || GRoot.touchPointInput && _touchPointId != TouchEvent(param1).touchPointID)
         {
            return;
         }
         if(GRoot.touchPointInput)
         {
            _loc2_ = UIConfig.touchDragSensitivity;
            if(_touchDownPoint != null && Math.abs(_touchDownPoint.x - TouchEvent(param1).stageX) < _loc2_ && Math.abs(_touchDownPoint.y - TouchEvent(param1).stageY) < _loc2_)
            {
               return;
            }
         }
         else
         {
            _loc2_ = UIConfig.clickDragSensitivity;
            if(_touchDownPoint != null && Math.abs(_touchDownPoint.x - MouseEvent(param1).stageX) < _loc2_ && Math.abs(_touchDownPoint.y - MouseEvent(param1).stageY) < _loc2_)
            {
               return;
            }
         }
         var _loc3_:GTouchEvent = new GTouchEvent("dragGTouch");
         _loc3_.copyFrom(param1);
         this.dispatchEvent(_loc3_);
         if(_loc3_.isPropagationStop)
         {
            param1.stopPropagation();
         }
      }
      
      private function __mouseup(param1:Event) : void
      {
         if(_buttonStatus != 1 || GRoot.touchPointInput && _touchPointId != TouchEvent(param1).touchPointID)
         {
            return;
         }
         _buttonStatus = 2;
      }
      
      private function __stageMouseup(param1:Event) : void
      {
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         var _loc4_:* = null;
         var _loc3_:* = null;
         if(!GRoot.touchPointInput)
         {
            param1.currentTarget.removeEventListener("mouseUp",__stageMouseup);
            param1.currentTarget.removeEventListener("mouseMove",__mousemove);
         }
         else
         {
            if(_touchPointId != TouchEvent(param1).touchPointID)
            {
               return;
            }
            param1.currentTarget.removeEventListener("touchEnd",__stageMouseup);
            param1.currentTarget.removeEventListener("touchMove",__mousemove);
         }
         if(_buttonStatus == 2)
         {
            _loc5_ = 1;
            _loc2_ = getTimer();
            if(_loc2_ - _lastClick < 500)
            {
               _loc5_ = 2;
               _lastClick = 0;
            }
            else
            {
               _lastClick = _loc2_;
            }
            _loc4_ = new GTouchEvent("clickGTouch");
            _loc4_.copyFrom(param1,_loc5_);
            this.dispatchEvent(_loc4_);
            if(_loc4_.isPropagationStop)
            {
               _loc3_ = this.parent;
               while(_loc3_ != null)
               {
                  _loc3_._buttonStatus = 0;
                  _loc3_ = _loc3_.parent;
               }
            }
         }
         _buttonStatus = 0;
         _loc4_ = new GTouchEvent("endGTouch");
         _loc4_.copyFrom(param1);
         this.dispatchEvent(_loc4_);
      }
      
      public function cancelClick() : void
      {
         var _loc3_:int = 0;
         var _loc1_:* = null;
         _buttonStatus = 0;
         var _loc2_:int = GComponent(this).numChildren;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = GComponent(this).getChildAt(_loc3_);
            _loc1_._buttonStatus = 0;
            if(_loc1_ is GComponent)
            {
               _loc1_.cancelClick();
            }
            _loc3_++;
         }
      }
      
      private function initDrag() : void
      {
         if(_draggable)
         {
            addEventListener("beginGTouch",__begin);
         }
         else
         {
            removeEventListener("beginGTouch",__begin);
         }
      }
      
      private function dragBegin(param1:GTouchEvent) : void
      {
         if(draggingObject != null)
         {
            draggingObject.stopDrag();
            draggingObject = null;
         }
         if(param1 != null)
         {
            sGlobalDragStart.x = param1.stageX;
            sGlobalDragStart.y = param1.stageY;
         }
         else
         {
            sGlobalDragStart.x = _displayObject.stage.mouseX;
            sGlobalDragStart.y = _displayObject.stage.mouseY;
         }
         this.localToGlobalRect(0,0,this.width,this.height,sGlobalRect);
         draggingObject = this;
         addEventListener("dragGTouch",__dragging);
         addEventListener("endGTouch",__dragEnd);
      }
      
      private function dragEnd() : void
      {
         if(draggingObject == this)
         {
            removeEventListener("dragGTouch",__dragStart);
            removeEventListener("endGTouch",__dragEnd);
            removeEventListener("dragGTouch",__dragging);
            draggingObject = null;
         }
      }
      
      private function __begin(param1:GTouchEvent) : void
      {
         if(param1.realTarget is TextField && TextField(param1.realTarget).type == "input")
         {
            return;
         }
         addEventListener("dragGTouch",__dragStart);
      }
      
      private function __dragStart(param1:GTouchEvent) : void
      {
         removeEventListener("dragGTouch",__dragStart);
         if(param1.realTarget is TextField && TextField(param1.realTarget).type == "input")
         {
            return;
         }
         var _loc2_:DragEvent = new DragEvent("startDrag");
         _loc2_.stageX = param1.stageX;
         _loc2_.stageY = param1.stageY;
         _loc2_.touchPointID = param1.touchPointID;
         dispatchEvent(_loc2_);
         if(!_loc2_.isDefaultPrevented())
         {
            dragBegin(param1);
         }
      }
      
      private function __dragging(param1:GTouchEvent) : void
      {
         var _loc4_:* = null;
         if(this.parent == null)
         {
            return;
         }
         var _loc6_:Number = param1.stageX - sGlobalDragStart.x + sGlobalRect.x;
         var _loc5_:Number = param1.stageY - sGlobalDragStart.y + sGlobalRect.y;
         if(_dragBounds != null)
         {
            _loc4_ = GRoot.inst.localToGlobalRect(_dragBounds.x,_dragBounds.y,_dragBounds.width,_dragBounds.height,sDragHelperRect);
            if(_loc6_ < _loc4_.x)
            {
               _loc6_ = _loc4_.x;
            }
            else if(_loc6_ + sGlobalRect.width > _loc4_.right)
            {
               _loc6_ = _loc4_.right - sGlobalRect.width;
               if(_loc6_ < _loc4_.x)
               {
                  _loc6_ = _loc4_.x;
               }
            }
            if(_loc5_ < _loc4_.y)
            {
               _loc5_ = _loc4_.y;
            }
            else if(_loc5_ + sGlobalRect.height > _loc4_.bottom)
            {
               _loc5_ = _loc4_.bottom - sGlobalRect.height;
               if(_loc5_ < _loc4_.y)
               {
                  _loc5_ = _loc4_.y;
               }
            }
         }
         sUpdateInDragging = true;
         var _loc3_:Point = this.parent.globalToLocal(_loc6_,_loc5_);
         this.setXY(Math.round(_loc3_.x),Math.round(_loc3_.y));
         sUpdateInDragging = false;
         var _loc2_:DragEvent = new DragEvent("dragMoving");
         _loc2_.stageX = param1.stageX;
         _loc2_.stageY = param1.stageY;
         _loc2_.touchPointID = param1.touchPointID;
         dispatchEvent(_loc2_);
      }
      
      private function __dragEnd(param1:GTouchEvent) : void
      {
         var _loc2_:* = null;
         if(draggingObject == this)
         {
            stopDrag();
            _loc2_ = new DragEvent("endDrag");
            _loc2_.stageX = param1.stageX;
            _loc2_.stageY = param1.stageY;
            _loc2_.touchPointID = param1.touchPointID;
            dispatchEvent(_loc2_);
         }
      }
   }
}
