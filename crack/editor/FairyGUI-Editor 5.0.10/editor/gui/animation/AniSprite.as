package fairygui.editor.gui.animation
{
   import fairygui.utils.GTimers;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class AniSprite extends Sprite
   {
       
      
      private var _bitmap:Bitmap;
      
      private var _ready:Boolean;
      
      private var _def:AniDef;
      
      private var _smoothing:Boolean;
      
      private var _frame:int;
      
      private var _playing:Boolean;
      
      private var _frameElapsed:int;
      
      private var _reversed:Boolean;
      
      private var _repeatedCount:int;
      
      public function AniSprite()
      {
         super();
         this._bitmap = new Bitmap();
         addChild(this._bitmap);
         this._smoothing = true;
         this._frame = 0;
         this._playing = true;
         this._reversed = false;
         this._frameElapsed = 0;
         this._repeatedCount = 0;
         addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
      
      public function get def() : AniDef
      {
         return this._def;
      }
      
      public function set def(param1:AniDef) : void
      {
         this._def = param1;
         this._frameElapsed = 0;
         this._repeatedCount = 0;
         this._reversed = false;
         if(this._def)
         {
            if(this._frame < 0 || this._frame >= this._def.frameCount)
            {
               this._frame = this._def.frameCount - 1;
            }
            this._ready = this._def.ready;
            if(this._ready)
            {
               this.drawFrame();
            }
         }
         else
         {
            this._ready = false;
            this.clear();
         }
         this.checkTimer();
      }
      
      public function set playing(param1:Boolean) : void
      {
         if(this._playing != param1)
         {
            this._playing = param1;
            this.checkTimer();
         }
      }
      
      public function get playing() : Boolean
      {
         return this._playing;
      }
      
      public function set frame(param1:int) : void
      {
         if(this._frame != param1)
         {
            if(this._def != null && param1 >= this._def.frameCount)
            {
               param1 = this._def.frameCount - 1;
            }
            this._frame = param1;
            this._frameElapsed = 0;
            this.drawFrame();
         }
      }
      
      public function get frame() : int
      {
         return this._frame;
      }
      
      public function set smoothing(param1:Boolean) : void
      {
         this._smoothing = param1;
         this._bitmap.smoothing = param1;
      }
      
      public function get smoothing() : Boolean
      {
         return this._smoothing;
      }
      
      public function stepNext() : void
      {
         this._frameElapsed = 0;
         this._frame++;
         if(this._frame > this._def.frameCount - 1)
         {
            this._frame = 0;
         }
         this.drawFrame();
      }
      
      public function stepPrev() : void
      {
         this._frameElapsed = 0;
         this._frame--;
         if(this._frame < 0)
         {
            this._frame = this._def.frameCount - 1;
         }
         this.drawFrame();
      }
      
      public function rewind() : void
      {
         this._frame = 0;
         this._frameElapsed = 0;
         this._reversed = false;
         this._repeatedCount = 0;
         this.drawFrame();
      }
      
      public function advance(param1:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:int = this._frame;
         var _loc3_:Boolean = this._reversed;
         var _loc4_:int = param1;
         while(true)
         {
            _loc5_ = 1000 / this._def.fps * this._def.speed + this._def.frameList[this._frame].delay;
            if(this._frame == 0 && this._repeatedCount > 0)
            {
               _loc5_ = _loc5_ + this.def.repeatDelay;
            }
            if(param1 < _loc5_)
            {
               break;
            }
            param1 = param1 - _loc5_;
            if(this.def.swing)
            {
               if(this._reversed)
               {
                  this._frame--;
                  if(this._frame <= 0)
                  {
                     this._frame = 0;
                     this._repeatedCount++;
                     this._reversed = !this._reversed;
                  }
               }
               else
               {
                  this._frame++;
                  if(this._frame > this.def.frameCount - 1)
                  {
                     this._frame = Math.max(0,this.def.frameCount - 2);
                     this._repeatedCount++;
                     this._reversed = !this._reversed;
                  }
               }
            }
            else
            {
               this._frame++;
               if(this._frame > this.def.frameCount - 1)
               {
                  this._frame = 0;
                  this._repeatedCount++;
               }
            }
            if(this._frame == _loc2_ && this._reversed == _loc3_)
            {
               _loc6_ = _loc4_ - param1;
               param1 = param1 - Math.floor(param1 / _loc6_) * _loc6_;
            }
         }
         this._frameElapsed = 0;
         this.drawFrame();
      }
      
      public function clear() : void
      {
         this._bitmap.bitmapData = null;
      }
      
      public function dispose() : void
      {
         if(this._def != null)
         {
            this._bitmap.bitmapData = null;
            GTimers.inst.remove(this.update);
         }
         this._playing = false;
         this._ready = false;
         this._def = null;
      }
      
      public function update() : void
      {
         if(!this._ready)
         {
            if(this._def.ready)
            {
               this._ready = true;
               if(!this._playing)
               {
                  GTimers.inst.remove(this.update);
               }
               this.drawFrame();
            }
         }
         if(!this._playing || this._def.frameCount == 0)
         {
            return;
         }
         if(this._frame < 0)
         {
            this._frame = 0;
         }
         var _loc1_:int = GTimers.deltaTime;
         this._frameElapsed = this._frameElapsed + _loc1_;
         var _loc2_:int = 1000 / this._def.fps;
         var _loc3_:int = _loc2_ * this._def.speed;
         var _loc4_:int = _loc3_ + _loc2_ * this._def.frameList[this._frame].delay;
         if(this._frame == 0 && this._repeatedCount > 0)
         {
            _loc4_ = _loc4_ + _loc2_ * this.def.repeatDelay;
         }
         if(this._frameElapsed < _loc4_)
         {
            return;
         }
         this._frameElapsed = this._frameElapsed - _loc4_;
         if(this._frameElapsed > _loc3_)
         {
            this._frameElapsed = _loc3_;
         }
         if(this.def.swing)
         {
            if(this._reversed)
            {
               this._frame--;
               if(this._frame <= 0)
               {
                  this._frame = 0;
                  this._repeatedCount++;
                  this._reversed = !this._reversed;
               }
            }
            else
            {
               this._frame++;
               if(this._frame > this.def.frameCount - 1)
               {
                  this._frame = Math.max(0,this.def.frameCount - 2);
                  this._repeatedCount++;
                  this._reversed = !this._reversed;
               }
            }
         }
         else
         {
            this._frame++;
            if(this._frame > this.def.frameCount - 1)
            {
               this._frame = 0;
               this._repeatedCount++;
            }
         }
         this.drawFrame();
      }
      
      private function drawFrame() : void
      {
         var _loc1_:AniFrame = null;
         var _loc2_:AniTexture = null;
         if(this.def && this.def.frameCount > 0 && this._frame < this.def.frameCount)
         {
            _loc1_ = this._def.frameList[this._frame];
            if(_loc1_.textureIndex == -1)
            {
               this._bitmap.bitmapData = null;
            }
            else
            {
               _loc2_ = this._def.textureList[_loc1_.textureIndex];
               this._bitmap.bitmapData = _loc2_.bitmapData;
               this._bitmap.smoothing = this._smoothing;
               this._bitmap.x = _loc1_.rect.x;
               this._bitmap.y = _loc1_.rect.y;
            }
         }
         else
         {
            this._bitmap.bitmapData = null;
         }
      }
      
      private function checkTimer() : void
      {
         if((this._playing || !this._ready) && this._def && this.stage != null)
         {
            if(!this._def.ready && !this._def.queued)
            {
               DecodeSupport.inst.add(this._def);
            }
            GTimers.inst.add(1,0,this.update);
         }
         else
         {
            GTimers.inst.remove(this.update);
         }
      }
      
      private function onAdded(param1:Event) : void
      {
         if(this._def && (this._playing || !this._ready))
         {
            if(!this._def.ready && !this._def.queued)
            {
               DecodeSupport.inst.add(this._def);
            }
            GTimers.inst.add(1,0,this.update);
         }
      }
      
      private function onRemoved(param1:Event) : void
      {
         GTimers.inst.remove(this.update);
      }
   }
}
