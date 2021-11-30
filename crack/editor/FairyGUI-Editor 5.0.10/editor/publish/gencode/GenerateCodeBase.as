package fairygui.editor.publish.gencode
{
   import fairygui.editor.Consts;
   import fairygui.editor.api.ProjectType;
   import fairygui.editor.gui.FPackageItem;
   import fairygui.editor.publish.§_-4Z§;
   import fairygui.editor.publish.taskRun;
   import fairygui.editor.settings.GlobalPublishSettings;
   import fairygui.utils.PinYinUtil;
   import fairygui.utils.UtilsFile;
   import fairygui.utils.UtilsStr;
   import flash.filesystem.File;
   
   public class GenerateCodeBase extends taskRun
   {
      
      public static const FILE_MARK:String = "/** This is an automatically generated class by FairyGUI. Please do not modify it. **/";
       
      
      protected var settings:GlobalPublishSettings;
      
      protected var thisPackageFolder:File;
      
      protected var thisPackageName:String = "";
      
      protected var thisPackagePath:String = "";
      
      protected var sortedClasses:Array;
      
      protected var classInfo:Object;
      
      public function GenerateCodeBase()
      {
         this.sortedClasses = [];
         super();
      }
      
      protected function init(param1:Array) : void
      {
         var targetFolder:File = null;
         var oldFiles:Array = null;
         var file:File = null;
         var fileContent:String = null;
         var fileExtNames:Array = param1;
         this.settings = GlobalPublishSettings(publishData.project.getSettings("publish"));
         try
         {
            targetFolder = new File(publishData.codePath);
            if(!targetFolder.exists)
            {
               targetFolder.createDirectory();
            }
            else if(!targetFolder.isDirectory)
            {
               _stepCallback.addMsg(Consts.strings.text341);
               _stepCallback.callOnFail();
               return;
            }
         }
         catch(err:Error)
         {
            publishData.project.editor.consoleView.logError(null,err);
            _stepCallback.addMsg(Consts.strings.text341);
            _stepCallback.callOnFail();
            return;
         }
         this.thisPackageName = this.normalizeName(publishData.pkg.name);
         this.thisPackageFolder = new File(targetFolder.nativePath + File.separator + this.thisPackageName);
         if(!this.settings.packageName || this.settings.packageName.length == 0)
         {
            this.thisPackagePath = this.thisPackageName;
         }
         else
         {
            this.thisPackagePath = this.settings.packageName + "." + this.thisPackageName;
         }
         if(this.thisPackageFolder.exists)
         {
            oldFiles = this.thisPackageFolder.getDirectoryListing();
            for each(file in oldFiles)
            {
               if(!(file.isDirectory || fileExtNames.indexOf(file.extension) == -1))
               {
                  fileContent = UtilsFile.loadString(file);
                  if(UtilsStr.startsWith(fileContent,FILE_MARK))
                  {
                     UtilsFile.deleteFile(file);
                  }
               }
            }
         }
         else
         {
            this.thisPackageFolder.createDirectory();
         }
         this.prepare(publishData);
         for each(this.classInfo in publishData.outputClasses)
         {
            if(!this.classInfo.ignored)
            {
               this.sortedClasses.push(this.classInfo);
            }
         }
         this.sortedClasses.sortOn("classId");
      }
      
      protected function loadTemplate(param1:String, param2:String) : String
      {
         var _loc5_:String = null;
         var _loc3_:* = param1 + "/" + param2 + ".template";
         var _loc4_:File = new File(publishData.project.basePath + "/template/" + _loc3_);
         if(_loc4_.exists)
         {
            _loc5_ = UtilsFile.loadString(_loc4_);
         }
         else
         {
            _loc4_ = File.applicationDirectory.resolvePath("template/" + _loc3_);
            if(_loc4_.exists)
            {
               _loc5_ = UtilsFile.loadString(_loc4_);
            }
         }
         if(_loc5_ == null)
         {
            throw new Error("代码模板不存在！ " + _loc3_);
         }
         _loc5_ = _loc5_.replace(/\r\n/g,"\n");
         return _loc5_;
      }
      
      protected function checkIsUseDefaultName(param1:String, param2:String, param3:String) : Boolean
      {
         var _loc4_:int = 0;
         if(param2 == "Controller")
         {
            if((param1 == "GButton" || param1 == "GComboBox") && param3 == "button")
            {
               return true;
            }
         }
         else if(param2 != "Transition")
         {
            switch(param1)
            {
               case "GButton":
               case "GLabel":
               case "GComboBox":
                  if(param3 == "title" || param3 == "icon")
                  {
                     return true;
                  }
                  break;
               case "GProgressBar":
                  if(param3 == "bar" || param3 == "bar_v" || param3 == "title" || param3 == "ani")
                  {
                     return true;
                  }
                  break;
               case "GSlider":
                  if(param3 == "bar" || param3 == "bar_v" || param3 == "grip" || param3 == "title" || param3 == "ani")
                  {
                     return true;
                  }
                  break;
            }
            if(param3.charAt(0) == "n")
            {
               _loc4_ = param3.indexOf("_");
               if(_loc4_ != -1)
               {
                  if(!isNaN(parseInt(param3.substring(1,_loc4_))))
                  {
                     return true;
                  }
               }
               else if(!isNaN(parseInt(param3.substring(1))))
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function prepare(param1:§_-4Z§) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:* = undefined;
         var _loc8_:Object = null;
         var _loc9_:FPackageItem = null;
         var _loc10_:String = null;
         var _loc2_:GlobalPublishSettings = GlobalPublishSettings(publishData.project.getSettings("publish"));
         for each(_loc4_ in param1.outputClasses)
         {
            _loc4_.encodedClassName = _loc2_.classNamePrefix + this.normalizeName(_loc4_.className);
            _loc3_ = {};
            _loc5_ = 0;
            for each(_loc6_ in _loc4_.members)
            {
               _loc6_.originalName = _loc6_.name;
               if(_loc2_.ignoreNoname && this.checkIsUseDefaultName(_loc4_.superClassName,_loc6_.type,_loc6_.name))
               {
                  _loc6_.ignored = true;
               }
               else
               {
                  _loc7_ = _loc3_[_loc6_.name];
                  if(_loc7_ != undefined)
                  {
                     _loc7_++;
                     _loc3_[_loc6_.name] = _loc7_;
                     _loc6_.name = _loc6_.name + "_" + _loc7_;
                  }
                  _loc3_[_loc6_.name] = 1;
                  _loc5_++;
               }
            }
            if(_loc5_ == 0)
            {
               _loc4_.ignored = true;
            }
         }
         for each(_loc4_ in param1.outputClasses)
         {
            if(!_loc4_.ignored)
            {
               for each(_loc6_ in _loc4_.members)
               {
                  if(_loc6_.src)
                  {
                     if(!_loc6_.pkg_id)
                     {
                        _loc8_ = param1.outputClasses[_loc6_.src_id];
                        if(_loc8_)
                        {
                           if(!_loc8_.ignored)
                           {
                              _loc6_.type = _loc8_.encodedClassName;
                           }
                           else
                           {
                              _loc6_.type = _loc8_.superClassName;
                           }
                        }
                        else
                        {
                           _loc6_.type = "GComponent";
                        }
                     }
                     else
                     {
                        _loc9_ = param1.project.getPackage(_loc6_.pkg_id).getItem(_loc6_.src_id);
                        if(_loc9_)
                        {
                           _loc10_ = _loc9_.componentExtension;
                           if(_loc10_)
                           {
                              _loc6_.type = "G" + _loc10_;
                           }
                        }
                     }
                  }
                  if(!_loc2_.memberNamePrefix)
                  {
                     _loc6_.name = this.normalizeName(_loc6_.name);
                  }
                  else
                  {
                     _loc6_.name = _loc2_.memberNamePrefix + this.normalizeName(_loc6_.name);
                  }
               }
            }
         }
      }
      
      protected function translateClassName(param1:String, param2:Object = null) : String
      {
         switch(param1)
         {
            case "GImage":
            case "GMovieClip":
            case "GSwfObject":
            case "GLoader":
            case "GTextField":
            case "GRichTextField":
            case "GTextInput":
            case "GGraph":
            case "GGroup":
            case "GComponent":
            case "GList":
            case "GTree":
            case "GLabel":
            case "GButton":
            case "GComboBox":
            case "GSlider":
            case "GProgressBar":
            case "GScrollBar":
            case "Transition":
               if(publishData.project.type == ProjectType.PIXI || publishData.project.type == ProjectType.COCOSCREATOR || publishData.project.type == ProjectType.LAYABOX && param2)
               {
                  return "fgui." + param1;
               }
               if(publishData.project.type == ProjectType.COCOS2DX || publishData.project.type == ProjectType.VISION)
               {
                  return "fairygui::" + param1;
               }
               if(publishData.project.type == ProjectType.EGRET || publishData.project.type == ProjectType.LAYABOX)
               {
                  return "fairygui." + param1;
               }
               return param1;
            case "Controller":
               if(publishData.project.type == ProjectType.PIXI)
               {
                  return "fgui.controller.Controller";
               }
               if(publishData.project.type == ProjectType.COCOSCREATOR || publishData.project.type == ProjectType.LAYABOX && param2)
               {
                  return "fgui.Controller";
               }
               if(publishData.project.type == ProjectType.COCOS2DX || publishData.project.type == ProjectType.VISION)
               {
                  return "fairygui::GController";
               }
               if(publishData.project.type == ProjectType.EGRET || publishData.project.type == ProjectType.LAYABOX)
               {
                  return "fairygui.Controller";
               }
               return param1;
            default:
               return param1;
         }
      }
      
      protected function normalizeName(param1:String) : String
      {
         if((publishData.project.type == ProjectType.COCOS2DX || publishData.project.type == ProjectType.VISION) && param1.toLowerCase() == "main")
         {
            return param1 + "_c_reserved";
         }
         return PinYinUtil.toPinyin(param1).replace(/[&-]/g,"_");
      }
      
      protected function generate(param1:String, param2:Object) : String
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc3_:int = 0;
         var _loc8_:* = "";
         while((_loc4_ = param1.indexOf("{",_loc3_)) != -1)
         {
            _loc8_ = _loc8_ + param1.substring(_loc3_,_loc4_);
            _loc3_ = _loc4_;
            _loc4_ = param1.indexOf("}",_loc3_);
            if(_loc4_ == -1)
            {
               break;
            }
            if(_loc4_ == _loc3_ + 1)
            {
               _loc8_ = _loc8_ + param1.substr(_loc3_,2);
               _loc3_ = _loc4_ + 1;
            }
            else
            {
               _loc6_ = param1.substring(_loc3_ + 1,_loc4_);
               _loc7_ = param2[_loc6_];
               if(_loc7_ != null)
               {
                  _loc8_ = _loc8_ + _loc7_;
                  _loc3_ = _loc4_ + 1;
               }
               else
               {
                  _loc8_ = _loc8_ + "{";
                  _loc3_++;
               }
            }
         }
         if(_loc3_ < param1.length)
         {
            _loc8_ = _loc8_ + param1.substr(_loc3_);
         }
         return _loc8_;
      }
   }
}
