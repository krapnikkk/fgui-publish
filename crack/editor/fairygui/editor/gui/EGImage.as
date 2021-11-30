package fairygui.editor.gui
{
   import fairygui.editor.gui.gear.EIColorGear;
   import fairygui.editor.utils.ImageFillUtils;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.utils.GTimers;
   import fairygui.utils.ToolSet;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   
   public class EGImage extends EGObject implements EIColorGear
   {
       
      
      private var _content:Bitmap;
      
      private var _bmdSource:BitmapData;
      
      private var _color:uint;
      
      private var _flip:String;
      
      private var _fillMethod:String;
      
      private var _fillOrigin:int;
      
      private var _fillClockwise:Boolean;
      
      private var _fillAmount:int;
      
      public function EGImage()
      {
         super();
         this.objectType = "image";
         this._color = 16777215;
         this._flip = "none";
         this._fillMethod = "none";
         this._fillClockwise = true;
         this._fillAmount = 100;
         this._content = new Bitmap(null,"auto",true);
         _displayObject.container.addChild(this._content);
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set color(param1:uint) : void
      {
         if(this._color != param1)
         {
            this._color = param1;
            this.applyColor();
            updateGear(4);
         }
      }
      
      private function applyColor() : void
      {
         var _loc1_:ColorTransform = this._content.transform.colorTransform;
         _loc1_.redMultiplier = (this._color >> 16 & 255) / 255;
         _loc1_.greenMultiplier = (this._color >> 8 & 255) / 255;
         _loc1_.blueMultiplier = (this._color & 255) / 255;
         this._content.transform.colorTransform = _loc1_;
      }
      
      public function get flip() : String
      {
         return this._flip;
      }
      
      public function set flip(param1:String) : void
      {
         if(this._flip != param1)
         {
            this._flip = param1;
            this.updateBitmap();
         }
      }
      
      public function get fillOrigin() : int
      {
         return this._fillOrigin;
      }
      
      public function set fillOrigin(param1:int) : void
      {
         if(this._fillOrigin != param1)
         {
            this._fillOrigin = param1;
            this.updateBitmap();
         }
      }
      
      public function get fillClockwise() : Boolean
      {
         return this._fillClockwise;
      }
      
      public function set fillClockwise(param1:Boolean) : void
      {
         if(this._fillClockwise != param1)
         {
            this._fillClockwise = param1;
            this.updateBitmap();
         }
      }
      
      public function get fillMethod() : String
      {
         return this._fillMethod;
      }
      
      public function set fillMethod(param1:String) : void
      {
         if(this._fillMethod != param1)
         {
            this._fillMethod = param1;
            this.updateBitmap();
         }
      }
      
      public function get fillAmount() : int
      {
         return this._fillAmount;
      }
      
      public function set fillAmount(param1:int) : void
      {
         if(this._fillAmount != param1)
         {
            this._fillAmount = param1;
            this.updateBitmap();
         }
      }
      
      public function get bitmap() : Bitmap
      {
         return this._content;
      }
      
      public function get source() : BitmapData
      {
         return this._bmdSource;
      }
      
      override public function create() : void
      {
         this._bmdSource = null;
         if(packageItem == null)
         {
            this._content.bitmapData = null;
            setError(true);
            return;
         }
         _sourceWidth = packageItem.width;
         _sourceHeight = packageItem.height;
         setSize(_sourceWidth,_sourceHeight);
         aspectLocked = true;
         pkg.getImage(packageItem,this.__imageLoaded);
      }
      
      private function __imageLoaded(param1:EPackageItem) : void
      {
         if(_disposed || packageItem != param1)
         {
            return;
         }
         if(param1.data == null)
         {
            this._bmdSource = null;
            this._content.bitmapData = null;
            setError(true);
         }
         else
         {
            setError(false);
            this._bmdSource = BitmapData(param1.data);
            this._content.bitmapData = this._bmdSource;
            this._content.smoothing = packageItem.imageSetting.smoothing;
         }
         this.handleSizeChanged();
      }
      
      override protected function handleSizeChanged() : void
      {
         super.handleSizeChanged();
         if(packageItem && (packageItem.imageSetting.scaleOption == "tile" || packageItem.imageSetting.scaleOption == "9grid"))
         {
            this._content.scaleX = 1;
            this._content.scaleY = 1;
         }
         else
         {
            this._content.scaleX = _width / _sourceWidth;
            this._content.scaleY = _height / _sourceHeight;
         }
         this.updateBitmap();
      }
      
      override protected function handleDispose() : void
      {
         if(this._content.bitmapData != null && this._content.bitmapData != this._bmdSource)
         {
            this._content.bitmapData.dispose();
            this._content.bitmapData = null;
         }
         this._bmdSource = null;
      }
      
      override public function fromXML_beforeAdd(param1:XML) : void
      {
         super.fromXML_beforeAdd(param1);
         var _loc2_:String = param1.@color;
         if(_loc2_)
         {
            this._color = UtilsStr.convertFromHtmlColor(_loc2_);
         }
         else
         {
            this._color = 16777215;
         }
         _loc2_ = param1.@flip;
         if(_loc2_)
         {
            this._flip = _loc2_;
         }
         _loc2_ = param1.@fillMethod;
         if(_loc2_)
         {
            this._fillMethod = _loc2_;
            _loc2_ = param1.@fillOrigin;
            if(_loc2_)
            {
               this._fillOrigin = parseInt(_loc2_);
            }
            this._fillClockwise = param1.@fillClockwise != "false";
            _loc2_ = param1.@fillAmount;
            if(_loc2_)
            {
               this._fillAmount = parseInt(_loc2_);
            }
            else
            {
               this._fillAmount = 100;
            }
            this.updateBitmap();
         }
         this.applyColor();
      }
      
      override public function fromXML_afterAdd(param1:XML) : void
      {
         super.fromXML_afterAdd(param1);
         if(param1.@forHitTest == "true")
         {
            parent.hitTestSource = this;
         }
         if(param1.@forMask == "true")
         {
            parent.mask = this;
         }
         if(editMode != 2)
         {
            this.displayObject.mouseChildren = false;
         }
      }
      
      override public function toXML() : XML
      {
         var _loc1_:XML = super.toXML();
         if(this._color != 16777215)
         {
            _loc1_.@color = UtilsStr.convertToHtmlColor(this._color);
         }
         if(this._flip != "none")
         {
            _loc1_.@flip = this._flip;
         }
         if(this._fillMethod != "none")
         {
            _loc1_.@fillMethod = this._fillMethod;
            if(this._fillOrigin != 0)
            {
               _loc1_.@fillOrigin = this._fillOrigin;
            }
            if(!this._fillClockwise)
            {
               _loc1_.@fillClockwise = this.fillClockwise;
            }
            if(this._fillAmount != 100)
            {
               _loc1_.@fillAmount = this._fillAmount;
            }
         }
         return _loc1_;
      }
      
      private function updateBitmap() : void
      {
         var _loc1_:Stage = null;
         if(this._bmdSource != null)
         {
            _loc1_ = displayObject.stage;
            if(_loc1_)
            {
               _loc1_.addEventListener("render",this.__render);
               _loc1_.invalidate();
            }
            else
            {
               GTimers.inst.callLater(this.updateBitmap2);
            }
         }
      }
      
      private function __render(param1:Event) : void
      {
         param1.currentTarget.removeEventListener("render",this.__render);
         this.updateBitmap2();
      }
      
      private function updateBitmap2() : void
      {
         var _loc6_:Matrix = null;
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         var _loc3_:BitmapData = null;
         if(this._bmdSource == null)
         {
            return;
         }
         var _loc8_:* = this._bmdSource;
         var _loc7_:int = this.width;
         var _loc5_:int = this.height;
         if(_loc7_ <= 0 || _loc5_ <= 0)
         {
            _loc8_ = null;
         }
         else if(this._bmdSource.width != _loc7_ || this._bmdSource.height != _loc5_)
         {
            if(this._fillMethod != "none" && (packageItem.imageSetting.scaleOption == "9grid" || packageItem.imageSetting.scaleOption == "tile"))
            {
               _loc8_ = new BitmapData(_loc7_,_loc5_,this._bmdSource.transparent,0);
               _loc6_ = new Matrix();
               _loc6_.scale(_loc7_ / this._bmdSource.width,_loc5_ / this._bmdSource.height);
               _loc8_.draw(this._bmdSource,_loc6_,null,null,null,packageItem.imageSetting.smoothing);
            }
            else if(packageItem.imageSetting.scaleOption == "9grid")
            {
               _loc8_ = ToolSet.scaleBitmapWith9Grid(this._bmdSource,packageItem.imageSetting.scale9Grid,_loc7_,_loc5_,packageItem.imageSetting.smoothing,packageItem.imageSetting.gridTile);
            }
            else if(packageItem.imageSetting.scaleOption == "tile")
            {
               _loc8_ = ToolSet.tileBitmap(this._bmdSource,this._bmdSource.rect,_loc7_,_loc5_);
            }
         }
         if(_loc8_ != null && this._flip != "none")
         {
            _loc6_ = new Matrix();
            _loc2_ = 1;
            _loc4_ = 1;
            if(this._flip == "both")
            {
               _loc6_.scale(-1,-1);
               _loc6_.translate(_loc8_.width,_loc8_.height);
            }
            else if(this._flip == "hz")
            {
               _loc6_.scale(-1,1);
               _loc6_.translate(_loc8_.width,0);
            }
            else
            {
               _loc6_.scale(1,-1);
               _loc6_.translate(0,_loc8_.height);
            }
            _loc3_ = new BitmapData(_loc8_.width,_loc8_.height,_loc8_.transparent,0);
            _loc3_.draw(_loc8_,_loc6_,null,null,null,packageItem.imageSetting.smoothing);
            if(_loc8_ != this._bmdSource)
            {
               _loc8_.dispose();
            }
            _loc8_ = _loc3_;
         }
         if(_loc8_ != null && this._fillMethod && this._fillMethod != "none")
         {
            if(_loc8_ == this._bmdSource)
            {
               _loc8_ = this._bmdSource.clone();
            }
            _loc8_ = ImageFillUtils.fillImage(this._fillMethod,this._fillAmount / 100,this._fillOrigin,this._fillClockwise,_loc8_);
         }
         var _loc1_:BitmapData = this._content.bitmapData;
         if(_loc1_ != _loc8_)
         {
            if(_loc1_ && _loc1_ != this._bmdSource)
            {
               _loc1_.dispose();
            }
            this._content.bitmapData = _loc8_;
            this._content.smoothing = packageItem.imageSetting.smoothing;
         }
         if(!underConstruct && parent && parent.editMode != 3)
         {
            if(parent.hitTestSource == this)
            {
               parent.displayObject.setHitArea(this);
            }
            if(parent.mask == this)
            {
               parent.displayObject.setMask(this);
            }
         }
      }
   }
}
