package fairygui.utils.loader
{
   import fairygui.utils.UtilsStr;
   import flash.display.Loader;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.UncaughtErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   
   public class LoaderExt extends EventDispatcher
   {
      
      public static const TYPE:String = "type";
      
      public static const WEIGHT:String = "weight";
      
      public static const CONTEXT:String = "context";
      
      public static const HEADERS:String = "headers";
      
      public static const PREVENT_CACHING:String = "preventCache";
      
      public static const RAW_CONTENT:String = "rawContent";
      
      private static var IMAGE_EXTENSIONS:Array = ["jpg","jpeg","gif","png"];
       
      
      public var iWeight:Number;
      
      public var iBytesTotal:int;
      
      public var iBytesLoaded:int;
      
      public var iPercentLoaded:Number;
      
      public var iWeightPercentLoaded:Number;
      
      protected var iProps:Object;
      
      protected var iType:String;
      
      protected var iURL:String;
      
      protected var iContent;
      
      protected var iError:String;
      
      protected var iContext:LoaderContext;
      
      protected var iLoader:Loader;
      
      protected var iURLLoader:URLLoader;
      
      protected var iLoadingType:int;
      
      public function LoaderExt()
      {
         super();
      }
      
      public function load(param1:String, param2:Object = null) : void
      {
         var type:String = null;
         var ext:String = null;
         var cacheString:String = null;
         var url:String = param1;
         var props:Object = param2;
         this.iProps = props;
         if(!this.iProps)
         {
            this.iProps = {};
         }
         this.iURL = url;
         this.iBytesTotal = -1;
         this.iBytesLoaded = 0;
         this.iPercentLoaded = 0;
         this.iWeightPercentLoaded = 0;
         this.iContext = this.iProps[CONTEXT] || null;
         this.iWeight = Number(Number(this.iProps[WEIGHT])) || Number(1);
         this.iContent = null;
         this.iError = null;
         if(this.iProps[TYPE])
         {
            this.iType = this.iProps[TYPE].toLowerCase();
         }
         else
         {
            ext = UtilsStr.getFileExt(url);
            if(ext == "swf")
            {
               this.iType = "movieclip";
            }
            else if(IMAGE_EXTENSIONS.indexOf(ext) != -1)
            {
               this.iType = "image";
            }
            else
            {
               this.iType = "binary";
            }
         }
         if(this.iProps[PREVENT_CACHING])
         {
            cacheString = "nocache=" + int(Math.random() * 100 * getTimer());
            if(url.indexOf("?") == -1)
            {
               url = url + ("?" + cacheString);
            }
            else
            {
               url = url + ("&" + cacheString);
            }
         }
         var req:URLRequest = new URLRequest(url);
         if(this.iProps[HEADERS])
         {
            req.requestHeaders = this.iProps[HEADERS];
         }
         if(this.iProps[RAW_CONTENT])
         {
            if(!this.iLoader)
            {
               this.iLoader = new Loader();
               this.iLoader.contentLoaderInfo.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function():void
               {
               });
               if(this.iProps.progress_enabled)
               {
                  this.iLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onProgressHandler);
               }
               this.iLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onCompleteHandler2);
               this.iLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorHandler);
               this.iLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityErrorHandler);
            }
            this.iLoadingType = 1;
            this.iLoader.loadBytes(ByteArray(this.iProps[RAW_CONTENT]),this.iContext);
         }
         else if(this.iType == "image" || this.iType == "movieclip")
         {
            if(!this.iLoader)
            {
               this.iLoader = new Loader();
               if(this.iProps.progress_enabled)
               {
                  this.iLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onProgressHandler);
               }
               this.iLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onCompleteHandler2);
               this.iLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorHandler);
               this.iLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityErrorHandler);
            }
            this.iLoadingType = 1;
            this.iLoader.load(req,this.iContext);
         }
         else
         {
            if(!this.iURLLoader)
            {
               this.iURLLoader = new URLLoader();
               this.iURLLoader.dataFormat = URLLoaderDataFormat.BINARY;
               if(this.iProps.progress_enabled)
               {
                  this.iURLLoader.addEventListener(ProgressEvent.PROGRESS,this.onProgressHandler);
               }
               this.iURLLoader.addEventListener(Event.COMPLETE,this.onCompleteHandler3);
               this.iURLLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorHandler);
               this.iURLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityErrorHandler);
            }
            this.iLoadingType = 2;
            this.iURLLoader.load(req);
         }
      }
      
      public function get content() : *
      {
         return this.iContent;
      }
      
      public function get error() : String
      {
         return this.iError;
      }
      
      public function get url() : String
      {
         return this.iURL;
      }
      
      public function get props() : Object
      {
         return this.iProps;
      }
      
      public function get applicationDomain() : ApplicationDomain
      {
         if(this.iLoader)
         {
            return this.iLoader.contentLoaderInfo.applicationDomain;
         }
         return ApplicationDomain.currentDomain;
      }
      
      public function close() : void
      {
         try
         {
            this.iLoader.close();
            this.iLoader.unload();
         }
         catch(e:*)
         {
         }
         try
         {
            if(this.iURLLoader)
            {
               this.iURLLoader.close();
            }
         }
         catch(e:*)
         {
         }
         this.iURL = null;
         this.iContent = null;
      }
      
      private function onProgressHandler(param1:ProgressEvent) : void
      {
         if(!this.iProps.progress_enabled)
         {
            return;
         }
         this.iBytesLoaded = param1.bytesLoaded;
         this.iBytesTotal = param1.bytesTotal;
         if(this.iBytesTotal > 0)
         {
            this.iPercentLoaded = this.iBytesLoaded / this.iBytesTotal;
         }
         else
         {
            this.iPercentLoaded = 1;
         }
         this.iWeightPercentLoaded = this.iPercentLoaded * this.iWeight;
         dispatchEvent(param1);
      }
      
      private function onCompleteHandler2(param1:Event) : void
      {
         if(this.iLoadingType != 1)
         {
            return;
         }
         this.iContent = this.iLoader.content;
         dispatchEvent(param1);
      }
      
      private function onCompleteHandler3(param1:Event) : void
      {
         if(this.iLoadingType != 2)
         {
            return;
         }
         this.iContent = this.iURLLoader.data;
         dispatchEvent(param1);
      }
      
      private function onErrorHandler(param1:ErrorEvent) : void
      {
         param1.stopPropagation();
         this.iError = param1.text;
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false));
      }
      
      private function onSecurityErrorHandler(param1:ErrorEvent) : void
      {
         param1.stopPropagation();
         this.iError = param1.text;
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false));
      }
   }
}
