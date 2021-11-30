package fairygui.editor.gui
{
   import com.adobe.crypto.MD5;
   import fairygui.editor.Consts;
   import fairygui.editor.api.EditorEvent;
   import fairygui.editor.api.IEditor;
   import fairygui.editor.api.IUIPackage;
   import fairygui.editor.api.IUIProject;
   import fairygui.editor.api.ProjectType;
   import fairygui.editor.settings.AdaptationSettings;
   import fairygui.editor.settings.CommonSettings;
   import fairygui.editor.settings.CustomProps;
   import fairygui.editor.settings.GlobalPublishSettings;
   import fairygui.editor.settings.I18nSettings;
   import fairygui.editor.settings.PackageGroupSettings;
   import fairygui.editor.settings.SettingsBase;
   import fairygui.editor.worker.WorkerClient;
   import fairygui.utils.Utils;
   import fairygui.utils.UtilsFile;
   import fairygui.utils.UtilsStr;
   import fairygui.utils.XData;
   import flash.filesystem.File;
   import flash.media.Sound;
   import flash.media.SoundTransform;
   import flash.system.Capabilities;
   
   public class FProject implements IUIProject
   {
      
      public static const FILE_EXT:String = "fairy";
      
      public static const ASSETS_PATH:String = "assets";
      
      public static const SETTINGS_PATH:String = "settings";
      
      public static const OBJS_PATH:String = ".objs";
       
      
      public var _comExtensions:Object;
      
      public var _globalFontVersion:uint;
      
      private var _id:String;
      
      private var _name:String;
      
      private var _basePath:String;
      
      private var _assetsPath:String;
      
      private var _objsPath:String;
      
      private var _settingsPath:String;
      
      private var _packages:Vector.<IUIPackage>;
      
      private var _packageInsts:Object;
      
      private var _type:String;
      
      private var _opened:Boolean;
      
      private var _allSettings:Object;
      
      private var _vars:Object;
      
      private var _branches:Vector.<String>;
      
      private var _activeBranch:String;
      
      private var _editor:IEditor;
      
      private var _versionCode:int;
      
      private var _serialNumberSeed:String;
      
      private var _lastChanged:int;
      
      var _listDirty:Boolean;
      
      public function FProject(param1:IEditor)
      {
         super();
         this._editor = param1;
         this._vars = {};
         this._packages = new Vector.<IUIPackage>();
         this._packageInsts = {};
         this._branches = new Vector.<String>();
         this._activeBranch = "";
         this._serialNumberSeed = Utils.genDevCode();
         this._lastChanged = 0;
         this._allSettings = {};
         this._allSettings["common"] = new CommonSettings(this);
         this._allSettings["publish"] = new GlobalPublishSettings(this);
         this._allSettings["customProps"] = new CustomProps(this);
         this._allSettings["adaptation"] = new AdaptationSettings(this);
         this._allSettings["packageGroups"] = new PackageGroupSettings(this);
         this._allSettings["i18n"] = new I18nSettings(this);
         this._comExtensions = {};
      }
      
      public static function createNew(param1:String, param2:String, param3:String, param4:String = null) : void
      {
         var _loc5_:XData = null;
         var _loc6_:File = null;
         var _loc7_:String = null;
         var _loc8_:* = null;
         param2 = validateName(param2);
         _loc5_ = XData.create("projectDescription");
         _loc5_.setAttribute("id",MD5.hash(param1 + new Date().time + Math.random() * 10000 + param2 + Capabilities.serverString));
         _loc5_.setAttribute("type",param3);
         _loc5_.setAttribute("version","5.0");
         UtilsFile.saveXData(new File(param1 + File.separator + param2 + "." + FILE_EXT),_loc5_);
         _loc6_ = new File(param1 + File.separator + ASSETS_PATH);
         _loc6_.createDirectory();
         _loc6_ = new File(param1 + File.separator + OBJS_PATH);
         _loc6_.createDirectory();
         _loc6_ = new File(param1 + File.separator + SETTINGS_PATH);
         _loc6_.createDirectory();
         if(param4)
         {
            _loc7_ = UtilsStr.generateUID();
            _loc6_ = new File(param1 + File.separator + ASSETS_PATH + File.separator + param4);
            _loc6_.createDirectory();
            _loc8_ = Utils.genDevCode() + "0";
            _loc5_ = XData.parse("<packageDescription>" + "\t<resources>" + "\t\t<component id=\"" + _loc8_ + "\" name=\"Component1.xml\" path=\"/\" exported=\"true\"/>" + "\t</resources>" + "</packageDescription>");
            _loc5_.setAttribute("id",_loc7_);
            UtilsFile.saveXData(new File(_loc6_.nativePath + File.separator + "package.xml"),_loc5_);
            _loc5_ = XData.create("component");
            _loc5_.setAttribute("size","800,600");
            UtilsFile.saveXData(_loc6_.resolvePath("Component1.xml"),_loc5_);
         }
      }
      
      private static function comparePackage(param1:FPackage, param2:FPackage) : int
      {
         return param1.rootItem.sortKey.localeCompare(param2.rootItem.sortKey);
      }
      
      private static function compareItem(param1:FPackageItem, param2:FPackageItem) : int
      {
         return param1.sortKey.localeCompare(param2.sortKey);
      }
      
      public static function validateName(param1:String) : String
      {
         param1 = UtilsStr.trim(param1);
         if(param1.length == 0)
         {
            throw new Error(Consts.strings.text197);
         }
         if(param1.search(/[\:\/\\\*\?<>\|]/) != -1)
         {
            throw new Error(Consts.strings.text196);
         }
         return param1;
      }
      
      public function get editor() : IEditor
      {
         return this._editor;
      }
      
      public function get versionCode() : int
      {
         return this._versionCode;
      }
      
      public function get serialNumberSeed() : String
      {
         return this._serialNumberSeed;
      }
      
      public function get lastChanged() : int
      {
         return this._lastChanged;
      }
      
      public function setChanged() : void
      {
         this._lastChanged++;
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
         if(this._type != param1)
         {
            this._type = param1;
            this._lastChanged++;
            this.loadAllSettings();
         }
      }
      
      public function get supportAtlas() : Boolean
      {
         return this._type != ProjectType.FLASH && this._type != ProjectType.HAXE;
      }
      
      public function get isH5() : Boolean
      {
         return this._type == ProjectType.EGRET || this._type == ProjectType.LAYABOX || this._type == ProjectType.PIXI || this._type == ProjectType.COCOSCREATOR;
      }
      
      public function get supportExtractAlpha() : Boolean
      {
         return this._type == ProjectType.UNITY || this._type == ProjectType.COCOS2DX;
      }
      
      public function get supportAlphaMask() : Boolean
      {
         return this.supportAtlas && this._type != ProjectType.EGRET && this._type != ProjectType.STARLING;
      }
      
      public function get zipFormatOption() : Boolean
      {
         return this._type == ProjectType.FLASH || this._type == ProjectType.STARLING || this._type == ProjectType.HAXE;
      }
      
      public function get binaryFormatOption() : Boolean
      {
         return this._type == ProjectType.UNITY || this._type == ProjectType.COCOS2DX || this._type == ProjectType.EGRET || this._type == ProjectType.LAYABOX || this._type == ProjectType.PIXI;
      }
      
      public function get supportCustomFileExtension() : Boolean
      {
         return this.isH5 || this.zipFormatOption;
      }
      
      public function get supportCodeType() : Boolean
      {
         return this._type == ProjectType.LAYABOX;
      }
      
      public function get basePath() : String
      {
         return this._basePath;
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
      
      public function get activeBranch() : String
      {
         return this._activeBranch;
      }
      
      public function set activeBranch(param1:String) : void
      {
         if(this._activeBranch != param1)
         {
            this._activeBranch = param1;
            this._lastChanged++;
         }
      }
      
      public function open(param1:File) : void
      {
         var xml:XData = null;
         var arr:Array = null;
         var projectDescFile:File = param1;
         this._opened = true;
         var projectFolder:File = projectDescFile.parent;
         projectFolder.canonicalize();
         this._basePath = projectFolder.nativePath;
         try
         {
            xml = UtilsFile.loadXData(projectDescFile);
         }
         catch(err:Error)
         {
            throw new Error(projectDescFile.name + " is corrupted, please check!");
         }
         this._id = xml.getAttribute("id");
         this._type = xml.getAttribute("type");
         if(!this._type)
         {
            this._type = ProjectType.UNITY;
         }
         this._name = UtilsStr.getFileName(projectDescFile.name);
         var str:String = xml.getAttribute("version");
         if(str)
         {
            arr = str.split(",");
            if(arr.length == 1)
            {
               this._versionCode = parseInt(arr[0]) * 100;
            }
            else
            {
               this._versionCode = parseInt(arr[0]) * 100 + parseInt(arr[1]);
            }
         }
         else
         {
            this._versionCode = 200;
         }
         var assetsFolder:File = projectFolder.resolvePath(ASSETS_PATH);
         if(!assetsFolder.exists)
         {
            assetsFolder.createDirectory();
         }
         this._assetsPath = assetsFolder.nativePath;
         this._objsPath = projectFolder.resolvePath(OBJS_PATH).nativePath;
         this._settingsPath = projectFolder.resolvePath(SETTINGS_PATH).nativePath;
         this.listAllPackages(assetsFolder);
         this.loadAllSettings();
         this.scanBranches();
      }
      
      public function scanBranches() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc7_:File = null;
         var _loc8_:String = null;
         var _loc2_:int = this._branches.length;
         var _loc3_:int = 0;
         var _loc4_:Array = [];
         while(_loc3_ < _loc2_)
         {
            if(!new File(this._basePath + "/assets_" + this._branches[_loc3_]).exists)
            {
               this._branches.splice(_loc3_,1);
               _loc2_--;
               _loc1_ = true;
            }
            else
            {
               _loc4_.push(this._branches[_loc3_]);
               _loc3_++;
            }
         }
         var _loc5_:File = new File(this._basePath);
         var _loc6_:Array = _loc5_.getDirectoryListing();
         for each(_loc7_ in _loc6_)
         {
            if(_loc7_.isDirectory && UtilsStr.startsWith(_loc7_.name,"assets_"))
            {
               _loc8_ = _loc7_.name.substring(7);
               if(_loc4_.indexOf(_loc8_) == -1)
               {
                  this._branches.push(_loc8_);
                  _loc1_ = true;
               }
            }
         }
         this._branches.sort(0);
         if(_loc1_)
         {
            this._lastChanged++;
         }
         return _loc1_;
      }
      
      private function listAllPackages(param1:File) : void
      {
         var _loc5_:File = null;
         var _loc6_:File = null;
         var _loc2_:Array = param1.getDirectoryListing();
         var _loc3_:int = _loc2_.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            if(_loc5_.isDirectory)
            {
               _loc6_ = new File(_loc5_.nativePath + File.separator + "package.xml");
               if(_loc6_.exists)
               {
                  this.addPackage(_loc5_);
               }
            }
            _loc4_++;
         }
      }
      
      public function close() : void
      {
         var _loc1_:FPackage = null;
         for each(_loc1_ in this._packageInsts)
         {
            _loc1_.dispose();
         }
         this._opened = false;
         this._editor = null;
         WorkerClient.inst.removeRequests(this);
      }
      
      public function getSettings(param1:String) : Object
      {
         var _loc2_:SettingsBase = this._allSettings[param1];
         _loc2_.touch();
         return _loc2_;
      }
      
      public function saveSettings(param1:String) : void
      {
         var _loc2_:SettingsBase = SettingsBase(this._allSettings[param1]);
         _loc2_.save();
      }
      
      public function getSetting(param1:String, param2:String) : *
      {
         return this._allSettings[param1][param2];
      }
      
      public function setSetting(param1:String, param2:String, param3:*) : void
      {
         this._allSettings[param1][param2] = param3;
      }
      
      public function loadAllSettings() : void
      {
         var _loc1_:SettingsBase = null;
         for each(_loc1_ in this._allSettings)
         {
            _loc1_.touch(true);
         }
      }
      
      public function rename(param1:String) : void
      {
         var _loc2_:File = new File(this._basePath + File.separator + this._name + ".fairy");
         this._name = param1;
         _loc2_.moveTo(new File(this._basePath + File.separator + this._name + ".fairy"));
      }
      
      public function getPackage(param1:String) : IUIPackage
      {
         return this._packageInsts[param1];
      }
      
      public function getPackageByName(param1:String) : IUIPackage
      {
         var _loc2_:FPackage = null;
         for each(_loc2_ in this._packageInsts)
         {
            if(Consts.isMacOS && _loc2_.name == param1 || !Consts.isMacOS && _loc2_.name.toLowerCase() == param1.toLowerCase())
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function createPackage(param1:String) : IUIPackage
      {
         var _loc3_:File = null;
         param1 = validateName(param1);
         if(this.getPackageByName(param1) != null)
         {
            throw new Error("Package already exists!");
         }
         var _loc2_:String = UtilsStr.generateUID();
         if(this._activeBranch.length == 0)
         {
            _loc3_ = new File(this.assetsPath + File.separator + param1);
         }
         else
         {
            _loc3_ = new File(this.assetsPath + "_" + this._activeBranch + File.separator + param1);
         }
         _loc3_.createDirectory();
         var _loc4_:XData = XData.parse("<packageDescription><resources/></packageDescription>");
         _loc4_.setAttribute("id",_loc2_);
         UtilsFile.saveXData(new File(_loc3_.nativePath + File.separator + "package.xml"),_loc4_);
         var _loc5_:FPackage = new FPackage(this,_loc3_);
         this._packageInsts[_loc2_] = _loc5_;
         this._packages.push(_loc5_);
         this._listDirty = true;
         _loc5_.open();
         if(this._editor)
         {
            this._editor.emit(EditorEvent.PackageListChanged);
         }
         return _loc5_;
      }
      
      public function addPackage(param1:File) : IUIPackage
      {
         var _loc2_:FPackage = new FPackage(this,param1);
         var _loc3_:FPackage = this._packageInsts[_loc2_.id];
         if(_loc3_ != null)
         {
            return _loc3_;
         }
         this._packageInsts[_loc2_.id] = _loc2_;
         this._packages.push(_loc2_);
         this._listDirty = true;
         this._lastChanged++;
         return _loc2_;
      }
      
      public function deletePackage(param1:String) : void
      {
         var _loc2_:FPackage = this._packageInsts[param1];
         if(!_loc2_)
         {
            return;
         }
         if(this._editor)
         {
            this._editor.docView.closeDocuments(_loc2_);
         }
         _loc2_.dispose();
         var _loc3_:File = new File(this.assetsPath + File.separator + _loc2_.name);
         if(_loc3_.exists)
         {
            _loc3_.moveToTrash();
         }
         _loc3_ = new File(this.objsPath + File.separator + "cache" + File.separator + _loc2_.id);
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
         delete this._packageInsts[param1];
         var _loc4_:int = this._packages.indexOf(_loc2_);
         this._packages.removeAt(_loc4_);
         this._listDirty = true;
         this._lastChanged++;
         if(this._editor)
         {
            this._editor.emit(EditorEvent.PackageListChanged);
         }
      }
      
      public function get allPackages() : Vector.<IUIPackage>
      {
         if(this._listDirty)
         {
            this._packages.sort(comparePackage);
            this._listDirty = false;
         }
         return this._packages;
      }
      
      public function get allBranches() : Vector.<String>
      {
         return this._branches;
      }
      
      public function save() : void
      {
         var _loc1_:XData = XData.create("projectDescription");
         _loc1_.setAttribute("id",this._id);
         _loc1_.setAttribute("type",this._type);
         _loc1_.setAttribute("version",int(this._versionCode / 100) + "." + int(this._versionCode % 100));
         UtilsFile.saveXData(new File(this._basePath + File.separator + this._name + ".fairy"),_loc1_);
      }
      
      public function getItemByURL(param1:String) : FPackageItem
      {
         var _loc4_:String = null;
         var _loc5_:IUIPackage = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:int = param1.indexOf("//");
         if(_loc2_ == -1)
         {
            return null;
         }
         var _loc3_:int = param1.indexOf("/",_loc2_ + 2);
         if(_loc3_ == -1)
         {
            if(param1.length > 13)
            {
               _loc4_ = param1.substr(5,8);
               _loc5_ = this.getPackage(_loc4_);
               if(_loc5_ != null)
               {
                  _loc6_ = param1.substr(13);
                  return _loc5_.getItem(_loc6_);
               }
            }
         }
         else
         {
            _loc7_ = param1.substr(_loc2_ + 2,_loc3_ - _loc2_ - 2);
            _loc5_ = this.getPackageByName(_loc7_);
            if(_loc5_ != null)
            {
               _loc8_ = param1.substr(_loc3_ + 1);
               return _loc5_.findItemByName(_loc8_);
            }
         }
         return null;
      }
      
      public function getItem(param1:String, param2:String) : FPackageItem
      {
         var _loc3_:IUIPackage = this.getPackage(param1);
         if(_loc3_)
         {
            return _loc3_.getItem(param2);
         }
         return null;
      }
      
      public function findItemByFile(param1:File) : FPackageItem
      {
         var _loc5_:String = null;
         var _loc6_:IUIPackage = null;
         var _loc7_:FPackageItem = null;
         param1.canonicalize();
         if(!UtilsStr.startsWith(param1.nativePath,this._assetsPath,true))
         {
            return null;
         }
         var _loc2_:* = param1.nativePath.substr(this._assetsPath.length);
         var _loc3_:String = UtilsStr.getFileFullName(_loc2_);
         _loc2_ = UtilsStr.getFilePath(_loc2_).replace(/\\/g,"/") + "/";
         var _loc4_:int = _loc2_.indexOf("/",1);
         if(_loc4_ != -1)
         {
            _loc5_ = _loc2_.substring(1,_loc4_);
            _loc6_ = this.getPackageByName(_loc5_);
            if(_loc6_)
            {
               _loc7_ = _loc6_.getItem(_loc2_.substring(_loc4_));
               if(_loc7_)
               {
                  return _loc6_.getItemByFileName(_loc7_,_loc3_);
               }
            }
         }
         return null;
      }
      
      public function getItemNameByURL(param1:String) : String
      {
         var _loc2_:FPackageItem = this.getItemByURL(param1);
         if(_loc2_)
         {
            return _loc2_.name;
         }
         return "";
      }
      
      public function createBranch(param1:String) : void
      {
         var _loc2_:File = new File(this._basePath + "/assets_" + param1);
         if(_loc2_.exists)
         {
            throw new Error(Consts.strings.text447);
         }
         _loc2_.createDirectory();
         this.scanBranches();
         if(this._editor)
         {
            this._editor.emit(EditorEvent.PackageListChanged);
         }
      }
      
      public function renameBranch(param1:String, param2:String) : void
      {
         var _loc5_:FPackage = null;
         var _loc6_:FPackageItem = null;
         param2 = validateName(param2);
         if(param2 == param1)
         {
            return;
         }
         var _loc3_:File = new File(this._basePath + "/assets_" + param1);
         var _loc4_:File = new File(this._basePath + "/assets_" + param2);
         UtilsFile.renameFile(_loc3_,_loc4_);
         this.scanBranches();
         param2 = ":" + param2;
         for each(_loc5_ in this._packageInsts)
         {
            if(_loc5_.opened)
            {
               _loc6_ = _loc5_.getItem("/:" + param1 + "/");
               if(_loc6_)
               {
                  _loc5_.renameBranchRoot(_loc6_,param2);
               }
            }
         }
         if(this._editor)
         {
            this._editor.emit(EditorEvent.PackageListChanged);
         }
      }
      
      public function removeBranch(param1:String) : void
      {
         var _loc2_:File = new File(this._basePath + "/assets_" + param1);
         UtilsFile.deleteFile(_loc2_,true);
         this._editor.refreshProject();
      }
      
      function getBranch(param1:FPackageItem) : FPackageItem
      {
         if(this._activeBranch.length == 0)
         {
            return param1;
         }
         var _loc2_:String = "/:" + this._activeBranch + param1.path + param1.name;
         var _loc3_:FPackageItem = param1.owner.getItemByPath(_loc2_);
         if(_loc3_ && _loc3_.type == param1.type)
         {
            return _loc3_;
         }
         return param1;
      }
      
      public function setVar(param1:String, param2:*) : void
      {
         if(param2 == undefined)
         {
            delete this._vars[param1];
         }
         else
         {
            this._vars[param1] = param2;
         }
      }
      
      public function getVar(param1:String) : *
      {
         return this._vars[param1];
      }
      
      public function registerCustomExtension(param1:String, param2:String, param3:String) : void
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         if(this._comExtensions[param2])
         {
            throw new Error("Component extension \'" + param2 + "\' already exists!");
         }
         if(param3 != null)
         {
            _loc4_ = param3.substr(1);
         }
         else
         {
            _loc4_ = null;
         }
         if(_loc4_ != null && FObjectType.NAME_PREFIX[_loc4_] == undefined)
         {
            throw new Error("Component extension \'" + param3 + "\' does not exist!");
         }
         this._comExtensions[param2] = {
            "name":param1,
            "className":param2,
            "superClassName":_loc4_
         };
         if(this._editor)
         {
            _loc5_ = this.getVar("CustomExtensionIDs") as Array;
            if(!_loc5_)
            {
               _loc5_ = [];
            }
            _loc5_.push(param2);
            this.setVar("CustomExtensionIDs",_loc5_);
            this.setVar("CustomExtensionChanged",true);
         }
      }
      
      public function getCustomExtension(param1:String) : Object
      {
         return this._comExtensions[param1];
      }
      
      public function clearCustomExtensions() : void
      {
         this._comExtensions = {};
         if(this._editor)
         {
            this.setVar("CustomExtensionIDs",undefined);
            this.setVar("CustomExtensionChanged",true);
         }
      }
      
      public function alert(param1:String, param2:Error = null) : void
      {
         if(this._editor)
         {
            this._editor.alert(null,param2);
         }
         else if(!param2)
         {
         }
      }
      
      public function logError(param1:String, param2:Error = null) : void
      {
         if(this._editor)
         {
            this._editor.consoleView.logError(param1,param2);
         }
         else if(!param2)
         {
         }
      }
      
      public function playSound(param1:String, param2:Number) : void
      {
         var _loc3_:FPackageItem = this.getItemByURL(param1);
         if(_loc3_)
         {
            _loc3_.setVar("volume",param2);
            _loc3_.getSound(this.playSound2);
         }
      }
      
      private function playSound2(param1:FPackageItem) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:Sound = param1.sound;
         if(_loc2_)
         {
            _loc3_ = Number(param1.getVar("volume"));
            if(_loc3_ == 0 || isNaN(_loc3_))
            {
               _loc2_.play();
            }
            else
            {
               _loc2_.play(0,0,new SoundTransform(_loc3_));
            }
         }
      }
      
      public function asyncRequest(param1:String, param2:* = undefined, param3:Function = null, param4:Function = null) : void
      {
         WorkerClient.inst.send(this,param1,param2,param3,param4);
      }
   }
}
