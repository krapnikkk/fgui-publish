package fairygui.editor.animation
{
   import fairygui.utils.GTimers;
   import flash.display.BitmapData;
   
   public class DecodeSupport
   {
      
      public static var textureToLoadOneRound:int = 50;
      
      public static const inst:DecodeSupport = new DecodeSupport();
       
      
      private var _queue:Array;
      
      private var _decodingAni:AniDef;
      
      private var _decodingTexture:int;
      
      private var _loadingCount:int;
      
      public function DecodeSupport()
      {
         super();
         this._queue = [];
         GTimers.inst.add(80,0,this.onTimer);
      }
      
      public function add(param1:AniDef) : void
      {
         if(param1.textureList.length == 0)
         {
            param1.setReady();
            return;
         }
         param1.queued = true;
         this._queue.push(param1);
      }
      
      public function get busy() : Boolean
      {
         return this._queue.length || this._loadingCount;
      }
      
      public function reset() : void
      {
         this._queue.length = 0;
         this._decodingAni = null;
         this._loadingCount = 0;
         TextureLoader.clearPool();
      }
      
      private function onTimer() : void
      {
         var _loc1_:AniTexture = null;
         var _loc2_:int = 0;
         while(_loc2_ < textureToLoadOneRound)
         {
            if(this._decodingAni == null)
            {
               if(this._queue.length)
               {
                  this._decodingAni = this._queue.pop();
               }
               if(this._decodingAni)
               {
                  if(this._decodingAni.decoding)
                  {
                     this._decodingAni = null;
                     continue;
                  }
                  this._decodingAni.decoding = true;
                  this._decodingTexture = 0;
               }
               else
               {
                  break;
               }
            }
            _loc1_ = this._decodingAni.textureList[this._decodingTexture];
            if(!_loc1_.bitmapData)
            {
               if(_loc1_.raw)
               {
                  TextureLoader.load(this._decodingAni,_loc1_,_loc1_.raw,this.onTextureLoaded);
                  this._loadingCount++;
                  _loc2_++;
               }
               else
               {
                  this._decodingAni.textureToDecode--;
                  if(this._decodingAni.textureToDecode <= 0)
                  {
                     this._decodingAni.setReady();
                  }
               }
            }
            else
            {
               this._decodingAni.textureToDecode--;
               if(this._decodingAni.textureToDecode <= 0)
               {
                  this._decodingAni.setReady();
               }
            }
            this._decodingTexture++;
            if(this._decodingTexture >= this._decodingAni.textureList.length)
            {
               this._decodingTexture = 0;
               this._decodingAni = null;
            }
         }
      }
      
      private function onTextureLoaded(param1:AniDef, param2:AniTexture, param3:BitmapData) : void
      {
         this._loadingCount--;
         if(param2.raw != null)
         {
            param2.bitmapData = param3;
            param1.textureToDecode--;
            if(param1.textureToDecode <= 0)
            {
               param1.setReady();
            }
         }
         else
         {
            param3.dispose();
         }
      }
   }
}
