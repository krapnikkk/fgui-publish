package fairygui.editor.loader
{
   import fairygui.editor.utils.UtilsStr;
   import flash.display.Loader;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.ProgressEvent;
   import flash.net.URLLoader;
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
      
      public var iType:String;
      
      protected var iURL:String;
      
      protected var iContent;
      
      protected var iError:String;
      
      protected var iContext:LoaderContext;
      
      protected var iLoader:Loader;
      
      protected var iURLLoader:URLLoader;
      
      protected var iLoadingType:int;
      
      public var extName:String;
      
      public function LoaderExt()
      {
         super();
      }
      
      public function load(param1:String, param2:Object = null) : void
      {
         param1 = param1;
         param2 = param2;
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
         this.iContext = this.iProps["context"] || null;
         this.iWeight = Number(this.iProps["weight"]) || 1;
         this.iContent = null;
         this.iError = null;
         if(this.iProps["type"])
         {
            this.iType = this.iProps["type"].toLowerCase();
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
         this.extName = ext;
         if(this.iProps["preventCache"])
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
         if(this.iProps["headers"])
         {
            req.requestHeaders = this.iProps["headers"];
         }
         if(this.iProps["rawContent"])
         {
            if(!this.iLoader)
            {
               this.iLoader = new Loader();
               this.iLoader.contentLoaderInfo.addEventListener("uncaughtError",function():void
               {
               });
               if(this.iProps.progress_enabled)
               {
                  this.iLoader.contentLoaderInfo.addEventListener("progress",this.onProgressHandler);
               }
               this.iLoader.contentLoaderInfo.addEventListener("complete",this.onCompleteHandler2);
               this.iLoader.contentLoaderInfo.addEventListener("ioError",this.onErrorHandler);
               this.iLoader.contentLoaderInfo.addEventListener("securityError",this.onSecurityErrorHandler);
            }
            this.iLoadingType = 1;
            this.iLoader.loadBytes(ByteArray(this.iProps["rawContent"]),this.iContext);
         }
         else if(this.iType == "image" || this.iType == "movieclip")
         {
            if(!this.iLoader)
            {
               this.iLoader = new Loader();
               if(this.iProps.progress_enabled)
               {
                  this.iLoader.contentLoaderInfo.addEventListener("progress",this.onProgressHandler);
               }
               this.iLoader.contentLoaderInfo.addEventListener("complete",this.onCompleteHandler2);
               this.iLoader.contentLoaderInfo.addEventListener("ioError",this.onErrorHandler);
               this.iLoader.contentLoaderInfo.addEventListener("securityError",this.onSecurityErrorHandler);
            }
            this.iLoadingType = 1;
            this.iLoader.load(req,this.iContext);
         }
         else
         {
            if(!this.iURLLoader)
            {
               this.iURLLoader = new URLLoader();
               this.iURLLoader.dataFormat = "binary";
               if(this.iProps.progress_enabled)
               {
                  this.iURLLoader.addEventListener("progress",this.onProgressHandler);
               }
               this.iURLLoader.addEventListener("complete",this.onCompleteHandler3);
               this.iURLLoader.addEventListener("ioError",this.onErrorHandler);
               this.iURLLoader.addEventListener("securityError",this.onSecurityErrorHandler);
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
         dispatchEvent(new ErrorEvent("error",false,false));
      }
      
      private function onSecurityErrorHandler(param1:ErrorEvent) : void
      {
         param1.stopPropagation();
         this.iError = param1.text;
         dispatchEvent(new ErrorEvent("error",false,false));
      }
   }
}
