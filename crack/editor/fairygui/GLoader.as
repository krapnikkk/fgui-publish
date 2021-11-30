package fairygui
{
   import fairygui.display.MovieClip;
   import fairygui.display.UISprite;
   import fairygui.utils.ToolSet;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   
   public class GLoader extends GObject implements IColorGear, IAnimationGear
   {
      
      private static var _errorSignPool:GObjectPool = new GObjectPool();
       
      
      private var _url:String;
      
      private var _align:int;
      
      private var _verticalAlign:int;
      
      private var _autoSize:Boolean;
      
      private var _fill:int;
      
      private var _showErrorSign:Boolean;
      
      private var _playing:Boolean;
      
      private var _frame:int;
      
      private var _color:uint;
      
      private var _contentItem:PackageItem;
      
      private var _contentSourceWidth:int;
      
      private var _contentSourceHeight:int;
      
      private var _contentWidth:int;
      
      private var _contentHeight:int;
      
      private var _container:Sprite;
      
      private var _content:DisplayObject;
      
      private var _errorSign:GObject;
      
      private var _updatingLayout:Boolean;
      
      private var _loading:int;
      
      private var _externalLoader:Loader;
      
      private var _initExternalURLBeforeLoadSuccess:String;
      
      public function GLoader()
      {
         super();
         _playing = true;
         _url = "";
         _align = 0;
         _verticalAlign = 0;
         _showErrorSign = true;
         _color = 16777215;
      }
      
      override protected function createDisplayObject() : void
      {
         _container = new UISprite(this);
         setDisplayObject(_container);
      }
      
      override public function dispose() : void
      {
         if(_contentItem != null)
         {
            if(_loading == 1)
            {
               _contentItem.owner.removeItemCallback(_contentItem,__imageLoaded);
            }
            else if(_loading == 2)
            {
               _contentItem.owner.removeItemCallback(_contentItem,__movieClipLoaded);
            }
         }
         else if(_content != null)
         {
            freeExternal(_content);
         }
         super.dispose();
      }
      
      public function get url() : String
      {
         return _url;
      }
      
      public function set url(param1:String) : void
      {
         if(_url == param1)
         {
            return;
         }
         _url = param1;
         loadContent();
         updateGear(7);
      }
      
      override public function get icon() : String
      {
         return _url;
      }
      
      override public function set icon(param1:String) : void
      {
         this.url = param1;
      }
      
      public function get align() : int
      {
         return _align;
      }
      
      public function set align(param1:int) : void
      {
         if(_align != param1)
         {
            _align = param1;
            updateLayout();
         }
      }
      
      public function get verticalAlign() : int
      {
         return _verticalAlign;
      }
      
      public function set verticalAlign(param1:int) : void
      {
         if(_verticalAlign != param1)
         {
            _verticalAlign = param1;
            updateLayout();
         }
      }
      
      public function get fill() : int
      {
         return _fill;
      }
      
      public function set fill(param1:int) : void
      {
         if(_fill != param1)
         {
            _fill = param1;
            updateLayout();
         }
      }
      
      public function get autoSize() : Boolean
      {
         return _autoSize;
      }
      
      public function set autoSize(param1:Boolean) : void
      {
         if(_autoSize != param1)
         {
            _autoSize = param1;
            updateLayout();
         }
      }
      
      public function get playing() : Boolean
      {
         return _playing;
      }
      
      public function set playing(param1:Boolean) : void
      {
         if(_playing != param1)
         {
            _playing = param1;
            if(_content is fairygui.display.MovieClip)
            {
               fairygui.display.MovieClip(_content).playing = param1;
            }
            else if(_content is flash.display.MovieClip)
            {
               flash.display.MovieClip(_content).stop();
            }
            updateGear(5);
         }
      }
      
      public function get frame() : int
      {
         return _frame;
      }
      
      public function set frame(param1:int) : void
      {
         if(_frame != param1)
         {
            _frame = param1;
            if(_content is fairygui.display.MovieClip)
            {
               fairygui.display.MovieClip(_content).currentFrame = param1;
            }
            else if(_content is flash.display.MovieClip)
            {
               if(_playing)
               {
                  flash.display.MovieClip(_content).gotoAndPlay(_frame + 1);
               }
               else
               {
                  flash.display.MovieClip(_content).gotoAndStop(_frame + 1);
               }
            }
            updateGear(5);
         }
      }
      
      public function get color() : uint
      {
         return _color;
      }
      
      public function set color(param1:uint) : void
      {
         if(_color != param1)
         {
            _color = param1;
            updateGear(4);
            applyColor();
         }
      }
      
      private function applyColor() : void
      {
         var _loc1_:ColorTransform = _container.transform.colorTransform;
         _loc1_.redMultiplier = (_color >> 16 & 255) / 255;
         _loc1_.greenMultiplier = (_color >> 8 & 255) / 255;
         _loc1_.blueMultiplier = (_color & 255) / 255;
         _container.transform.colorTransform = _loc1_;
      }
      
      public function get showErrorSign() : Boolean
      {
         return _showErrorSign;
      }
      
      public function set showErrorSign(param1:Boolean) : void
      {
         _showErrorSign = param1;
      }
      
      public function get texture() : BitmapData
      {
         if(_content is Bitmap)
         {
            return Bitmap(_content).bitmapData;
         }
         return null;
      }
      
      public function set texture(param1:BitmapData) : void
      {
         this.url = null;
         if(!(_content is Bitmap))
         {
            _content = new Bitmap();
            _container.addChild(_content);
         }
         else
         {
            _container.addChild(_content);
         }
         Bitmap(_content).bitmapData = param1;
         _contentSourceWidth = param1.width;
         _contentSourceHeight = param1.height;
         updateLayout();
      }
      
      protected function loadContent() : void
      {
         clearContent();
         if(!_url)
         {
            return;
         }
         if(ToolSet.startsWith(_url,"ui://"))
         {
            loadFromPackage(_url);
         }
         else
         {
            loadExternal();
         }
      }
      
      protected function loadFromPackage(param1:String) : void
      {
         _contentItem = UIPackage.getItemByURL(param1);
         if(_contentItem != null)
         {
            if(_autoSize)
            {
               this.setSize(_contentItem.width,_contentItem.height);
            }
            if(_contentItem.type == 0)
            {
               if(_contentItem.loaded)
               {
                  __imageLoaded(_contentItem);
               }
               else
               {
                  _loading = 1;
                  _contentItem.owner.addItemCallback(_contentItem,__imageLoaded);
               }
            }
            else if(_contentItem.type == 2)
            {
               if(_contentItem.loaded)
               {
                  __movieClipLoaded(_contentItem);
               }
               else
               {
                  _loading = 2;
                  _contentItem.owner.addItemCallback(_contentItem,__movieClipLoaded);
               }
            }
            else if(_contentItem.type == 1)
            {
               _loading = 2;
               _contentItem.owner.addItemCallback(_contentItem,__swfLoaded);
            }
            else
            {
               setErrorState();
            }
         }
         else
         {
            setErrorState();
         }
      }
      
      private function __imageLoaded(param1:PackageItem) : void
      {
         _loading = 0;
         if(param1.image == null)
         {
            setErrorState();
         }
         else
         {
            if(!(_content is Bitmap))
            {
               _content = new Bitmap();
               _container.addChild(_content);
            }
            else
            {
               _container.addChild(_content);
            }
            Bitmap(_content).bitmapData = param1.image;
            Bitmap(_content).smoothing = param1.smoothing;
            _contentSourceWidth = param1.width;
            _contentSourceHeight = param1.height;
            updateLayout();
         }
      }
      
      private function __movieClipLoaded(param1:PackageItem) : void
      {
         _loading = 0;
         if(!(_content is fairygui.display.MovieClip))
         {
            _content = new fairygui.display.MovieClip();
            _container.addChild(_content);
         }
         else
         {
            _container.addChild(_content);
         }
         _contentSourceWidth = param1.width;
         _contentSourceHeight = param1.height;
         fairygui.display.MovieClip(_content).interval = param1.interval;
         fairygui.display.MovieClip(_content).frames = param1.frames;
         fairygui.display.MovieClip(_content).repeatDelay = param1.repeatDelay;
         fairygui.display.MovieClip(_content).swing = param1.swing;
         fairygui.display.MovieClip(_content).boundsRect = new Rectangle(0,0,_contentSourceWidth,_contentSourceHeight);
         updateLayout();
      }
      
      private function __swfLoaded(param1:DisplayObject) : void
      {
         _loading = 0;
         if(_content)
         {
            _container.removeChild(_content);
         }
         _content = DisplayObject(param1);
         if(_content)
         {
            try
            {
               _container.addChild(_content);
            }
            catch(e:Error)
            {
               trace("__swfLoaded:" + e);
               _content = null;
            }
         }
         if(_content && _content is flash.display.MovieClip)
         {
            if(_playing)
            {
               flash.display.MovieClip(_content).gotoAndPlay(_frame + 1);
            }
            else
            {
               flash.display.MovieClip(_content).gotoAndStop(_frame + 1);
            }
         }
         _contentSourceWidth = _content.width;
         _contentSourceHeight = _content.height;
         updateLayout();
      }
      
      protected function loadExternal() : void
      {
         if(!_externalLoader)
         {
            _externalLoader = new Loader();
            _externalLoader.contentLoaderInfo.addEventListener("complete",__externalLoadCompleted);
            _externalLoader.contentLoaderInfo.addEventListener("ioError",__externalLoadFailed);
         }
         _initExternalURLBeforeLoadSuccess = _url;
         _externalLoader.load(new URLRequest(url));
      }
      
      protected function freeExternal(param1:DisplayObject) : void
      {
      }
      
      protected final function onExternalLoadSuccess(param1:DisplayObject) : void
      {
         _content = param1;
         _container.addChild(_content);
         if(param1.loaderInfo && param1.loaderInfo != displayObject.loaderInfo)
         {
            _contentSourceWidth = param1.loaderInfo.width;
            _contentSourceHeight = param1.loaderInfo.height;
         }
         else
         {
            _contentSourceWidth = param1.width;
            _contentSourceHeight = param1.height;
         }
         updateLayout();
      }
      
      protected final function onExternalLoadFailed() : void
      {
         setErrorState();
      }
      
      private function __externalLoadCompleted(param1:Event) : void
      {
         if(_initExternalURLBeforeLoadSuccess == _url)
         {
            onExternalLoadSuccess(_externalLoader.content);
         }
         _initExternalURLBeforeLoadSuccess = null;
      }
      
      private function __externalLoadFailed(param1:Event) : void
      {
         onExternalLoadFailed();
      }
      
      private function setErrorState() : void
      {
         if(!_showErrorSign)
         {
            return;
         }
         if(_errorSign == null)
         {
            if(UIConfig.loaderErrorSign != null)
            {
               _errorSign = _errorSignPool.getObject(UIConfig.loaderErrorSign);
            }
         }
         if(_errorSign != null)
         {
            _errorSign.setSize(this.width,this.height);
            _container.addChild(_errorSign.displayObject);
         }
      }
      
      private function clearErrorState() : void
      {
         if(_errorSign != null)
         {
            _container.removeChild(_errorSign.displayObject);
            _errorSignPool.returnObject(_errorSign);
            _errorSign = null;
         }
      }
      
      private function updateLayout() : void
      {
         if(_content == null)
         {
            if(_autoSize)
            {
               _updatingLayout = true;
               this.setSize(50,30);
               _updatingLayout = false;
            }
            return;
         }
         _content.x = 0;
         _content.y = 0;
         _content.scaleX = 1;
         _content.scaleY = 1;
         _contentWidth = _contentSourceWidth;
         _contentHeight = _contentSourceHeight;
         if(_autoSize)
         {
            _updatingLayout = true;
            if(_contentWidth == 0)
            {
               _contentWidth = 50;
            }
            if(_contentHeight == 0)
            {
               _contentHeight = 30;
            }
            this.setSize(_contentWidth,_contentHeight);
            _updatingLayout = false;
            if(_width == _contentWidth && _height == _contentHeight)
            {
               return;
            }
         }
         var _loc2_:* = 1;
         var _loc1_:* = 1;
         if(_fill != 0)
         {
            _loc2_ = Number(_width / _contentSourceWidth);
            _loc1_ = Number(_height / _contentSourceHeight);
            if(_loc2_ != 1 || _loc1_ != 1)
            {
               if(_fill == 2)
               {
                  _loc2_ = _loc1_;
               }
               else if(_fill == 3)
               {
                  _loc1_ = _loc2_;
               }
               else if(_fill == 1)
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
               _contentWidth = _contentSourceWidth * _loc2_;
               _contentHeight = _contentSourceHeight * _loc1_;
            }
         }
         if(_contentItem && _contentItem.type == 0)
         {
            resizeImage();
         }
         else
         {
            _content.scaleX = _loc2_;
            _content.scaleY = _loc1_;
         }
         if(_align == 1)
         {
            _content.x = int((this.width - _contentWidth) / 2);
         }
         else if(_align == 2)
         {
            _content.x = this.width - _contentWidth;
         }
         if(_verticalAlign == 1)
         {
            _content.y = int((this.height - _contentHeight) / 2);
         }
         else if(_verticalAlign == 2)
         {
            _content.y = this.height - _contentHeight;
         }
      }
      
      private function clearContent() : void
      {
         clearErrorState();
         if(_content != null && _content.parent != null)
         {
            _container.removeChild(_content);
         }
         if(_contentItem != null)
         {
            if(_loading == 1)
            {
               _contentItem.owner.removeItemCallback(_contentItem,__imageLoaded);
            }
            else if(_loading == 2)
            {
               _contentItem.owner.removeItemCallback(_contentItem,__movieClipLoaded);
            }
         }
         else if(_content != null)
         {
            freeExternal(_content);
         }
         _contentItem = null;
         _loading = 0;
      }
      
      override protected function handleSizeChanged() : void
      {
         if(!_updatingLayout)
         {
            updateLayout();
         }
      }
      
      private function resizeImage() : void
      {
         var _loc2_:* = null;
         var _loc1_:* = null;
         var _loc3_:BitmapData = _contentItem.image;
         if(_loc3_ == null)
         {
            return;
         }
         if(_contentItem.scale9Grid != null)
         {
            _content.scaleX = 1;
            _content.scaleY = 1;
            _loc2_ = Bitmap(_content).bitmapData;
            if(_loc3_.width == _contentWidth && _loc3_.height == _contentHeight)
            {
               _loc1_ = _loc3_;
            }
            else if(_contentWidth == 0 || _contentHeight == 0)
            {
               _loc1_ = null;
            }
            else
            {
               _loc1_ = ToolSet.scaleBitmapWith9Grid(_loc3_,_contentItem.scale9Grid,_contentWidth,_contentHeight,_contentItem.smoothing,_contentItem.tileGridIndice);
            }
            if(_loc2_ != _loc1_)
            {
               if(_loc2_ && _loc2_ != _loc3_)
               {
                  _loc2_.dispose();
               }
               Bitmap(_content).bitmapData = _loc1_;
            }
         }
         else if(_contentItem.scaleByTile)
         {
            _content.scaleX = 1;
            _content.scaleY = 1;
            _loc2_ = Bitmap(_content).bitmapData;
            if(_loc3_.width == _contentWidth && _loc3_.height == _contentHeight)
            {
               _loc1_ = _loc3_;
            }
            else if(_contentWidth == 0 || _contentHeight == 0)
            {
               _loc1_ = null;
            }
            else
            {
               _loc1_ = ToolSet.tileBitmap(_loc3_,_loc3_.rect,_contentWidth,_contentHeight);
            }
            if(_loc2_ != _loc1_)
            {
               if(_loc2_ && _loc2_ != _loc3_)
               {
                  _loc2_.dispose();
               }
               Bitmap(_content).bitmapData = _loc1_;
            }
         }
         else
         {
            _content.scaleX = _contentWidth / _contentSourceWidth;
            _content.scaleY = _contentHeight / _contentSourceHeight;
         }
      }
      
      override public function setup_beforeAdd(param1:XML) : void
      {
         var _loc2_:* = null;
         super.setup_beforeAdd(param1);
         _loc2_ = param1.@url;
         if(_loc2_)
         {
            _url = _loc2_;
         }
         _loc2_ = param1.@align;
         if(_loc2_)
         {
            _align = AlignType.parse(_loc2_);
         }
         _loc2_ = param1.@vAlign;
         if(_loc2_)
         {
            _verticalAlign = VertAlignType.parse(_loc2_);
         }
         _loc2_ = param1.@fill;
         if(_loc2_)
         {
            _fill = LoaderFillType.parse(_loc2_);
         }
         _autoSize = param1.@autoSize == "true";
         _loc2_ = param1.@errorSign;
         if(_loc2_)
         {
            _showErrorSign = _loc2_ == "true";
         }
         _playing = param1.@playing != "false";
         _loc2_ = param1.@color;
         if(_loc2_)
         {
            this.color = ToolSet.convertFromHtmlColor(_loc2_);
         }
         if(_url)
         {
            loadContent();
         }
      }
   }
}
