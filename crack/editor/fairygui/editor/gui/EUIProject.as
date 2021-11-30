package fairygui.editor.gui
{
   import com.adobe.crypto.MD5;
   import fairygui.editor.ComDocument;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.handlers.ProjectRefreshHandler;
   import fairygui.editor.pack.BinPackManager;
   import fairygui.editor.plugin.IEditorUIProject;
   import fairygui.editor.plugin.PlugInManager;
   import fairygui.editor.settings.SettingsCenter;
   import fairygui.editor.utils.Utils;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   import flash.filesystem.File;
   import flash.system.Capabilities;
   
   public class EUIProject implements IEditorUIProject
   {
      
      public static var devCode:String;
      
      public static const TYPE_FLASH:String = "Flash";
      
      public static const TYPE_STARLING:String = "Starling";
      
      public static const TYPE_UNITY:String = "Unity";
      
      public static const TYPE_EGRET:String = "Egret";
      
      public static const TYPE_LAYABOX:String = "Layabox";
      
      public static const TYPE_HAXE:String = "Haxe";
      
      public static const TYPE_PIXI:String = "Pixi";
      
      public static const FILE_EXT:String = "fairy";
      
      public static const ASSETS_PATH:String = "assets";
      
      public static const SETTINGS_PATH:String = "settings";
      
      public static const OBJS_PATH:String = ".objs";
       
      
      public var settingsCenter:SettingsCenter;
      
      public var version:String;
      
      public var globalFontVersion:uint;
      
      private var _id:String;
      
      private var _name:String;
      
      private var _basePath:String;
      
      private var _assetsPath:String;
      
      private var _objsPath:String;
      
      private var _settingsPath:String;
      
      private var _packages:Array;
      
      private var _packageInsts:Object;
      
      private var _type:String;
      
      private var _opened:Boolean;
      
      private var _pkgCount:int;
      
      private var _refreshHandler:ProjectRefreshHandler;
      
      private var _editorWindow:EditorWindow;
      
      public var refreshRunnning:Boolean;
      
      public var binPackManager1:BinPackManager;
      
      public var plugInManager1:PlugInManager;
      
      public function EUIProject(param1:EditorWindow)
      {
         binPackManager1 = new BinPackManager(null);
         plugInManager1 = new PlugInManager(null);
         super();
         this._editorWindow = param1;
         this._packages = [];
         this._packageInsts = {};
         devCode = Utils.genDevCode();
         this._refreshHandler = new ProjectRefreshHandler(this);
         this.settingsCenter = new SettingsCenter(this);
      }
      
      public static function createNew(param1:String, param2:String, param3:String, param4:String = null) : void
      {
         var _loc5_:XML = null;
         var _loc6_:File = null;
         var _loc7_:String = null;
         param2 = UtilsStr.validateName(param2);
         _loc5_ = <projectDescription/>;
         _loc5_.@id = MD5.hash(param1 + new Date().time + Math.random() * 10000 + param2 + Capabilities.serverString);
         _loc5_.@type = param3;
         _loc5_.@version = "3.1";
         UtilsFile.saveXML(new File(param1 + File.separator + param2 + "." + "fairy"),_loc5_);
         _loc6_ = new File(param1 + File.separator + "assets");
         _loc6_.createDirectory();
         _loc6_ = new File(param1 + File.separator + ".objs");
         _loc6_.createDirectory();
         _loc6_ = new File(param1 + File.separator + "settings");
         _loc6_.createDirectory();
         if(param4)
         {
            _loc7_ = UtilsStr.generateUID();
            param4 = param4;
            _loc6_ = new File(param1 + File.separator + "assets" + File.separator + param4);
            _loc6_.createDirectory();
            _loc5_ = <packageDescription><resources/></packageDescription>;
            _loc5_.@id = _loc7_;
            UtilsFile.saveXML(new File(_loc6_.nativePath + File.separator + "package.xml"),_loc5_);
         }
      }
      
      private static function comparePackage(param1:EUIPackage, param2:EUIPackage) : int
      {
         return param1.rootItem.sortKey.localeCompare(param2.rootItem.sortKey);
      }
      
      private static function compareItem(param1:EPackageItem, param2:EPackageItem) : int
      {
         return param1.sortKey.localeCompare(param2.sortKey);
      }
      
      public function get editorWindow() : EditorWindow
      {
         return this._editorWindow;
      }
      
      public function get opened() : Boolean
      {
         return this._opened;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function set type(param1:String) : void
      {
         this._type = param1;
      }
      
      public function get usingAtlas() : Boolean
      {
         return this._type != "Flash" && this._type != "Haxe";
      }
      
      public function get isH5() : Boolean
      {
         return this._type == "Egret" || this._type == "Layabox" || this._type == "Pixi";
      }
      
      public function get basePath() : String
      {
         return this._basePath;
      }
      
      public function get customProperties() : Object
      {
         return this.settingsCenter.customProps.all;
      }
      
      public function get assetsPath() : String
      {
         return this._assetsPath;
      }
      
      public function get objsPath() : String
      {
         return this._objsPath;
      }
      
      public function get settingsPath() : String
      {
         return this._settingsPath;
      }
      
      public function open(param1:File) : void
      {
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         var _loc2_:String = null;
         var _loc5_:* = param1;
         this._opened = true;
         this._basePath = _loc5_.parent.nativePath;
         XML.ignoreWhitespace = true;
         try
         {
            _loc3_ = new XML(UtilsFile.loadString(_loc5_));
         }
         catch(err:Error)
         {
            throw new Error(_loc5_.name + " is corrupted, please check!");
         }
         this._id = _loc3_.@id;
         this._type = _loc3_.@type;
         if(!this._type)
         {
            this._type = "Unity";
         }
         this._name = UtilsStr.getFileName(_loc5_.name);
         this.version = _loc3_.@version;
         this._assetsPath = this._basePath + File.separator + "assets";
         this._objsPath = this._basePath + File.separator + ".objs";
         this._settingsPath = this._basePath + File.separator + "settings";
         this.listAllPackages();
         this.settingsCenter.loadAll();
      }
      
      private function listAllPackages() : void
      {
         var _loc3_:File = null;
         var _loc1_:File = null;
         this._packages = [];
         this._packageInsts = {};
         var _loc5_:Array = new File(this.assetsPath).getDirectoryListing();
         var _loc4_:int = _loc5_.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = _loc5_[_loc2_];
            if(_loc3_.isDirectory && !_loc3_.isHidden)
            {
               _loc1_ = new File(_loc3_.nativePath + File.separator + "package.xml");
               if(_loc1_.exists)
               {
                  this.addPackage(_loc3_);
               }
            }
            _loc2_++;
         }
      }
      
      public function close() : void
      {
         var _loc1_:EUIPackage = null;
         var _loc3_:int = 0;
         var _loc2_:* = this._packageInsts;
         for each(_loc1_ in this._packageInsts)
         {
            _loc1_.close();
         }
         this._opened = false;
      }
      
      public function rename(param1:String) : void
      {
         var _loc2_:File = new File(this._basePath + File.separator + this._name + ".fairy");
         this._name = param1;
         _loc2_.moveTo(new File(this._basePath + File.separator + this._name + ".fairy"));
      }
      
      public function getPackage(param1:String) : EUIPackage
      {
         return this._packageInsts[param1];
      }
      
      public function getPackageByName(param1:String) : EUIPackage
      {
         var _loc2_:EUIPackage = null;
         var _loc4_:int = 0;
         var _loc3_:* = this._packageInsts;
         for each(_loc2_ in this._packageInsts)
         {
            if(ClassEditor.os_mac && _loc2_.name == param1 || !ClassEditor.os_mac && _loc2_.name.toLowerCase() == param1.toLowerCase())
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function createPackage(param1:String) : EUIPackage
      {
         param1 = UtilsStr.validateName(param1);
         if(this.getPackageByName(param1) != null)
         {
            throw new Error("Package already exists!");
         }
         var _loc5_:String = UtilsStr.generateUID();
         var _loc3_:File = new File(this.assetsPath + File.separator + param1);
         _loc3_.createDirectory();
         var _loc4_:XML = <packageDescription><resources/></packageDescription>;
         _loc4_.@id = _loc5_;
         UtilsFile.saveXML(new File(_loc3_.nativePath + File.separator + "package.xml"),_loc4_);
         var _loc2_:EUIPackage = new EUIPackage(this,param1);
         this._packageInsts[_loc5_] = _loc2_;
         this._pkgCount++;
         _loc2_.open();
         return _loc2_;
      }
      
      public function addPackage(param1:File) : EUIPackage
      {
         var _loc3_:EUIPackage = new EUIPackage(this,param1.name);
         var _loc2_:EUIPackage = this._packageInsts[_loc3_.id];
         if(_loc2_ != null)
         {
            return _loc2_;
         }
         this._packageInsts[_loc3_.id] = _loc3_;
         this._pkgCount++;
         return _loc3_;
      }
      
      public function deletePackage(param1:String) : void
      {
         var _loc4_:Vector.<ComDocument> = null;
         var _loc2_:ComDocument = null;
         var _loc5_:EUIPackage = this._packageInsts[param1];
         if(!_loc5_)
         {
            return;
         }
         if(this._editorWindow)
         {
            _loc4_ = this._editorWindow.mainPanel.editPanel.findComDocuments(_loc5_);
            var _loc7_:int = 0;
            var _loc6_:* = _loc4_;
            for each(_loc2_ in _loc4_)
            {
               this._editorWindow.mainPanel.editPanel.closeDocument(_loc2_);
            }
         }
         _loc5_.close();
         var _loc3_:File = new File(this.assetsPath + File.separator + _loc5_.name);
         if(_loc3_.exists)
         {
            _loc3_.moveToTrash();
         }
         _loc3_ = new File(this.objsPath + File.separator + "cache" + File.separator + _loc5_.id);
         if(_loc3_.exists)
         {
            try
            {
               _loc3_.deleteDirectory(true);
            }
            catch(err:Error)
            {
            }
         }
         this._pkgCount--;
         delete this._packageInsts[param1];
         if(this._editorWindow)
         {
            this._editorWindow.mainPanel.libPanel.pkgsPanel.notifyRootChanged();
         }
      }
      
      public function getPackageList() : Vector.<EUIPackage>
      {
         var _loc1_:EUIPackage = null;
         var _loc2_:Vector.<EUIPackage> = new Vector.<EUIPackage>();
         var _loc4_:int = 0;
         var _loc3_:* = this._packageInsts;
         for each(_loc1_ in this._packageInsts)
         {
            _loc2_.push(_loc1_);
         }
         _loc2_.sort(comparePackage);
         return _loc2_;
      }
      
      public function getPackageListChoosePackges() : Vector.<EUIPackage>
      {
         var _loc1_:EUIPackage = null;
         var _loc2_:Vector.<EUIPackage> = new Vector.<EUIPackage>();
         var _loc4_:int = 0;
         var _loc3_:* = this._packageInsts;
         for each(_loc1_ in this._packageInsts)
         {
            if(this.settingsCenter.workspace.hidden_packages.indexOf(_loc1_.id) == -1)
            {
               _loc2_.push(_loc1_);
            }
         }
         _loc2_.sort(comparePackage);
         return _loc2_;
      }
      
      public function getPackageRootItems(param1:Vector.<EPackageItem>, param2:Boolean = false) : Vector.<EPackageItem>
      {
         var _loc3_:EUIPackage = null;
         if(param1 == null)
         {
            param1 = new Vector.<EPackageItem>();
         }
         var _loc5_:int = 0;
         var _loc4_:* = this._packageInsts;
         for each(_loc3_ in this._packageInsts)
         {
            if(this.settingsCenter.workspace.hidden_packages.indexOf(_loc3_.id) == -1 && (!param2 || _loc3_.rootItem.favorite))
            {
               param1.push(_loc3_.rootItem);
            }
         }
         param1.sort(compareItem);
         return param1;
      }
      
      public function get packageCount() : int
      {
         return this._pkgCount;
      }
      
      public function reload() : void
      {
         var _loc1_:EUIPackage = null;
         this.settingsCenter.loadAll();
         var _loc3_:int = 0;
         var _loc2_:* = this._packageInsts;
         for each(_loc1_ in this._packageInsts)
         {
            _loc1_.reload();
         }
      }
      
      public function save() : void
      {
         var _loc1_:XML = <projectDescription/>;
         _loc1_.@id = this._id;
         _loc1_.@type = this._type;
         _loc1_.@version = this.version;
         UtilsFile.saveXML(new File(this._basePath + File.separator + this._name + ".fairy"),_loc1_);
      }
      
      public function getItemByURL(param1:String) : EPackageItem
      {
         var _loc7_:String = null;
         var _loc2_:EUIPackage = null;
         var _loc3_:String = null;
         var _loc5_:String = null;
         var _loc4_:String = null;
         if(param1 == null)
         {
            return null;
         }
         var _loc8_:int = param1.indexOf("//");
         if(_loc8_ == -1)
         {
            return null;
         }
         var _loc6_:int = param1.indexOf("/",_loc8_ + 2);
         if(_loc6_ == -1)
         {
            if(param1.length > 13)
            {
               _loc7_ = param1.substr(5,8);
               _loc2_ = this.getPackage(_loc7_);
               if(_loc2_ != null)
               {
                  _loc3_ = param1.substr(13);
                  return _loc2_.getItem(_loc3_);
               }
            }
         }
         else
         {
            _loc5_ = param1.substr(_loc8_ + 2,_loc6_ - _loc8_ - 2);
            _loc2_ = this.getPackageByName(_loc5_);
            if(_loc2_ != null)
            {
               _loc4_ = param1.substr(_loc6_ + 1);
               return _loc2_.getItemByName(_loc4_);
            }
         }
         return null;
      }
      
      public function getItemByFile(param1:File) : EPackageItem
      {
         var _loc7_:* = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc2_:String = null;
         var _loc3_:EUIPackage = null;
         var _loc4_:EPackageItem = null;
         param1.canonicalize();
         if(UtilsStr.startsWith(param1.nativePath,this._assetsPath,true))
         {
            _loc7_ = param1.nativePath.substr(this._assetsPath.length);
            _loc5_ = UtilsStr.getFileFullName(_loc7_);
            _loc7_ = UtilsStr.getFilePath(_loc7_).replace(/\\/g,"/") + "/";
            _loc6_ = _loc7_.indexOf("/",1);
            if(_loc6_ != -1)
            {
               _loc2_ = _loc7_.substring(1,_loc6_);
               _loc3_ = this.getPackageByName(_loc2_);
               if(_loc3_)
               {
                  _loc4_ = _loc3_.getItem(_loc7_.substring(_loc6_));
                  if(_loc4_)
                  {
                     return _loc3_.getItemByFileName(_loc4_,_loc5_);
                  }
               }
            }
         }
         return null;
      }
      
      public function getItemNameByURL(param1:String) : String
      {
         var _loc2_:EPackageItem = this.getItemByURL(param1);
         if(_loc2_)
         {
            return _loc2_.name;
         }
         return "";
      }
      
      public function getItemName(param1:String, param2:String) : String
      {
         var _loc3_:EUIPackage = this.getPackage(param1);
         if(_loc3_)
         {
            return _loc3_.getItemName(param2);
         }
         return "";
      }
      
      public function refresh() : void
      {
         this._refreshHandler.run();
      }
   }
}
