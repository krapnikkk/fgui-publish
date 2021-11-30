package fairygui.editor.gui
{
   import com.powerflasher.as3potrace.POTrace;
   import com.powerflasher.as3potrace.POTraceParams;
   import com.powerflasher.as3potrace.backend.GraphicsDataBackend;
   import fairygui.editor.utils.Utils;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.GraphicsEndFill;
   import flash.display.GraphicsSolidFill;
   import flash.display.GraphicsStroke;
   import flash.display.IGraphicsData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class EUISprite extends Sprite
   {
      
      public static var deformationChanged:Boolean;
       
      
      public var owner:EGObject;
      
      public var rootContainer:Sprite;
      
      public var container:Sprite;
      
      private var _dashedRectShape:Shape;
      
      private var _hitArea:Sprite;
      
      private var _maskArea:Sprite;
      
      private var _title:TextField;
      
      private var _dashedRect:Boolean;
      
      private var _opaque:Boolean;
      
      private var _error:Boolean;
      
      private var _scaleX:Number;
      
      private var _scaleY:Number;
      
      private var _rotation:Number;
      
      private var _skewX:Number;
      
      private var _skewY:Number;
      
      private var _matrix:Matrix;
      
      public var deformation:Boolean;
      
      public function EUISprite(param1:EGObject)
      {
         super();
         this.owner = param1;
         this._scaleX = 1;
         this._scaleY = 1;
         this._rotation = 0;
         this._skewX = 0;
         this._skewY = 0;
         this._matrix = new Matrix();
         this.mouseEnabled = false;
         this.rootContainer = new Sprite();
         addChild(this.rootContainer);
         this.container = new Sprite();
         this.rootContainer.addChild(this.container);
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
      
      public function setDashedRect(param1:Boolean, param2:String) : void
      {
         if(this._dashedRect != param1)
         {
            this._dashedRect = param1;
            if(this._dashedRect)
            {
               if(!this._dashedRectShape)
               {
                  this._dashedRectShape = new Shape();
               }
               addChild(this._dashedRectShape);
               this._dashedRectShape.transform.matrix = this._matrix;
               this.drawDashedRect();
            }
            else if(this._dashedRectShape && this._dashedRectShape.parent)
            {
               removeChild(this._dashedRectShape);
            }
         }
         if(param2)
         {
            if(!this._title)
            {
               this.createTitle();
            }
            if(!this._title.parent)
            {
               this.rootContainer.addChild(this._title);
            }
            this._title.text = param2;
         }
         else if(this._title && this._title.parent)
         {
            this.rootContainer.removeChild(this._title);
         }
      }
      
      public function drawTo(param1:BitmapData, param2:Matrix) : void
      {
         if(this._dashedRectShape)
         {
            this._dashedRectShape.visible = false;
         }
         if(this._title)
         {
            this._title.visible = false;
         }
         param1.draw(this,param2,null,null,null,true);
         if(this._dashedRectShape)
         {
            this._dashedRectShape.visible = true;
         }
         if(this._title)
         {
            this._title.visible = true;
         }
      }
      
      public function setMask(param1:EGObject) : void
      {
         if(this._opaque)
         {
            this._opaque = false;
            this.rootContainer.graphics.clear();
         }
         if(this._maskArea == null)
         {
            this._maskArea = new Sprite();
            this._maskArea.mouseEnabled = false;
            addChild(this._maskArea);
         }
         param1.visible = false;
         param1.statusDispatcher.addListener(1,this.onMaskChanged);
         param1.statusDispatcher.addListener(3,this.onMaskChanged);
         this.onMaskChanged(param1);
         this._maskArea.graphics.clear();
         if(param1 is EGImage)
         {
            if(EGImage(param1).bitmap.bitmapData != null)
            {
               if(this.owner.pkg.project.type == "Unity" && !EGComponent(this.owner).reversedMask)
               {
                  this.fillBitmapToGraphics(EGImage(param1).bitmap.bitmapData,this._maskArea.graphics,1);
               }
               else
               {
                  this._maskArea.graphics.beginBitmapFill(EGImage(param1).bitmap.bitmapData,null,false);
                  this._maskArea.graphics.drawRect(0,0,param1.width,param1.height);
                  this._maskArea.graphics.endFill();
               }
            }
         }
         else
         {
            this._maskArea.graphics.copyFrom(param1.displayObject.container.graphics);
         }
         if(EGComponent(this.owner).reversedMask)
         {
            this._maskArea.blendMode = "erase";
            this.blendMode = "layer";
         }
         else
         {
            this.mask = this._maskArea;
         }
      }
      
      private function onMaskChanged(param1:EGObject) : void
      {
         var _loc3_:EUISprite = param1.displayObject;
         var _loc2_:Matrix = new Matrix();
         Utils.skew(_loc2_,_loc3_.contentSkewX,_loc3_.contentSkewY);
         if(param1 is EGImage)
         {
            _loc2_.scale(_loc3_.contentScaleX * EGImage(param1).bitmap.scaleX,_loc3_.contentScaleY * EGImage(param1).bitmap.scaleY);
         }
         else
         {
            _loc2_.scale(_loc3_.contentScaleX,_loc3_.contentScaleY);
         }
         _loc2_.rotate(_loc3_.contentRotation * 0.0174532925199433);
         _loc2_.translate(_loc3_.x,_loc3_.y);
         this._maskArea.transform.matrix = _loc2_;
      }
      
      public function setHitArea(param1:EGObject) : void
      {
         this.rootContainer.mouseChildren = false;
         if(this._hitArea == null)
         {
            this._hitArea = new Sprite();
            this._hitArea.mouseEnabled = false;
            this.rootContainer.addChild(this._hitArea);
         }
         this._hitArea.x = param1.x;
         this._hitArea.y = param1.y;
         this._hitArea.scaleX = param1.scaleX;
         this._hitArea.scaleY = param1.scaleY;
         this._hitArea.graphics.clear();
         if(param1 is EGImage)
         {
            if(EGImage(param1).source != null)
            {
               this.fillBitmapToGraphics(EGImage(param1).source,this._hitArea.graphics,0);
            }
         }
         else
         {
            this._hitArea.graphics.copyFrom(param1.displayObject.container.graphics);
         }
         this.rootContainer.hitArea = this._hitArea;
      }
      
      public function handleSizeChanged() : void
      {
         this.drawBackground();
         if(this._title)
         {
            this._title.width = this.owner.width;
            this._title.height = Math.min(20,this.owner.height);
         }
         if(this._dashedRect)
         {
            this.drawDashedRect();
         }
      }
      
      public function handleXYChanged() : void
      {
         if(this.owner.anchor && this.owner.editMode != 3)
         {
            this.x = int(this.owner.x - this.owner.pivotX * this.owner.width) + this.owner.pivotOffsetX;
            this.y = int(this.owner.y - this.owner.pivotY * this.owner.height) + this.owner.pivotOffsetY;
         }
         else
         {
            this.x = int(this.owner.x) + this.owner.pivotOffsetX;
            this.y = int(this.owner.y) + this.owner.pivotOffsetY;
         }
      }
      
      public function setError(param1:Boolean) : void
      {
         if(this._error != param1)
         {
            this._error = param1;
            this.drawBackground();
         }
      }
      
      public function onViewScaleChanged() : void
      {
         if(this._dashedRect)
         {
            this.drawDashedRect();
         }
      }
      
      private function createTitle() : void
      {
         this._title = new TextField();
         this._title.defaultTextFormat = new TextFormat(null,12,0,null,null,null,null,null,"center");
         this._title.mouseEnabled = false;
         this._title.width = this.owner.width;
         this._title.height = Math.min(20,this.owner.height);
         this.rootContainer.addChild(this._title);
      }
      
      private function drawBackground() : void
      {
         var _loc3_:Graphics = this.rootContainer.graphics;
         var _loc2_:Number = this.owner.width - 1;
         var _loc1_:Number = this.owner.height - 1;
         if(this._error)
         {
            _loc3_.clear();
            if(_loc2_ > 0 && _loc1_ > 0)
            {
               _loc3_.lineStyle(1,16724736,1);
               _loc3_.beginFill(16777215,1);
               _loc3_.drawRect(0,0,_loc2_,_loc1_);
               _loc3_.endFill();
               _loc3_.moveTo(0,0);
               _loc3_.lineTo(_loc2_,_loc1_);
               _loc3_.moveTo(_loc2_,0);
               _loc3_.lineTo(0,_loc1_);
            }
         }
         else if((this.owner.editMode == 2 || this.owner is EGComponent && EGComponent(this.owner).opaque || this.owner is EGList) && this.mask == null)
         {
            this._opaque = true;
            _loc3_.clear();
            if(_loc2_ > 0 && _loc1_ > 0)
            {
               _loc3_.lineStyle(0,0,0);
               _loc3_.beginFill(0,0);
               _loc3_.drawRect(0,0,_loc2_,_loc1_);
               _loc3_.endFill();
            }
         }
         else if(this._opaque)
         {
            this._opaque = false;
            _loc3_.clear();
         }
      }
      
      private function drawDashedRect() : void
      {
         var _loc3_:* = NaN;
         var _loc4_:Graphics = this._dashedRectShape.graphics;
         _loc4_.clear();
         _loc3_ = Number(1 / this.owner.pkg.project.editorWindow.mainPanel.viewScale);
         _loc3_ = 1;
         var _loc1_:Number = this.owner.width - _loc3_;
         var _loc2_:Number = this.owner.height - _loc3_;
         if(_loc1_ > 0 && _loc2_ > 0)
         {
            _loc4_.lineStyle(1,0,1,true,"none");
            Utils.drawDashedRect(_loc4_,0,0,_loc1_,_loc2_,5);
         }
      }
      
      private function updateMatrix() : void
      {
         this._matrix.identity();
         Utils.skew(this._matrix,this._skewX,this._skewY);
         this._matrix.scale(this._scaleX,this._scaleY);
         this._matrix.rotate(this._rotation * 0.0174532925199433);
         this.rootContainer.transform.matrix = this._matrix;
         if(this._dashedRectShape && this._dashedRectShape.parent)
         {
            this._dashedRectShape.transform.matrix = this._matrix;
         }
         if(this.owner is EGComponent || this.owner is EGTextField)
         {
            this.deformation = this._matrix.a != 1 || this._matrix.b != 0 || this._matrix.c != 0 || this._matrix.d != 1;
         }
      }
      
      private function fillBitmapToGraphics(param1:BitmapData, param2:Graphics, param3:Number) : void
      {
         var _loc9_:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
         var _loc10_:GraphicsSolidFill = new GraphicsSolidFill(0,param3);
         _loc9_.push(new GraphicsStroke(1,false,"none","round","round",3,_loc10_));
         _loc9_.push(new GraphicsSolidFill(0,param3));
         var _loc11_:uint = 0;
         var _loc14_:String = ">";
         var _loc12_:int = 10;
         var _loc13_:* = 1;
         var _loc5_:Boolean = false;
         var _loc7_:* = 0.2;
         var _loc6_:POTraceParams = new POTraceParams(_loc11_,_loc14_,_loc12_,_loc13_,_loc5_,_loc7_);
         var _loc8_:BitmapData = new BitmapData(param1.width,param1.height,false,0);
         _loc8_.copyChannel(param1,param1.rect,new Point(0,0),8,1);
         var _loc4_:POTrace = new POTrace(_loc6_);
         _loc4_.backend = new GraphicsDataBackend(_loc9_);
         _loc4_.potrace_trace(_loc8_);
         _loc8_.dispose();
         _loc9_.push(new GraphicsEndFill());
         param2.drawGraphicsData(_loc9_);
      }
   }
}
