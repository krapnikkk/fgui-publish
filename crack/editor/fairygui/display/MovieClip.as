package fairygui.display
{
   import fairygui.utils.GTimers;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class MovieClip extends Sprite
   {
       
      
      public var interval:int;
      
      public var swing:Boolean;
      
      public var repeatDelay:int;
      
      private var _bitmap:Bitmap;
      
      private var _playing:Boolean;
      
      private var _playState:PlayState;
      
      private var _frameCount:int;
      
      private var _frames:Vector.<Frame>;
      
      private var _currentFrame:int;
      
      private var _boundsRect:Rectangle;
      
      private var _start:int;
      
      private var _end:int;
      
      private var _times:int;
      
      private var _endAt:int;
      
      private var _status:int;
      
      private var _callback:Function;
      
      private var _smoothing:Boolean;
      
      public function MovieClip()
      {
         super();
         _bitmap = new Bitmap();
         addChild(_bitmap);
         _playState = new PlayState();
         _playing = true;
         setPlaySettings();
         _smoothing = true;
         this.addEventListener("addedToStage",__addedToStage);
         this.addEventListener("removedFromStage",__removedFromStage);
      }
      
      public function get playState() : PlayState
      {
         return _playState;
      }
      
      public function set playState(param1:PlayState) : void
      {
         _playState = param1;
      }
      
      public function get frames() : Vector.<Frame>
      {
         return _frames;
      }
      
      public function set frames(param1:Vector.<Frame>) : void
      {
         _frames = param1;
         if(_frames != null)
         {
            _frameCount = _frames.length;
         }
         else
         {
            _frameCount = 0;
         }
         if(_end == -1 || _end > _frameCount - 1)
         {
            _end = _frameCount - 1;
         }
         if(_endAt == -1 || _endAt > _frameCount - 1)
         {
            _endAt = _frameCount - 1;
         }
         if(_currentFrame < 0 || _currentFrame > _frameCount - 1)
         {
            _currentFrame = _frameCount - 1;
         }
         if(_frameCount > 0)
         {
            setFrame(_frames[_currentFrame]);
         }
         else
         {
            setFrame(null);
         }
         _playState.rewind();
      }
      
      public function get frameCount() : int
      {
         return _frameCount;
      }
      
      public function get boundsRect() : Rectangle
      {
         return _boundsRect;
      }
      
      public function set boundsRect(param1:Rectangle) : void
      {
         _boundsRect = param1;
      }
      
      public function get currentFrame() : int
      {
         return _currentFrame;
      }
      
      public function set currentFrame(param1:int) : void
      {
         if(_currentFrame != param1)
         {
            _currentFrame = param1;
            _playState.currentFrame = param1;
            setFrame(_currentFrame < _frameCount?_frames[_currentFrame]:null);
         }
      }
      
      public function get playing() : Boolean
      {
         return _playing;
      }
      
      public function set playing(param1:Boolean) : void
      {
         _playing = param1;
         if(_playing && this.stage != null)
         {
            GTimers.inst.add(1,0,update);
         }
         else
         {
            GTimers.inst.remove(update);
         }
      }
      
      public function get smoothing() : Boolean
      {
         return _smoothing;
      }
      
      public function set smoothing(param1:Boolean) : void
      {
         _smoothing = param1;
         _bitmap.smoothing = _smoothing;
      }
      
      public function setPlaySettings(param1:int = 0, param2:int = -1, param3:int = 0, param4:int = -1, param5:Function = null) : void
      {
         _start = param1;
         _end = param2;
         if(_end == -1 || _end > _frameCount - 1)
         {
            _end = _frameCount - 1;
         }
         _times = param3;
         _endAt = param4;
         if(_endAt == -1)
         {
            _endAt = _end;
         }
         _status = 0;
         _callback = param5;
         this.currentFrame = param1;
      }
      
      private function update() : void
      {
         var _loc1_:* = null;
         if(_playing && _frameCount != 0 && _status != 3)
         {
            _playState.update(this);
            if(_currentFrame != _playState.currentFrame)
            {
               if(_status == 1)
               {
                  _currentFrame = _start;
                  _playState.currentFrame = _currentFrame;
                  _status = 0;
               }
               else if(_status == 2)
               {
                  _currentFrame = _endAt;
                  _playState.currentFrame = _currentFrame;
                  _status = 3;
                  if(_callback != null)
                  {
                     _loc1_ = _callback;
                     _callback = null;
                     if(_loc1_.length == 1)
                     {
                        _loc1_(this);
                     }
                     else
                     {
                        _loc1_();
                     }
                  }
               }
               else
               {
                  _currentFrame = _playState.currentFrame;
                  if(_currentFrame == _end)
                  {
                     if(_times > 0)
                     {
                        _times = Number(_times) - 1;
                        if(_times == 0)
                        {
                           _status = 2;
                        }
                        else
                        {
                           _status = 1;
                        }
                     }
                  }
               }
               setFrame(_frames[_currentFrame]);
            }
         }
      }
      
      private function setFrame(param1:Frame) : void
      {
         if(param1 != null)
         {
            _bitmap.bitmapData = param1.image;
            if(_bitmap.smoothing != _smoothing)
            {
               _bitmap.smoothing = _smoothing;
            }
            _bitmap.x = param1.rect.x;
            _bitmap.y = param1.rect.y;
         }
         else
         {
            _bitmap.bitmapData = null;
         }
      }
      
      private function __addedToStage(param1:Event) : void
      {
         if(_playing)
         {
            GTimers.inst.add(1,0,update);
         }
      }
      
      private function __removedFromStage(param1:Event) : void
      {
         GTimers.inst.remove(update);
      }
   }
}
