package fairygui.editor.gui
{
   import fairygui.editor.ComDocument;
   import fairygui.editor.settings.ImageSetting;
   import fairygui.editor.utils.PinYinUtil;
   import fairygui.editor.utils.ResourceSize;
   import fairygui.editor.utils.Utils;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.tree.TreeNode;
   import fairygui.utils.GTimers;
   import flash.filesystem.File;
   
   public class EPackageItem
   {
      
      public static const FOLDER:String = "folder";
      
      public static const IMAGE:String = "image";
      
      public static const MOVIECLIP:String = "movieclip";
      
      public static const SOUND:String = "sound";
      
      public static const COMPONENT:String = "component";
      
      public static const ATLAS:String = "atlas";
      
      public static const FONT:String = "font";
      
      public static const SWF:String = "swf";
      
      public static const MISC:String = "misc";
      
      public static const DRAGONBONE:String = "dragonbone";
      
      public static const VIDEO:String = "video";
       
      
      public var id:String;
      
      public var name:String;
      
      public var type:String;
      
      public var path:String;
      
      public var fileName:String;
      
      public var owner:EUIPackage;
      
      public var exported:Boolean;
      
      public var children:Vector.<EPackageItem>;
      
      public var favorite:Boolean;
      
      public var treeNode:TreeNode;
      
      public var errorStatus:int;
      
      public var nodeStatus:int;
      
      public var addedToPublish:Boolean;
      
      public var generatingCache:Boolean;
      
      public var testPanelScale:Number;
      
      public var testPanelScreenSize:String;
      
      public var data:Object;
      
      public var dataVersion:int;
      
      public var fontTexture:String;
      
      public var loadQueue:Array;
      
      public var callbackParam:Object;
      
      private var _file:File;
      
      private var _width:int;
      
      private var _height:int;
      
      private var _sortKey:String;
      
      private var _firstLetter:String;
      
      private var _version:int;
      
      private var _lastTouch:int;
      
      private var _modificationTime:Number;
      
      private var _fileSize:Number;
      
      private var _imageInfo:ImageInfo;
      
      private var _imageSetting:ImageSetting;
      
      private var _needRefresh:Boolean;
      
      public var customExtention:String = "";
      
      private var _boneName:String = "";
      
      public var armatureName:String = "";
      
      public var boneType:int = 1;
      
      public function EPackageItem(param1:EUIPackage, param2:String)
      {
         super();
         this.owner = param1;
         this.type = param2;
         if(param2 == "image" || param2 == "movieclip")
         {
            this._imageInfo = new ImageInfo();
            this._imageSetting = new ImageSetting();
         }
         this._needRefresh = true;
         this.testPanelScale = 1;
      }
      
      public function set boneName(param1:String) : void
      {
         this._boneName = param1;
      }
      
      public function get boneName() : String
      {
         return this._boneName;
      }
      
      public function get version() : int
      {
         this.touch();
         return this._version;
      }
      
      public function set version(param1:int) : void
      {
         this._version = param1;
      }
      
      public function get width() : Number
      {
         this.touch();
         if(this._needRefresh)
         {
            this.refresh();
         }
         return this._width;
      }
      
      public function get height() : Number
      {
         this.touch();
         if(this._needRefresh)
         {
            this.refresh();
         }
         return this._height;
      }
      
      public function get firstLetter() : String
      {
         if(this._firstLetter == null)
         {
            this._firstLetter = PinYinUtil.toPinyin2(this.name.charAt(0));
         }
         return this._firstLetter;
      }
      
      public function get sortKey() : String
      {
         if(this._sortKey == null)
         {
            this._sortKey = Utils.getStringSortKey(this.name);
         }
         return this._sortKey;
      }
      
      public function set sortKey(param1:String) : void
      {
         this._sortKey = param1;
         this._firstLetter = null;
      }
      
      public function getURL() : String
      {
         return "ui://" + this.owner.id + this.id;
      }
      
      public function get file() : File
      {
         if(this._file == null)
         {
            this._file = new File(this.owner.basePath + this.path + this.fileName);
         }
         return this._file;
      }
      
      public function get modificationTime() : Number
      {
         return this._modificationTime;
      }
      
      public function get fileSize() : Number
      {
         return this._fileSize;
      }
      
      public function get imageInfo() : ImageInfo
      {
         this.touch();
         if(this._needRefresh)
         {
            this.refresh();
         }
         return this._imageInfo;
      }
      
      public function get imageSetting() : ImageSetting
      {
         return this._imageSetting;
      }
      
      public function init() : void
      {
         var _loc1_:Boolean = this._imageInfo && this._imageInfo.file == this._file;
         this._file = new File(this.owner.basePath + this.path + this.fileName);
         if(_loc1_)
         {
            this._imageInfo.file = this._file;
         }
         if(this._file.exists)
         {
            this._modificationTime = this._file.modificationDate.time;
            this._fileSize = this._file.size;
            this.errorStatus = 0;
         }
         else
         {
            this.errorStatus = 1;
         }
      }
      
      public function relocate() : void
      {
         this.init();
      }
      
      public function invalidate() : void
      {
         this._version++;
         this._needRefresh = true;
      }
      
      public function touch() : void
      {
         if(this._lastTouch == GTimers.workCount || this.owner.publishing)
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
               this._needRefresh = true;
            }
            if(this.errorStatus != 0)
            {
               this._version++;
               this.errorStatus = 0;
            }
         }
         else if(this.errorStatus == 0)
         {
            this._version++;
            this.errorStatus = 1;
         }
      }
      
      public function invokeCallbacks() : void
      {
         var _loc1_:Function = null;
         if(!this.loadQueue)
         {
            return;
         }
         var _loc3_:Array = this.loadQueue.concat();
         this.loadQueue.length = 0;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_.length)
         {
            _loc1_ = _loc3_[_loc2_];
            _loc1_(this);
            _loc2_++;
         }
      }
      
      public function removeCallback(param1:Function) : void
      {
         if(!this.loadQueue)
         {
            return;
         }
         var _loc2_:int = this.loadQueue.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.loadQueue.splice(_loc2_,1);
         }
      }
      
      private function refresh() : void
      {
         var _loc4_:ComDocument = null;
         var _loc3_:String = null;
         var _loc1_:Array = null;
         var _loc2_:Object = null;
         this._needRefresh = false;
         var _loc5_:int = 0;
         this._height = _loc5_;
         this._width = _loc5_;
         if(this.type == "component")
         {
            _loc4_ = this.owner.project.editorWindow.mainPanel.editPanel.findComDocument(this.owner,this.id);
            if(_loc4_ && _loc4_.editingContent)
            {
               this._width = _loc4_.editingContent.width;
               this._height = _loc4_.editingContent.height;
            }
            else
            {
               _loc3_ = UtilsFile.loadString(this._file,null,200);
               if(_loc3_)
               {
                  _loc3_ = UtilsStr.getBetweenSymbol(_loc3_,"size=\"","\"");
                  if(_loc3_)
                  {
                     _loc1_ = _loc3_.split(",");
                     this._width = parseInt(_loc1_[0]);
                     this._height = parseInt(_loc1_[1]);
                  }
               }
            }
         }
         else
         {
            _loc2_ = ResourceSize.getSize(this._file);
            if(_loc2_)
            {
               this._width = _loc2_.width;
               this._height = _loc2_.height;
            }
         }
         if(this._imageInfo != null)
         {
            if(_loc2_)
            {
               this._imageInfo.format = _loc2_.type;
            }
            else
            {
               this._imageInfo.format = "png";
            }
            this._imageInfo.targetQuality = this.owner.getImageQuality(this);
         }
      }
      
      public function serialize(param1:Boolean = false) : XML
      {
         var _loc2_:* = null;
         _loc2_ = null;
         var _loc3_:XML = new XML("<" + this.type + "/>");
         _loc3_.@id = this.id;
         if(param1)
         {
            _loc3_.@name = UtilsStr.getFileName(this.fileName);
         }
         else
         {
            _loc3_.@name = this.fileName;
         }
         _loc3_.@path = this.path;
         if(this.customExtention == "")
         {
            if(this.data && this.data is XML)
            {
               _loc2_ = this.data.@customExtention;
               if(_loc2_ != null && _loc2_ != "" && _loc2_ != "\"\"")
               {
                  this.customExtention = _loc2_;
               }
               else
               {
                  this.customExtention = "";
               }
            }
         }
         if(this.customExtention != "")
         {
            if(this.data && this.data is XML)
            {
               _loc2_ = this.data.@customExtention;
               if(_loc2_ != null && _loc2_ != "" && _loc2_ != "\"\"")
               {
                  this.customExtention = _loc2_;
               }
               else
               {
                  this.customExtention = "";
               }
            }
         }
         _loc3_.@customExtention = this.customExtention;
         if(param1)
         {
            _loc3_.@size = this.width + "," + this.height;
         }
         if(this.exported)
         {
            _loc3_.@exported = this.exported;
         }
         if(this.exported)
         {
            _loc3_.@exported = this.exported;
         }
         if(this.favorite)
         {
            _loc3_.@favorite = this.favorite;
         }
         if(this.type == "image")
         {
            if(this._imageSetting.scaleOption != "none")
            {
               _loc3_.@scale = this._imageSetting.scaleOption;
            }
            if(!this._imageSetting.scale9Grid.isEmpty())
            {
               _loc3_.@scale9grid = this._imageSetting.scale9Grid.x + "," + this._imageSetting.scale9Grid.y + "," + this._imageSetting.scale9Grid.width + "," + this._imageSetting.scale9Grid.height;
            }
            if(this._imageSetting.gridTile != 0)
            {
               _loc3_.@gridTile = this._imageSetting.gridTile;
            }
            if(this._imageSetting.qualityOption != "default" && !param1)
            {
               _loc3_.@qualityOption = this._imageSetting.qualityOption;
            }
            if(this._imageSetting.qualityOption == "custom" && !param1)
            {
               _loc3_.@quality = this._imageSetting.quality;
            }
            if(!this._imageSetting.smoothing)
            {
               _loc3_.@smoothing = "false";
            }
            if(this._imageSetting.atlas != "0" && !param1)
            {
               _loc3_.@atlas = this._imageSetting.atlas;
            }
         }
         else if(this.type == "movieclip")
         {
            if(!this._imageSetting.smoothing)
            {
               _loc3_.@smoothing = "false";
            }
            if(this._imageSetting.atlas != "0" && !param1)
            {
               _loc3_.@atlas = this._imageSetting.atlas;
            }
         }
         else if(this.type == "font")
         {
            if(this.fontTexture)
            {
               _loc3_.@texture = this.fontTexture;
            }
         }
         else if(this.type == "dragonbone")
         {
            _loc3_.@boneName = this.boneName;
            _loc3_.@armatureName = this.armatureName;
            _loc3_.@boneType = this.boneType;
         }
         return _loc3_;
      }
      
      public function toString() : String
      {
         return this.name;
      }
   }
}
