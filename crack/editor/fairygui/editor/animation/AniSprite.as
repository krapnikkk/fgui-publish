package fairygui.editor.animation
{
   import fairygui.utils.GTimers;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class AniSprite extends Sprite
   {
       
      
      private var _bitmap:Bitmap;
      
      private var _playing:Boolean;
      
      private var _ready:Boolean;
      
      private var _def:AniDef;
      
      private var _playSettings:PlaySettings;
      
      private var _smoothing:Boolean;
      
      public function AniSprite(param1:PlaySettings = null)
      {
         super();
         this._playSettings = param1;
         if(!this._playSettings)
         {
            this._playSettings = new PlaySettings();
         }
         this._smoothing = true;
         this._bitmap = new Bitmap();
         addChild(this._bitmap);
         addEventListener("addedToStage",this.onAdded);
         addEventListener("removedFromStage",this.onRemoved);
      }
      
      public function get def() : AniDef
      {
         return this._def;
      }
      
      public function set def(param1:AniDef) : void
      {
         this._playing = false;
         this._ready = false;
         if(this._def != null)
         {
            this._def.releaseRef();
         }
         this._def = param1;
         this._def.addRef();
         this._playSettings.rewind();
         if(this.stage)
         {
            GTimers.inst.add(1000 / this._def.fps,0,this.update);
         }
      }
      
      public function get ready() : Boolean
      {
         return this._ready;
      }
      
      public function set playing(param1:Boolean) : void
      {
         this._playing = param1;
      }
      
      public function get playing() : Boolean
      {
         return this._playing;
      }
      
      public function set frame(param1:int) : void
      {
         this._playSettings.curFrame = param1;
         this._playSettings.curFrameDelay = 0;
         this._playSettings.setRedrawFlag();
      }
      
      public function get frame() : int
      {
         return this._playSettings.curFrame;
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
      
      public function clear() : void
      {
         this._bitmap.bitmapData = null;
      }
      
      public function dispose() : void
      {
         if(this._def != null)
         {
            this._def.releaseRef();
            this._bitmap.bitmapData = null;
            GTimers.inst.remove(this.update);
         }
         this._playing = false;
         this._ready = false;
         this._def = null;
      }
      
      public function update() : void
      {
         var _loc2_:AniFrame = null;
         var _loc1_:AniTexture = null;
         if(!this._def)
         {
            return;
         }
         if(!this._ready && this._def.ready)
         {
            this._ready = true;
            this._playSettings.setRedrawFlag();
         }
         if(!this._def.ready || this._def.frameCount == 0)
         {
            if(!this._def.queued)
            {
               DecodeSupport.inst.add(this._def);
            }
            return;
         }
         if(this._playSettings.curFrameDelay == 0 || this._playSettings.redrawFlag)
         {
            if(this._playSettings.curFrame < this._def.frameList.length)
            {
               _loc2_ = this._def.frameList[this._playSettings.curFrame];
               if(_loc2_.textureIndex == -1)
               {
                  this._bitmap.bitmapData = null;
               }
               else
               {
                  _loc1_ = this._def.textureList[_loc2_.textureIndex];
                  this._bitmap.bitmapData = _loc1_.bitmapData;
                  this._bitmap.smoothing = this._smoothing;
                  this._bitmap.x = _loc2_.rect.x;
                  this._bitmap.y = _loc2_.rect.y;
               }
            }
         }
         if(this._ready && this._playing)
         {
            this._playSettings.nextFrame(this._def);
         }
      }
      
      private function onAdded(param1:Event) : void
      {
         if(this._def)
         {
            GTimers.inst.add(1000 / this._def.fps,0,this.update);
         }
      }
      
      private function onRemoved(param1:Event) : void
      {
         GTimers.inst.remove(this.update);
      }
   }
}
