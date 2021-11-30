package fairygui.editor.gui
{
   import fairygui.editor.animation.AniDef;
   import fairygui.editor.animation.AniSprite;
   import fairygui.editor.gui.gear.EIColorGear;
   import fairygui.editor.utils.UtilsStr;
   import flash.geom.ColorTransform;
   
   public class EGMovieClip extends EGAniObject implements EIColorGear
   {
       
      
      private var _aniSprite:AniSprite;
      
      private var _color:uint;
      
      public function EGMovieClip()
      {
         super();
         this.objectType = "movieclip";
         this._color = 16777215;
         this._aniSprite = new AniSprite();
         _displayObject.container.addChild(this._aniSprite);
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
         var _loc1_:ColorTransform = this._aniSprite.transform.colorTransform;
         _loc1_.redMultiplier = (this._color >> 16 & 255) / 255;
         _loc1_.greenMultiplier = (this._color >> 8 & 255) / 255;
         _loc1_.blueMultiplier = (this._color & 255) / 255;
         this._aniSprite.transform.colorTransform = _loc1_;
      }
      
      override protected function stateChanged() : void
      {
         this._aniSprite.playing = _playing;
         this._aniSprite.frame = _frame;
      }
      
      override public function create() : void
      {
         if(packageItem == null)
         {
            this._aniSprite.clear();
            setError(true);
            return;
         }
         _sourceWidth = packageItem.width;
         _sourceHeight = packageItem.height;
         setSize(_sourceWidth,_sourceHeight);
         aspectLocked = true;
         var _loc1_:AniDef = pkg.getMovieClip(packageItem);
         if(_loc1_)
         {
            setError(false);
            this._aniSprite.def = _loc1_;
            this._aniSprite.smoothing = packageItem.imageSetting.smoothing;
            this.stateChanged();
         }
         else
         {
            setError(true);
         }
      }
      
      override protected function handleSizeChanged() : void
      {
         super.handleSizeChanged();
         this._aniSprite.scaleX = _width / _sourceWidth;
         this._aniSprite.scaleY = _height / _sourceHeight;
      }
      
      override protected function handleDispose() : void
      {
         this._aniSprite.dispose();
      }
      
      override public function fromXML_beforeAdd(param1:XML) : void
      {
         var _loc2_:String = null;
         super.fromXML_beforeAdd(param1);
         _loc2_ = param1.@frame;
         if(_loc2_)
         {
            _frame = parseInt(_loc2_);
         }
         _loc2_ = param1.@playing;
         _playing = _loc2_ != "false";
         _loc2_ = param1.@color;
         if(_loc2_)
         {
            this._color = UtilsStr.convertFromHtmlColor(_loc2_);
         }
         else
         {
            this._color = 16777215;
         }
         this.stateChanged();
         this.applyColor();
      }
      
      override public function toXML() : XML
      {
         var _loc1_:XML = super.toXML();
         if(_frame != 0)
         {
            _loc1_.@frame = _frame;
         }
         if(!_playing)
         {
            _loc1_.@playing = "false";
         }
         if(this._color != 16777215)
         {
            _loc1_.@color = UtilsStr.convertToHtmlColor(this._color);
         }
         return _loc1_;
      }
   }
}
