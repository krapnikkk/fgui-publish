package fairygui.editor.handlers
{
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIPackage;
   import fairygui.editor.gui.EUIProject;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   
   public class FindReferenceHandler
   {
       
      
      private var _mode:int;
      
      private var _results:Vector.<EPackageItem>;
      
      private var _source:String;
      
      private var _replacing:Boolean;
      
      private var _target:String;
      
      private var _targetPkgId:String;
      
      private var _targetItemId:String;
      
      private var _modified:Boolean;
      
      public function FindReferenceHandler()
      {
         super();
         this._results = new Vector.<EPackageItem>();
      }
      
      public function get results() : Vector.<EPackageItem>
      {
         return this._results;
      }
      
      public function find(param1:String, param2:int, param3:EUIProject) : void
      {
         var _loc6_:EPackageItem = null;
         var _loc4_:Vector.<EUIPackage> = null;
         var _loc5_:EUIPackage = null;
         this._results.length = 0;
         this._mode = param2;
         this._source = param1;
         this._replacing = false;
         if(param2 == 0)
         {
            _loc4_ = param3.getPackageList();
            var _loc10_:int = 0;
            var _loc9_:* = _loc4_;
            for each(_loc5_ in _loc4_)
            {
               _loc5_.ensureOpen();
               var _loc8_:int = 0;
               var _loc7_:* = _loc5_.resources;
               for each(_loc6_ in _loc5_.resources)
               {
                  this.analyseItem(_loc6_);
               }
            }
         }
         else
         {
            _loc6_ = param3.getItemByURL(param1);
            this.analyseItem(_loc6_);
         }
      }
      
      public function replaceAll(param1:String, param2:String, param3:EUIProject) : void
      {
         var _loc4_:EPackageItem = null;
         this._replacing = true;
         this._target = param2;
         this._targetPkgId = param2.substr(5,8);
         this._targetItemId = param2.substr(13);
         var _loc6_:int = 0;
         var _loc5_:* = this._results;
         for each(_loc4_ in this._results)
         {
            this.analyseItem(_loc4_);
         }
      }
      
      private function addPropURL(param1:EPackageItem, param2:XML, param3:String, param4:Boolean = false) : void
      {
         var _loc10_:String = null;
         var _loc13_:Array = null;
         var _loc11_:int = 0;
         var _loc12_:Boolean = false;
         var _loc5_:int = 0;
         var _loc7_:Boolean = false;
         var _loc6_:int = 0;
         var _loc8_:String = null;
         var _loc9_:String = param2["@" + param3];
         if(param4)
         {
            if(_loc9_.length == 0)
            {
               return;
            }
            _loc10_ = _loc9_.indexOf(",") != -1?",":"|";
            _loc13_ = _loc9_.split(_loc10_);
            _loc11_ = _loc13_.length;
            _loc12_ = false;
            _loc5_ = 0;
            while(_loc5_ < _loc11_)
            {
               _loc7_ = this.addURL(param1,_loc13_[_loc5_]);
               if(_loc7_ && this._replacing)
               {
                  _loc13_[_loc5_] = this._target;
                  this._modified = true;
                  _loc12_ = true;
               }
               _loc5_++;
            }
            if(_loc12_)
            {
               param2["@" + param3] = _loc13_.join(_loc10_);
            }
         }
         else
         {
            _loc6_ = _loc9_.indexOf(",");
            if(_loc6_ != -1)
            {
               _loc8_ = _loc9_.substr(_loc6_);
               _loc9_ = _loc9_.substr(0,_loc6_);
            }
            else
            {
               _loc8_ = "";
            }
            _loc7_ = this.addURL(param1,_loc9_);
            if(_loc7_ && this._replacing)
            {
               param2["@" + param3] = this._target + _loc8_;
               this._modified = true;
            }
         }
      }
      
      private function addURL(param1:EPackageItem, param2:String) : Boolean
      {
         var _loc3_:EPackageItem = null;
         if(!param2 || param2.length < 14 || !UtilsStr.startsWith(param2,"ui://"))
         {
            return false;
         }
         if(this._mode == 0)
         {
            if(param2 == this._source)
            {
               if(this._results.indexOf(param1) == -1)
               {
                  this._results.push(param1);
               }
               return true;
            }
            return false;
         }
         if(param2 != this._source)
         {
            _loc3_ = param1.owner.project.getItemByURL(param2);
            if(_loc3_ && this._results.indexOf(_loc3_) == -1)
            {
               this._results.push(_loc3_);
            }
         }
         return true;
      }
      
      private function analyseItem(param1:EPackageItem) : void
      {
         var _loc12_:XML = null;
         var _loc10_:Object = null;
         var _loc11_:XMLList = null;
         var _loc15_:XML = null;
         var _loc16_:XML = null;
         var _loc19_:XML = null;
         var _loc17_:String = null;
         var _loc18_:EUIPackage = null;
         var _loc3_:String = null;
         var _loc5_:String = null;
         var _loc4_:String = null;
         var _loc7_:Boolean = false;
         var _loc2_:EPackageItem = null;
         var _loc13_:String = null;
         var _loc14_:Array = null;
         var _loc9_:int = 0;
         var _loc6_:int = 0;
         var _loc21_:Object = null;
         var _loc8_:Array = null;
         var _loc20_:int = 0;
         var _loc22_:Array = null;
         if(param1.type == "component")
         {
            _loc12_ = UtilsFile.loadXML(param1.file);
            if(!_loc12_)
            {
               return;
            }
            this._modified = false;
            _loc10_ = _loc12_.displayList.elements();
            var _loc28_:int = 0;
            var _loc27_:* = _loc10_;
            for each(_loc15_ in _loc10_)
            {
               _loc3_ = _loc15_.name().localName;
               _loc5_ = _loc15_.@src;
               if(_loc5_)
               {
                  _loc4_ = _loc15_.@pkg;
                  if(_loc4_)
                  {
                     _loc18_ = param1.owner.project.getPackage(_loc4_);
                     if(!_loc18_)
                     {
                        continue;
                     }
                  }
                  else
                  {
                     _loc18_ = param1.owner;
                  }
                  _loc7_ = this.addURL(param1,"ui://" + _loc18_.id + _loc5_);
                  if(_loc7_ && this._replacing)
                  {
                     if(this._targetPkgId != param1.owner.id)
                     {
                        _loc15_.@pkg = this._targetPkgId;
                     }
                     else
                     {
                        delete _loc15_.@pkg;
                     }
                     _loc15_.@src = this._targetItemId;
                     this._modified = true;
                  }
               }
               if(_loc3_ == "component")
               {
                  if(this._mode == 1)
                  {
                     _loc2_ = _loc18_.getItem(_loc5_);
                     if(_loc2_)
                     {
                        this.analyseItem(_loc2_);
                     }
                  }
                  _loc16_ = _loc15_.Button[0];
                  if(_loc16_)
                  {
                     this.addPropURL(param1,_loc16_,"icon");
                     this.addPropURL(param1,_loc16_,"selectedIcon");
                     this.addPropURL(param1,_loc16_,"sound");
                  }
                  _loc16_ = _loc15_.Label[0];
                  if(_loc16_)
                  {
                     this.addPropURL(param1,_loc16_,"icon");
                  }
                  _loc16_ = _loc15_.ComboBox[0];
                  if(_loc16_)
                  {
                     _loc11_ = _loc16_.item;
                     var _loc24_:int = 0;
                     var _loc23_:* = _loc11_;
                     for each(_loc19_ in _loc11_)
                     {
                        _loc17_ = _loc19_.@icon;
                        if(_loc17_)
                        {
                           this.addPropURL(param1,_loc19_,"icon");
                        }
                     }
                  }
               }
               else if(_loc3_ == "loader")
               {
                  this.addPropURL(param1,_loc15_,"url");
               }
               else if(_loc3_ == "list")
               {
                  this.addPropURL(param1,_loc15_,"defaultItem");
                  _loc11_ = _loc15_.item;
                  var _loc26_:int = 0;
                  var _loc25_:* = _loc11_;
                  for each(_loc19_ in _loc11_)
                  {
                     _loc17_ = String(_loc19_.@url);
                     if(_loc17_)
                     {
                        this.addPropURL(param1,_loc19_,"url");
                     }
                     _loc17_ = String(_loc19_.@icon);
                     if(_loc17_)
                     {
                        this.addPropURL(param1,_loc19_,"icon");
                     }
                  }
                  _loc17_ = _loc15_.@scrollBarRes;
                  if(_loc17_)
                  {
                     this.addPropURL(param1,_loc15_,"scrollBarRes",true);
                  }
                  _loc17_ = _loc15_.@ptrRes;
                  if(_loc17_)
                  {
                     this.addPropURL(param1,_loc15_,"ptrRes",true);
                  }
               }
               else if(_loc3_ == "text" || _loc3_ == "richtext")
               {
                  this.addPropURL(param1,_loc15_,"font");
               }
               _loc16_ = _loc15_.gearIcon[0];
               if(_loc16_)
               {
                  this.addPropURL(param1,_loc16_,"values",true);
                  this.addPropURL(param1,_loc16_,"default");
               }
            }
            _loc16_ = _loc12_.Button[0];
            if(_loc16_)
            {
               this.addPropURL(param1,_loc16_,"sound");
            }
            _loc16_ = _loc12_.ComboBox[0];
            if(_loc16_)
            {
               this.addPropURL(param1,_loc16_,"dropdown");
            }
            _loc10_ = _loc12_.transition;
            var _loc32_:int = 0;
            var _loc31_:* = _loc10_;
            for each(_loc15_ in _loc10_)
            {
               _loc11_ = _loc15_.item;
               var _loc30_:int = 0;
               var _loc29_:* = _loc11_;
               for each(_loc16_ in _loc11_)
               {
                  if(_loc16_.@type == "Sound")
                  {
                     this.addPropURL(param1,_loc16_,"value");
                  }
               }
            }
            this.addPropURL(param1,_loc12_,"designImage");
            this.addPropURL(param1,_loc12_,"hitTestData");
            _loc17_ = _loc12_.@scrollBarRes;
            if(_loc17_)
            {
               this.addPropURL(param1,_loc12_,"scrollBarRes",true);
            }
            _loc17_ = _loc12_.@ptrRes;
            if(_loc17_)
            {
               this.addPropURL(param1,_loc12_,"ptrRes",true);
            }
            if(this._modified)
            {
               UtilsFile.saveXML(param1.file,_loc12_);
               param1.invalidate();
            }
         }
         else if(param1.type == "font")
         {
            _loc13_ = UtilsFile.loadString(param1.file);
            if(!_loc13_)
            {
               return;
            }
            _loc14_ = _loc13_.split("\n");
            _loc9_ = _loc14_.length;
            _loc21_ = {};
            _loc6_ = 0;
            while(_loc6_ < _loc9_)
            {
               _loc17_ = _loc14_[_loc6_];
               if(_loc17_)
               {
                  _loc8_ = _loc17_.split(" ");
                  _loc20_ = 1;
                  while(_loc20_ < _loc8_.length)
                  {
                     _loc22_ = _loc8_[_loc20_].split("=");
                     _loc21_[_loc22_[0]] = _loc22_[1];
                     _loc20_++;
                  }
                  _loc17_ = _loc8_[0];
                  if(_loc17_ == "char")
                  {
                     this.addURL(param1,"ui://" + param1.owner.id + _loc21_.img);
                  }
                  else if(_loc17_ == "info")
                  {
                     if(_loc21_.face != undefined)
                     {
                        break;
                     }
                  }
               }
               _loc6_++;
            }
            if(param1.fontTexture)
            {
               _loc2_ = param1.owner.getItem(param1.fontTexture);
               if(_loc2_)
               {
                  this.addURL(param1,"ui://" + _loc2_.owner.id + _loc2_.id);
               }
            }
         }
      }
   }
}
