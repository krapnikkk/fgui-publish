package fairygui.fysheji
{
   import fairygui.editor.animation.BaseBone;
   import fairygui.editor.animation.BoneDef;
   import fairygui.editor.gui.EGAniObject;
   import fairygui.editor.gui.gear.EIColorGear;
   import fairygui.editor.utils.UtilsStr;
   
   public class EGDragonBone extends EGAniObject implements EIColorGear
   {
       
      
      public var _basebone:BaseBone;
      
      private var _color:uint;
      
      public function EGDragonBone()
      {
         super();
         this.objectType = "dragonbone";
         this._color = 16777215;
         this._basebone = new BaseBone();
         _displayObject.container.addChild(this._basebone);
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
      }
      
      override protected function stateChanged() : void
      {
         if(this._aniName != null)
         {
            this._basebone.selectActionName = this._aniName;
            this._basebone.setPlay(_playing,_frame);
         }
      }
      
      override public function create() : void
      {
         if(packageItem == null)
         {
            this._basebone.dispose();
            setError(true);
            return;
         }
         _sourceWidth = packageItem.width;
         _sourceHeight = packageItem.height;
         setSize(_sourceWidth,_sourceHeight);
         aspectLocked = true;
         var _loc1_:BoneDef = pkg.getBoneDef(packageItem);
         if(_loc1_)
         {
            setError(false);
            this._basebone.dispose();
            this._basebone.def = _loc1_;
            this.packageItem.boneName = _loc1_.boneName;
            this.packageItem.boneType = _loc1_.movieTye;
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
         this._basebone.scaleX = _width / _sourceWidth;
         this._basebone.scaleY = _height / _sourceHeight;
      }
      
      override protected function handleDispose() : void
      {
         this._basebone.dispose();
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
         this._aniName = param1.@aniName;
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
         else
         {
            _loc1_.@playing = "true";
         }
         if(this._aniName != null && this._aniName != "")
         {
            _loc1_.@aniName = this._aniName;
         }
         if(this._aniName != null && this._aniName != "")
         {
            _loc1_.@aniName = !!this._aniName?aniName:"";
         }
         _loc1_.@boneName = this.packageItem.boneName;
         _loc1_.@boneType = this.packageItem.boneType;
         _loc1_.@armatureName = this.packageItem.armatureName;
         return _loc1_;
      }
   }
}
