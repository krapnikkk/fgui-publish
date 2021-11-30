package fairygui.editor.loader
{
   import fairygui.utils.GTimers;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.utils.ByteArray;
   
   public class PartLoader extends EventDispatcher
   {
       
      
      private var _url:String;
      
      private var _retry:int;
      
      private var _bytesLoaded:int;
      
      private var _startPos:int;
      
      private var _endPos:int;
      
      private var _data:ByteArray;
      
      private var _loader:URLLoader;
      
      public function PartLoader()
      {
         super();
      }
      
      public function get startPos() : int
      {
         return this._startPos;
      }
      
      public function get endPos() : int
      {
         return this._endPos;
      }
      
      public function get bytesLoaded() : int
      {
         return this._bytesLoaded;
      }
      
      public function get data() : ByteArray
      {
         return this._data;
      }
      
      public function get idle() : Boolean
      {
         return this._loader == null;
      }
      
      public function load(param1:String, param2:int, param3:int) : void
      {
         this._url = param1;
         this._startPos = param2;
         this._endPos = param3;
         this._bytesLoaded = 0;
         this._retry = 0;
         this._data = null;
         this._loader = new URLLoader();
         this._loader.dataFormat = "binary";
         this._loader.addEventListener("progress",this.onProgress);
         this._loader.addEventListener("complete",this.onComplete);
         this._loader.addEventListener("ioError",this.onIOError);
         this.doLoad();
      }
      
      public function dispose() : void
      {
         GTimers.inst.remove(this.doLoad);
         if(this._loader)
         {
            this._loader.removeEventListener("progress",this.onProgress);
            this._loader.removeEventListener("complete",this.onComplete);
            this._loader.removeEventListener("ioError",this.onIOError);
            try
            {
               this._loader.close();
            }
            catch(err:Error)
            {
            }
            this._loader = null;
         }
      }
      
      private function doLoad() : void
      {
         var _loc1_:URLRequest = new URLRequest(this._url);
         _loc1_.useCache = false;
         _loc1_.cacheResponse = false;
         _loc1_.requestHeaders.push(new URLRequestHeader("Range","bytes=" + this._startPos + "-" + this._endPos));
         this._loader.load(_loc1_);
      }
      
      private function onProgress(param1:ProgressEvent) : void
      {
         this._bytesLoaded = param1.bytesLoaded;
         dispatchEvent(param1);
      }
      
      private function onComplete(param1:Event) : void
      {
         var _loc2_:ByteArray = this._loader.data;
         if(_loc2_.length == this._endPos - this._startPos + 1)
         {
            this._data = _loc2_;
            this.dispose();
            dispatchEvent(new Event("complete"));
         }
         else if(this._retry < 3)
         {
            this._retry++;
            GTimers.inst.add(1000,1,this.doLoad);
         }
         else
         {
            this.dispose();
            dispatchEvent(new IOErrorEvent("ioError",false,false,"Content Error"));
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
   }
}
