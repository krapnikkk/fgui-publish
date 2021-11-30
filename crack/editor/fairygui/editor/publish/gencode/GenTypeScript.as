package fairygui.editor.publish.gencode
{
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   import flash.filesystem.File;
   
   public class GenTypeScript extends GenerateCodeBase
   {
       
      
      public function GenTypeScript()
      {
         super();
      }
      
      override public function run() : void
      {
         init("ts");
         loadTemplate("TypeScript");
      }
      
      override protected function createFile(param1:*) : void
      {
         var _loc4_:* = null;
         var _loc8_:int = 0;
         var _loc17_:* = null;
         var _loc6_:* = null;
         var _loc7_:String = null;
         var _loc12_:Array = null;
         var _loc13_:Array = null;
         var _loc11_:Array = null;
         var _loc10_:String = null;
         var _loc16_:String = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:Object = null;
         var _loc9_:Array = [];
         thisPackagePath;
         var _loc18_:String = UtilsStr.formatStringByName(this.settings.codePath,publishData._project.customProperties);
         var _loc2_:File = new File(publishData.project.basePath).resolvePath(_loc18_);
         _loc18_ = _loc2_.nativePath;
         _loc2_ = null;
         var _loc22_:int = 0;
         var _loc21_:* = sortedClasses;
         for each(classInfo in sortedClasses)
         {
            _loc12_ = [];
            _loc13_ = [];
            _loc11_ = [];
            _loc16_ = param1["Component"];
            _loc16_ = _loc16_.replace("{packageName}",thisPackagePath);
            _loc16_ = _loc16_.split("{className}").join(classInfo.encodedClassName);
            _loc16_ = _loc16_.replace("{componentName}",!!classInfo.customSuperClassName?classInfo.customSuperClassName:"fairygui." + classInfo.superClassName);
            _loc16_ = _loc16_.replace("{uiPath}","ui://" + publishData.targetUIPackage.id + classInfo.classId);
            _loc16_ = _loc16_.replace("{createInstance}","\t\t\treturn <" + classInfo.encodedClassName + "><any>(fairygui.UIPackage.createObject(\"" + publishData.targetUIPackage.name + "\",\"" + classInfo.className + "\"));");
            _loc16_ = _loc16_.split("{uiPkgName}").join(publishData.targetUIPackage.name);
            _loc16_ = _loc16_.split("{uiResName}").join(classInfo.className);
            _loc14_ = 0;
            _loc15_ = 0;
            _loc3_ = 0;
            var _loc20_:int = 0;
            var _loc19_:* = classInfo.members;
            for each(_loc5_ in classInfo.members)
            {
               if(_loc5_.type == "Controller")
               {
                  if(!_loc5_.ignored)
                  {
                     if(settings.getMemberByName)
                     {
                        _loc12_.push("\t\t\tthis." + _loc5_.name + " = this.getController(\"" + _loc5_.originalName + "\");");
                     }
                     else
                     {
                        _loc12_.push("\t\t\tthis." + _loc5_.name + " = this.getControllerAt(" + _loc15_ + ");");
                     }
                  }
                  _loc15_++;
               }
               else if(_loc5_.type == "Transition")
               {
                  if(!_loc5_.ignored)
                  {
                     if(settings.getMemberByName)
                     {
                        _loc12_.push("\t\t\tthis." + _loc5_.name + " = this.getTransition(\"" + _loc5_.originalName + "\");");
                     }
                     else
                     {
                        _loc12_.push("\t\t\tthis." + _loc5_.name + " = this.getTransitionAt(" + _loc3_ + ");");
                     }
                  }
                  _loc3_++;
               }
               else
               {
                  if(!_loc5_.ignored)
                  {
                     if(settings.getMemberByName)
                     {
                        _loc12_.push("\t\t\tthis." + _loc5_.name + " = <" + GenCodeUtils.translateClassName(_loc5_.type) + "><any>(this.getChild(\"" + _loc5_.originalName + "\"));");
                     }
                     else
                     {
                        _loc12_.push("\t\t\tthis." + _loc5_.name + " = <" + GenCodeUtils.translateClassName(_loc5_.type) + "><any>(this.getChildAt(" + _loc14_ + "));");
                     }
                  }
                  _loc14_++;
               }
               if(!_loc5_.ignored)
               {
                  _loc13_.push("\t\tpublic " + _loc5_.name + ":" + GenCodeUtils.translateClassName(_loc5_.type) + ";");
               }
               if(_loc5_.events != null)
               {
                  _loc12_.push("\t\t\tthis." + _loc5_.name + ".onClick(this,this." + _loc5_.name + "OnClick);");
               }
               if(_loc5_.events != null)
               {
                  _loc4_ = "\r\n\t\tprivate " + _loc5_.name + "OnClick(evt:Event):void{\r\n";
                  _loc8_ = 0;
                  while(_loc8_ < _loc5_.events.length)
                  {
                     _loc17_ = _loc5_.events[_loc8_].split("@");
                     _loc4_ = _loc4_ + ("\t\t\tFacade.instance.event(" + _loc17_[0] + "," + _loc17_[1] + ");\r\n");
                     _loc8_++;
                  }
                  _loc4_ = _loc4_ + "\t\t};";
                  _loc11_.push(_loc4_);
               }
            }
            _loc16_ = _loc16_.replace("{functions}",_loc11_.join("\r\n"));
            _loc16_ = _loc16_.replace("{variable}",_loc13_.join("\r\n"));
            _loc16_ = _loc16_.replace("{content}",_loc12_.join("\r\n"));
            _loc9_.push("\t\t\tfairygui.UIObjectFactory.setPackageItemExtension(" + classInfo.encodedClassName + ".URL, " + classInfo.encodedClassName + ");");
            UtilsFile.saveString(new File(thisPackageFolder.nativePath + File.separator + classInfo.encodedClassName + ".ts"),"/** This is an automatically generated class by FairyGUI. Please do not modify it. **/\n\n" + _loc16_);
         }
         _loc6_ = thisPackageName + "Binder";
         _loc7_ = param1["Binder"];
         _loc7_ = _loc7_.replace("{packageName}",thisPackagePath);
         _loc7_ = _loc7_.split("{className}").join(_loc6_);
         _loc7_ = _loc7_.replace("{bindContent}",_loc9_.join("\r\n"));
         UtilsFile.saveString(new File(thisPackageFolder.nativePath + File.separator + _loc6_ + ".ts"),"/** This is an automatically generated class by FairyGUI. Please do not modify it. **/\n\n" + _loc7_);
         stepCallback.callOnSuccess();
      }
   }
}
