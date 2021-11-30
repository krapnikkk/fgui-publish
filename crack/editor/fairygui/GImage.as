package fairygui
{
   import fairygui.display.UIImage;
   import fairygui.utils.ToolSet;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   
   public class GImage extends GObject implements IColorGear
   {
       
      
      private var _bmdSource:BitmapData;
      
      private var _content:Bitmap;
      
      private var _color:uint;
      
      private var _flip:int;
      
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
         if(!packageItem.loaded)
         {
            packageItem.owner.removeItemCallback(packageItem,__imageLoaded);
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
         sourceWidth = packageItem.width;
         sourceHeight = packageItem.height;
         initWidth = sourceWidth;
         initHeight = sourceHeight;
         setSize(sourceWidth,sourceHeight);
         if(packageItem.loaded)
         {
            __imageLoaded(packageItem);
         }
         else
         {
            packageItem.owner.addItemCallback(packageItem,__imageLoaded);
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
         _content.smoothing = packageItem.smoothing;
         updateBitmap();
      }
      
      override protected function handleSizeChanged() : void
      {
         if(packageItem.scale9Grid == null && !packageItem.scaleByTile || _bmdSource != packageItem.image)
         {
            _sizeImplType = 1;
         }
         else
         {
            _sizeImplType = 0;
         }
         handleScaleChanged();
         updateBitmap();
      }
      
      private function updateBitmap() : void
      {
         var _loc7_:* = null;
         var _loc6_:int = 0;
         var _loc4_:* = null;
         if(_bmdSource == null)
         {
            return;
         }
         var _loc2_:* = _bmdSource;
         var _loc1_:int = this.width;
         var _loc8_:int = this.height;
         if(_loc1_ <= 0 || _loc8_ <= 0)
         {
            _loc2_ = null;
         }
         else if(_bmdSource == packageItem.image && (_bmdSource.width != _loc1_ || _bmdSource.height != _loc8_))
         {
            if(packageItem.scale9Grid != null)
            {
               _loc2_ = ToolSet.scaleBitmapWith9Grid(_bmdSource,packageItem.scale9Grid,_loc1_,_loc8_,packageItem.smoothing,packageItem.tileGridIndice);
            }
            else if(packageItem.scaleByTile)
            {
               _loc2_ = ToolSet.tileBitmap(_bmdSource,_bmdSource.rect,_loc1_,_loc8_);
            }
         }
         if(_loc2_ != null && _flip != 0)
         {
            _loc7_ = new Matrix();
            _loc6_ = 1;
            var _loc5_:int = 1;
            if(_flip == 3)
            {
               _loc7_.scale(-1,-1);
               _loc7_.translate(_loc2_.width,_loc2_.height);
            }
            else if(_flip == 1)
            {
               _loc7_.scale(-1,1);
               _loc7_.translate(_loc2_.width,0);
            }
            else
            {
               _loc7_.scale(1,-1);
               _loc7_.translate(0,_loc2_.height);
            }
            _loc4_ = new BitmapData(_loc2_.width,_loc2_.height,_loc2_.transparent,0);
            _loc4_.draw(_loc2_,_loc7_,null,null,null,packageItem.smoothing);
            if(_loc2_ != _bmdSource)
            {
               _loc2_.dispose();
            }
            _loc2_ = _loc4_;
         }
         var _loc3_:BitmapData = _content.bitmapData;
         if(_loc3_ != _loc2_)
         {
            if(_loc3_ && _loc3_ != _bmdSource)
            {
               _loc3_.dispose();
            }
            _content.bitmapData = _loc2_;
            _content.smoothing = packageItem.smoothing;
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
