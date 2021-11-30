package fairygui.editor.publish.gencode
{
   import fairygui.utils.UtilsFile;
   import flash.filesystem.File;
   
   public class TplLaya2TSGenerator extends GenerateCodeBase
   {
       
      
      public function TplLaya2TSGenerator()
      {
         super();
      }
      
      override public function run() : void
      {
         var _loc5_:String = null;
         var _loc8_:* = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:Object = null;
         var _loc16_:String = null;
         var _loc17_:* = null;
         init(["ts"]);
         var _loc1_:Object = {};
         _loc1_["packageName"] = thisPackagePath;
         _loc1_["thisPackageName"] = thisPackageName;
         _loc1_["uiPkgName"] = publishData.pkg.name;
         var _loc2_:String = loadTemplate("Laya2TS","Component");
         var _loc3_:* = settings.codeType == "TS-2.0";
         var _loc4_:String = !!_loc3_?"fairygui":"fgui";
         _loc5_ = !!_loc3_?"setPackageItemExtension":"setExtension";
         var _loc6_:Array = [];
         var _loc7_:Array = [];
         for each(classInfo in sortedClasses)
         {
            _loc9_ = [];
            _loc10_ = [];
            _loc11_ = [];
            _loc12_ = 0;
            _loc13_ = 0;
            _loc14_ = 0;
            for each(_loc15_ in classInfo.members)
            {
               _loc16_ = translateClassName(_loc15_.type,!_loc3_);
               if(_loc15_.type == "Controller")
               {
                  if(!_loc15_.ignored)
                  {
                     if(settings.getMemberByName)
                     {
                        _loc9_.push("\t\tthis." + _loc15_.name + " = this.getController(\"" + _loc15_.originalName + "\");");
                     }
                     else
                     {
                        _loc9_.push("\t\tthis." + _loc15_.name + " = this.getControllerAt(" + _loc13_ + ");");
                     }
                  }
                  _loc13_++;
               }
               else if(_loc15_.type == "Transition")
               {
                  if(!_loc15_.ignored)
                  {
                     if(settings.getMemberByName)
                     {
                        _loc9_.push("\t\tthis." + _loc15_.name + " = this.getTransition(\"" + _loc15_.originalName + "\");");
                     }
                     else
                     {
                        _loc9_.push("\t\tthis." + _loc15_.name + " = this.getTransitionAt(" + _loc14_ + ");");
                     }
                  }
                  _loc14_++;
               }
               else
               {
                  if(!_loc15_.ignored)
                  {
                     if(settings.getMemberByName)
                     {
                        _loc9_.push("\t\tthis." + _loc15_.name + " = <" + _loc16_ + "><any>(this.getChild(\"" + _loc15_.originalName + "\"));");
                     }
                     else
                     {
                        _loc9_.push("\t\tthis." + _loc15_.name + " = <" + _loc16_ + "><any>(this.getChildAt(" + _loc12_ + "));");
                     }
                  }
                  _loc12_++;
               }
               if(!_loc15_.ignored)
               {
                  _loc10_.push("\tpublic " + _loc15_.name + ":" + _loc16_ + ";");
                  if(_loc16_.indexOf(".") == -1)
                  {
                     _loc17_ = "import " + _loc16_ + " from \"./" + _loc16_ + "\";";
                     if(_loc11_.indexOf(_loc17_) == -1)
                     {
                        _loc11_.push(_loc17_);
                     }
                  }
               }
            }
            _loc6_.push("\t\t" + _loc4_ + ".UIObjectFactory." + _loc5_ + "(" + classInfo.encodedClassName + ".URL, " + classInfo.encodedClassName + ");");
            _loc7_.push("import " + classInfo.encodedClassName + " from \"./" + classInfo.encodedClassName + "\";");
            _loc1_["className"] = classInfo.encodedClassName;
            _loc1_["componentName"] = translateClassName(!!classInfo.customSuperClassName?classInfo.customSuperClassName:classInfo.superClassName,!_loc3_);
            _loc1_["uiPath"] = "ui://" + publishData.pkg.id + classInfo.classId;
            _loc1_["uiResName"] = classInfo.className;
            _loc1_["createInstance"] = "\t\treturn <" + classInfo.encodedClassName + "><any>(" + _loc4_ + ".UIPackage.createObject(\"" + publishData.pkg.name + "\",\"" + classInfo.className + "\"));";
            _loc1_["includeFiles"] = _loc11_.join("\n");
            _loc1_["variable"] = _loc10_.join("\n");
            _loc1_["content"] = _loc9_.join("\n");
            UtilsFile.saveString(new File(thisPackageFolder.nativePath + File.separator + classInfo.encodedClassName + ".ts"),FILE_MARK + "\n\n" + generate(_loc2_,_loc1_));
         }
         _loc8_ = thisPackageName + "Binder";
         _loc1_["className"] = _loc8_;
         _loc1_["bindContent"] = _loc6_.join("\n");
         _loc1_["includeFiles"] = _loc7_.join("\n");
         UtilsFile.saveString(new File(thisPackageFolder.nativePath + File.separator + _loc8_ + ".ts"),FILE_MARK + "\n\n" + generate(loadTemplate("Laya2TS","Binder"),_loc1_));
         _stepCallback.callOnSuccess();
      }
   }
}
