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
      
      public static var _constructing:int;
      
      private static var _packageInstById:Object = {};
      
      private static var _packageInstByName:Object = {};
      
      private static var _bitmapFonts:Object = {};
      
      private static var _loadingQueue:Array = [];
      
      private static var _stringsSource:Object = null;
      
      private static var _branch:String = null;
      
      private static var _vars:Object = {};
       
      
      private var _id:String;
      
      private var _name:String;
      
      private var _basePath:String;
      
      private var _items:Vector.<PackageItem>;
      
      private var _itemsById:Object;
      
      private var _itemsByName:Object;
      
      private var _hitTestDatas:Object;
      
      private var _customId:String;
      
      private var _branches:Array;
      
      var _branchIndex:int;
      
      private var _reader:IUIPackageReader;
      
      public function UIPackage()
      {
         super();
         _items = new Vector.<PackageItem>();
         _hitTestDatas = {};
         _branches = [];
         _branchIndex = -1;
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
         var _loc4_:UIPackage = getByName(param1);
         if(!_loc4_)
         {
            return null;
         }
         var _loc3_:PackageItem = _loc4_._itemsByName[param2];
         if(!_loc3_)
         {
            return null;
         }
         return "ui://" + _loc4_.id + _loc3_.id;
      }
      
      public static function getItemByURL(param1:String) : PackageItem
      {
         var _loc7_:* = null;
         var _loc8_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc2_:* = null;
         if(param1 == null)
         {
            return null;
         }
         var _loc5_:int = param1.indexOf("//");
         if(_loc5_ == -1)
         {
            return null;
         }
         var _loc6_:int = param1.indexOf("/",_loc5_ + 2);
         if(_loc6_ == -1)
         {
            if(param1.length > 13)
            {
               _loc7_ = param1.substr(5,8);
               _loc8_ = getById(_loc7_);
               if(_loc8_ != null)
               {
                  _loc3_ = param1.substr(13);
                  return _loc8_.getItemById(_loc3_);
               }
            }
         }
         else
         {
            _loc4_ = param1.substr(_loc5_ + 2,_loc6_ - _loc5_ - 2);
            _loc8_ = getByName(_loc4_);
            if(_loc8_ != null)
            {
               _loc2_ = param1.substr(_loc6_ + 1);
               return _loc8_.getItemByName(_loc2_);
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
         var _loc4_:int = param1.indexOf("//");
         if(_loc4_ == -1)
         {
            return null;
         }
         var _loc5_:int = param1.indexOf("/",_loc4_ + 2);
         if(_loc5_ == -1)
         {
            return param1;
         }
         var _loc3_:String = param1.substr(_loc4_ + 2,_loc5_ - _loc4_ - 2);
         var _loc2_:String = param1.substr(_loc5_ + 1);
         return getItemURL(_loc3_,_loc2_);
      }
      
      public static function getBitmapFontByURL(param1:String) : BitmapFont
      {
         return _bitmapFonts[param1];
      }
      
      public static function setStringsSource(param1:XML) : void
      {
         var _loc9_:* = null;
         var _loc7_:* = null;
         var _loc6_:int = 0;
         var _loc2_:* = null;
         var _loc5_:* = null;
         var _loc3_:* = null;
         _stringsSource = {};
         var _loc8_:XMLList = param1.string;
         var _loc11_:int = 0;
         var _loc10_:* = _loc8_;
         for each(var _loc4_ in _loc8_)
         {
            _loc9_ = _loc4_.@name;
            _loc7_ = _loc4_.toString();
            _loc6_ = _loc9_.indexOf("-");
            if(_loc6_ != -1)
            {
               _loc2_ = _loc9_.substr(0,_loc6_);
               _loc5_ = _loc9_.substr(_loc6_ + 1);
               _loc3_ = _stringsSource[_loc2_];
               if(!_loc3_)
               {
                  _loc3_ = {};
                  _stringsSource[_loc2_] = _loc3_;
               }
               _loc3_[_loc5_] = _loc7_;
            }
         }
      }
      
      public static function get branch() : String
      {
         return _branch;
      }
      
      public static function set branch(param1:String) : void
      {
         var _loc3_:* = null;
         _branch = param1;
         var _loc5_:int = 0;
         var _loc4_:* = _packageInstById;
         for(var _loc2_ in _packageInstById)
         {
            _loc3_ = _packageInstById[_loc2_];
            if(_loc3_._branches)
            {
               _loc3_._branchIndex = _loc3_._branches.indexOf(_branch);
            }
         }
      }
      
      public static function getVar(param1:String) : *
      {
         return _vars[param1];
      }
      
      public static function setVar(param1:String, param2:*) : void
      {
         if(param2 == undefined)
         {
            delete _vars[param1];
         }
         else
         {
            _vars[param1] = param2;
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
         var _loc8_:* = null;
         var _loc10_:* = null;
         var _loc11_:* = null;
         var _loc2_:* = null;
         var _loc6_:* = null;
         var _loc5_:int = 0;
         _reader = param1;
         var _loc7_:Boolean = XML.ignoreWhitespace;
         XML.ignoreWhitespace = true;
         _loc8_ = _reader.readDescFile("package.xml");
         var _loc9_:XML = new XML(_loc8_);
         XML.ignoreWhitespace = _loc7_;
         _id = _loc9_.@id;
         _name = _loc9_.@name;
         _loc8_ = _loc9_.@branches;
         if(_loc8_)
         {
            _branches = _loc8_.split(",");
            if(_branch)
            {
               _branchIndex = _branches.indexOf(_branch);
            }
         }
         var _loc12_:* = _branches.length > 0;
         _itemsById = {};
         _itemsByName = {};
         var _loc4_:XMLList = _loc9_.resources.elements();
         var _loc15_:int = 0;
         var _loc14_:* = _loc4_;
         for each(_loc11_ in _loc4_)
         {
            _loc10_ = new PackageItem();
            _loc10_.owner = this;
            _loc10_.type = PackageItemType.parseType(_loc11_.name().localName);
            _loc10_.id = _loc11_.@id;
            _loc10_.name = _loc11_.@name;
            _loc10_.file = _loc11_.@file;
            _loc8_ = _loc11_.@size;
            _loc2_ = _loc8_.split(",");
            _loc10_.width = int(_loc2_[0]);
            _loc10_.height = int(_loc2_[1]);
            _loc8_ = _loc11_.@branch;
            if(_loc8_)
            {
               _loc10_.name = _loc8_ + "/" + _loc10_.name;
            }
            _loc8_ = _loc11_.@branches;
            if(_loc8_)
            {
               if(_loc12_)
               {
                  _loc10_.branches = _loc8_.split(",");
               }
               else
               {
                  _itemsById[_loc8_] = _loc10_;
               }
            }
            switch(int(_loc10_.type))
            {
               case 0:
                  _loc8_ = _loc11_.@scale;
                  if(_loc8_ == "9grid")
                  {
                     _loc10_.scale9Grid = new Rectangle();
                     _loc8_ = _loc11_.@scale9grid;
                     _loc2_ = _loc8_.split(",");
                     _loc10_.scale9Grid.x = _loc2_[0];
                     _loc10_.scale9Grid.y = _loc2_[1];
                     _loc10_.scale9Grid.width = _loc2_[2];
                     _loc10_.scale9Grid.height = _loc2_[3];
                     _loc8_ = _loc11_.@gridTile;
                     if(_loc8_)
                     {
                        _loc10_.tileGridIndice = parseInt(_loc8_);
                     }
                  }
                  else if(_loc8_ == "tile")
                  {
                     _loc10_.scaleByTile = true;
                  }
                  _loc8_ = _loc11_.@smoothing;
                  _loc10_.smoothing = _loc8_ != "false";
                  _loc8_ = _loc11_.@highRes;
                  if(_loc8_)
                  {
                     _loc10_.highResolution = _loc8_.split(",");
                  }
                  break;
               default:
                  _loc8_ = _loc11_.@scale;
                  if(_loc8_ == "9grid")
                  {
                     _loc10_.scale9Grid = new Rectangle();
                     _loc8_ = _loc11_.@scale9grid;
                     _loc2_ = _loc8_.split(",");
                     _loc10_.scale9Grid.x = _loc2_[0];
                     _loc10_.scale9Grid.y = _loc2_[1];
                     _loc10_.scale9Grid.width = _loc2_[2];
                     _loc10_.scale9Grid.height = _loc2_[3];
                     _loc8_ = _loc11_.@gridTile;
                     if(_loc8_)
                     {
                        _loc10_.tileGridIndice = parseInt(_loc8_);
                     }
                  }
                  else if(_loc8_ == "tile")
                  {
                     _loc10_.scaleByTile = true;
                  }
                  _loc8_ = _loc11_.@smoothing;
                  _loc10_.smoothing = _loc8_ != "false";
                  _loc8_ = _loc11_.@highRes;
                  if(_loc8_)
                  {
                     _loc10_.highResolution = _loc8_.split(",");
                  }
                  break;
               case 2:
                  _loc8_ = _loc11_.@smoothing;
                  _loc10_.smoothing = _loc8_ != "false";
                  _loc8_ = _loc11_.@highRes;
                  if(_loc8_)
                  {
                     _loc10_.highResolution = _loc8_.split(",");
                  }
                  break;
               default:
                  _loc8_ = _loc11_.@smoothing;
                  _loc10_.smoothing = _loc8_ != "false";
                  _loc8_ = _loc11_.@highRes;
                  if(_loc8_)
                  {
                     _loc10_.highResolution = _loc8_.split(",");
                  }
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
         var _loc13_:ByteArray = _reader.readResFile("hittest.bytes");
         if(_loc13_ != null)
         {
            while(_loc13_.bytesAvailable)
            {
               _loc6_ = new PixelHitTestData();
               _hitTestDatas[_loc13_.readUTF()] = _loc6_;
               _loc6_.load(_loc13_);
            }
         }
         var _loc3_:int = _items.length;
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            _loc10_ = _items[_loc5_];
            if(_loc10_.type == 6)
            {
               loadFont(_loc10_);
               _bitmapFonts[_loc10_.bitmapFont.id] = _loc10_.bitmapFont;
            }
            _loc5_++;
         }
      }
      
      public function loadAllImages() : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc1_:int = _items.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = _items[_loc2_];
            if(!(_loc3_.type != 0 || _loc3_.image != null || _loc3_.loading))
            {
               loadImage(_loc3_);
            }
            _loc2_++;
         }
      }
      
      public function dispose() : void
      {
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:int = _items.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _items[_loc4_];
            _loc1_ = _loc5_.image;
            if(_loc1_ != null)
            {
               _loc1_.dispose();
            }
            else if(_loc5_.frames != null)
            {
               _loc2_ = _loc5_.frames.length;
               _loc6_ = 0;
               while(_loc6_ < _loc2_)
               {
                  _loc1_ = _loc5_.frames[_loc6_].image;
                  if(_loc1_ != null)
                  {
                     _loc1_.dispose();
                  }
                  _loc6_++;
               }
            }
            else if(_loc5_.bitmapFont != null)
            {
               delete _bitmapFonts[_loc5_.bitmapFont.id];
               _loc5_.bitmapFont.dispose();
            }
            _loc4_++;
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
         var _loc9_:int = 0;
         var _loc4_:* = null;
         var _loc6_:int = 0;
         var _loc8_:* = null;
         var _loc11_:* = null;
         var _loc5_:* = null;
         var _loc10_:* = null;
         var _loc12_:* = null;
         var _loc7_:* = null;
         var _loc3_:XML = param1.componentData.displayList[0];
         if(_loc3_ != null)
         {
            _loc2_ = _loc3_.elements();
            _loc9_ = _loc2_.length();
            param1.displayList = new Vector.<DisplayListItem>(_loc9_);
            _loc6_ = 0;
            while(_loc6_ < _loc9_)
            {
               _loc8_ = _loc2_[_loc6_];
               _loc11_ = _loc8_.name().localName;
               _loc5_ = _loc8_.@src;
               if(_loc5_)
               {
                  _loc10_ = _loc8_.@pkg;
                  if(_loc10_ && _loc10_ != param1.owner.id)
                  {
                     _loc12_ = UIPackage.getById(_loc10_);
                  }
                  else
                  {
                     _loc12_ = param1.owner;
                  }
                  _loc7_ = _loc12_ != null?_loc12_.getItemById(_loc5_):null;
                  if(_loc7_ != null)
                  {
                     _loc4_ = new DisplayListItem(_loc7_,null);
                  }
                  else
                  {
                     _loc4_ = new DisplayListItem(null,_loc11_);
                  }
               }
               else if(_loc11_ == "text" && _loc8_.@input == "true")
               {
                  _loc4_ = new DisplayListItem(null,"inputtext");
               }
               else if(_loc11_ == "list" && _loc8_.@treeView == "true")
               {
                  _loc4_ = new DisplayListItem(null,"tree");
               }
               else
               {
                  _loc4_ = new DisplayListItem(null,_loc11_);
               }
               _loc4_.desc = _loc8_;
               param1.displayList[_loc6_] = _loc4_;
               _loc6_++;
            }
         }
         else
         {
            param1.displayList = new Vector.<DisplayListItem>(0);
         }
      }
      
      private function translateComponent(param1:PackageItem) : void
      {
         var _loc12_:* = undefined;
         var _loc11_:* = null;
         var _loc10_:* = null;
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         var _loc8_:* = null;
         var _loc2_:* = null;
         var _loc7_:* = null;
         var _loc3_:* = null;
         var _loc13_:* = null;
         if(_stringsSource == null)
         {
            return;
         }
         var _loc9_:Object = _stringsSource[this.id + param1.id];
         if(_loc9_ == null)
         {
            return;
         }
         var _loc4_:int = param1.displayList.length;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc10_ = param1.displayList[_loc5_].desc;
            _loc8_ = _loc10_.name().localName;
            _loc2_ = _loc10_.@id;
            if(_loc10_.@tooltips.length() > 0)
            {
               _loc12_ = _loc9_[_loc2_ + "-tips"];
               if(_loc12_ != undefined)
               {
                  _loc10_.@tooltips = _loc12_;
               }
            }
            _loc11_ = _loc10_.gearText[0];
            if(_loc11_)
            {
               _loc7_ = _loc11_.@values;
               if(_loc7_)
               {
                  _loc3_ = _loc7_.split("|");
                  _loc6_ = 0;
                  while(_loc6_ < _loc3_.length)
                  {
                     _loc12_ = _loc9_[_loc2_ + "-texts_" + _loc6_];
                     if(_loc12_ != null)
                     {
                        _loc3_[_loc6_] = _loc12_;
                     }
                     _loc6_++;
                  }
                  _loc11_.@values = _loc3_.join("|");
               }
               _loc12_ = _loc9_[_loc2_ + "-texts_def"];
               if(_loc12_ != undefined)
               {
                  _loc11_["default"] = _loc12_;
               }
            }
            if(_loc8_ == "text" || _loc8_ == "richtext")
            {
               _loc12_ = _loc9_[_loc2_];
               if(_loc12_ != undefined)
               {
                  _loc10_.@text = _loc12_;
               }
               _loc12_ = _loc9_[_loc2_ + "-prompt"];
               if(_loc12_ != undefined)
               {
                  _loc10_.@prompt = _loc12_;
               }
            }
            else if(_loc8_ == "list")
            {
               _loc13_ = _loc10_.item;
               _loc6_ = 0;
               var _loc16_:int = 0;
               var _loc15_:* = _loc13_;
               for each(var _loc14_ in _loc13_)
               {
                  _loc12_ = _loc9_[_loc2_ + "-" + _loc6_];
                  if(_loc12_ != undefined)
                  {
                     _loc14_.@title = _loc12_;
                  }
                  _loc6_++;
               }
            }
            else if(_loc8_ == "component")
            {
               _loc11_ = _loc10_.Button[0];
               if(_loc11_)
               {
                  _loc12_ = _loc9_[_loc2_];
                  if(_loc12_ != undefined)
                  {
                     _loc11_.@title = _loc12_;
                  }
                  _loc12_ = _loc9_[_loc2_ + "-0"];
                  if(_loc12_ != undefined)
                  {
                     _loc11_.@selectedTitle = _loc12_;
                  }
               }
               else
               {
                  _loc11_ = _loc10_.Label[0];
                  if(_loc11_)
                  {
                     _loc12_ = _loc9_[_loc2_];
                     if(_loc12_ != undefined)
                     {
                        _loc11_.@title = _loc12_;
                     }
                     _loc12_ = _loc9_[_loc2_ + "-prompt"];
                     if(_loc12_ != undefined)
                     {
                        _loc11_.@prompt = _loc12_;
                     }
                  }
                  else
                  {
                     _loc11_ = _loc10_.ComboBox[0];
                     if(_loc11_)
                     {
                        _loc12_ = _loc9_[_loc2_];
                        if(_loc12_ != undefined)
                        {
                           _loc11_.@title = _loc12_;
                        }
                        _loc13_ = _loc11_.item;
                        _loc6_ = 0;
                        var _loc18_:int = 0;
                        var _loc17_:* = _loc13_;
                        for each(_loc14_ in _loc13_)
                        {
                           _loc12_ = _loc9_[_loc2_ + "-" + _loc6_];
                           if(_loc12_ != undefined)
                           {
                              _loc14_.@title = _loc12_;
                           }
                           _loc6_++;
                        }
                     }
                  }
               }
            }
            _loc5_++;
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
         var _loc3_:ByteArray = _reader.readResFile(param1.file);
         if(_loc3_ == null)
         {
            trace("cannot load " + param1.file);
            param1.completeLoading();
            return;
         }
         var _loc2_:PackageItemLoader = new PackageItemLoader();
         _loc2_.contentLoaderInfo.addEventListener("complete",__imageLoaded);
         _loc2_.contentLoaderInfo.addEventListener("ioError",__imageLoaded);
         _loc2_.item = param1;
         param1.loading = 1;
         _loadingQueue.push(_loc2_);
         _loc2_.loadBytes(_loc3_);
      }
      
      private function __imageLoaded(param1:Event) : void
      {
         var _loc2_:PackageItemLoader = PackageItemLoader(LoaderInfo(param1.currentTarget).loader);
         var _loc3_:int = _loadingQueue.indexOf(_loc2_);
         if(_loc3_ == -1)
         {
            return;
         }
         _loadingQueue.splice(_loc3_,1);
         var _loc4_:PackageItem = _loc2_.item;
         if(_loc2_.content)
         {
            _loc4_.image = Bitmap(_loc2_.content).bitmapData;
         }
         else
         {
            trace("load \'" + _loc4_.name + "," + _loc4_.file + "\' failed: " + param1.toString());
         }
         _loc4_.completeLoading();
      }
      
      private function loadSwf(param1:PackageItem) : void
      {
         var _loc4_:ByteArray = _reader.readResFile(param1.file);
         var _loc2_:PackageItemLoader = new PackageItemLoader();
         _loc2_.contentLoaderInfo.addEventListener("complete",__swfLoaded);
         var _loc3_:LoaderContext = new LoaderContext();
         _loc3_.allowCodeImport = true;
         _loc2_.loadBytes(_loc4_,_loc3_);
         _loc2_.item = param1;
         _loadingQueue.push(_loc2_);
      }
      
      private function __swfLoaded(param1:Event) : void
      {
         var _loc2_:PackageItemLoader = PackageItemLoader(LoaderInfo(param1.currentTarget).loader);
         var _loc3_:int = _loadingQueue.indexOf(_loc2_);
         if(_loc3_ == -1)
         {
            return;
         }
         _loadingQueue.splice(_loc3_,1);
         var _loc4_:PackageItem = _loc2_.item;
         var _loc5_:Function = _loc4_.callbacks.pop();
         if(_loc5_ != null)
         {
            _loc5_(_loc2_.content);
         }
      }
      
      private function loadMovieClip(param1:PackageItem) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc8_:int = 0;
         var _loc10_:* = null;
         var _loc5_:* = null;
         var _loc11_:* = null;
         var _loc7_:* = null;
         var _loc6_:XML = getXMLDesc(param1.id + ".xml");
         _loc2_ = _loc6_.@interval;
         if(_loc2_ != null)
         {
            param1.interval = parseInt(_loc2_);
         }
         _loc2_ = _loc6_.@swing;
         if(_loc2_ != null)
         {
            param1.swing = _loc2_ == "true";
         }
         _loc2_ = _loc6_.@repeatDelay;
         if(_loc2_ != null)
         {
            param1.repeatDelay = parseInt(_loc2_);
         }
         var _loc4_:int = parseInt(_loc6_.@frameCount);
         param1.frames = new Vector.<Frame>(_loc4_);
         var _loc9_:XMLList = _loc6_.frames.elements();
         _loc8_ = 0;
         while(_loc8_ < _loc4_)
         {
            _loc10_ = new Frame();
            _loc5_ = _loc9_[_loc8_];
            _loc2_ = _loc5_.@rect;
            _loc3_ = _loc2_.split(",");
            _loc10_.rect = new Rectangle(parseInt(_loc3_[0]),parseInt(_loc3_[1]),parseInt(_loc3_[2]),parseInt(_loc3_[3]));
            _loc2_ = _loc5_.@addDelay;
            _loc10_.addDelay = parseInt(_loc2_);
            param1.frames[_loc8_] = _loc10_;
            if(_loc10_.rect.width != 0)
            {
               _loc2_ = _loc5_.@sprite;
               if(_loc2_)
               {
                  _loc2_ = param1.id + "_" + _loc2_ + ".png";
               }
               else
               {
                  _loc2_ = param1.id + "_" + _loc8_ + ".png";
               }
               _loc11_ = _reader.readResFile(_loc2_);
               if(_loc11_)
               {
                  _loc7_ = new FrameLoader();
                  _loc7_.contentLoaderInfo.addEventListener("complete",__frameLoaded);
                  _loc7_.loadBytes(_loc11_);
                  _loc7_.item = param1;
                  _loc7_.frame = _loc10_;
                  _loadingQueue.push(_loc7_);
                  param1.loading++;
               }
               else
               {
                  _loc10_.rect.setEmpty();
               }
            }
            _loc8_++;
         }
      }
      
      private function __frameLoaded(param1:Event) : void
      {
         var _loc2_:FrameLoader = FrameLoader(param1.currentTarget.loader);
         var _loc3_:int = _loadingQueue.indexOf(_loc2_);
         if(_loc3_ == -1)
         {
            return;
         }
         _loadingQueue.splice(_loc3_,1);
         var _loc4_:PackageItem = _loc2_.item;
         var _loc5_:Frame = _loc2_.frame;
         _loc5_.image = Bitmap(_loc2_.content).bitmapData;
         _loc4_.loading = Number(_loc4_.loading) - 1;
         if(_loc4_.loading == 0)
         {
            _loc4_.completeLoading();
         }
      }
      
      private function loadSound(param1:PackageItem) : void
      {
         var _loc2_:Sound = new Sound();
         var _loc3_:ByteArray = _reader.readResFile(param1.file);
         _loc2_.loadCompressedDataFromByteArray(_loc3_,_loc3_.length);
         param1.sound = _loc2_;
         param1.loaded = true;
      }
      
      private function loadFont(param1:PackageItem) : void
      {
         var _loc8_:int = 0;
         var _loc2_:* = null;
         var _loc9_:int = 0;
         var _loc17_:* = null;
         var _loc5_:* = null;
         var _loc3_:* = null;
         var _loc20_:* = null;
         var _loc6_:* = null;
         var _loc19_:BitmapFont = new BitmapFont();
         _loc19_.id = "ui://" + this.id + param1.id;
         var _loc11_:String = _reader.readDescFile(param1.id + ".fnt");
         var _loc16_:Array = _loc11_.split("\n");
         var _loc18_:int = _loc16_.length;
         var _loc10_:Object = {};
         var _loc7_:* = false;
         var _loc13_:* = 0;
         var _loc12_:int = 0;
         var _loc4_:* = false;
         var _loc14_:* = false;
         var _loc15_:* = 0;
         _loc8_ = 0;
         while(_loc8_ < _loc18_)
         {
            _loc11_ = _loc16_[_loc8_];
            if(_loc11_.length != 0)
            {
               _loc11_ = ToolSet.trim(_loc11_);
               _loc2_ = _loc11_.split(" ");
               _loc9_ = 1;
               while(_loc9_ < _loc2_.length)
               {
                  _loc17_ = _loc2_[_loc9_].split("=");
                  _loc10_[_loc17_[0]] = _loc17_[1];
                  _loc9_++;
               }
               _loc11_ = _loc2_[0];
               if(_loc11_ == "char")
               {
                  _loc5_ = new BMGlyph();
                  _loc5_.x = _loc10_.x;
                  _loc5_.y = _loc10_.y;
                  _loc5_.offsetX = _loc10_.xoffset;
                  _loc5_.offsetY = _loc10_.yoffset;
                  _loc5_.width = _loc10_.width;
                  _loc5_.height = _loc10_.height;
                  _loc5_.advance = _loc10_.xadvance;
                  _loc5_.channel = _loc19_.translateChannel(_loc10_.chnl);
                  if(!_loc7_)
                  {
                     if(_loc10_.img)
                     {
                        _loc3_ = _itemsById[_loc10_.img];
                        if(_loc3_ != null)
                        {
                           _loc3_ = _loc3_.getBranch();
                           _loc5_.width = _loc3_.width;
                           _loc5_.height = _loc3_.height;
                           _loc3_ = _loc3_.getHighResolution();
                           _loc5_.imageItem = _loc3_;
                           loadImage(_loc3_);
                        }
                     }
                  }
                  if(_loc7_)
                  {
                     _loc5_.lineHeight = _loc15_;
                  }
                  else
                  {
                     if(_loc5_.advance == 0)
                     {
                        if(_loc12_ == 0)
                        {
                           _loc5_.advance = _loc5_.offsetX + _loc5_.width;
                        }
                        else
                        {
                           _loc5_.advance = _loc12_;
                        }
                     }
                     _loc5_.lineHeight = _loc5_.offsetY < 0?_loc5_.height:_loc5_.offsetY + _loc5_.height;
                     if(_loc13_ > 0 && _loc5_.lineHeight < _loc13_)
                     {
                        _loc5_.lineHeight = _loc13_;
                     }
                  }
                  _loc19_.glyphs[String.fromCharCode(_loc10_.id)] = _loc5_;
               }
               else if(_loc11_ == "info")
               {
                  _loc7_ = _loc10_.face != null;
                  _loc14_ = _loc7_;
                  _loc13_ = int(_loc10_.size);
                  _loc4_ = _loc10_.resizable == "true";
                  if(_loc10_.colored != undefined)
                  {
                     _loc14_ = _loc10_.colored == "true";
                  }
                  if(_loc7_)
                  {
                     _loc20_ = _reader.readResFile(param1.id + ".png");
                     _loc6_ = new PackageItemLoader();
                     _loc6_.contentLoaderInfo.addEventListener("complete",__fontAtlasLoaded);
                     _loc6_.loadBytes(_loc20_);
                     _loc6_.item = param1;
                     _loadingQueue.push(_loc6_);
                  }
               }
               else if(_loc11_ == "common")
               {
                  _loc15_ = int(_loc10_.lineHeight);
                  if(_loc13_ == 0)
                  {
                     _loc13_ = _loc15_;
                  }
                  else if(_loc15_ == 0)
                  {
                     _loc15_ = _loc13_;
                  }
                  _loc12_ = _loc10_.xadvance;
               }
            }
            _loc8_++;
         }
         if(_loc13_ == 0 && _loc5_)
         {
            _loc13_ = int(_loc5_.height);
         }
         _loc19_.ttf = _loc7_;
         _loc19_.size = _loc13_;
         _loc19_.resizable = _loc4_;
         _loc19_.colored = _loc14_;
         param1.bitmapFont = _loc19_;
      }
      
      private function __fontAtlasLoaded(param1:Event) : void
      {
         var _loc2_:PackageItemLoader = PackageItemLoader(LoaderInfo(param1.currentTarget).loader);
         var _loc3_:int = _loadingQueue.indexOf(_loc2_);
         if(_loc3_ == -1)
         {
            return;
         }
         _loadingQueue.splice(_loc3_,1);
         var _loc4_:PackageItem = _loc2_.item;
         _loc4_.bitmapFont.atlas = Bitmap(_loc2_.content).bitmapData;
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
