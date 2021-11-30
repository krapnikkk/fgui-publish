package fairygui.utils.loader
{
   import fairygui.utils.GTimers;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   
   public class SizeLoader extends EventDispatcher
   {
       
      
      private var _url:String;
      
      private var _loader:URLLoader;
      
      private var _loader2:URLLoader;
      
      private var _retry:int;
      
      private var _resultSize:int;
      
      private var _statusCode:int;
      
      public function SizeLoader()
      {
         super();
      }
      
      public function load(param1:String) : void
      {
         this._retry = 0;
         this._url = param1;
         this._resultSize = 0;
         this._statusCode = 200;
         this._loader = new URLLoader();
         this._loader.dataFormat = URLLoaderDataFormat.BINARY;
         this._loader.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
         this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this._loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,this.onResponseStatus);
         this.doLoad();
         GTimers.inst.add(5000,1,this.load2);
      }
      
      public function dispose() : void
      {
         GTimers.inst.remove(this.doLoad);
         GTimers.inst.remove(this.load2);
         if(this._loader)
         {
            this._loader.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this._loader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,this.onResponseStatus);
            try
            {
               this._loader.close();
            }
            catch(err:Error)
            {
            }
            this._loader = null;
         }
         if(this._loader2)
         {
            this._loader2.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this._loader2.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError2);
            this._loader2.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,this.onResponseStatus);
            try
            {
               this._loader2.close();
            }
            catch(err:Error)
            {
            }
            this._loader2 = null;
         }
      }
      
      public function get resultSize() : int
      {
         return this._resultSize;
      }
      
      private function doLoad() : void
      {
         var _loc1_:URLRequest = new URLRequest(this._url);
         _loc1_.useCache = false;
         _loc1_.cacheResponse = false;
         this._loader.load(_loc1_);
      }
      
      private function load2() : void
      {
         this._loader2 = new URLLoader();
         this._loader2.dataFormat = URLLoaderDataFormat.BINARY;
         this._loader2.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
         this._loader2.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,this.onResponseStatus);
         this._loader2.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError2);
         var _loc1_:URLRequest = new URLRequest(this._url);
         _loc1_.useCache = false;
         _loc1_.cacheResponse = false;
         this._loader2.load(_loc1_);
      }
      
      private function onResponseStatus(param1:HTTPStatusEvent) : void
      {
         this._statusCode = param1.status;
      }
      
      private function onProgress(param1:ProgressEvent) : void
      {
         this.dispose();
         if(this._statusCode == 200)
         {
            this._resultSize = param1.bytesTotal;
            dispatchEvent(new Event(Event.COMPLETE));
         }
         else
         {
            dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,"Server response " + this._statusCode));
         }
      }
      
      private function onIOError(param1:IOErrorEvent) : void
      {
         if(this._retry < 3)
         {
            this._retry++;
            GTimers.inst.add(1000,1,this.doLoad);
         }
         else
         {
            this.dispose();
            dispatchEvent(param1);
         }
      }
      
      private function onIOError2(param1:IOErrorEvent) : void
      {
      }
   }
}
