package fairygui.editor.plugin
{
   import fairygui.editor.Consts;
   import fairygui.editor.api.IEditor;
   import fairygui.utils.BulkTasks;
   import fairygui.utils.ZipReader;
   import fairygui.utils.loader.EasyLoader;
   import fairygui.utils.loader.LoaderExt;
   import flash.filesystem.File;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   
   public class PlugInManager
   {
       
      
      public var allPlugins:Vector.<PlugInInfo>;
      
      private var _editor:IEditor;
      
      private var _proxy:LegacyPlugInProxy;
      
      private var _loadTasks:BulkTasks;
      
      private var _pluginFolder:File;
      
      public function PlugInManager(param1:IEditor)
      {
         super();
         this._editor = param1;
         this.allPlugins = new Vector.<PlugInInfo>();
      }
      
      public function dispose() : void
      {
         this._editor = null;
      }
      
      public function get legacyProxy() : LegacyPlugInProxy
      {
         return this._proxy;
      }
      
      public function get pluginFolder() : File
      {
         return this._pluginFolder;
      }
      
      public function load(param1:Function = null) : void
      {
         var file:File = null;
         var callback:Function = param1;
         this.reset();
         this._proxy = new LegacyPlugInProxy(this._editor);
         try
         {
            this._pluginFolder = new File(new File("app:/plugins").nativePath);
            if(!Consts.isMacOS)
            {
               if(!this._pluginFolder.exists)
               {
                  this._pluginFolder.createDirectory();
               }
            }
            else if(!this._pluginFolder.exists)
            {
               if(callback != null)
               {
                  callback();
               }
               return;
            }
         }
         catch(err:Error)
         {
            _editor.consoleView.logError(null,err);
            if(callback != null)
            {
               callback();
            }
            return;
         }
         var files:Array = this.pluginFolder.getDirectoryListing();
         var task:Function = function():void
         {
            var _loc1_:File = File(_loadTasks.taskData);
            EasyLoader.load(_loc1_.url,{"name":_loc1_.name},__loadSwcCompleted);
         };
         this._loadTasks = new BulkTasks(5);
         for each(file in files)
         {
            if(!(file.isDirectory || file.extension.toLowerCase() != "swc"))
            {
               this._loadTasks.addTask(task,file);
            }
         }
         this._loadTasks.start(callback);
      }
      
      private function reset() : void
      {
         var plugin:PlugInInfo = null;
         for each(plugin in this.allPlugins)
         {
            try
            {
               plugin.entry.dispose();
            }
            catch(err:Error)
            {
               continue;
            }
         }
         this.allPlugins.length = 0;
         if(this._proxy)
         {
            this._proxy.dispose();
            this._proxy = null;
         }
      }
      
      private function __loadSwcCompleted(param1:LoaderExt) : void
      {
         if(!this._editor)
         {
            return;
         }
         if(!param1.content)
         {
            this._loadTasks.finishItem();
            return;
         }
         var _loc2_:ZipReader = new ZipReader(param1.content);
         var _loc3_:ByteArray = _loc2_.getEntryData("library.swf");
         var _loc4_:LoaderContext = new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain));
         _loc4_.allowCodeImport = true;
         _loc4_.allowLoadBytesCodeExecution = true;
         EasyLoader.load("",{
            "rawContent":_loc3_,
            "context":_loc4_,
            "name":param1.props.name
         },this.__decodeSwcCompleted);
      }
      
      private function __decodeSwcCompleted(param1:LoaderExt) : void
      {
         var name:String = null;
         var clsName:String = null;
         var pos:int = 0;
         var info:PlugInInfo = null;
         var l:LoaderExt = param1;
         if(!this._editor)
         {
            return;
         }
         this._loadTasks.finishItem();
         if(!l.content)
         {
            return;
         }
         var mainClass:Object = null;
         var names:Vector.<String> = l.applicationDomain.getQualifiedDefinitionNames();
         for each(name in names)
         {
            pos = name.indexOf("::");
            if(pos == -1)
            {
               clsName = name;
            }
            else
            {
               clsName = name.substr(pos + 2);
            }
            if(clsName == "PlugInMain")
            {
               mainClass = l.applicationDomain.getDefinition(name);
            }
         }
         if(!mainClass)
         {
            return;
         }
         try
         {
            info = new PlugInInfo();
            info.name = l.props.name;
            info.entry = new mainClass(this._proxy);
            this.allPlugins.push(info);
            return;
         }
         catch(err:Error)
         {
            _editor.alert(null,err);
            return;
         }
      }
   }
}
