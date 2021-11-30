package fairygui.editor.gui
{
   import fairygui.GRoot;
   import fairygui.ObjectPropID;
   import fairygui.UIConfig;
   import fairygui.editor.api.IDocElement;
   import fairygui.editor.api.IEditor;
   import fairygui.editor.api.IUIPackage;
   import fairygui.editor.gui.gear.FGearBase;
   import fairygui.editor.gui.gear.FGearDisplay;
   import fairygui.editor.gui.gear.FGearDisplay2;
   import fairygui.editor.settings.Preferences;
   import fairygui.event.GTouchEvent;
   import fairygui.utils.DispatcherLite;
   import fairygui.utils.GTimers;
   import fairygui.utils.Utils;
   import fairygui.utils.UtilsStr;
   import fairygui.utils.XData;
   import flash.display.BlendMode;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.utils.getTimer;
   
   public class FObject extends EventDispatcher
   {
      
      public static var loadingSnapshot:Boolean;
      
      public static const REMOVED:int = 0;
      
      public static const XY_CHANGED:int = 1;
      
      public static const SIZE_CHANGED:int = 2;
      
      public static const SCALE_CHANGED:int = 3;
      
      public static const ROTATION_CHANGED:int = 4;
      
      public static const PIVOT_CHANGED:int = 5;
      
      public static const SKEW_CHANGED:int = 6;
      
      public static const MAX_GEAR_INDEX:int = 9;
      
      private static var sHelperPoint:Point = new Point();
      
      private static var helperMatrix:Matrix = new Matrix();
      
      private static var helperPoint:Point = new Point();
       
      
      protected var _name:String;
      
      protected var _x:Number;
      
      protected var _y:Number;
      
      protected var _alpha:Number;
      
      protected var _rotation:Number;
      
      protected var _visible:Boolean;
      
      protected var _relations:FRelations;
      
      protected var _locked:Boolean;
      
      protected var _aspectLocked:Boolean;
      
      protected var _aspectRatio:Number;
      
      protected var _groupId:String;
      
      protected var _touchable:Boolean;
      
      protected var _grayed:Boolean;
      
      protected var _pivotX:Number;
      
      protected var _pivotY:Number;
      
      protected var _anchor:Boolean;
      
      protected var _pivotFromSource:Boolean;
      
      protected var _scaleX:Number;
      
      protected var _scaleY:Number;
      
      protected var _tooltips:String;
      
      protected var _blendMode:String;
      
      protected var _filterData:FilterData;
      
      protected var _skewX:Number;
      
      protected var _skewY:Number;
      
      protected var _gears:Vector.<FGearBase>;
      
      protected var _touchDisabled:Boolean;
      
      protected var _hideByEditor:Boolean;
      
      protected var _scaleFactor:Number;
      
      protected var _useSourceSize:Boolean;
      
      protected var _internalMinWidth:int;
      
      protected var _internalMinHeight:int;
      
      protected var _minWidth:int;
      
      protected var _minHeight:int;
      
      protected var _maxWidth:int;
      
      protected var _maxHeight:int;
      
      protected var _restrictSizeFromSource:Boolean;
      
      protected var _displayObject:FSprite;
      
      protected var _dispatcher:DispatcherLite;
      
      protected var _handlingController:Boolean;
      
      public var _parent:FComponent;
      
      public var _id:String;
      
      public var _width:Number;
      
      public var _height:Number;
      
      public var _rawWidth:Number;
      
      public var _rawHeight:Number;
      
      public var _widthEnabled:Boolean;
      
      public var _heightEnabled:Boolean;
      
      public var _renderDepth:int;
      
      public var _outlineVersion:int;
      
      public var _pivotOffsetX:Number;
      
      public var _pivotOffsetY:Number;
      
      public var _opened:Boolean;
      
      public var _group:FGroup;
      
      public var _sizePercentInGroup:Number;
      
      public var _gearLocked:Boolean;
      
      public var _internalVisible:Boolean;
      
      public var _hasSnapshot:Boolean;
      
      public var _treeNode:FTreeNode;
      
      public var _pkg:FPackage;
      
      public var _res:ResourceRef;
      
      public var _objectType:String;
      
      public var _docElement:IDocElement;
      
      public var _flags:int;
      
      public var _underConstruct:Boolean;
      
      public var sourceWidth:int;
      
      public var sourceHeight:int;
      
      public var initWidth:Number;
      
      public var initHeight:Number;
      
      public var customData:String;
      
      protected var _disposed:Boolean;
      
      private var _lastClick:int;
      
      private var _buttonStatus:int;
      
      private var _touchDownPoint:Point;
      
      public function FObject()
      {
         super();
         this._x = 0;
         this._y = 0;
         this._width = 0;
         this._height = 0;
         this._rawWidth = 0;
         this._rawHeight = 0;
         this._id = "";
         this._name = "";
         this._alpha = 1;
         this._rotation = 0;
         this._visible = true;
         this._relations = new FRelations(this);
         this._displayObject = new FSprite(this);
         this._dispatcher = new DispatcherLite();
         this._locked = false;
         this._widthEnabled = true;
         this._heightEnabled = true;
         this._aspectLocked = false;
         this._useSourceSize = true;
         this._aspectRatio = 1;
         this._minWidth = 0;
         this._minHeight = 0;
         this._maxWidth = 0;
         this._maxHeight = 0;
         this._internalMinWidth = 0;
         this._internalMinHeight = 0;
         this._touchable = true;
         this._grayed = false;
         this._scaleX = 1;
         this._scaleY = 1;
         this._tooltips = "";
         this._pivotX = 0;
         this._pivotY = 0;
         this._pivotOffsetX = 0;
         this._pivotOffsetY = 0;
         this._internalVisible = true;
         this._blendMode = "normal";
         this._filterData = new FilterData();
         this._skewX = 0;
         this._skewY = 0;
         this._gears = new Vector.<FGearBase>(MAX_GEAR_INDEX + 1,true);
         if(this is FComponent)
         {
            this.initMTouch();
         }
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get objectType() : String
      {
         return this._objectType;
      }
      
      public function get pkg() : IUIPackage
      {
         return this._pkg;
      }
      
      public function get docElement() : IDocElement
      {
         return this._docElement;
      }
      
      public function get touchable() : Boolean
      {
         if(this._touchDisabled)
         {
            return false;
         }
         return this._touchable;
      }
      
      public function set touchable(param1:Boolean) : void
      {
         if(this._touchable != param1)
         {
            this._touchable = param1;
            this.handleTouchableChanged();
            this.updateGear(3);
         }
      }
      
      public function get touchDisabled() : Boolean
      {
         return this._touchDisabled;
      }
      
      public function set touchDisabled(param1:Boolean) : void
      {
         if(this._touchDisabled != param1)
         {
            this._touchDisabled = param1;
            this.handleTouchableChanged();
         }
      }
      
      public function get grayed() : Boolean
      {
         return this._grayed;
      }
      
      public function set grayed(param1:Boolean) : void
      {
         if(this._grayed != param1)
         {
            this._grayed = param1;
            this.handleGrayedChanged();
            this.updateGear(3);
         }
      }
      
      public function get enabled() : Boolean
      {
         return !this._grayed && this._touchable;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         this._grayed = !param1;
         this._touchable = param1;
      }
      
      public function get resourceURL() : String
      {
         if(this._res != null)
         {
            return this._res.getURL();
         }
         return null;
      }
      
      public function get x() : Number
      {
         return this._x;
      }
      
      public function set x(param1:Number) : void
      {
         this.setXY(param1,this._y);
      }
      
      public function get y() : Number
      {
         return this._y;
      }
      
      public function set y(param1:Number) : void
      {
         this.setXY(this._x,param1);
      }
      
      public function setXY(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this._x != param1 || this._y != param2)
         {
            _loc3_ = param1 - this._x;
            _loc4_ = param2 - this._y;
            this._x = param1;
            this._y = param2;
            this.handleXYChanged();
            if(this._parent)
            {
               if(!(loadingSnapshot && this._hasSnapshot))
               {
                  if(this._group)
                  {
                     this._group.refresh(true);
                  }
                  if(this is FGroup)
                  {
                     FGroup(this).moveChildren(_loc3_,_loc4_);
                  }
               }
               this._parent.setBoundsChangedFlag();
            }
            this.updateGear(1);
            this._outlineVersion++;
            this._dispatcher.emit(this,XY_CHANGED);
         }
      }
      
      public function setTopLeft(param1:Number, param2:Number) : void
      {
         if(this._anchor)
         {
            this.setXY(param1 + this._pivotX * this._width,param2 + this._pivotY * this._height);
         }
         else
         {
            this.setXY(param1,param2);
         }
      }
      
      public function get xMin() : Number
      {
         if(this._anchor)
         {
            return this._x - this._width * this._pivotX;
         }
         return this._x;
      }
      
      public function set xMin(param1:Number) : void
      {
         if(this._anchor)
         {
            this.setXY(param1 + this._width * this._pivotX,this._y);
         }
         else
         {
            this.setXY(param1,this._y);
         }
      }
      
      public function get xMax() : Number
      {
         return this.xMin + this._width;
      }
      
      public function set xMax(param1:Number) : void
      {
         this.xMin = param1 - this._width;
      }
      
      public function get yMin() : Number
      {
         if(this._anchor)
         {
            return this._y - this._height * this._pivotY;
         }
         return this._y;
      }
      
      public function set yMin(param1:Number) : void
      {
         if(this._anchor)
         {
            this.setXY(this._x,param1 + this._height * this._pivotY);
         }
         else
         {
            this.setXY(this._x,param1);
         }
      }
      
      public function get yMax() : Number
      {
         return this.yMin + this._height;
      }
      
      public function set yMax(param1:Number) : void
      {
         this.yMin = param1 - this._height;
      }
      
      public function get height() : Number
      {
         return this._height;
      }
      
      public function get width() : Number
      {
         return this._width;
      }
      
      public function set width(param1:Number) : void
      {
         this.setSize(param1,this._rawHeight);
      }
      
      public function set height(param1:Number) : void
      {
         this.setSize(this._rawWidth,param1);
      }
      
      public function setSize(param1:Number, param2:Number, param3:Boolean = false, param4:Boolean = false) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(!param4)
         {
            if(!this._widthEnabled)
            {
               param1 = this._width;
            }
            if(!this._heightEnabled)
            {
               param2 = this._height;
            }
            if(this.docElement)
            {
               if(this.relations.widthLocked)
               {
                  param1 = this._rawWidth;
               }
               if(this.relations.heightLocked)
               {
                  param2 = this._rawHeight;
               }
            }
         }
         if(this._rawWidth != param1 || this._rawHeight != param2)
         {
            this._rawWidth = param1;
            this._rawHeight = param2;
            if((this._flags & FObjectFlags.INSPECTING) != 0)
            {
               if(param1 < this._internalMinWidth)
               {
                  param1 = this._internalMinWidth;
               }
               if(param2 < this._internalMinHeight)
               {
                  param2 = this._internalMinHeight;
               }
            }
            if(param1 < this._minWidth)
            {
               param1 = this._minWidth;
            }
            if(param2 < this._minHeight)
            {
               param2 = this._minHeight;
            }
            if(this._maxWidth > 0 && param1 > this._maxWidth)
            {
               param1 = this._maxWidth;
            }
            if(this._maxHeight > 0 && param2 > this._maxHeight)
            {
               param2 = this._maxHeight;
            }
            _loc5_ = param1 - this._width;
            _loc6_ = param2 - this._height;
            this._width = param1;
            this._height = param2;
            if((this._pivotX != 0 || this._pivotY != 0) && (this._flags & FObjectFlags.ROOT) == 0)
            {
               if(!this._anchor)
               {
                  if(!param3)
                  {
                     this.setXY(this.x - this._pivotX * _loc5_,this.y - this._pivotY * _loc6_);
                  }
                  this.updatePivotOffset();
               }
               else
               {
                  this.applyPivot();
               }
            }
            if(this._res && (this._width != this.sourceWidth || this._height != this.sourceHeight))
            {
               this._useSourceSize = false;
            }
            this.handleSizeChanged();
            if(this._parent)
            {
               if(!(loadingSnapshot && this._hasSnapshot))
               {
                  this._relations.onOwnerSizeChanged(_loc5_,_loc6_,this._anchor || !param3);
                  if(this is FGroup)
                  {
                     FGroup(this).resizeChildren(_loc5_,_loc6_);
                  }
                  if(this._group)
                  {
                     this._group.refresh();
                  }
               }
               this._parent.setBoundsChangedFlag();
            }
            this.updateGear(2);
            this._outlineVersion++;
            this._dispatcher.emit(this,SIZE_CHANGED);
         }
      }
      
      public function get minWidth() : int
      {
         return this._minWidth;
      }
      
      public function set minWidth(param1:int) : void
      {
         this._minWidth = param1;
         this._restrictSizeFromSource = false;
      }
      
      public function get minHeight() : int
      {
         return this._minHeight;
      }
      
      public function set minHeight(param1:int) : void
      {
         this._minHeight = param1;
         this._restrictSizeFromSource = false;
      }
      
      public function get maxWidth() : int
      {
         return this._maxWidth;
      }
      
      public function set maxWidth(param1:int) : void
      {
         this._maxWidth = param1;
         this._restrictSizeFromSource = false;
      }
      
      public function get maxHeight() : int
      {
         return this._maxHeight;
      }
      
      public function set maxHeight(param1:int) : void
      {
         this._maxHeight = param1;
         this._restrictSizeFromSource = false;
      }
      
      public function get actualWidth() : Number
      {
         return this.width * this._scaleX;
      }
      
      public function get actualHeight() : Number
      {
         return this.height * this._scaleY;
      }
      
      public final function get scaleX() : Number
      {
         return this._scaleX;
      }
      
      public function set scaleX(param1:Number) : void
      {
         this.setScale(param1,this._scaleY);
      }
      
      public final function get scaleY() : Number
      {
         return this._scaleY;
      }
      
      public function set scaleY(param1:Number) : void
      {
         this.setScale(this._scaleX,param1);
      }
      
      public function setScale(param1:Number, param2:Number) : void
      {
         if(this._scaleX != param1 || this._scaleY != param2)
         {
            this._scaleX = param1;
            this._scaleY = param2;
            this._displayObject.setContentScale(this._scaleX,this._scaleY);
            this.applyPivot();
            if(this._parent)
            {
               this._parent.setBoundsChangedFlag();
            }
            this.updateGear(2);
            this._outlineVersion++;
            this._dispatcher.emit(this,SCALE_CHANGED);
         }
      }
      
      public function get pivotOffsetX() : Number
      {
         return this._pivotOffsetX;
      }
      
      public function get pivotOffsetY() : Number
      {
         return this._pivotOffsetY;
      }
      
      public function get aspectLocked() : Boolean
      {
         return this._aspectLocked;
      }
      
      public function set aspectLocked(param1:Boolean) : void
      {
         this._aspectLocked = param1;
         if(this._aspectLocked)
         {
            this._aspectRatio = this.width / this.height;
         }
      }
      
      public function get aspectRatio() : Number
      {
         return this._aspectRatio;
      }
      
      public function get skewX() : Number
      {
         return this._skewX;
      }
      
      public function set skewX(param1:Number) : void
      {
         this.setSkew(param1,this._skewY);
      }
      
      public function get skewY() : Number
      {
         return this._skewY;
      }
      
      public function set skewY(param1:Number) : void
      {
         this.setSkew(this._skewX,param1);
      }
      
      public function setSkew(param1:Number, param2:Number) : void
      {
         if(this._skewX != param1 || this._skewY != param2)
         {
            this._skewX = param1;
            this._skewY = param2;
            this.displayObject.setContentSkew(this._skewX,this._skewY);
            this.applyPivot();
            this._outlineVersion++;
            this._dispatcher.emit(this,SKEW_CHANGED);
         }
      }
      
      public function get pivotX() : Number
      {
         return this._pivotX;
      }
      
      public function set pivotX(param1:Number) : void
      {
         this.setPivot(param1,this._pivotY,this._anchor);
      }
      
      public function get pivotY() : Number
      {
         return this._pivotY;
      }
      
      public function set pivotY(param1:Number) : void
      {
         this.setPivot(this._pivotX,param1,this._anchor);
      }
      
      public function setPivot(param1:Number, param2:Number, param3:Boolean) : void
      {
         if(this._pivotX != param1 || this._pivotY != param2 || this._anchor != param3)
         {
            this._pivotFromSource = false;
            this._pivotX = param1;
            this._pivotY = param2;
            this._anchor = param3;
            this._outlineVersion++;
            if((this._flags & FObjectFlags.ROOT) == 0)
            {
               this.applyPivot();
               if(!this._underConstruct)
               {
                  this._dispatcher.emit(this,PIVOT_CHANGED);
               }
            }
         }
      }
      
      public function get anchor() : Boolean
      {
         return this._anchor;
      }
      
      public function set anchor(param1:Boolean) : void
      {
         if(this._anchor != param1)
         {
            this._anchor = param1;
            this._pivotFromSource = false;
            this._outlineVersion++;
            if((this._flags & FObjectFlags.ROOT) == 0)
            {
               this.handleXYChanged();
               this._dispatcher.emit(this,PIVOT_CHANGED);
            }
         }
      }
      
      private function updatePivotOffset() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Point = null;
         var _loc1_:Number = this.normalizeRotation;
         if(_loc1_ != 0 || this._scaleX != 1 || this._scaleY != 1 || this._skewX != 0 || this._skewY != 0)
         {
            _loc2_ = _loc1_ * Math.PI / 180;
            _loc3_ = this._pivotX * this._width;
            _loc4_ = this._pivotY * this._height;
            if(this._skewX == 0 && this._skewY == 0)
            {
               _loc5_ = Math.cos(_loc2_);
               _loc6_ = Math.sin(_loc2_);
               _loc7_ = this._scaleX * _loc5_;
               _loc8_ = this._scaleX * _loc6_;
               _loc9_ = this._scaleY * -_loc6_;
               _loc10_ = this._scaleY * _loc5_;
               this._pivotOffsetX = _loc3_ - (_loc7_ * _loc3_ + _loc9_ * _loc4_);
               this._pivotOffsetY = _loc4_ - (_loc10_ * _loc4_ + _loc8_ * _loc3_);
            }
            else
            {
               helperMatrix.identity();
               helperMatrix.scale(this._scaleX,this._scaleY);
               Utils.skew(helperMatrix,this._skewX,this._skewY);
               helperMatrix.rotate(_loc2_);
               helperPoint.x = this._pivotX * this._width;
               helperPoint.y = this._pivotY * this._height;
               _loc11_ = helperMatrix.transformPoint(helperPoint);
               this._pivotOffsetX = _loc3_ - _loc11_.x;
               this._pivotOffsetY = _loc4_ - _loc11_.y;
            }
         }
         else
         {
            this._pivotOffsetX = 0;
            this._pivotOffsetY = 0;
         }
      }
      
      private function applyPivot() : void
      {
         this.updatePivotOffset();
         this.handleXYChanged();
      }
      
      public function get locked() : Boolean
      {
         return this._locked;
      }
      
      public function set locked(param1:Boolean) : void
      {
         if(this._locked != param1)
         {
            this._locked = param1;
            this.handleTouchableChanged();
         }
      }
      
      public function get hideByEditor() : Boolean
      {
         return this._hideByEditor;
      }
      
      public function set hideByEditor(param1:Boolean) : void
      {
         this._hideByEditor = param1;
      }
      
      public function get useSourceSize() : Boolean
      {
         return this._useSourceSize;
      }
      
      public function set useSourceSize(param1:Boolean) : void
      {
         if(!this._res)
         {
            return;
         }
         this._useSourceSize = param1;
      }
      
      public function get rotation() : Number
      {
         return this._rotation;
      }
      
      public function get normalizeRotation() : Number
      {
         var _loc1_:Number = this._rotation % 360;
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
      
      public function set rotation(param1:Number) : void
      {
         if(this._rotation != param1)
         {
            this._rotation = param1;
            this.applyPivot();
            if(this._displayObject != null)
            {
               this._displayObject.contentRotation = this.normalizeRotation;
            }
            this.updateGear(3);
            this._outlineVersion++;
            this._dispatcher.emit(this,ROTATION_CHANGED);
         }
      }
      
      public function get alpha() : Number
      {
         return this._alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         if(this._alpha != param1)
         {
            this._alpha = param1;
            this.handleAlphaChanged();
            this.updateGear(3);
         }
      }
      
      public function get visible() : Boolean
      {
         return this._visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         if(this._visible != param1)
         {
            this._visible = param1;
            this.handleVisibleChanged();
            if(this._parent)
            {
               this._parent.setBoundsChangedFlag();
            }
            if(this._group)
            {
               this._group.refresh();
            }
         }
      }
      
      public function get internalVisible() : Boolean
      {
         return this._internalVisible && (!this._group || this._group.internalVisible);
      }
      
      public function get internalVisible2() : Boolean
      {
         var _loc1_:Boolean = this._visible;
         if((this._flags & FObjectFlags.INSPECTING) != 0)
         {
            if(this._hideByEditor)
            {
               _loc1_ = false;
            }
            else if(Preferences.hideInvisibleChild)
            {
               _loc1_ = this._visible;
            }
            else if(!this.docElement || !this.docElement.owner.timelineMode)
            {
               _loc1_ = true;
            }
         }
         return _loc1_ && (!this._group || this._group.internalVisible2);
      }
      
      public function get internalVisible3() : Boolean
      {
         return this._visible && this._internalVisible;
      }
      
      public function get groupId() : String
      {
         return this._groupId;
      }
      
      public function set groupId(param1:String) : void
      {
         if(this._groupId != param1)
         {
            if(this._group)
            {
               this._group._childrenDirty = true;
               this._group.refresh();
               this._group = null;
            }
            this._groupId = param1;
            if(this._groupId)
            {
               this._group = this._parent.getChildById(this._groupId) as FGroup;
               if(this._group)
               {
                  this._group._childrenDirty = true;
                  this._group.refresh();
               }
            }
         }
      }
      
      public function inGroup(param1:FGroup) : Boolean
      {
         if(this._group == null && param1 == null)
         {
            return true;
         }
         var _loc2_:FGroup = this._group;
         while(_loc2_)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
            _loc2_ = _loc2_._group;
         }
         return false;
      }
      
      public function get tooltips() : String
      {
         return this._tooltips;
      }
      
      public function set tooltips(param1:String) : void
      {
         if((this._flags & FObjectFlags.IN_TEST) != 0 && this._tooltips)
         {
            this.displayObject.removeEventListener(MouseEvent.ROLL_OVER,this.__rollOver);
            this.displayObject.removeEventListener(MouseEvent.ROLL_OUT,this.__rollOut);
         }
         this._tooltips = param1;
         if((this._flags & FObjectFlags.IN_TEST) != 0 && this._tooltips)
         {
            this.displayObject.addEventListener(MouseEvent.ROLL_OVER,this.__rollOver);
            this.displayObject.addEventListener(MouseEvent.ROLL_OUT,this.__rollOut);
         }
      }
      
      private function __rollOver(param1:Event) : void
      {
         GTimers.inst.callDelay(100,this.__doShowTooltips);
      }
      
      private function __doShowTooltips(param1:GRoot) : void
      {
         this.editor.testView.showTooltips(this._tooltips);
      }
      
      private function __rollOut(param1:Event) : void
      {
         GTimers.inst.remove(this.__doShowTooltips);
         this.editor.testView.hideTooltips();
      }
      
      public function get filterData() : FilterData
      {
         return this._filterData;
      }
      
      public function set filterData(param1:FilterData) : void
      {
         this._filterData = param1;
         this._displayObject.applyFilter();
      }
      
      public function get filter() : String
      {
         return this._filterData.type;
      }
      
      public function set filter(param1:String) : void
      {
         this._filterData.type = param1;
         this._displayObject.applyFilter();
      }
      
      public function get blendMode() : String
      {
         return this._blendMode;
      }
      
      public function set blendMode(param1:String) : void
      {
         this._blendMode = param1;
         switch(this._blendMode)
         {
            case "normal":
               this._displayObject.blendMode = BlendMode.NORMAL;
               break;
            case "none":
               this._displayObject.blendMode = BlendMode.NORMAL;
               break;
            case "add":
               this._displayObject.blendMode = BlendMode.ADD;
               break;
            case "multiply":
               this._displayObject.blendMode = BlendMode.MULTIPLY;
               break;
            case "screen":
               this._displayObject.blendMode = BlendMode.SCREEN;
         }
      }
      
      public final function getGear(param1:int, param2:Boolean = true) : FGearBase
      {
         var _loc3_:FGearBase = this._gears[param1];
         if(_loc3_ == null && param2)
         {
            this._gears[param1] = _loc3_ = FGearBase.create(this,param1);
         }
         return _loc3_;
      }
      
      public function updateGear(param1:int) : void
      {
         if(this._underConstruct || this._gearLocked || this._docElement && this._docElement.owner.timelineMode)
         {
            return;
         }
         var _loc2_:FGearBase = this._gears[param1];
         if(_loc2_ != null && _loc2_.controllerObject != null)
         {
            _loc2_.updateState();
         }
      }
      
      public function updateGearFromRelations(param1:int, param2:Number, param3:Number) : void
      {
         if(this._gears[param1] != null)
         {
            this._gears[param1].updateFromRelations(param2,param3);
         }
      }
      
      public function supportGear(param1:int) : Boolean
      {
         switch(param1)
         {
            case 3:
               return !(this is FGroup);
            case 4:
               return !(this is FGroup) && (!(this is FComponent) || FComponent(this).extentionId == "Button" || FComponent(this).extentionId == "Label");
            case 5:
               return this is FMovieClip || this is FLoader || this is FSwfObject;
            case 9:
               return this is FTextField || this is FComponent && (FComponent(this).extentionId == "Button" || FComponent(this).extentionId == "Label");
            default:
               return true;
         }
      }
      
      public function validateGears() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ <= MAX_GEAR_INDEX)
         {
            if(this._gears[_loc1_] != null && !this.supportGear(_loc1_))
            {
               this._gears[_loc1_] = null;
            }
            _loc1_++;
         }
      }
      
      public function checkGearController(param1:int, param2:FController) : Boolean
      {
         return this._gears[param1] != null && this._gears[param1].controllerObject == param2;
      }
      
      public function checkGearsController(param1:FController) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ <= MAX_GEAR_INDEX)
         {
            if(this._gears[_loc2_] != null && this._gears[_loc2_].controllerObject == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function addDisplayLock() : uint
      {
         var _loc2_:uint = 0;
         var _loc1_:FGearDisplay = FGearDisplay(this._gears[0]);
         if(_loc1_ && _loc1_.controllerObject)
         {
            _loc2_ = _loc1_.addLock();
            this.checkGearDisplay();
            return _loc2_;
         }
         return 0;
      }
      
      public function releaseDisplayLock(param1:uint) : void
      {
         var _loc2_:FGearDisplay = FGearDisplay(this._gears[0]);
         if(_loc2_ && _loc2_.controller)
         {
            _loc2_.releaseLock(param1);
            this.checkGearDisplay();
         }
      }
      
      public function checkGearDisplay() : void
      {
         if(this._handlingController)
         {
            return;
         }
         var _loc1_:Boolean = this._gears[0] == null || FGearDisplay(this._gears[0]).connected;
         if(this._gears[8] != null)
         {
            _loc1_ = FGearDisplay2(this._gears[8]).evaluate(_loc1_);
         }
         if(_loc1_ != this._internalVisible)
         {
            this._internalVisible = _loc1_;
            if(this._parent)
            {
               this._parent.updateDisplayList();
               if(this._group)
               {
                  this._group.refresh();
               }
            }
         }
      }
      
      public function get relations() : FRelations
      {
         return this._relations;
      }
      
      public function get dispatcher() : DispatcherLite
      {
         return this._dispatcher;
      }
      
      public function get displayObject() : FSprite
      {
         return this._displayObject;
      }
      
      public function get parent() : FComponent
      {
         return this._parent;
      }
      
      public function removeFromParent() : void
      {
         if(this._parent)
         {
            this._parent.removeChild(this);
         }
      }
      
      public function localToGlobal(param1:Number = 0, param2:Number = 0) : Point
      {
         if(this._anchor)
         {
            param1 = param1 + this._pivotX * this._width;
            param2 = param2 + this._pivotY * this._height;
         }
         sHelperPoint.x = param1;
         sHelperPoint.y = param2;
         return this._displayObject.rootContainer.localToGlobal(sHelperPoint);
      }
      
      public function globalToLocal(param1:Number = 0, param2:Number = 0) : Point
      {
         sHelperPoint.x = param1;
         sHelperPoint.y = param2;
         var _loc3_:Point = this._displayObject.rootContainer.globalToLocal(sHelperPoint);
         if(this._anchor)
         {
            _loc3_.x = _loc3_.x - this._pivotX * this._width;
            _loc3_.y = _loc3_.y - this._pivotY * this._height;
         }
         return _loc3_;
      }
      
      public function handleXYChanged() : void
      {
         this._displayObject.handleXYChanged();
      }
      
      public function handleSizeChanged() : void
      {
         this._displayObject.handleSizeChanged();
      }
      
      public function handleTouchableChanged() : void
      {
         if((this._flags & FObjectFlags.INSPECTING) != 0)
         {
            if(this._locked)
            {
               this._displayObject.mouseChildren = false;
            }
            else
            {
               this._displayObject.mouseChildren = true;
            }
         }
         else if(this._touchDisabled)
         {
            this._displayObject.mouseChildren = false;
         }
         else
         {
            this._displayObject.mouseChildren = this._touchable;
         }
      }
      
      public function handleGrayedChanged() : void
      {
         this._displayObject.applyFilter();
      }
      
      public function handleAlphaChanged() : void
      {
         this._displayObject.container.alpha = this._alpha;
      }
      
      public function handleVisibleChanged() : void
      {
         this._displayObject.visible = this.internalVisible2;
      }
      
      public function handleControllerChanged(param1:FController) : void
      {
         var _loc3_:FGearBase = null;
         this._handlingController = true;
         var _loc2_:int = 0;
         while(_loc2_ <= MAX_GEAR_INDEX)
         {
            _loc3_ = this._gears[_loc2_];
            if(_loc3_ != null && _loc3_.controllerObject == param1)
            {
               _loc3_.apply();
            }
            _loc2_++;
         }
         this._handlingController = false;
         this.checkGearDisplay();
      }
      
      public function getProp(param1:int) : *
      {
         switch(param1)
         {
            case ObjectPropID.Text:
               return this.text;
            case ObjectPropID.Icon:
               return this.icon;
            case ObjectPropID.Color:
               return 0;
            case ObjectPropID.OutlineColor:
               return 0;
            case ObjectPropID.Playing:
               return false;
            case ObjectPropID.Frame:
               return 0;
            case ObjectPropID.DeltaTime:
               return 0;
            case ObjectPropID.TimeScale:
               return 1;
            case ObjectPropID.FontSize:
               return 0;
            default:
               return undefined;
         }
      }
      
      public function setProp(param1:int, param2:*) : void
      {
         switch(param1)
         {
            case ObjectPropID.Text:
               this.text = param2;
               break;
            case ObjectPropID.Icon:
               this.icon = param2;
         }
      }
      
      public function get deprecated() : Boolean
      {
         if(this._res)
         {
            return this._res.deprecated;
         }
         return false;
      }
      
      public function validate(param1:Boolean = false) : Boolean
      {
         if(this.deprecated)
         {
            if(!param1)
            {
               this.recreate();
            }
            return true;
         }
         if(this is FComponent)
         {
            return FComponent(this).validateChildren(param1);
         }
         return false;
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
      
      override public function toString() : String
      {
         var _loc1_:String = null;
         if(this._name)
         {
            _loc1_ = this._name;
         }
         else
         {
            _loc1_ = "";
         }
         if(this._res)
         {
            _loc1_ = _loc1_ + (" {" + this._res.name + "}");
         }
         return _loc1_;
      }
      
      public function getDetailString() : String
      {
         if(this._res)
         {
            return this._res.desc;
         }
         return "";
      }
      
      public function get errorStatus() : Boolean
      {
         return this._displayObject.errorStatus;
      }
      
      public function set errorStatus(param1:Boolean) : void
      {
         if(param1)
         {
            if(this.sourceWidth == 0 || this.sourceHeight == 0)
            {
               this.sourceWidth = 100;
               this.sourceHeight = 100;
               this.setSize(this.sourceWidth,this.sourceHeight);
            }
         }
         this.displayObject.errorStatus = param1;
      }
      
      public function get editor() : IEditor
      {
         return this._pkg.project.editor as IEditor;
      }
      
      public function get topmost() : FComponent
      {
         var _loc1_:FComponent = this._parent;
         if(!_loc1_ && this is FComponent)
         {
            return FComponent(this);
         }
         while(_loc1_._parent)
         {
            _loc1_ = _loc1_._parent;
         }
         return _loc1_;
      }
      
      public final function create() : void
      {
         this.handleCreate();
      }
      
      protected function handleCreate() : void
      {
      }
      
      public final function dispose() : void
      {
         if(this._disposed)
         {
            return;
         }
         this._disposed = true;
         this._relations.reset();
         this._dispatcher.offAll();
         this.handleDispose();
         if(this._res)
         {
            this._res.release();
            this._res = null;
         }
      }
      
      protected function handleDispose() : void
      {
      }
      
      public function recreate() : void
      {
         var _loc1_:Number = this._width;
         var _loc2_:Number = this._height;
         var _loc3_:XData = this.write();
         this._name = "";
         this._alpha = 1;
         this._rotation = 0;
         this._visible = true;
         this._touchable = true;
         this._grayed = false;
         this._anchor = false;
         this.initWidth = this.initHeight = this.sourceWidth = this.sourceHeight = 0;
         this._minWidth = this._maxWidth = this._minHeight = this._maxHeight = 0;
         this._pivotX = this._pivotY = 0;
         this._relations.reset();
         this._displayObject.reset();
         if(this._res)
         {
            this._res.update();
         }
         this._underConstruct = true;
         this.handleCreate();
         var _loc4_:String = _loc3_.getAttribute("size");
         if(_loc4_)
         {
            if(this.relations.widthLocked && this.relations.heightLocked)
            {
               _loc3_.removeAttribute("size");
            }
            else if(this.relations.widthLocked)
            {
               _loc3_.setAttribute("size",this.sourceWidth + "," + _loc2_);
            }
            else if(this.relations.heightLocked)
            {
               _loc3_.setAttribute("size",_loc1_ + "," + this.sourceHeight);
            }
         }
         this.read_beforeAdd(_loc3_,null);
         this._relations.read(_loc3_);
         this.read_afterAdd(_loc3_,null);
         this._underConstruct = false;
      }
      
      public function read_beforeAdd(param1:XData, param2:Object) : void
      {
         var _loc3_:String = null;
         var _loc5_:* = undefined;
         this._id = param1.getAttribute("id");
         this._name = param1.getAttribute("name");
         this._aspectLocked = param1.getAttributeBool("aspect");
         this.visible = param1.getAttributeBool("visible",true);
         this.touchable = param1.getAttributeBool("touchable",true);
         this.grayed = param1.getAttributeBool("grayed");
         _loc3_ = param1.getAttribute("xy");
         var _loc4_:Array = _loc3_.split(",");
         this.setXY(int(_loc4_[0]),int(_loc4_[1]));
         _loc3_ = param1.getAttribute("pivot");
         if(_loc3_)
         {
            _loc4_ = _loc3_.split(",");
            this.setPivot(parseFloat(_loc4_[0]),parseFloat(_loc4_[1]),param1.getAttributeBool("anchor"));
         }
         else if(this._pivotX != 0 || this._pivotY != 0)
         {
            this.applyPivot();
         }
         _loc3_ = param1.getAttribute("size");
         if(_loc3_)
         {
            this._useSourceSize = false;
            _loc4_ = _loc3_.split(",");
            this.initWidth = int(_loc4_[0]);
            this.initHeight = int(_loc4_[1]);
            this.setSize(this.initWidth,this.initHeight,true,true);
            if(this._aspectLocked)
            {
               this._aspectRatio = this._width / this._height;
            }
         }
         else
         {
            this.useSourceSize = true;
            this.initWidth = this.sourceWidth;
            this.initHeight = this.sourceHeight;
         }
         _loc3_ = param1.getAttribute("restrictSize");
         if(_loc3_)
         {
            _loc4_ = _loc3_.split(",");
            this._minWidth = int(_loc4_[0]);
            this._maxWidth = int(_loc4_[1]);
            this._minHeight = int(_loc4_[2]);
            this._maxHeight = int(_loc4_[3]);
            this._restrictSizeFromSource = false;
         }
         _loc3_ = param1.getAttribute("scale");
         if(_loc3_)
         {
            _loc4_ = _loc3_.split(",");
            this.setScale(parseFloat(_loc4_[0]),parseFloat(_loc4_[1]));
         }
         _loc3_ = param1.getAttribute("skew");
         if(_loc3_)
         {
            _loc4_ = _loc3_.split(",");
            this.setSkew(parseFloat(_loc4_[0]),parseFloat(_loc4_[1]));
         }
         _loc3_ = param1.getAttribute("alpha");
         if(_loc3_)
         {
            this.alpha = parseFloat(_loc3_);
         }
         else
         {
            this.alpha = 1;
         }
         _loc3_ = param1.getAttribute("rotation");
         if(_loc3_)
         {
            this.rotation = parseFloat(_loc3_);
         }
         else
         {
            this.rotation = 0;
         }
         _loc3_ = param1.getAttribute("tooltips");
         if(_loc3_)
         {
            if(param2)
            {
               _loc5_ = param2[this._id + "-tips"];
               if(_loc5_ != undefined)
               {
                  _loc3_ = _loc5_;
               }
            }
            this.tooltips = _loc3_;
         }
         _loc3_ = param1.getAttribute("blend");
         if(_loc3_)
         {
            this.blendMode = _loc3_;
         }
         this._filterData.read(param1);
         this._displayObject.applyFilter();
         this.customData = param1.getAttribute("customData");
      }
      
      public function read_afterAdd(param1:XData, param2:Object) : void
      {
         var _loc5_:XData = null;
         var _loc6_:int = 0;
         var _loc3_:String = param1.getAttribute("group");
         if(_loc3_)
         {
            this.groupId = _loc3_;
         }
         var _loc4_:Vector.<XData> = param1.getChildren();
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = FGearBase.getIndexByName(_loc5_.getName());
            if(_loc6_ != -1)
            {
               this.getGear(_loc6_).read(_loc5_,param2);
            }
         }
      }
      
      public function write() : XData
      {
         var _loc3_:int = 0;
         var _loc4_:XData = null;
         var _loc1_:Boolean = this is FGroup && !FGroup(this).advanced;
         var _loc2_:XData = XData.create(this._objectType);
         _loc2_.setAttribute("id",this._id);
         _loc2_.setAttribute("name",this._name);
         if(this._res)
         {
            if(this._res.packageItem)
            {
               _loc2_.setAttribute("src",this._res.packageItem.id);
               _loc2_.setAttribute("fileName",(this._res.packageItem.path + this._res.packageItem.fileName).substr(1));
               if(this._parent && this._pkg != this._parent._pkg)
               {
                  _loc2_.setAttribute("pkg",this._pkg.id);
               }
            }
            else
            {
               if(this._res.missingInfo.pkgId)
               {
                  _loc2_.setAttribute("pkg",this._res.missingInfo.pkgId);
               }
               _loc2_.setAttribute("src",this._res.missingInfo.itemId);
               _loc2_.setAttribute("fileName",this._res.missingInfo.fileName);
            }
         }
         _loc2_.setAttribute("xy",int(this._x) + "," + int(this._y));
         if(!this._pivotFromSource && (this._pivotX != 0 || this._pivotY != 0))
         {
            _loc2_.setAttribute("pivot",UtilsStr.toFixed(this._pivotX) + "," + UtilsStr.toFixed(this._pivotY));
            if(this._anchor)
            {
               _loc2_.setAttribute("anchor",true);
            }
         }
         if(!this._parent || !(this._parent is FList))
         {
            if(!this._useSourceSize)
            {
               _loc2_.setAttribute("size",int(this._width) + "," + int(this._height));
            }
         }
         if(!this._restrictSizeFromSource && (this._minWidth != 0 || this._maxWidth != 0 || this._minHeight != 0 || this._maxHeight != 0))
         {
            _loc2_.setAttribute("restrictSize",this._minWidth + "," + this._maxWidth + "," + this._minHeight + "," + this._maxHeight);
         }
         if(this._group)
         {
            _loc2_.setAttribute("group",this._groupId);
         }
         if(this._aspectLocked)
         {
            _loc2_.setAttribute("aspect",true);
         }
         if(this._scaleX != 1 || this._scaleY != 1)
         {
            _loc2_.setAttribute("scale",UtilsStr.toFixed(this._scaleX) + "," + UtilsStr.toFixed(this._scaleY));
         }
         if(this._skewX != 0 || this._skewY != 0)
         {
            _loc2_.setAttribute("skew",UtilsStr.toFixed(this._skewX) + "," + UtilsStr.toFixed(this._skewY));
         }
         if(!this._visible && !_loc1_)
         {
            _loc2_.setAttribute("visible",false);
         }
         if(this._alpha != 1)
         {
            _loc2_.setAttribute("alpha",UtilsStr.toFixed(this._alpha));
         }
         if(this._rotation != 0)
         {
            _loc2_.setAttribute("rotation",UtilsStr.toFixed(this._rotation));
         }
         if(!this._touchable && !this._touchDisabled)
         {
            _loc2_.setAttribute("touchable",false);
         }
         if(this._grayed)
         {
            _loc2_.setAttribute("grayed",true);
         }
         if(this._blendMode != "normal")
         {
            _loc2_.setAttribute("blend",this._blendMode);
         }
         this._filterData.write(_loc2_);
         if(this._tooltips)
         {
            _loc2_.setAttribute("tooltips",this._tooltips);
         }
         if(this.customData)
         {
            _loc2_.setAttribute("customData",this.customData);
         }
         if(!_loc1_)
         {
            _loc3_ = 0;
            while(_loc3_ <= MAX_GEAR_INDEX)
            {
               if(this._gears[_loc3_] != null && this._gears[_loc3_].controllerObject && this._gears[_loc3_].controllerObject.parent)
               {
                  _loc2_.appendChild(this._gears[_loc3_].write());
               }
               _loc3_++;
            }
            if(!this._relations.isEmpty)
            {
               for each(_loc4_ in this._relations.write().getChildren())
               {
                  _loc2_.appendChild(_loc4_);
               }
            }
         }
         return _loc2_;
      }
      
      public function takeSnapshot(param1:ObjectSnapshot) : void
      {
         param1.x = this._x;
         param1.y = this._y;
         param1.width = this._rawWidth;
         param1.height = this._rawHeight;
         param1.scaleX = this._scaleX;
         param1.scaleY = this._scaleY;
         param1.skewX = this._skewX;
         param1.skewY = this._skewY;
         param1.pivotX = this._pivotX;
         param1.pivotY = this._pivotY;
         param1.anchor = this._anchor;
         param1.alpha = this._alpha;
         param1.rotation = this._rotation;
         param1.visible = this._visible;
         param1.color = this.getProp(ObjectPropID.Color);
         param1.playing = this.getProp(ObjectPropID.Playing);
         param1.frame = this.getProp(ObjectPropID.Frame);
         param1.filterData.copyFrom(this._filterData);
         param1.text = this.text;
         param1.icon = this.icon;
      }
      
      public function readSnapshot(param1:ObjectSnapshot) : void
      {
         loadingSnapshot = true;
         this.setPivot(param1.pivotX,param1.pivotY,param1.anchor);
         this.setSize(param1.width,param1.height,false,true);
         this.rotation = param1.rotation;
         this.setXY(param1.x,param1.y);
         this.setScale(param1.scaleX,param1.scaleY);
         this.setSkew(param1.skewX,param1.skewY);
         this.alpha = param1.alpha;
         this.visible = param1.visible;
         this.setProp(ObjectPropID.Color,param1.color);
         this.setProp(ObjectPropID.Playing,param1.playing);
         this.setProp(ObjectPropID.Frame,param1.frame);
         this._filterData.copyFrom(param1.filterData);
         if(param1.text != this.text)
         {
            this.text = param1.text;
         }
         if(param1.icon != this.icon)
         {
            this.icon = param1.icon;
         }
         this._displayObject.applyFilter();
         loadingSnapshot = false;
      }
      
      public function get isDown() : Boolean
      {
         return this._buttonStatus == 1;
      }
      
      public function triggerDown() : void
      {
         this._buttonStatus = 1;
         this._displayObject.stage.addEventListener(MouseEvent.MOUSE_UP,this.__stageMouseup,false,20);
         if((this._flags & FObjectFlags.IN_TEST) != 0 && hasEventListener(GTouchEvent.DRAG))
         {
            this._displayObject.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.__mousemove);
         }
      }
      
      private function initMTouch() : void
      {
         this._displayObject.addEventListener(MouseEvent.MOUSE_DOWN,this.__mousedown);
         this._displayObject.addEventListener(MouseEvent.MOUSE_UP,this.__mouseup);
      }
      
      private function __mousedown(param1:Event) : void
      {
         if((this._flags & FObjectFlags.IN_TEST) == 0)
         {
            return;
         }
         var _loc2_:GTouchEvent = new GTouchEvent(GTouchEvent.BEGIN);
         _loc2_.copyFrom(param1);
         this.dispatchEvent(_loc2_);
         if(_loc2_.isPropagationStop)
         {
            param1.stopPropagation();
         }
         if(this._touchDownPoint == null)
         {
            this._touchDownPoint = new Point();
         }
         this._touchDownPoint.x = MouseEvent(param1).stageX;
         this._touchDownPoint.y = MouseEvent(param1).stageY;
         this.triggerDown();
      }
      
      private function __mousemove(param1:Event) : void
      {
         if(this._buttonStatus != 1)
         {
            return;
         }
         var _loc2_:int = UIConfig.clickDragSensitivity;
         if(this._touchDownPoint != null && Math.abs(this._touchDownPoint.x - MouseEvent(param1).stageX) < _loc2_ && Math.abs(this._touchDownPoint.y - MouseEvent(param1).stageY) < _loc2_)
         {
            return;
         }
         var _loc3_:GTouchEvent = new GTouchEvent(GTouchEvent.DRAG);
         _loc3_.copyFrom(param1);
         this.dispatchEvent(_loc3_);
         if(_loc3_.isPropagationStop)
         {
            param1.stopPropagation();
         }
      }
      
      private function __mouseup(param1:Event) : void
      {
         if(this._buttonStatus != 1)
         {
            return;
         }
         this._buttonStatus = 2;
      }
      
      private function __stageMouseup(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:GTouchEvent = null;
         param1.currentTarget.removeEventListener(MouseEvent.MOUSE_UP,this.__stageMouseup);
         if(this._buttonStatus == 2)
         {
            _loc2_ = 1;
            _loc3_ = getTimer();
            if(_loc3_ - this._lastClick < 500)
            {
               _loc2_ = 2;
               this._lastClick = 0;
            }
            else
            {
               this._lastClick = _loc3_;
            }
            _loc4_ = new GTouchEvent(GTouchEvent.CLICK);
            _loc4_.copyFrom(param1,_loc2_);
            this.dispatchEvent(_loc4_);
         }
         this._buttonStatus = 0;
         _loc4_ = new GTouchEvent(GTouchEvent.END);
         _loc4_.copyFrom(param1);
         this.dispatchEvent(_loc4_);
      }
      
      function cancelChildrenClickEvent() : void
      {
         var _loc3_:FObject = null;
         var _loc1_:int = FComponent(this).numChildren;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = FComponent(this).getChildAt(_loc2_);
            _loc3_._buttonStatus = 0;
            if(_loc3_ is FComponent)
            {
               _loc3_.cancelChildrenClickEvent();
            }
            _loc2_++;
         }
      }
   }
}
