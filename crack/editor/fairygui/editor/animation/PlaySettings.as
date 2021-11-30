package fairygui.editor.animation
{
   public class PlaySettings
   {
       
      
      public var curFrame:int;
      
      public var curFrameDelay:int;
      
      public var speedRatio:Number;
      
      public var totalFrames:int;
      
      public var repeatedCount:int;
      
      public var reachEnding:Boolean;
      
      public var reversed:Boolean;
      
      public var redrawFlag:int;
      
      private var _curFrame:int;
      
      public function PlaySettings()
      {
         super();
         this.speedRatio = 1;
      }
      
      public function setRedrawFlag() : void
      {
         this.redrawFlag = 2;
      }
      
      public function nextFrame(param1:AniDef) : Boolean
      {
         if(this.redrawFlag)
         {
            this.redrawFlag--;
         }
         if(!param1.ready || param1.frameCount == 0 || this.curFrame >= param1.frameCount)
         {
            return false;
         }
         this.reachEnding = false;
         this.curFrameDelay++;
         var _loc2_:int = Math.ceil(param1.speed / this.speedRatio);
         if(this.curFrame == 0)
         {
            if(this.curFrameDelay < _loc2_ + param1.frameList[this.curFrame].delay + (this.repeatedCount > 0?param1.repeatDelay:0))
            {
               return false;
            }
         }
         else if(this.curFrameDelay < _loc2_ + param1.frameList[this.curFrame].delay)
         {
            return false;
         }
         this.curFrameDelay = 0;
         if(param1.swing)
         {
            if(this.reversed)
            {
               this.curFrame--;
               if(this.curFrame < 0)
               {
                  this.curFrame = Math.min(1,param1.frameCount - 1);
                  this.repeatedCount++;
                  this.reversed = !this.reversed;
               }
            }
            else
            {
               this.curFrame++;
               if(this.curFrame > param1.frameCount - 1)
               {
                  this.curFrame = Math.max(0,param1.frameCount - 2);
                  this.repeatedCount++;
                  this.reachEnding = true;
                  this.reversed = !this.reversed;
               }
            }
         }
         else
         {
            this.curFrame++;
            if(this.curFrame > param1.frameCount - 1)
            {
               this.curFrame = 0;
               this.repeatedCount++;
               this.reachEnding = true;
            }
         }
         return true;
      }
      
      public function stepNext(param1:AniDef) : void
      {
         this.curFrameDelay = 0;
         this.curFrame++;
         if(this.curFrame > param1.frameCount - 1)
         {
            this.curFrame = 0;
         }
      }
      
      public function stepPrev(param1:AniDef) : void
      {
         this.curFrameDelay = 0;
         this.curFrame--;
         if(this.curFrame < 0)
         {
            this.curFrame = param1.frameCount - 1;
         }
      }
      
      public function rewind() : void
      {
         this.curFrame = 0;
         this.curFrameDelay = 0;
         this.reversed = false;
         this.reachEnding = false;
      }
      
      public function reset() : void
      {
         this.curFrame = 0;
         this.curFrameDelay = 0;
         this.speedRatio = 1;
         this.repeatedCount = 0;
         this.reachEnding = false;
         this.reversed = false;
      }
      
      public function copy(param1:PlaySettings) : void
      {
         this.curFrame = param1.curFrame;
         this.curFrameDelay = param1.curFrameDelay;
         this.speedRatio = param1.speedRatio;
         this.repeatedCount = param1.repeatedCount;
         this.reachEnding = param1.reachEnding;
         this.reversed = param1.reversed;
      }
   }
}
