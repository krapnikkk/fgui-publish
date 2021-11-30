package fairygui.editor.gui
{
   import com.powerflasher.as3potrace.POTrace;
   import com.powerflasher.as3potrace.POTraceParams;
   import com.powerflasher.as3potrace.backend.GraphicsDataBackend;
   import fairygui.GMovieClip;
   import fairygui.UIPackage;
   import fairygui.editor.Consts;
   import fairygui.editor.api.ProjectType;
   import fairygui.utils.ColorMatrix;
   import fairygui.utils.Utils;
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.display.BlendMode;
   import flash.display.CapsStyle;
   import flash.display.Graphics;
   import flash.display.GraphicsEndFill;
   import flash.display.GraphicsSolidFill;
   import flash.display.GraphicsStroke;
   import flash.display.IGraphicsData;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class FSprite extends Sprite
   {
      
      private static var GRAY_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0,0,0,1,0]);
       
      
      private var _owner:FObject;
      
      private var _rootContainer:Sprite;
      
      private var _container:Sprite;
      
      private var _hitArea:Sprite;
      
      private var _maskArea:Sprite;
      
      private var _maskObject:FObject;
      
      private var _loadingSign:GMovieClip;
      
      private var _scaleX:Number;
      
      private var _scaleY:Number;
      
      private var _rotation:Number;
      
      private var _skewX:Number;
      
      private var _skewY:Number;
      
      private var _matrix:Matrix;
      
      private var _errorStatus:Boolean;
      
      private var _colorMatrix:ColorMatrix;
      
      private var _colorFilter:ColorMatrixFilter;
      
      private var _filters:Array;
      
      var _deformation:Boolean;
      
      public function FSprite(param1:FObject)
      {
         super();
         this._owner = param1;
         this._scaleX = 1;
         this._scaleY = 1;
         this._rotation = 0;
         this._skewX = 0;
         this._skewY = 0;
         this._matrix = new Matrix();
         this.mouseEnabled = false;
         this._rootContainer = new Sprite();
         addChild(this._rootContainer);
         this._container = new Sprite();
         this._rootContainer.addChild(this._container);
      }
      
      public function get owner() : FObject
      {
         return this._owner;
      }
      
      public function get rootContainer() : Sprite
      {
         return this._rootContainer;
      }
      
      public function get container() : Sprite
      {
         return this._container;
      }
      
      public final function get contentScaleX() : Number
      {
         return this._scaleX;
      }
      
      public function set contentScaleX(param1:Number) : void
      {
         this.setContentScale(param1,this._scaleY);
      }
      
      public final function get contentScaleY() : Number
      {
         return this._scaleY;
      }
      
      public function set contentScaleY(param1:Number) : void
      {
         this.setContentScale(this._scaleX,param1);
      }
      
      public function setContentScale(param1:Number, param2:Number) : void
      {
         if(this._scaleX != param1 || this._scaleY != param2)
         {
            this._scaleX = param1;
            this._scaleY = param2;
            this.updateMatrix();
         }
      }
      
      public final function get contentRotation() : Number
      {
         return this._rotation;
      }
      
      public function set contentRotation(param1:Number) : void
      {
         this._rotation = param1;
         this.updateMatrix();
      }
      
      public final function get contentSkewX() : Number
      {
         return this._skewX;
      }
      
      public function set contentSkewX(param1:Number) : void
      {
         this.setContentSkew(param1,this._skewY);
      }
      
      public final function get contentSkewY() : Number
      {
         return this._skewY;
      }
      
      public function set contentSkewY(param1:Number) : void
      {
         this.setContentScale(this._skewX,param1);
      }
      
      public function setContentSkew(param1:Number, param2:Number) : void
      {
         if(this._skewX != param1 || this._skewY != param2)
         {
            this._skewX = param1;
            this._skewY = param2;
            this.updateMatrix();
         }
      }
      
      public function get contentMatrix() : Matrix
      {
         return this._matrix;
      }
      
      public function reset() : void
      {
         if(this._maskArea != null && this._maskArea.parent != null)
         {
            this._maskArea.parent.removeChild(this._maskArea);
         }
         this._maskArea = null;
         this.blendMode = BlendMode.NORMAL;
         this._rootContainer.mask = null;
         if(this._maskObject)
         {
            this._maskObject.dispatcher.off(FObject.XY_CHANGED,this.onMaskChanged);
            this._maskObject.dispatcher.off(FObject.SCALE_CHANGED,this.onMaskChanged);
            this._maskObject.displayObject.removeEventListener(Event.ADDED_TO_STAGE,this.onMaskChanged2);
            this._maskObject.displayObject.removeEventListener(Event.REMOVED_FROM_STAGE,this.onMaskChanged2);
            this._maskObject = null;
         }
         if(this._hitArea != null && this._hitArea.parent != null)
         {
            this._hitArea.parent.removeChild(this._hitArea);
         }
         this._hitArea = null;
         this._rootContainer.hitArea = null;
         this._rootContainer.mouseEnabled = this._container.mouseEnabled = true;
      }
      
      public function setMask(param1:FObject) : void
      {
         this._maskObject = param1;
         if(this._maskArea == null)
         {
            this._maskArea = new Sprite();
            this._maskArea.mouseEnabled = false;
            if(FComponent(this._owner).reversedMask)
            {
               this._maskArea.blendMode = BlendMode.ERASE;
            }
         }
         var _loc2_:* = this._maskObject.displayObject.parent != null;
         if(_loc2_)
         {
            this._rootContainer.addChild(this._maskArea);
         }
         this._maskObject.displayObject._rootContainer.visible = false;
         this._maskObject.dispatcher.on(FObject.XY_CHANGED,this.onMaskChanged);
         this._maskObject.dispatcher.on(FObject.SCALE_CHANGED,this.onMaskChanged);
         this._maskObject.displayObject.addEventListener(Event.ADDED_TO_STAGE,this.onMaskChanged2);
         this._maskObject.displayObject.addEventListener(Event.REMOVED_FROM_STAGE,this.onMaskChanged2);
         this.onMaskChanged();
         this._maskArea.graphics.clear();
         if(this._maskObject is FImage)
         {
            if(FImage(this._maskObject).bitmap.bitmapData != null)
            {
               if(this._owner._pkg.project.supportAlphaMask && !FComponent(this._owner).reversedMask)
               {
                  this.fillBitmapToGraphics(FImage(this._maskObject).bitmap.bitmapData,this._maskArea.graphics,1);
               }
               else
               {
                  this._maskArea.graphics.beginBitmapFill(FImage(this._maskObject).bitmap.bitmapData,null,false);
                  this._maskArea.graphics.drawRect(0,0,this._maskObject.width,this._maskObject.height);
                  this._maskArea.graphics.endFill();
               }
            }
         }
         else
         {
            this._maskArea.graphics.copyFrom(this._maskObject.displayObject._container.graphics);
         }
         if(_loc2_)
         {
            if(FComponent(this._owner).reversedMask)
            {
               this.blendMode = BlendMode.LAYER;
            }
            else
            {
               this._rootContainer.mask = this._maskArea;
            }
         }
         this.drawBackground();
      }
      
      private function onMaskChanged() : void
      {
         var _loc1_:FSprite = this._maskObject.displayObject;
         var _loc2_:Matrix = new Matrix();
         Utils.skew(_loc2_,_loc1_.contentSkewX,_loc1_.contentSkewY);
         if(this._maskObject is FImage)
         {
            _loc2_.scale(_loc1_.contentScaleX * FImage(this._maskObject).bitmap.scaleX,_loc1_.contentScaleY * FImage(this._maskObject).bitmap.scaleY);
         }
         else
         {
            _loc2_.scale(_loc1_.contentScaleX,_loc1_.contentScaleY);
         }
         _loc2_.rotate(_loc1_.contentRotation * Utils.DEG_TO_RAD);
         _loc2_.translate(_loc1_.x,_loc1_.y);
         this._maskArea.transform.matrix = _loc2_;
      }
      
      private function onMaskChanged2(param1:Event) : void
      {
         if(param1.type == Event.ADDED_TO_STAGE)
         {
            this._rootContainer.addChild(this._maskArea);
            if(FComponent(this._owner).reversedMask)
            {
               this.blendMode = BlendMode.LAYER;
            }
            else
            {
               this._rootContainer.mask = this._maskArea;
            }
         }
         else
         {
            if(this._maskArea.parent)
            {
               this._rootContainer.removeChild(this._maskArea);
            }
            if(FComponent(this._owner).reversedMask)
            {
               this.blendMode = BlendMode.NORMAL;
            }
            else
            {
               this._rootContainer.mask = null;
            }
         }
      }
      
      public function setHitArea(param1:FObject) : void
      {
         this._rootContainer.mouseChildren = false;
         if(this._hitArea == null)
         {
            this._hitArea = new Sprite();
            this._hitArea.mouseEnabled = false;
            this._rootContainer.addChild(this._hitArea);
         }
         this._hitArea.x = param1.x;
         this._hitArea.y = param1.y;
         this._hitArea.scaleX = param1.scaleX;
         this._hitArea.scaleY = param1.scaleY;
         this._hitArea.graphics.clear();
         this._hitArea.visible = false;
         if(param1 is FImage)
         {
            if(FImage(param1).source != null)
            {
               this.fillBitmapToGraphics(FImage(param1).source,this._hitArea.graphics,0);
            }
         }
         else
         {
            this._hitArea.graphics.copyFrom(param1.displayObject._container.graphics);
         }
         this._rootContainer.hitArea = this._hitArea;
      }
      
      public function handleSizeChanged() : void
      {
         this.drawBackground();
      }
      
      public function handleXYChanged() : void
      {
         if(this._owner.anchor && !FObjectFlags.isDocRoot(this._owner._flags))
         {
            this.x = int(this._owner.x - this._owner.pivotX * this._owner.width) + this._owner.pivotOffsetX;
            this.y = int(this._owner.y - this._owner.pivotY * this._owner.height) + this._owner.pivotOffsetY;
         }
         else
         {
            this.x = int(this._owner.x) + this._owner.pivotOffsetX;
            this.y = int(this._owner.y) + this._owner.pivotOffsetY;
         }
      }
      
      public function get errorStatus() : Boolean
      {
         return this._errorStatus;
      }
      
      public function set errorStatus(param1:Boolean) : void
      {
         if(this._errorStatus != param1)
         {
            this._errorStatus = param1;
            this.drawBackground();
         }
      }
      
      private function drawBackground() : void
      {
         var _loc1_:Graphics = this._rootContainer.graphics;
         _loc1_.clear();
         var _loc2_:Number = this._owner.width;
         var _loc3_:Number = this._owner.height;
         var _loc4_:Boolean = false;
         if(this._errorStatus)
         {
            if(_loc2_ > 0 && _loc3_ > 0)
            {
               _loc1_.lineStyle(Consts.auxLineSize,16724736,1,true,LineScaleMode.NORMAL);
               _loc1_.beginFill(16777215,1);
               _loc1_.drawRect(0.5,0.5,_loc2_ - 1,_loc3_ - 1);
               _loc1_.endFill();
               _loc1_.moveTo(0.5,0.5);
               _loc1_.lineTo(_loc2_ - 1,_loc3_ - 1);
               _loc1_.moveTo(_loc2_ - 1,0.5);
               _loc1_.lineTo(0.5,_loc3_ - 1);
            }
            _loc4_ = true;
         }
         else if((this._owner._flags & FObjectFlags.INSPECTING) != 0 || ((this._owner._flags & FObjectFlags.IN_PREVIEW) == 0 && (this._owner is FComponent && FComponent(this._owner).opaque) || this._owner is FList))
         {
            if(_loc2_ > 0 && _loc3_ > 0)
            {
               _loc1_.lineStyle(0,0,0);
               _loc1_.beginFill(0,0);
               _loc1_.drawRect(0,0,_loc2_,_loc3_);
               _loc1_.endFill();
            }
            _loc4_ = true;
         }
         else
         {
            _loc4_ = false;
         }
         this._rootContainer.mouseEnabled = this._container.mouseEnabled = _loc4_;
      }
      
      private function updateMatrix() : void
      {
         this._matrix.identity();
         Utils.skew(this._matrix,this._skewX,this._skewY);
         this._matrix.scale(this._scaleX,this._scaleY);
         this._matrix.rotate(this._rotation * Utils.DEG_TO_RAD);
         this._deformation = this._matrix.a != 1 || this._matrix.b != 0 || this._matrix.c != 0 || this._matrix.d != 1;
         this._rootContainer.transform.matrix = this._matrix;
      }
      
      private function fillBitmapToGraphics(param1:BitmapData, param2:Graphics, param3:Number) : void
      {
         var _loc4_:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
         var _loc5_:GraphicsSolidFill = new GraphicsSolidFill(0,param3);
         _loc4_.push(new GraphicsStroke(1,false,LineScaleMode.NONE,CapsStyle.ROUND,JointStyle.ROUND,3,_loc5_));
         _loc4_.push(new GraphicsSolidFill(0,param3));
         var _loc6_:uint = 0;
         var _loc7_:String = ">";
         var _loc8_:int = 10;
         var _loc9_:Number = 1;
         var _loc10_:Boolean = false;
         var _loc11_:Number = 0.2;
         var _loc12_:POTraceParams = new POTraceParams(_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_);
         var _loc13_:BitmapData = new BitmapData(param1.width,param1.height,false,0);
         if(this._owner._pkg.project.type == ProjectType.CORONA)
         {
            _loc13_.draw(param1);
         }
         else
         {
            _loc13_.copyChannel(param1,param1.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.RED);
         }
         var _loc14_:POTrace = new POTrace(_loc12_);
         _loc14_.backend = new GraphicsDataBackend(_loc4_);
         _loc14_.potrace_trace(_loc13_);
         _loc13_.dispose();
         _loc4_.push(new GraphicsEndFill());
         param2.drawGraphicsData(_loc4_);
      }
      
      public function setLoading(param1:Boolean) : void
      {
         if(param1)
         {
            if(this._loadingSign == null)
            {
               this._loadingSign = UIPackage.createObject("Builder","loading").asMovieClip;
               this._loadingSign.touchable = false;
            }
            addChild(this._loadingSign.displayObject);
         }
         else if(this._loadingSign != null && this._loadingSign.displayObject.parent != null)
         {
            removeChild(this._loadingSign.displayObject);
         }
      }
      
      public function applyFilter() : void
      {
         var _loc1_:Boolean = this._owner.grayed && !(this._owner is FComponent);
         if(this._owner.filter == "none" && !_loc1_)
         {
            this.filters = null;
         }
         else
         {
            if(!this._filters)
            {
               this._filters = [];
            }
            else
            {
               this._filters.length = 0;
            }
            if(_loc1_)
            {
               this._filters.push(GRAY_FILTER);
            }
            if(this._owner.filter != "none")
            {
               if(this._colorFilter == null)
               {
                  this._colorMatrix = new ColorMatrix();
                  this._colorFilter = new ColorMatrixFilter();
               }
               else
               {
                  this._colorMatrix.reset();
               }
               this._colorMatrix.adjustBrightness(this._owner.filterData.brightness);
               this._colorMatrix.adjustContrast(this._owner.filterData.contrast);
               this._colorMatrix.adjustSaturation(this._owner.filterData.saturation);
               this._colorMatrix.adjustHue(this._owner.filterData.hue);
               this._colorFilter.matrix = this._colorMatrix;
               this._filters.push(this._colorFilter);
            }
            this.filters = this._filters;
         }
      }
   }
}
