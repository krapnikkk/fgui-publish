package fairygui
{
   import fairygui.display.UIMovieClip;
   import fairygui.utils.ToolSet;
   import flash.geom.ColorTransform;
   import flash.geom.Rectangle;
   
   public class GMovieClip extends GObject implements IAnimationGear, IColorGear
   {
       
      
      private var _movieClip:UIMovieClip;
      
      private var _color:uint;
      
      public function GMovieClip()
      {
         super();
         _sizeImplType = 1;
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
         return _movieClip.currentFrame;
      }
      
      public function set frame(param1:int) : void
      {
         if(_movieClip.currentFrame != param1)
         {
            _movieClip.currentFrame = param1;
            updateGear(5);
         }
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
         sourceWidth = packageItem.width;
         sourceHeight = packageItem.height;
         initWidth = sourceWidth;
         initHeight = sourceHeight;
         setSize(sourceWidth,sourceHeight);
         if(packageItem.loaded)
         {
            __movieClipLoaded(packageItem);
         }
         else
         {
            packageItem.owner.addItemCallback(packageItem,__movieClipLoaded);
         }
      }
      
      private function __movieClipLoaded(param1:PackageItem) : void
      {
         _movieClip.interval = packageItem.interval;
         _movieClip.swing = packageItem.swing;
         _movieClip.repeatDelay = packageItem.repeatDelay;
         _movieClip.frames = packageItem.frames;
         _movieClip.boundsRect = new Rectangle(0,0,sourceWidth,sourceHeight);
         _movieClip.smoothing = packageItem.smoothing;
      }
      
      override public function setup_beforeAdd(param1:XML) : void
      {
         var _loc2_:* = null;
         super.setup_beforeAdd(param1);
         _loc2_ = param1.@frame;
         if(_loc2_)
         {
            _movieClip.currentFrame = parseInt(_loc2_);
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
