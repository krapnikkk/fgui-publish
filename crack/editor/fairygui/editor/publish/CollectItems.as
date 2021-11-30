package fairygui.editor.publish
{
   import fairygui.editor.PackagesPanel;
   import fairygui.editor.animation.AniDef;
   import fairygui.editor.animation.AniFrame;
   import fairygui.editor.animation.AniTexture;
   import fairygui.editor.animation.BoneDef;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIPackage;
   import fairygui.editor.plugin.PlugInManager;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   
   public class CollectItems extends PublishStep
   {
       
      
      private var _excludeList:Object;
      
      private var _binMap:Object;
      
      public var excludedCount:int;
      
      public function CollectItems()
      {
         super();
      }
      
      override public function run() : void
      {
         var _loc1_:EPackageItem = null;
         var _loc2_:String = null;
         this.excludedCount = 0;
         this._binMap = {};
         var _loc4_:Array = publishData.pkg.publishSettings.excludedList;
         if(_loc4_.length > 0)
         {
            this._excludeList = {};
            var _loc6_:int = 0;
            var _loc5_:* = _loc4_;
            for each(_loc2_ in _loc4_)
            {
               this._excludeList[_loc2_] = false;
            }
         }
         var _loc3_:Vector.<EPackageItem> = publishData.pkg.resources;
         var _loc8_:int = 0;
         var _loc7_:* = _loc3_;
         for each(_loc1_ in _loc3_)
         {
            _loc1_.addedToPublish = false;
         }
         var _loc10_:int = 0;
         var _loc9_:* = _loc3_;
         for each(_loc1_ in _loc3_)
         {
            if(PackagesPanel.PUBLIC_OK)
            {
               if(_loc1_.exported && _loc1_.type == "font")
               {
                  this.addItem(_loc1_);
               }
               else if(_loc1_.id == PackagesPanel.PUBLIC_COMPONENT_OBJECT.componentID)
               {
                  this.addItem(_loc1_);
               }
            }
            else if(_loc1_.exported)
            {
               this.addItem(_loc1_);
            }
         }
         publishData.items.sortOn(["exported","type","id"]);
         var _loc12_:int = 0;
         var _loc11_:* = publishData.items;
         for each(_loc1_ in publishData.items)
         {
            _loc1_.touch();
            if(_loc1_.errorStatus != 0)
            {
               stepCallback.addMsg(_loc1_.path + _loc1_.name + " not exists!");
            }
         }
         stepCallback.callOnSuccess();
      }
      
      private function addItem(param1:EPackageItem) : void
      {
         var _loc5_:* = null;
         var _loc7_:AniDef = null;
         var _loc4_:int = 0;
         var _loc6_:AniTexture = null;
         var _loc2_:int = 0;
         var _loc3_:AniFrame = null;
         if(param1.addedToPublish)
         {
            return;
         }
         if(this._excludeList && this._excludeList[param1.id] != undefined)
         {
            if(this._excludeList[param1.id] == false)
            {
               this._excludeList[param1.id] = true;
               this.excludedCount++;
            }
            return;
         }
         param1.addedToPublish = true;
         publishData.items.push(param1);
         if(param1.type == "image")
         {
            if(publishData.usingAtlas)
            {
               this.addToAtlas(param1);
            }
         }
         else if(param1.type == "movieclip")
         {
            if(publishData.usingAtlas)
            {
               this.addToAtlas(param1);
            }
            _loc7_ = publishData.pkg.getMovieClip(param1);
            _loc4_ = _loc7_.frameCount;
            var _loc9_:int = 0;
            var _loc8_:* = _loc7_.textureList;
            for each(_loc6_ in _loc7_.textureList)
            {
               _loc6_.exportFrame = -1;
            }
            _loc2_ = 0;
            while(_loc2_ < _loc4_)
            {
               _loc3_ = _loc7_.frameList[_loc2_];
               if(_loc3_.textureIndex != -1)
               {
                  _loc6_ = _loc7_.textureList[_loc3_.textureIndex];
                  if(_loc6_.raw != null && _loc6_.exportFrame == -1)
                  {
                     _loc6_.exportFrame = _loc2_;
                  }
               }
               _loc2_++;
            }
         }
         if(param1.type == "dragonbone")
         {
            _loc5_ = publishData.pkg.getBoneDef(param1);
         }
         if(param1.type == "component")
         {
            this.getComponentDependencies(param1);
         }
         else if(param1.type == "font")
         {
            this.getFontDependencies(param1);
         }
      }
      
      private function addToAtlas(param1:EPackageItem) : void
      {
         var _loc4_:String = null;
         var _loc2_:int = 0;
         if(param1.imageSetting.atlas == "default")
         {
            _loc4_ = "atlas0";
            _loc2_ = 0;
         }
         else if(param1.imageSetting.atlas == "alone" || param1.imageSetting.atlas == "alone_npot")
         {
            _loc4_ = "atlas_" + param1.id;
            _loc2_ = -1;
         }
         else
         {
            _loc4_ = "atlas" + param1.imageSetting.atlas;
            _loc2_ = parseInt(param1.imageSetting.atlas);
         }
         var _loc3_:AtlasItem = this._binMap[_loc4_];
         if(!_loc3_)
         {
            _loc3_ = new AtlasItem();
            _loc3_.id = _loc4_;
            _loc3_.index = _loc2_;
            publishData.atlases.push(_loc3_);
            this._binMap[_loc4_] = _loc3_;
         }
         _loc3_.items.push(param1);
         if(param1.imageInfo.format != "jpg")
         {
            _loc3_.alphaChannel = true;
         }
      }
      
      private function addURL(param1:String) : void
      {
         var _loc6_:int = 0;
         var _loc4_:String = null;
         var _loc5_:EUIPackage = null;
         var _loc2_:String = null;
         var _loc3_:EPackageItem = null;
         if(UtilsStr.startsWith(param1,"ui://"))
         {
            _loc6_ = param1.indexOf(",");
            if(_loc6_ != -1)
            {
               param1 = param1.substr(0,_loc6_);
            }
            _loc4_ = param1.substr(5,8);
            _loc5_ = publishData._project.getPackage(_loc4_);
            if(!_loc5_ || _loc5_ != publishData.pkg)
            {
               return;
            }
            _loc2_ = param1.substr(13);
            _loc3_ = _loc5_.getItem(_loc2_);
            if(_loc3_)
            {
               this.addItem(_loc3_);
            }
         }
      }
      
      private function getComponentDependencies(param1:EPackageItem) : void
      {
         var _loc9_:* = null;
         var _loc6_:* = null;
         var _loc17_:* = null;
         var _loc2_:Object = null;
         var _loc7_:XMLList = null;
         var _loc26_:XML = null;
         var _loc23_:XML = null;
         var _loc24_:String = null;
         var _loc28_:String = null;
         var _loc21_:String = null;
         var _loc13_:Array = null;
         var _loc10_:String = null;
         var _loc16_:int = 0;
         var _loc19_:int = 0;
         var _loc14_:XML = null;
         var _loc5_:String = null;
         var _loc22_:EPackageItem = null;
         var _loc25_:String = null;
         var _loc3_:String = null;
         var _loc15_:XML = null;
         var _loc20_:EUIPackage = null;
         var _loc27_:* = param1;
         try
         {
            _loc14_ = UtilsFile.loadXML(_loc27_.file);
            if(!_loc14_)
            {
               return;
            }
         }
         catch(err:Error)
         {
            stepCallback.addMsg("XML format error: " + _loc27_.name);
            return;
         }
         delete _loc14_.@resolution;
         delete _loc14_.@copies;
         delete _loc14_.@designImage;
         delete _loc14_.@designImageOffsetX;
         delete _loc14_.@designImageOffsetY;
         delete _loc14_.@designImageAlpha;
         delete _loc14_.@designImageLayer;
         delete _loc14_.@initName;
         delete _loc14_.@bgColor;
         delete _loc14_.@bgColorEnabled;
         var _loc11_:Array = [];
         var _loc4_:Object = {};
         _loc4_.classId = _loc27_.id;
         _loc4_.className = _loc27_.name;
         _loc4_.events = "";
         _loc21_ = _loc14_.@extention;
         if(_loc21_)
         {
            _loc4_.superClassName = "G" + _loc21_;
         }
         else
         {
            _loc4_.superClassName = "GComponent";
         }
         if(_loc21_ != "ScrollBar")
         {
            publishData.outputClasses[_loc27_.id] = _loc4_;
         }
         _loc21_ = _loc14_.@customExtention;
         if(_loc21_)
         {
            _loc4_.customSuperClassName = _loc21_;
            delete _loc14_.@customExtention;
         }
         _loc21_ = _loc14_.@remark;
         if(_loc21_)
         {
            _loc4_.remark = _loc21_;
            delete _loc14_.@remark;
         }
         _loc21_ = _loc14_.@hitTest;
         if(_loc21_)
         {
            _loc2_ = _loc14_.displayList.elements();
            var _loc32_:* = 0;
            var _loc31_:* = _loc2_;
            for each(_loc26_ in _loc2_)
            {
               if(_loc26_.@id == _loc21_)
               {
                  _loc10_ = _loc26_.@src;
                  if(_loc10_)
                  {
                     _loc5_ = _loc26_.@pkg;
                     if(!_loc5_ || _loc5_ == publishData.pkg.id)
                     {
                        _loc14_.@hitTest = _loc10_ + "," + _loc26_.@xy;
                        publishData._hitTestImages.push(_loc10_);
                     }
                     break;
                  }
               }
            }
         }
         var _loc12_:Array = [];
         _loc4_.members = _loc12_;
         _loc2_ = _loc14_.controller;
         var _loc34_:int = 0;
         var _loc33_:* = _loc2_;
         for each(_loc26_ in _loc2_)
         {
            _loc28_ = _loc26_.@name;
            delete _loc26_.@exported;
            delete _loc26_.@alias;
            _loc12_.push({
               "name":_loc28_,
               "type":"Controller"
            });
         }
         _loc2_ = _loc14_.displayList.elements();
         var _loc44_:int = 0;
         var _loc43_:* = _loc2_;
         for each(_loc26_ in _loc2_)
         {
            delete _loc26_.@aspect;
            delete _loc26_.@locked;
            delete _loc26_.@hideByEditor;
            _loc24_ = _loc26_.name().localName;
            _loc28_ = _loc26_.@name;
            _loc10_ = _loc26_.@src;
            if(_loc10_)
            {
               _loc5_ = _loc26_.@pkg;
               if(!_loc5_ || _loc5_ == this.publishData.pkg.id)
               {
                  _loc22_ = publishData.pkg.getItem(_loc10_);
                  if(_loc22_)
                  {
                     this.addItem(_loc22_);
                  }
               }
            }
            _loc31_ = _loc24_;
            if("loader" !== _loc31_)
            {
               if("list" !== _loc31_)
               {
                  if("group" !== _loc31_)
                  {
                     if("text" !== _loc31_)
                     {
                        if("richtext" !== _loc31_)
                        {
                           if("movieclip" !== _loc31_)
                           {
                              if("jta" !== _loc31_)
                              {
                                 if("image" !== _loc31_)
                                 {
                                    if("swf" !== _loc31_)
                                    {
                                       if("graph" !== _loc31_)
                                       {
                                          if("video" !== _loc31_)
                                          {
                                             if("component" === _loc31_)
                                             {
                                                _loc9_ = {};
                                                _loc6_ = _loc26_.@events;
                                                if(_loc6_ != "")
                                                {
                                                   _loc9_.events = _loc6_.split("|");
                                                }
                                                if(!_loc5_ || _loc5_ == publishData.pkg.id)
                                                {
                                                   _loc9_.name = _loc28_;
                                                   _loc9_.type = "GComponent";
                                                   _loc9_.src = publishData.pkg.getItemName(_loc10_);
                                                   _loc9_.src_id = _loc10_;
                                                   _loc12_.push(_loc9_);
                                                }
                                                else
                                                {
                                                   _loc20_ = publishData._project.getPackage(_loc5_);
                                                   if(_loc20_ != null)
                                                   {
                                                      _loc9_.name = _loc28_;
                                                      _loc9_.type = "GComponent";
                                                      _loc9_.src = _loc20_.getItemName(_loc10_);
                                                      _loc32_ = _loc10_;
                                                      _loc9_.src_id = _loc32_;
                                                      _loc32_;
                                                      _loc9_.pkg = _loc20_.name;
                                                      _loc9_.pkg_id = _loc20_.id;
                                                      _loc12_.push(_loc9_);
                                                   }
                                                }
                                                _loc23_ = _loc26_.Button[0];
                                                if(_loc23_)
                                                {
                                                   this.addURL(_loc23_.@icon);
                                                   this.addURL(_loc23_.@selectedIcon);
                                                   this.addURL(_loc23_.@sound);
                                                }
                                                _loc23_ = _loc26_.Label[0];
                                                if(_loc23_)
                                                {
                                                   this.addURL(_loc23_.@icon);
                                                }
                                                _loc23_ = _loc26_.ComboBox[0];
                                                if(_loc23_)
                                                {
                                                   _loc7_ = _loc23_.item;
                                                   var _loc40_:int = 0;
                                                   var _loc39_:* = _loc7_;
                                                   for each(_loc15_ in _loc7_)
                                                   {
                                                      _loc21_ = _loc15_.@icon;
                                                      if(_loc21_)
                                                      {
                                                         this.addURL(_loc21_);
                                                      }
                                                   }
                                                }
                                             }
                                          }
                                          else
                                          {
                                             _loc21_ = _loc26_.@forMask;
                                             if(_loc21_ == "true")
                                             {
                                                _loc14_.@mask = _loc26_.@id;
                                                delete _loc26_.@forMask;
                                             }
                                             _loc12_.push({
                                                "name":_loc28_,
                                                "type":"GVideo"
                                             });
                                          }
                                       }
                                       else
                                       {
                                          _loc21_ = _loc26_.@forMask;
                                          if(_loc21_ == "true")
                                          {
                                             _loc14_.@mask = _loc26_.@id;
                                             delete _loc26_.@forMask;
                                          }
                                          _loc12_.push({
                                             "name":_loc28_,
                                             "type":"GGraph"
                                          });
                                       }
                                    }
                                    else
                                    {
                                       _loc12_.push({
                                          "name":_loc28_,
                                          "type":"GSwfObject"
                                       });
                                    }
                                 }
                                 else
                                 {
                                    _loc21_ = _loc26_.@forHitTest;
                                    if(_loc21_ == "true")
                                    {
                                       _loc5_ = _loc26_.@pkg;
                                       if(!_loc5_ || _loc5_ == publishData.pkg.id)
                                       {
                                          _loc14_.@hitTest = _loc10_ + "," + _loc26_.@xy;
                                          publishData._hitTestImages.push(_loc10_);
                                       }
                                       delete _loc26_.@forHitTest;
                                    }
                                    _loc21_ = _loc26_.@forMask;
                                    if(_loc21_ == "true")
                                    {
                                       _loc14_.@mask = _loc26_.@id;
                                       delete _loc26_.@forMask;
                                    }
                                    _loc12_.push({
                                       "name":_loc28_,
                                       "type":"GImage"
                                    });
                                 }
                              }
                              else
                              {
                                 _loc26_.setLocalName("movieclip");
                                 _loc12_.push({
                                    "name":_loc28_,
                                    "type":"GMovieClip"
                                 });
                              }
                           }
                           else
                           {
                              _loc12_.push({
                                 "name":_loc28_,
                                 "type":"GMovieClip"
                              });
                           }
                        }
                        else
                        {
                           _loc12_.push({
                              "name":_loc28_,
                              "type":"GRichTextField"
                           });
                        }
                     }
                     else
                     {
                        _loc21_ = _loc26_.@input;
                        if(_loc21_ == "true")
                        {
                           _loc12_.push({
                              "name":_loc28_,
                              "type":"GTextInput"
                           });
                        }
                        else
                        {
                           _loc12_.push({
                              "name":_loc28_,
                              "type":"GTextField"
                           });
                        }
                     }
                  }
                  else
                  {
                     _loc21_ = _loc26_.@advanced;
                     if(_loc21_ != "true")
                     {
                        _loc11_.push(_loc26_.childIndex());
                        _loc25_ = _loc26_.@id;
                        _loc3_ = _loc26_.@group;
                        var _loc38_:int = 0;
                        var _loc37_:* = _loc2_;
                        for each(_loc15_ in _loc2_)
                        {
                           if(_loc15_.@group == _loc25_)
                           {
                              if(_loc3_)
                              {
                                 _loc15_.@group = _loc3_;
                              }
                              else
                              {
                                 delete _loc15_.@group;
                              }
                           }
                        }
                     }
                     else
                     {
                        delete _loc26_.@collapsed;
                        _loc12_.push({
                           "name":_loc28_,
                           "type":"GGroup"
                        });
                     }
                  }
               }
               else
               {
                  this.addURL(_loc26_.@defaultItem);
                  _loc12_.push({
                     "name":_loc28_,
                     "type":"GList"
                  });
                  _loc7_ = _loc26_.item;
                  var _loc36_:int = 0;
                  var _loc35_:* = _loc7_;
                  for each(_loc15_ in _loc7_)
                  {
                     _loc21_ = String(_loc15_.@url);
                     if(_loc21_)
                     {
                        this.addURL(_loc21_);
                     }
                     _loc21_ = String(_loc15_.@icon);
                     if(_loc21_)
                     {
                        this.addURL(_loc15_.@icon);
                     }
                  }
                  _loc21_ = _loc26_.@scrollBarRes;
                  if(_loc21_)
                  {
                     _loc13_ = _loc21_.split(",");
                     this.addURL(_loc13_[0]);
                     this.addURL(_loc13_[1]);
                  }
                  _loc21_ = _loc26_.@ptrRes;
                  if(_loc21_)
                  {
                     _loc13_ = _loc21_.split(",");
                     this.addURL(_loc13_[0]);
                     this.addURL(_loc13_[1]);
                  }
               }
            }
            else
            {
               this.addURL(_loc26_.@url);
               _loc12_.push({
                  "name":_loc28_,
                  "type":"GLoader"
               });
            }
            _loc23_ = _loc26_.gearIcon[0];
            if(_loc23_)
            {
               _loc21_ = _loc23_.@values;
               _loc13_ = _loc21_.split("|");
               var _loc42_:int = 0;
               var _loc41_:* = _loc13_;
               for each(_loc21_ in _loc13_)
               {
                  this.addURL(_loc21_);
               }
               _loc21_ = _loc23_["default"];
               this.addURL(_loc21_);
            }
         }
         _loc16_ = 0;
         _loc19_ = 0;
         while(_loc19_ < _loc11_.length)
         {
            delete _loc2_[_loc11_[_loc19_] - _loc16_];
            _loc16_++;
            _loc19_++;
         }
         _loc23_ = _loc14_.Button[0];
         if(_loc23_)
         {
            this.addURL(_loc23_.@sound);
         }
         _loc23_ = _loc14_.ComboBox[0];
         if(_loc23_)
         {
            this.addURL(_loc23_.@dropdown);
         }
         _loc2_ = _loc14_.transition;
         var _loc48_:int = 0;
         var _loc47_:* = _loc2_;
         for each(_loc26_ in _loc2_)
         {
            _loc28_ = _loc26_.@name;
            _loc12_.push({
               "name":_loc28_,
               "type":"Transition"
            });
            _loc7_ = _loc26_.item;
            var _loc46_:int = 0;
            var _loc45_:* = _loc7_;
            for each(_loc23_ in _loc7_)
            {
               if(_loc23_.@type == "Sound")
               {
                  this.addURL(_loc23_.@value);
               }
            }
         }
         _loc21_ = _loc14_.@scrollBarRes;
         if(_loc21_)
         {
            _loc13_ = _loc21_.split(",");
            this.addURL(_loc13_[0]);
            this.addURL(_loc13_[1]);
         }
         _loc21_ = _loc14_.@ptrRes;
         if(_loc21_)
         {
            _loc13_ = _loc21_.split(",");
            this.addURL(_loc13_[0]);
            this.addURL(_loc13_[1]);
         }
         var _loc8_:XML = _loc14_.copy();
         var _loc18_:String = _loc14_.@size;
         _loc18_ = this.scaseXY(_loc18_);
         _loc8_.@size = _loc18_;
         _loc2_ = _loc8_.displayList.elements();
         var _loc50_:int = 0;
         var _loc49_:* = _loc2_;
         for each(_loc26_ in _loc2_)
         {
            _loc17_ = _loc26_.@xy;
            _loc17_ = this.scaseXY(_loc17_);
            _loc26_.@xy = _loc17_;
            if(_loc26_.@size != undefined)
            {
               _loc18_ = _loc26_.@size;
               _loc18_ = this.scaseXY(_loc18_);
               _loc26_.@size = _loc18_;
            }
         }
         publishData.outputDesc[_loc27_.id + ".xml"] = _loc8_;
      }
      
      private function scaseXY(param1:String) : String
      {
         var _loc2_:Array = param1.split(",");
         var _loc3_:String = Math.ceil(PlugInManager.FYOUT * int(_loc2_[0])) + "," + Math.ceil(PlugInManager.FYOUT * int(_loc2_[1]));
         return _loc3_;
      }
      
      private function getFontDependencies(param1:EPackageItem) : void
      {
         var _loc2_:int = 0;
         var _loc8_:String = null;
         var _loc7_:Array = null;
         var _loc6_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:EPackageItem = null;
         var _loc11_:String = UtilsFile.loadString(param1.file);
         if(!_loc11_)
         {
            return;
         }
         var _loc9_:Array = _loc11_.split("\n");
         var _loc10_:int = _loc9_.length;
         var _loc3_:Object = {};
         _loc2_ = 0;
         while(_loc2_ < _loc10_)
         {
            _loc8_ = _loc9_[_loc2_];
            if(_loc8_)
            {
               _loc7_ = _loc8_.split(" ");
               _loc6_ = 1;
               while(_loc6_ < _loc7_.length)
               {
                  _loc4_ = _loc7_[_loc6_].split("=");
                  _loc3_[_loc4_[0]] = _loc4_[1];
                  _loc6_++;
               }
               _loc8_ = _loc7_[0];
               if(_loc8_ == "char")
               {
                  this.addURL("ui://" + publishData.pkg.id + _loc3_.img);
               }
               else if(_loc8_ == "info")
               {
                  if(_loc3_.face != undefined)
                  {
                     break;
                  }
               }
            }
            _loc2_++;
         }
         if(param1.fontTexture)
         {
            _loc5_ = publishData.pkg.getItem(param1.fontTexture);
            if(_loc5_)
            {
               publishData._fontTextures[param1.fontTexture] = param1;
               this.addItem(_loc5_);
            }
         }
      }
   }
}
