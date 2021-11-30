package fairygui.editor.gui
{
   import fairygui.editor.loader.EasyLoader;
   import fairygui.editor.loader.LoaderExt;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class EGSwfObject extends EGAniObject
   {
       
      
      private var _content:DisplayObject;
      
      public function EGSwfObject()
      {
         super();
         this.objectType = "swf";
      }
      
      override protected function stateChanged() : void
      {
         if(this._content && this._content is MovieClip)
         {
            if(_playing)
            {
               MovieClip(this._content).gotoAndPlay(_frame + 1);
            }
            else
            {
               MovieClip(this._content).gotoAndStop(_frame + 1);
            }
         }
      }
      
      override public function create() : void
      {
         _displayObject.container.removeChildren();
         if(packageItem == null)
         {
            setError(true);
            return;
         }
         _sourceWidth = packageItem.width;
         _sourceHeight = packageItem.height;
         setSize(_sourceWidth,_sourceHeight);
         aspectLocked = true;
         EasyLoader.load(packageItem.file.url,null,this.__swfLoaded);
      }
      
      private function __swfLoaded(param1:LoaderExt) : void
      {
         var _loc2_:* = param1;
         this._content = _loc2_.content;
         if(!this._content)
         {
            setError(true);
            return;
         }
         try
         {
            Sprite(this._content).mouseChildren = false;
            _displayObject.container.addChild(this._content);
            setError(false);
            this.stateChanged();
            this.handleSizeChanged();
            return;
         }
         catch(e:Error)
         {
            _content = null;
            setError(true);
            return;
         }
      }
      
      override protected function handleSizeChanged() : void
      {
         super.handleSizeChanged();
         if(this._content != null)
         {
            this._content.scaleX = _width / _sourceWidth;
            this._content.scaleY = _height / _sourceHeight;
         }
      }
      
      override public function fromXML_beforeAdd(param1:XML) : void
      {
         super.fromXML_beforeAdd(param1);
         var _loc2_:String = param1.@playing;
         _playing = _loc2_ != "false";
         this.stateChanged();
      }
      
      override public function toXML() : XML
      {
         var _loc1_:XML = super.toXML();
         if(!_playing)
         {
            _loc1_.@playing = "false";
         }
         return _loc1_;
      }
   }
}
