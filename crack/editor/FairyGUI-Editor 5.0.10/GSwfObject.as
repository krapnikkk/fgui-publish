package fairygui
{
   import fairygui.display.UISprite;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class GSwfObject extends GObject
   {
       
      
      protected var _container:Sprite;
      
      protected var _content:DisplayObject;
      
      protected var _playing:Boolean;
      
      protected var _frame:int;
      
      public function GSwfObject()
      {
         super();
         _playing = true;
      }
      
      override protected function createDisplayObject() : void
      {
         _container = new UISprite(this);
         setDisplayObject(_container);
      }
      
      public final function get movieClip() : MovieClip
      {
         return MovieClip(_content);
      }
      
      public final function get playing() : Boolean
      {
         return _playing;
      }
      
      public function set playing(param1:Boolean) : void
      {
         if(_playing != param1)
         {
            _playing = param1;
            if(_content && _content is MovieClip)
            {
               if(_playing)
               {
                  MovieClip(_content).gotoAndPlay(_frame + 1);
               }
               else
               {
                  MovieClip(_content).gotoAndStop(_frame + 1);
               }
            }
            updateGear(5);
         }
      }
      
      public final function get frame() : int
      {
         return _frame;
      }
      
      public function set frame(param1:int) : void
      {
         if(_frame != param1)
         {
            _frame = param1;
            if(_content && _content is MovieClip)
            {
               if(_playing)
               {
                  MovieClip(_content).gotoAndPlay(_frame + 1);
               }
               else
               {
                  MovieClip(_content).gotoAndStop(_frame + 1);
               }
            }
            updateGear(5);
         }
      }
      
      override public function dispose() : void
      {
         packageItem.owner.removeItemCallback(packageItem,__swfLoaded);
         super.dispose();
      }
      
      override public function constructFromResource() : void
      {
         sourceWidth = packageItem.width;
         sourceHeight = packageItem.height;
         initWidth = sourceWidth;
         initHeight = sourceHeight;
         setSize(sourceWidth,sourceHeight);
         packageItem.owner.addItemCallback(packageItem,__swfLoaded);
      }
      
      private function __swfLoaded(param1:Object) : void
      {
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
         if(_content && _content is MovieClip)
         {
            if(_playing)
            {
               MovieClip(_content).gotoAndPlay(_frame + 1);
            }
            else
            {
               MovieClip(_content).gotoAndStop(_frame + 1);
            }
         }
      }
      
      override protected function handleSizeChanged() : void
      {
         handleScaleChanged();
      }
      
      override protected function handleScaleChanged() : void
      {
         _displayObject.scaleX = _width / sourceWidth * _scaleX;
         _displayObject.scaleY = _height / sourceHeight * _scaleY;
      }
      
      override public function getProp(param1:int) : *
      {
         switch(int(param1) - 4)
         {
            case 0:
               return this.playing;
            case 1:
               return this.frame;
         }
      }
      
      override public function setProp(param1:int, param2:*) : void
      {
         switch(int(param1) - 4)
         {
            case 0:
               this.playing = param2;
               break;
            case 1:
               this.frame = param2;
         }
      }
      
      override public function setup_beforeAdd(param1:XML) : void
      {
         super.setup_beforeAdd(param1);
         var _loc2_:String = param1.@playing;
         _playing = _loc2_ != "false";
      }
   }
}
