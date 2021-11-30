package fairygui.editor.plugin
{
   import fairygui.GRoot;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.loader.EasyLoader;
   import fairygui.editor.loader.LoaderExt;
   import fairygui.editor.utils.BulkTasks;
   import fairygui.utils.ZipReader;
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   
   public class PlugInManager implements IFairyGUIEditor
   {
      
      public static var FYOUT1:Number = 1;
      
      public static var FYOUT:Number = 1;
      
      public static var FYOUT_Ext:Number = 1;
      
      public static var COMPRESS:Boolean = false;
      
      public static var ISBINARY:Boolean = true;
      
      public static var RES_SIZE:int = 1024;
      
      public static var EX1024:Boolean = true;
      
      public static var TuextureCount:Number = 16;
       
      
      public var editorWindow:EditorWindow;
      
      public var allPlugins:Vector.<PlugInInfo>;
      
      public var publishHandlers:Vector.<IPublishHandler>;
      
      public var comExtensions:Object;
      
      public var comExtensionIDs:Array;
      
      public var comExtensionNames:Array;
      
      private var _loadTasks:BulkTasks;
      
      public var eventExtensionIDs:Array;
      
      public var eventExtensionNames:Array;
      
      public var eventExtensionTyps:Array;
      
      public function PlugInManager(param1:EditorWindow)
      {
         super();
         this.editorWindow = param1;
         this.allPlugins = new Vector.<PlugInInfo>();
         this.publishHandlers = new Vector.<IPublishHandler>();
         this.comExtensions = {};
         this.eventExtensionIDs = [];
         this.eventExtensionNames = [];
         this.eventExtensionTyps = [];
         this.comExtensionIDs = ["","Button","Label","ProgressBar","ScrollBar","Slider","ComboBox"];
         this.comExtensionNames = [Consts.g.text139,Consts.g.text140,Consts.g.text141,Consts.g.text142,Consts.g.text143,Consts.g.text144,Consts.g.text145];
      }
      
      public static function get fileNameEtx() : String
      {
         return "_" + (PlugInManager.FYOUT_Ext == -1?PlugInManager.FYOUT:PlugInManager.FYOUT_Ext);
      }
      
      public static function ceil(param1:Number) : Number
      {
         return param1;
      }
      
      public static function ceil_fy(param1:Number) : Number
      {
         return Math.ceil(param1);
      }
      
      public static function floor_fy(param1:Number) : Number
      {
         return Math.floor(param1);
      }
      
      public static function scaseXY(param1:String) : String
      {
         var _loc2_:Array = param1.split(",");
         var _loc3_:String = PlugInManager.FYOUT * int(_loc2_[0]) + "," + PlugInManager.FYOUT * int(_loc2_[1]);
         return _loc3_;
      }
      
      public function get project() : IEditorUIProject
      {
         return this.editorWindow.project;
      }
      
      public function getPackage(param1:String) : IEditorUIPackage
      {
         return this.editorWindow.project.getPackageByName(param1);
      }
      
      public function get language() : String
      {
         return ClassEditor.language;
      }
      
      public function get groot() : GRoot
      {
         return this.editorWindow.groot;
      }
      
      public function get menuBar() : IMenuBar
      {
         return this.editorWindow.mainPanel.menuBar;
      }
      
      public function alert(param1:String) : void
      {
         this.editorWindow.alert(param1);
      }
      
      public function registerPublishHandler(param1:IPublishHandler) : void
      {
         this.publishHandlers.push(param1);
      }
      
      public function registerComponentExtension(param1:String, param2:String, param3:String) : void
      {
         var _loc4_:String = null;
         if(this.comExtensions[param2])
         {
            this.editorWindow.alert("Component extension \'" + param2 + "\' already exists!");
            return;
         }
         if(param3 != null)
         {
            _loc4_ = param3.substr(1);
         }
         else
         {
            _loc4_ = null;
         }
         if(_loc4_ != null && this.comExtensionIDs.indexOf(_loc4_) == -1)
         {
            this.editorWindow.alert("Component extension \'" + param3 + "\' does not exist!");
            return;
         }
         this.comExtensions[param2] = {
            "name":param1,
            "className":param2,
            "superClassName":_loc4_
         };
         this.comExtensionIDs.push(param2);
         this.comExtensionNames.push(param1);
      }
      
      public function registerEventExtension(param1:String, param2:String, param3:String = "Nomal") : void
      {
         this.eventExtensionIDs.push(param1);
         this.eventExtensionNames.push(param2);
         this.eventExtensionTyps.push(param3);
      }
      
      public function load(param1:Function = null) : void
      {
         param1 = param1;
         var file:File = null;
         var pluginFolder:File = null;
         var callback:Function = param1;
         this.reset();
         this.registerEventExtension("EventsGlobal.Run_FY_JS","EventsGlobal.Run_FY_JS");
         this.registerEventExtension("EventsGlobal.HTTP_SEND_DATA","EventsGlobal.HTTP_SEND_DATA");
         this.registerEventExtension("ClassEvent.Drag_SELECT","ClassEvent.Drag_SELECT");
         this.registerEventExtension("ClassEvent.SelectAnwser","ClassEvent.SelectAnwser");
         this.registerEventExtension("ClassEvent.ChooseAnser","ClassEvent.ChooseAnser");
         this.registerEventExtension("ClassEvent.LuckyRawStart","ClassEvent.LuckyRawStart");
         try
         {
            pluginFolder = new File(new File("app:/plugins").nativePath);
            if(!pluginFolder.exists)
            {
               pluginFolder.createDirectory();
            }
         }
         catch(e:Error)
         {
            if(callback != null)
            {
               callback();
            }
            return;
         }
         var files:Array = pluginFolder.getDirectoryListing();
         var task:Function = function():void
         {
            var _loc2_:File = File(_loadTasks.taskData);
            var _loc1_:URLLoader = new URLLoader();
            _loc1_.addEventListener("complete",__loadXmlCompleted);
            _loc1_.load(new URLRequest(_loc2_.url));
         };
         this._loadTasks = new BulkTasks(5);
         var _loc6_:int = 0;
         var _loc5_:* = files;
         for each(file in files)
         {
            if(!(file.isDirectory || file.extension.toLowerCase() != "xml"))
            {
               this._loadTasks.addTask(task,file);
            }
         }
         this._loadTasks.start(callback);
      }
      
      private function reset() : void
      {
         var _loc1_:PlugInInfo = null;
         var _loc5_:int = 0;
         var _loc4_:* = this.allPlugins;
         for each(_loc1_ in this.allPlugins)
         {
            try
            {
               _loc1_.entry.dispose();
            }
            catch(err:Error)
            {
               continue;
            }
         }
         if(this.allPlugins.length > 0)
         {
            this.editorWindow.mainPanel.menuBar.clearAll();
            this.editorWindow.mainPanel.setupMenuBar();
         }
         this.allPlugins.length = 0;
         this.publishHandlers.length = 0;
         this.comExtensionIDs.length = 7;
         this.comExtensionNames.length = 7;
         this.comExtensions = {};
      }
      
      private function __loadXmlCompleted(param1:Event) : void
      {
         var _loc3_:* = null;
         var _loc5_:* = null;
         var _loc7_:* = null;
         var _loc2_:* = null;
         var _loc4_:* = null;
         URLLoader(param1.target).removeEventListener("complete",__loadXmlCompleted);
         var _loc8_:XML = new XML(URLLoader(param1.target).data);
         if(_loc8_.@type && _loc8_.@type == "fyEvent")
         {
            var _loc10_:int = 0;
            var _loc9_:* = _loc8_.node;
            for each(var _loc6_ in _loc8_.node)
            {
               _loc3_ = String(_loc6_.@eventTitle);
               _loc5_ = String(_loc6_.@eventName);
               _loc7_ = String(_loc6_.@eventType);
               this.registerEventExtension(_loc3_,_loc5_,_loc7_);
            }
         }
         else
         {
            var _loc12_:int = 0;
            var _loc11_:* = _loc8_.node;
            for each(_loc6_ in _loc8_.node)
            {
               _loc2_ = String(_loc6_.@classTitle);
               _loc4_ = String(_loc6_.@className);
               this.registerComponentExtension(_loc2_,_loc4_,null);
            }
         }
      }
      
      private function __loadSwcCompleted(param1:LoaderExt) : void
      {
         if(!param1.content)
         {
            this._loadTasks.finishItem();
            return;
         }
         var _loc4_:ZipReader = new ZipReader(param1.content);
         var _loc2_:ByteArray = _loc4_.getEntryData("library.swf");
         var _loc3_:LoaderContext = new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain));
         _loc3_.allowCodeImport = true;
         _loc3_.allowLoadBytesCodeExecution = true;
         EasyLoader.load("",{
            "rawContent":_loc2_,
            "context":_loc3_,
            "name":param1.props.name
         },this.__decodeSwcCompleted);
      }
      
      private function __decodeSwcCompleted(param1:LoaderExt) : void
      {
         var _loc4_:String = null;
         var _loc6_:* = null;
         var _loc8_:int = 0;
         var _loc7_:PlugInInfo = null;
         var _loc5_:* = param1;
         this._loadTasks.finishItem();
         if(!_loc5_.content)
         {
            return;
         }
         var _loc3_:Object = null;
         var _loc2_:Vector.<String> = _loc5_.applicationDomain.getQualifiedDefinitionNames();
         var _loc10_:int = 0;
         for each(_loc4_ in _loc2_)
         {
            _loc8_ = _loc4_.indexOf("::");
            if(_loc8_ == -1)
            {
               _loc6_ = _loc4_;
            }
            else
            {
               _loc6_ = _loc4_.substr(_loc8_ + 2);
            }
            if(_loc6_ == "PlugInMain")
            {
               _loc3_ = _loc5_.applicationDomain.getDefinition(_loc4_);
            }
         }
         if(!_loc3_)
         {
            return;
         }
         try
         {
            _loc7_ = new PlugInInfo();
            _loc7_.name = _loc5_.props.name;
            _loc7_.entry = new _loc3_(this);
            this.allPlugins.push(_loc7_);
            return;
         }
         catch(err:Error)
         {
            return;
         }
      }
   }
}
