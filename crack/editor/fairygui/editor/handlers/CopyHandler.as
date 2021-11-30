package fairygui.editor.handlers
{
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIPackage;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   import flash.filesystem.File;
   
   public class CopyHandler
   {
      
      public static const RENAME:int = 0;
      
      public static const REPLACE:int = 1;
      
      public static const SKIP:int = 2;
       
      
      private var _todoList:Vector.<TodoItem>;
      
      private var _references:Vector.<ItemReference>;
      
      private var _todoMap:Object;
      
      private var _pathDepth:int;
      
      private var _sourcePkg:EUIPackage;
      
      private var _targetPath:String;
      
      private var _crossPackage:Boolean;
      
      private var _crossProject:Boolean;
      
      private var _existsItemCount:int;
      
      private var _ignoreExported:Boolean;
      
      public function CopyHandler()
      {
         super();
      }
      
      public function copy(param1:Vector.<EPackageItem>, param2:EUIPackage, param3:String, param4:Boolean = false) : void
      {
         var _loc5_:TodoItem = null;
         var _loc8_:EPackageItem = null;
         var _loc12_:int = 0;
         var _loc11_:int = 0;
         var _loc7_:int = 0;
         var _loc9_:int = 0;
         var _loc6_:EPackageItem = null;
         this._todoMap = {};
         this._todoList = new Vector.<TodoItem>();
         this._references = new Vector.<ItemReference>();
         if(param1.length == 0)
         {
            return;
         }
         this._sourcePkg = param1[0].owner;
         this._targetPath = param3;
         this._crossPackage = !param2 || param2 != this._sourcePkg;
         this._crossProject = !param2 || param2.project != param1[0].owner.project;
         this._ignoreExported = !this._crossProject && param4;
         var _loc10_:int = param1.length;
         this._pathDepth = 2147483647;
         _loc12_ = 0;
         while(_loc12_ < _loc10_)
         {
            _loc8_ = param1[_loc12_];
            _loc11_ = _loc8_.path.length;
            _loc7_ = 0;
            _loc9_ = 1;
            while(_loc9_ < _loc11_)
            {
               if(_loc8_.path.charAt(_loc9_) == "/")
               {
                  _loc7_++;
               }
               _loc9_++;
            }
            if(_loc7_ < this._pathDepth)
            {
               this._pathDepth = _loc7_;
            }
            _loc12_++;
         }
         _loc12_ = 0;
         while(_loc12_ < _loc10_)
         {
            _loc8_ = param1[_loc12_];
            this.addTodoItem(_loc8_,true);
            _loc12_++;
         }
         if(param2)
         {
            param2.ensureOpen();
            this._existsItemCount = 0;
            var _loc14_:int = 0;
            var _loc13_:* = this._todoList;
            for each(_loc5_ in this._todoList)
            {
               _loc8_ = _loc5_.source;
               if(_loc8_.type != "folder")
               {
                  if(!(!_loc5_.inSelection && _loc8_.exported && this._ignoreExported))
                  {
                     _loc6_ = param2.getItem(_loc5_.targetPath);
                     if(_loc6_ && param2.getItemByFileName(_loc6_,_loc8_.fileName))
                     {
                        this._existsItemCount++;
                     }
                  }
               }
            }
         }
      }
      
      public function copyXML(param1:EUIPackage, param2:XML, param3:EUIPackage, param4:String, param5:Boolean = false) : void
      {
         var _loc6_:EPackageItem = null;
         var _loc8_:TodoItem = null;
         var _loc7_:EPackageItem = null;
         this._todoMap = {};
         this._todoList = new Vector.<TodoItem>();
         this._references = new Vector.<ItemReference>();
         this._sourcePkg = param1;
         this._targetPath = param4;
         this._crossPackage = !param3 || param3 != this._sourcePkg;
         this._crossProject = !param3 || param3.project != param1.project;
         this._ignoreExported = param5;
         this._pathDepth = 0;
         this.parseXML(param1,param2);
         if(param3)
         {
            param3.ensureOpen();
            this._existsItemCount = 0;
            var _loc10_:int = 0;
            var _loc9_:* = this._todoList;
            for each(_loc8_ in this._todoList)
            {
               _loc7_ = _loc8_.source;
               if(_loc7_.type != "folder")
               {
                  if(!(!_loc8_.inSelection && _loc7_.exported && this._ignoreExported))
                  {
                     _loc6_ = param3.getItem(_loc8_.targetPath);
                     if(_loc6_ && param3.getItemByFileName(_loc6_,_loc7_.fileName))
                     {
                        this._existsItemCount++;
                     }
                  }
               }
            }
         }
      }
      
      public function paste(param1:EUIPackage, param2:int) : void
      {
         var _loc12_:EPackageItem = null;
         var _loc3_:TodoItem = null;
         var _loc6_:EPackageItem = null;
         var _loc10_:EPackageItem = null;
         var _loc9_:String = null;
         var _loc8_:File = null;
         var _loc5_:Boolean = false;
         var _loc7_:ItemReference = null;
         var _loc4_:String = null;
         var _loc11_:Object = {};
         var _loc14_:int = 0;
         var _loc13_:* = this._todoList;
         for each(_loc3_ in this._todoList)
         {
            _loc12_ = _loc3_.source;
            if(!(!_loc3_.inSelection && _loc12_.exported && this._ignoreExported && _loc12_.type != "folder"))
            {
               _loc10_ = param1.ensurePathExists(_loc3_.targetPath,true,false);
               _loc6_ = null;
               if(param2 == 2 || _loc12_.type == "folder")
               {
                  _loc6_ = param1.getItemByFileName(_loc10_,_loc12_.fileName);
                  if(_loc6_)
                  {
                     _loc11_[_loc12_.owner.id + _loc12_.id] = _loc6_.id;
                     continue;
                  }
                  _loc9_ = _loc12_.fileName;
               }
               else if(param2 == 0)
               {
                  _loc9_ = param1.getUniqueName(_loc10_,_loc12_.fileName,false);
               }
               else if(param2 == 1)
               {
                  _loc6_ = param1.getItemByFileName(_loc10_,_loc12_.fileName);
                  _loc9_ = _loc12_.fileName;
               }
               if(!_loc6_)
               {
                  _loc5_ = true;
                  _loc6_ = new EPackageItem(param1,_loc12_.type);
                  if(_loc6_.type == "folder")
                  {
                     _loc6_.id = _loc3_.targetPath + _loc9_ + "/";
                  }
                  else
                  {
                     _loc6_.id = param1.getNextId();
                  }
                  _loc6_.fileName = _loc9_;
                  _loc6_.name = UtilsStr.getFileName(_loc6_.fileName);
                  _loc6_.path = _loc3_.targetPath;
                  _loc6_.exported = _loc12_.exported;
                  _loc6_.favorite = _loc12_.favorite;
                  if(_loc12_.type == "image" || _loc12_.type == "movieclip")
                  {
                     _loc6_.imageSetting.copyFrom(_loc12_.imageSetting);
                  }
               }
               else
               {
                  _loc5_ = false;
               }
               _loc11_[_loc12_.owner.id + _loc12_.id] = _loc6_.id;
               _loc3_.target = _loc6_;
               _loc8_ = _loc12_.file;
               if(_loc12_.type == "folder")
               {
                  _loc3_.target.file.createDirectory();
               }
               else if(_loc8_.exists)
               {
                  UtilsFile.copyFile(_loc8_,_loc3_.target.file);
               }
               if(_loc5_)
               {
                  param1.addItem(_loc3_.target,false);
               }
            }
         }
         var _loc16_:int = 0;
         var _loc15_:* = this._references;
         for each(_loc7_ in this._references)
         {
            _loc4_ = _loc11_[_loc7_.pkg.id + _loc7_.propValue];
            if(_loc4_)
            {
               if(_loc7_.isURL)
               {
                  if(_loc7_.propValueArray)
                  {
                     _loc7_.propValueArray[_loc7_.propValueIndex] = "ui://" + param1.id + _loc4_;
                     _loc7_.xml["@" + _loc7_.propName] = _loc7_.propValueArray.join(_loc7_.propValueSplitter);
                  }
                  else
                  {
                     _loc7_.xml["@" + _loc7_.propName] = "ui://" + param1.id + _loc4_ + _loc7_.propValueExt;
                  }
               }
               else
               {
                  _loc7_.xml["@" + _loc7_.propName] = _loc4_ + _loc7_.propValueExt;
                  delete _loc7_.xml["@pkg"];
               }
            }
            else if(!_loc7_.isURL && _loc7_.pkg != param1)
            {
               _loc7_.xml.@pkg = _loc7_.pkg.id;
            }
         }
         var _loc18_:int = 0;
         var _loc17_:* = this._todoList;
         for each(_loc3_ in this._todoList)
         {
            _loc12_ = _loc3_.target;
            if(_loc12_ != null)
            {
               if(_loc12_.type == "component")
               {
                  if(_loc3_.content)
                  {
                     UtilsFile.saveXML(_loc12_.file,_loc3_.content);
                  }
               }
               else if(_loc12_.type == "font")
               {
                  if(_loc3_.content)
                  {
                     this.resolveFontDependencies(_loc3_,_loc11_,_loc12_.file);
                  }
               }
            }
         }
         param1.save();
         this._todoMap = null;
         this._references.length = 0;
         this._todoList.length = 0;
      }
      
      public function get existsItemCount() : int
      {
         return this._existsItemCount;
      }
      
      public function get sourceItems() : Vector.<EPackageItem>
      {
         var _loc1_:TodoItem = null;
         var _loc2_:Vector.<EPackageItem> = new Vector.<EPackageItem>();
         var _loc4_:int = 0;
         var _loc3_:* = this._todoList;
         for each(_loc1_ in this._todoList)
         {
            _loc2_.push(_loc1_.source);
         }
         return _loc2_;
      }
      
      public function get targetPaths() : Vector.<String>
      {
         var _loc1_:TodoItem = null;
         var _loc2_:Vector.<String> = new Vector.<String>();
         var _loc4_:int = 0;
         var _loc3_:* = this._todoList;
         for each(_loc1_ in this._todoList)
         {
            _loc2_.push(_loc1_.targetPath);
         }
         return _loc2_;
      }
      
      private function addTodoItem(param1:EPackageItem, param2:Boolean = false) : void
      {
         param1.owner.ensureOpen();
         var _loc3_:TodoItem = this._todoMap[param1.getURL()];
         if(_loc3_)
         {
            if(!_loc3_.inSelection && param2)
            {
               _loc3_.inSelection = param2;
               if(!_loc3_.dependenciesAnalysed && this._crossPackage)
               {
                  if(param1.type == "component")
                  {
                     this.getComponentDependencies(_loc3_);
                  }
                  else if(param1.type == "font")
                  {
                     this.getFontDependencies(_loc3_);
                  }
               }
            }
            return;
         }
         if(!this._crossProject && this._sourcePkg != param1.owner && param1.exported && !param2)
         {
            return;
         }
         _loc3_ = new TodoItem();
         _loc3_.source = param1;
         _loc3_.inSelection = param2;
         _loc3_.targetPath = this.prependPath(_loc3_.source,this._targetPath);
         this._todoMap[param1.getURL()] = _loc3_;
         this._todoList.push(_loc3_);
         var _loc4_:File = param1.file;
         if(!_loc4_.exists)
         {
            return;
         }
         if(this._crossPackage && (this._crossProject || !param1.exported || !this._ignoreExported || param2))
         {
            _loc3_.dependenciesAnalysed = true;
            if(param1.type == "component")
            {
               this.getComponentDependencies(_loc3_);
            }
            else if(param1.type == "font")
            {
               this.getFontDependencies(_loc3_);
            }
         }
      }
      
      private function addPropURL(param1:EUIPackage, param2:XML, param3:String, param4:Boolean = false) : void
      {
         var _loc7_:String = null;
         var _loc10_:Array = null;
         var _loc9_:int = 0;
         var _loc8_:Boolean = false;
         var _loc6_:int = 0;
         var _loc5_:String = param2["@" + param3];
         if(param4)
         {
            if(_loc5_.length == 0)
            {
               return;
            }
            _loc7_ = _loc5_.indexOf(",") != -1?",":"|";
            _loc10_ = _loc5_.split(_loc7_);
            _loc9_ = _loc10_.length;
            _loc8_ = false;
            _loc6_ = 0;
            while(_loc6_ < _loc9_)
            {
               this.addURL(param1,param2,param3,_loc10_[_loc6_],_loc10_,_loc6_,_loc7_);
               _loc6_++;
            }
         }
         else
         {
            this.addURL(param1,param2,param3,_loc5_);
         }
      }
      
      private function addURL(param1:EUIPackage, param2:XML, param3:String, param4:String, param5:Array = null, param6:int = 0, param7:String = null) : void
      {
         var _loc9_:String = null;
         if(!param4 || param4.length < 14 || !UtilsStr.startsWith(param4,"ui://"))
         {
            return;
         }
         var _loc13_:String = param4.substr(5,8);
         var _loc14_:EUIPackage = param1.project.getPackage(_loc13_);
         if(_loc14_ == null || !this._crossProject && _loc14_ != param1)
         {
            return;
         }
         var _loc10_:String = param4.substr(13);
         var _loc11_:int = _loc10_.indexOf(",");
         if(_loc11_ != -1)
         {
            _loc9_ = _loc10_.substr(_loc11_);
            _loc10_ = _loc10_.substr(0,_loc11_);
         }
         else
         {
            _loc9_ = "";
         }
         var _loc12_:EPackageItem = param1.getItem(_loc10_);
         if(_loc12_)
         {
            this.addTodoItem(_loc12_);
         }
         var _loc8_:ItemReference = this.addReference(_loc14_,param2,param3,_loc10_);
         _loc8_.propValueExt = _loc9_;
         _loc8_.propValueArray = param5;
         _loc8_.propValueIndex = param6;
         _loc8_.propValueSplitter = param7;
         _loc8_.isURL = true;
      }
      
      private function addReference(param1:EUIPackage, param2:XML, param3:String, param4:String) : ItemReference
      {
         var _loc5_:ItemReference = new ItemReference();
         _loc5_.pkg = param1;
         _loc5_.xml = param2;
         _loc5_.propName = param3;
         _loc5_.propValue = param4;
         this._references.push(_loc5_);
         return _loc5_;
      }
      
      private function getComponentDependencies(param1:TodoItem) : void
      {
         var _loc3_:File = null;
         var _loc5_:XML = null;
         var _loc7_:* = param1;
         var _loc6_:EPackageItem = _loc7_.source;
         _loc3_ = _loc6_.file;
         if(!_loc3_.exists)
         {
            return;
         }
         var _loc2_:String = UtilsFile.loadString(_loc3_);
         try
         {
            _loc5_ = new XML(_loc2_);
         }
         catch(err:Error)
         {
            throw new Error("Read \'" + _loc3_.nativePath + "\' failed，check the file format！");
         }
         var _loc4_:EUIPackage = _loc6_.owner;
         _loc7_.content = _loc5_;
         this.parseXML(_loc4_,_loc5_);
      }
      
      private function parseXML(param1:EUIPackage, param2:XML) : void
      {
         var _loc8_:Object = null;
         var _loc9_:XMLList = null;
         var _loc10_:XML = null;
         var _loc11_:XML = null;
         var _loc14_:XML = null;
         var _loc12_:String = null;
         var _loc13_:Array = null;
         var _loc4_:String = null;
         var _loc6_:String = null;
         var _loc5_:String = null;
         var _loc7_:EUIPackage = null;
         var _loc3_:EPackageItem = null;
         _loc8_ = param2.displayList.elements();
         var _loc20_:int = 0;
         var _loc19_:* = _loc8_;
         for each(_loc10_ in _loc8_)
         {
            _loc12_ = _loc10_.name().localName;
            _loc6_ = _loc10_.@src;
            if(_loc6_)
            {
               _loc5_ = _loc10_.@pkg;
               if(_loc5_)
               {
                  _loc7_ = param1.project.getPackage(_loc5_);
                  if(this._crossProject || _loc7_ == param1)
                  {
                     _loc3_ = _loc7_.getItem(_loc6_);
                     if(_loc3_)
                     {
                        this.addTodoItem(_loc3_);
                        this.addReference(_loc7_,_loc10_,"src",_loc6_);
                     }
                  }
               }
               else
               {
                  _loc3_ = param1.getItem(_loc6_);
                  if(_loc3_)
                  {
                     this.addTodoItem(_loc3_);
                     this.addReference(param1,_loc10_,"src",_loc6_);
                  }
               }
            }
            if(_loc12_ == "loader")
            {
               this.addPropURL(param1,_loc10_,"url");
            }
            else if(_loc12_ == "list")
            {
               this.addPropURL(param1,_loc10_,"defaultItem");
               _loc9_ = _loc10_.item;
               var _loc16_:int = 0;
               var _loc15_:* = _loc9_;
               for each(_loc14_ in _loc9_)
               {
                  _loc4_ = String(_loc14_.@url);
                  if(_loc4_)
                  {
                     this.addPropURL(param1,_loc14_,"url");
                  }
                  _loc4_ = String(_loc14_.@icon);
                  if(_loc4_)
                  {
                     this.addPropURL(param1,_loc14_,"icon");
                  }
               }
               _loc4_ = _loc10_.@scrollBarRes;
               if(_loc4_)
               {
                  this.addPropURL(param1,_loc10_,"scrollBarRes",true);
               }
               _loc4_ = _loc10_.@ptrRes;
               if(_loc4_)
               {
                  this.addPropURL(param1,_loc10_,"ptrRes",true);
               }
            }
            else if(_loc12_ == "text" || _loc12_ == "richtext")
            {
               this.addPropURL(param1,_loc10_,"font");
            }
            else if(_loc12_ == "component")
            {
               _loc11_ = _loc10_.Button[0];
               if(_loc11_)
               {
                  this.addPropURL(param1,_loc11_,"icon");
                  this.addPropURL(param1,_loc11_,"selectedIcon");
                  this.addPropURL(param1,_loc11_,"sound");
               }
               _loc11_ = _loc10_.Label[0];
               if(_loc11_)
               {
                  this.addPropURL(param1,_loc11_,"icon");
               }
               _loc11_ = _loc10_.ComboBox[0];
               if(_loc11_)
               {
                  _loc9_ = _loc11_.item;
                  var _loc18_:int = 0;
                  var _loc17_:* = _loc9_;
                  for each(_loc14_ in _loc9_)
                  {
                     _loc4_ = _loc14_.@icon;
                     if(_loc4_)
                     {
                        this.addPropURL(param1,_loc14_,"icon");
                     }
                  }
               }
            }
            _loc11_ = _loc10_.gearIcon[0];
            if(_loc11_)
            {
               this.addPropURL(param1,_loc11_,"values",true);
               this.addPropURL(param1,_loc11_,"default");
            }
         }
         _loc11_ = param2.Button[0];
         if(_loc11_)
         {
            this.addPropURL(param1,_loc11_,"sound");
         }
         _loc11_ = param2.ComboBox[0];
         if(_loc11_)
         {
            this.addPropURL(param1,_loc11_,"dropdown");
         }
         _loc8_ = param2.transition;
         var _loc24_:int = 0;
         var _loc23_:* = _loc8_;
         for each(_loc10_ in _loc8_)
         {
            _loc9_ = _loc10_.item;
            var _loc22_:int = 0;
            var _loc21_:* = _loc9_;
            for each(_loc11_ in _loc9_)
            {
               if(_loc11_.@type == "Sound")
               {
                  this.addPropURL(param1,_loc11_,"value");
               }
            }
         }
         this.addPropURL(param1,param2,"designImage");
         this.addPropURL(param1,param2,"hitTestData");
         _loc4_ = param2.@scrollBarRes;
         if(_loc4_)
         {
            this.addPropURL(param1,param2,"scrollBarRes",true);
         }
         _loc4_ = param2.@ptrRes;
         if(_loc4_)
         {
            this.addPropURL(param1,param2,"ptrRes",true);
         }
      }
      
      private function getFontDependencies(param1:TodoItem) : void
      {
         var _loc13_:int = 0;
         var _loc11_:String = null;
         var _loc2_:Array = null;
         var _loc4_:int = 0;
         var _loc3_:Array = null;
         var _loc5_:EPackageItem = null;
         var _loc8_:File = param1.source.file;
         if(!_loc8_.exists)
         {
            return;
         }
         var _loc6_:EUIPackage = param1.source.owner;
         var _loc7_:String = UtilsFile.loadString(_loc8_);
         var _loc9_:Array = _loc7_.split("\n");
         param1.content = _loc9_;
         var _loc10_:int = _loc9_.length;
         var _loc12_:Object = {};
         _loc13_ = 0;
         while(_loc13_ < _loc10_)
         {
            _loc11_ = _loc9_[_loc13_];
            if(_loc11_)
            {
               _loc2_ = _loc11_.split(" ");
               _loc4_ = 1;
               while(_loc4_ < _loc2_.length)
               {
                  _loc3_ = _loc2_[_loc4_].split("=");
                  _loc12_[_loc3_[0]] = _loc3_[1];
                  _loc4_++;
               }
               _loc11_ = _loc2_[0];
               if(_loc11_ == "char")
               {
                  _loc5_ = _loc6_.getItem(_loc12_.img);
                  if(_loc5_)
                  {
                     this.addTodoItem(_loc5_);
                  }
               }
               else if(_loc11_ == "info")
               {
                  if(_loc12_.face != undefined)
                  {
                     break;
                  }
               }
            }
            _loc13_++;
         }
         if(param1.source.fontTexture)
         {
            _loc5_ = _loc6_.getItem(param1.source.fontTexture);
            if(_loc5_)
            {
               this.addTodoItem(_loc5_);
            }
         }
      }
      
      private function resolveFontDependencies(param1:TodoItem, param2:Object, param3:File) : void
      {
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc12_:Array = null;
         var _loc4_:int = 0;
         var _loc6_:String = null;
         var _loc5_:Array = null;
         var _loc7_:String = null;
         var _loc8_:Array = param1.content;
         var _loc9_:int = _loc8_.length;
         var _loc13_:Object = {};
         _loc10_ = 0;
         while(_loc10_ < _loc9_)
         {
            _loc11_ = _loc8_[_loc10_];
            if(_loc11_)
            {
               _loc12_ = _loc11_.split(" ");
               _loc4_ = 1;
               while(_loc4_ < _loc12_.length)
               {
                  _loc5_ = _loc12_[_loc4_].split("=");
                  _loc13_[_loc5_[0]] = _loc5_[1];
                  _loc4_++;
               }
               _loc6_ = _loc12_[0];
               if(_loc6_ == "char")
               {
                  _loc7_ = param2[param1.source.owner.id + _loc13_.img];
                  _loc8_[_loc10_] = _loc11_.replace(_loc13_.img,_loc7_);
               }
            }
            _loc10_++;
         }
         UtilsFile.saveString(param3,_loc8_.join("\n"));
         if(param1.source.fontTexture)
         {
            _loc7_ = param2[param1.source.owner.id + param1.source.fontTexture];
            param1.target.fontTexture = _loc7_;
         }
      }
      
      private function prependPath(param1:EPackageItem, param2:String) : String
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         if(this._pathDepth != 0)
         {
            _loc4_ = param1.path.length;
            _loc5_ = 0;
            _loc3_ = 1;
            while(_loc3_ < _loc4_)
            {
               if(param1.path.charAt(_loc3_) == "/")
               {
                  _loc5_++;
                  if(_loc5_ == this._pathDepth)
                  {
                     if(_loc3_ != _loc4_ - 1)
                     {
                        return param2 + param1.path.substr(_loc3_ + 1);
                     }
                     return param2;
                  }
               }
               _loc3_++;
            }
         }
         return param2 + param1.path.substr(1);
      }
   }
}

import fairygui.editor.gui.EPackageItem;

class TodoItem
{
    
   
   public var source:EPackageItem;
   
   public var target:EPackageItem;
   
   public var content;
   
   public var targetPath:String;
   
   public var inSelection:Boolean;
   
   public var dependenciesAnalysed:Boolean;
   
   function TodoItem()
   {
      super();
   }
}

import fairygui.editor.gui.EUIPackage;

class ItemReference
{
    
   
   public var pkg:EUIPackage;
   
   public var xml:XML;
   
   public var propName:String;
   
   public var propValue:String;
   
   public var propValueExt:String;
   
   public var propValueArray:Array;
   
   public var propValueIndex:int;
   
   public var propValueSplitter:String;
   
   public var isURL:Boolean;
   
   function ItemReference()
   {
      super();
      this.propValueExt = "";
   }
}
