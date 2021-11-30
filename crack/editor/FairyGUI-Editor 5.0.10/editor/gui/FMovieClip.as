package fairygui.editor.gui
{
   import fairygui.ObjectPropID;
   import fairygui.editor.gui.animation.AniDef;
   import fairygui.editor.gui.animation.AniSprite;
   import fairygui.utils.UtilsStr;
   import fairygui.utils.XData;
   import flash.geom.ColorTransform;
   
   public class FMovieClip extends FObject
   {
       
      
      private var _aniSprite:AniSprite;
      
      private var _color:uint;
      
      private var _playing:Boolean;
      
      private var _frame:int;
      
      public function FMovieClip()
      {
         super();
         this._objectType = FObjectType.MOVIECLIP;
         this._color = 16777215;
         this._playing = true;
         this._aniSprite = new AniSprite();
         _displayObject.container.addChild(this._aniSprite);
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
            this._aniSprite.playing = this._playing;
            if(!this._playing)
            {
               this._aniSprite.frame = this._frame;
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
         if(this._aniSprite.frame != param1)
         {
            this._frame = param1;
            this._aniSprite.frame = this._frame;
            updateGear(5);
         }
      }
      
      public function advance(param1:int) : void
      {
         this._aniSprite.advance(param1);
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
      
      override protected function handleCreate() : void
      {
         this.touchDisabled = true;
         if(!_res || _res.isMissing)
         {
            this._aniSprite.clear();
            this.errorStatus = true;
            return;
         }
         sourceWidth = _res.sourceWidth;
         sourceHeight = _res.sourceHeight;
         setSize(sourceWidth,sourceHeight);
         aspectLocked = true;
         var _loc1_:AniDef = _res.displayItem.getAnimation();
         if(_loc1_)
         {
            this.errorStatus = false;
            this._aniSprite.def = _loc1_;
            this._aniSprite.smoothing = _res.displayItem.imageSettings.smoothing;
            this._aniSprite.playing = this._playing;
            this._aniSprite.frame = this._frame;
         }
         else
         {
            this.errorStatus = true;
         }
      }
      
      override public function handleSizeChanged() : void
      {
         super.handleSizeChanged();
         this._aniSprite.scaleX = _width / sourceWidth;
         this._aniSprite.scaleY = _height / sourceHeight;
      }
      
      override protected function handleDispose() : void
      {
         this._aniSprite.dispose();
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
               this.advance(param2);
               break;
            default:
               super.setProp(param1,param2);
         }
      }
      
      override public function read_beforeAdd(param1:XData, param2:Object) : void
      {
         var _loc3_:String = null;
         super.read_beforeAdd(param1,param2);
         this._frame = param1.getAttributeInt("frame");
         this._playing = param1.getAttributeBool("playing",true);
         this._color = param1.getAttributeColor("color",false,16777215);
         this._aniSprite.playing = this._playing;
         this._aniSprite.frame = this._frame;
         this.applyColor();
      }
      
      override public function write() : XData
      {
         var _loc1_:XData = super.write();
         if(this._frame != 0)
         {
            _loc1_.setAttribute("frame",this._frame);
         }
         if(!this._playing)
         {
            _loc1_.setAttribute("playing",false);
         }
         if(this._color != 16777215)
         {
            _loc1_.setAttribute("color",UtilsStr.convertToHtmlColor(this._color));
         }
         return _loc1_;
      }
   }
}
