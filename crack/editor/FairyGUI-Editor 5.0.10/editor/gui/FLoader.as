package fairygui.editor.gui
{
   import fairygui.ObjectPropID;
   import fairygui.editor.gui.animation.AniDef;
   import fairygui.editor.gui.animation.AniSprite;
   import fairygui.utils.ImageFillUtils;
   import fairygui.utils.ToolSet;
   import fairygui.utils.UtilsStr;
   import fairygui.utils.XData;
   import fairygui.utils.loader.EasyLoader;
   import fairygui.utils.loader.LoaderExt;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   
   public class FLoader extends FObject
   {
       
      
      public var clearOnPublish:Boolean;
      
      private var _url:String;
      
      private var _align:String;
      
      private var _verticalAlign:String;
      
      private var _autoSize:Boolean;
      
      private var _fill:String;
      
      private var _shrinkOnly:Boolean;
      
      private var _showErrorSign:Boolean;
      
      private var _playing:Boolean;
      
      private var _frame:int;
      
      private var _color:uint;
      
      private var _fillMethod:String;
      
      private var _fillOrigin:int;
      
      private var _fillClockwise:Boolean;
      
      private var _fillAmount:int;
      
      private var _contentSourceWidth:int;
      
      private var _contentSourceHeight:int;
      
      private var _contentWidth:int;
      
      private var _contentHeight:int;
      
      private var _bitmapData:BitmapData;
      
      private var _contentRes:ResourceRef;
      
      private var _loader:LoaderExt;
      
      private var _jtSprite:AniSprite;
      
      private var _content2:FObject;
      
      private var _content:Object;
      
      private var _errorSign:DisplayObject;
      
      private var _updatingLayout:Boolean;
      
      public function FLoader()
      {
         super();
         this._objectType = FObjectType.LOADER;
         this._playing = true;
         this._url = "";
         this._align = "left";
         this._verticalAlign = "top";
         this._fill = FillConst.NONE;
         _useSourceSize = false;
         this._color = 16777215;
         this._fillMethod = "none";
         this._fillClockwise = true;
         this._fillAmount = 100;
         this._contentRes = new ResourceRef();
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function set url(param1:String) : void
      {
         if(this._url == param1)
         {
            if(!this._url && this._content)
            {
               this.clearContent();
            }
            return;
         }
         this._url = param1;
         this.loadContent();
         updateGear(7);
      }
      
      override public function get icon() : String
      {
         return this._url;
      }
      
      override public function set icon(param1:String) : void
      {
         this.url = param1;
      }
      
      public function get align() : String
      {
         return this._align;
      }
      
      public function set align(param1:String) : void
      {
         if(this._align != param1)
         {
            this._align = param1;
            this.updateLayout();
         }
      }
      
      public function get verticalAlign() : String
      {
         return this._verticalAlign;
      }
      
      public function set verticalAlign(param1:String) : void
      {
         if(this._verticalAlign != param1)
         {
            this._verticalAlign = param1;
            this.updateLayout();
         }
      }
      
      public function get fill() : String
      {
         return this._fill;
      }
      
      public function set fill(param1:String) : void
      {
         if(this._fill != param1)
         {
            this._fill = param1;
            this.updateLayout();
         }
      }
      
      public function get shrinkOnly() : Boolean
      {
         return this._shrinkOnly;
      }
      
      public function set shrinkOnly(param1:Boolean) : void
      {
         if(this._shrinkOnly != param1)
         {
            this._shrinkOnly = param1;
            this.updateLayout();
         }
      }
      
      public function get autoSize() : Boolean
      {
         return this._autoSize;
      }
      
      public function set autoSize(param1:Boolean) : void
      {
         if(this._autoSize != param1)
         {
            this._autoSize = param1;
            this.updateLayout();
         }
      }
      
      public function get playing() : Boolean
      {
         return this._playing;
      }
      
      public function set playing(param1:Boolean) : void
      {
         if(this._playing != param1)
         {
            this._playing = param1;
            if(this._content)
            {
               if(this._content == this._jtSprite)
               {
                  this._jtSprite.playing = this._playing;
               }
               else if(this._content is MovieClip)
               {
                  MovieClip(this._content).gotoAndStop(this._frame + 1);
               }
            }
            updateGear(5);
         }
      }
      
      public function get frame() : int
      {
         return this._frame;
      }
      
      public function set frame(param1:int) : void
      {
         this._frame = param1;
         if(this._content)
         {
            if(this._content == this._jtSprite)
            {
               this._jtSprite.frame = this._frame;
            }
            else if(this._content is MovieClip)
            {
               MovieClip(this._content).gotoAndStop(this._frame);
            }
         }
         updateGear(5);
      }
      
      public function get showErrorSign() : Boolean
      {
         return this._showErrorSign;
      }
      
      public function set showErrorSign(param1:Boolean) : void
      {
         this._showErrorSign = param1;
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
         var _loc1_:ColorTransform = _displayObject.container.transform.colorTransform;
         _loc1_.redMultiplier = (this._color >> 16 & 255) / 255;
         _loc1_.greenMultiplier = (this._color >> 8 & 255) / 255;
         _loc1_.blueMultiplier = (this._color & 255) / 255;
         _displayObject.container.transform.colorTransform = _loc1_;
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
      
      public function get contentRes() : ResourceRef
      {
         return this._contentRes;
      }
      
      public function set fillAmount(param1:int) : void
      {
         if(this._fillAmount != param1)
         {
            this._fillAmount = param1;
            this.updateBitmap();
         }
      }
      
      public function set bitmapData(param1:BitmapData) : void
      {
         var _loc2_:Bitmap = null;
         this._url = null;
         this.clearContent();
         if(param1)
         {
            this._contentSourceWidth = param1.width;
            this._contentSourceHeight = param1.height;
            _loc2_ = new Bitmap(param1);
            _loc2_.smoothing = true;
            this.setContent(_loc2_);
         }
      }
      
      protected function loadContent() : void
      {
         var _loc1_:FPackageItem = null;
         var _loc2_:AniDef = null;
         var _loc3_:String = null;
         this.clearContent();
         if(this._url == null || this._url.length == 0)
         {
            return;
         }
         if(UtilsStr.startsWith(this._url,"ui://"))
         {
            this._contentRes.setPackageItem(_pkg.project.getItemByURL(this._url),_flags);
            if(!this._contentRes.isMissing)
            {
               this._contentSourceWidth = this._contentRes.sourceWidth;
               this._contentSourceHeight = this._contentRes.sourceHeight;
               _loc1_ = this._contentRes.displayItem;
               if(_loc1_.type == FPackageItemType.IMAGE)
               {
                  _loc1_.getImage(this.__imageLoaded);
                  if((_flags & FObjectFlags.IN_PREVIEW) == 0 && _loc1_.getVar("converting"))
                  {
                     _displayObject.setLoading(true);
                  }
               }
               else if(_loc1_.type == FPackageItemType.MOVIECLIP)
               {
                  _loc2_ = _loc1_.getAnimation();
                  if(_loc2_ != null)
                  {
                     if(!this._jtSprite)
                     {
                        this._jtSprite = new AniSprite();
                     }
                     this._jtSprite.def = _loc2_;
                     this._jtSprite.playing = this._playing;
                     this._jtSprite.frame = this._frame;
                     this._jtSprite.smoothing = _loc1_.imageSettings.smoothing;
                     this.setContent(this._jtSprite);
                  }
                  else
                  {
                     this.setErrorState();
                  }
               }
               else if(_loc1_.type == FPackageItemType.SWF)
               {
                  if((_flags & FObjectFlags.IN_PREVIEW) == 0)
                  {
                     EasyLoader.load(_loc1_.file.url,null,this.__swfLoaded);
                  }
               }
               else if(_loc1_.type == FPackageItemType.COMPONENT)
               {
                  this._content2 = FObjectFactory.createObject(_loc1_,_flags & 255);
                  this._content2.dispatcher.on(FObject.SIZE_CHANGED,this.onContent2SizeChanged);
                  if((_flags & FObjectFlags.IN_TEST) != 0)
                  {
                     FComponent(this._content2).playAutoPlayTransitions();
                  }
                  this.setContent(this._content2.displayObject);
               }
            }
            else
            {
               this.setErrorState();
            }
            return;
         }
         if((_flags & FObjectFlags.IN_PREVIEW) == 0)
         {
            if(!this._loader)
            {
               this._loader = new LoaderExt();
               this._loader.addEventListener(Event.COMPLETE,this.__etcLoaded);
               this._loader.addEventListener(ErrorEvent.ERROR,this.__etcLoadFailed);
            }
            _loc3_ = this._url;
            if(_pkg && _loc3_.indexOf("://") == -1)
            {
               try
               {
                  _loc3_ = new File(_pkg.project.basePath).resolvePath(_loc3_).url;
               }
               catch(err:Error)
               {
               }
            }
            this._loader.load(_loc3_,{"type":"image"});
         }
      }
      
      private function __etcLoaded(param1:Event) : void
      {
         if(_disposed || this._loader == null || this._loader.content == null)
         {
            return;
         }
         this._contentSourceWidth = this._loader.content.width;
         this._contentSourceHeight = this._loader.content.height;
         if(this._loader.content is Bitmap)
         {
            Bitmap(this._loader.content).smoothing = true;
         }
         this.setContent(this._loader.content);
      }
      
      private function __etcLoadFailed(param1:Event) : void
      {
         if(_disposed)
         {
            return;
         }
         param1.preventDefault();
         this.setErrorState();
      }
      
      private function __imageLoaded(param1:FPackageItem) : void
      {
         if(_disposed || this._contentRes.displayItem != param1)
         {
            return;
         }
         _displayObject.setLoading(false);
         this._bitmapData = param1.image;
         if(this._bitmapData == null)
         {
            this.setErrorState();
            return;
         }
         var _loc2_:Bitmap = new Bitmap(this._bitmapData);
         _loc2_.smoothing = this._contentRes.displayItem.imageSettings.smoothing;
         this.setContent(_loc2_);
      }
      
      private function __swfLoaded(param1:LoaderExt) : void
      {
         var l:LoaderExt = param1;
         if(_disposed)
         {
            return;
         }
         try
         {
            this.setContent(l.content);
            return;
         }
         catch(e:Error)
         {
            setErrorState();
            return;
         }
      }
      
      private function onContent2SizeChanged() : void
      {
         if(!this._updatingLayout)
         {
            this.updateLayout();
         }
      }
      
      protected function setContent(param1:Object) : void
      {
         this._content = param1;
         if(!this._playing && this._content is MovieClip)
         {
            MovieClip(this._content).gotoAndStop(this._frame + 1);
         }
         if(this._content is DisplayObject)
         {
            _displayObject.container.addChild(DisplayObject(this._content));
         }
         this.updateLayout();
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      protected function setErrorState() : void
      {
         this._contentWidth = 0;
         this._contentHeight = 0;
         this.updateLayout();
      }
      
      protected function updateLayout() : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(!this._content || !(this._content is DisplayObject))
         {
            if(this._autoSize)
            {
               this._updatingLayout = true;
               this.setSize(50,30);
               this._updatingLayout = false;
            }
            return;
         }
         this._contentWidth = this._contentSourceWidth;
         this._contentHeight = this._contentSourceHeight;
         var _loc1_:Number = 1;
         var _loc2_:Number = 1;
         if(this._autoSize)
         {
            this._updatingLayout = true;
            if(this._contentWidth == 0)
            {
               this._contentWidth = 50;
            }
            if(this._contentHeight == 0)
            {
               this._contentHeight = 30;
            }
            this.setSize(this._contentWidth,this._contentHeight);
            this._updatingLayout = false;
            if(this._contentWidth == _width && this._contentHeight == _height)
            {
               if(this._content2)
               {
                  this._content2.setXY(0,0);
                  this._content2.setScale(_loc1_,_loc2_);
               }
               else
               {
                  this._content.x = 0;
                  this._content.y = 0;
                  if(this._bitmapData)
                  {
                     _loc1_ = _loc1_ * (this._contentSourceWidth / this._bitmapData.width);
                     _loc2_ = _loc2_ * (this._contentSourceHeight / this._bitmapData.height);
                  }
                  this._content.scaleX = _loc1_;
                  this._content.scaleY = _loc2_;
               }
               return;
            }
         }
         if(this._fill != FillConst.NONE && this._content != this._errorSign)
         {
            _loc1_ = _width / this._contentSourceWidth;
            _loc2_ = _height / this._contentSourceHeight;
            if(this._fill == FillConst.SCALE_MATCH_HEIGHT)
            {
               _loc1_ = _loc2_;
            }
            else if(this._fill == FillConst.SCALE_MATCH_WIDTH)
            {
               _loc2_ = _loc1_;
            }
            else if(this._fill == FillConst.SCALE_SHOW_ALL)
            {
               if(_loc1_ > _loc2_)
               {
                  _loc1_ = _loc2_;
               }
               else
               {
                  _loc2_ = _loc1_;
               }
            }
            else if(this._fill == FillConst.SCALE_NO_BORDER)
            {
               if(_loc1_ > _loc2_)
               {
                  _loc2_ = _loc1_;
               }
               else
               {
                  _loc1_ = _loc2_;
               }
            }
            if(this._shrinkOnly)
            {
               if(_loc1_ > 1)
               {
                  _loc1_ = 1;
               }
               if(_loc2_ > 1)
               {
                  _loc2_ = 1;
               }
            }
            this._contentWidth = this._contentSourceWidth * _loc1_;
            this._contentHeight = this._contentSourceHeight * _loc2_;
         }
         if(this._content2)
         {
            this._content2.setScale(_loc1_,_loc2_);
         }
         else if(this._bitmapData)
         {
            if(this._contentRes.displayItem.imageSettings.scaleOption != "9grid" && this._contentRes.displayItem.imageSettings.scaleOption != "tile")
            {
               if(this._bitmapData)
               {
                  _loc1_ = _loc1_ * (this._contentSourceWidth / this._bitmapData.width);
                  _loc2_ = _loc2_ * (this._contentSourceHeight / this._bitmapData.height);
               }
               this._content.scaleX = _loc1_;
               this._content.scaleY = _loc2_;
            }
            else
            {
               this.updateBitmap();
            }
         }
         else
         {
            this._content.scaleX = _loc1_;
            this._content.scaleY = _loc2_;
         }
         if(this._align == "center")
         {
            _loc3_ = int((_width - this._contentWidth) / 2);
         }
         else if(this._align == "right")
         {
            _loc3_ = _width - this._contentWidth;
         }
         else
         {
            _loc3_ = 0;
         }
         if(this._verticalAlign == "middle")
         {
            _loc4_ = int((_height - this._contentHeight) / 2);
         }
         else if(this._verticalAlign == "bottom")
         {
            _loc4_ = _height - this._contentHeight;
         }
         else
         {
            _loc4_ = 0;
         }
         if(this._content2)
         {
            this._content2.setXY(_loc3_,_loc4_);
         }
         else
         {
            this._content.x = _loc3_;
            this._content.y = _loc4_;
         }
      }
      
      protected function clearContent() : void
      {
         if(this._errorSign && this._errorSign.parent)
         {
            this._errorSign.parent.removeChild(this._errorSign);
         }
         _displayObject.setLoading(false);
         if(!this._contentRes.isMissing)
         {
            this._contentRes.displayItem.removeLoadedCallback(this.__imageLoaded);
            this._contentRes.release();
         }
         if(this._loader)
         {
            try
            {
               this._loader.close();
            }
            catch(e:Error)
            {
            }
            this._loader = null;
         }
         if(this._jtSprite != null)
         {
            this._jtSprite.dispose();
         }
         if(this._content2 != null)
         {
            this._content2.dispose();
            this._content2 = null;
         }
         if(this._content)
         {
            if(this._content is DisplayObject && this._content.parent == _displayObject.container)
            {
               _displayObject.container.removeChild(DisplayObject(this._content));
            }
            this._content = null;
         }
         this._bitmapData = null;
      }
      
      override public function handleSizeChanged() : void
      {
         super.handleSizeChanged();
         if(!this._updatingLayout && !_underConstruct)
         {
            this.updateLayout();
         }
      }
      
      private function updateBitmap() : void
      {
         var _loc2_:Matrix = null;
         if(!this._bitmapData)
         {
            return;
         }
         var _loc1_:BitmapData = this._bitmapData;
         var _loc3_:FPackageItem = this._contentRes.displayItem;
         var _loc4_:Number = _loc3_.width / this._contentSourceWidth;
         var _loc5_:Number = _loc3_.height / this._contentSourceHeight;
         var _loc6_:int = this._contentWidth * _loc4_;
         var _loc7_:int = this._contentHeight * _loc5_;
         if(_loc6_ <= 0 || _loc7_ <= 0)
         {
            _loc1_ = null;
         }
         else if(this._bitmapData.width != _loc6_ || this._bitmapData.height != _loc7_)
         {
            if(this._fillMethod != "none" && (_loc3_.imageSettings.scaleOption == "9grid" || _loc3_.imageSettings.scaleOption == "tile"))
            {
               _loc1_ = new BitmapData(_loc6_,_loc7_,this._bitmapData.transparent,0);
               _loc2_ = new Matrix();
               _loc2_.scale(_loc6_ / this._bitmapData.width,_loc7_ / this._bitmapData.height);
               _loc1_.draw(this._bitmapData,_loc2_,null,null,null,_loc3_.imageSettings.smoothing);
            }
            else if(_loc3_.imageSettings.scaleOption == "9grid")
            {
               _loc1_ = ToolSet.scaleBitmapWith9Grid(this._bitmapData,_loc3_.imageSettings.scale9Grid,_loc6_,_loc7_,_loc3_.imageSettings.smoothing,_loc3_.imageSettings.gridTile);
            }
            else if(_loc3_.imageSettings.scaleOption == "tile")
            {
               _loc1_ = ToolSet.tileBitmap(this._bitmapData,this._bitmapData.rect,_loc6_,_loc7_);
            }
         }
         if(_loc1_ != null && this._fillMethod && this._fillMethod != "none")
         {
            if(_loc1_ == this._bitmapData)
            {
               _loc1_ = this._bitmapData.clone();
            }
            _loc1_ = ImageFillUtils.fillImage(this._fillMethod,this._fillAmount / 100,this._fillOrigin,this._fillClockwise,_loc1_);
         }
         var _loc8_:BitmapData = this._content.bitmapData;
         if(_loc8_ != _loc1_)
         {
            if(_loc8_ && _loc8_ != this._bitmapData)
            {
               _loc8_.dispose();
            }
            this._content.bitmapData = _loc1_;
            this._content.smoothing = _loc3_.imageSettings.smoothing;
         }
         this._content.width = this._contentWidth;
         this._content.height = this._contentHeight;
      }
      
      override public function get deprecated() : Boolean
      {
         return this._contentRes.deprecated;
      }
      
      override protected function handleDispose() : void
      {
         if(this._jtSprite != null)
         {
            this._jtSprite.dispose();
            this._jtSprite = null;
         }
         if(!this._contentRes.isMissing)
         {
            this._contentRes.displayItem.removeLoadedCallback(this.__imageLoaded);
            this._contentRes.release();
         }
         if(this._content2)
         {
            this._content2.dispose();
         }
      }
      
      override public function getProp(param1:int) : *
      {
         switch(param1)
         {
            case ObjectPropID.Color:
               return this.color;
            case ObjectPropID.Playing:
               return this.playing;
            case ObjectPropID.Frame:
               return this.frame;
            case ObjectPropID.TimeScale:
               return 1;
            default:
               return super.getProp(param1);
         }
      }
      
      override public function setProp(param1:int, param2:*) : void
      {
         switch(param1)
         {
            case ObjectPropID.Color:
               this.color = param2;
               break;
            case ObjectPropID.Playing:
               this.playing = param2;
               break;
            case ObjectPropID.Frame:
               this.frame = param2;
               break;
            case ObjectPropID.TimeScale:
               break;
            case ObjectPropID.DeltaTime:
               if(this._content == this._jtSprite)
               {
                  this._jtSprite.advance(param2);
               }
               break;
            default:
               super.setProp(param1,param2);
         }
      }
      
      override public function read_beforeAdd(param1:XData, param2:Object) : void
      {
         var _loc3_:String = null;
         super.read_beforeAdd(param1,param2);
         this._url = param1.getAttribute("url","");
         this._align = param1.getAttribute("align","left");
         this._verticalAlign = param1.getAttribute("vAlign","top");
         this._fill = param1.getAttribute("fill",FillConst.NONE);
         this._shrinkOnly = param1.getAttributeBool("shrinkOnly");
         this._autoSize = param1.getAttributeBool("autoSize");
         this._showErrorSign = param1.getAttributeBool("errorSign");
         this._playing = param1.getAttributeBool("playing",true);
         this._frame = param1.getAttributeInt("frame");
         this._color = param1.getAttributeColor("color",false,16777215);
         this.applyColor();
         this._fillMethod = param1.getAttribute("fillMethod","none");
         if(this._fillMethod != "none")
         {
            this._fillOrigin = param1.getAttributeInt("fillOrigin");
            this._fillClockwise = param1.getAttributeBool("fillClockwise",true);
            this._fillAmount = param1.getAttributeInt("fillAmount",100);
         }
         this.clearOnPublish = param1.getAttributeBool("clearOnPublish");
         if(this._url)
         {
            this.loadContent();
         }
      }
      
      override public function write() : XData
      {
         var _loc1_:XData = super.write();
         if(this._url)
         {
            _loc1_.setAttribute("url",this._url);
         }
         if(this._align != "left")
         {
            _loc1_.setAttribute("align",this._align);
         }
         if(this._verticalAlign != "top")
         {
            _loc1_.setAttribute("vAlign",this._verticalAlign);
         }
         if(this._fill != FillConst.NONE)
         {
            _loc1_.setAttribute("fill",this._fill);
         }
         if(this._shrinkOnly)
         {
            _loc1_.setAttribute("shrinkOnly",this._shrinkOnly);
         }
         if(this._autoSize)
         {
            _loc1_.setAttribute("autoSize",this._autoSize);
         }
         if(this._showErrorSign)
         {
            _loc1_.setAttribute("errorSign",this._showErrorSign);
         }
         if(!this._playing)
         {
            _loc1_.setAttribute("playing",false);
         }
         if(this._frame != 0)
         {
            _loc1_.setAttribute("frame",this._frame);
         }
         if(this._color != 16777215)
         {
            _loc1_.setAttribute("color",UtilsStr.convertToHtmlColor(this._color));
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
         if(this.clearOnPublish)
         {
            _loc1_.setAttribute("clearOnPublish",true);
         }
         return _loc1_;
      }
   }
}
