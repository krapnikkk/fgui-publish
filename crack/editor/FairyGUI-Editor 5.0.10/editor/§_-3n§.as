package fairygui.editor
{
   import fairygui.editor.api.IEditor;
   import fairygui.editor.settings.Preferences;
   import fairygui.editor.settings.§_-D§;
   import fairygui.utils.RuntimeErrorUtil;
   import fairygui.utils.UtilsFile;
   import fairygui.utils.UtilsStr;
   import fairygui.utils.ZipReader;
   import fairygui.utils.loader.Downloader;
   import flash.desktop.NativeApplication;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.filesystem.File;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   
   public class §_-3n§
   {
      
      public static var newVersionPrompt:Boolean;
      
      public static var §_-l§:Object;
      
      private static var iLoader:URLLoader;
      
      private static var §_-J8§:Boolean;
      
      private static var §_-78§:§_-1L§;
      
      private static var §_-Hf§:Downloader;
      
      public static const §_-2i§:String = "https://jk.fairygui.com/version/check/index.php";
       
      
      public function §_-3n§()
      {
         super();
      }
      
      public static function start(param1:IEditor = null) : void
      {
         if(§_-J8§)
         {
            return;
         }
         §_-78§ = §_-1L§(param1);
         §_-J8§ = true;
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.ver = Consts.versionCode;
         _loc2_.build = Consts.build;
         _loc2_.type = Capabilities.os.toLowerCase().indexOf("mac") != -1?"mac":"win";
         _loc2_.lang = Consts.language;
         _loc2_.id = §_-D§.clientId;
         if(§_-D§.§_-F3§)
         {
            _loc2_.key = §_-D§.§_-F3§;
         }
         iLoader = new URLLoader();
         iLoader.addEventListener(Event.COMPLETE,§_-2L§);
         iLoader.addEventListener(IOErrorEvent.IO_ERROR,§_-6§);
         var _loc3_:URLRequest = new URLRequest();
         _loc3_.url = §_-2i§;
         _loc3_.method = URLRequestMethod.GET;
         _loc3_.data = _loc2_;
         iLoader.load(_loc3_);
      }
      
      public static function cancel() : void
      {
         cleanup();
      }
      
      private static function success(param1:String) : void
      {
         var result:Object = null;
         var data:String = param1;
         cleanup();
         if(!data)
         {
            §_-I§(null);
            return;
         }
         try
         {
            result = JSON.parse(data);
         }
         catch(err:*)
         {
            result = {};
            result.code = 10001;
            result.msg = RuntimeErrorUtil.toString(err);
         }
         if(result.code == 999)
         {
            NativeApplication.nativeApplication.exit();
            return;
         }
         if(result.code || !result.url)
         {
            return;
         }
         §_-I§(result);
      }
      
      private static function failed(param1:String) : void
      {
         cleanup();
      }
      
      private static function cleanup() : void
      {
         try
         {
            iLoader.close();
         }
         catch(e:*)
         {
         }
         iLoader = null;
         §_-J8§ = false;
      }
      
      private static function §_-2L§(param1:Event) : void
      {
         var _loc2_:Object = param1.currentTarget;
         if(_loc2_ != iLoader)
         {
            return;
         }
         success(_loc2_.data);
      }
      
      private static function §_-6§(param1:IOErrorEvent) : void
      {
         var _loc2_:Object = param1.currentTarget;
         if(_loc2_ != iLoader)
         {
            return;
         }
         failed(param1.text);
      }
      
      private static function §_-I§(param1:Object) : void
      {
         if(param1 == null)
         {
            if(§_-78§)
            {
               §_-78§.mainView.§_-5M§();
            }
            return;
         }
         if(!§_-78§ && Preferences.checkNewVersion == "disabled")
         {
            return;
         }
         §_-l§ = param1;
         var _loc2_:File = new File(new File(File.applicationStorageDirectory.url).nativePath).resolvePath("upgrade");
         if(!_loc2_.exists)
         {
            _loc2_.createDirectory();
         }
         var _loc3_:File = _loc2_.resolvePath(UtilsStr.getFileFullName(§_-l§.url));
         if(_loc3_.exists && _loc3_.size == §_-l§.size)
         {
            §_-Jt§(_loc3_.nativePath);
            return;
         }
         if(§_-Hf§ && §_-Hf§.running)
         {
            return;
         }
         §_-Hf§ = new Downloader();
         §_-Hf§.addEventListener(Event.COMPLETE,§_-4N§);
         §_-Hf§.addEventListener(IOErrorEvent.IO_ERROR,§_-i§);
         §_-Hf§.download(§_-l§.url,_loc3_.nativePath,3,false);
      }
      
      public static function §_-3q§(param1:§_-1L§) : void
      {
         var zipFile:File = null;
         var ba:ByteArray = null;
         var zip:ZipReader = null;
         var appFolder:File = null;
         var entry:Object = null;
         var file:File = null;
         var folder:File = null;
         var initiator:§_-1L§ = param1;
         try
         {
            zipFile = new File(§_-l§.filePath);
            ba = UtilsFile.loadBytes(zipFile);
            zip = new ZipReader(ba);
            appFolder = new File(new File(File.applicationDirectory.url).nativePath);
            for each(entry in zip.entries)
            {
               file = appFolder.resolvePath(entry.name);
               folder = file.parent;
               if(!folder.exists)
               {
                  folder.createDirectory();
               }
               UtilsFile.saveBytes(file,zip.getEntryData(entry.name));
            }
            UtilsFile.deleteFile(zipFile);
            if(initiator)
            {
               initiator.mainView.§_-Ib§();
            }
            return;
         }
         catch(err:Error)
         {
            return;
         }
      }
      
      private static function §_-4N§(param1:String) : void
      {
         var _loc2_:File = new File(§_-Hf§.filePath);
         if(_loc2_.size != §_-l§.size)
         {
            return;
         }
         §_-Jt§(§_-Hf§.filePath);
      }
      
      private static function §_-Jt§(param1:String) : void
      {
         §_-l§.filePath = param1;
         if(Preferences.checkNewVersion == "auto")
         {
            §_-3q§(null);
            return;
         }
         if(FairyGUIEditor.§_-8Y§.length > 0)
         {
            FairyGUIEditor.§_-8Y§[0].mainView.§_-8t§();
         }
         else
         {
            newVersionPrompt = true;
         }
      }
      
      private static function §_-i§(param1:IOErrorEvent) : void
      {
      }
   }
}
