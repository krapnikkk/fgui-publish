package fairygui.editor.gui
{
   import fairygui.editor.ComDocument;
   import fairygui.editor.Consts;
   import fairygui.editor.animation.AniDef;
   import fairygui.editor.animation.AniImporter;
   import fairygui.editor.animation.BoneDef;
   import fairygui.editor.gui.text.EBitmapFont;
   import fairygui.editor.handlers.PackageRefreshHandler;
   import fairygui.editor.loader.EasyLoader;
   import fairygui.editor.loader.LoaderExt;
   import fairygui.editor.plugin.IEditorUIPackage;
   import fairygui.editor.settings.AtlasSettings;
   import fairygui.editor.settings.ImageSetting;
   import fairygui.editor.settings.PublishSettings;
   import fairygui.editor.utils.Callback;
   import fairygui.editor.utils.GIFDecoder;
   import fairygui.editor.utils.GIFFrame;
   import fairygui.editor.utils.ImageTool;
   import fairygui.editor.utils.ResourceSize;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.utils.GTimers;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.PNGEncoderOptions;
   import flash.filesystem.File;
   import flash.media.Sound;
   import flash.net.URLRequest;
   import flash.system.System;
   import flash.utils.ByteArray;
   
   public class EUIPackage implements IEditorUIPackage
   {
      
      private static var helperList:Array = [];
       
      
      private var _project:EUIProject;
      
      private var _id:String;
      
      private var _basePath:String;
      
      private var _nextId:uint;
      
      private var _opened:Boolean;
      
      private var _opening:Boolean;
      
      private var _rootItem:EPackageItem;
      
      private var _itemList:Vector.<EPackageItem>;
      
      private var _items:Object;
      
      private var _publishSettings:PublishSettings;
      
      private var _jpegQuality:int;
      
      private var _compressPNG:Boolean;
      
      private var _refreshHandler:PackageRefreshHandler;
      
      public var needSave:Boolean;
      
      public var descModification:Number;
      
      public var descFileSize:Number;
      
      public var publishing:Boolean;
      
      public function EUIPackage(param1:EUIProject, param2:String)
      {
         var _loc6_:File = null;
         var _loc4_:String = null;
         var _loc3_:* = param1;
         var _loc5_:* = param2;
         super();
         this._project = _loc3_;
         this._basePath = _loc3_.assetsPath + File.separator + _loc5_;
         this._items = {};
         this._itemList = new Vector.<EPackageItem>();
         this._refreshHandler = new PackageRefreshHandler(this);
         this._rootItem = new EPackageItem(this,"folder");
         this._rootItem.id = "/";
         this._rootItem.name = _loc5_;
         this._rootItem.fileName = "";
         this._rootItem.path = "";
         this._rootItem.children = new Vector.<EPackageItem>();
         this._items["/"] = this._rootItem;
         this._rootItem.init();
         try
         {
            _loc6_ = new File(this._basePath + File.separator + "package.xml");
            _loc4_ = UtilsFile.loadString(_loc6_,null,500);
            this._id = UtilsStr.getBetweenSymbol(_loc4_,"id=\"","\"");
            if(this._id === null)
            {
               this._rootItem.errorStatus = 1;
               this._id = UtilsStr.generateUID();
               return;
            }
            _loc4_ = UtilsStr.getBetweenSymbol(_loc4_,"hasFavorites=\"","\"");
            this._rootItem.favorite = _loc4_ == "true";
            return;
            return;
         }
         catch(err:Error)
         {
            _rootItem.errorStatus = 2;
            _id = UtilsStr.generateUID();
            return;
         }
      }
      
      public function get opened() : Boolean
      {
         return this._opened;
      }
      
      public function get project() : EUIProject
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
      
      public function get resources() : Vector.<EPackageItem>
      {
         return this._itemList;
      }
      
      public function get publishSettings() : PublishSettings
      {
         this.ensureOpen();
         return this._publishSettings;
      }
      
      public function get jpegQuality() : int
      {
         this.ensureOpen();
         return this._jpegQuality;
      }
      
      public function set jpegQuality(param1:int) : void
      {
         this.ensureOpen();
         this._jpegQuality = param1;
      }
      
      public function get compressPNG() : Boolean
      {
         this.ensureOpen();
         return this._compressPNG;
      }
      
      public function set compressPNG(param1:Boolean) : void
      {
         this.ensureOpen();
         this._compressPNG = param1;
      }
      
      public function get rootItem() : EPackageItem
      {
         return this._rootItem;
      }
      
      public function toString() : String
      {
         return this._rootItem.name;
      }
      
      public function open() : void
      {
         var _loc7_:XML = null;
         var _loc19_:XML = null;
         var _loc13_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc16_:XML = null;
         var _loc20_:EPackageItem = null;
         var _loc8_:File = null;
         var _loc6_:AtlasSettings = null;
         var _loc11_:EPackageItem = null;
         var _loc17_:int = 0;
         var _loc5_:ImageSetting = null;
         var _loc22_:Boolean = this._opened;
         this._opened = true;
         this._opening = true;
         this._itemList.length = 0;
         var _loc12_:Object = this._items;
         this._items = {"/":this._rootItem};
         this._rootItem.children.length = 0;
         XML.ignoreWhitespace = true;
         try
         {
            _loc8_ = new File(this._basePath + "/package.xml");
            _loc13_ = UtilsFile.loadString(_loc8_);
            _loc7_ = new XML(_loc13_);
            this.descModification = _loc8_.modificationDate.time;
            this.descFileSize = _loc8_.size;
         }
         catch(e:Error)
         {
            _rootItem.errorStatus = 1;
            _opening = false;
            return;
         }
         _loc13_ = _loc7_.@jpegQuality;
         this._jpegQuality = parseInt(_loc13_);
         if(this._jpegQuality == 0)
         {
            this._jpegQuality = 80;
         }
         _loc13_ = _loc7_.@compressPNG;
         this._compressPNG = _loc13_ != "false";
         this._nextId = 0;
         _loc19_ = _loc7_.publish[0];
         if(_loc19_ == null)
         {
            _loc19_ = <publish/>;
         }
         this._publishSettings = new PublishSettings();
         this._publishSettings.fileName = _loc19_.@name;
         if(this._publishSettings.fileName == null)
         {
            this._publishSettings.fileName = "";
         }
         this._publishSettings.filePath = _loc19_.@path;
         _loc13_ = _loc19_.@packageCount;
         if(_loc13_)
         {
            this._publishSettings.packageCount = parseInt(_loc13_);
         }
         else
         {
            this._publishSettings.packageCount = 0;
         }
         this._publishSettings.genCode = _loc19_.@genCode == "true";
         _loc13_ = _loc19_.@maxAtlasSize;
         if(_loc13_)
         {
            _loc4_ = parseInt(_loc13_);
         }
         else
         {
            _loc4_ = 2048;
         }
         var _loc21_:* = _loc19_.@npot == "true";
         var _loc18_:* = _loc19_.@square == "true";
         var _loc15_:* = _loc19_.@rotation == "true";
         var _loc14_:* = _loc19_.@extractAlpha == "true";
         var _loc2_:* = _loc19_.@multiPage != "false";
         var _loc10_:XMLList = _loc19_.atlas;
         var _loc9_:int = 0;
         while(_loc9_ < this._publishSettings.atlasList.length)
         {
            _loc6_ = this._publishSettings.atlasList[_loc9_];
            _loc6_.name = "";
            _loc6_.pot = !_loc21_;
            _loc6_.square = _loc18_;
            _loc6_.rotation = _loc15_;
            var _loc25_:* = _loc4_;
            _loc6_.maxWidth = _loc25_;
            _loc6_.maxHeight = _loc25_;
            _loc6_.extractAlpha = _loc14_;
            _loc6_.compression = false;
            _loc6_.multiPage = _loc2_;
            _loc9_++;
         }
         var _loc27_:int = 0;
         var _loc26_:* = _loc10_;
         for each(_loc16_ in _loc10_)
         {
            _loc6_ = this._publishSettings.atlasList[_loc16_.@index];
            _loc6_.name = _loc16_.@name;
            _loc6_.compression = _loc16_.@compression == "true";
         }
         _loc13_ = _loc19_.@excluded;
         if(_loc13_)
         {
            this._publishSettings.excludedList = _loc13_.split(",");
         }
         else
         {
            this._publishSettings.excludedList.length = 0;
         }
         this.listAllFolders(this._rootItem,new File(this._basePath),_loc12_);
         this._rootItem.favorite = false;
         var _loc1_:XMLList = _loc7_.resources.elements();
         var _loc29_:int = 0;
         var _loc28_:* = _loc1_;
         for each(_loc19_ in _loc1_)
         {
            _loc13_ = _loc19_.@id;
            if(_loc22_)
            {
               _loc20_ = _loc12_[_loc13_];
               if(!_loc20_)
               {
                  _loc20_ = new EPackageItem(this,_loc19_.name().localName);
               }
            }
            else
            {
               _loc20_ = this._items[_loc13_];
               if(!_loc20_)
               {
                  _loc20_ = new EPackageItem(this,_loc19_.name().localName);
               }
               else
               {
                  continue;
               }
            }
            _loc20_.id = _loc13_;
            _loc20_.fileName = _loc19_.@name;
            _loc20_.name = UtilsStr.getFileName(_loc20_.fileName);
            _loc20_.path = _loc19_.@path;
            if(_loc19_.@customExtention != null && _loc19_.@customExtention != "" && _loc19_.@customExtention != "\"\"")
            {
               _loc20_.customExtention = _loc19_.@customExtention;
            }
            if(_loc20_.path.length == 0)
            {
               _loc20_.path = "/";
            }
            else
            {
               if(_loc20_.path.charAt(0) != "/")
               {
                  _loc20_.path = "/" + _loc20_.path;
               }
               if(_loc20_.path.charAt(_loc20_.path.length - 1) != "/")
               {
                  _loc20_.path = _loc20_.path + "/";
               }
            }
            _loc20_.exported = _loc19_.@exported == "true";
            _loc20_.favorite = _loc19_.@favorite == "true";
            if(_loc20_.favorite)
            {
               this._rootItem.favorite = true;
            }
            if(_loc20_.type == "image")
            {
               _loc5_ = _loc20_.imageSetting;
               _loc13_ = _loc19_.@scale;
               if(_loc13_)
               {
                  _loc5_.scaleOption = _loc13_;
               }
               _loc13_ = _loc19_.@scale9grid;
               if(_loc13_)
               {
                  _loc3_ = _loc13_.split(",");
                  _loc5_.scale9Grid.x = _loc3_[0];
                  _loc5_.scale9Grid.y = _loc3_[1];
                  _loc5_.scale9Grid.width = _loc3_[2];
                  _loc5_.scale9Grid.height = _loc3_[3];
               }
               _loc13_ = _loc19_.@gridTile;
               if(_loc13_)
               {
                  _loc5_.gridTile = parseInt(_loc13_);
               }
               else
               {
                  _loc5_.gridTile = 0;
               }
               _loc13_ = _loc19_.@qualityOption;
               if(_loc13_)
               {
                  _loc5_.qualityOption = _loc13_;
               }
               _loc13_ = _loc19_.@quality;
               if(_loc13_)
               {
                  _loc5_.quality = int(_loc13_);
               }
               else
               {
                  _loc5_.quality = this._jpegQuality;
               }
               _loc5_.smoothing = _loc19_.@smoothing != "false";
               _loc13_ = _loc19_.@atlas;
               if(_loc13_)
               {
                  _loc5_.atlas = _loc13_;
               }
            }
            else if(_loc20_.type == "movieclip")
            {
               _loc5_ = _loc20_.imageSetting;
               _loc5_.smoothing = _loc19_.@smoothing != "false";
               _loc13_ = _loc19_.@atlas;
               if(_loc13_)
               {
                  _loc5_.atlas = _loc13_;
               }
            }
            else if(_loc20_.type == "font")
            {
               _loc20_.fontTexture = _loc19_.@texture;
            }
            _loc11_ = this._items[_loc20_.path];
            if(!_loc11_)
            {
               _loc11_ = this.ensurePathExists(_loc20_.path,false,false);
            }
            _loc11_.children.push(_loc20_);
            this._items[_loc20_.id] = _loc20_;
            this._itemList.push(_loc20_);
            _loc20_.init();
            _loc13_ = _loc20_.id.substr(4);
            _loc17_ = parseInt(_loc13_,36);
            if(_loc17_ >= this._nextId)
            {
               this._nextId = _loc17_ + 1;
            }
         }
         this._opening = false;
         GTimers.inst.add((300 + Math.random() * 30) * 1000,0,this.gc);
      }
      
      public function save(param1:Boolean = true) : void
      {
         var _loc8_:XML = null;
         var _loc4_:XML = null;
         var _loc9_:EPackageItem = null;
         var _loc6_:AtlasSettings = null;
         var _loc3_:* = param1;
         if(!_loc3_)
         {
            this.needSave = true;
            return;
         }
         this.needSave = false;
         var _loc7_:XML = <packageDescription/>;
         _loc7_.@id = this._id;
         _loc7_.@jpegQuality = this._jpegQuality;
         _loc7_.@compressPNG = this._compressPNG;
         _loc8_ = <resources/>;
         _loc7_.appendChild(_loc8_);
         this._rootItem.favorite = false;
         var _loc2_:int = this._itemList.length;
         var _loc11_:int = 0;
         while(_loc11_ < _loc2_)
         {
            _loc9_ = this._itemList[_loc11_];
            if(_loc9_.favorite && _loc9_.type != "folder")
            {
               this._rootItem.favorite = true;
            }
            if(_loc9_.type != "folder")
            {
               _loc8_.appendChild(_loc9_.serialize());
            }
            _loc11_++;
         }
         if(this._rootItem.favorite)
         {
            _loc7_.@hasFavorites = this._rootItem.favorite;
         }
         _loc8_ = <publish/>;
         _loc7_.appendChild(_loc8_);
         _loc8_.@name = this._publishSettings.fileName;
         if(this._publishSettings.filePath)
         {
            _loc8_.@path = this._publishSettings.filePath;
         }
         if(this._publishSettings.packageCount)
         {
            _loc8_.@packageCount = this._publishSettings.packageCount;
         }
         if(this._publishSettings.genCode)
         {
            _loc8_.@genCode = this._publishSettings.genCode;
         }
         var _loc5_:AtlasSettings = this._publishSettings.atlasList[0];
         if(_loc5_.maxWidth != 2048)
         {
            _loc8_.@maxAtlasSize = _loc5_.maxWidth;
         }
         if(!_loc5_.pot)
         {
            _loc8_.@npot = !_loc5_.pot;
         }
         if(_loc5_.square)
         {
            _loc8_.@square = _loc5_.square;
         }
         if(_loc5_.rotation)
         {
            _loc8_.@rotation = _loc5_.rotation;
         }
         if(_loc5_.extractAlpha)
         {
            _loc8_.@extractAlpha = _loc5_.extractAlpha;
         }
         if(!_loc5_.multiPage)
         {
            _loc8_.@multiPage = _loc5_.multiPage;
         }
         _loc11_ = 0;
         while(_loc11_ < this._publishSettings.atlasList.length)
         {
            _loc6_ = this._publishSettings.atlasList[_loc11_];
            _loc4_ = <atlas/>;
            if(_loc6_.name)
            {
               _loc4_.@name = _loc6_.name;
            }
            if(_loc6_.compression)
            {
               _loc4_.@compression = _loc6_.compression;
            }
            if(_loc4_.attributes().length() > 0)
            {
               _loc4_.@index = _loc11_;
               _loc8_.appendChild(_loc4_);
            }
            _loc11_++;
         }
         if(this._publishSettings.excludedList.length > 0)
         {
            _loc8_.@excluded = this._publishSettings.excludedList.join(",");
         }
         var _loc10_:File = new File(this._basePath + "/package.xml");
         try
         {
            UtilsFile.saveXML(_loc10_,_loc7_);
         }
         catch(err:Error)
         {
            _project.editorWindow.alertError(err);
         }
         System.disposeXML(_loc7_);
         this.descModification = _loc10_.modificationDate.time;
         this.descFileSize = _loc10_.size;
      }
      
      public function reload() : void
      {
         var _loc1_:EPackageItem = null;
         var _loc3_:int = this._itemList.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this._itemList[_loc2_];
            _loc1_.invalidate();
            _loc2_++;
         }
      }
      
      public function close() : void
      {
         GTimers.inst.remove(this.gc);
      }
      
      public function ensureOpen() : void
      {
         if(!this._opened)
         {
            this.open();
         }
      }
      
      public function refresh() : void
      {
         this._refreshHandler.run();
      }
      
      private function gc() : void
      {
         var _loc2_:EPackageItem = null;
         var _loc1_:AniDef = null;
         if(this.publishing)
         {
            return;
         }
         var _loc3_:Number = new Date().time / 1000;
         var _loc5_:int = 0;
         var _loc4_:* = this._itemList;
         for each(_loc2_ in this._itemList)
         {
            if(_loc2_.type == "movieclip" && _loc2_.data)
            {
               _loc1_ = AniDef(_loc2_.data);
               if(_loc1_.releasedTime && _loc3_ - _loc1_.releasedTime > 10)
               {
                  _loc1_.reset();
                  _loc2_.data = null;
               }
            }
         }
      }
      
      private function listAllFolders(param1:EPackageItem, param2:File, param3:Object) : void
      {
         var _loc8_:File = null;
         var _loc7_:* = null;
         var _loc6_:EPackageItem = null;
         var _loc9_:Array = param2.getDirectoryListing();
         var _loc4_:int = _loc9_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc8_ = _loc9_[_loc5_];
            if(_loc8_.isDirectory && !_loc8_.isHidden)
            {
               _loc7_ = param1.id + _loc8_.name + "/";
               _loc6_ = param3[_loc7_];
               if(!_loc6_)
               {
                  _loc6_ = new EPackageItem(this,"folder");
               }
               var _loc10_:* = _loc8_.name;
               _loc6_.name = _loc10_;
               _loc6_.fileName = _loc10_;
               _loc6_.path = param1.id;
               _loc6_.id = _loc7_;
               _loc6_.children = new Vector.<EPackageItem>();
               this._items[_loc6_.id] = _loc6_;
               this._itemList.push(_loc6_);
               param1.children.push(_loc6_);
               _loc6_.init();
               this.listAllFolders(_loc6_,_loc8_,param3);
            }
            _loc5_++;
         }
      }
      
      public function getNextId() : String
      {
         var _loc1_:Number = this._nextId;
         this._nextId++;
         return EUIProject.devCode + _loc1_.toString(36);
      }
      
      public function getSequenceName(param1:String) : String
      {
         var _loc3_:EPackageItem = null;
         var _loc4_:int = 0;
         var _loc7_:int = param1.length;
         var _loc5_:int = this._itemList.length;
         var _loc6_:* = -1;
         var _loc2_:int = 0;
         while(_loc2_ < _loc5_)
         {
            _loc3_ = this._itemList[_loc2_];
            if(UtilsStr.startsWith(_loc3_.name,param1))
            {
               _loc4_ = parseInt(_loc3_.name.substr(_loc7_));
               if(_loc4_ > _loc6_)
               {
                  _loc6_ = _loc4_;
               }
            }
            _loc2_++;
         }
         if(_loc6_ <= 0)
         {
            return param1 + "1";
         }
         _loc6_++;
         return param1 + _loc6_;
      }
      
      public function getUniqueName(param1:EPackageItem, param2:String, param3:Boolean = false) : String
      {
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc4_:int = 0;
         var _loc6_:EPackageItem = null;
         var _loc5_:Boolean = false;
         var _loc8_:String = UtilsStr.getFileName(param2);
         var _loc9_:String = UtilsStr.getFileExt(param2,true);
         if(_loc9_)
         {
            _loc10_ = "." + _loc9_;
         }
         _loc9_ = _loc9_.toLowerCase();
         var _loc13_:int = 1;
         var _loc7_:int = _loc8_.length;
         if(param3)
         {
            _loc11_ = this._itemList.length;
            _loc12_ = 0;
            while(_loc12_ < _loc11_)
            {
               _loc6_ = this._itemList[_loc12_];
               if(UtilsStr.startsWith(_loc6_.name,_loc8_,true) && UtilsStr.getFileExt(_loc6_.fileName) == _loc9_)
               {
                  if(_loc6_.name.length == _loc7_)
                  {
                     _loc5_ = true;
                  }
                  else if(_loc6_.name.charAt(_loc7_) == "(")
                  {
                     _loc4_ = _loc6_.name.indexOf(")",_loc7_);
                     if(_loc4_ != -1)
                     {
                        _loc4_ = parseInt(_loc6_.fileName.substring(_loc7_ + 1,_loc4_));
                        if(_loc4_ >= _loc13_)
                        {
                           _loc13_ = _loc4_ + 1;
                        }
                     }
                  }
               }
               _loc12_++;
            }
         }
         else
         {
            _loc11_ = param1.children.length;
            _loc12_ = 0;
            while(_loc12_ < _loc11_)
            {
               _loc6_ = param1.children[_loc12_];
               if(UtilsStr.startsWith(_loc6_.name,_loc8_,true) && UtilsStr.getFileExt(_loc6_.fileName) == _loc9_)
               {
                  if(_loc6_.name.length == _loc7_)
                  {
                     _loc5_ = true;
                  }
                  else if(_loc6_.name.charAt(_loc7_) == "(")
                  {
                     _loc4_ = _loc6_.name.indexOf(")",_loc7_);
                     if(_loc4_ != -1)
                     {
                        _loc4_ = parseInt(_loc6_.fileName.substring(_loc7_ + 1,_loc4_));
                        if(_loc4_ >= _loc13_)
                        {
                           _loc13_ = _loc4_ + 1;
                        }
                     }
                  }
               }
               _loc12_++;
            }
         }
         if(_loc5_)
         {
            return _loc8_ + "(" + _loc13_ + ")" + _loc10_;
         }
         return param2;
      }
      
      public function getFolderContent(param1:EPackageItem, param2:Array = null, param3:Boolean = true, param4:Vector.<EPackageItem> = null, param5:Boolean = false) : Vector.<EPackageItem>
      {
         var _loc7_:EPackageItem = null;
         this.ensureOpen();
         if(param4 == null)
         {
            param4 = new Vector.<EPackageItem>();
         }
         var _loc6_:int = param1.children.length;
         var _loc8_:int = 0;
         while(_loc8_ < _loc6_)
         {
            _loc7_ = param1.children[_loc8_];
            if(!(param2 != null && param2.indexOf(_loc7_.type) == -1))
            {
               param4.push(_loc7_);
               if(param5 && _loc7_.type == "folder")
               {
                  this.getFolderContent(_loc7_,param2,param3,param4,param5);
               }
            }
            _loc8_++;
         }
         if(param3 && !param5)
         {
            param4.sort(this.compareItem);
         }
         return param4;
      }
      
      public function refreshFavoriteFlags(param1:EPackageItem) : void
      {
         var _loc3_:EPackageItem = null;
         this.ensureOpen();
         param1.favorite = false;
         var _loc4_:int = param1.children.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = param1.children[_loc2_];
            if(_loc3_.type == "folder")
            {
               this.refreshFavoriteFlags(_loc3_);
            }
            if(_loc3_.favorite)
            {
               param1.favorite = true;
            }
            _loc2_++;
         }
      }
      
      public function getFavoriteItems(param1:EPackageItem, param2:Boolean = true, param3:Vector.<EPackageItem> = null) : Vector.<EPackageItem>
      {
         var _loc5_:EPackageItem = null;
         this.ensureOpen();
         if(param3 == null)
         {
            param3 = new Vector.<EPackageItem>();
         }
         var _loc6_:int = param1.children.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc6_)
         {
            _loc5_ = param1.children[_loc4_];
            if(_loc5_.favorite)
            {
               param3.push(_loc5_);
            }
            _loc4_++;
         }
         if(param2)
         {
            param3.sort(this.compareItem);
         }
         return param3;
      }
      
      private function compareItem(param1:EPackageItem, param2:EPackageItem) : int
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
      
      public function getItem(param1:String) : EPackageItem
      {
         this.ensureOpen();
         return this._items[param1];
      }
      
      public function getItemByName(param1:String) : EPackageItem
      {
         var _loc3_:EPackageItem = null;
         var _loc2_:EPackageItem = null;
         this.ensureOpen();
         var _loc5_:int = 0;
         var _loc4_:* = this._itemList;
         for each(_loc3_ in this._itemList)
         {
            if(_loc3_.name == param1)
            {
               if(_loc3_.exported)
               {
                  helperList.unshift(_loc3_);
               }
               else
               {
                  helperList.push(_loc3_);
               }
            }
         }
         if(helperList.length > 0)
         {
            _loc2_ = helperList[0];
            helperList.length = 0;
            return _loc2_;
         }
         return null;
      }
      
      public function getItemByFileName(param1:EPackageItem, param2:String) : EPackageItem
      {
         var _loc3_:EPackageItem = null;
         var _loc4_:int = param1.children.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = param1.children[_loc5_];
            if(_loc3_.fileName == param2)
            {
               return _loc3_;
            }
            _loc5_++;
         }
         return null;
      }
      
      public function getItemName(param1:String) : String
      {
         this.ensureOpen();
         var _loc2_:EPackageItem = this._items[param1];
         if(!_loc2_)
         {
            return null;
         }
         return _loc2_.name;
      }
      
      public function getItemPath(param1:EPackageItem) : Vector.<EPackageItem>
      {
         var _loc2_:Vector.<EPackageItem> = new Vector.<EPackageItem>();
         _loc2_.push(param1);
         if(param1 != this._rootItem)
         {
            param1 = this._items[param1.path];
            if(param1)
            {
               _loc2_.push(param1);
            }
         }
         _loc2_.reverse();
         return _loc2_;
      }
      
      public function addItem(param1:EPackageItem, param2:Boolean = true) : void
      {
         this._itemList.push(param1);
         this._items[param1.id] = param1;
         var _loc3_:EPackageItem = this._items[param1.path];
         _loc3_.children.push(param1);
         if(param1.type == "folder")
         {
            if(!param1.children)
            {
               param1.children = new Vector.<EPackageItem>();
            }
         }
         param1.init();
         if(this._project.editorWindow && !this._opening)
         {
            this._project.editorWindow.mainPanel.libPanel.pkgsPanel.notifyChanged(_loc3_.treeNode);
         }
         this.save(param2);
      }
      
      public function renameItem(param1:EPackageItem, param2:String, param3:Boolean = true) : void
      {
         var _loc8_:File = null;
         var _loc6_:ComDocument = null;
         param2 = UtilsStr.validateName(param2);
         var _loc10_:File = param1.file;
         if(param1 == this._rootItem)
         {
            if(_loc10_.name != param2)
            {
               this.renameRoot(param2);
            }
            return;
         }
         var _loc4_:String = UtilsStr.getFileExt(param1.fileName,true);
         var _loc5_:File = new File(this._basePath + param1.path + param2 + (!!_loc4_?"." + _loc4_:""));
         var _loc9_:Boolean = !ClassEditor.os_mac && _loc5_.name.toLowerCase() == _loc10_.name.toLowerCase();
         if(_loc5_.exists && !_loc9_)
         {
            throw new Error("file already exits");
         }
         if(_loc9_)
         {
            _loc8_ = new File(_loc5_.nativePath + "_" + Math.random() * 1000);
            _loc10_.moveTo(_loc8_);
            _loc8_.moveTo(_loc5_);
         }
         else
         {
            _loc10_.moveTo(_loc5_);
         }
         param1.name = param2;
         param1.fileName = _loc5_.name;
         param1.sortKey = null;
         if(param1.type == "folder")
         {
            delete this._items[param1.id];
            param1.id = param1.path + param1.name + "/";
            this._items[param1.id] = param1;
            this.changeChildrenPath(param1);
         }
         param1.relocate();
         var _loc7_:EPackageItem = this._items[param1.path];
         if(this._project.editorWindow)
         {
            this._project.editorWindow.mainPanel.libPanel.pkgsPanel.notifyChanged(_loc7_.treeNode);
            _loc6_ = this._project.editorWindow.mainPanel.editPanel.findComDocument(param1.owner,param1.id);
            if(_loc6_ != null)
            {
               _loc6_.updateDocTitle();
            }
         }
         this._project.editorWindow.mainPanel.libPanel.updateItem(param1);
         this.save(param3);
      }
      
      private function renameRoot(param1:String) : void
      {
         var _loc2_:EPackageItem = null;
         var _loc3_:File = null;
         var _loc6_:String = this._project.assetsPath + "/" + param1;
         var _loc4_:File = new File(_loc6_);
         var _loc5_:Boolean = !ClassEditor.os_mac && _loc4_.name.toLowerCase() == this._rootItem.file.name.toLowerCase();
         if(_loc4_.exists && !_loc5_)
         {
            throw new Error("file already exits");
         }
         if(_loc5_)
         {
            _loc3_ = new File(_loc4_.nativePath + "_" + Math.random() * 1000);
            this._rootItem.file.moveTo(_loc3_);
            _loc3_.moveTo(_loc4_);
         }
         else
         {
            this._rootItem.file.moveTo(_loc4_);
         }
         this._rootItem.name = param1;
         this._basePath = _loc6_;
         this._rootItem.sortKey = null;
         this._rootItem.relocate();
         var _loc8_:int = 0;
         var _loc7_:* = this._itemList;
         for each(_loc2_ in this._itemList)
         {
            _loc2_.relocate();
         }
         this._project.editorWindow.mainPanel.libPanel.updateItem(this._rootItem);
         if(this._project.editorWindow)
         {
            this._project.editorWindow.mainPanel.libPanel.pkgsPanel.notifyRootChanged();
            this._project.editorWindow.mainPanel.editPanel.refreshDocument();
         }
      }
      
      public function moveItem(param1:EPackageItem, param2:String, param3:Boolean = true) : Boolean
      {
         if(param1.path == param2)
         {
            return false;
         }
         var _loc9_:EPackageItem = this._items[param1.path];
         var _loc4_:EPackageItem = this._items[param2];
         if(_loc9_ == null || _loc4_ == null)
         {
            return false;
         }
         var _loc5_:String = this.getUniqueName(_loc4_,param1.fileName,false);
         var _loc8_:File = param1.file;
         var _loc7_:File = new File(_loc4_.file.nativePath + "/" + _loc5_);
         if(param1.type == "folder")
         {
            if(UtilsStr.startsWith(_loc7_.nativePath,_loc8_.nativePath,true))
            {
               return false;
            }
         }
         if(_loc8_.exists)
         {
            _loc8_.moveTo(_loc7_);
         }
         var _loc6_:int = _loc9_.children.indexOf(param1);
         _loc9_.children.splice(_loc6_,1);
         _loc4_.children.push(param1);
         param1.path = param2;
         param1.name = UtilsStr.getFileName(_loc5_);
         param1.fileName = _loc5_;
         if(param1.type == "folder")
         {
            delete this._items[param1.id];
            param1.id = param1.path + param1.name + "/";
            this._items[param1.id] = param1;
            this.changeChildrenPath(param1);
         }
         param1.relocate();
         if(param1.treeNode && param1.treeNode.parent)
         {
            param1.treeNode.parent.removeChild(param1.treeNode);
         }
         if(this._project.editorWindow)
         {
            this._project.editorWindow.mainPanel.libPanel.pkgsPanel.notifyChanged(_loc4_.treeNode);
         }
         this.save(param3);
         return true;
      }
      
      private function changeChildrenPath(param1:EPackageItem) : void
      {
         var _loc3_:EPackageItem = null;
         var _loc4_:int = param1.children.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = param1.children[_loc2_];
            _loc3_.path = param1.id;
            if(_loc3_.type == "folder")
            {
               delete this._items[_loc3_.id];
               _loc3_.id = _loc3_.path + _loc3_.name + "/";
               this._items[_loc3_.id] = _loc3_;
               this.changeChildrenPath(_loc3_);
            }
            _loc3_.relocate();
            _loc2_++;
         }
      }
      
      public function deleteItem(param1:EPackageItem, param2:Boolean = true) : int
      {
         var _loc5_:EPackageItem = null;
         var _loc3_:int = 0;
         var _loc4_:int = this._deleteItem(param1);
         if(_loc4_ > 0)
         {
            if(param1.treeNode && param1.treeNode.parent)
            {
               param1.treeNode.parent.removeChild(param1.treeNode);
            }
            _loc5_ = this._items[param1.path];
            if(_loc5_ != null)
            {
               _loc3_ = _loc5_.children.indexOf(param1);
               _loc5_.children.splice(_loc3_,1);
            }
            this.save(param2);
         }
         return _loc4_;
      }
      
      public function deleteItems(param1:Vector.<EPackageItem>, param2:Boolean = true) : int
      {
         var _loc4_:int = param1.length;
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc5_ + this.deleteItem(param1[_loc3_],false);
            _loc3_++;
         }
         this.save(param2);
         return _loc5_;
      }
      
      private function _deleteItem(param1:EPackageItem) : int
      {
         var _loc2_:int = 0;
         var _loc3_:ComDocument = null;
         var _loc6_:int = this._itemList.indexOf(param1);
         if(_loc6_ == -1)
         {
            return 0;
         }
         this._itemList.splice(_loc6_,1);
         delete this._items[param1.id];
         var _loc4_:int = 1;
         if(param1.type == "folder")
         {
            _loc2_ = param1.children.length;
            _loc6_ = 0;
            while(_loc6_ < _loc2_)
            {
               _loc4_ = _loc4_ + this._deleteItem(param1.children[_loc6_]);
               _loc6_++;
            }
         }
         var _loc5_:File = param1.file;
         if(_loc5_.exists)
         {
            UtilsFile.deleteFile(_loc5_,true);
         }
         param1.invalidate();
         if(param1.type == "component" && this._project.editorWindow)
         {
            _loc3_ = this._project.editorWindow.mainPanel.editPanel.findComDocument(param1.owner,param1.id);
            if(_loc3_ != null)
            {
               this._project.editorWindow.mainPanel.editPanel.closeDocument(_loc3_);
            }
         }
         return _loc4_;
      }
      
      public function duplicateItem(param1:EPackageItem, param2:String, param3:Boolean = true) : EPackageItem
      {
         param2 = UtilsStr.validateName(param2);
         var _loc7_:String = UtilsStr.getFileExt(param1.fileName);
         param2 = param2 + (!!_loc7_?"." + _loc7_:"");
         var _loc4_:EPackageItem = new EPackageItem(this,param1.type);
         _loc4_.id = this.getNextId();
         _loc4_.name = UtilsStr.getFileName(param2);
         _loc4_.fileName = param2;
         _loc4_.path = param1.path;
         if(param1.type == "image" || param1.type == "movieclip")
         {
            _loc4_.imageSetting.copyFrom(param1.imageSetting);
         }
         _loc4_.fontTexture = param1.fontTexture;
         var _loc5_:File = param1.file;
         var _loc6_:File = _loc4_.file;
         if(_loc6_.exists)
         {
            throw new Error("file already exists");
         }
         if(_loc5_.isDirectory)
         {
            _loc6_.createDirectory();
         }
         else
         {
            UtilsFile.copyFile(_loc5_,_loc6_);
         }
         this.addItem(_loc4_,param3);
         return _loc4_;
      }
      
      public function createFolder2(param1:EPackageItem, param2:String, param3:Boolean = true) : EPackageItem
      {
         this.ensureOpen();
         if(param2)
         {
            param2 = UtilsStr.validateName(param2);
         }
         else
         {
            param2 = this.getSequenceName("Folder");
         }
         var _loc5_:File = new File(param1.file.nativePath + "/" + param2);
         if(_loc5_.exists)
         {
            throw new Error("folder already exists");
         }
         _loc5_.createDirectory();
         var _loc4_:EPackageItem = new EPackageItem(this,"folder");
         _loc4_.id = param1.id + param2 + "/";
         _loc4_.name = param2;
         _loc4_.fileName = param2;
         _loc4_.path = param1.id;
         this.addItem(_loc4_,param3);
         return _loc4_;
      }
      
      public function ensurePathExists(param1:String, param2:Boolean, param3:Boolean = true) : EPackageItem
      {
         var _loc9_:String = null;
         var _loc8_:Boolean = false;
         var _loc6_:File = null;
         var _loc10_:EPackageItem = this._items[param1];
         if(_loc10_)
         {
            return _loc10_;
         }
         _loc10_ = this._rootItem;
         var _loc4_:int = param1.length;
         var _loc5_:int = 1;
         var _loc7_:int = 1;
         while(_loc7_ < _loc4_)
         {
            if(param1.charAt(_loc7_) == "/")
            {
               _loc9_ = param1.substring(0,_loc7_ + 1);
               _loc10_ = this._items[_loc9_];
               if(!_loc10_)
               {
                  _loc10_ = new EPackageItem(this,"folder");
                  _loc10_.id = _loc9_;
                  _loc10_.path = _loc9_.substring(0,_loc5_);
                  var _loc11_:* = _loc9_.substring(_loc5_,_loc7_);
                  _loc10_.fileName = _loc11_;
                  _loc10_.name = _loc11_;
                  if(param2)
                  {
                     _loc6_ = _loc10_.file;
                     if(!_loc6_.exists)
                     {
                        _loc6_.createDirectory();
                     }
                  }
                  this.addItem(_loc10_,false);
                  _loc8_ = true;
               }
               _loc5_ = _loc7_ + 1;
            }
            _loc7_++;
         }
         if(_loc8_)
         {
            this.save(param3);
         }
         return _loc10_;
      }
      
      public function importResource(param1:File, param2:String, param3:Boolean, param4:Callback, param5:Boolean) : void
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         param4 = param4;
         param5 = param5;
         var type:String = null;
         var pi:EPackageItem = null;
         var callback2:Callback = null;
         var ani:AniDef = null;
         var xml:XML = null;
         var sourceFile:File = param1;
         var toPath:String = param2;
         var crop:Boolean = param3;
         var callback:Callback = param4;
         var saveNow:Boolean = param5;
         this.ensureOpen();
         var ext:String = sourceFile.extension.toLowerCase();
         if(ext == "swf")
         {
            type = "swf";
         }
         else if(ext == "jta" || ext == "gif" || ext == "plist" || ext == "eas")
         {
            type = "movieclip";
         }
         else if(ext == "wav" || ext == "mp3" || ext == "ogg")
         {
            type = "sound";
         }
         else if(ext == "png" || ext == "jpg" || ext == "jpeg")
         {
            type = "image";
         }
         else if(ext == "fnt")
         {
            type = "font";
         }
         else if(ext == "xml")
         {
            type = "component";
         }
         else
         {
            type = "misc";
         }
         var folderItem:EPackageItem = this.ensurePathExists(toPath,true,false);
         var fileName:String = sourceFile.name;
         if(type == "movieclip")
         {
            fileName = UtilsStr.replaceFileExt(fileName,"jta");
         }
         fileName = this.getUniqueName(folderItem,fileName,false);
         pi = new EPackageItem(this,type);
         pi.id = this.getNextId();
         pi.path = toPath;
         pi.fileName = fileName;
         pi.name = UtilsStr.getFileName(fileName);
         callback2 = new Callback();
         callback2.success = function():void
         {
            addItem(pi,saveNow);
            callback.result = pi;
            callback.callOnSuccess();
         };
         callback2.failed = function():void
         {
            callback.addMsgs(callback2.msgs);
            callback.callOnFail();
         };
         var info:Object = ResourceSize.getSize(sourceFile);
         if(info && info.type == "png" && crop)
         {
            ImageTool.cropImage(sourceFile,pi.file,callback2);
         }
         else if(type == "movieclip")
         {
            if(ext == "gif")
            {
               this.importGif(pi,sourceFile,callback2);
            }
            else if(ext == "plist" || ext == "eas")
            {
               this.importMovieClip(pi,sourceFile,callback2);
            }
            else
            {
               ani = new AniDef();
               ani.load(UtilsFile.loadBytes(sourceFile));
               if(ani.frameCount == 0)
               {
                  callback.addMsg(Consts.g.text116);
                  callback.callOnFailImmediately();
               }
               else
               {
                  UtilsFile.saveBytes(pi.file,ani.save());
                  callback2.callOnSuccessImmediately();
               }
            }
         }
         else if(type == "font")
         {
            this.importFont(pi,sourceFile,callback2,saveNow);
         }
         else if(type == "component")
         {
            try
            {
               xml = UtilsFile.loadXML(sourceFile);
               if(xml.name() != "component")
               {
                  callback2.addMsg("Not a valid fairygui component!");
                  callback2.callOnFailImmediately();
               }
               else
               {
                  UtilsFile.copyFile(sourceFile,pi.file);
                  callback2.callOnSuccessImmediately();
               }
            }
            catch(err:Error)
            {
               callback2.addMsg(err.message);
               callback2.callOnFailImmediately();
            }
         }
         else
         {
            UtilsFile.copyFile(sourceFile,pi.file);
            callback2.callOnSuccessImmediately();
         }
      }
      
      public function updateResource(param1:EPackageItem, param2:File, param3:Boolean, param4:Callback, param5:Boolean) : void
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         param4 = param4;
         param5 = param5;
         var callback2:Callback = null;
         var ani:AniDef = null;
         var xml:XML = null;
         var pi:EPackageItem = param1;
         var sourceFile:File = param2;
         var crop:Boolean = param3;
         var callback:Callback = param4;
         var saveNow:Boolean = param5;
         var info:Object = ResourceSize.getSize(sourceFile);
         if(info && ((info.type == "png" || info.type == "jpg") && pi.type != "image" || info.type == "swf" && pi.type != "swf" || (info.type == "plist" || info.type == "eas" || info.type == "jta" || info.type == "gif") && pi.type != "movieclip" || info.type == "xml" && pi.type != "component"))
         {
            callback.addMsg("Source file type mismatched!");
            callback.callOnFail();
            return;
         }
         var folderItem:EPackageItem = this.ensurePathExists(pi.path,true,false);
         var oldExt:String = UtilsStr.getFileExt(pi.fileName);
         var newExt:String = sourceFile.extension;
         var fileName:String = pi.fileName;
         if(pi.type == "image" && oldExt != newExt)
         {
            fileName = UtilsStr.replaceFileExt(fileName,newExt);
            fileName = this.getUniqueName(folderItem,fileName,false);
            UtilsFile.deleteFile(pi.file);
            pi.fileName = fileName;
            this.save(saveNow);
         }
         callback2 = new Callback();
         callback2.success = function():void
         {
            pi.invalidate();
            callback.result = pi;
            callback.callOnSuccess();
         };
         callback2.failed = function():void
         {
            callback.addMsgs(callback2.msgs);
            callback.callOnFail();
         };
         if(info && info.type == "png" && crop)
         {
            ImageTool.cropImage(sourceFile,pi.file,callback2);
         }
         else if(pi.type == "movieclip")
         {
            if(newExt == "gif")
            {
               this.importGif(pi,sourceFile,callback2);
            }
            else if(newExt == "plist" || newExt == "eas")
            {
               this.importMovieClip(pi,sourceFile,callback2);
            }
            else
            {
               ani = new AniDef();
               ani.load(UtilsFile.loadBytes(sourceFile));
               if(ani.frameCount == 0)
               {
                  callback.addMsg(Consts.g.text116);
                  callback.callOnFailImmediately();
               }
               else
               {
                  UtilsFile.saveBytes(pi.file,ani.save());
                  callback2.callOnSuccessImmediately();
               }
            }
         }
         else if(pi.type == "font")
         {
            this.importFont(pi,sourceFile,callback2,saveNow);
         }
         else if(pi.type == "component")
         {
            try
            {
               xml = UtilsFile.loadXML(sourceFile);
               if(xml.name() != "component")
               {
                  callback2.addMsg("Not a valid fairygui component!");
                  callback2.callOnFailImmediately();
               }
               else
               {
                  UtilsFile.copyFile(sourceFile,pi.file);
                  callback2.callOnSuccessImmediately();
               }
            }
            catch(err:Error)
            {
               callback2.addMsg(err.message);
               callback2.callOnFailImmediately();
            }
         }
         else
         {
            UtilsFile.copyFile(sourceFile,pi.file);
            callback2.callOnSuccessImmediately();
         }
      }
      
      private function importFont(param1:EPackageItem, param2:File, param3:Callback, param4:Boolean) : void
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         param4 = param4;
         var i:int = 0;
         var pngFile:String = null;
         var ttf:Boolean = false;
         var str:String = null;
         var arr:Array = null;
         var j:int = 0;
         var arr2:Array = null;
         var atlasItem:EPackageItem = null;
         var newAtlas:Boolean = false;
         var sourcePngFile:File = null;
         var callback2:Callback = null;
         var pi:EPackageItem = param1;
         var sourceFile:File = param2;
         var callback:Callback = param3;
         var saveNow:Boolean = param4;
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
                  j = Number(j) + 1;
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
                     callback.addMsg(Consts.g.text114);
                     callback.callOnFail();
                     return;
                  }
               }
            }
            i = Number(i) + 1;
         }
         if(ttf)
         {
            if(pi.fontTexture)
            {
               atlasItem = this._items[pi.fontTexture];
            }
            if(!atlasItem)
            {
               atlasItem = new EPackageItem(this,"image");
               atlasItem.id = this.getNextId();
               atlasItem.path = pi.path;
               atlasItem.fileName = this.getUniqueName(this._items[pi.path],pi.name + "_atlas.png");
               atlasItem.name = UtilsStr.getFileName(atlasItem.fileName);
               newAtlas = true;
            }
            else
            {
               atlasItem.invalidate();
            }
            pi.fontTexture = atlasItem.id;
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
                  addItem(atlasItem,saveNow);
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
            pi.fontTexture = null;
            UtilsFile.copyFile(sourceFile,pi.file);
            callback.callOnSuccess();
         }
      }
      
      private function importGif(param1:EPackageItem, param2:File, param3:Callback) : void
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         var bmd:BitmapData = null;
         var tmpFolder:File = null;
         var frameDelays:Array = null;
         var ani:AniDef = null;
         var callback2:Callback = null;
         var gf:GIFFrame = null;
         var fn:int = 0;
         var delay:int = 0;
         var tmpFile:File = null;
         var ba:ByteArray = null;
         var pi:EPackageItem = param1;
         var sourceFile:File = param2;
         var callback:Callback = param3;
         var gd:GIFDecoder = new GIFDecoder(UtilsFile.loadBytes(sourceFile));
         var tmpFiles:Array = [];
         tmpFolder = File.createTempDirectory();
         frameDelays = [];
         var frameCount:int = gd.getFrameCount();
         if(gd.hasError() || frameCount == 0)
         {
            callback.addMsg("GIF format error!");
            callback.callOnFail();
            return;
         }
         var frame0:BitmapData = gd.getFrame(0).bitmapData;
         var i:int = 0;
         while(i < frameCount)
         {
            gf = gd.getFrame(i);
            bmd = gf.bitmapData;
            delay = gf.delay > 0?int(gf.delay):100;
            frameDelays[i] = int(delay / 1000 * 24);
            tmpFile = new File(tmpFolder.nativePath + File.separator + i + ".png");
            ba = bmd.encode(bmd.rect,new PNGEncoderOptions());
            UtilsFile.saveBytes(tmpFile,ba);
            tmpFiles[i] = tmpFile;
            i = Number(i) + 1;
         }
         ani = new AniDef();
         callback2 = new Callback();
         callback2.success = function():void
         {
            var _loc2_:int = ani.frameCount;
            var _loc1_:int = 0;
            while(_loc1_ < _loc2_)
            {
               ani.frameList[_loc1_].delay = int(frameDelays[_loc1_]);
               _loc1_++;
            }
            UtilsFile.saveBytes(pi.file,ani.save());
            if(UtilsStr.startsWith(sourceFile.parent.nativePath,_basePath))
            {
               UtilsFile.deleteFile(sourceFile);
            }
            try
            {
               tmpFolder.deleteDirectory(true);
            }
            catch(e:Error)
            {
            }
            callback.callOnSuccessImmediately();
         };
         callback2.failed = function():void
         {
            try
            {
               tmpFolder.deleteDirectory(true);
            }
            catch(e:Error)
            {
            }
            callback.addMsgs(callback2.msgs);
            callback.callOnFailImmediately();
         };
         AniImporter.importImages(tmpFiles,ani,!this._project.usingAtlas,callback2);
      }
      
      private function importMovieClip(param1:EPackageItem, param2:File, param3:Callback) : void
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         var ani:AniDef = null;
         var callback2:Callback = null;
         var pi:EPackageItem = param1;
         var sourceFile:File = param2;
         var callback:Callback = param3;
         ani = new AniDef();
         callback2 = new Callback();
         callback2.success = function():void
         {
            UtilsFile.saveBytes(pi.file,ani.save());
            callback.callOnSuccessImmediately();
         };
         callback2.failed = function():void
         {
            callback.addMsgs(callback2.msgs);
            callback.callOnFailImmediately();
         };
         AniImporter.importSpriteSheet(sourceFile,ani,!this._project.usingAtlas,callback2);
      }
      
      public function getComponentXML(param1:EPackageItem, param2:Boolean = false) : XML
      {
         var _loc6_:XML = null;
         var _loc5_:ComDocument = null;
         var _loc4_:File = null;
         var _loc7_:* = param1;
         var _loc3_:* = param2;
         if(_loc7_.data && _loc7_.dataVersion == _loc7_.version)
         {
            return _loc7_.data as XML;
         }
         if(_loc3_)
         {
            _loc5_ = this._project.editorWindow.mainPanel.editPanel.findComDocument(this,_loc7_.id);
            if(_loc5_ && _loc5_.isModified)
            {
               _loc6_ = _loc5_.serialize();
            }
         }
         if(!_loc6_)
         {
            _loc4_ = _loc7_.file;
            if(!_loc4_.exists)
            {
               return null;
            }
            try
            {
               _loc6_ = new XML(UtilsFile.loadString(_loc4_));
            }
            catch(err:Error)
            {
               var _loc9_:* = null;
               return _loc9_;
            }
         }
         if(_loc7_.data)
         {
            System.disposeXML(_loc7_.data as XML);
         }
         _loc7_.data = _loc6_;
         _loc7_.dataVersion = _loc7_.version;
         return _loc6_;
      }
      
      public function getSound(param1:EPackageItem, param2:Function) : void
      {
         if(param1.data && param1.dataVersion == param1.version)
         {
            return;
            §§push(param2(param1));
         }
         else if(!param1.file.exists)
         {
            param1.data = null;
            return;
            §§push(param2(param1));
         }
         else
         {
            if(param1.data)
            {
               try
               {
                  Sound(param1.data).close();
               }
               catch(err:*)
               {
               }
            }
            var _loc3_:String = UtilsStr.getFileExt(param1.fileName);
            if(_loc3_ == "mp3")
            {
               param1.data = new Sound(new URLRequest(param1.file.url));
               param1.dataVersion = param1.version;
               param2(param1);
            }
            else
            {
               if(!param1.loadQueue)
               {
                  param1.loadQueue = [];
               }
               param1.loadQueue.push(param2);
               this._project.editorWindow.cacheManager.loadSound(param1);
            }
            return;
         }
      }
      
      public function getImage(param1:EPackageItem, param2:Function, param3:Boolean = true) : void
      {
         if(!param1.loadQueue)
         {
            param1.loadQueue = [];
         }
         param1.loadQueue.push(param2);
         if(param1.data && param1.dataVersion == param1.version)
         {
            GTimers.inst.callLater(param1.invokeCallbacks);
            return;
         }
         if(!param1.file.exists)
         {
            param1.data = null;
            param1.imageInfo.file = null;
            GTimers.inst.callLater(param1.invokeCallbacks);
            return;
         }
         if(param1.loadQueue.length > 1)
         {
            if(param3)
            {
               param1.imageInfo.loadingToMemory = true;
            }
            return;
         }
         param1.imageInfo.loadingToMemory = param3;
         if(param1.imageInfo.targetQuality == 100 || !this._project.editorWindow)
         {
            if(param3)
            {
               EasyLoader.load(param1.file.url,{
                  "pi":param1,
                  "type":"image"
               },this.__imageLoaded);
            }
            else
            {
               param1.imageInfo.file = param1.file;
               GTimers.inst.callLater(param1.invokeCallbacks);
            }
         }
         else
         {
            this._project.editorWindow.cacheManager.loadImage(param1);
         }
      }
      
      private function __imageLoaded(param1:LoaderExt) : void
      {
         var _loc4_:Object = param1.props;
         var _loc2_:EPackageItem = _loc4_.pi;
         var _loc3_:Object = param1.content;
         if(_loc3_ is Bitmap)
         {
            _loc2_.data = _loc3_.bitmapData;
            _loc2_.imageInfo.file = _loc2_.file;
         }
         else
         {
            _loc2_.data = null;
            _loc2_.imageInfo.file = null;
         }
         _loc2_.dataVersion = _loc2_.version;
         _loc2_.invokeCallbacks();
      }
      
      public function getMovieClip(param1:EPackageItem) : AniDef
      {
         var _loc3_:AniDef = null;
         var _loc4_:* = param1;
         if(_loc4_.data && _loc4_.dataVersion == _loc4_.version)
         {
            return AniDef(_loc4_.data);
         }
         if(_loc4_.data)
         {
            AniDef(_loc4_.data).reset();
            _loc4_.data = null;
         }
         var _loc2_:ByteArray = UtilsFile.loadBytes(_loc4_.file);
         if(_loc2_ == null)
         {
            return null;
         }
         try
         {
            _loc3_ = new AniDef();
            _loc3_.load(_loc2_);
            _loc4_.data = _loc3_;
         }
         catch(err:Error)
         {
         }
         _loc4_.dataVersion = _loc4_.version;
         return AniDef(_loc4_.data);
      }
      
      public function getBoneDef(param1:EPackageItem) : BoneDef
      {
         var _loc3_:BoneDef = null;
         var _loc4_:* = param1;
         if(_loc4_.data && _loc4_.dataVersion == _loc4_.version)
         {
            return BoneDef(_loc4_.data);
         }
         if(_loc4_.data)
         {
            BoneDef(_loc4_.data).reset();
            _loc4_.data = null;
         }
         var _loc2_:ByteArray = UtilsFile.loadBytes(_loc4_.file);
         if(_loc2_ == null)
         {
            return null;
         }
         try
         {
            _loc3_ = new BoneDef();
            _loc3_.load(_loc2_);
            _loc4_.data = _loc3_;
         }
         catch(err:Error)
         {
         }
         _loc4_.dataVersion = _loc4_.version;
         return BoneDef(_loc4_.data);
      }
      
      public function getBitmapFont(param1:EPackageItem) : EBitmapFont
      {
         if(param1.data && param1.dataVersion == param1.version)
         {
            return EBitmapFont(param1.data);
         }
         if(param1.data)
         {
            EBitmapFont(param1.data).dispose();
            param1.data = null;
         }
         var _loc2_:EBitmapFont = new EBitmapFont();
         _loc2_.packageItem = param1;
         param1.data = _loc2_;
         param1.dataVersion = param1.version;
         _loc2_.load();
         return EBitmapFont(param1.data);
      }
      
      public function getImageQuality(param1:EPackageItem) : int
      {
         var _loc2_:ImageSetting = param1.imageSetting;
         var _loc3_:* = _loc2_.qualityOption;
         if("default" !== _loc3_)
         {
            if("source" !== _loc3_)
            {
               if("custom" !== _loc3_)
               {
                  return 100;
               }
               if(param1.imageInfo.format == "png")
               {
                  return this._jpegQuality != 100?8:100;
               }
               return _loc2_.quality;
            }
            return 100;
         }
         if(this._project.usingAtlas)
         {
            return 100;
         }
         if(param1.imageInfo.format == "png")
         {
            return !!this._compressPNG?8:100;
         }
         return this._jpegQuality;
      }
      
      public function createNewComponent(param1:String, param2:int, param3:int, param4:String, param5:String = null, param6:XML = null, param7:Boolean = false, param8:Boolean = false) : EPackageItem
      {
         var _loc10_:* = null;
         var _loc13_:File = null;
         var _loc9_:XML = null;
         this.ensureOpen();
         param1 = UtilsStr.validateName(param1);
         var _loc14_:EPackageItem = this._items[param4];
         var _loc11_:* = param1 + ".xml";
         if(param8)
         {
            _loc11_ = this.getUniqueName(_loc14_,_loc11_,true);
         }
         else
         {
            _loc13_ = new File(this._basePath + param4 + _loc11_);
            if(_loc13_.exists)
            {
               throw new Error(Consts.g.text113);
            }
         }
         var _loc12_:EPackageItem = new EPackageItem(this,"component");
         _loc12_.id = this.getNextId();
         _loc12_.path = param4;
         _loc12_.name = UtilsStr.getFileName(_loc11_);
         _loc12_.fileName = _loc11_;
         _loc12_.exported = param7;
         if(param6 != null)
         {
            _loc10_ = param6;
         }
         else
         {
            _loc10_ = <component/>;
         }
         _loc10_.@size = param2 + "," + param3;
         if(param5)
         {
            _loc10_.@extention = param5;
            _loc9_ = new XML("<" + param5 + "/>");
            _loc10_.appendChild(_loc9_);
         }
         UtilsFile.saveXML(_loc12_.file,_loc10_);
         this.addItem(_loc12_);
         return _loc12_;
      }
      
      public function createNewFont(param1:String, param2:String) : EPackageItem
      {
         this.ensureOpen();
         param1 = UtilsStr.validateName(param1);
         var _loc4_:* = param1 + ".fnt";
         var _loc5_:File = new File(this._basePath + param2 + _loc4_);
         if(_loc5_.exists)
         {
            throw new Error(Consts.g.text113);
         }
         var _loc3_:EPackageItem = new EPackageItem(this,"font");
         _loc3_.id = this.getNextId();
         _loc3_.path = param2;
         _loc3_.name = UtilsStr.getFileName(_loc4_);
         _loc3_.fileName = _loc4_;
         _loc3_.exported = true;
         UtilsFile.saveString(_loc3_.file,"info creator=UIBuilder\n");
         this.addItem(_loc3_);
         return _loc3_;
      }
      
      public function createNewMovieClip(param1:String, param2:String, param3:Boolean = false) : EPackageItem
      {
         this.ensureOpen();
         param1 = UtilsStr.validateName(param1);
         var _loc7_:* = param1 + ".jta";
         var _loc4_:File = new File(this._basePath + param2 + _loc7_);
         if(_loc4_.exists)
         {
            throw new Error(Consts.g.text113);
         }
         var _loc5_:EPackageItem = new EPackageItem(this,"movieclip");
         _loc5_.id = this.getNextId();
         _loc5_.path = param2;
         _loc5_.name = UtilsStr.getFileName(_loc7_);
         _loc5_.fileName = _loc7_;
         var _loc6_:AniDef = new AniDef();
         UtilsFile.saveBytes(_loc5_.file,_loc6_.save());
         this.addItem(_loc5_);
         return _loc5_;
      }
      
      public function createNewVideo(param1:String, param2:String, param3:Boolean = false) : EPackageItem
      {
         this.ensureOpen();
         param1 = UtilsStr.validateName(param1);
         var _loc6_:* = param1 + ".jtv";
         var _loc4_:File = new File(this._basePath + param2 + _loc6_);
         if(_loc4_.exists)
         {
            throw new Error(Consts.g.text113);
         }
         var _loc5_:EPackageItem = new EPackageItem(this,"video");
         _loc5_.id = this.getNextId();
         _loc5_.path = param2;
         _loc5_.name = UtilsStr.getFileName(_loc6_);
         _loc5_.fileName = _loc6_;
         this.addItem(_loc5_);
         return _loc5_;
      }
      
      public function createNewFyMovie(param1:String, param2:String, param3:Boolean = false) : EPackageItem
      {
         this.ensureOpen();
         param1 = UtilsStr.validateName(param1);
         var _loc7_:* = param1 + ".jtb";
         var _loc4_:File = new File(this._basePath + param2 + _loc7_);
         if(_loc4_.exists)
         {
            throw new Error(Consts.g.text113);
         }
         var _loc5_:EPackageItem = new EPackageItem(this,"dragonbone");
         _loc5_.id = this.getNextId();
         _loc5_.path = param2;
         _loc5_.name = UtilsStr.getFileName(_loc7_);
         _loc5_.fileName = _loc7_;
         var _loc6_:BoneDef = new BoneDef();
         UtilsFile.saveBytes(_loc5_.file,_loc6_.save());
         this.addItem(_loc5_);
         return _loc5_;
      }
      
      public function getResourceId(param1:String) : String
      {
         var _loc3_:EPackageItem = null;
         var _loc4_:int = this._itemList.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = this._itemList[_loc2_];
            if(_loc3_.type != "folder" && _loc3_.name == param1)
            {
               return _loc3_.id;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function setExported(param1:Array, param2:Boolean) : void
      {
         var _loc3_:String = null;
         var _loc4_:EPackageItem = null;
         var _loc6_:int = 0;
         var _loc5_:* = param1;
         for each(_loc3_ in param1)
         {
            _loc4_ = this._items[_loc3_];
            if(_loc4_)
            {
               _loc4_.exported = param2;
            }
         }
         this.save(true);
      }
      
      public function createFolder(param1:String, param2:String) : void
      {
         var _loc3_:EPackageItem = this._items[param1];
         if(_loc3_)
         {
            this.createFolder2(_loc3_,param2);
         }
      }
      
      public function renameResources(param1:Array, param2:Array) : void
      {
         var _loc3_:int = 0;
         var _loc6_:int = 0;
         var _loc5_:* = param1;
         var _loc4_:* = param2;
         var _loc7_:* = 0;
         _loc3_ = _loc5_.length;
         _loc6_ = 0;
         while(_loc6_ < _loc3_)
         {
            this.renameItem(_loc5_[_loc6_],_loc4_[_loc6_],false);
            _loc6_++;
         }
         _loc7_ = 1;
         this.save(true);
         switch(int(_loc7_))
         {
            case 0:
               return;
            case 1:
               return;
         }
      }
      
      public function importResources(param1:String, param2:Array, param3:Array, param4:Function) : void
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         param4 = param4;
         var callback:Callback = null;
         var folderPath:String = param1;
         var files:Array = param2;
         var names:Array = param3;
         var onComplete:Function = param4;
         callback = new Callback();
         callback.success = function():void
         {
            if(onComplete != null)
            {
               if(onComplete.length > 0)
               {
                  onComplete(callback.result);
               }
               else
               {
                  onComplete();
               }
            }
         };
         this.project.editorWindow.mainPanel.importResources(files,this,[folderPath],callback);
      }
      
      public function createMovieClip(param1:String, param2:String, param3:Array, param4:Object, param5:Function, param6:Function) : void
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         param4 = param4;
         param5 = param5;
         param6 = param6;
         var pi:EPackageItem = null;
         var ani:AniDef = null;
         var importCallback:Callback = null;
         var resName:String = param1;
         var folderPath:String = param2;
         var files:Array = param3;
         var options:Object = param4;
         var onSuccess:Function = param5;
         var onFail:Function = param6;
         pi = this.createNewMovieClip(resName,folderPath,true);
         ani = this.getMovieClip(pi);
         importCallback = new Callback();
         importCallback.success = function():void
         {
            if(options == null)
            {
               options = {};
            }
            if(options.speed)
            {
               ani.speed = options.speed;
            }
            ani.repeatDelay = options.repeatDelay;
            if(options.swing)
            {
               ani.swing = true;
            }
            UtilsFile.saveBytes(pi.file,ani.save());
            project.editorWindow.closeWaiting();
            if(onSuccess != null)
            {
               if(onSuccess.length > 0)
               {
                  onSuccess(pi.id);
               }
               else
               {
                  onSuccess();
               }
            }
         };
         importCallback.failed = function():void
         {
            project.editorWindow.closeWaiting();
            if(onFail != null)
            {
               if(onFail.length > 0)
               {
                  onFail(importCallback.msgs.join("\n"));
               }
               else
               {
                  onFail();
               }
            }
         };
         this.project.editorWindow.showWaiting(Consts.g.text86 + "...");
         AniImporter.importImages(files,ani,!this._project.usingAtlas,importCallback);
      }
      
      public function createVideo(param1:String, param2:String, param3:Array, param4:Object, param5:Function, param6:Function) : void
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         param4 = param4;
         param5 = param5;
         param6 = param6;
         var pi:EPackageItem = null;
         var ani:AniDef = null;
         var importCallback:Callback = null;
         var resName:String = param1;
         var folderPath:String = param2;
         var files:Array = param3;
         var options:Object = param4;
         var onSuccess:Function = param5;
         var onFail:Function = param6;
         pi = this.createNewMovieClip(resName,folderPath,true);
         ani = this.getMovieClip(pi);
         importCallback = new Callback();
         importCallback.success = function():void
         {
            if(options == null)
            {
               options = {};
            }
            if(options.speed)
            {
               ani.speed = options.speed;
            }
            ani.repeatDelay = options.repeatDelay;
            if(options.swing)
            {
               ani.swing = true;
            }
            UtilsFile.saveBytes(pi.file,ani.save());
            project.editorWindow.closeWaiting();
            if(onSuccess != null)
            {
               if(onSuccess.length > 0)
               {
                  onSuccess(pi.id);
               }
               else
               {
                  onSuccess();
               }
            }
         };
         importCallback.failed = function():void
         {
            project.editorWindow.closeWaiting();
            if(onFail != null)
            {
               if(onFail.length > 0)
               {
                  onFail(importCallback.msgs.join("\n"));
               }
               else
               {
                  onFail();
               }
            }
         };
         this.project.editorWindow.showWaiting(Consts.g.text86 + "...");
         AniImporter.importImages(files,ani,!this._project.usingAtlas,importCallback);
      }
      
      public function createComponent(param1:String, param2:int, param3:int, param4:String, param5:XML) : String
      {
         var _loc6_:EPackageItem = this.createNewComponent(param1,param2,param3,param4,null,param5,false);
         return _loc6_.id;
      }
   }
}
