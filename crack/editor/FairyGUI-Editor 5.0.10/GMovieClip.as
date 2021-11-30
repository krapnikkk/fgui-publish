package fairygui
{
   import fairygui.display.UIMovieClip;
   import fairygui.utils.ToolSet;
   import flash.geom.ColorTransform;
   import flash.geom.Rectangle;
   
   public class GMovieClip extends GObject
   {
       
      
      private var _movieClip:UIMovieClip;
      
      private var _color:uint;
      
      public function GMovieClip()
      {
         super();
         _color = 16777215;
      }
      
      override protected function createDisplayObject() : void
      {
         _movieClip = new UIMovieClip(this);
         _movieClip.mouseEnabled = false;
         _movieClip.mouseChildren = false;
         setDisplayObject(_movieClip);
      }
      
      public final function get playing() : Boolean
      {
         return _movieClip.playing;
      }
      
      public final function set playing(param1:Boolean) : void
      {
         if(_movieClip.playing != param1)
         {
            _movieClip.playing = param1;
            updateGear(5);
         }
      }
      
      public final function get frame() : int
      {
         return _movieClip.frame;
      }
      
      public function set frame(param1:int) : void
      {
         if(_movieClip.frame != param1)
         {
            _movieClip.frame = param1;
            updateGear(5);
         }
      }
      
      public final function get timeScale() : Number
      {
         return _movieClip.timeScale;
      }
      
      public function set timeScale(param1:Number) : void
      {
         _movieClip.timeScale = param1;
      }
      
      public function rewind() : void
      {
         _movieClip.rewind();
      }
      
      public function syncStatus(param1:GMovieClip) : void
      {
         _movieClip.syncStatus(param1._movieClip);
      }
      
      public function advance(param1:int) : void
      {
         _movieClip.advance(param1);
      }
      
      public function setPlaySettings(param1:int = 0, param2:int = -1, param3:int = 0, param4:int = -1, param5:Function = null) : void
      {
         _movieClip.setPlaySettings(param1,param2,param3,param4,param5);
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
         var _loc1_:ColorTransform = _movieClip.transform.colorTransform;
         _loc1_.redMultiplier = (_color >> 16 & 255) / 255;
         _loc1_.greenMultiplier = (_color >> 8 & 255) / 255;
         _loc1_.blueMultiplier = (_color & 255) / 255;
         _movieClip.transform.colorTransform = _loc1_;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      override public function constructFromResource() : void
      {
         var _loc1_:PackageItem = packageItem.getBranch();
         sourceWidth = _loc1_.width;
         sourceHeight = _loc1_.height;
         initWidth = sourceWidth;
         initHeight = sourceHeight;
         setSize(sourceWidth,sourceHeight);
         _loc1_ = _loc1_.getHighResolution();
         if(_loc1_.loaded)
         {
            __movieClipLoaded(_loc1_);
         }
         else
         {
            _loc1_.owner.addItemCallback(_loc1_,__movieClipLoaded);
         }
      }
      
      private function __movieClipLoaded(param1:PackageItem) : void
      {
         _movieClip.interval = param1.interval;
         _movieClip.swing = param1.swing;
         _movieClip.repeatDelay = param1.repeatDelay;
         _movieClip.frames = param1.frames;
         _movieClip.boundsRect = new Rectangle(0,0,sourceWidth,sourceHeight);
         _movieClip.smoothing = param1.smoothing;
         handleSizeChanged();
      }
      
      override protected function handleSizeChanged() : void
      {
         handleScaleChanged();
      }
      
      override protected function handleScaleChanged() : void
      {
         if(_movieClip.boundsRect)
         {
            _displayObject.scaleX = _width / _movieClip.boundsRect.width * _scaleX;
            _displayObject.scaleY = _height / _movieClip.boundsRect.height * _scaleY;
         }
         else
         {
            _displayObject.scaleX = _scaleX;
            _displayObject.scaleY = _scaleY;
         }
      }
      
      override public function getProp(param1:int) : *
      {
         switch(int(param1) - 2)
         {
            case 0:
               return this.color;
            default:
               return super.getProp(param1);
            case 2:
               return this.playing;
            case 3:
            default:
               return this.frame;
            case 5:
               return this.timeScale;
         }
      }
      
      override public function setProp(param1:int, param2:*) : void
      {
         switch(int(param1) - 2)
         {
            case 0:
               this.color = param2;
               break;
            default:
               super.setProp(param1,param2);
               break;
            case 2:
               this.playing = param2;
               break;
            case 3:
               this.frame = param2;
               break;
            case 4:
               this.advance(param2);
               break;
            case 5:
               this.timeScale = param2;
         }
      }
      
      override public function setup_beforeAdd(param1:XML) : void
      {
         var _loc2_:* = null;
         super.setup_beforeAdd(param1);
         _loc2_ = param1.@frame;
         if(_loc2_)
         {
            _movieClip.frame = parseInt(_loc2_);
         }
         _loc2_ = param1.@playing;
         _movieClip.playing = _loc2_ != "false";
         _loc2_ = param1.@color;
         if(_loc2_)
         {
            this.color = ToolSet.convertFromHtmlColor(_loc2_);
         }
      }
   }
}
