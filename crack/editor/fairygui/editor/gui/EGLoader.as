package fairygui.editor.gui
{
   import fairygui.editor.animation.AniDef;
   import fairygui.editor.animation.AniSprite;
   import fairygui.editor.animation.BaseBone;
   import fairygui.editor.animation.BoneDef;
   import fairygui.editor.gui.gear.EIAnimationGear;
   import fairygui.editor.gui.gear.EIColorGear;
   import fairygui.editor.loader.EasyLoader;
   import fairygui.editor.loader.LoaderExt;
   import fairygui.editor.utils.ImageFillUtils;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.utils.ToolSet;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   
   public class EGLoader extends EGObject implements EIAnimationGear, EIColorGear
   {
       
      
      private var _url:String;
      
      private var _align:String;
      
      private var _verticalAlign:String;
      
      private var _autoSize:Boolean;
      
      private var _fill:String;
      
      private var _showErrorSign:Boolean;
      
      private var _playing:Boolean;
      
      private var _frame:int;
      
      private var _color:uint;
      
      private var _fillMethod:String;
      
      private var _fillOrigin:int;
      
      private var _fillClockwise:Boolean;
      
      private var _fillAmount:int;
      
      private var _contentVersion:int;
      
      private var _contentSourceWidth:int;
      
      private var _contentSourceHeight:int;
      
      private var _contentWidth:int;
      
      private var _contentHeight:int;
      
      private var _contentData:BitmapData;
      
      private var _contentItem:EPackageItem;
      
      private var _loader:LoaderExt;
      
      private var _jtSprite:AniSprite;
      
      private var _boneSprite:BaseBone;
      
      private var _content:Object;
      
      private var _errorSign:DisplayObject;
      
      private var _updatingLayout:Boolean;
      
      public var useToPreview:Boolean;
      
      private var _aniName:String;
      
      public function EGLoader()
      {
         super();
         this.objectType = "loader";
         this._playing = true;
         this._url = "";
         this._align = "left";
         this._verticalAlign = "top";
         this._fill = "none";
         _useSourceSize = false;
         this._color = 16777215;
         this._fillMethod = "none";
         this._fillClockwise = true;
         this._fillAmount = 100;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function set url(param1:String) : void
      {
         if(this._url == param1)
         {
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
      
      public function get aniName() : String
      {
         return this._aniName;
      }
      
      public function set aniName(param1:String) : void
      {
         this._aniName = param1;
         if(this._content)
         {
            if(this._content is BaseBone)
            {
               BaseBone(this._content).selectActionName = param1;
               BaseBone(this._content).setPlay(false,this._frame);
            }
         }
         updateGear(5);
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
      
      public function set fillAmount(param1:int) : void
      {
         if(this._fillAmount != param1)
         {
            this._fillAmount = param1;
            this.updateBitmap();
         }
      }
      
      protected function loadContent() : void
      {
         var _loc2_:AniDef = null;
         var _loc1_:BoneDef = null;
         this.clearContent();
         if(this._url == null || this._url.length == 0)
         {
            return;
         }
         if(UtilsStr.startsWith(this._url,"ui://"))
         {
            this._contentItem = pkg.project.getItemByURL(this._url);
            if(this._contentItem != null)
            {
               this._contentVersion = this._contentItem.version;
               this._contentSourceWidth = this._contentItem.width;
               this._contentSourceHeight = this._contentItem.height;
               if(this._contentItem.type == "image")
               {
                  this._contentItem.owner.getImage(this._contentItem,this.__imageLoaded);
               }
               else if(this._contentItem.type == "movieclip")
               {
                  _loc2_ = this._contentItem.owner.getMovieClip(this._contentItem);
                  if(_loc2_ != null)
                  {
                     if(!this._jtSprite)
                     {
                        this._jtSprite = new AniSprite();
                     }
                     this._jtSprite.def = _loc2_;
                     this._jtSprite.playing = this._playing;
                     this._jtSprite.frame = this._frame;
                     this._jtSprite.smoothing = this._contentItem.imageSetting.smoothing;
                     this.setContent(this._jtSprite);
                  }
                  else
                  {
                     this.setErrorState();
                  }
               }
               else if(this._contentItem.type == "swf")
               {
                  EasyLoader.load(this._contentItem.file.url,null,this.__swfLoaded);
               }
               else if(this._contentItem.type == "dragonbone")
               {
                  _loc1_ = this._contentItem.owner.getBoneDef(this._contentItem);
                  if(_loc1_ != null)
                  {
                     if(!this._boneSprite)
                     {
                        this._boneSprite = new BaseBone();
                     }
                     this._boneSprite.def = _loc1_;
                     this.setContent(this._boneSprite);
                  }
                  else
                  {
                     this.setErrorState();
                  }
               }
            }
            else
            {
               this.setErrorState();
            }
            return;
         }
         if(!this._loader)
         {
            this._loader = new LoaderExt();
            this._loader.addEventListener("complete",this.__etcLoaded);
            this._loader.addEventListener("error",this.__etcLoadFailed);
         }
         var _loc3_:String = this._url;
         if(pkg && !UtilsStr.startsWith(_loc3_,"http://",true))
         {
            try
            {
               _loc3_ = new File(pkg.project.basePath).resolvePath(_loc3_).url;
            }
            catch(err:Error)
            {
            }
         }
         this._loader.load(_loc3_);
      }
      
      private function __etcLoaded(param1:Event) : void
      {
         this._contentSourceWidth = this._loader.content.width;
         this._contentSourceHeight = this._loader.content.height;
         this.setContent(this._loader.content);
      }
      
      private function __etcLoadFailed(param1:Event) : void
      {
         param1.preventDefault();
         this.setErrorState();
      }
      
      private function __imageLoaded(param1:EPackageItem) : void
      {
         if(_disposed || this._contentItem != param1)
         {
            return;
         }
         if(param1.data == null)
         {
            this.setErrorState();
            return;
         }
         this._contentData = BitmapData(param1.data);
         var _loc2_:Bitmap = new Bitmap(this._contentData);
         _loc2_.bitmapData = this._contentData;
         _loc2_.smoothing = this._contentItem.imageSetting.smoothing;
         this.setContent(_loc2_);
      }
      
      private function __swfLoaded(param1:LoaderExt) : void
      {
         var _loc2_:* = param1;
         try
         {
            this.setContent(_loc2_.content);
            return;
         }
         catch(e:Error)
         {
            setErrorState();
            return;
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
         dispatchEvent(new Event("complete"));
      }
      
      protected function setErrorState() : void
      {
         this._contentWidth = 0;
         this._contentHeight = 0;
         this.updateLayout();
      }
      
      protected function updateLayout() : void
      {
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
         this._content.x = 0;
         this._content.y = 0;
         this._content.scaleX = 1;
         this._content.scaleY = 1;
         this._contentWidth = this._contentSourceWidth;
         this._contentHeight = this._contentSourceHeight;
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
               return;
            }
         }
         var _loc2_:* = 1;
         var _loc1_:* = 1;
         if(this._fill != "none" && this._content != this._errorSign)
         {
            _loc2_ = Number(_width / this._contentSourceWidth);
            _loc1_ = Number(_height / this._contentSourceHeight);
            if(this.useToPreview)
            {
               if(_loc2_ > 1)
               {
                  _loc2_ = 1;
               }
               if(_loc1_ > 1)
               {
                  _loc1_ = 1;
               }
            }
            if(this._fill == "scaleMatchHeight")
            {
               _loc2_ = _loc1_;
            }
            else if(this._fill == "scaleMatchWidth")
            {
               _loc1_ = _loc2_;
            }
            else if(this._fill == "scale")
            {
               if(_loc2_ > _loc1_)
               {
                  _loc2_ = _loc1_;
               }
               else
               {
                  _loc1_ = _loc2_;
               }
            }
            this._contentWidth = this._contentSourceWidth * _loc2_;
            this._contentHeight = this._contentSourceHeight * _loc1_;
         }
         if(this._contentItem && this._contentItem.type == "image" && this._contentItem.imageSetting)
         {
            if(this._contentItem.imageSetting.scaleOption != "9grid" && this._contentItem.imageSetting.scaleOption != "tile" || this.useToPreview)
            {
               this._content.scaleX = _loc2_;
               this._content.scaleY = _loc1_;
            }
            this.updateBitmap();
         }
         else
         {
            this._content.scaleX = _loc2_;
            this._content.scaleY = _loc1_;
         }
         if(this._align == "center")
         {
            this._content.x = int((_width - this._contentWidth) / 2);
         }
         else if(this._align == "right")
         {
            this._content.x = _width - this._contentWidth;
         }
         if(this._verticalAlign == "middle")
         {
            this._content.y = int((_height - this._contentHeight) / 2);
         }
         else if(this._verticalAlign == "bottom")
         {
            this._content.y = _height - this._contentHeight;
         }
      }
      
      protected function clearContent() : void
      {
         if(this._errorSign && this._errorSign.parent)
         {
            this._errorSign.parent.removeChild(this._errorSign);
         }
         if(this._contentItem)
         {
            this._contentItem.removeCallback(this.__imageLoaded);
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
         if(this._content)
         {
            if(this._content is DisplayObject && this._content.parent == _displayObject.container)
            {
               _displayObject.container.removeChild(DisplayObject(this._content));
            }
            this._content = null;
         }
         this._contentItem = null;
         if(this._boneSprite != null)
         {
            this._boneSprite.dispose();
         }
      }
      
      override protected function handleSizeChanged() : void
      {
         super.handleSizeChanged();
         if(!this._updatingLayout && !underConstruct)
         {
            this.updateLayout();
         }
      }
      
      private function updateBitmap() : void
      {
         var _loc2_:Matrix = null;
         if(!this._contentData)
         {
            return;
         }
         var _loc3_:BitmapData = this._contentData;
         if(this._contentWidth <= 0 || this._contentHeight <= 0)
         {
            _loc3_ = null;
         }
         else if(this._contentData.width != this._contentWidth || this._contentData.height != this._contentHeight)
         {
            if(this._fillMethod != "none" && (this._contentItem.imageSetting.scaleOption == "9grid" || this._contentItem.imageSetting.scaleOption == "tile"))
            {
               _loc3_ = new BitmapData(this._contentWidth,this._contentHeight,this._contentData.transparent,0);
               _loc2_ = new Matrix();
               _loc2_.scale(this._contentWidth / this._contentData.width,this._contentHeight / this._contentData.height);
               _loc3_.draw(this._contentData,_loc2_,null,null,null,this._contentItem.imageSetting.smoothing);
            }
            else if(this._contentItem.imageSetting.scaleOption == "9grid")
            {
               _loc3_ = ToolSet.scaleBitmapWith9Grid(this._contentData,this._contentItem.imageSetting.scale9Grid,this._contentWidth,this._contentHeight,this._contentItem.imageSetting.smoothing,this._contentItem.imageSetting.gridTile);
            }
            else if(this._contentItem.imageSetting.scaleOption == "tile")
            {
               _loc3_ = ToolSet.tileBitmap(this._contentData,this._contentData.rect,this._contentWidth,this._contentHeight);
            }
         }
         if(_loc3_ != null && this._fillMethod && this._fillMethod != "none")
         {
            if(_loc3_ == this._contentData)
            {
               _loc3_ = this._contentData.clone();
            }
            _loc3_ = ImageFillUtils.fillImage(this._fillMethod,this._fillAmount / 100,this._fillOrigin,this._fillClockwise,_loc3_);
         }
         var _loc1_:BitmapData = this._content.bitmapData;
         if(_loc1_ != _loc3_)
         {
            if(_loc1_ && _loc1_ != this._contentData)
            {
               _loc1_.dispose();
            }
            this._content.bitmapData = _loc3_;
            this._content.smoothing = this._contentItem.imageSetting.smoothing;
         }
      }
      
      override public function get deprecated() : Boolean
      {
         if(this._contentItem != null)
         {
            return this._contentVersion != this._contentItem.version;
         }
         return false;
      }
      
      override public function create() : void
      {
         if(editMode == 2)
         {
            _displayObject.setDashedRect(true,"Loader");
         }
      }
      
      override protected function handleDispose() : void
      {
         if(this._jtSprite != null)
         {
            this._jtSprite.dispose();
         }
      }
      
      override public function fromXML_beforeAdd(param1:XML) : void
      {
         var _loc2_:String = null;
         super.fromXML_beforeAdd(param1);
         _loc2_ = param1.@url;
         if(_loc2_)
         {
            this._url = _loc2_;
         }
         else
         {
            this._url = "";
         }
         _loc2_ = param1.@align;
         if(_loc2_)
         {
            this._align = _loc2_;
         }
         else
         {
            this._align = "left";
         }
         _loc2_ = param1.@vAlign;
         if(_loc2_)
         {
            this._verticalAlign = _loc2_;
         }
         else
         {
            this._verticalAlign = "top";
         }
         _loc2_ = param1.@fill;
         if(_loc2_)
         {
            this._fill = _loc2_;
         }
         else
         {
            this._fill = "none";
         }
         this._autoSize = param1.@autoSize == "true";
         _loc2_ = param1.@errorSign;
         this._showErrorSign = _loc2_ == "true";
         this._playing = param1.@playing != "false";
         _loc2_ = param1.@frame;
         if(_loc2_)
         {
            this._frame = parseInt(_loc2_);
         }
         _loc2_ = param1.@color;
         if(_loc2_)
         {
            this._color = UtilsStr.convertFromHtmlColor(_loc2_);
         }
         else
         {
            this._color = 16777215;
         }
         this.applyColor();
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
         }
         if(this._url)
         {
            this.loadContent();
         }
      }
      
      override public function toXML() : XML
      {
         var _loc1_:XML = super.toXML();
         if(this._url)
         {
            _loc1_.@url = this._url;
         }
         if(this._align != "left")
         {
            _loc1_.@align = this._align;
         }
         if(this._verticalAlign != "top")
         {
            _loc1_.@vAlign = this._verticalAlign;
         }
         if(this._fill != "none")
         {
            _loc1_.@fill = this._fill;
         }
         if(this._autoSize)
         {
            _loc1_.@autoSize = this._autoSize;
         }
         if(this._showErrorSign)
         {
            _loc1_.@errorSign = "true";
         }
         if(!this._playing)
         {
            _loc1_.@playing = "false";
         }
         if(this._frame != 0)
         {
            _loc1_.@frame = this._frame;
         }
         if(this._color != 16777215)
         {
            _loc1_.@color = UtilsStr.convertToHtmlColor(this._color);
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
   }
}
