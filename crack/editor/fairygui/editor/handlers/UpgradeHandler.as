package fairygui.editor.handlers
{
   import fairygui.GObject;
   import fairygui.editor.Consts;
   import fairygui.editor.OpenProjectWindow;
   import fairygui.editor.animation.AniDef;
   import fairygui.editor.utils.BulkTasks;
   import fairygui.editor.utils.Utils;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.utils.GTimers;
   import flash.filesystem.File;
   import flash.system.System;
   
   public class UpgradeHandler
   {
       
      
      private var _win:OpenProjectWindow;
      
      private var _msg:GObject;
      
      private var _sourceFolder:File;
      
      private var _targetFolder:File;
      
      private var _assetsFolder:File;
      
      private var _objsFolder:File;
      
      private var _settingsFolder:File;
      
      private var _devCode:String;
      
      private var _nextId:uint;
      
      private var _useAtlas:Boolean;
      
      private var _publishPath:Object;
      
      private var _zipExt:String;
      
      private var _tasks:BulkTasks;
      
      public function UpgradeHandler()
      {
         super();
      }
      
      public function open(param1:OpenProjectWindow, param2:File) : void
      {
         param1 = param1;
         param2 = param2;
         var win:OpenProjectWindow = param1;
         var sourceFolder:File = param2;
         this._win = win;
         UtilsFile.browseForDirectory(Consts.g.text313,function(param1:File):void
         {
            run(sourceFolder,param1);
         });
      }
      
      private function run(param1:File, param2:File) : void
      {
         param1 = param1;
         param2 = param2;
         var xml:XML = null;
         var sourceFolder:File = param1;
         var targetFolder:File = param2;
         this._win.view.getChild("upgrade").visible = true;
         this._msg = this._win.view.getChild("upgradeMsg");
         this._devCode = Utils.genDevCode();
         this._nextId = 0;
         this._publishPath = {};
         this._sourceFolder = sourceFolder;
         this._targetFolder = targetFolder;
         var oldProjectXML:XML = new XML(UtilsFile.loadString(sourceFolder.resolvePath("project.xml")));
         var str:String = oldProjectXML.@type;
         this._useAtlas = str != "Flash";
         var projectXML:XML = <projectDescription/>;
         projectXML.@id = oldProjectXML.@id;
         projectXML.@type = oldProjectXML.@type;
         projectXML.@version = "3";
         this._assetsFolder = targetFolder.resolvePath("assets");
         this._assetsFolder.createDirectory();
         this._settingsFolder = targetFolder.resolvePath("settings");
         this._settingsFolder.createDirectory();
         this._objsFolder = targetFolder.resolvePath(".objs");
         this._objsFolder.createDirectory();
         UtilsFile.saveXML(targetFolder.resolvePath(oldProjectXML.@name + ".fairy"),projectXML);
         this.convertSettings(oldProjectXML);
         this._tasks = new BulkTasks(1);
         var packages:XMLList = oldProjectXML.packages["package"];
         var _loc5_:int = 0;
         var _loc4_:* = packages;
         for each(xml in packages)
         {
            this._tasks.addTask(this.convertPkg,xml);
         }
         this._tasks.start(function():void
         {
            var _loc2_:File = null;
            var _loc1_:Object = null;
            if(_zipExt)
            {
               _loc2_ = _settingsFolder.resolvePath("Publish.json");
               if(_loc2_.exists)
               {
                  _loc1_ = UtilsFile.loadJSON(_loc2_);
                  _loc1_.fileExtension = _zipExt;
                  UtilsFile.saveJSON(_loc2_,_loc1_);
               }
            }
            _win.openProject(targetFolder.nativePath);
         });
      }
      
      private function convertSettings(param1:XML) : void
      {
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc8_:Object = null;
         var _loc18_:XML = null;
         var _loc16_:Object = null;
         var _loc12_:String = null;
         var _loc9_:Object = null;
         var _loc15_:* = null;
         var _loc2_:* = 0;
         var _loc10_:* = null;
         var _loc4_:* = null;
         var _loc11_:int = 0;
         var _loc17_:Object = null;
         var _loc3_:XMLList = null;
         var _loc13_:XML = null;
         var _loc19_:String = null;
         var _loc14_:String = null;
         var _loc7_:* = param1;
         try
         {
            _loc5_ = UtilsFile.loadJSON(this._sourceFolder.resolvePath("projectSettings.json"));
            if(_loc5_ != null)
            {
               _loc16_ = {};
               _loc9_ = _loc5_.publish_path;
               if(_loc9_)
               {
                  var _loc21_:* = _loc9_;
                  for each(_loc15_ in _loc9_)
                  {
                     _loc11_ = _loc16_[_loc15_];
                     _loc11_ = _loc11_ + 1;
                     _loc16_[_loc15_] = _loc11_;
                  }
                  _loc2_ = 0;
                  var _loc24_:int = 0;
                  var _loc23_:* = _loc16_;
                  for(_loc15_ in _loc16_)
                  {
                     _loc11_ = _loc16_[_loc15_];
                     if(_loc11_ > _loc2_)
                     {
                        _loc2_ = _loc11_;
                        _loc10_ = _loc15_;
                     }
                  }
                  var _loc26_:int = 0;
                  var _loc25_:* = _loc9_;
                  for(_loc4_ in _loc9_)
                  {
                     _loc15_ = _loc9_[_loc4_];
                     if(_loc15_ != _loc10_)
                     {
                        this._publishPath[_loc4_] = _loc15_.replace(/\\\\/g,"\\");
                     }
                  }
                  delete _loc5_.publish_path;
               }
               UtilsFile.saveJSON(this._objsFolder.resolvePath("workspace.json"),_loc5_);
            }
            _loc6_ = {};
            if(_loc10_)
            {
               _loc6_.path = _loc10_.replace(/\\\\/g,"\\");
            }
            _loc8_ = {};
            _loc6_.codeGeneration = _loc8_;
            _loc8_.codePath = String(_loc7_.@targetPath);
            _loc8_.classNamePrefix = String(_loc7_.@classNamePrefix);
            _loc8_.memberNamePrefix = String(_loc7_.@memberNamePrefix);
            _loc8_.packageName = String(_loc7_.@packageName);
            _loc12_ = _loc7_.@ignoreNoname;
            if(_loc12_)
            {
               _loc8_.ignoreNoname = _loc12_ == "true";
            }
            _loc12_ = _loc7_.@getMemberByName;
            if(_loc12_)
            {
               _loc8_.getMemberByName = _loc12_ == "true";
            }
            _loc12_ = _loc7_.@codeType;
            if(_loc12_)
            {
               _loc8_.codeType = _loc12_;
            }
            UtilsFile.saveJSON(this._settingsFolder.resolvePath("Publish.json"),_loc6_,true);
            _loc6_ = {};
            _loc18_ = _loc7_.textSetting[0];
            if(_loc18_)
            {
               _loc12_ = _loc18_.@font;
               if(_loc12_)
               {
                  _loc6_.font = _loc12_;
               }
               _loc12_ = _loc18_.@size;
               if(_loc12_)
               {
                  _loc6_.fontSize = parseInt(_loc12_);
               }
               _loc12_ = _loc18_.@color;
               if(_loc12_)
               {
                  _loc6_.textColor = _loc12_;
               }
               _loc12_ = _loc18_.@originalPosition;
               if(_loc12_ == "false")
               {
                  _loc6_.fontAdjustment = false;
               }
            }
            _loc18_ = _loc7_.colorScheme[0];
            if(_loc18_)
            {
               _loc12_ = _loc18_.@value;
               _loc6_.colorScheme = _loc12_.split("\r\n");
            }
            _loc18_ = _loc7_.fontSizeScheme[0];
            if(_loc18_)
            {
               _loc12_ = _loc18_.@value;
               _loc6_.fontSizeScheme = _loc12_.split("\r\n");
            }
            _loc18_ = _loc7_.scrollBars[0];
            if(_loc18_)
            {
               _loc17_ = {};
               _loc6_.scrollBars = _loc17_;
               _loc17_.vertical = String(_loc18_.@vertical);
               _loc17_.horizontal = String(_loc18_.@horizontal);
               _loc17_.defaultDisplay = String(_loc18_.@defaultDisplay);
            }
            UtilsFile.saveJSON(this._settingsFolder.resolvePath("Common.json"),_loc6_,true);
            _loc18_ = _loc7_.customProps[0];
            if(_loc18_)
            {
               _loc6_ = {};
               _loc3_ = _loc18_.elements();
               var _loc28_:int = 0;
               var _loc27_:* = _loc3_;
               for each(_loc13_ in _loc3_)
               {
                  _loc19_ = String(_loc13_.@key);
                  _loc14_ = String(_loc13_.@value);
                  _loc6_[_loc19_] = _loc14_;
               }
               UtilsFile.saveJSON(this._settingsFolder.resolvePath("CustomProperties.json"),_loc6_,true);
            }
            return;
         }
         catch(err:Error)
         {
            return;
         }
      }
      
      private function convertPkg() : void
      {
         var _loc1_:XML = null;
         var _loc15_:XML = null;
         var _loc5_:XML = null;
         var _loc20_:String = null;
         var _loc16_:String = null;
         var _loc14_:String = null;
         var _loc13_:String = null;
         var _loc11_:String = null;
         var _loc18_:XML = null;
         var _loc10_:XML = null;
         var _loc8_:File = null;
         var _loc6_:File = null;
         var _loc7_:AniDef = null;
         var _loc4_:String = this._tasks.taskData.@id;
         var _loc3_:String = this._tasks.taskData.@name;
         this._msg.text = UtilsStr.formatString(Consts.g.text315,_loc3_);
         var _loc19_:File = this._sourceFolder.resolvePath(_loc3_);
         if(!_loc19_.exists)
         {
            this._tasks.finishItem();
            return;
         }
         var _loc17_:XML = UtilsFile.loadXML(_loc19_.resolvePath("package.xml"));
         if(_loc17_ == null)
         {
            this._tasks.finishItem();
            return;
         }
         var _loc12_:File = this._assetsFolder.resolvePath(_loc3_);
         _loc12_.createDirectory();
         var _loc9_:Object = {};
         var _loc2_:XMLList = _loc17_.resources.elements();
         var _loc22_:int = 0;
         var _loc21_:* = _loc2_;
         for each(_loc1_ in _loc2_)
         {
            _loc14_ = _loc1_.@name;
            _loc1_.@name = _loc14_.replace(/[\:\/\\\*\?<>\|]/g,"_");
         }
         var _loc24_:int = 0;
         var _loc23_:* = _loc2_;
         for each(_loc1_ in _loc2_)
         {
            _loc20_ = _loc1_.name().localName;
            if(_loc20_ == "folder")
            {
               _loc16_ = this.getPath(_loc2_,_loc1_);
               _loc9_[_loc1_.@id] = _loc16_;
               _loc12_.resolvePath("." + _loc16_).createDirectory();
            }
         }
         _loc18_ = <packageDescription><resources/></packageDescription>;
         _loc18_.@id = _loc4_;
         _loc13_ = _loc17_.@jpegQuality;
         if(_loc13_)
         {
            _loc18_.@jpegQuality = _loc13_;
         }
         _loc13_ = _loc17_.@compressPNG;
         if(_loc13_)
         {
            _loc18_.@compressPNG = _loc13_;
         }
         var _loc26_:int = 0;
         var _loc25_:* = _loc2_;
         for each(_loc1_ in _loc2_)
         {
            _loc20_ = _loc1_.name().localName;
            if(_loc20_ != "folder")
            {
               if(_loc20_ == "jta")
               {
                  _loc20_ = "movieclip";
               }
               _loc15_ = new XML("<" + _loc20_ + "/>");
               _loc18_.resources.appendChild(_loc15_);
               _loc15_.@id = _loc1_.@id;
               _loc13_ = UtilsStr.getFileExt(_loc1_.@file);
               _loc14_ = _loc1_.@name;
               if(UtilsStr.getFileExt(_loc14_) == _loc13_)
               {
                  if(_loc1_.@exported != "true")
                  {
                     _loc14_ = _loc14_.replace(/\./g,"_");
                  }
               }
               _loc15_.@name = _loc14_ + (!!_loc13_?"." + _loc13_:"");
               _loc11_ = _loc1_.@folder;
               if(_loc11_)
               {
                  _loc16_ = _loc9_[_loc11_];
                  if(!_loc16_)
                  {
                     _loc16_ = "/";
                  }
               }
               else
               {
                  _loc16_ = "/";
               }
               _loc15_.@path = _loc16_;
               _loc13_ = _loc1_.@exported;
               if(_loc13_)
               {
                  _loc15_.@exported = _loc13_;
               }
               if(_loc20_ == "image" || _loc20_ == "movieclip")
               {
                  _loc13_ = _loc1_.@includedInAtlas;
                  if(_loc13_)
                  {
                     if(_loc13_ == "no")
                     {
                        _loc15_.@atlas = "alone";
                     }
                     else if(_loc13_ != "yes" && _loc13_ != "default" && _loc13_ != "0")
                     {
                        _loc15_.@atlas = _loc13_;
                     }
                  }
                  _loc13_ = _loc1_.@qualityOption;
                  if(_loc13_)
                  {
                     if(_loc13_ != "package" && !(_loc13_ == "source" && this._useAtlas) && (_loc13_ == "source" || _loc13_ == "custom"))
                     {
                        _loc15_.@qualityOption = _loc1_.@qualityOption;
                     }
                  }
                  _loc13_ = _loc1_.@scale;
                  if(_loc13_)
                  {
                     _loc15_.@scale = _loc13_;
                  }
                  _loc13_ = _loc1_.@scale9grid;
                  if(_loc13_)
                  {
                     _loc15_.@scale9grid = _loc13_;
                  }
                  _loc13_ = _loc1_.@gridTile;
                  if(_loc13_)
                  {
                     _loc15_.@gridTile = _loc13_;
                  }
                  _loc13_ = _loc1_.@quality;
                  if(_loc13_)
                  {
                     _loc15_.@quality = _loc13_;
                  }
               }
               _loc8_ = _loc19_.resolvePath(_loc1_.@file);
               _loc6_ = _loc12_.resolvePath("." + _loc16_ + _loc15_.@name);
               if(_loc20_ == "movieclip")
               {
                  _loc7_ = new AniDef();
                  try
                  {
                     _loc7_.load(UtilsFile.loadBytes(_loc8_));
                     UtilsFile.saveBytes(_loc6_,_loc7_.save());
                  }
                  catch(err:Error)
                  {
                  }
               }
               else if(_loc20_ == "font")
               {
                  UtilsFile.copyFile(_loc8_,_loc6_);
                  _loc8_ = _loc19_.resolvePath(_loc1_.@id + "_.png");
                  if(_loc8_.exists)
                  {
                     _loc6_ = _loc12_.resolvePath("." + _loc16_ + _loc14_ + "_atlas.png");
                     UtilsFile.copyFile(_loc8_,_loc6_);
                     _loc5_ = <image/>;
                     _loc5_.@id = this.getNextId();
                     _loc5_.@name = _loc14_ + "_atlas.png";
                     _loc5_.@path = _loc15_.@path;
                     _loc13_ = _loc1_.@atlas;
                     if(_loc13_)
                     {
                        if(_loc13_ == "no")
                        {
                           _loc5_.@atlas = "alone";
                        }
                        else if(_loc13_ != "yes" && _loc13_ != "default" && _loc13_ != "0")
                        {
                           _loc5_.@atlas = _loc13_;
                        }
                     }
                     _loc18_.resources.appendChild(_loc5_);
                     _loc15_.@texture = _loc5_.@id;
                  }
               }
               else
               {
                  UtilsFile.copyFile(_loc8_,_loc6_);
               }
            }
         }
         _loc10_ = _loc17_.publish[0];
         if(_loc10_)
         {
            if(this._publishPath[_loc4_])
            {
               _loc10_.@path = this._publishPath[_loc4_];
            }
            _loc13_ = _loc10_.@singlePackage;
            if(_loc13_ == "true")
            {
               _loc10_.@packageCount = "1";
            }
            _loc13_ = _loc10_.@zipExt;
            if(_loc13_)
            {
               this._zipExt = _loc13_;
            }
            delete _loc10_.@zipExt;
            _loc18_.appendChild(_loc10_);
         }
         UtilsFile.saveXML(_loc12_.resolvePath("package.xml"),_loc18_);
         System.disposeXML(_loc17_);
         System.disposeXML(_loc18_);
         GTimers.inst.add(12,1,this._tasks.finishItem);
      }
      
      public function getNextId() : String
      {
         var _loc1_:Number = this._nextId;
         this._nextId++;
         return this._devCode + _loc1_.toString(36);
      }
      
      private function getPath(param1:XMLList, param2:XML) : String
      {
         var _loc5_:XML = null;
         var _loc4_:* = param1;
         var _loc7_:* = param2;
         var _loc3_:Array = [];
         _loc3_.push(_loc7_.@name);
         var _loc6_:String = _loc7_.@folder;
         while(_loc6_ != "")
         {
            var _loc8_:* = _loc4_;
            var _loc9_:int = 0;
            var _loc11_:* = new XMLList("");
            _loc5_ = _loc4_.(@id == _loc6_)[0];
            if(_loc5_)
            {
               _loc3_.push(_loc5_.@name);
               _loc6_ = _loc5_.@folder;
               if(_loc3_.indexOf(_loc6_) == -1)
               {
                  continue;
               }
               break;
            }
            break;
         }
         _loc3_.reverse();
         if(_loc3_.length == 0)
         {
            return "/";
         }
         return "/" + _loc3_.join("/") + "/";
      }
   }
}
