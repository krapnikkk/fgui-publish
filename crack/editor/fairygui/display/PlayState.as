package fairygui.display
{
   import fairygui.utils.GTimers;
   
   public class PlayState
   {
       
      
      public var reachEnding:Boolean;
      
      public var reversed:Boolean;
      
      public var repeatedCount:int;
      
      private var _curFrame:int;
      
      private var _curFrameDelay:int;
      
      private var _lastUpdateSeq:uint;
      
      public function PlayState()
      {
         super();
      }
      
      public function update(param1:MovieClip) : void
      {
         var _loc2_:* = NaN;
         var _loc3_:uint = GTimers.workCount;
         if(_loc3_ - _lastUpdateSeq != 1)
         {
            _loc2_ = 0;
         }
         else
         {
            _loc2_ = Number(GTimers.deltaTime);
         }
         _lastUpdateSeq = _loc3_;
         reachEnding = false;
         _curFrameDelay = _curFrameDelay + _loc2_;
         var _loc4_:int = param1.interval + param1.frames[_curFrame].addDelay + (_curFrame == 0 && repeatedCount > 0?param1.repeatDelay:0);
         if(_curFrameDelay < _loc4_)
         {
            return;
         }
         _curFrameDelay = _curFrameDelay - _loc4_;
         if(_curFrameDelay > param1.interval)
         {
            _curFrameDelay = param1.interval;
         }
         if(param1.swing)
         {
            if(reversed)
            {
               _curFrame = Number(_curFrame) - 1;
               if(_curFrame <= 0)
               {
                  _curFrame = 0;
                  repeatedCount = Number(repeatedCount) + 1;
                  reversed = !reversed;
               }
            }
            else
            {
               _curFrame = Number(_curFrame) + 1;
               if(_curFrame > param1.frameCount - 1)
               {
                  _curFrame = Math.max(0,param1.frameCount - 2);
                  repeatedCount = Number(repeatedCount) + 1;
                  reachEnding = true;
                  reversed = !reversed;
               }
            }
         }
         else
         {
            _curFrame = Number(_curFrame) + 1;
            if(_curFrame > param1.frameCount - 1)
            {
               _curFrame = 0;
               repeatedCount = Number(repeatedCount) + 1;
               reachEnding = true;
            }
         }
      }
      
      public function get currentFrame() : int
      {
         return _curFrame;
      }
      
      public function set currentFrame(param1:int) : void
      {
         _curFrame = param1;
         _curFrameDelay = 0;
      }
      
      public function rewind() : void
      {
         _curFrame = 0;
         _curFrameDelay = 0;
         reversed = false;
         reachEnding = false;
      }
      
      public function reset() : void
      {
         _curFrame = 0;
         _curFrameDelay = 0;
         repeatedCount = 0;
         reachEnding = false;
         reversed = false;
      }
      
      public function copy(param1:PlayState) : void
      {
         _curFrame = param1._curFrame;
         _curFrameDelay = param1._curFrameDelay;
         repeatedCount = param1.repeatedCount;
         reachEnding = param1.reachEnding;
         reversed = param1.reversed;
      }
   }
}
