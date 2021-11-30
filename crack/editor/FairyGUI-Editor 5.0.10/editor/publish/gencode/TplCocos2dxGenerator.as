package fairygui.editor.publish.gencode
{
   import fairygui.utils.UtilsFile;
   import flash.filesystem.File;
   
   public class TplCocos2dxGenerator extends GenerateCodeBase
   {
       
      
      public function TplCocos2dxGenerator()
      {
         super();
      }
      
      override public function run() : void
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:* = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Object = null;
         var _loc15_:String = null;
         var _loc16_:* = null;
         init(["h","cpp"]);
         var _loc1_:Object = {};
         _loc1_["packageName"] = thisPackagePath;
         _loc1_["thisPackageName"] = thisPackageName;
         _loc1_["uiPkgName"] = publishData.pkg.name;
         var _loc2_:String = loadTemplate(publishData.project.type,"ComponentH");
         var _loc3_:String = loadTemplate(publishData.project.type,"ComponentCPP");
         _loc4_ = [];
         _loc5_ = [];
         for each(classInfo in sortedClasses)
         {
            _loc7_ = [];
            _loc8_ = [];
            _loc9_ = [];
            _loc11_ = 0;
            _loc12_ = 0;
            _loc13_ = 0;
            for each(_loc14_ in classInfo.members)
            {
               _loc15_ = translateClassName(_loc14_.type);
               if(_loc14_.type == "Controller")
               {
                  if(!_loc14_.ignored)
                  {
                     if(settings.getMemberByName)
                     {
                        _loc7_.push("    " + _loc14_.name + " = getController(\"" + _loc14_.originalName + "\");");
                     }
                     else
                     {
                        _loc7_.push("    " + _loc14_.name + " = getControllerAt(" + _loc12_ + ");");
                     }
                  }
                  _loc12_++;
               }
               else if(_loc14_.type == "Transition")
               {
                  if(!_loc14_.ignored)
                  {
                     if(settings.getMemberByName)
                     {
                        _loc7_.push("    " + _loc14_.name + " = getTransition(\"" + _loc14_.originalName + "\");");
                     }
                     else
                     {
                        _loc7_.push("    " + _loc14_.name + " = getTransitionAt(" + _loc13_ + ");");
                     }
                  }
                  _loc13_++;
               }
               else
               {
                  if(!_loc14_.ignored)
                  {
                     if(settings.getMemberByName)
                     {
                        _loc7_.push("    " + _loc14_.name + " = dynamic_cast<" + _loc15_ + "*>(getChild(\"" + _loc14_.originalName + "\"));");
                     }
                     else
                     {
                        _loc7_.push("    " + _loc14_.name + " = dynamic_cast<" + _loc15_ + "*>(getChildAt(" + _loc11_ + "));");
                     }
                  }
                  _loc11_++;
               }
               if(!_loc14_.ignored)
               {
                  _loc8_.push("    " + _loc15_ + "* " + _loc14_.name + ";");
                  if(_loc15_.indexOf(":") == -1)
                  {
                     _loc16_ = "class " + _loc15_ + ";";
                     if(_loc9_.indexOf(_loc16_) == -1)
                     {
                        _loc9_.push(_loc16_);
                     }
                  }
               }
            }
            _loc4_.push("    UIObjectFactory::setPackageItemExtension(" + classInfo.encodedClassName + "::URL, std::bind(&" + classInfo.encodedClassName + "::createByBinder));");
            _loc5_.push("#include \"" + classInfo.encodedClassName + ".h\"");
            _loc1_["className"] = classInfo.encodedClassName;
            _loc1_["componentName"] = translateClassName(!!classInfo.customSuperClassName?classInfo.customSuperClassName:classInfo.superClassName);
            _loc1_["uiPath"] = "ui://" + publishData.pkg.id + classInfo.classId;
            _loc1_["uiResName"] = classInfo.className;
            _loc1_["forwardDeclaration"] = _loc9_.join("\n");
            _loc1_["createInstance"] = "    return dynamic_cast<" + classInfo.encodedClassName + "*>(UIPackage::createObject(\"" + publishData.pkg.name + "\",\"" + classInfo.className + "\"));";
            _loc1_["variable"] = _loc8_.join("\n");
            _loc1_["content"] = _loc7_.join("\n");
            UtilsFile.saveString(new File(thisPackageFolder.nativePath + File.separator + classInfo.encodedClassName + ".h"),FILE_MARK + "\n\n" + generate(_loc2_,_loc1_));
            UtilsFile.saveString(new File(thisPackageFolder.nativePath + File.separator + classInfo.encodedClassName + ".cpp"),FILE_MARK + "\n\n" + generate(_loc3_,_loc1_));
         }
         _loc6_ = thisPackageName + "Binder";
         _loc1_["className"] = _loc6_;
         _loc1_["includeFiles"] = _loc5_.join("\n");
         _loc1_["bindContent"] = _loc4_.join("\n");
         UtilsFile.saveString(new File(thisPackageFolder.nativePath + File.separator + _loc6_ + ".h"),FILE_MARK + "\n\n" + generate(loadTemplate("Cocos2dx","BinderH"),_loc1_));
         UtilsFile.saveString(new File(thisPackageFolder.nativePath + File.separator + _loc6_ + ".cpp"),FILE_MARK + "\n\n" + generate(loadTemplate("Cocos2dx","BinderCPP"),_loc1_));
         _stepCallback.callOnSuccess();
      }
   }
}
