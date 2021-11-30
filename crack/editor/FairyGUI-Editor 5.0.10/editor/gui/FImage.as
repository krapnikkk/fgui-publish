package fairygui.editor.gui
{
   import fairygui.ObjectPropID;
   import fairygui.utils.GTimers;
   import fairygui.utils.ImageFillUtils;
   import fairygui.utils.ToolSet;
   import fairygui.utils.UtilsStr;
   import fairygui.utils.XData;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   
   public class FImage extends FObject
   {
       
      
      private var _content:Bitmap;
      
      private var _bmdSource:BitmapData;
      
      private var _color:uint;
      
      private var _flip:String;
      
      private var _fillMethod:String;
      
      private var _fillOrigin:int;
      
      private var _fillClockwise:Boolean;
      
      private var _fillAmount:int;
      
      public function FImage()
      {
         super();
         this._objectType = FObjectType.IMAGE;
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
      
      override protected function handleCreate() : void
      {
         this.touchDisabled = true;
         this._bmdSource = null;
         if(!_res || _res.isMissing)
         {
            this._content.bitmapData = null;
            this.errorStatus = true;
            return;
         }
         sourceWidth = _res.sourceWidth;
         sourceHeight = _res.sourceHeight;
         setSize(sourceWidth,sourceHeight);
         aspectLocked = true;
         _res.displayItem.getImage(this.__imageLoaded);
         if((_flags & FObjectFlags.IN_PREVIEW) == 0 && _res.displayItem.getVar("converting"))
         {
            _displayObject.setLoading(true);
         }
      }
      
      private function __imageLoaded(param1:FPackageItem) : void
      {
         if(_disposed || _res.displayItem != param1)
         {
            return;
         }
         _displayObject.setLoading(false);
         this._bmdSource = param1.image;
         if(this._bmdSource == null)
         {
            this._content.bitmapData = null;
            this.errorStatus = true;
         }
         else
         {
            this.errorStatus = false;
            this._content.bitmapData = this._bmdSource;
            this._content.smoothing = _res.displayItem.imageSettings.smoothing;
         }
         this.handleSizeChanged();
         if((_flags & FObjectFlags.IN_PREVIEW) == 0 && GTimers.inst.exists(this.updateBitmap2))
         {
            GTimers.inst.remove(this.updateBitmap2);
            this.updateBitmap2();
         }
      }
      
      override public function handleSizeChanged() : void
      {
         super.handleSizeChanged();
         if(_res && _res.displayItem && (_res.displayItem.imageSettings.scaleOption == "tile" || _res.displayItem.imageSettings.scaleOption == "9grid"))
         {
            this._content.scaleX = 1;
            this._content.scaleY = 1;
         }
         else if(this._bmdSource)
         {
            this._content.scaleX = _width / this._bmdSource.width;
            this._content.scaleY = _height / this._bmdSource.height;
         }
         else
         {
            this._content.scaleX = _width / sourceWidth;
            this._content.scaleY = _height / sourceHeight;
         }
         this.updateBitmap();
      }
      
      override protected function handleDispose() : void
      {
         if(this._content.bitmapData != null)
         {
            if(this._content.bitmapData != this._bmdSource)
            {
               this._content.bitmapData.dispose();
            }
            this._content.bitmapData = null;
         }
         this._bmdSource = null;
      }
      
      override public function getProp(param1:int) : *
      {
         if(param1 == ObjectPropID.Color)
         {
            return this.color;
         }
         return super.getProp(param1);
      }
      
      override public function setProp(param1:int, param2:*) : void
      {
         if(param1 == ObjectPropID.Color)
         {
            this.color = param2;
         }
         else
         {
            super.setProp(param1,param2);
         }
      }
      
      override public function read_beforeAdd(param1:XData, param2:Object) : void
      {
         var _loc3_:String = null;
         super.read_beforeAdd(param1,param2);
         this._color = param1.getAttributeColor("color",false,16777215);
         this._flip = param1.getAttribute("flip","none");
         this._fillMethod = param1.getAttribute("fillMethod","none");
         if(this._fillMethod != "none")
         {
            this._fillOrigin = param1.getAttributeInt("fillOrigin");
            this._fillClockwise = param1.getAttributeBool("fillClockwise",true);
            this._fillAmount = param1.getAttributeInt("fillAmount",100);
            this.updateBitmap();
         }
         this.applyColor();
      }
      
      override public function read_afterAdd(param1:XData, param2:Object) : void
      {
         super.read_afterAdd(param1,param2);
         if(param1.getAttributeBool("forHitTest"))
         {
            _parent.hitTestSource = this;
         }
         if(param1.getAttributeBool("forMask"))
         {
            _parent.mask = this;
         }
      }
      
      override public function write() : XData
      {
         var _loc1_:XData = super.write();
         if(this._color != 16777215)
         {
            _loc1_.setAttribute("color",UtilsStr.convertToHtmlColor(this._color));
         }
         if(this._flip != "none")
         {
            _loc1_.setAttribute("flip",this._flip);
         }
         if(this._fillMethod != "none")
         {
            _loc1_.setAttribute("fillMethod",this._fillMethod);
            if(this._fillOrigin != 0)
            {
               _loc1_.setAttribute("fillOrigin",this._fillOrigin);
            }
            if(!this._fillClockwise)
            {
               _loc1_.setAttribute("fillClockwise",this.fillClockwise);
            }
            if(this._fillAmount != 100)
            {
               _loc1_.setAttribute("fillAmount",this._fillAmount);
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
            if(_loc1_ && (_flags & FObjectFlags.IN_PREVIEW) == 0)
            {
               _loc1_.addEventListener(Event.RENDER,this.__render);
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
         param1.currentTarget.removeEventListener(Event.RENDER,this.__render);
         this.updateBitmap2();
      }
      
      private function updateBitmap2() : void
      {
         var _loc7_:Matrix = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:BitmapData = null;
         if(this._bmdSource == null)
         {
            return;
         }
         var _loc1_:BitmapData = this._bmdSource;
         var _loc2_:FPackageItem = _res.displayItem;
         var _loc3_:Number = _loc2_.width / _res.sourceWidth;
         var _loc4_:Number = _loc2_.height / _res.sourceHeight;
         var _loc5_:int = _width * _loc3_;
         var _loc6_:int = _height * _loc4_;
         if(_loc5_ <= 0 || _loc6_ <= 0)
         {
            _loc1_ = null;
         }
         else if(this._bmdSource.width != _loc5_ || this._bmdSource.height != _loc6_)
         {
            if(this._fillMethod != "none" && (_loc2_.imageSettings.scaleOption == "9grid" || _loc2_.imageSettings.scaleOption == "tile"))
            {
               _loc1_ = new BitmapData(_loc5_,_loc6_,this._bmdSource.transparent,0);
               _loc7_ = new Matrix();
               _loc7_.scale(_loc5_ / this._bmdSource.width,_loc6_ / this._bmdSource.height);
               _loc1_.draw(this._bmdSource,_loc7_,null,null,null,_loc2_.imageSettings.smoothing);
            }
            else if(_loc2_.imageSettings.scaleOption == "9grid")
            {
               _loc1_ = ToolSet.scaleBitmapWith9Grid(this._bmdSource,_loc2_.imageSettings.scale9Grid,_loc5_,_loc6_,_loc2_.imageSettings.smoothing,_loc2_.imageSettings.gridTile);
            }
            else if(_loc2_.imageSettings.scaleOption == "tile")
            {
               _loc1_ = ToolSet.tileBitmap(this._bmdSource,this._bmdSource.rect,_loc5_,_loc6_);
            }
         }
         if(_loc1_ != null && this._flip != "none")
         {
            _loc7_ = new Matrix();
            _loc9_ = 1;
            _loc10_ = 1;
            if(this._flip == "both")
            {
               _loc7_.scale(-1,-1);
               _loc7_.translate(_loc1_.width,_loc1_.height);
            }
            else if(this._flip == "hz")
            {
               _loc7_.scale(-1,1);
               _loc7_.translate(_loc1_.width,0);
            }
            else
            {
               _loc7_.scale(1,-1);
               _loc7_.translate(0,_loc1_.height);
            }
            _loc11_ = new BitmapData(_loc1_.width,_loc1_.height,_loc1_.transparent,0);
            _loc11_.draw(_loc1_,_loc7_,null,null,null,_loc2_.imageSettings.smoothing);
            if(_loc1_ != this._bmdSource)
            {
               _loc1_.dispose();
            }
            _loc1_ = _loc11_;
         }
         if(_loc1_ != null && this._fillMethod && this._fillMethod != "none")
         {
            if(_loc1_ == this._bmdSource)
            {
               _loc1_ = this._bmdSource.clone();
            }
            _loc1_ = ImageFillUtils.fillImage(this._fillMethod,this._fillAmount / 100,this._fillOrigin,this._fillClockwise,_loc1_);
         }
         var _loc8_:BitmapData = this._content.bitmapData;
         if(_loc8_ != _loc1_)
         {
            if(_loc8_ && _loc8_ != this._bmdSource)
            {
               _loc8_.dispose();
            }
            this._content.bitmapData = _loc1_;
            this._content.smoothing = _loc2_.imageSettings.smoothing;
         }
         this._content.width = _width;
         this._content.height = _height;
         if(!_underConstruct && _parent && !FObjectFlags.isDocRoot(_parent._flags))
         {
            if(_parent.hitTestSource == this)
            {
               _parent.displayObject.setHitArea(this);
            }
            if(_parent.mask == this)
            {
               _parent.displayObject.setMask(this);
            }
         }
      }
   }
}
