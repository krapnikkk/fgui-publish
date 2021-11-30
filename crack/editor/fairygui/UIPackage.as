package fairygui
{
   import fairygui.display.Frame;
   import fairygui.text.BMGlyph;
   import fairygui.text.BitmapFont;
   import fairygui.utils.GTimers;
   import fairygui.utils.PixelHitTestData;
   import fairygui.utils.ToolSet;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.media.Sound;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   
   public class UIPackage
   {
      
      static var _constructing:int;
      
      private static var _packageInstById:Object = {};
      
      private static var _packageInstByName:Object = {};
      
      private static var _bitmapFonts:Object = {};
      
      private static var _loadingQueue:Array = [];
      
      private static var _stringsSource:Object = null;
       
      
      private var _id:String;
      
      private var _name:String;
      
      private var _basePath:String;
      
      private var _items:Vector.<PackageItem>;
      
      private var _itemsById:Object;
      
      private var _itemsByName:Object;
      
      private var _hitTestDatas:Object;
      
      private var _customId:String;
      
      private var _reader:IUIPackageReader;
      
      public function UIPackage()
      {
         super();
         _items = new Vector.<PackageItem>();
         _hitTestDatas = {};
      }
      
      public static function getById(param1:String) : UIPackage
      {
         return _packageInstById[param1];
      }
      
      public static function getByName(param1:String) : UIPackage
      {
         return _packageInstByName[param1];
      }
      
      public static function addPackage(param1:ByteArray, param2:ByteArray) : UIPackage
      {
         var _loc4_:UIPackage = new UIPackage();
         var _loc3_:ZipUIPackageReader = new ZipUIPackageReader(param1,param2);
         _loc4_.create(_loc3_);
         _packageInstById[_loc4_.id] = _loc4_;
         _packageInstByName[_loc4_.name] = _loc4_;
         return _loc4_;
      }
      
      public static function addPackage2(param1:IUIPackageReader) : UIPackage
      {
         var _loc2_:UIPackage = new UIPackage();
         _loc2_.create(param1);
         _packageInstById[_loc2_.id] = _loc2_;
         _packageInstByName[_loc2_.name] = _loc2_;
         return _loc2_;
      }
      
      public static function removePackage(param1:String) : void
      {
         var _loc2_:UIPackage = _packageInstById[param1];
         _loc2_.dispose();
         delete _packageInstById[_loc2_.id];
         if(_loc2_._customId != null)
         {
            delete _packageInstById[_loc2_._customId];
         }
      }
      
      public static function createObject(param1:String, param2:String, param3:Object = null) : GObject
      {
         var _loc4_:UIPackage = getByName(param1);
         if(_loc4_)
         {
            return _loc4_.createObject(param2,param3);
         }
         return null;
      }
      
      public static function createObjectFromURL(param1:String, param2:Object = null) : GObject
      {
         var _loc3_:PackageItem = getItemByURL(param1);
         if(_loc3_)
         {
            return _loc3_.owner.internalCreateObject(_loc3_,param2);
         }
         return null;
      }
      
      public static function getItemURL(param1:String, param2:String) : String
      {
         var _loc3_:UIPackage = getByName(param1);
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:PackageItem = _loc3_._itemsByName[param2];
         if(!_loc4_)
         {
            return null;
         }
         return "ui://" + _loc3_.id + _loc4_.id;
      }
      
      public static function getItemByURL(param1:String) : PackageItem
      {
         var _loc5_:* = null;
         var _loc7_:* = null;
         var _loc6_:* = null;
         var _loc3_:* = null;
         var _loc8_:* = null;
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:int = param1.indexOf("//");
         if(_loc2_ == -1)
         {
            return null;
         }
         var _loc4_:int = param1.indexOf("/",_loc2_ + 2);
         if(_loc4_ == -1)
         {
            if(param1.length > 13)
            {
               _loc5_ = param1.substr(5,8);
               _loc7_ = getById(_loc5_);
               if(_loc7_ != null)
               {
                  _loc6_ = param1.substr(13);
                  return _loc7_.getItemById(_loc6_);
               }
            }
         }
         else
         {
            _loc3_ = param1.substr(_loc2_ + 2,_loc4_ - _loc2_ - 2);
            _loc7_ = getByName(_loc3_);
            if(_loc7_ != null)
            {
               _loc8_ = param1.substr(_loc4_ + 1);
               return _loc7_.getItemByName(_loc8_);
            }
         }
         return null;
      }
      
      public static function normalizeURL(param1:String) : String
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:int = param1.indexOf("//");
         if(_loc2_ == -1)
         {
            return null;
         }
         var _loc4_:int = param1.indexOf("/",_loc2_ + 2);
         if(_loc4_ == -1)
         {
            return param1;
         }
         var _loc3_:String = param1.substr(_loc2_ + 2,_loc4_ - _loc2_ - 2);
         var _loc5_:String = param1.substr(_loc4_ + 1);
         return getItemURL(_loc3_,_loc5_);
      }
      
      public static function getBitmapFontByURL(param1:String) : BitmapFont
      {
         return _bitmapFonts[param1];
      }
      
      public static function setStringsSource(param1:XML) : void
      {
         var _loc8_:* = null;
         var _loc4_:* = null;
         var _loc9_:int = 0;
         var _loc5_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         _stringsSource = {};
         var _loc7_:XMLList = param1.string;
         var _loc11_:int = 0;
         var _loc10_:* = _loc7_;
         for each(var _loc6_ in _loc7_)
         {
            _loc8_ = _loc6_.@name;
            _loc4_ = _loc6_.toString();
            _loc9_ = _loc8_.indexOf("-");
            if(_loc9_ != -1)
            {
               _loc5_ = _loc8_.substr(0,_loc9_);
               _loc2_ = _loc8_.substr(_loc9_ + 1);
               _loc3_ = _stringsSource[_loc5_];
               if(!_loc3_)
               {
                  _loc3_ = {};
                  _stringsSource[_loc5_] = _loc3_;
               }
               _loc3_[_loc2_] = _loc4_;
            }
         }
      }
      
      public static function loadingCount() : int
      {
         return _loadingQueue.length;
      }
      
      public static function waitToLoadCompleted(param1:Function) : void
      {
         GTimers.inst.add(10,0,checkComplete,param1);
      }
      
      private static function checkComplete(param1:Function) : void
      {
         if(_loadingQueue.length == 0)
         {
            GTimers.inst.remove(checkComplete);
            param1();
         }
      }
      
      private function create(param1:IUIPackageReader) : void
      {
         var _loc10_:* = null;
         var _loc9_:* = null;
         var _loc7_:* = null;
         var _loc12_:* = null;
         var _loc11_:int = 0;
         _reader = param1;
         var _loc6_:String = _reader.readDescFile("package.xml");
         var _loc5_:Boolean = XML.ignoreWhitespace;
         XML.ignoreWhitespace = true;
         var _loc8_:XML = new XML(_loc6_);
         XML.ignoreWhitespace = _loc5_;
         _id = _loc8_.@id;
         _name = _loc8_.@name;
         var _loc2_:XMLList = _loc8_.resources.elements();
         _itemsById = {};
         _itemsByName = {};
         var _loc14_:int = 0;
         var _loc13_:* = _loc2_;
         for each(_loc9_ in _loc2_)
         {
            _loc10_ = new PackageItem();
            _loc10_.owner = this;
            _loc10_.type = PackageItemType.parseType(_loc9_.name().localName);
            _loc10_.id = _loc9_.@id;
            _loc10_.name = _loc9_.@name;
            _loc10_.file = _loc9_.@file;
            _loc6_ = _loc9_.@size;
            _loc7_ = _loc6_.split(",");
            _loc10_.width = int(_loc7_[0]);
            _loc10_.height = int(_loc7_[1]);
            switch(int(_loc10_.type))
            {
               case 0:
                  _loc6_ = _loc9_.@scale;
                  if(_loc6_ == "9grid")
                  {
                     _loc10_.scale9Grid = new Rectangle();
                     _loc6_ = _loc9_.@scale9grid;
                     _loc7_ = _loc6_.split(",");
                     _loc10_.scale9Grid.x = _loc7_[0];
                     _loc10_.scale9Grid.y = _loc7_[1];
                     _loc10_.scale9Grid.width = _loc7_[2];
                     _loc10_.scale9Grid.height = _loc7_[3];
                     _loc6_ = _loc9_.@gridTile;
                     if(_loc6_)
                     {
                        _loc10_.tileGridIndice = parseInt(_loc6_);
                     }
                  }
                  else if(_loc6_ == "tile")
                  {
                     _loc10_.scaleByTile = true;
                  }
                  _loc6_ = _loc9_.@smoothing;
                  _loc10_.smoothing = _loc6_ != "false";
                  break;
               default:
                  _loc6_ = _loc9_.@scale;
                  if(_loc6_ == "9grid")
                  {
                     _loc10_.scale9Grid = new Rectangle();
                     _loc6_ = _loc9_.@scale9grid;
                     _loc7_ = _loc6_.split(",");
                     _loc10_.scale9Grid.x = _loc7_[0];
                     _loc10_.scale9Grid.y = _loc7_[1];
                     _loc10_.scale9Grid.width = _loc7_[2];
                     _loc10_.scale9Grid.height = _loc7_[3];
                     _loc6_ = _loc9_.@gridTile;
                     if(_loc6_)
                     {
                        _loc10_.tileGridIndice = parseInt(_loc6_);
                     }
                  }
                  else if(_loc6_ == "tile")
                  {
                     _loc10_.scaleByTile = true;
                  }
                  _loc6_ = _loc9_.@smoothing;
                  _loc10_.smoothing = _loc6_ != "false";
                  break;
               case 2:
                  _loc6_ = _loc9_.@smoothing;
                  _loc10_.smoothing = _loc6_ != "false";
                  break;
               default:
                  _loc6_ = _loc9_.@smoothing;
                  _loc10_.smoothing = _loc6_ != "false";
                  break;
               case 4:
                  UIObjectFactory.resolvePackageItemExtension(_loc10_);
            }
            _items.push(_loc10_);
            _itemsById[_loc10_.id] = _loc10_;
            if(_loc10_.name != null)
            {
               _itemsByName[_loc10_.name] = _loc10_;
            }
         }
         var _loc4_:ByteArray = _reader.readResFile("hittest.bytes");
         if(_loc4_ != null)
         {
            while(_loc4_.bytesAvailable)
            {
               _loc12_ = new PixelHitTestData();
               _hitTestDatas[_loc4_.readUTF()] = _loc12_;
               _loc12_.load(_loc4_);
            }
         }
         var _loc3_:int = _items.length;
         _loc11_ = 0;
         while(_loc11_ < _loc3_)
         {
            _loc10_ = _items[_loc11_];
            if(_loc10_.type == 6)
            {
               loadFont(_loc10_);
               _bitmapFonts[_loc10_.bitmapFont.id] = _loc10_.bitmapFont;
            }
            _loc11_++;
         }
      }
      
      public function loadAllImages() : void
      {
         var _loc3_:int = 0;
         var _loc2_:* = null;
         var _loc1_:int = _items.length;
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = _items[_loc3_];
            if(!(_loc2_.type != 0 || _loc2_.image != null || _loc2_.loading))
            {
               loadImage(_loc2_);
            }
            _loc3_++;
         }
      }
      
      public function dispose() : void
      {
         var _loc6_:int = 0;
         var _loc5_:* = null;
         var _loc3_:* = null;
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:int = _items.length;
         _loc6_ = 0;
         while(_loc6_ < _loc1_)
         {
            _loc5_ = _items[_loc6_];
            _loc3_ = _loc5_.image;
            if(_loc3_ != null)
            {
               _loc3_.dispose();
            }
            else if(_loc5_.frames != null)
            {
               _loc2_ = _loc5_.frames.length;
               _loc4_ = 0;
               while(_loc4_ < _loc2_)
               {
                  _loc3_ = _loc5_.frames[_loc4_].image;
                  if(_loc3_ != null)
                  {
                     _loc3_.dispose();
                  }
                  _loc4_++;
               }
            }
            else if(_loc5_.bitmapFont != null)
            {
               delete _bitmapFonts[_loc5_.bitmapFont.id];
               _loc5_.bitmapFont.dispose();
            }
            _loc6_++;
         }
      }
      
      public function get id() : String
      {
         return _id;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function get customId() : String
      {
         return _customId;
      }
      
      public function set customId(param1:String) : void
      {
         if(_customId != null)
         {
            delete _packageInstById[_customId];
         }
         _customId = param1;
         if(_customId != null)
         {
            _packageInstById[_customId] = this;
         }
      }
      
      public function createObject(param1:String, param2:Object = null) : GObject
      {
         var _loc3_:PackageItem = _itemsByName[param1];
         if(_loc3_)
         {
            return internalCreateObject(_loc3_,param2);
         }
         return null;
      }
      
      function internalCreateObject(param1:PackageItem, param2:Object) : GObject
      {
         var _loc3_:GObject = null;
         if(param1.type == 4)
         {
            if(param2 != null)
            {
               if(param2 is Class)
               {
                  _loc3_ = new param2();
               }
               else
               {
                  _loc3_ = GObject(param2);
               }
            }
            else
            {
               _loc3_ = UIObjectFactory.newObject(param1);
            }
         }
         else
         {
            _loc3_ = UIObjectFactory.newObject(param1);
         }
         if(_loc3_ == null)
         {
            return null;
         }
         _constructing = Number(_constructing) + 1;
         _loc3_.packageItem = param1;
         _loc3_.constructFromResource();
         _constructing = Number(_constructing) - 1;
         return _loc3_;
      }
      
      public function getItemById(param1:String) : PackageItem
      {
         return _itemsById[param1];
      }
      
      public function getItemByName(param1:String) : PackageItem
      {
         return _itemsByName[param1];
      }
      
      private function getXMLDesc(param1:String) : XML
      {
         var _loc3_:Boolean = XML.ignoreWhitespace;
         XML.ignoreWhitespace = true;
         var _loc2_:XML = new XML(_reader.readDescFile(param1));
         XML.ignoreWhitespace = _loc3_;
         return _loc2_;
      }
      
      public function getItemRaw(param1:PackageItem) : ByteArray
      {
         return _reader.readResFile(param1.file);
      }
      
      public function getImage(param1:String) : BitmapData
      {
         var _loc2_:PackageItem = _itemsByName[param1];
         if(_loc2_)
         {
            return _loc2_.image;
         }
         return null;
      }
      
      public function getPixelHitTestData(param1:String) : PixelHitTestData
      {
         return _hitTestDatas[param1];
      }
      
      public function getComponentData(param1:PackageItem) : XML
      {
         var _loc2_:* = null;
         if(!param1.componentData)
         {
            _loc2_ = getXMLDesc(param1.id + ".xml");
            param1.componentData = _loc2_;
            loadComponentChildren(param1);
            translateComponent(param1);
         }
         return param1.componentData;
      }
      
      private function loadComponentChildren(param1:PackageItem) : void
      {
         var _loc2_:* = null;
         var _loc6_:int = 0;
         var _loc5_:* = null;
         var _loc12_:int = 0;
         var _loc10_:* = null;
         var _loc7_:* = null;
         var _loc9_:* = null;
         var _loc4_:* = null;
         var _loc8_:* = null;
         var _loc11_:* = null;
         var _loc3_:XML = param1.componentData.displayList[0];
         if(_loc3_ != null)
         {
            _loc2_ = _loc3_.elements();
            _loc6_ = _loc2_.length();
            param1.displayList = new Vector.<DisplayListItem>(_loc6_);
            _loc12_ = 0;
            while(_loc12_ < _loc6_)
            {
               _loc10_ = _loc2_[_loc12_];
               _loc7_ = _loc10_.name().localName;
               _loc9_ = _loc10_.@src;
               if(_loc9_)
               {
                  _loc4_ = _loc10_.@pkg;
                  if(_loc4_ && _loc4_ != param1.owner.id)
                  {
                     _loc8_ = UIPackage.getById(_loc4_);
                  }
                  else
                  {
                     _loc8_ = param1.owner;
                  }
                  _loc11_ = _loc8_ != null?_loc8_.getItemById(_loc9_):null;
                  if(_loc11_ != null)
                  {
                     _loc5_ = new DisplayListItem(_loc11_,null);
                  }
                  else
                  {
                     _loc5_ = new DisplayListItem(null,_loc7_);
                  }
               }
               else if(_loc7_ == "text" && _loc10_.@input == "true")
               {
                  _loc5_ = new DisplayListItem(null,"inputtext");
               }
               else
               {
                  _loc5_ = new DisplayListItem(null,_loc7_);
               }
               _loc5_.desc = _loc10_;
               param1.displayList[_loc12_] = _loc5_;
               _loc12_++;
            }
         }
         else
         {
            param1.displayList = new Vector.<DisplayListItem>(0);
         }
      }
      
      private function translateComponent(param1:PackageItem) : void
      {
         var _loc7_:* = undefined;
         var _loc5_:* = null;
         var _loc11_:* = null;
         var _loc12_:int = 0;
         var _loc6_:* = null;
         var _loc2_:* = null;
         var _loc4_:* = null;
         var _loc10_:int = 0;
         if(_stringsSource == null)
         {
            return;
         }
         var _loc8_:Object = _stringsSource[this.id + param1.id];
         if(_loc8_ == null)
         {
            return;
         }
         var _loc3_:int = param1.displayList.length;
         _loc12_ = 0;
         while(_loc12_ < _loc3_)
         {
            _loc11_ = param1.displayList[_loc12_].desc;
            _loc6_ = _loc11_.name().localName;
            _loc2_ = _loc11_.@id;
            if(_loc11_.@tooltips.length() > 0)
            {
               _loc7_ = _loc8_[_loc2_ + "-tips"];
               if(_loc7_ != undefined)
               {
                  _loc11_.@tooltips = _loc7_;
               }
            }
            _loc5_ = _loc11_.gearText[0];
            if(_loc5_)
            {
               _loc7_ = _loc8_[_loc2_ + "-texts"];
               if(_loc7_ != undefined)
               {
                  _loc5_.@values = _loc7_;
               }
               _loc7_ = _loc8_[_loc2_ + "-texts_def"];
               if(_loc7_ != undefined)
               {
                  _loc5_["default"] = _loc7_;
               }
            }
            if(_loc6_ == "text" || _loc6_ == "richtext")
            {
               _loc7_ = _loc8_[_loc2_];
               if(_loc7_ != undefined)
               {
                  _loc11_.@text = _loc7_;
               }
               _loc7_ = _loc8_[_loc2_ + "-prompt"];
               if(_loc7_ != undefined)
               {
                  _loc11_.@prompt = _loc7_;
               }
            }
            else if(_loc6_ == "list")
            {
               _loc4_ = _loc11_.item;
               _loc10_ = 0;
               var _loc14_:int = 0;
               var _loc13_:* = _loc4_;
               for each(var _loc9_ in _loc4_)
               {
                  _loc7_ = _loc8_[_loc2_ + "-" + _loc10_];
                  if(_loc7_ != undefined)
                  {
                     _loc9_.@title = _loc7_;
                  }
                  _loc10_++;
               }
            }
            else if(_loc6_ == "component")
            {
               _loc5_ = _loc11_.Button[0];
               if(_loc5_)
               {
                  _loc7_ = _loc8_[_loc2_];
                  if(_loc7_ != undefined)
                  {
                     _loc5_.@title = _loc7_;
                  }
                  _loc7_ = _loc8_[_loc2_ + "-0"];
                  if(_loc7_ != undefined)
                  {
                     _loc5_.@selectedTitle = _loc7_;
                  }
               }
               else
               {
                  _loc5_ = _loc11_.Label[0];
                  if(_loc5_)
                  {
                     _loc7_ = _loc8_[_loc2_];
                     if(_loc7_ != undefined)
                     {
                        _loc5_.@title = _loc7_;
                     }
                     _loc7_ = _loc8_[_loc2_ + "-prompt"];
                     if(_loc7_ != undefined)
                     {
                        _loc5_.@prompt = _loc7_;
                     }
                  }
                  else
                  {
                     _loc5_ = _loc11_.ComboBox[0];
                     if(_loc5_)
                     {
                        _loc7_ = _loc8_[_loc2_];
                        if(_loc7_ != undefined)
                        {
                           _loc5_.@title = _loc7_;
                        }
                        _loc4_ = _loc5_.item;
                        _loc10_ = 0;
                        var _loc16_:int = 0;
                        var _loc15_:* = _loc4_;
                        for each(_loc9_ in _loc4_)
                        {
                           _loc7_ = _loc8_[_loc2_ + "-" + _loc10_];
                           if(_loc7_ != undefined)
                           {
                              _loc9_.@title = _loc7_;
                           }
                           _loc10_++;
                        }
                     }
                  }
               }
            }
            _loc12_++;
         }
      }
      
      public function getSound(param1:PackageItem) : Sound
      {
         if(!param1.loaded)
         {
            loadSound(param1);
         }
         return param1.sound;
      }
      
      public function addCallback(param1:String, param2:Function) : void
      {
         var _loc3_:PackageItem = _itemsByName[param1];
         if(_loc3_)
         {
            addItemCallback(_loc3_,param2);
         }
      }
      
      public function removeCallback(param1:String, param2:Function) : void
      {
         var _loc3_:PackageItem = _itemsByName[param1];
         if(_loc3_)
         {
            removeItemCallback(_loc3_,param2);
         }
      }
      
      public function addItemCallback(param1:PackageItem, param2:Function) : void
      {
         param1.lastVisitTime = getTimer();
         if(param1.type == 0)
         {
            if(param1.loaded)
            {
               GTimers.inst.add(0,1,param2);
               return;
            }
            param1.addCallback(param2);
            if(param1.loading)
            {
               return;
            }
            loadImage(param1);
         }
         else if(param1.type == 2)
         {
            if(param1.loaded)
            {
               GTimers.inst.add(0,1,param2);
               return;
            }
            param1.addCallback(param2);
            if(param1.loading)
            {
               return;
            }
            loadMovieClip(param1);
         }
         else if(param1.type == 1)
         {
            param1.addCallback(param2);
            loadSwf(param1);
         }
         else if(param1.type == 3)
         {
            if(!param1.loaded)
            {
               loadSound(param1);
            }
            GTimers.inst.add(0,1,param2);
         }
      }
      
      public function removeItemCallback(param1:PackageItem, param2:Function) : void
      {
         param1.removeCallback(param2);
      }
      
      private function loadImage(param1:PackageItem) : void
      {
         var _loc2_:ByteArray = _reader.readResFile(param1.file);
         var _loc3_:PackageItemLoader = new PackageItemLoader();
         _loc3_.contentLoaderInfo.addEventListener("complete",__imageLoaded);
         _loc3_.loadBytes(_loc2_);
         _loc3_.item = param1;
         param1.loading = 1;
         _loadingQueue.push(_loc3_);
      }
      
      private function __imageLoaded(param1:Event) : void
      {
         var _loc2_:PackageItemLoader = PackageItemLoader(LoaderInfo(param1.currentTarget).loader);
         var _loc4_:int = _loadingQueue.indexOf(_loc2_);
         if(_loc4_ == -1)
         {
            return;
         }
         _loadingQueue.splice(_loc4_,1);
         var _loc3_:PackageItem = _loc2_.item;
         _loc3_.image = Bitmap(_loc2_.content).bitmapData;
         _loc3_.completeLoading();
      }
      
      private function loadSwf(param1:PackageItem) : void
      {
         var _loc2_:ByteArray = _reader.readResFile(param1.file);
         var _loc3_:PackageItemLoader = new PackageItemLoader();
         _loc3_.contentLoaderInfo.addEventListener("complete",__swfLoaded);
         var _loc4_:LoaderContext = new LoaderContext();
         _loc4_.allowCodeImport = true;
         _loc3_.loadBytes(_loc2_,_loc4_);
         _loc3_.item = param1;
         _loadingQueue.push(_loc3_);
      }
      
      private function __swfLoaded(param1:Event) : void
      {
         var _loc2_:PackageItemLoader = PackageItemLoader(LoaderInfo(param1.currentTarget).loader);
         var _loc5_:int = _loadingQueue.indexOf(_loc2_);
         if(_loc5_ == -1)
         {
            return;
         }
         _loadingQueue.splice(_loc5_,1);
         var _loc4_:PackageItem = _loc2_.item;
         var _loc3_:Function = _loc4_.callbacks.pop();
         if(_loc3_ != null)
         {
            _loc3_(_loc2_.content);
         }
      }
      
      private function loadMovieClip(param1:PackageItem) : void
      {
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc11_:int = 0;
         var _loc3_:* = null;
         var _loc8_:* = null;
         var _loc4_:* = null;
         var _loc7_:* = null;
         var _loc10_:XML = getXMLDesc(param1.id + ".xml");
         _loc5_ = _loc10_.@interval;
         if(_loc5_ != null)
         {
            param1.interval = parseInt(_loc5_);
         }
         _loc5_ = _loc10_.@swing;
         if(_loc5_ != null)
         {
            param1.swing = _loc5_ == "true";
         }
         _loc5_ = _loc10_.@repeatDelay;
         if(_loc5_ != null)
         {
            param1.repeatDelay = parseInt(_loc5_);
         }
         var _loc9_:int = parseInt(_loc10_.@frameCount);
         param1.frames = new Vector.<Frame>(_loc9_);
         var _loc2_:XMLList = _loc10_.frames.elements();
         _loc11_ = 0;
         while(_loc11_ < _loc9_)
         {
            _loc3_ = new Frame();
            _loc8_ = _loc2_[_loc11_];
            _loc5_ = _loc8_.@rect;
            _loc6_ = _loc5_.split(",");
            _loc3_.rect = new Rectangle(parseInt(_loc6_[0]),parseInt(_loc6_[1]),parseInt(_loc6_[2]),parseInt(_loc6_[3]));
            _loc5_ = _loc8_.@addDelay;
            _loc3_.addDelay = parseInt(_loc5_);
            param1.frames[_loc11_] = _loc3_;
            if(_loc3_.rect.width != 0)
            {
               _loc5_ = _loc8_.@sprite;
               if(_loc5_)
               {
                  _loc5_ = param1.id + "_" + _loc5_ + ".png";
               }
               else
               {
                  _loc5_ = param1.id + "_" + _loc11_ + ".png";
               }
               _loc4_ = _reader.readResFile(_loc5_);
               if(_loc4_)
               {
                  _loc7_ = new FrameLoader();
                  _loc7_.contentLoaderInfo.addEventListener("complete",__frameLoaded);
                  _loc7_.loadBytes(_loc4_);
                  _loc7_.item = param1;
                  _loc7_.frame = _loc3_;
                  _loadingQueue.push(_loc7_);
                  param1.loading++;
               }
            }
            _loc11_++;
         }
      }
      
      private function __frameLoaded(param1:Event) : void
      {
         var _loc3_:FrameLoader = FrameLoader(param1.currentTarget.loader);
         var _loc5_:int = _loadingQueue.indexOf(_loc3_);
         if(_loc5_ == -1)
         {
            return;
         }
         _loadingQueue.splice(_loc5_,1);
         var _loc4_:PackageItem = _loc3_.item;
         var _loc2_:Frame = _loc3_.frame;
         _loc2_.image = Bitmap(_loc3_.content).bitmapData;
         _loc4_.loading = Number(_loc4_.loading) - 1;
         if(_loc4_.loading == 0)
         {
            _loc4_.completeLoading();
         }
      }
      
      private function loadSound(param1:PackageItem) : void
      {
         var _loc3_:Sound = new Sound();
         var _loc2_:ByteArray = _reader.readResFile(param1.file);
         _loc3_.loadCompressedDataFromByteArray(_loc2_,_loc2_.length);
         param1.sound = _loc3_;
         param1.loaded = true;
      }
      
      private function loadFont(param1:PackageItem) : void
      {
         var _loc12_:int = 0;
         var _loc5_:* = null;
         var _loc11_:int = 0;
         var _loc18_:* = null;
         var _loc16_:* = null;
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc6_:* = null;
         var _loc7_:BitmapFont = new BitmapFont();
         _loc7_.id = "ui://" + this.id + param1.id;
         var _loc14_:String = _reader.readDescFile(param1.id + ".fnt");
         var _loc19_:Array = _loc14_.split("\n");
         var _loc15_:int = _loc19_.length;
         var _loc9_:Object = {};
         var _loc8_:* = false;
         var _loc13_:* = 0;
         var _loc10_:int = 0;
         var _loc17_:* = false;
         var _loc20_:* = false;
         var _loc2_:* = 0;
         _loc12_ = 0;
         while(_loc12_ < _loc15_)
         {
            _loc14_ = _loc19_[_loc12_];
            if(_loc14_.length != 0)
            {
               _loc14_ = ToolSet.trim(_loc14_);
               _loc5_ = _loc14_.split(" ");
               _loc11_ = 1;
               while(_loc11_ < _loc5_.length)
               {
                  _loc18_ = _loc5_[_loc11_].split("=");
                  _loc9_[_loc18_[0]] = _loc18_[1];
                  _loc11_++;
               }
               _loc14_ = _loc5_[0];
               if(_loc14_ == "char")
               {
                  _loc16_ = new BMGlyph();
                  _loc16_.x = _loc9_.x;
                  _loc16_.y = _loc9_.y;
                  _loc16_.offsetX = _loc9_.xoffset;
                  _loc16_.offsetY = _loc9_.yoffset;
                  _loc16_.width = _loc9_.width;
                  _loc16_.height = _loc9_.height;
                  _loc16_.advance = _loc9_.xadvance;
                  _loc16_.channel = _loc7_.translateChannel(_loc9_.chnl);
                  if(!_loc8_)
                  {
                     if(_loc9_.img)
                     {
                        _loc4_ = _itemsById[_loc9_.img];
                        if(_loc4_ != null)
                        {
                           _loc16_.imageItem = _loc4_;
                           _loc16_.width = _loc4_.width;
                           _loc16_.height = _loc4_.height;
                           loadImage(_loc4_);
                        }
                     }
                  }
                  if(_loc8_)
                  {
                     _loc16_.lineHeight = _loc2_;
                  }
                  else
                  {
                     if(_loc16_.advance == 0)
                     {
                        if(_loc10_ == 0)
                        {
                           _loc16_.advance = _loc16_.offsetX + _loc16_.width;
                        }
                        else
                        {
                           _loc16_.advance = _loc10_;
                        }
                     }
                     _loc16_.lineHeight = _loc16_.offsetY < 0?_loc16_.height:_loc16_.offsetY + _loc16_.height;
                     if(_loc13_ > 0 && _loc16_.lineHeight < _loc13_)
                     {
                        _loc16_.lineHeight = _loc13_;
                     }
                  }
                  _loc7_.glyphs[String.fromCharCode(_loc9_.id)] = _loc16_;
               }
               else if(_loc14_ == "info")
               {
                  _loc8_ = _loc9_.face != null;
                  _loc20_ = _loc8_;
                  _loc13_ = int(_loc9_.size);
                  _loc17_ = _loc9_.resizable == "true";
                  if(_loc9_.colored != undefined)
                  {
                     _loc20_ = _loc9_.colored == "true";
                  }
                  if(_loc8_)
                  {
                     _loc3_ = _reader.readResFile(param1.id + ".png");
                     _loc6_ = new PackageItemLoader();
                     _loc6_.contentLoaderInfo.addEventListener("complete",__fontAtlasLoaded);
                     _loc6_.loadBytes(_loc3_);
                     _loc6_.item = param1;
                     _loadingQueue.push(_loc6_);
                  }
               }
               else if(_loc14_ == "common")
               {
                  _loc2_ = int(_loc9_.lineHeight);
                  if(_loc13_ == 0)
                  {
                     _loc13_ = _loc2_;
                  }
                  else if(_loc2_ == 0)
                  {
                     _loc2_ = _loc13_;
                  }
                  _loc10_ = _loc9_.xadvance;
               }
            }
            _loc12_++;
         }
         if(_loc13_ == 0 && _loc16_)
         {
            _loc13_ = int(_loc16_.height);
         }
         _loc7_.ttf = _loc8_;
         _loc7_.size = _loc13_;
         _loc7_.resizable = _loc17_;
         _loc7_.colored = _loc20_;
         param1.bitmapFont = _loc7_;
      }
      
      private function __fontAtlasLoaded(param1:Event) : void
      {
         var _loc2_:PackageItemLoader = PackageItemLoader(LoaderInfo(param1.currentTarget).loader);
         var _loc4_:int = _loadingQueue.indexOf(_loc2_);
         if(_loc4_ == -1)
         {
            return;
         }
         _loadingQueue.splice(_loc4_,1);
         var _loc3_:PackageItem = _loc2_.item;
         _loc3_.bitmapFont.atlas = Bitmap(_loc2_.content).bitmapData;
      }
   }
}

import fairygui.PackageItem;
import flash.display.Loader;

class PackageItemLoader extends Loader
{
    
   
   public var item:PackageItem;
   
   function PackageItemLoader()
   {
      super();
   }
}

import fairygui.PackageItem;
import fairygui.display.Frame;
import flash.display.Loader;

class FrameLoader extends Loader
{
    
   
   public var item:PackageItem;
   
   public var frame:Frame;
   
   function FrameLoader()
   {
      super();
   }
}
