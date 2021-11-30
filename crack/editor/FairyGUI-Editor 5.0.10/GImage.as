package fairygui
{
   import fairygui.display.UIImage;
   import fairygui.utils.ToolSet;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   
   public class GImage extends GObject
   {
       
      
      private var _bmdSource:BitmapData;
      
      private var _content:Bitmap;
      
      private var _color:uint;
      
      private var _flip:int;
      
      private var _contentItem:PackageItem;
      
      public function GImage()
      {
         super();
         _color = 16777215;
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
         var _loc1_:ColorTransform = _content.transform.colorTransform;
         _loc1_.redMultiplier = (_color >> 16 & 255) / 255;
         _loc1_.greenMultiplier = (_color >> 8 & 255) / 255;
         _loc1_.blueMultiplier = (_color & 255) / 255;
         _content.transform.colorTransform = _loc1_;
      }
      
      public function get flip() : int
      {
         return _flip;
      }
      
      public function set flip(param1:int) : void
      {
         if(_flip != param1)
         {
            _flip = param1;
            updateBitmap();
         }
      }
      
      public function get texture() : BitmapData
      {
         return _bmdSource;
      }
      
      public function set texture(param1:BitmapData) : void
      {
         _bmdSource = param1;
         handleSizeChanged();
      }
      
      override protected function createDisplayObject() : void
      {
         _content = new UIImage(this);
         setDisplayObject(_content);
      }
      
      override public function dispose() : void
      {
         if(_contentItem && !_contentItem.loaded)
         {
            _contentItem.owner.removeItemCallback(_contentItem,__imageLoaded);
         }
         if(_content.bitmapData != null && _content.bitmapData != _bmdSource)
         {
            _content.bitmapData.dispose();
            _content.bitmapData = null;
         }
         super.dispose();
      }
      
      override public function constructFromResource() : void
      {
         _contentItem = packageItem.getBranch();
         sourceWidth = _contentItem.width;
         sourceHeight = _contentItem.height;
         initWidth = sourceWidth;
         initHeight = sourceHeight;
         setSize(sourceWidth,sourceHeight);
         _contentItem = _contentItem.getHighResolution();
         if(_contentItem.loaded)
         {
            __imageLoaded(_contentItem);
         }
         else
         {
            _contentItem.owner.addItemCallback(_contentItem,__imageLoaded);
         }
      }
      
      private function __imageLoaded(param1:PackageItem) : void
      {
         if(_bmdSource != null)
         {
            return;
         }
         _bmdSource = param1.image;
         _content.bitmapData = _bmdSource;
         _content.smoothing = _contentItem.smoothing;
         handleSizeChanged();
      }
      
      override protected function handleSizeChanged() : void
      {
         handleScaleChanged();
         updateBitmap();
      }
      
      override protected function handleScaleChanged() : void
      {
         if(_contentItem && _contentItem.scale9Grid == null && !_contentItem.scaleByTile && _bmdSource)
         {
            _displayObject.scaleX = _width / _bmdSource.width * _scaleX;
            _displayObject.scaleY = _height / _bmdSource.height * _scaleY;
         }
         else
         {
            _displayObject.scaleX = _scaleX;
            _displayObject.scaleY = _scaleY;
         }
      }
      
      private function updateBitmap() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc10_:* = null;
         if(_bmdSource == null)
         {
            return;
         }
         var _loc3_:* = _bmdSource;
         var _loc5_:Number = _contentItem.width / sourceWidth;
         var _loc6_:Number = _contentItem.height / sourceHeight;
         var _loc7_:int = _width * _loc5_;
         var _loc8_:int = _height * _loc6_;
         if(_loc7_ <= 0 || _loc8_ <= 0)
         {
            _loc3_ = null;
         }
         else if(_bmdSource == _contentItem.image && (_bmdSource.width != _loc7_ || _bmdSource.height != _loc8_))
         {
            if(_contentItem.scale9Grid != null)
            {
               _loc3_ = ToolSet.scaleBitmapWith9Grid(_bmdSource,_contentItem.scale9Grid,_loc7_,_loc8_,_contentItem.smoothing,_contentItem.tileGridIndice);
            }
            else if(_contentItem.scaleByTile)
            {
               _loc3_ = ToolSet.tileBitmap(_bmdSource,_bmdSource.rect,_loc7_,_loc8_);
            }
         }
         if(_loc3_ != null && _flip != 0)
         {
            _loc1_ = new Matrix();
            _loc2_ = 1;
            var _loc4_:int = 1;
            if(_flip == 3)
            {
               _loc1_.scale(-1,-1);
               _loc1_.translate(_loc3_.width,_loc3_.height);
            }
            else if(_flip == 1)
            {
               _loc1_.scale(-1,1);
               _loc1_.translate(_loc3_.width,0);
            }
            else
            {
               _loc1_.scale(1,-1);
               _loc1_.translate(0,_loc3_.height);
            }
            _loc10_ = new BitmapData(_loc3_.width,_loc3_.height,_loc3_.transparent,0);
            _loc10_.draw(_loc3_,_loc1_,null,null,null,_contentItem.smoothing);
            if(_loc3_ != _bmdSource)
            {
               _loc3_.dispose();
            }
            _loc3_ = _loc10_;
         }
         var _loc9_:BitmapData = _content.bitmapData;
         if(_loc9_ != _loc3_)
         {
            if(_loc9_ && _loc9_ != _bmdSource)
            {
               _loc9_.dispose();
            }
            _content.bitmapData = _loc3_;
            _content.smoothing = _contentItem.smoothing;
         }
         _content.width = _width;
         _content.height = _height;
      }
      
      override public function getProp(param1:int) : *
      {
         if(param1 == 2)
         {
            return this.color;
         }
         return super.getProp(param1);
      }
      
      override public function setProp(param1:int, param2:*) : void
      {
         if(param1 == 2)
         {
            this.color = param2;
         }
         else
         {
            super.setProp(param1,param2);
         }
      }
      
      override public function setup_beforeAdd(param1:XML) : void
      {
         var _loc2_:* = null;
         super.setup_beforeAdd(param1);
         _loc2_ = param1.@color;
         if(_loc2_)
         {
            this.color = ToolSet.convertFromHtmlColor(_loc2_);
         }
         _loc2_ = param1.@flip;
         if(_loc2_)
         {
            this.flip = FlipType.parse(_loc2_);
         }
      }
   }
}
