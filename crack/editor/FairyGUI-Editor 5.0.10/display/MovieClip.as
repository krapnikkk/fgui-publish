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
      
      public var timeScale:Number;
      
      private var _bitmap:Bitmap;
      
      private var _frameCount:int;
      
      private var _frames:Vector.<Frame>;
      
      private var _boundsRect:Rectangle;
      
      private var _smoothing:Boolean;
      
      private var _frame:int;
      
      private var _playing:Boolean;
      
      private var _ready:Boolean;
      
      private var _start:int;
      
      private var _end:int;
      
      private var _times:int;
      
      private var _endAt:int;
      
      private var _status:int;
      
      private var _frameElapsed:Number;
      
      private var _reversed:Boolean;
      
      private var _repeatedCount:int;
      
      private var _callback:Function;
      
      public function MovieClip()
      {
         super();
         _bitmap = new Bitmap();
         addChild(_bitmap);
         _playing = true;
         _frameCount = 0;
         _frame = 0;
         _smoothing = true;
         _reversed = false;
         _frameElapsed = 0;
         _repeatedCount = 0;
         timeScale = 1;
         setPlaySettings();
         this.addEventListener("addedToStage",__addedToStage);
         this.addEventListener("removedFromStage",__removedFromStage);
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
         if(_frame < 0 || _frame > _frameCount - 1)
         {
            _frame = _frameCount - 1;
         }
         _ready = checkReady();
         drawFrame();
         _frameElapsed = 0;
         _repeatedCount = 0;
         _reversed = false;
         checkTimer();
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
      
      public function get frame() : int
      {
         return _frame;
      }
      
      public function set frame(param1:int) : void
      {
         if(_frame != param1)
         {
            if(_frames != null && param1 >= _frameCount)
            {
               param1 = _frameCount - 1;
            }
            _frame = param1;
            _frameElapsed = 0;
            drawFrame();
         }
      }
      
      public function get playing() : Boolean
      {
         return _playing;
      }
      
      public function set playing(param1:Boolean) : void
      {
         if(_playing != param1)
         {
            _playing = param1;
            checkTimer();
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
      
      public function rewind() : void
      {
         _frame = 0;
         _frameElapsed = 0;
         _reversed = false;
         _repeatedCount = 0;
         drawFrame();
      }
      
      public function syncStatus(param1:MovieClip) : void
      {
         _frame = param1._frame;
         _frameElapsed = param1._frameElapsed;
         _reversed = param1._reversed;
         _repeatedCount = param1._repeatedCount;
         drawFrame();
      }
      
      public function advance(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc6_:int = _frame;
         var _loc4_:Boolean = _reversed;
         var _loc5_:int = param1;
         while(true)
         {
            _loc2_ = interval + _frames[_frame].addDelay;
            if(_frame == 0 && _repeatedCount > 0)
            {
               _loc2_ = _loc2_ + repeatDelay;
            }
            if(param1 < _loc2_)
            {
               break;
            }
            param1 = param1 - _loc2_;
            if(swing)
            {
               if(_reversed)
               {
                  _frame = Number(_frame) - 1;
                  if(_frame <= 0)
                  {
                     _frame = 0;
                     _repeatedCount = Number(_repeatedCount) + 1;
                     _reversed = !_reversed;
                  }
               }
               else
               {
                  _frame = Number(_frame) + 1;
                  if(_frame > _frameCount - 1)
                  {
                     _frame = Math.max(0,_frameCount - 2);
                     _repeatedCount = Number(_repeatedCount) + 1;
                     _reversed = !_reversed;
                  }
               }
            }
            else
            {
               _frame = Number(_frame) + 1;
               if(_frame > _frameCount - 1)
               {
                  _frame = 0;
                  _repeatedCount = Number(_repeatedCount) + 1;
               }
            }
            if(_frame == _loc6_ && _reversed == _loc4_)
            {
               _loc3_ = _loc5_ - param1;
               param1 = param1 - Math.floor(param1 / _loc3_) * _loc3_;
            }
         }
         _frameElapsed = 0;
         drawFrame();
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
         this.frame = param1;
      }
      
      private function checkReady() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         _loc1_ = 0;
         while(_loc1_ < _frameCount)
         {
            _loc2_ = _frames[_loc1_];
            if(_loc2_.rect.width != 0 && _loc2_.image == null)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      private function update() : void
      {
         var _loc3_:* = null;
         if(!_ready)
         {
            if(checkReady())
            {
               _ready = true;
               if(!_playing)
               {
                  GTimers.inst.remove(update);
                  drawFrame();
               }
            }
         }
         if(!_playing || _frameCount == 0 || _status == 3)
         {
            return;
         }
         var _loc1_:int = GTimers.deltaTime;
         if(timeScale != 1)
         {
            _loc1_ = _loc1_ * timeScale;
         }
         _frameElapsed = _frameElapsed + _loc1_;
         var _loc2_:int = interval + _frames[_frame].addDelay;
         if(_frame == 0 && _repeatedCount > 0)
         {
            _loc2_ = _loc2_ + repeatDelay;
         }
         if(_frameElapsed < _loc2_)
         {
            return;
         }
         _frameElapsed = _frameElapsed - _loc2_;
         if(_frameElapsed > interval)
         {
            _frameElapsed = interval;
         }
         if(swing)
         {
            if(_reversed)
            {
               _frame = Number(_frame) - 1;
               if(_frame <= 0)
               {
                  _frame = 0;
                  _repeatedCount = Number(_repeatedCount) + 1;
                  _reversed = !_reversed;
               }
            }
            else
            {
               _frame = Number(_frame) + 1;
               if(_frame > _frameCount - 1)
               {
                  _frame = Math.max(0,_frameCount - 2);
                  _repeatedCount = Number(_repeatedCount) + 1;
                  _reversed = !_reversed;
               }
            }
         }
         else
         {
            _frame = Number(_frame) + 1;
            if(_frame > _frameCount - 1)
            {
               _frame = 0;
               _repeatedCount = Number(_repeatedCount) + 1;
            }
         }
         if(_status == 1)
         {
            _frame = _start;
            _frameElapsed = 0;
            _status = 0;
         }
         else if(_status == 2)
         {
            _frame = _endAt;
            _frameElapsed = 0;
            _status = 3;
            if(_callback != null)
            {
               _loc3_ = _callback;
               _callback = null;
               if(_loc3_.length == 1)
               {
                  _loc3_(this);
               }
               else
               {
                  _loc3_();
               }
            }
         }
         else if(_frame == _end)
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
            else if(_start != 0)
            {
               _status = 1;
            }
         }
         drawFrame();
      }
      
      private function drawFrame() : void
      {
         var _loc1_:* = null;
         if(_frameCount > 0 && _frame < _frames.length)
         {
            _loc1_ = _frames[_frame];
            _bitmap.bitmapData = _loc1_.image;
            if(_bitmap.smoothing != _smoothing)
            {
               _bitmap.smoothing = _smoothing;
            }
            _bitmap.x = _loc1_.rect.x;
            _bitmap.y = _loc1_.rect.y;
         }
         else
         {
            _bitmap.bitmapData = null;
         }
      }
      
      private function checkTimer() : void
      {
         if((_playing || !_ready) && _frameCount > 0 && this.stage != null)
         {
            GTimers.inst.add(1,0,update);
         }
         else
         {
            GTimers.inst.remove(update);
         }
      }
      
      private function __addedToStage(param1:Event) : void
      {
         if((_playing || !_ready) && _frameCount > 0)
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
