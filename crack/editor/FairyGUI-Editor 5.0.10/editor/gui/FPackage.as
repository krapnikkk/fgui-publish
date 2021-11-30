package fairygui.editor.gui
{
   import fairygui.editor.Consts;
   import fairygui.editor.api.EditorEvent;
   import fairygui.editor.api.IUIPackage;
   import fairygui.editor.api.IUIProject;
   import fairygui.editor.gui.animation.AniDef;
   import fairygui.editor.gui.animation.AniImporter;
   import fairygui.editor.settings.AtlasSettings;
   import fairygui.editor.settings.GlobalPublishSettings;
   import fairygui.editor.settings.PublishSettings;
   import fairygui.utils.Callback;
   import fairygui.utils.GTimers;
   import fairygui.utils.ImageTool;
   import fairygui.utils.ResourceSize;
   import fairygui.utils.UtilsFile;
   import fairygui.utils.UtilsStr;
   import fairygui.utils.XData;
   import fairygui.utils.XDataEnumerator;
   import fairygui.utils.pack.PackSettings;
   import flash.display.BitmapData;
   import flash.display.PNGEncoderOptions;
   import flash.filesystem.File;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   import org.bytearray.gif.GIFDecoder;
   import org.bytearray.gif.GIFFrame;
   
   public class FPackage implements IUIPackage
   {
      
      private static const GC_INTERVAL_IN_SECONDS:int = 300;
      
      private static var helperList:Array = [];
       
      
      private var _project:FProject;
      
      private var _id:String;
      
      private var _basePath:String;
      
      private var _cacheFolder:File;
      
      private var _metaFolder:File;
      
      private var _nextId:uint;
      
      private var _opened:Boolean;
      
      private var _opening:Boolean;
      
      private var _fatalError:Boolean;
      
      private var _inTransaction:int;
      
      private var _needSave:Boolean;
      
      private var _vars:Object;
      
      private var _rootItem:FPackageItem;
      
      private var _itemList:Vector.<FPackageItem>;
      
      private var _itemById:Object;
      
      private var _itemByPath:Object;
      
      private var _itemsCache:Object;
      
      private var _strings:Object;
      
      private var _publishSettings:PublishSettings;
      
      private var _lastModified:Number;
      
      public function FPackage(param1:FProject, param2:File)
      {
         super();
         this._project = param1;
         this._basePath = param2.nativePath;
         this._vars = {};
         this._itemById = {};
         this._itemByPath = {};
         this._itemList = new Vector.<FPackageItem>();
         this._itemsCache = {};
         this._rootItem = new FPackageItem(this,FPackageItemType.FOLDER,"/");
         this._rootItem.setFile("",param2.name);
         this._itemById[this._rootItem.id] = this._rootItem;
         this._itemByPath[this._rootItem.id] = this._rootItem;
         this.init();
      }
      
      private static function importMovieClip(param1:FPackageItem, param2:File, param3:Callback) : void
      {
         var callback2:Callback = null;
         var pi:FPackageItem = param1;
         var sourceFile:File = param2;
         var callback:Callback = param3;
         callback2 = new Callback();
         callback2.success = function():void
         {
            var _loc1_:AniDef = AniDef(callback2.result);
            UtilsFile.saveBytes(pi.file,_loc1_.save());
            callback.callOnSuccessImmediately();
         };
         callback2.failed = function():void
         {
            callback.addMsgs(callback2.msgs);
            callback.callOnFailImmediately();
         };
         AniImporter.importSpriteSheet(sourceFile,!pi.owner.project.supportAtlas,callback2);
      }
      
      public function get opened() : Boolean
      {
         return this._opened;
      }
      
      public function get project() : IUIProject
      {
         return this._project;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return this._rootItem.name;
      }
      
      public function get basePath() : String
      {
         return this._basePath;
      }
      
      public function get cacheFolder() : File
      {
         if(!this._cacheFolder.exists)
         {
            this._cacheFolder.createDirectory();
         }
         return this._cacheFolder;
      }
      
      public function get metaFolder() : File
      {
         if(!this._metaFolder.exists)
         {
            this._metaFolder.createDirectory();
         }
         return this._metaFolder;
      }
      
      public function get items() : Vector.<FPackageItem>
      {
         this.ensureOpen();
         return this._itemList;
      }
      
      public function get publishSettings() : Object
      {
         this.ensureOpen();
         return this._publishSettings;
      }
      
      public function get rootItem() : FPackageItem
      {
         return this._rootItem;
      }
      
      public function getBranchRootItem(param1:String) : FPackageItem
      {
         this.ensureOpen();
         return this._itemById["/:" + param1 + "/"];
      }
      
      public function toString() : String
      {
         return this._rootItem.name;
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
      
      public function beginBatch() : void
      {
         this._inTransaction++;
      }
      
      public function endBatch() : void
      {
         this._inTransaction--;
         if(this._inTransaction < 0)
         {
            this._inTransaction = 0;
         }
         if(this._inTransaction == 0 && this._needSave)
         {
            this.save();
         }
      }
      
      private function init() : void
      {
         var descFile:File = null;
         var xml:XData = null;
         try
         {
            descFile = new File(this._basePath + File.separator + "package.xml");
            this._lastModified = descFile.modificationDate.time;
            xml = UtilsFile.loadXMLRoot(descFile);
            if(xml)
            {
               this._id = xml.getAttribute("id");
               this._rootItem.favorite = xml.getAttributeBool("hasFavorites");
            }
            if(!this._id)
            {
               this._rootItem._errorStatus = true;
               this._id = UtilsStr.generateUID();
               this._project.logError("Invalid package id in \'" + descFile.nativePath + "\'");
            }
         }
         catch(err:Error)
         {
            _rootItem._errorStatus = true;
            _id = UtilsStr.generateUID();
            _project.logError("UIPackage()",err);
         }
         this._cacheFolder = new File(this._project.objsPath + "/cache/" + this._id);
         this._metaFolder = new File(this._project.objsPath + "/metas/" + this._id);
      }
      
      public function open() : void
      {
         var xd:XData = null;
         var step:String = null;
         var k:String = null;
         var descFile:File = null;
         var publishNode:XData = null;
         var resources:XData = null;
         var branches:Vector.<String> = null;
         var branch:String = null;
         var branchRoot:FPackageItem = null;
         var branchDescFile:File = null;
         var reopen:Boolean = this._opened;
         if(reopen)
         {
            this.setChanged();
         }
         try
         {
            descFile = new File(this._basePath + "/package.xml");
            xd = UtilsFile.loadXData(descFile);
         }
         catch(err:Error)
         {
            _fatalError = true;
            _rootItem._errorStatus = true;
            _opened = true;
            _project.logError("UIPackage.open",err);
            return;
         }
         this._opened = true;
         this._opening = true;
         this._fatalError = false;
         this._itemList.length = 0;
         this._itemsCache = this._itemById;
         this._itemById = {};
         this._itemByPath = {};
         this._itemById[this._rootItem.id] = this._rootItem;
         this._itemByPath[this._rootItem.id] = this._rootItem;
         this._rootItem.children.length = 0;
         this._rootItem._errorStatus = false;
         this._rootItem.favorite = false;
         try
         {
            this._lastModified = descFile.modificationDate.time;
            this._nextId = 0;
            publishNode = xd.getChild("publish");
            if(publishNode == null)
            {
               publishNode = XData.create("publish");
            }
            step = "loadPublishSettings";
            this.loadPublishSettings(publishNode);
            step = "listAllFolders";
            this.listAllFolders(this._rootItem,new File(this._basePath));
            resources = xd.getChild("resources");
            if(resources)
            {
               step = "parseItems";
               this.parseItems(resources.getChildren(),"");
            }
            xd.dispose();
            branches = this._project.allBranches;
            for each(branch in branches)
            {
               branchDescFile = new File(this.getBranchPath(branch) + "/package_branch.xml");
               if(branchDescFile.exists)
               {
                  step = "loadBranch";
                  branchRoot = this.ensurePathExists("/:" + branch + "/",false);
                  xd = UtilsFile.loadXData(branchDescFile);
                  if(xd)
                  {
                     step = "listBranchFolders";
                     this.listAllFolders(branchRoot,branchDescFile.parent);
                     resources = xd.getChild("resources");
                     if(resources)
                     {
                        step = "parseBranchItems";
                        this.parseItems(resources.getChildren(),branch);
                     }
                     branchRoot.setVar("lastModified",branchDescFile.modificationDate.time);
                  }
                  else
                  {
                     branchRoot._errorStatus = true;
                  }
               }
            }
         }
         catch(err:Error)
         {
            _fatalError = true;
            _rootItem._errorStatus = true;
            _project.logError("UIPackage.open(" + step + ")",err);
         }
         this._opening = false;
         for(k in this._itemsCache)
         {
            this._itemsCache[k].dispose();
         }
         this._itemsCache = null;
         GTimers.inst.add((GC_INTERVAL_IN_SECONDS + Math.random() * 10) * 1000,0,this.freeUnusedResources);
      }
      
      public function save() : void
      {
         var branchNode:XData = null;
         var pi:FPackageItem = null;
         var pd:XData = null;
         if(this._fatalError || !this._opened)
         {
            this._project.logError("Save failed! The package is not opened!");
            return;
         }
         if(this._inTransaction > 0)
         {
            this._needSave = true;
            return;
         }
         this._needSave = false;
         this.setChanged();
         var xd:XData = XData.create("packageDescription");
         xd.setAttribute("id",this._id);
         var resData:XData = XData.create("resources");
         xd.appendChild(resData);
         var branchRoot:Object = {};
         this._rootItem.favorite = false;
         var cnt:int = this._itemList.length;
         var i:int = 0;
         for(; i < cnt; i++)
         {
            pi = this._itemList[i];
            if(pi.favorite)
            {
               this._rootItem.favorite = true;
            }
            pd = null;
            if(pi.type == FPackageItemType.FOLDER)
            {
               if(!pi.folderSettings.empty || pi.favorite)
               {
                  pd = pi.serialize();
               }
               else
               {
                  continue;
               }
            }
            else
            {
               pd = pi.serialize();
            }
            if(pi.branch)
            {
               branchNode = branchRoot[pi.branch];
               if(!branchNode)
               {
                  branchNode = XData.create("resources");
                  branchRoot[pi.branch] = branchNode;
               }
               branchNode.appendChild(pd);
            }
            else
            {
               resData.appendChild(pd);
            }
         }
         if(this._rootItem.favorite)
         {
            xd.setAttribute("hasFavorites",this._rootItem.favorite);
         }
         var publishNode:XData = XData.create("publish");
         xd.appendChild(publishNode);
         this.savePublishSettings(publishNode);
         var descFile:File = new File(this._basePath + "/package.xml");
         try
         {
            UtilsFile.saveXData(descFile,xd);
            this._lastModified = descFile.modificationDate.time;
         }
         catch(err:Error)
         {
            _project.alert("Save package",err);
         }
         xd.dispose();
         for each(pi in this._rootItem.children)
         {
            if(pi.branch.length > 0)
            {
               xd = XData.create("branchDescription");
               branchNode = branchRoot[pi.branch];
               if(branchNode)
               {
                  xd.appendChild(branchRoot[pi.branch]);
               }
               descFile = new File(this.getBranchPath(pi.branch) + "/package_branch.xml");
               try
               {
                  UtilsFile.saveXData(descFile,xd);
                  pi.setVar("lastModified",descFile.modificationDate.time);
               }
               catch(err:Error)
               {
                  _project.alert("Save branch",err);
                  continue;
               }
            }
         }
      }
      
      private function loadPublishSettings(param1:XData) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc12_:AtlasSettings = null;
         var _loc15_:String = null;
         var _loc16_:Array = null;
         var _loc17_:PackSettings = null;
         var _loc2_:GlobalPublishSettings = GlobalPublishSettings(this._project.getSettings("publish"));
         this._publishSettings = new PublishSettings();
         this._publishSettings.fileName = param1.getAttribute("name","");
         this._publishSettings.path = param1.getAttribute("path","");
         this._publishSettings.branchPath = param1.getAttribute("branchPath","");
         this._publishSettings.packageCount = param1.getAttributeInt("packageCount",_loc2_.packageCount);
         this._publishSettings.genCode = param1.getAttributeBool("genCode");
         this._publishSettings.codePath = param1.getAttribute("codePath","");
         this._publishSettings.useGlobalAtlasSettings = !param1.hasAttribute("maxAtlasSize");
         var _loc6_:Boolean = true;
         if(this._publishSettings.useGlobalAtlasSettings)
         {
            _loc3_ = _loc2_.atlasMaxSize;
            _loc5_ = _loc2_.atlasSizeOption;
            _loc8_ = _loc2_.atlasForceSquare;
            _loc9_ = _loc2_.atlasAllowRotation;
            _loc4_ = _loc2_.atlasPaging;
         }
         else
         {
            _loc3_ = param1.getAttributeInt("maxAtlasSize",_loc2_.atlasMaxSize);
            _loc5_ = param1.getAttribute("sizeOption",_loc2_.atlasSizeOption);
            if(param1.getAttributeBool("npot"))
            {
               _loc5_ = "npot";
            }
            _loc8_ = param1.getAttributeBool("square",_loc2_.atlasForceSquare);
            _loc9_ = param1.getAttributeBool("rotation",_loc2_.atlasAllowRotation);
            _loc4_ = param1.getAttributeBool("multiPage",_loc2_.atlasPaging);
         }
         if(_loc5_ == "npot")
         {
            _loc6_ = false;
         }
         else if(_loc5_ == "mof")
         {
            _loc6_ = false;
            _loc7_ = true;
         }
         var _loc10_:Boolean = param1.getAttributeBool("extractAlpha");
         var _loc11_:int = param1.getAttributeInt("maxAtlasIndex",10);
         this._publishSettings.atlasList.length = _loc11_ + 1;
         var _loc13_:int = 0;
         while(_loc13_ <= _loc11_)
         {
            _loc12_ = this._publishSettings.atlasList[_loc13_];
            if(!_loc12_)
            {
               _loc12_ = new AtlasSettings();
               this._publishSettings.atlasList[_loc13_] = _loc12_;
            }
            _loc12_.name = "";
            _loc12_.extractAlpha = _loc10_;
            _loc12_.compression = false;
            _loc17_ = _loc12_.packSettings;
            _loc17_.pot = _loc6_;
            _loc17_.mof = _loc7_;
            _loc17_.square = _loc8_;
            _loc17_.rotation = _loc9_;
            _loc17_.maxHeight = _loc12_.packSettings.maxWidth = _loc3_;
            _loc17_.multiPage = _loc4_;
            _loc13_++;
         }
         var _loc14_:XDataEnumerator = param1.getEnumerator("atlas");
         while(_loc14_.moveNext())
         {
            _loc13_ = _loc14_.current.getAttributeInt("index");
            if(_loc13_ <= _loc11_)
            {
               _loc12_ = this._publishSettings.atlasList[_loc13_];
               _loc12_.name = _loc14_.current.getAttribute("name","");
               _loc12_.compression = _loc14_.current.getAttributeBool("compression");
            }
         }
         this._publishSettings.excludedList.length = 0;
         _loc15_ = param1.getAttribute("excluded");
         if(_loc15_)
         {
            _loc16_ = _loc15_.split(",");
            for each(_loc15_ in _loc16_)
            {
               this._publishSettings.excludedList.push(_loc15_);
            }
         }
      }
      
      private function savePublishSettings(param1:XData) : void
      {
         var _loc5_:Boolean = false;
         var _loc6_:AtlasSettings = null;
         var _loc8_:XData = null;
         param1.setAttribute("name",this._publishSettings.fileName);
         if(this._publishSettings.path)
         {
            param1.setAttribute("path",this._publishSettings.path);
            param1.setAttribute("packageCount",this._publishSettings.packageCount);
         }
         if(this._publishSettings.branchPath)
         {
            param1.setAttribute("branchPath",this._publishSettings.branchPath);
         }
         if(this._publishSettings.genCode)
         {
            param1.setAttribute("genCode",this._publishSettings.genCode);
         }
         if(this._publishSettings.codePath)
         {
            param1.setAttribute("codePath",this._publishSettings.codePath);
         }
         var _loc2_:AtlasSettings = this._publishSettings.atlasList[0];
         var _loc3_:PackSettings = _loc2_.packSettings;
         if(!this._publishSettings.useGlobalAtlasSettings)
         {
            param1.setAttribute("maxAtlasSize",_loc3_.maxWidth);
            if(!_loc3_.pot)
            {
               param1.setAttribute("sizeOption",!!_loc3_.mof?"mof":"npot");
            }
            if(_loc3_.square)
            {
               param1.setAttribute("square",_loc3_.square);
            }
            if(_loc3_.rotation)
            {
               param1.setAttribute("rotation",_loc3_.rotation);
            }
            if(!_loc3_.multiPage)
            {
               param1.setAttribute("multiPage",_loc3_.multiPage);
            }
         }
         if(_loc2_.extractAlpha)
         {
            param1.setAttribute("extractAlpha",_loc2_.extractAlpha);
         }
         var _loc4_:int = this._publishSettings.atlasList.length;
         if(_loc4_ != 11)
         {
            param1.setAttribute("maxAtlasIndex",_loc4_ - 1);
         }
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_)
         {
            _loc6_ = this._publishSettings.atlasList[_loc7_];
            _loc8_ = XData.create("atlas");
            _loc5_ = false;
            if(_loc6_.name)
            {
               _loc8_.setAttribute("name",_loc6_.name);
               _loc5_ = true;
            }
            if(_loc6_.compression)
            {
               _loc8_.setAttribute("compression",_loc6_.compression);
               _loc5_ = true;
            }
            if(_loc5_)
            {
               _loc8_.setAttribute("index",_loc7_);
               param1.appendChild(_loc8_);
            }
            else
            {
               _loc8_.dispose();
            }
            _loc7_++;
         }
         if(this._publishSettings.excludedList.length > 0)
         {
            param1.setAttribute("excluded",this._publishSettings.excludedList.join(","));
         }
      }
      
      public function setChanged() : void
      {
         this._vars.modifiedYetNotPublished = true;
         this._project.setChanged();
      }
      
      public function touch() : void
      {
         var _loc3_:Vector.<String> = null;
         var _loc4_:String = null;
         var _loc5_:FPackageItem = null;
         var _loc1_:Boolean = false;
         var _loc2_:File = new File(this._basePath + File.separator + "package.xml");
         if(!_loc2_.exists || this._lastModified != _loc2_.modificationDate.time)
         {
            _loc1_ = true;
         }
         if(this._opened)
         {
            _loc3_ = this._project.allBranches;
            if(_loc3_.length > 0)
            {
               for each(_loc4_ in _loc3_)
               {
                  _loc2_ = new File(this.getBranchPath(_loc4_) + "/package_branch.xml");
                  if(_loc2_.exists)
                  {
                     _loc5_ = this.getBranchRootItem(_loc4_);
                     if(!_loc5_)
                     {
                        _loc1_ = true;
                     }
                     else if(_loc5_.getVar("lastModified") != _loc2_.modificationDate.time)
                     {
                        _loc1_ = true;
                     }
                  }
               }
            }
            for each(_loc5_ in this._rootItem.children)
            {
               if(_loc5_.branch.length > 0)
               {
                  _loc5_.touch();
                  if(!_loc5_.file.exists)
                  {
                     _loc1_ = true;
                  }
               }
            }
         }
         if(_loc1_)
         {
            if(this._opened)
            {
               this.open();
            }
            else
            {
               this.init();
            }
            if(this._project.editor)
            {
               this._project.editor.emit(EditorEvent.PackageReloaded,this);
            }
         }
      }
      
      public function dispose() : void
      {
         var _loc3_:FPackageItem = null;
         GTimers.inst.remove(this.freeUnusedResources);
         var _loc1_:int = this._itemList.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._itemList[_loc2_];
            _loc3_.dispose();
            _loc2_++;
         }
         this._itemList.length = 0;
         this._opened = false;
      }
      
      public function ensureOpen() : void
      {
         if(!this._opened)
         {
            this.open();
         }
      }
      
      public function freeUnusedResources(param1:Boolean = false) : void
      {
         var _loc2_:Boolean = false;
         var _loc4_:FPackageItem = null;
         if(Capabilities.isDebugger)
         {
            _loc2_ = true;
         }
         var _loc3_:int = !!param1?0:int(getTimer());
         for each(_loc4_ in this._itemList)
         {
            if(_loc4_.type == FPackageItemType.IMAGE || _loc4_.type == FPackageItemType.MOVIECLIP)
            {
               if(!_loc4_.tryDisposeData(_loc3_))
               {
               }
            }
         }
      }
      
      public function get strings() : Object
      {
         return this._strings;
      }
      
      public function set strings(param1:Object) : void
      {
         this._strings = param1;
      }
      
      private function listAllFolders(param1:FPackageItem, param2:File) : void
      {
         var _loc6_:File = null;
         var _loc7_:* = null;
         var _loc8_:FPackageItem = null;
         var _loc3_:Array = param2.getDirectoryListing();
         var _loc4_:int = _loc3_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            if(_loc6_.isDirectory)
            {
               _loc7_ = param1.id + _loc6_.name + "/";
               _loc8_ = this._itemsCache[_loc7_];
               if(!_loc8_)
               {
                  _loc8_ = new FPackageItem(this,FPackageItemType.FOLDER,_loc7_);
               }
               else
               {
                  delete this._itemsCache[_loc7_];
                  _loc8_.children.length = 0;
               }
               _loc8_.setFile(param1.id,_loc6_.name);
               this._itemById[_loc8_.id] = _loc8_;
               this._itemByPath[_loc8_.path + _loc8_.name] = _loc8_;
               this._itemList.push(_loc8_);
               param1.children.push(_loc8_);
               this.listAllFolders(_loc8_,_loc6_);
            }
            _loc5_++;
         }
      }
      
      private function parseItems(param1:Vector.<XData>, param2:String) : void
      {
         var _loc3_:FPackageItem = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:* = null;
         var _loc7_:XData = null;
         var _loc8_:FPackageItem = null;
         var _loc9_:int = 0;
         for each(_loc7_ in param1)
         {
            _loc4_ = _loc7_.getAttribute("id");
            if(_loc4_)
            {
               _loc5_ = _loc7_.getName();
               if(_loc5_ == "folder")
               {
                  _loc3_ = this._itemById[_loc4_];
                  if(_loc3_)
                  {
                     _loc3_.favorite = _loc7_.getAttributeBool("favorite");
                     if(_loc3_.favorite)
                     {
                        this._rootItem.favorite = true;
                     }
                     _loc3_.folderSettings.read(_loc3_,_loc7_);
                  }
               }
               else
               {
                  _loc3_ = this._itemById[_loc4_];
                  if(!_loc3_)
                  {
                     _loc3_ = this._itemsCache[_loc4_];
                     if(!_loc3_)
                     {
                        _loc3_ = new FPackageItem(this,_loc5_,_loc4_);
                     }
                     else
                     {
                        delete this._itemsCache[_loc4_];
                        _loc3_.setChanged();
                     }
                     _loc6_ = _loc7_.getAttribute("path","");
                     if(_loc6_.length == 0)
                     {
                        _loc6_ = "/";
                     }
                     else
                     {
                        if(_loc6_.charAt(0) != "/")
                        {
                           _loc6_ = "/" + _loc6_;
                        }
                        if(_loc6_.charAt(_loc6_.length - 1) != "/")
                        {
                           _loc6_ = _loc6_ + "/";
                        }
                     }
                     if(param2)
                     {
                        _loc6_ = "/:" + param2 + _loc6_;
                     }
                     _loc3_.setFile(_loc6_,_loc7_.getAttribute("name",""));
                     _loc3_.exported = _loc7_.getAttributeBool("exported");
                     _loc3_.favorite = _loc7_.getAttributeBool("favorite");
                     _loc3_.reviewed = _loc7_.getAttribute("reviewed");
                     if(_loc3_.imageSettings)
                     {
                        _loc3_.imageSettings.read(_loc3_,_loc7_);
                     }
                     else if(_loc3_.fontSettings)
                     {
                        _loc3_.fontSettings.read(_loc3_,_loc7_);
                     }
                     if(_loc3_.favorite)
                     {
                        this._rootItem.favorite = true;
                     }
                     _loc8_ = this._itemById[_loc3_.path];
                     if(!_loc8_)
                     {
                        _loc8_ = this.ensurePathExists(_loc3_.path,false);
                     }
                     _loc8_.children.push(_loc3_);
                     this._itemById[_loc3_.id] = _loc3_;
                     this._itemList.push(_loc3_);
                     this._itemByPath[_loc3_.path + _loc3_.name] = _loc3_;
                     _loc6_ = _loc3_.id.substr(4);
                     _loc9_ = parseInt(_loc6_,36);
                     if(_loc9_ >= this._nextId)
                     {
                        this._nextId = _loc9_ + 1;
                     }
                  }
               }
            }
         }
      }
      
      public function getNextId() : String
      {
         var _loc1_:String = this._project.serialNumberSeed + (this._nextId++).toString(36);
         while(this._itemById[_loc1_])
         {
            _loc1_ = this._project.serialNumberSeed + (this._nextId++).toString(36);
         }
         return _loc1_;
      }
      
      public function getSequenceName(param1:String) : String
      {
         var _loc6_:FPackageItem = null;
         var _loc7_:int = 0;
         var _loc2_:int = param1.length;
         var _loc3_:int = this._itemList.length;
         var _loc4_:int = -1;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = this._itemList[_loc5_];
            if(UtilsStr.startsWith(_loc6_.name,param1))
            {
               _loc7_ = parseInt(_loc6_.name.substr(_loc2_));
               if(_loc7_ > _loc4_)
               {
                  _loc4_ = _loc7_;
               }
            }
            _loc5_++;
         }
         if(_loc4_ <= 0)
         {
            return param1 + "1";
         }
         return param1 + ++_loc4_;
      }
      
      public function getUniqueName(param1:FPackageItem, param2:String) : String
      {
         var _loc5_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:FPackageItem = null;
         var _loc11_:Boolean = false;
         var _loc3_:String = UtilsStr.getFileName(param2);
         var _loc4_:String = UtilsStr.getFileExt(param2,true);
         if(_loc4_)
         {
            _loc5_ = "." + _loc4_;
            _loc5_ = _loc5_.toLowerCase();
         }
         else
         {
            _loc5_ = "";
         }
         var _loc6_:int = 1;
         var _loc12_:int = _loc3_.length;
         if(param1 == null)
         {
            _loc7_ = this._itemList.length;
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc10_ = this._itemList[_loc8_];
               if(UtilsStr.startsWith(_loc10_.name,_loc3_,true) && UtilsStr.getFileExt(_loc10_.fileName) == _loc4_)
               {
                  if(_loc10_.name.length == _loc12_)
                  {
                     _loc11_ = true;
                  }
                  else if(_loc10_.name.charAt(_loc12_) == "(")
                  {
                     _loc9_ = _loc10_.name.indexOf(")",_loc12_);
                     if(_loc9_ != -1)
                     {
                        _loc9_ = parseInt(_loc10_.fileName.substring(_loc12_ + 1,_loc9_));
                        if(_loc9_ >= _loc6_)
                        {
                           _loc6_ = _loc9_ + 1;
                        }
                     }
                  }
               }
               _loc8_++;
            }
         }
         else
         {
            _loc7_ = param1.children.length;
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc10_ = param1.children[_loc8_];
               if(UtilsStr.startsWith(_loc10_.name,_loc3_,true) && UtilsStr.getFileExt(_loc10_.fileName) == _loc4_)
               {
                  if(_loc10_.name.length == _loc12_)
                  {
                     _loc11_ = true;
                  }
                  else if(_loc10_.name.charAt(_loc12_) == "(")
                  {
                     _loc9_ = _loc10_.name.indexOf(")",_loc12_);
                     if(_loc9_ != -1)
                     {
                        _loc9_ = parseInt(_loc10_.fileName.substring(_loc12_ + 1,_loc9_));
                        if(_loc9_ >= _loc6_)
                        {
                           _loc6_ = _loc9_ + 1;
                        }
                     }
                  }
               }
               _loc8_++;
            }
         }
         if(_loc11_)
         {
            return _loc3_ + "(" + _loc6_ + ")" + _loc5_;
         }
         return param2;
      }
      
      public function getItemListing(param1:FPackageItem, param2:Array = null, param3:Boolean = true, param4:Boolean = false, param5:Vector.<FPackageItem> = null) : Vector.<FPackageItem>
      {
         var _loc8_:FPackageItem = null;
         this.ensureOpen();
         if(param5 == null)
         {
            param5 = new Vector.<FPackageItem>();
         }
         var _loc6_:int = param1.children.length;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = param1.children[_loc7_];
            if(!(param2 != null && param2.indexOf(_loc8_.type) == -1))
            {
               param5.push(_loc8_);
               if(param4 && _loc8_.type == FPackageItemType.FOLDER)
               {
                  this.getItemListing(_loc8_,param2,param3,param4,param5);
               }
            }
            _loc7_++;
         }
         if(param3 && !param4 && param5.length)
         {
            param5.sort(this.compareItem);
         }
         return param5;
      }
      
      public function getFavoriteItems(param1:Vector.<FPackageItem> = null) : Vector.<FPackageItem>
      {
         this.ensureOpen();
         if(param1 == null)
         {
            param1 = new Vector.<FPackageItem>();
         }
         this.collectFavorites(this._rootItem.children,param1);
         param1.sort(this.compareItem);
         return param1;
      }
      
      private function collectFavorites(param1:Vector.<FPackageItem>, param2:Vector.<FPackageItem>) : void
      {
         var _loc5_:FPackageItem = null;
         var _loc3_:int = param1.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            if(_loc5_.favorite)
            {
               param2.push(_loc5_);
            }
            else if(_loc5_.type == FPackageItemType.FOLDER)
            {
               this.collectFavorites(_loc5_.children,param2);
            }
            _loc4_++;
         }
      }
      
      private function compareItem(param1:FPackageItem, param2:FPackageItem) : int
      {
         if(param1.type == "folder" && param2.type != "folder")
         {
            return -1;
         }
         if(param1.type != "folder" && param2.type == "folder")
         {
            return 1;
         }
         return param1.sortKey.localeCompare(param2.sortKey);
      }
      
      public function getItem(param1:String) : FPackageItem
      {
         this.ensureOpen();
         return this._itemById[param1];
      }
      
      public function findItemByName(param1:String) : FPackageItem
      {
         var _loc2_:FPackageItem = null;
         var _loc3_:FPackageItem = null;
         this.ensureOpen();
         for each(_loc2_ in this._itemList)
         {
            if(_loc2_.name == param1)
            {
               if(_loc2_.exported)
               {
                  helperList.unshift(_loc2_);
               }
               else
               {
                  helperList.push(_loc2_);
               }
            }
         }
         if(helperList.length > 0)
         {
            _loc3_ = helperList[0];
            helperList.length = 0;
            return _loc3_;
         }
         return null;
      }
      
      public function getItemByPath(param1:String) : FPackageItem
      {
         this.ensureOpen();
         return this._itemByPath[param1];
      }
      
      public function getItemByName(param1:FPackageItem, param2:String) : FPackageItem
      {
         var _loc4_:FPackageItem = null;
         this.ensureOpen();
         if(param1 == null)
         {
            param1 = this._rootItem;
         }
         var _loc3_:Vector.<FPackageItem> = param1.children;
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.name == param2)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      public function getItemByFileName(param1:FPackageItem, param2:String) : FPackageItem
      {
         var _loc5_:FPackageItem = null;
         var _loc3_:int = param1.children.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1.children[_loc4_];
            if(Consts.isMacOS && _loc5_.fileName == param2 || !Consts.isMacOS && _loc5_.fileName.toLowerCase() == param2.toLowerCase())
            {
               return _loc5_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function getItemPath(param1:FPackageItem, param2:Vector.<FPackageItem> = null) : Vector.<FPackageItem>
      {
         if(!param2)
         {
            param2 = new Vector.<FPackageItem>();
         }
         param2.push(param1);
         while(param1 != this._rootItem)
         {
            param1 = param1.parent;
            if(param1)
            {
               if(param1 != this._rootItem)
               {
                  param2.push(param1);
               }
               continue;
            }
            break;
         }
         param2.reverse();
         return param2;
      }
      
      public function addItem(param1:FPackageItem) : void
      {
         param1.touch();
         this._itemList.push(param1);
         this._itemById[param1.id] = param1;
         this._itemByPath[param1.path + param1.name] = param1;
         var _loc2_:FPackageItem = this._itemById[param1.path];
         _loc2_.children.push(param1);
         if(!this._opening)
         {
            if(this._project.editor)
            {
               this._project.editor.emit(EditorEvent.PackageTreeChanged,_loc2_);
            }
            this.save();
         }
      }
      
      public function renameItem(param1:FPackageItem, param2:String) : void
      {
         var _loc5_:String = null;
         var _loc6_:Vector.<String> = null;
         var _loc7_:String = null;
         var _loc8_:FPackageItem = null;
         var _loc9_:FPackageItem = null;
         if(param1.isBranchRoot)
         {
            return;
         }
         param2 = FProject.validateName(param2);
         var _loc3_:File = param1.file;
         if(param1.type != FPackageItemType.FOLDER)
         {
            _loc5_ = _loc3_.extension;
            param2 = param2 + (!!_loc5_?"." + _loc5_:"");
         }
         var _loc4_:File = new File(UtilsStr.getFilePath(_loc3_.nativePath) + "/" + param2);
         UtilsFile.renameFile(_loc3_,_loc4_);
         if(param1 == this._rootItem)
         {
            this._basePath = _loc4_.nativePath;
            this._project._listDirty = true;
            param1.setFile(param1.path,param2);
            _loc6_ = this._project.allBranches;
            for each(_loc7_ in _loc6_)
            {
               _loc8_ = this.getBranchRootItem(_loc7_);
               if(_loc8_)
               {
                  _loc4_ = new File(this.getBranchPath(_loc7_));
                  UtilsFile.renameFile(_loc8_.file,_loc4_);
               }
            }
            this.changeChildrenPath(param1);
            if(this._project.editor)
            {
               this._project.editor.emit(EditorEvent.PackageItemChanged,param1);
               this._project.editor.emit(EditorEvent.PackageTreeChanged,null);
            }
         }
         else
         {
            delete this._itemByPath[param1.path + param1.name];
            param1.setFile(param1.path,param2);
            this._itemByPath[param1.path + param1.name] = param1;
            if(param1.type == FPackageItemType.FOLDER)
            {
               delete this._itemById[param1.id];
               param1.id = param1.path + param1.name + "/";
               this._itemById[param1.id] = param1;
               this.changeChildrenPath(param1);
            }
            if(this._project.editor)
            {
               this._project.editor.emit(EditorEvent.PackageItemChanged,param1);
               _loc9_ = this._itemById[param1.path];
               if(_loc9_)
               {
                  this._project.editor.emit(EditorEvent.PackageTreeChanged,_loc9_);
               }
            }
         }
         this.save();
      }
      
      function renameBranchRoot(param1:FPackageItem, param2:String) : void
      {
         var _loc3_:FPackageItem = null;
         if(!param1.isBranchRoot)
         {
            return;
         }
         delete this._itemByPath[param1.path + param1.name];
         param1.setFile(param1.path,param2);
         this._itemByPath[param1.path + param1.name] = param1;
         delete this._itemById[param1.id];
         param1.id = param1.path + param1.name + "/";
         this._itemById[param1.id] = param1;
         this.changeChildrenPath(param1);
         if(this._project.editor)
         {
            this._project.editor.emit(EditorEvent.PackageItemChanged,param1);
            _loc3_ = this._itemById[param1.path];
            if(_loc3_)
            {
               this._project.editor.emit(EditorEvent.PackageTreeChanged,_loc3_);
            }
         }
      }
      
      public function moveItem(param1:FPackageItem, param2:String) : void
      {
         if(param1.path == param2)
         {
            return;
         }
         var _loc3_:FPackageItem = this._itemById[param1.path];
         var _loc4_:FPackageItem = this._itemById[param2];
         if(_loc3_ == null || _loc4_ == null)
         {
            throw new Error("Path not exists");
         }
         var _loc5_:String = this.getUniqueName(_loc4_,param1.fileName);
         var _loc6_:File = param1.file;
         var _loc7_:File = new File(_loc4_.file.nativePath + "/" + _loc5_);
         try
         {
            _loc6_.canonicalize();
            _loc7_.canonicalize();
         }
         catch(err:*)
         {
         }
         if(_loc6_.nativePath != _loc7_.nativePath)
         {
            if(param1.type == FPackageItemType.FOLDER)
            {
               if(UtilsStr.startsWith(_loc7_.nativePath,_loc6_.nativePath,true))
               {
                  throw new Error("Cannot move into child folder");
               }
            }
            if(_loc6_.exists)
            {
               _loc6_.moveTo(_loc7_);
            }
         }
         var _loc8_:int = _loc3_.children.indexOf(param1);
         _loc3_.children.splice(_loc8_,1);
         _loc4_.children.push(param1);
         delete this._itemByPath[param1.path + param1.name];
         param1.setFile(param2,_loc5_);
         this._itemByPath[param1.path + param1.name] = param1;
         if(param1.type == FPackageItemType.FOLDER)
         {
            delete this._itemById[param1.id];
            param1.id = param1.path + param1.name + "/";
            this._itemById[param1.id] = param1;
            this.changeChildrenPath(param1);
         }
         if(this._project.editor)
         {
            this._project.editor.emit(EditorEvent.PackageTreeChanged,_loc3_);
            this._project.editor.emit(EditorEvent.PackageTreeChanged,_loc4_);
         }
         this.save();
      }
      
      private function changeChildrenPath(param1:FPackageItem) : void
      {
         var _loc4_:FPackageItem = null;
         var _loc2_:int = param1.children.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.children[_loc3_];
            delete this._itemByPath[_loc4_.path + _loc4_.name];
            _loc4_.setFile(param1.id,_loc4_.fileName);
            this._itemByPath[_loc4_.path + _loc4_.name] = _loc4_;
            if(_loc4_.type == FPackageItemType.FOLDER)
            {
               delete this._itemById[_loc4_.id];
               _loc4_.id = _loc4_.path + _loc4_.name + "/";
               this._itemById[_loc4_.id] = _loc4_;
               this.changeChildrenPath(_loc4_);
            }
            _loc3_++;
         }
      }
      
      public function deleteItem(param1:FPackageItem) : int
      {
         var _loc3_:File = null;
         var _loc4_:FPackageItem = null;
         var _loc5_:int = 0;
         var _loc2_:int = this._deleteItem(param1);
         if(_loc2_ > 0)
         {
            _loc3_ = param1.file;
            if(_loc3_.exists)
            {
               UtilsFile.deleteFile(_loc3_,true);
            }
            _loc4_ = this._itemById[param1.path];
            if(_loc4_ != null)
            {
               _loc5_ = _loc4_.children.indexOf(param1);
               _loc4_.children.splice(_loc5_,1);
               if(this._project.editor)
               {
                  this._project.editor.emit(EditorEvent.PackageTreeChanged,_loc4_);
               }
            }
            this.save();
         }
         return _loc2_;
      }
      
      private function _deleteItem(param1:FPackageItem) : int
      {
         var _loc4_:int = 0;
         var _loc2_:int = this._itemList.indexOf(param1);
         if(_loc2_ == -1)
         {
            return 0;
         }
         this._itemList.splice(_loc2_,1);
         delete this._itemById[param1.id];
         delete this._itemByPath[param1.path + param1.name];
         var _loc3_:int = 1;
         if(param1.type == FPackageItemType.FOLDER)
         {
            _loc4_ = param1.children.length;
            _loc2_ = 0;
            while(_loc2_ < _loc4_)
            {
               _loc3_ = _loc3_ + this._deleteItem(param1.children[_loc2_]);
               _loc2_++;
            }
         }
         param1.dispose();
         if(this._project.editor)
         {
            this._project.editor.emit(EditorEvent.PackageItemDeleted,param1);
         }
         return _loc3_;
      }
      
      public function duplicateItem(param1:FPackageItem, param2:String) : FPackageItem
      {
         param2 = FProject.validateName(param2);
         var _loc3_:String = UtilsStr.getFileExt(param1.fileName);
         param2 = param2 + (!!_loc3_?"." + _loc3_:"");
         var _loc4_:FPackageItem = new FPackageItem(this,param1.type,this.getNextId());
         _loc4_.setFile(param1.path,param2);
         _loc4_.copySettings(param1);
         var _loc5_:File = param1.file;
         var _loc6_:File = _loc4_.file;
         if(_loc6_.exists)
         {
            throw new Error("File already exists");
         }
         if(_loc5_.isDirectory)
         {
            _loc6_.createDirectory();
         }
         else
         {
            UtilsFile.copyFile(_loc5_,_loc6_);
         }
         this.addItem(_loc4_);
         return _loc4_;
      }
      
      public function setItemProperty(param1:FPackageItem, param2:String, param3:*) : void
      {
         if(param1[param2] == param3)
         {
            return;
         }
         param1[param2] = param3;
         this.save();
         if(this._project.editor)
         {
            this._project.editor.emit(EditorEvent.PackageItemChanged,param1);
         }
      }
      
      public function ensurePathExists(param1:String, param2:Boolean) : FPackageItem
      {
         var _loc6_:String = null;
         var _loc9_:File = null;
         var _loc3_:FPackageItem = this._itemById[param1];
         if(_loc3_)
         {
            return _loc3_;
         }
         var _loc4_:int = param1.length;
         var _loc5_:int = 1;
         var _loc7_:FPackageItem = this._rootItem;
         var _loc8_:int = 1;
         while(_loc8_ < _loc4_)
         {
            if(param1.charCodeAt(_loc8_) == 47)
            {
               _loc6_ = param1.substring(0,_loc8_ + 1);
               _loc3_ = this._itemById[_loc6_];
               if(!_loc3_)
               {
                  _loc3_ = new FPackageItem(this,FPackageItemType.FOLDER,_loc6_);
                  _loc3_.setFile(_loc6_.substring(0,_loc5_),_loc6_.substring(_loc5_,_loc8_));
                  if(param2)
                  {
                     _loc9_ = _loc3_.file;
                     if(!_loc9_.exists)
                     {
                        _loc9_.createDirectory();
                     }
                  }
                  this.addItem(_loc3_);
               }
               _loc7_ = _loc3_;
               _loc5_ = _loc8_ + 1;
            }
            _loc8_++;
         }
         if(!_loc3_)
         {
            _loc3_ = this._rootItem;
         }
         return _loc3_;
      }
      
      public function getBranchPath(param1:String) : String
      {
         return this._project.basePath + "/assets_" + param1 + "/" + this._rootItem.name;
      }
      
      public function createBranch(param1:String) : void
      {
         var _loc4_:XData = null;
         var _loc2_:File = new File(this.getBranchPath(param1));
         if(!_loc2_.exists)
         {
            _loc2_.createDirectory();
         }
         var _loc3_:File = _loc2_.resolvePath("package_branch.xml");
         if(!_loc3_.exists)
         {
            _loc4_ = XData.parse("<branchDescription><resources/></branchDescription>");
            UtilsFile.saveXData(_loc3_,_loc4_);
         }
         this.ensurePathExists("/:" + param1 + "/",false);
      }
      
      public function createFolder(param1:String, param2:String = null, param3:Boolean = false) : FPackageItem
      {
         this.ensureOpen();
         if(param2 == null)
         {
            param2 = "/";
         }
         var _loc4_:FPackageItem = this._itemById[param2];
         if(!_loc4_)
         {
            throw new Error("Path not exists");
         }
         param1 = FProject.validateName(param1);
         if(param3)
         {
            param1 = this.getUniqueName(null,param1);
         }
         var _loc5_:FPackageItem = new FPackageItem(this,FPackageItemType.FOLDER,param2 + param1 + "/");
         _loc5_.setFile(param2,param1);
         if(_loc5_.file.exists)
         {
            throw new Error(Consts.strings.text113);
         }
         _loc5_.file.createDirectory();
         this.addItem(_loc5_);
         return _loc5_;
      }
      
      public function createPath(param1:String) : FPackageItem
      {
         this.ensureOpen();
         return this.ensurePathExists(param1,true);
      }
      
      public function createComponentItem(param1:String, param2:int, param3:int, param4:String = null, param5:String = null, param6:Boolean = false, param7:Boolean = false) : FPackageItem
      {
         var _loc12_:XData = null;
         this.ensureOpen();
         if(param4 == null)
         {
            param4 = "/";
         }
         var _loc8_:FPackageItem = this._itemById[param4];
         if(!_loc8_)
         {
            throw new Error("Path not exists");
         }
         param1 = FProject.validateName(param1);
         var _loc9_:* = param1 + ".xml";
         if(param7)
         {
            _loc9_ = this.getUniqueName(null,_loc9_);
         }
         var _loc10_:FPackageItem = new FPackageItem(this,FPackageItemType.COMPONENT,this.getNextId());
         _loc10_.setFile(param4,_loc9_);
         _loc10_.exported = param6;
         if(_loc10_.file.exists)
         {
            throw new Error(Consts.strings.text113);
         }
         var _loc11_:XData = XData.create("component");
         _loc11_.setAttribute("size",param2 + "," + param3);
         if(param5)
         {
            _loc11_.setAttribute("extention",param5);
            _loc12_ = XData.create(param5);
            _loc11_.appendChild(_loc12_);
         }
         UtilsFile.saveXData(_loc10_.file,_loc11_);
         this.addItem(_loc10_);
         return _loc10_;
      }
      
      public function createFontItem(param1:String, param2:String = null, param3:Boolean = false) : FPackageItem
      {
         this.ensureOpen();
         if(param2 == null)
         {
            param2 = "/";
         }
         var _loc4_:FPackageItem = this._itemById[param2];
         if(!_loc4_)
         {
            throw new Error("Path not exists");
         }
         param1 = FProject.validateName(param1);
         var _loc5_:* = param1 + ".fnt";
         if(param3)
         {
            _loc5_ = this.getUniqueName(null,_loc5_);
         }
         var _loc6_:FPackageItem = new FPackageItem(this,FPackageItemType.FONT,this.getNextId());
         _loc6_.setFile(param2,_loc5_);
         _loc6_.exported = true;
         if(_loc6_.file.exists)
         {
            throw new Error(Consts.strings.text113);
         }
         UtilsFile.saveString(_loc6_.file,"info creator=UIBuilder\n");
         this.addItem(_loc6_);
         return _loc6_;
      }
      
      public function createMovieClipItem(param1:String, param2:String = null, param3:Boolean = false) : FPackageItem
      {
         this.ensureOpen();
         if(param2 == null)
         {
            param2 = "/";
         }
         var _loc4_:FPackageItem = this._itemById[param2];
         if(!_loc4_)
         {
            throw new Error("Path not exists");
         }
         param1 = FProject.validateName(param1);
         var _loc5_:* = param1 + ".jta";
         if(param3)
         {
            _loc5_ = this.getUniqueName(null,_loc5_);
         }
         var _loc6_:FPackageItem = new FPackageItem(this,FPackageItemType.MOVIECLIP,this.getNextId());
         _loc6_.setFile(param2,_loc5_);
         if(_loc6_.file.exists)
         {
            throw new Error(Consts.strings.text113);
         }
         var _loc7_:AniDef = new AniDef();
         UtilsFile.saveBytes(_loc6_.file,_loc7_.save());
         this.addItem(_loc6_);
         return _loc6_;
      }
      
      public function importResource(param1:File, param2:String, param3:String, param4:Callback) : void
      {
         var pi:FPackageItem = null;
         var callback2:Callback = null;
         var info:Object = null;
         var ani:AniDef = null;
         var ext:String = null;
         var sourceFile:File = param1;
         var toPath:String = param2;
         var resName:String = param3;
         var callback:Callback = param4;
         var type:String = FPackageItemType.getFileType(sourceFile);
         if(type == null)
         {
            callback.callOnFail();
            return;
         }
         var folderItem:FPackageItem = this.createPath(toPath);
         var fileName:String = !!resName?resName:sourceFile.name;
         if(type == FPackageItemType.MOVIECLIP)
         {
            fileName = UtilsStr.replaceFileExt(fileName,"jta");
         }
         fileName = this.getUniqueName(folderItem,fileName);
         pi = new FPackageItem(this,type,this.getNextId());
         pi.setFile(toPath,fileName);
         callback2 = new Callback();
         callback2.success = function():void
         {
            addItem(pi);
            callback.result = pi;
            callback.callOnSuccess();
         };
         callback2.failed = function():void
         {
            callback.addMsgs(callback2.msgs);
            callback.callOnFail();
         };
         if(type == FPackageItemType.IMAGE)
         {
            info = ResourceSize.getSize(sourceFile);
            if(info && info.type == "svg")
            {
               pi.imageSettings.width = info.width;
               pi.imageSettings.height = info.height;
            }
            UtilsFile.copyFile(sourceFile,pi.file);
            callback2.callOnSuccessImmediately();
         }
         else if(type == FPackageItemType.MOVIECLIP)
         {
            ext = sourceFile.extension.toLowerCase();
            if(ext == "gif")
            {
               this.importGif(pi,sourceFile,callback2);
            }
            else if(ext == "plist" || ext == "eas")
            {
               importMovieClip(pi,sourceFile,callback2);
            }
            else
            {
               ani = new AniDef();
               ani.load(UtilsFile.loadBytes(sourceFile));
               if(ani.frameCount == 0)
               {
                  callback.addMsg(Consts.strings.text116);
                  callback.callOnFailImmediately();
               }
               else
               {
                  UtilsFile.saveBytes(pi.file,ani.save());
                  callback2.callOnSuccessImmediately();
               }
            }
         }
         else if(type == FPackageItemType.FONT)
         {
            this.importFont(pi,sourceFile,callback2);
         }
         else
         {
            UtilsFile.copyFile(sourceFile,pi.file);
            callback2.callOnSuccessImmediately();
         }
      }
      
      public function updateResource(param1:FPackageItem, param2:File, param3:Callback) : void
      {
         var callback2:Callback = null;
         var info:Object = null;
         var ani:AniDef = null;
         var pi:FPackageItem = param1;
         var sourceFile:File = param2;
         var callback:Callback = param3;
         var newType:String = FPackageItemType.getFileType(sourceFile);
         if(newType == null)
         {
            callback.callOnFail();
            return;
         }
         var oldExt:String = UtilsStr.getFileExt(pi.fileName);
         var newExt:String = sourceFile.extension.toLowerCase();
         if(newType != pi.type && !(newType == FPackageItemType.COMPONENT && pi.type == FPackageItemType.MISC))
         {
            callback.addMsg("Source file type mismatched!");
            callback.callOnFail();
            return;
         }
         var folderItem:FPackageItem = this.createPath(pi.path);
         var fileName:String = pi.fileName;
         if((pi.type == FPackageItemType.IMAGE || pi.type == FPackageItemType.SOUND || pi.type == FPackageItemType.MISC) && oldExt != newExt)
         {
            fileName = UtilsStr.replaceFileExt(fileName,newExt);
            if(new File(pi.file.parent.nativePath + "/" + fileName).exists)
            {
               callback.addMsg("File already exists!");
               callback.callOnFail();
               return;
            }
            UtilsFile.deleteFile(pi.file);
            pi.setFile(pi.path,fileName);
            this.save();
         }
         callback2 = new Callback();
         callback2.success = function():void
         {
            pi.setChanged();
            setChanged();
            callback.result = pi;
            callback.callOnSuccess();
         };
         callback2.failed = function():void
         {
            callback.addMsgs(callback2.msgs);
            callback.callOnFail();
         };
         if(pi.type == FPackageItemType.IMAGE)
         {
            info = ResourceSize.getSize(sourceFile);
            if(info && info.type == "svg" && pi.imageSettings.width == 0)
            {
               pi.imageSettings.width = info.width;
               pi.imageSettings.height = info.height;
               this.save();
            }
            UtilsFile.copyFile(sourceFile,pi.file);
            callback2.callOnSuccessImmediately();
         }
         else if(pi.type == FPackageItemType.MOVIECLIP)
         {
            if(newExt == "gif")
            {
               this.importGif(pi,sourceFile,callback2);
            }
            else if(newExt == "plist" || newExt == "eas")
            {
               importMovieClip(pi,sourceFile,callback2);
            }
            else
            {
               ani = new AniDef();
               ani.load(UtilsFile.loadBytes(sourceFile));
               if(ani.frameCount == 0)
               {
                  callback.addMsg(Consts.strings.text116);
                  callback.callOnFailImmediately();
               }
               else
               {
                  UtilsFile.saveBytes(pi.file,ani.save());
                  callback2.callOnSuccessImmediately();
               }
            }
         }
         else if(pi.type == FPackageItemType.FONT)
         {
            this.importFont(pi,sourceFile,callback2);
         }
         else
         {
            UtilsFile.copyFile(sourceFile,pi.file);
            callback2.callOnSuccessImmediately();
         }
      }
      
      private function importFont(param1:FPackageItem, param2:File, param3:Callback) : void
      {
         var pkg:IUIPackage = null;
         var i:int = 0;
         var pngFile:String = null;
         var ttf:Boolean = false;
         var str:String = null;
         var arr:Array = null;
         var j:int = 0;
         var arr2:Array = null;
         var atlasItem:FPackageItem = null;
         var newAtlas:Boolean = false;
         var sourcePngFile:File = null;
         var callback2:Callback = null;
         var pi:FPackageItem = param1;
         var sourceFile:File = param2;
         var callback:Callback = param3;
         pkg = pi.owner;
         var content:String = UtilsFile.loadString(sourceFile);
         var lines:Array = content.split("\n");
         var lineCount:int = lines.length;
         var kv:Object = {};
         i = 0;
         while(i < lineCount)
         {
            str = lines[i];
            if(str)
            {
               str = UtilsStr.trim(str);
               arr = str.split(" ");
               j = 1;
               while(j < arr.length)
               {
                  arr2 = arr[j].split("=");
                  kv[arr2[0]] = arr2[1];
                  j++;
               }
               str = arr[0];
               if(str == "page")
               {
                  pngFile = kv.file.substr(1,kv.file.length - 2);
                  break;
               }
               if(str == "info")
               {
                  ttf = kv.face != null;
               }
               else if(str == "common")
               {
                  if(int(kv.pages) > 1)
                  {
                     callback.addMsg(Consts.strings.text114);
                     callback.callOnFail();
                     return;
                  }
               }
            }
            i++;
         }
         if(ttf)
         {
            if(pi.fontSettings.texture)
            {
               atlasItem = pi.owner.getItem(pi.fontSettings.texture);
            }
            if(!atlasItem)
            {
               atlasItem = new FPackageItem(pkg,FPackageItemType.IMAGE,pkg.getNextId());
               atlasItem.setFile(pi.path,pkg.getUniqueName(pkg.getItem(pi.path),pi.name + "_atlas.png"));
               newAtlas = true;
            }
            else
            {
               atlasItem.setChanged();
            }
            pi.fontSettings.texture = atlasItem.id;
            sourcePngFile = new File(sourceFile.parent.nativePath + "/" + pngFile);
            if(!sourcePngFile.exists)
            {
               sourcePngFile = new File(sourceFile.parent.nativePath + "/" + UtilsStr.replaceFileExt(sourceFile.name,"png"));
            }
            if(!sourcePngFile.exists)
            {
               callback.addMsg("File not found: " + sourcePngFile.nativePath);
               callback.callOnFail();
               return;
            }
            callback2 = new Callback();
            callback2.success = function():void
            {
               UtilsFile.copyFile(sourcePngFile,atlasItem.file);
               UtilsFile.copyFile(sourceFile,pi.file);
               if(newAtlas)
               {
                  pkg.addItem(atlasItem);
               }
               callback.callOnSuccessImmediately();
            };
            callback2.failed = function():void
            {
               callback.addMsgs(callback2.msgs);
               callback.callOnFailImmediately();
            };
            ImageTool.cropImage(sourcePngFile,atlasItem.file,callback2);
         }
         else
         {
            pi.fontSettings.texture = null;
            UtilsFile.copyFile(sourceFile,pi.file);
            callback.callOnSuccess();
         }
      }
      
      private function importGif(param1:FPackageItem, param2:File, param3:Callback) : void
      {
         var tmpFiles:Array = null;
         var tmpFolder:File = null;
         var frameDelays:Array = null;
         var frameCount:int = 0;
         var i:int = 0;
         var gf:GIFFrame = null;
         var delay:int = 0;
         var args:Vector.<String> = null;
         var callback3:Callback = null;
         var bmd:BitmapData = null;
         var tmpFile:File = null;
         var ba:ByteArray = null;
         var pi:FPackageItem = param1;
         var sourceFile:File = param2;
         var callback:Callback = param3;
         var gd:GIFDecoder = new GIFDecoder(UtilsFile.loadBytes(sourceFile));
         tmpFiles = [];
         tmpFolder = File.createTempDirectory();
         frameDelays = [];
         frameCount = gd.getFrameCount();
         if(gd.hasError() || frameCount == 0)
         {
            callback.addMsg("GIF format error!");
            callback.callOnFail();
            return;
         }
         i = 0;
         while(i < frameCount)
         {
            gf = gd.getFrame(i);
            delay = gf.delay > 0?int(gf.delay):100;
            frameDelays[i] = int(delay / 1000 * 24);
            i++;
         }
         if(ImageTool.magickExe.exists)
         {
            args = new Vector.<String>();
            args.push("convert");
            args.push("-coalesce");
            args.push(sourceFile.nativePath);
            args.push(tmpFolder.nativePath + File.separator + "g.png");
            callback3 = new Callback();
            callback3.success = function():void
            {
               if(frameCount == 1)
               {
                  tmpFile = new File(tmpFolder.nativePath + File.separator + "g.png");
                  if(tmpFile.exists)
                  {
                     tmpFiles.push(tmpFile);
                  }
               }
               else
               {
                  i = 0;
                  while(i < frameCount)
                  {
                     tmpFile = new File(tmpFolder.nativePath + File.separator + "g-" + i + ".png");
                     if(tmpFile.exists)
                     {
                        tmpFiles.push(tmpFile);
                     }
                     i++;
                  }
               }
               if(tmpFiles.length == 0)
               {
                  callback.addMsg("GIF format error!");
                  callback.callOnFail();
               }
               else
               {
                  importGif2(pi,sourceFile,tmpFiles,frameDelays,callback);
               }
            };
            callback3.failed = function():void
            {
               callback.addMsg("GIF decode failed!\n" + callback3.msgs.join("\n"));
               callback.callOnFail();
            };
            ImageTool.magick(args,callback3);
         }
         else
         {
            i = 0;
            while(i < frameCount)
            {
               gf = gd.getFrame(i);
               bmd = gf.bitmapData;
               tmpFile = new File(tmpFolder.nativePath + File.separator + i + ".png");
               ba = bmd.encode(bmd.rect,new PNGEncoderOptions());
               UtilsFile.saveBytes(tmpFile,ba);
               tmpFiles[i] = tmpFile;
               i++;
            }
            this.importGif2(pi,sourceFile,tmpFiles,frameDelays,callback);
         }
      }
      
      private function importGif2(param1:FPackageItem, param2:File, param3:Array, param4:Array, param5:Callback) : void
      {
         var callback2:Callback = null;
         var item:FPackageItem = param1;
         var sourceFile:File = param2;
         var framesFiles:Array = param3;
         var frameDelays:Array = param4;
         var callback:Callback = param5;
         callback2 = new Callback();
         callback2.success = function():void
         {
            var ani:AniDef = AniDef(callback2.result);
            var fcnt:int = ani.frameCount;
            var i:int = 0;
            while(i < fcnt)
            {
               ani.frameList[i].delay = int(frameDelays[i]);
               i++;
            }
            UtilsFile.saveBytes(item.file,ani.save());
            if(UtilsStr.startsWith(sourceFile.parent.nativePath,_basePath))
            {
               UtilsFile.deleteFile(sourceFile);
            }
            try
            {
               framesFiles[0].parent.deleteDirectory(true);
            }
            catch(err:Error)
            {
            }
            callback.callOnSuccessImmediately();
         };
         callback2.failed = function():void
         {
            try
            {
               framesFiles[0].parent.deleteDirectory(true);
            }
            catch(err:Error)
            {
            }
            callback.addMsgs(callback2.msgs);
            callback.callOnFailImmediately();
         };
         AniImporter.importImages(framesFiles,!item.owner.project.supportAtlas,callback2);
      }
   }
}
