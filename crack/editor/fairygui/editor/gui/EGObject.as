package fairygui.editor.gui
{
   import fairygui.GRoot;
   import fairygui.UIConfig;
   import fairygui.editor.ComDocument;
   import fairygui.editor.gui.gear.EGearAnimation;
   import fairygui.editor.gui.gear.EGearBase;
   import fairygui.editor.gui.gear.EGearColor;
   import fairygui.editor.gui.gear.EGearDisplay;
   import fairygui.editor.gui.gear.EGearIcon;
   import fairygui.editor.gui.gear.EGearLook;
   import fairygui.editor.gui.gear.EGearSize;
   import fairygui.editor.gui.gear.EGearText;
   import fairygui.editor.gui.gear.EGearXY;
   import fairygui.editor.gui.gear.EIAnimationGear;
   import fairygui.editor.gui.gear.EIColorGear;
   import fairygui.editor.utils.ColorMatrix;
   import fairygui.editor.utils.StatusDispatcher;
   import fairygui.editor.utils.Utils;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.event.GTouchEvent;
   import fairygui.utils.GTimers;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.utils.getTimer;
   
   public class EGObject extends EventDispatcher
   {
      
      public static const REMOVED:int = 0;
      
      public static const XY_CHANGED:int = 1;
      
      public static const SIZE_CHANGED:int = 2;
      
      public static const SCALE_CHANGED:int = 3;
      
      public static const ROTATION_CHANGED:int = 4;
      
      public static const PIVOT_CHANGED:int = 5;
      
      public static const SKEW_CHANGED:int = 6;
      
      public static var snapshotHandling:Boolean;
      
      private static var GRAY_FILTERS:Array = [new ColorMatrixFilter([0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0,0,0,1,0])];
      
      private static var helperMatrix:Matrix = new Matrix();
      
      private static var helperPoint:Point = new Point();
      
      public static var GearKeys:Object = {
         "gearDisplay":0,
         "gearXY":1,
         "gearSize":2,
         "gearLook":3,
         "gearColor":4,
         "gearAni":5,
         "gearText":6,
         "gearIcon":7
      };
      
      public static var GearXMLKeys:Object = {
         "gearDisplay":0,
         "gearXY":1,
         "gearSize":2,
         "gearLook":3,
         "gearColor":4,
         "gearAni":5,
         "gearText":6,
         "gearIcon":7
      };
       
      
      protected var _x:Number;
      
      protected var _y:Number;
      
      protected var _alpha:Number;
      
      protected var _rotation:Number;
      
      protected var _visible:Boolean;
      
      protected var _relations:ERelations;
      
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
      
      protected var _pivotOffsetX:Number;
      
      protected var _pivotOffsetY:Number;
      
      protected var _tooltips:String;
      
      protected var _events:String;
      
      protected var _clcikEvents:Object;
      
      protected var _blendMode:String;
      
      protected var _filter:String;
      
      protected var _skewX:Number;
      
      protected var _skewY:Number;
      
      var _gears:Vector.<EGearBase>;
      
      protected var _settingManually:Boolean;
      
      protected var _useSourceSize:Boolean;
      
      protected var _sourceWidth:int;
      
      protected var _sourceHeight:int;
      
      protected var _internalMinWidth:int;
      
      protected var _internalMinHeight:int;
      
      protected var _minWidth:int;
      
      protected var _minHeight:int;
      
      protected var _maxWidth:int;
      
      protected var _maxHeight:int;
      
      protected var _restrictSizeFromSource:Boolean;
      
      protected var _displayObject:EUISprite;
      
      protected var _statusDispatcher:StatusDispatcher;
      
      protected var _internalVisible:Boolean;
      
      protected var _handlingController:Boolean;
      
      public var _id:String;
      
      public var _name:String;
      
      public var _group:EGGroup;
      
      public var _width:Number;
      
      public var _height:Number;
      
      public var _rawWidth:Number;
      
      public var _rawHeight:Number;
      
      public var _initWidth:Number;
      
      public var _initHeight:Number;
      
      public var parent:EGComponent;
      
      public var pkg:EUIPackage;
      
      public var packageItem:EPackageItem;
      
      public var packageItemVersion:int;
      
      public var editMode:int;
      
      public var gearLocked:Boolean;
      
      public var rangeEditor:RangeEditor;
      
      public var hideByEditor:Boolean;
      
      public var fixedByDoc:Boolean;
      
      public var objectType:String;
      
      public var propPanelScrollPos:int;
      
      public var underConstruct:Boolean;
      
      public var constructingData:XML;
      
      public var widthEnabled:Boolean;
      
      public var heightEnabled:Boolean;
      
      public var sizePercent:Number;
      
      public var filter_cb:Number = 0;
      
      public var filter_cc:Number = 0;
      
      public var filter_cs:Number = 0;
      
      public var filter_ch:Number = 0;
      
      protected var _disposed:Boolean;
      
      private var _lastClick:int;
      
      private var _buttonStatus:int;
      
      private var _touchDownPoint:Point;
      
      public function EGObject()
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
         this._relations = new ERelations(this);
         this._displayObject = new EUISprite(this);
         this._statusDispatcher = new StatusDispatcher();
         this._locked = false;
         this.widthEnabled = true;
         this.heightEnabled = true;
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
         this._clcikEvents = {};
         this._events = "";
         this._pivotX = 0;
         this._pivotY = 0;
         this._pivotOffsetX = 0;
         this._pivotOffsetY = 0;
         this._internalVisible = true;
         this._blendMode = "normal";
         this._filter = "none";
         this._skewX = 0;
         this._skewY = 0;
         this._gears = new Vector.<EGearBase>(8,true);
         if(this is EGComponent)
         {
            this.initMTouch();
         }
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function set id(param1:String) : void
      {
         this._id = param1;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
         if(this.editMode == 2 && this.parent)
         {
            this.parent.namesChanged = true;
         }
      }
      
      public function get untouchable() : Boolean
      {
         return !this._touchable;
      }
      
      public function set untouchable(param1:Boolean) : void
      {
         this.touchable = !param1;
      }
      
      public function get touchable() : Boolean
      {
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
      
      protected function handleGrayedChanged() : void
      {
         if(this._displayObject)
         {
            if(this._grayed)
            {
               this._displayObject.filters = GRAY_FILTERS;
            }
            else
            {
               this._displayObject.filters = null;
            }
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
         if(this.packageItem != null)
         {
            return this.packageItem.getURL();
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
         if(!this._settingManually && this.fixedByDoc)
         {
            return;
         }
         if(this._x != param1 || this._y != param2)
         {
            _loc3_ = param1 - this._x;
            _loc4_ = param2 - this._y;
            this._x = param1;
            this._y = param2;
            this.handleXYChanged();
            if(this.parent)
            {
               if(!snapshotHandling)
               {
                  if(this._group)
                  {
                     this._group.update();
                  }
                  if(this is EGGroup)
                  {
                     EGGroup(this).moveChildren(_loc3_,_loc4_);
                  }
               }
               this.parent.setBoundsChangedFlag();
            }
            this.updateGear(1);
            this._statusDispatcher.dispatch(this,1);
         }
      }
      
      public function setXYV(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(!this._settingManually && this.fixedByDoc)
         {
            return;
         }
         if(this._x != param1 || this._y != param2)
         {
            _loc3_ = param1 - this._x;
            _loc4_ = param2 - this._y;
            this._x = param1;
            this._y = param2;
            this.handleXYChanged();
            if(this.parent)
            {
               if(!snapshotHandling)
               {
                  if(this._group)
                  {
                     this._group.update();
                  }
                  if(this is EGGroup)
                  {
                     EGGroup(this).moveChildren(_loc3_,_loc4_);
                  }
               }
               this.parent.setBoundsChangedFlag();
            }
            this.updateGear(1);
            this._statusDispatcher.dispatch(this,1);
         }
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
         if(this._settingManually)
         {
            if(!this.widthEnabled)
            {
               param1 = this._width;
            }
            if(!this.heightEnabled)
            {
               param2 = this._height;
            }
         }
         else if(this.fixedByDoc)
         {
            return;
         }
         if(param4)
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
         if(this._rawWidth != param1 || this._rawHeight != param2)
         {
            this._rawWidth = param1;
            this._rawHeight = param2;
            if(this.editMode != 1)
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
            if((this._pivotX != 0 || this._pivotY != 0) && this.editMode != 3)
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
            if(this._width != this._sourceWidth || this._height != this._sourceHeight)
            {
               if(this.editMode == 2 && this._settingManually && this.packageItem)
               {
                  this.setProperty("useSourceSize",false);
               }
               else
               {
                  this._useSourceSize = false;
               }
            }
            this.handleSizeChanged();
            if(this.parent)
            {
               if(!snapshotHandling)
               {
                  this._relations.onOwnerSizeChanged(this._settingManually,_loc5_,_loc6_);
                  if(this is EGGroup)
                  {
                     EGGroup(this).resizeChildren(_loc5_,_loc6_);
                  }
                  if(this._group)
                  {
                     this._group.update(true);
                  }
               }
               this.parent.setBoundsChangedFlag();
            }
            this.updateGear(2);
            this._statusDispatcher.dispatch(this,2);
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
      
      public function get sourceHeight() : int
      {
         return this._sourceHeight;
      }
      
      public function get sourceWidth() : int
      {
         return this._sourceWidth;
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
            if(this.parent)
            {
               this.parent.setBoundsChangedFlag();
            }
            this.updateGear(2);
            this._statusDispatcher.dispatch(this,3);
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
            this._statusDispatcher.dispatch(this,6);
         }
      }
      
      public function get pivotX() : Number
      {
         return this._pivotX;
      }
      
      public function set pivotX(param1:Number) : void
      {
         this.setPivot(param1,this._pivotY);
      }
      
      public function get pivotY() : Number
      {
         return this._pivotY;
      }
      
      public function set pivotY(param1:Number) : void
      {
         this.setPivot(this._pivotX,param1);
      }
      
      public function setPivot(param1:Number, param2:Number) : void
      {
         if(this._pivotX != param1 || this._pivotY != param2)
         {
            this._pivotFromSource = false;
            this._pivotX = param1;
            this._pivotY = param2;
            if(this.editMode != 3)
            {
               this.applyPivot();
               if(!this.underConstruct)
               {
                  this._statusDispatcher.dispatch(this,5);
               }
            }
         }
      }
      
      private function updatePivotOffset() : void
      {
         var _loc10_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc1_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc4_:Point = null;
         var _loc11_:Number = this.normalizeRotation;
         if(_loc11_ != 0 || this._scaleX != 1 || this._scaleY != 1 || this._skewX != 0 || this._skewY != 0)
         {
            _loc10_ = _loc11_ * 3.14159265358979 / 180;
            _loc8_ = this._pivotX * this._width;
            _loc9_ = this._pivotY * this._height;
            if(this._skewX == 0 && this._skewY == 0)
            {
               _loc1_ = Math.cos(_loc10_);
               _loc3_ = Math.sin(_loc10_);
               _loc7_ = this._scaleX * _loc1_;
               _loc6_ = this._scaleX * _loc3_;
               _loc5_ = this._scaleY * -_loc3_;
               _loc2_ = this._scaleY * _loc1_;
               this._pivotOffsetX = _loc8_ - (_loc7_ * _loc8_ + _loc5_ * _loc9_);
               this._pivotOffsetY = _loc9_ - (_loc2_ * _loc9_ + _loc6_ * _loc8_);
            }
            else
            {
               helperMatrix.identity();
               helperMatrix.scale(this._scaleX,this._scaleY);
               Utils.skew(helperMatrix,this._skewX,this._skewY);
               helperMatrix.rotate(_loc10_);
               helperPoint.x = this._pivotX * this._width;
               helperPoint.y = this._pivotY * this._height;
               _loc4_ = helperMatrix.transformPoint(helperPoint);
               this._pivotOffsetX = _loc8_ - _loc4_.x;
               this._pivotOffsetY = _loc9_ - _loc4_.y;
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
            if(this.editMode != 3)
            {
               this.handleXYChanged();
               this._statusDispatcher.dispatch(this,5);
            }
         }
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
      
      public function get useSourceSize() : Boolean
      {
         return this._useSourceSize;
      }
      
      public function set useSourceSize(param1:Boolean) : void
      {
         if(param1)
         {
            if(!this._relations.widthLocked)
            {
               this.setProperty("width",this._sourceWidth);
            }
            if(!this._relations.heightLocked)
            {
               this.setProperty("height",this._sourceHeight);
            }
            if(this._aspectLocked)
            {
               this._aspectRatio = this.width / this.height;
            }
            this._useSourceSize = true;
         }
         else
         {
            this._useSourceSize = false;
         }
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
            this._statusDispatcher.dispatch(this,4);
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
            this.updateAlpha();
         }
      }
      
      protected function updateAlpha() : void
      {
         if(this._displayObject != null)
         {
            this._displayObject.container.alpha = this._alpha;
         }
         this.updateGear(3);
      }
      
      public function get invisible() : Boolean
      {
         return !this._visible;
      }
      
      public function set invisible(param1:Boolean) : void
      {
         this.visible = !param1;
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
            if(this.parent)
            {
               this.parent.updateDisplayList();
            }
         }
      }
      
      public function get finalVisible() : Boolean
      {
         return (this._visible || this.editMode >= 2) && this._internalVisible && (!this._group || this._group.finalVisible) && !this.hideByEditor;
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
               this._group.update(true);
               this._group = null;
            }
            this._groupId = param1;
            if(this._groupId)
            {
               this._group = this.parent.getChildById(this._groupId) as EGGroup;
               if(this._group)
               {
                  this._group.update(true);
               }
            }
         }
      }
      
      public function get groupInst() : EGGroup
      {
         return this._group;
      }
      
      public function inGroup(param1:EGGroup) : Boolean
      {
         var _loc2_:EGGroup = this._group;
         while(_loc2_)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
            _loc2_ = _loc2_.groupInst;
         }
         return false;
      }
      
      public function get tooltips() : String
      {
         return this._tooltips;
      }
      
      public function set tooltips(param1:String) : void
      {
         if(this.editMode == 1 && this._tooltips)
         {
            this.displayObject.removeEventListener("rollOver",this.__rollOver);
            this.displayObject.removeEventListener("rollOut",this.__rollOut);
         }
         this._tooltips = param1;
         if(this.editMode == 1 && this._tooltips)
         {
            this.displayObject.addEventListener("rollOver",this.__rollOver);
            this.displayObject.addEventListener("rollOut",this.__rollOut);
         }
      }
      
      private function __rollOver(param1:Event) : void
      {
         GTimers.inst.callDelay(100,this.__doShowTooltips);
      }
      
      private function __doShowTooltips(param1:GRoot) : void
      {
         this.pkg.project.editorWindow.mainPanel.testPanel.showTooltips(this._tooltips);
      }
      
      private function __rollOut(param1:Event) : void
      {
         GTimers.inst.remove(this.__doShowTooltips);
         this.pkg.project.editorWindow.mainPanel.testPanel.hideTooltips();
      }
      
      public function get filter() : String
      {
         return this._filter;
      }
      
      public function set filter(param1:String) : void
      {
         this._filter = param1;
         if(this._filter != "none")
         {
            this.updateFilter();
         }
         else
         {
            this._displayObject.filters = null;
         }
      }
      
      public function updateFilter() : void
      {
         var _loc2_:ColorMatrixFilter = null;
         var _loc1_:ColorMatrix = null;
         if(this._filter == "color")
         {
            if(this._displayObject.filters == null || !(this._displayObject.filters[0] is ColorMatrixFilter))
            {
               _loc2_ = new ColorMatrixFilter();
            }
            else
            {
               _loc2_ = ColorMatrixFilter(this._displayObject.filters[0]);
            }
            _loc1_ = new ColorMatrix();
            _loc1_.adjustBrightness(this.filter_cb);
            _loc1_.adjustContrast(this.filter_cc);
            _loc1_.adjustSaturation(this.filter_cs);
            _loc1_.adjustHue(this.filter_ch);
            _loc2_.matrix = _loc1_;
            this._displayObject.filters = [_loc2_];
         }
      }
      
      public function get blendMode() : String
      {
         return this._blendMode;
      }
      
      public function set blendMode(param1:String) : void
      {
         this._blendMode = param1;
         var _loc2_:* = this._blendMode;
         if("normal" !== _loc2_)
         {
            if("none" !== _loc2_)
            {
               if("add" !== _loc2_)
               {
                  if("multiply" !== _loc2_)
                  {
                     if("screen" === _loc2_)
                     {
                        this._displayObject.blendMode = "screen";
                     }
                  }
                  else
                  {
                     this._displayObject.blendMode = "multiply";
                  }
               }
               else
               {
                  this._displayObject.blendMode = "add";
               }
            }
            else
            {
               this._displayObject.blendMode = "normal";
            }
         }
         else
         {
            this._displayObject.blendMode = "normal";
         }
      }
      
      public function handleControllerChanged(param1:EController) : void
      {
         var _loc2_:EGearBase = null;
         this._handlingController = true;
         var _loc3_:int = 0;
         while(_loc3_ < 8)
         {
            _loc2_ = this._gears[_loc3_];
            if(_loc2_ != null && _loc2_.controllerObject == param1)
            {
               _loc2_.apply();
            }
            _loc3_++;
         }
         this._handlingController = false;
         this.checkGearDisplay();
      }
      
      public final function getGear(param1:int) : EGearBase
      {
         var _loc2_:EGearBase = this._gears[param1];
         if(_loc2_ == null)
         {
            switch(int(param1))
            {
               case 0:
                  _loc2_ = new EGearDisplay(this);
                  break;
               case 1:
                  _loc2_ = new EGearXY(this);
                  break;
               case 2:
                  _loc2_ = new EGearSize(this);
                  break;
               case 3:
                  _loc2_ = new EGearLook(this);
                  break;
               case 4:
                  _loc2_ = new EGearColor(this);
                  break;
               case 5:
                  _loc2_ = new EGearAnimation(this);
                  break;
               case 6:
                  _loc2_ = new EGearText(this);
                  break;
               case 7:
                  _loc2_ = new EGearIcon(this);
            }
            this._gears[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      public function updateGear(param1:int) : void
      {
         if(this.underConstruct || this.gearLocked || this.parent && this.parent.editingTransition)
         {
            return;
         }
         var _loc2_:EGearBase = this._gears[param1];
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
      
      public function shouldDisplayGear(param1:int) : Boolean
      {
         return this._gears[param1] != null && this._gears[param1].display;
      }
      
      public function get clcikEvents() : Object
      {
         return this._clcikEvents;
      }
      
      public function set events(param1:String) : void
      {
         this._events = param1;
      }
      
      public function get events() : String
      {
         return this._events;
      }
      
      public function addEvent(param1:String, param2:Object) : void
      {
         if(param2.type == "" || param2.type == null)
         {
            param2.type = "C";
         }
         this._clcikEvents[param1] = param2;
         this.setProperty("events",this.clcikEventsToString());
      }
      
      private function clcikEventsToString() : String
      {
         var _loc1_:String = "";
         var _loc4_:int = 0;
         var _loc3_:* = this._clcikEvents;
         for(var _loc2_ in this._clcikEvents)
         {
            if(this._clcikEvents[_loc2_]["eventName"] == null)
            {
               this._clcikEvents[_loc2_]["eventName"] = _loc2_;
            }
            _loc1_ = _loc1_ + (this._clcikEvents[_loc2_]["eventName"] + "@" + this._clcikEvents[_loc2_]["title"]);
            if(this._clcikEvents[_loc2_]["type"])
            {
               _loc1_ = _loc1_ + ("@" + this._clcikEvents[_loc2_]["type"]);
            }
            _loc1_ = _loc1_ + "|";
         }
         _loc1_ = _loc1_.substr(0,_loc1_.length - 1);
         return _loc1_;
      }
      
      public function updateEvent(param1:String, param2:Object) : void
      {
         this._clcikEvents[param1] = param2;
         this.setProperty("events",this.clcikEventsToString());
      }
      
      public function removeEvent(param1:String) : void
      {
         delete this._clcikEvents[param1];
         this.setProperty("events",this.clcikEventsToString());
      }
      
      public function checkEvent(param1:String) : Boolean
      {
         return this._clcikEvents[param1] != null?true:false;
      }
      
      public function checkGearController(param1:int, param2:EController) : Boolean
      {
         return this._gears[param1] != null && this._gears[param1].controllerObject == param2;
      }
      
      public function checkGearsController(param1:EController) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < 8)
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
         var _loc1_:uint = 0;
         var _loc2_:EGearDisplay = EGearDisplay(this._gears[0]);
         if(_loc2_ && _loc2_.controllerObject)
         {
            _loc1_ = _loc2_.addLock();
            this.checkGearDisplay();
            return _loc1_;
         }
         return 0;
      }
      
      public function releaseDisplayLock(param1:uint) : void
      {
         var _loc2_:EGearDisplay = EGearDisplay(this._gears[0]);
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
         var _loc1_:Boolean = this._gears[0] == null || EGearDisplay(this._gears[0]).connected;
         if(_loc1_ != this._internalVisible)
         {
            this._internalVisible = _loc1_;
            if(this.parent)
            {
               this.parent.updateDisplayList();
            }
         }
      }
      
      public final function get gearDisplay() : EGearDisplay
      {
         return EGearDisplay(this.getGear(0));
      }
      
      public function get relations() : ERelations
      {
         return this._relations;
      }
      
      public function get statusDispatcher() : StatusDispatcher
      {
         return this._statusDispatcher;
      }
      
      public function get displayObject() : EUISprite
      {
         return this._displayObject;
      }
      
      public function removeFromParent() : void
      {
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      protected function handleXYChanged() : void
      {
         this._displayObject.handleXYChanged();
      }
      
      protected function handleSizeChanged() : void
      {
         this._displayObject.handleSizeChanged();
      }
      
      protected function handleTouchableChanged() : void
      {
         if(this.editMode == 2)
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
         else if(this is EGImage || this is EGTextField && !EGTextField(this).input)
         {
            this._displayObject.mouseChildren = false;
         }
         else
         {
            this._displayObject.mouseChildren = this._touchable;
         }
      }
      
      public function get deprecated() : Boolean
      {
         if(this.packageItem)
         {
            return this.packageItemVersion != this.packageItem.version;
         }
         return false;
      }
      
      public function validate() : void
      {
         if(this.deprecated)
         {
            this.recreate();
         }
         else if(this is EGComponent)
         {
            EGComponent(this).validateChildren();
         }
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
      
      public function setProperty(param1:String, param2:*) : *
      {
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc6_:ETransition = null;
         var _loc10_:ActionHistory = null;
         var _loc9_:int = 0;
         var _loc8_:ETransitionItem = null;
         var _loc5_:Boolean = false;
         var _loc7_:String = null;
         var _loc4_:String = null;
         _loc11_ = this[param1];
         if(Utils.equalText(param2,_loc11_))
         {
            return _loc11_;
         }
         if(this is EGGroup)
         {
            if(param1 == "scaleX" || param1 == "scaleY" || param1 == "aspectLocked" || param1 == "useSourceSize" || param1 == "touchable")
            {
               return _loc11_;
            }
         }
         else if(this is EGTextField || this is EGRichTextField)
         {
            if(param1 == "aspectLocked" || param1 == "useSourceSize" || param1 == "touchable")
            {
               return _loc11_;
            }
         }
         else if(this is EGList)
         {
            if(param1 == "aspectLocked" || param1 == "useSourceSize")
            {
               return _loc11_;
            }
         }
         else if(this is EGLoader)
         {
            if(param1 == "useSourceSize")
            {
               return _loc11_;
            }
         }
         else if(this is EGGraph)
         {
            if(param1 == "useSourceSize")
            {
               return _loc11_;
            }
         }
         else if(this is EGImage || this is EGMovieClip)
         {
            if(param1 == "touchable")
            {
               return _loc11_;
            }
         }
         var _loc3_:Boolean = this._settingManually;
         this._settingManually = true;
         this[param1] = param2;
         this._settingManually = _loc3_;
         _loc12_ = this[param1];
         if(!this.underConstruct && !Utils.equalText(_loc12_,_loc11_))
         {
            if(this.parent)
            {
               _loc6_ = this.parent.editingTransition;
            }
            else if(this.editMode == 3)
            {
               _loc6_ = EGComponent(this).editingTransition;
            }
            _loc10_ = this.pkg.project.editorWindow.activeComDocument.actionHistory;
            if(_loc6_ == null)
            {
               _loc10_.action_propertySet(this,param1,_loc11_,_loc12_);
            }
            if(UtilsStr.startsWith(param1,"filter_"))
            {
               this.updateFilter();
            }
            if(_loc6_ != null && (param1 == "x" || param1 == "y" || param1 == "width" || param1 == "height"))
            {
               _loc9_ = this.pkg.project.editorWindow.mainPanel.editPanel.timelinePanel.head;
               _loc8_ = _loc6_.findItem(_loc9_,this._id,"XY");
               if(_loc8_ != null)
               {
                  _loc7_ = _loc8_.value.encode(_loc8_.type);
                  _loc8_.value.a = this._x;
                  _loc8_.value.b = this._y;
                  _loc4_ = _loc8_.value.encode(_loc8_.type);
                  _loc10_.action_transItemSet(_loc8_,null,_loc7_,_loc4_);
                  _loc5_ = true;
               }
               _loc8_ = _loc6_.findItem(_loc9_,this._id,"Size");
               if(_loc8_ != null)
               {
                  _loc7_ = _loc8_.value.encode(_loc8_.type);
                  _loc8_.value.a = this._width;
                  _loc8_.value.b = this._height;
                  _loc4_ = _loc8_.value.encode(_loc8_.type);
                  _loc10_.action_transItemSet(_loc8_,null,_loc7_,_loc4_);
                  _loc5_ = true;
               }
               if(_loc5_)
               {
                  if(this.parent)
                  {
                     this.parent.setModified();
                  }
                  else
                  {
                     this.setModified();
                  }
               }
            }
         }
         return _loc12_;
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
         if(this.packageItem)
         {
            _loc1_ = _loc1_ + (" {" + this.packageItem.name + "}");
         }
         return _loc1_;
      }
      
      public function getDetailString() : String
      {
         var _loc1_:String = null;
         if(this.packageItem)
         {
            _loc1_ = this.packageItem.name + " @" + this.packageItem.owner.name;
         }
         else
         {
            _loc1_ = "";
         }
         return _loc1_;
      }
      
      public function setError(param1:Boolean) : void
      {
         if(param1)
         {
            if(this._sourceWidth == 0 || this._sourceHeight == 0)
            {
               this._sourceWidth = 100;
               this._sourceHeight = 100;
               this.setSize(this._sourceWidth,this._sourceHeight);
            }
         }
         this.displayObject.setError(param1);
      }
      
      public function create() : void
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
         this._statusDispatcher.clear();
         this.handleDispose();
      }
      
      protected function handleDispose() : void
      {
      }
      
      public function recreate() : void
      {
         var _loc4_:Number = this._width;
         var _loc3_:Number = this._height;
         var _loc1_:XML = this.toXML();
         this._name = "";
         this._alpha = 1;
         this._rotation = 0;
         this._visible = true;
         this._touchable = true;
         this._grayed = false;
         this._anchor = false;
         var _loc5_:* = 0;
         this._sourceHeight = _loc5_;
         _loc5_ = _loc5_;
         this._sourceWidth = _loc5_;
         _loc5_ = _loc5_;
         this._initHeight = _loc5_;
         this._initWidth = _loc5_;
         _loc5_ = 0;
         this._maxHeight = _loc5_;
         _loc5_ = _loc5_;
         this._minHeight = _loc5_;
         _loc5_ = _loc5_;
         this._maxWidth = _loc5_;
         this._minWidth = _loc5_;
         _loc5_ = 0;
         this._pivotY = _loc5_;
         this._pivotX = _loc5_;
         this._relations.reset();
         if(this.packageItem)
         {
            this.packageItemVersion = this.packageItem.version;
         }
         this.underConstruct = true;
         this.create();
         var _loc2_:String = _loc1_.@size;
         if(_loc2_)
         {
            if(this.relations.widthLocked && this.relations.heightLocked)
            {
               delete _loc1_.@size;
            }
            else if(this.relations.widthLocked)
            {
               _loc1_.@size = this._sourceWidth + "," + _loc3_;
            }
            else if(this.relations.heightLocked)
            {
               _loc1_.@size = _loc4_ + "," + this._sourceHeight;
            }
         }
         this.fromXML_beforeAdd(_loc1_);
         this._relations.fromXML(_loc1_);
         this.fromXML_afterAdd(_loc1_);
         if(this.rangeEditor != null)
         {
            this.rangeEditor.synEditorRange();
         }
         this.underConstruct = false;
      }
      
      public function fromXML_beforeAdd(param1:XML) : void
      {
         var _loc3_:* = null;
         var _loc6_:int = 0;
         var _loc2_:* = null;
         var _loc5_:String = null;
         this._id = param1.@id;
         this._name = param1.@name;
         this.locked = param1.@locked == "true";
         this.hideByEditor = param1.@hideByEditor == "true";
         this._aspectLocked = param1.@aspect == "true";
         this._visible = param1.@visible != "false";
         this.touchable = param1.@touchable != "false";
         this.grayed = param1.@grayed == "true";
         _loc5_ = param1.@xy;
         var _loc4_:Array = _loc5_.split(",");
         this.setXY(int(_loc4_[0]),int(_loc4_[1]));
         _loc5_ = param1.@pivot;
         if(_loc5_)
         {
            _loc4_ = _loc5_.split(",");
            this._anchor = param1.@anchor == "true";
            this.setPivot(parseFloat(_loc4_[0]),parseFloat(_loc4_[1]));
         }
         else if(this._pivotX != 0 || this._pivotY != 0)
         {
            this.applyPivot();
         }
         _loc5_ = param1.@size;
         if(_loc5_)
         {
            this._useSourceSize = false;
            _loc4_ = _loc5_.split(",");
            this._initWidth = int(_loc4_[0]);
            this._initHeight = int(_loc4_[1]);
            this.setSize(this._initWidth,this._initHeight,true);
            if(this._aspectLocked)
            {
               this._aspectRatio = this._width / this._height;
            }
         }
         else
         {
            this.useSourceSize = true;
            this._initWidth = this._sourceWidth;
            this._initHeight = this._sourceHeight;
         }
         _loc5_ = param1.@restrictSize;
         if(_loc5_)
         {
            _loc4_ = _loc5_.split(",");
            this._minWidth = int(_loc4_[0]);
            this._maxWidth = int(_loc4_[1]);
            this._minHeight = int(_loc4_[2]);
            this._maxHeight = int(_loc4_[3]);
            this._restrictSizeFromSource = false;
         }
         _loc5_ = param1.@scale;
         if(_loc5_)
         {
            _loc4_ = _loc5_.split(",");
            this.setScale(parseFloat(_loc4_[0]),parseFloat(_loc4_[1]));
         }
         _loc5_ = param1.@skew;
         if(_loc5_)
         {
            _loc4_ = _loc5_.split(",");
            this.setSkew(parseInt(_loc4_[0]),parseInt(_loc4_[1]));
         }
         _loc5_ = param1.@alpha;
         if(_loc5_)
         {
            this.alpha = parseFloat(_loc5_);
         }
         else
         {
            this.alpha = 1;
         }
         _loc5_ = param1.@rotation;
         if(_loc5_)
         {
            this.rotation = parseInt(_loc5_);
         }
         else
         {
            this.rotation = 0;
         }
         _loc5_ = param1.@tooltips;
         if(_loc5_)
         {
            this.tooltips = _loc5_;
         }
         _loc5_ = param1.@events;
         if(_loc5_)
         {
            _loc3_ = _loc5_.split("|");
            _loc6_ = 0;
            while(_loc6_ < _loc3_.length)
            {
               _loc2_ = _loc3_[_loc6_].split("@");
               this.addEvent(_loc2_[0] + _loc2_[2],{
                  "title":_loc2_[1],
                  "eventName":_loc2_[0],
                  "type":_loc2_[2]
               });
               _loc6_++;
            }
         }
         _loc5_ = param1.@blend;
         if(_loc5_)
         {
            this.blendMode = _loc5_;
         }
         _loc5_ = param1.@filter;
         if(_loc5_)
         {
            this._filter = _loc5_;
            _loc5_ = param1.@filterData;
            _loc4_ = _loc5_.split(",");
            this.filter_cb = parseFloat(_loc4_[0]);
            this.filter_cc = parseFloat(_loc4_[1]);
            this.filter_cs = parseFloat(_loc4_[2]);
            this.filter_ch = parseFloat(_loc4_[3]);
            this.updateFilter();
         }
      }
      
      public function fromXML_afterAdd(param1:XML) : void
      {
         var _loc4_:XML = null;
         var _loc2_:* = undefined;
         var _loc5_:String = param1.@group;
         if(_loc5_)
         {
            this.groupId = _loc5_;
         }
         var _loc3_:Object = param1.elements();
         var _loc7_:int = 0;
         var _loc6_:* = _loc3_;
         for each(_loc4_ in _loc3_)
         {
            _loc2_ = GearXMLKeys[_loc4_.name().localName];
            if(_loc2_ != undefined)
            {
               this.getGear(int(_loc2_)).fromXML(_loc4_);
            }
         }
      }
      
      public function toXML() : XML
      {
         var _loc1_:int = 0;
         var _loc3_:Boolean = this is EGGroup && !EGGroup(this).advanced;
         var _loc2_:XML = new XML("<" + this.objectType + "/>");
         _loc2_.@id = this._id;
         _loc2_.@name = this._name;
         if(this.packageItem)
         {
            _loc2_.@src = this.packageItem.id;
         }
         if(this.parent && this.pkg != this.parent.pkg)
         {
            _loc2_.@pkg = this.pkg.id;
         }
         _loc2_.@xy = int(this._x) + "," + int(this._y);
         if(!this._pivotFromSource && (this._pivotX != 0 || this._pivotY != 0))
         {
            _loc2_.@pivot = UtilsStr.toFixed(this._pivotX) + "," + UtilsStr.toFixed(this._pivotY);
            if(this._anchor)
            {
               _loc2_.@anchor = true;
            }
         }
         if(!this.parent || !(this.parent is EGList))
         {
            if(!this._useSourceSize)
            {
               _loc2_.@size = int(this._width) + "," + int(this._height);
            }
         }
         if(!this._restrictSizeFromSource && (this._minWidth != 0 || this._maxWidth != 0 || this._minHeight != 0 || this._maxHeight != 0))
         {
            _loc2_.@restrictSize = this._minWidth + "," + this._maxWidth + "," + this._minHeight + "," + this._maxHeight;
         }
         if(this._group)
         {
            _loc2_.@group = this._groupId;
         }
         if(this._locked)
         {
            _loc2_.@locked = "true";
         }
         if(this.hideByEditor)
         {
            _loc2_.@hideByEditor = "true";
         }
         if(!(this is EGTextField) && !(this is EGGroup))
         {
            if(this._aspectLocked)
            {
               _loc2_.@aspect = "true";
            }
         }
         if(this._scaleX != 1 || this._scaleY != 1)
         {
            _loc2_.@scale = UtilsStr.toFixed(this._scaleX) + "," + UtilsStr.toFixed(this._scaleY);
         }
         if(this._skewX != 0 || this._skewY != 0)
         {
            _loc2_.@skew = this._skewX + "," + this._skewY;
         }
         if(!this._visible && !_loc3_)
         {
            _loc2_.@visible = false;
         }
         if(this._alpha != 1)
         {
            _loc2_.@alpha = this._alpha;
         }
         if(this._rotation != 0)
         {
            _loc2_.@rotation = this._rotation;
         }
         if(!this._touchable)
         {
            _loc2_.@touchable = false;
         }
         if(this._grayed)
         {
            _loc2_.@grayed = true;
         }
         if(this._blendMode != "normal")
         {
            _loc2_.@blend = this._blendMode;
         }
         if(this._filter != "none")
         {
            _loc2_.@filter = this._filter;
            _loc2_.@filterData = this.filter_cb.toFixed(2) + "," + this.filter_cc.toFixed(2) + "," + this.filter_cs.toFixed(2) + "," + this.filter_ch.toFixed(2);
         }
         if(this._tooltips)
         {
            _loc2_.@tooltips = this._tooltips;
         }
         if(this._clcikEvents)
         {
            _loc2_.@events = this._events;
         }
         if(!_loc3_)
         {
            _loc1_ = 0;
            while(_loc1_ < 8)
            {
               if(this._gears[_loc1_] != null && this._gears[_loc1_].controllerObject && this._gears[_loc1_].controllerObject.parent)
               {
                  _loc2_.appendChild(this._gears[_loc1_].toXML());
               }
               _loc1_++;
            }
            if(!this._relations.isEmpty)
            {
               _loc2_.appendChild(this._relations.toXML().relation);
            }
         }
         return _loc2_;
      }
      
      function __takeSnapshot(param1:ObjectSnapshot) : void
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
         param1.alpha = this._alpha;
         param1.rotation = this._rotation;
         param1.visible = this._visible;
         if(this is EIColorGear)
         {
            param1.color = EIColorGear(this).color;
         }
         if(this is EIAnimationGear)
         {
            param1.aniName = EIAnimationGear(this).aniName;
            param1.playing = EIAnimationGear(this).playing;
            param1.frame = EIAnimationGear(this).frame;
         }
         param1.filter_cb = this.filter_cb;
         param1.filter_cc = this.filter_cc;
         param1.filter_cs = this.filter_cs;
         param1.filter_ch = this.filter_ch;
         param1.filter = this._filter;
      }
      
      function __readSnapshot(param1:ObjectSnapshot) : void
      {
         snapshotHandling = true;
         this.setPivot(param1.pivotX,param1.pivotY);
         this.setSize(param1.width,param1.height);
         this.rotation = param1.rotation;
         this.setXY(param1.x,param1.y);
         this.setScale(param1.scaleX,param1.scaleY);
         this.setSkew(param1.skewX,param1.skewY);
         this.alpha = param1.alpha;
         this.visible = param1.visible;
         if(this is EIColorGear)
         {
            EIColorGear(this).color = param1.color;
         }
         if(this is EIAnimationGear)
         {
            EIAnimationGear(this).aniName = param1.aniName;
            EIAnimationGear(this).playing = param1.playing;
            EIAnimationGear(this).frame = param1.frame;
         }
         this.filter_cb = param1.filter_cb;
         this.filter_cc = param1.filter_cc;
         this.filter_cs = param1.filter_cs;
         this.filter_ch = param1.filter_ch;
         this.filter = param1.filter;
         snapshotHandling = false;
      }
      
      public function setModified() : void
      {
         var _loc1_:ComDocument = null;
         if(this.packageItem)
         {
            this.packageItem.invalidate();
            _loc1_ = this.packageItem.owner.project.editorWindow.mainPanel.editPanel.findComDocument(this.packageItem.owner,this.packageItem.id);
            if(_loc1_)
            {
               _loc1_.setModified();
            }
         }
      }
      
      public function get isDown() : Boolean
      {
         return this._buttonStatus == 1;
      }
      
      public function triggerDown() : void
      {
         this._buttonStatus = 1;
         this._displayObject.stage.addEventListener("mouseUp",this.__stageMouseup,false,20);
         if(this.editMode == 1 && hasEventListener("dragGTouch"))
         {
            this._displayObject.stage.addEventListener("mouseMove",this.__mousemove);
         }
      }
      
      private function initMTouch() : void
      {
         this._displayObject.addEventListener("mouseDown",this.__mousedown);
         this._displayObject.addEventListener("mouseUp",this.__mouseup);
      }
      
      private function __mousedown(param1:Event) : void
      {
         if(this.editMode != 1)
         {
            return;
         }
         var _loc2_:GTouchEvent = new GTouchEvent("beginGTouch");
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
         var _loc3_:int = UIConfig.clickDragSensitivity;
         if(this._touchDownPoint != null && Math.abs(this._touchDownPoint.x - MouseEvent(param1).stageX) < _loc3_ && Math.abs(this._touchDownPoint.y - MouseEvent(param1).stageY) < _loc3_)
         {
            return;
         }
         var _loc2_:GTouchEvent = new GTouchEvent("dragGTouch");
         _loc2_.copyFrom(param1);
         this.dispatchEvent(_loc2_);
         if(_loc2_.isPropagationStop)
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
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:GTouchEvent = null;
         param1.currentTarget.removeEventListener("mouseUp",this.__stageMouseup);
         if(this._buttonStatus == 2)
         {
            _loc4_ = 1;
            _loc2_ = getTimer();
            if(_loc2_ - this._lastClick < 500)
            {
               _loc4_ = 2;
               this._lastClick = 0;
            }
            else
            {
               this._lastClick = _loc2_;
            }
            _loc3_ = new GTouchEvent("clickGTouch");
            _loc3_.copyFrom(param1,_loc4_);
            this.dispatchEvent(_loc3_);
         }
         this._buttonStatus = 0;
         _loc3_ = new GTouchEvent("endGTouch");
         _loc3_.copyFrom(param1);
         this.dispatchEvent(_loc3_);
      }
      
      function cancelChildrenClickEvent() : void
      {
         var _loc1_:EGObject = null;
         var _loc3_:int = EGComponent(this).numChildren;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = EGComponent(this).getChildAt(_loc2_);
            _loc1_._buttonStatus = 0;
            if(_loc1_ is EGComponent)
            {
               _loc1_.cancelChildrenClickEvent();
            }
            _loc2_++;
         }
      }
   }
}
