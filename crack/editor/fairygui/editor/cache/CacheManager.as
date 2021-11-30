package fairygui.editor.cache
{
   import fairygui.editor.EditorWindow;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIPackage;
   import fairygui.editor.gui.EUIProject;
   import fairygui.editor.loader.EasyLoader;
   import fairygui.editor.loader.LoaderExt;
   import fairygui.editor.utils.UtilsFile;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.media.Sound;
   import flash.net.URLRequest;
   import flash.net.registerClassAlias;
   import flash.system.MessageChannel;
   import flash.system.Worker;
   import flash.system.WorkerDomain;
   
   public class CacheManager
   {
       
      
      private var _project:EUIProject;
      
      private var _worker:Worker;
      
      private var _outChannel:MessageChannel;
      
      private var _inChannel:MessageChannel;
      
      public function CacheManager(param1:EditorWindow)
      {
         super();
         registerClassAlias("CacheMessage",CacheMessage as Class);
         this._project = param1.project;
      }
      
      public function loadImage(param1:EPackageItem) : void
      {
         var _loc3_:File = null;
         var _loc2_:File = null;
         var _loc6_:Object = null;
         var _loc4_:* = param1;
         if(_loc4_.generatingCache)
         {
            return;
         }
         try
         {
            _loc3_ = new File(this._project.objsPath + "/cache/" + _loc4_.owner.id);
            if(!_loc3_.exists)
            {
               _loc3_.createDirectory();
            }
            _loc2_ = _loc3_.resolvePath(_loc4_.id);
            if(_loc2_.exists)
            {
               _loc6_ = UtilsFile.loadJSON(_loc3_.resolvePath(_loc4_.id + ".info"));
               if(_loc6_)
               {
                  if(_loc6_.modificationDate == _loc4_.modificationTime && _loc6_.fileSize == _loc4_.fileSize && _loc6_.format == _loc4_.imageInfo.format && _loc6_.quality == _loc4_.imageInfo.targetQuality)
                  {
                     _loc4_.imageInfo.file = _loc2_;
                     if(_loc4_.imageInfo.loadingToMemory)
                     {
                        EasyLoader.load(_loc2_.url,{
                           "pi":_loc4_,
                           "type":"image",
                           "version":_loc4_.version
                        },this.__imageLoaded);
                     }
                     else
                     {
                        _loc4_.invokeCallbacks();
                     }
                     return;
                  }
               }
            }
         }
         catch(err:Error)
         {
         }
         if(!this._worker)
         {
            this.createWorker();
         }
         _loc4_.generatingCache = true;
         var _loc5_:CacheMessage = new CacheMessage();
         _loc5_.pkgId = _loc4_.owner.id;
         _loc5_.itemId = _loc4_.id;
         _loc5_.sourceFile = _loc4_.file.nativePath;
         _loc5_.targetFile = _loc2_.nativePath;
         _loc5_.format = _loc4_.imageInfo.format;
         _loc5_.quality = _loc4_.imageInfo.targetQuality;
         _loc5_.version = _loc4_.version;
         this._outChannel.send(_loc5_);
      }
      
      public function loadSound(param1:EPackageItem) : void
      {
         var _loc3_:File = null;
         var _loc2_:File = null;
         var _loc6_:Object = null;
         var _loc4_:* = param1;
         try
         {
            _loc3_ = new File(this._project.objsPath + "/cache/" + _loc4_.owner.id);
            if(!_loc3_.exists)
            {
               _loc3_.createDirectory();
            }
            _loc2_ = _loc3_.resolvePath(_loc4_.id);
            if(_loc2_.exists)
            {
               _loc6_ = UtilsFile.loadJSON(_loc3_.resolvePath(_loc4_.id + ".info"));
               if(_loc6_)
               {
                  if(_loc6_.modificationDate == _loc4_.modificationTime && _loc6_.fileSize == _loc4_.fileSize)
                  {
                     _loc4_.data = new Sound(new URLRequest(_loc2_.url));
                     _loc4_.invokeCallbacks();
                     return;
                  }
               }
            }
         }
         catch(err:Error)
         {
         }
         if(!this._worker)
         {
            this.createWorker();
         }
         var _loc5_:CacheMessage = new CacheMessage();
         _loc5_.pkgId = _loc4_.owner.id;
         _loc5_.itemId = _loc4_.id;
         _loc5_.sourceFile = _loc4_.file.nativePath;
         _loc5_.targetFile = _loc2_.nativePath;
         _loc5_.format = "sound";
         _loc5_.version = _loc4_.version;
         this._outChannel.send(_loc5_);
      }
      
      private function createWorker() : void
      {
         this._worker = WorkerDomain.current.createWorker(Workers.fairygui_editor_cache_CacheWorker,true);
         this._outChannel = Worker.current.createMessageChannel(this._worker);
         this._inChannel = this._worker.createMessageChannel(Worker.current);
         this._inChannel.addEventListener("channelMessage",this.__channelMessage);
         this._worker.setSharedProperty("outChannel",this._outChannel);
         this._worker.setSharedProperty("inChannel",this._inChannel);
         this._worker.setSharedProperty("applicationDirectory",File.applicationDirectory.nativePath);
         this._worker.start();
      }
      
      private function __imageLoaded(param1:LoaderExt) : void
      {
         var _loc4_:Object = param1.props;
         var _loc2_:EPackageItem = _loc4_.pi;
         var _loc3_:Object = param1.content;
         if(_loc3_ is Bitmap)
         {
            _loc2_.dataVersion = _loc4_.version;
            _loc2_.data = _loc3_.bitmapData;
         }
         else
         {
            _loc2_.data = null;
            _loc2_.imageInfo.file = null;
         }
         _loc2_.invokeCallbacks();
      }
      
      private function __channelMessage(param1:Event) : void
      {
         var _loc4_:CacheMessage = null;
         var _loc2_:EUIPackage = null;
         var _loc3_:EPackageItem = null;
         while(this._inChannel.messageAvailable)
         {
            _loc4_ = this._inChannel.receive();
            _loc2_ = this._project.getPackage(_loc4_.pkgId);
            if(_loc2_)
            {
               _loc3_ = _loc2_.getItem(_loc4_.itemId);
               if(_loc3_)
               {
                  _loc3_.generatingCache = false;
                  if(_loc4_.error != null)
                  {
                     _loc3_.invokeCallbacks();
                  }
                  else if(_loc3_.type == "sound")
                  {
                     _loc3_.data = new Sound(new URLRequest(new File(_loc4_.targetFile).url));
                     _loc3_.invokeCallbacks();
                  }
                  else
                  {
                     _loc3_.imageInfo.file = new File(_loc4_.targetFile);
                     if(_loc3_.imageInfo.loadingToMemory)
                     {
                        EasyLoader.load(_loc3_.imageInfo.file.url,{
                           "pi":_loc3_,
                           "type":"image",
                           "version":_loc4_.version
                        },this.__imageLoaded);
                     }
                     else
                     {
                        _loc3_.invokeCallbacks();
                     }
                  }
               }
            }
         }
      }
   }
}
