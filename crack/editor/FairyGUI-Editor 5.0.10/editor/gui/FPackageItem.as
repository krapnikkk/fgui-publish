package fairygui.editor.gui
{
   import com.adobe.crypto.MD5;
   import fairygui.editor.Consts;
   import fairygui.editor.api.IDocument;
   import fairygui.editor.api.IUIPackage;
   import fairygui.editor.gui.animation.AniDef;
   import fairygui.editor.gui.text.FBitmapFont;
   import fairygui.editor.settings.FolderSettings;
   import fairygui.editor.settings.FontSettings;
   import fairygui.editor.settings.GlobalPublishSettings;
   import fairygui.editor.settings.ImageSettings;
   import fairygui.editor.worker.ConvertMessage;
   import fairygui.utils.GTimers;
   import fairygui.utils.PinYinUtil;
   import fairygui.utils.ResourceSize;
   import fairygui.utils.Utils;
   import fairygui.utils.UtilsFile;
   import fairygui.utils.UtilsStr;
   import fairygui.utils.XData;
   import fairygui.utils.loader.EasyLoader;
   import fairygui.utils.loader.LoaderExt;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.filesystem.File;
   import flash.media.Sound;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   
   public class FPackageItem
   {
       
      
      public var exported:Boolean;
      
      public var favorite:Boolean;
      
      public var reviewed:String;
      
      public var §_-e§:String;
      
      public var _errorStatus:Boolean;
      
      private var _id:String;
      
      private var _type:String;
      
      private var _owner:FPackage;
      
      private var _name:String;
      
      private var _path:String;
      
      private var _fileName:String;
      
      private var _branch:String;
      
      private var _file:File;
      
      private var _width:int;
      
      private var _height:int;
      
      private var _sortKey:String;
      
      private var _quickKey:String;
      
      private var _version:int;
      
      private var _lastTouch:int;
      
      private var _modificationTime:Number;
      
      private var _fileSize:Number;
      
      private var _needReload:Boolean;
      
      private var _hash:String;
      
      private var _vars:Object;
      
      private var _loadQueue:Array;
      
      private var _data:Object;
      
      private var _releasedTime:int;
      
      private var _ref:int;
      
      private var _dataVersion:int;
      
      private var _disposed:Boolean;
      
      private var _loading:Boolean;
      
      private var _imageSettings:ImageSettings;
      
      private var _folderSettings:FolderSettings;
      
      private var _fontSettings:FontSettings;
      
      private var _imageInfo:ImageInfo;
      
      private var _children:Vector.<FPackageItem>;
      
      private var _componentExtension:String;
      
      public function FPackageItem(param1:IUIPackage, param2:String, param3:String)
      {
         super();
         this._owner = param1 as FPackage;
         this._type = param2;
         this._id = param3;
         this._vars = {};
         this._needReload = true;
         this._quickKey = null;
         if(param2 == FPackageItemType.IMAGE || param2 == FPackageItemType.MOVIECLIP)
         {
            this._imageSettings = new ImageSettings();
            this._imageInfo = new ImageInfo();
         }
         else if(param2 == FPackageItemType.FOLDER)
         {
            this._folderSettings = new FolderSettings();
            this._children = new Vector.<FPackageItem>();
         }
         else if(param2 == FPackageItemType.FONT)
         {
            this._fontSettings = new FontSettings();
         }
      }
      
      private static function __imageLoaded(param1:LoaderExt) : void
      {
         var _loc2_:Object = param1.content;
         var _loc3_:FPackageItem = FPackageItem(param1.props.pi);
         if(_loc3_._disposed)
         {
            return;
         }
         _loc3_._loading = false;
         if(_loc2_ is Bitmap)
         {
            _loc3_.updateData(_loc2_.bitmapData,param1.props.ver);
         }
         _loc3_.invokeLoadedCallbacks();
      }
      
      public function get owner() : FPackage
      {
         return this._owner;
      }
      
      public function get pkg() : IUIPackage
      {
         return this._owner;
      }
      
      public function get parent() : FPackageItem
      {
         if(this == this._owner.rootItem)
         {
            return null;
         }
         return this._owner.getItem(this._path);
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function set id(param1:String) : void
      {
         this._id = param1;
      }
      
      public function get path() : String
      {
         return this._path;
      }
      
      public function get branch() : String
      {
         return this._branch;
      }
      
      public function get isRoot() : Boolean
      {
         return this._id == "/";
      }
      
      public function get isBranchRoot() : Boolean
      {
         return this._path == "/" && this._branch.length > 0;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get file() : File
      {
         return this._file;
      }
      
      public function get fileName() : String
      {
         return this._fileName;
      }
      
      public function get modificationTime() : Number
      {
         return this._modificationTime;
      }
      
      public function get isError() : Boolean
      {
         return this._errorStatus;
      }
      
      public function matchName(param1:String) : Boolean
      {
         if(this._quickKey == null)
         {
            this._quickKey = PinYinUtil.toPinyin(this._name.substr(0,5),true,false,false).toLowerCase();
         }
         var _loc2_:int = param1.length;
         if(this._quickKey.length < _loc2_)
         {
            return false;
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1.charCodeAt(_loc3_) != this._quickKey.charCodeAt(_loc3_))
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      public function get sortKey() : String
      {
         if(this._sortKey == null)
         {
            this._sortKey = (this._branch.length > 0?"A":"B") + Utils.getStringSortKey(this._name);
         }
         return this._sortKey;
      }
      
      public function getURL() : String
      {
         return "ui://" + this._owner.id + this._id;
      }
      
      public function get version() : int
      {
         return this._version;
      }
      
      public function get width() : Number
      {
         if(this._needReload)
         {
            this.loadInfo();
         }
         return this._width;
      }
      
      public function get height() : Number
      {
         if(this._needReload)
         {
            this.loadInfo();
         }
         return this._height;
      }
      
      public function get children() : Vector.<FPackageItem>
      {
         return this._children;
      }
      
      public function get imageInfo() : ImageInfo
      {
         if(this._needReload)
         {
            this.loadInfo();
         }
         return this._imageInfo;
      }
      
      public function get componentExtension() : String
      {
         if(this._needReload)
         {
            this.loadInfo();
         }
         return this._componentExtension;
      }
      
      public function get imageSettings() : ImageSettings
      {
         return this._imageSettings;
      }
      
      public function get folderSettings() : FolderSettings
      {
         return this._folderSettings;
      }
      
      public function get fontSettings() : FontSettings
      {
         return this._fontSettings;
      }
      
      public function copySettings(param1:FPackageItem) : void
      {
         if(this._type == FPackageItemType.IMAGE || this._type == FPackageItemType.MOVIECLIP)
         {
            this._imageSettings.copyFrom(param1.imageSettings);
         }
         else if(this._type == FPackageItemType.FONT)
         {
            this._fontSettings.copyFrom(param1.fontSettings);
         }
      }
      
      public function setFile(param1:String, param2:String) : void
      {
         var _loc4_:int = 0;
         this._path = param1;
         if(this._path.length > 2 && this._path.charCodeAt(1) == 58)
         {
            _loc4_ = this._path.indexOf("/",2);
            this._branch = this._path.substring(2,_loc4_);
         }
         else if(this._path.length == 1 && param2.charCodeAt(0) == 58)
         {
            this._branch = param2.substring(1);
         }
         else
         {
            this._branch = "";
         }
         this._fileName = param2;
         if(this.type == FPackageItemType.FOLDER)
         {
            this._name = this._fileName;
         }
         else
         {
            this._name = UtilsStr.getFileName(this._fileName);
         }
         this._sortKey = null;
         this._quickKey = null;
         var _loc3_:File = this._file;
         if(this._branch.length > 0)
         {
            if(this._path.length == 1)
            {
               this._file = new File(this._owner.project.basePath + "/assets_" + this._branch + "/" + this._owner.name);
            }
            else
            {
               this._file = new File(this._owner.project.basePath + "/assets_" + this._branch + "/" + this._owner.name + "/" + this._path.substr(this._branch.length + 3) + this._fileName);
            }
         }
         else if(this._path.length == 0)
         {
            this._file = new File(this._owner.basePath);
         }
         else
         {
            this._file = new File(this._owner.basePath + this._path + this._fileName);
         }
         if(_loc3_)
         {
            if(this._imageInfo && this._imageInfo.file == _loc3_)
            {
               this._imageInfo.file = this._file;
            }
         }
         if(this._file.exists)
         {
            this._modificationTime = this._file.modificationDate.time;
            this._fileSize = this._file.size;
            if(this._errorStatus)
            {
               this._errorStatus = false;
               this.setChanged();
            }
         }
         else
         {
            if(!this._errorStatus)
            {
               this._errorStatus = true;
               this.setChanged();
            }
            this._hash = null;
         }
      }
      
      public function setChanged() : void
      {
         this._version++;
         this._needReload = true;
      }
      
      public function touch() : void
      {
         if(this._lastTouch == GTimers.workCount)
         {
            return;
         }
         this._lastTouch = GTimers.workCount;
         if(this._file.exists)
         {
            if(this._modificationTime != this._file.modificationDate.time || this._fileSize != this._file.size)
            {
               this._version++;
               this._modificationTime = this._file.modificationDate.time;
               this._fileSize = this._file.size;
               this._hash = null;
               this._needReload = true;
            }
            if(this._errorStatus)
            {
               this._version++;
               this._errorStatus = false;
            }
         }
         else if(!this._errorStatus)
         {
            this._version++;
            this._errorStatus = true;
         }
      }
      
      public function setUptoDate() : void
      {
         if(this._file.exists)
         {
            this._modificationTime = this._file.modificationDate.time;
            this._fileSize = this._file.size;
         }
      }
      
      public function getComponentData() : ComponentData
      {
         if(this._type != FPackageItemType.COMPONENT)
         {
            throw new Error("invalid call to get componentData");
         }
         if(this._disposed)
         {
            return null;
         }
         if(this._needReload)
         {
            this.loadInfo();
         }
         if(!this._data || this._dataVersion != this._version)
         {
            this.updateData(new ComponentData(this),this._version);
         }
         return ComponentData(this._data);
      }
      
      public function get image() : BitmapData
      {
         return BitmapData(this._data);
      }
      
      public function getImage(param1:Function = null) : BitmapData
      {
         if(this._type != FPackageItemType.IMAGE)
         {
            throw new Error("invalid item status");
         }
         if(this._disposed)
         {
            return null;
         }
         if(this._needReload)
         {
            this.loadInfo();
         }
         if(param1 != null)
         {
            this.addLoadedCallback(param1);
         }
         if(this._data && this._dataVersion == this._version)
         {
            if(param1 != null)
            {
               GTimers.inst.callLater(this.invokeLoadedCallbacks);
            }
            return BitmapData(this._data);
         }
         if(!this._file.exists)
         {
            this.disposeData();
            if(param1 != null)
            {
               GTimers.inst.callLater(this.invokeLoadedCallbacks);
            }
            return null;
         }
         if(!this._loading)
         {
            this._loading = true;
            if(this._imageInfo.needConversion)
            {
               this.convertImage();
            }
            else
            {
               this._imageInfo.file = this._file;
               EasyLoader.load(this._file.url,{
                  "type":"image",
                  "pi":this,
                  "ver":this._version
               },__imageLoaded);
            }
         }
         return null;
      }
      
      public function getAnimation() : AniDef
      {
         var ani:AniDef = null;
         var ba:ByteArray = null;
         if(this._type != FPackageItemType.MOVIECLIP)
         {
            throw new Error("invalid item status");
         }
         if(this._disposed)
         {
            return null;
         }
         if(this._needReload)
         {
            this.loadInfo();
         }
         if(!this._data || this._dataVersion != this._version)
         {
            ba = UtilsFile.loadBytes(this._file);
            if(ba != null)
            {
               try
               {
                  ani = new AniDef();
                  ani.load(ba);
               }
               catch(err:Error)
               {
                  owner.project.logError("load movieclip",err);
               }
            }
            this.updateData(ani,this._version);
         }
         return AniDef(this._data);
      }
      
      public function getBitmapFont() : FBitmapFont
      {
         var _loc1_:FBitmapFont = null;
         if(this._type != FPackageItemType.FONT)
         {
            throw new Error("invalid item status");
         }
         if(this._disposed)
         {
            return null;
         }
         if(this._needReload)
         {
            this.loadInfo();
         }
         if(!this._data || this._dataVersion != this._version)
         {
            _loc1_ = new FBitmapFont(this);
            this.updateData(_loc1_,this._version);
            _loc1_.load();
         }
         return FBitmapFont(this._data);
      }
      
      public function get sound() : Sound
      {
         return Sound(this._data);
      }
      
      public function getSound(param1:Function = null) : Sound
      {
         if(this._type != FPackageItemType.SOUND)
         {
            throw new Error("invalid item status");
         }
         if(this._disposed)
         {
            return null;
         }
         if(this._needReload)
         {
            this.loadInfo();
         }
         if(param1 != null)
         {
            this.addLoadedCallback(param1);
         }
         if(this._data && this._dataVersion == this._version)
         {
            if(param1 != null)
            {
               GTimers.inst.callLater(this.invokeLoadedCallbacks);
            }
            return Sound(this._data);
         }
         if(!this._file.exists)
         {
            this.disposeData();
            if(param1 != null)
            {
               GTimers.inst.callLater(this.invokeLoadedCallbacks);
            }
            return null;
         }
         var _loc2_:String = UtilsStr.getFileExt(this._fileName);
         if(_loc2_ == "mp3")
         {
            this.updateData(new Sound(new URLRequest(this._file.url)),this._version);
            if(param1 != null)
            {
               GTimers.inst.callLater(this.invokeLoadedCallbacks);
            }
            return Sound(this._data);
         }
         if(!this._loading)
         {
            this._loading = true;
            this.convertSound();
         }
         return null;
      }
      
      public function addLoadedCallback(param1:Function) : void
      {
         if(!this._loadQueue)
         {
            this._loadQueue = [];
         }
         var _loc2_:int = this._loadQueue.indexOf(param1);
         if(_loc2_ == -1)
         {
            this._loadQueue.push(param1);
         }
      }
      
      public function removeLoadedCallback(param1:Function) : void
      {
         if(!this._loadQueue)
         {
            return;
         }
         var _loc2_:int = this._loadQueue.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._loadQueue.splice(_loc2_,1);
         }
      }
      
      public function get loading() : Boolean
      {
         return this._loading;
      }
      
      public function invokeLoadedCallbacks() : void
      {
         var _loc3_:Function = null;
         if(!this._loadQueue || this._loadQueue.length == 0)
         {
            return;
         }
         var _loc1_:Array = this._loadQueue.concat();
         this._loadQueue.length = 0;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            _loc3_(this);
            _loc2_++;
         }
      }
      
      public function openWithDefaultApplication() : void
      {
         if(this.isRoot)
         {
            new File(this._owner.basePath + "/package.xml").openWithDefaultApplication();
         }
         else if(this.isBranchRoot)
         {
            new File(this._owner.getBranchPath(this._branch) + "/package_branch.xml").openWithDefaultApplication();
         }
         else
         {
            this._file.openWithDefaultApplication();
         }
      }
      
      private function loadInfo() : void
      {
         var _loc1_:IDocument = null;
         var _loc2_:XData = null;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:GlobalPublishSettings = null;
         this._needReload = false;
         this._width = this._height = 0;
         if(this._type == FPackageItemType.COMPONENT)
         {
            _loc1_ = this._vars.doc;
            if(_loc1_ && _loc1_.content)
            {
               this._width = _loc1_.content.width;
               this._height = _loc1_.content.height;
               this._componentExtension = _loc1_.content.extentionId;
            }
            else
            {
               _loc2_ = UtilsFile.loadXMLRoot(this._file);
               if(_loc2_)
               {
                  _loc3_ = _loc2_.getAttribute("size");
                  if(_loc3_)
                  {
                     _loc4_ = _loc3_.split(",");
                     this._width = parseInt(_loc4_[0]);
                     this._height = parseInt(_loc4_[1]);
                  }
                  _loc3_ = _loc2_.getAttribute("extention");
                  if(_loc3_)
                  {
                     this._componentExtension = _loc3_;
                  }
               }
            }
            if(this._componentExtension == null)
            {
               this._componentExtension = "";
            }
         }
         else if(this._imageInfo != null)
         {
            _loc5_ = this._file.extension;
            if(_loc5_ && _loc5_.toLowerCase() == "svg")
            {
               this._imageInfo.format = "svg";
               this._width = this._imageSettings.width;
               this._height = this._imageSettings.height;
            }
            else
            {
               _loc6_ = ResourceSize.getSize(this._file);
               if(_loc6_)
               {
                  this._imageInfo.format = _loc6_.type;
                  this._width = _loc6_.width;
                  this._height = _loc6_.height;
               }
               else
               {
                  this._imageInfo.format = "png";
               }
            }
            switch(this._imageSettings.qualityOption)
            {
               case ImageSettings.QUALITY_DEFAULT:
                  if(this.owner.project.supportAtlas)
                  {
                     this._imageInfo.targetQuality = 100;
                  }
                  else
                  {
                     _loc7_ = GlobalPublishSettings(this._owner.project.getSettings("publish"));
                     if(this._imageInfo.format == "jpg")
                     {
                        this._imageInfo.targetQuality = _loc7_.jpegQuality;
                     }
                     else
                     {
                        this._imageInfo.targetQuality = !!_loc7_.compressPNG?8:100;
                     }
                  }
                  break;
               case ImageSettings.QUALITY_SOURCE:
                  this._imageInfo.targetQuality = 100;
                  break;
               case ImageSettings.QUALITY_CUSTOM:
                  if(this._imageInfo.format == "jpg")
                  {
                     this._imageInfo.targetQuality = this._imageSettings.quality;
                  }
                  else
                  {
                     this._imageInfo.targetQuality = this._imageSettings.quality != 100?8:100;
                  }
                  break;
               default:
                  this._imageInfo.targetQuality = 100;
            }
         }
         else
         {
            _loc6_ = ResourceSize.getSize(this._file);
            if(_loc6_)
            {
               this._width = _loc6_.width;
               this._height = _loc6_.height;
            }
         }
      }
      
      private function updateHash() : void
      {
         var _loc1_:ByteArray = UtilsFile.loadBytes(this.file);
         if(_loc1_ != null)
         {
            this._hash = MD5.hashBinary(_loc1_);
            _loc1_.clear();
         }
      }
      
      public function updateReviewStatus() : Boolean
      {
         if(this._hash == null)
         {
            this.updateHash();
         }
         if(this.reviewed != this._hash)
         {
            this.reviewed = this._hash;
            return true;
         }
         return false;
      }
      
      public function get isReviewStatusUpdated() : Boolean
      {
         if(this._hash == null)
         {
            this.updateHash();
         }
         return this.reviewed == this._hash;
      }
      
      public function get title() : String
      {
         if(this._branch.length > 0 && this._path.length == 1)
         {
            return this._branch;
         }
         return this._name;
      }
      
      public function getIcon(param1:Boolean = false) : String
      {
         var _loc2_:String = null;
         if(this._type == FPackageItemType.FOLDER)
         {
            if(this._path == "/" && this._branch.length > 0)
            {
               return Consts.icons.branch;
            }
            if(param1)
            {
               if(this._id == "/")
               {
                  return Consts.icons["package_open"];
               }
               return Consts.icons.folder_open;
            }
            if(this._id == "/")
            {
               return Consts.icons["package"];
            }
            return Consts.icons.folder;
         }
         if(this._type == FPackageItemType.COMPONENT)
         {
            _loc2_ = Consts.icons[this.componentExtension];
            if(_loc2_)
            {
               return _loc2_;
            }
            return Consts.icons.component;
         }
         return Consts.icons[this._type];
      }
      
      public function getBranch() : FPackageItem
      {
         return FProject(this._owner.project).getBranch(this);
      }
      
      public function getHighResolution(param1:int) : FPackageItem
      {
         var _loc3_:FPackageItem = null;
         var _loc2_:String = this._path + this._name;
         while(param1 > 0)
         {
            _loc3_ = this._owner.getItemByPath(_loc2_ + "@" + (param1 + 1) + "x");
            if(_loc3_ && _loc3_.type == this._type)
            {
               return _loc3_;
            }
            param1--;
         }
         return this;
      }
      
      public function getAtlasIndex() : int
      {
         var _loc2_:FPackageItem = null;
         var _loc1_:String = this._imageSettings.atlas;
         if(_loc1_ == "default")
         {
            _loc2_ = this.parent;
            while(_loc2_ != this._owner.rootItem)
            {
               if(!_loc2_.folderSettings.empty && _loc2_.folderSettings.atlas != "default")
               {
                  _loc1_ = _loc2_.folderSettings.atlas;
                  break;
               }
               _loc2_ = _loc2_.parent;
            }
         }
         switch(_loc1_)
         {
            case "default":
               return 0;
            case "alone":
               return -1;
            case "alone_npot":
               return -2;
            case "alone_mof":
               return -3;
            default:
               return int(parseInt(_loc1_));
         }
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
      
      public function toString() : String
      {
         return this._name;
      }
      
      public function addRef() : void
      {
         this._ref++;
      }
      
      public function releaseRef() : void
      {
         if(this._ref > 0)
         {
            this._ref--;
         }
         if(this._ref == 0)
         {
            this._releasedTime = getTimer();
         }
      }
      
      public function get isDisposed() : Boolean
      {
         return this._disposed;
      }
      
      private function updateData(param1:Object, param2:int) : void
      {
         if(this._data && this._data != param1)
         {
            this.disposeData();
         }
         this._data = param1;
         this._dataVersion = param2;
      }
      
      public function tryDisposeData(param1:int = 0) : Boolean
      {
         if(this._data && this._ref == 0 && (!this._loadQueue || this._loadQueue.length == 0) && (param1 == 0 || param1 - this._releasedTime > 10000))
         {
            this.disposeData();
            return true;
         }
         return false;
      }
      
      public function disposeData() : void
      {
         if(!this._data)
         {
            return;
         }
         switch(this._type)
         {
            case FPackageItemType.MOVIECLIP:
               AniDef(this._data).reset();
               break;
            case FPackageItemType.IMAGE:
               BitmapData(this._data).dispose();
               break;
            case FPackageItemType.FONT:
               FBitmapFont(this._data).dispose();
               break;
            case FPackageItemType.COMPONENT:
               ComponentData(this._data).dispose();
               break;
            case FPackageItemType.SOUND:
               try
               {
                  Sound(this._data).close();
               }
               catch(err:*)
               {
               }
         }
         this._data = null;
      }
      
      public function dispose() : void
      {
         this.disposeData();
         this._version++;
         this._disposed = true;
      }
      
      public function serialize(param1:Boolean = false) : XData
      {
         var _loc2_:XData = XData.create(this._type);
         if(param1)
         {
            _loc2_.setAttribute("id",this.§_-e§);
            _loc2_.setAttribute("name",this._name);
         }
         else
         {
            _loc2_.setAttribute("id",this._id);
            _loc2_.setAttribute("name",this._fileName);
         }
         if(this._branch.length > 0 && this._path.length > 1)
         {
            _loc2_.setAttribute("path",this._path.substr(this._branch.length + 2));
         }
         else
         {
            _loc2_.setAttribute("path",this._path);
         }
         if(param1)
         {
            _loc2_.setAttribute("size",this.width + "," + this.height);
         }
         if(this.exported)
         {
            _loc2_.setAttribute("exported",this.exported);
         }
         if(this.favorite && !param1)
         {
            _loc2_.setAttribute("favorite",this.favorite);
         }
         if(this._imageSettings)
         {
            this._imageSettings.write(this,_loc2_,param1);
         }
         else if(this._fontSettings)
         {
            this._fontSettings.write(this,_loc2_,param1);
         }
         else if(this._folderSettings)
         {
            this._folderSettings.write(this,_loc2_,param1);
         }
         if(!param1 && this.reviewed)
         {
            _loc2_.setAttribute("reviewed",this.reviewed);
         }
         return _loc2_;
      }
      
      private function convertImage() : void
      {
         var cacheFolder:File = null;
         var file:File = null;
         var info:Object = null;
         try
         {
            cacheFolder = this.owner.cacheFolder;
            file = cacheFolder.resolvePath(this._id);
            if(file.exists)
            {
               info = UtilsFile.loadJSON(cacheFolder.resolvePath(this._id + ".info"));
               if(info)
               {
                  if(info.modificationDate == this._modificationTime && info.fileSize == this._fileSize && info.format == this._imageInfo.format && info.quality == this._imageInfo.targetQuality && (info.format != "svg" || info.width == this._imageSettings.width && info.height == this._imageSettings.height))
                  {
                     this._imageInfo.file = file;
                     EasyLoader.load(file.url,{
                        "type":"image",
                        "pi":this,
                        "ver":this._version
                     },__imageLoaded);
                     return;
                  }
               }
               UtilsFile.deleteFile(file);
            }
         }
         catch(err:Error)
         {
            _owner.project.logError("convertImage",err);
         }
         this._vars.converting = true;
         var vo:ConvertMessage = new ConvertMessage();
         vo.pkgId = this._owner.id;
         vo.itemId = this._id;
         vo.sourceFile = this._file.nativePath;
         vo.targetFile = file.nativePath;
         vo.format = this._imageInfo.format;
         vo.quality = this._imageInfo.targetQuality;
         vo.width = this._imageSettings.width;
         vo.height = this._imageSettings.height;
         vo.version = this._version;
         this._owner.project.asyncRequest("convert",vo,this.onConverted,this.onConvertFailed);
      }
      
      private function convertSound() : void
      {
         var cacheFolder:File = null;
         var file:File = null;
         var info:Object = null;
         try
         {
            cacheFolder = this.owner.cacheFolder;
            file = cacheFolder.resolvePath(this._id);
            if(file.exists)
            {
               info = UtilsFile.loadJSON(cacheFolder.resolvePath(this._id + ".info"));
               if(info)
               {
                  if(info.modificationDate == this._modificationTime && info.fileSize == this._fileSize)
                  {
                     this.updateData(new Sound(new URLRequest(file.url)),this._version);
                     this.invokeLoadedCallbacks();
                     return;
                  }
               }
            }
         }
         catch(err:Error)
         {
            _owner.project.logError("convertSound",err);
         }
         this._vars.converting = true;
         var vo:ConvertMessage = new ConvertMessage();
         vo.pkgId = this._owner.id;
         vo.itemId = this._id;
         vo.sourceFile = this._file.nativePath;
         vo.targetFile = file.nativePath;
         vo.format = "sound";
         vo.version = this._version;
         this.owner.project.asyncRequest("convert",vo,this.onConverted,this.onConvertFailed);
      }
      
      private function onConverted(param1:ConvertMessage) : void
      {
         if(this._disposed)
         {
            return;
         }
         this._vars.converting = false;
         if(this._type == FPackageItemType.SOUND)
         {
            this._loading = false;
            this.updateData(new Sound(new URLRequest(new File(param1.targetFile).url)),param1.version);
            this.invokeLoadedCallbacks();
         }
         else
         {
            this._imageInfo.file = new File(param1.targetFile);
            EasyLoader.load(this._imageInfo.file.url,{
               "type":"image",
               "pi":this,
               "ver":param1.version
            },__imageLoaded);
         }
      }
      
      private function onConvertFailed(param1:String, param2:ConvertMessage) : void
      {
         if(this._disposed)
         {
            return;
         }
         this._vars.converting = false;
         this._owner.project.logError("convert-response: " + this._name + "@" + this._owner.name + "(" + param2.itemId + "," + param2.pkgId + ") " + param1);
         this._loading = false;
         this.invokeLoadedCallbacks();
      }
   }
}
