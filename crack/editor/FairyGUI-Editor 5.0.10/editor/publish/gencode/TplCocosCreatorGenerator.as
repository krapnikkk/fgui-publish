package fairygui.editor.publish.gencode
{
   import fairygui.utils.UtilsFile;
   import flash.filesystem.File;
   
   public class TplCocosCreatorGenerator extends GenerateCodeBase
   {
       
      
      public function TplCocosCreatorGenerator()
      {
         super();
      }
      
      override public function run() : void
      {
         var _loc5_:* = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Object = null;
         var _loc13_:String = null;
         var _loc14_:* = null;
         init(["ts"]);
         var _loc1_:Object = {};
         _loc1_["packageName"] = thisPackagePath;
         _loc1_["thisPackageName"] = thisPackageName;
         _loc1_["uiPkgName"] = publishData.pkg.name;
         var _loc2_:String = loadTemplate("CocosCreator","Component");
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         for each(classInfo in sortedClasses)
         {
            _loc6_ = [];
            _loc7_ = [];
            _loc8_ = [];
            _loc9_ = 0;
            _loc10_ = 0;
            _loc11_ = 0;
            for each(_loc12_ in classInfo.members)
            {
               _loc13_ = translateClassName(_loc12_.type);
               if(_loc12_.type == "Controller")
               {
                  if(!_loc12_.ignored)
                  {
                     if(settings.getMemberByName)
                     {
                        _loc6_.push("\t\tthis." + _loc12_.name + " = this.getController(\"" + _loc12_.originalName + "\");");
                     }
                     else
                     {
                        _loc6_.push("\t\tthis." + _loc12_.name + " = this.getControllerAt(" + _loc10_ + ");");
                     }
                  }
                  _loc10_++;
               }
               else if(_loc12_.type == "Transition")
               {
                  if(!_loc12_.ignored)
                  {
                     if(settings.getMemberByName)
                     {
                        _loc6_.push("\t\tthis." + _loc12_.name + " = this.getTransition(\"" + _loc12_.originalName + "\");");
                     }
                     else
                     {
                        _loc6_.push("\t\tthis." + _loc12_.name + " = this.getTransitionAt(" + _loc11_ + ");");
                     }
                  }
                  _loc11_++;
               }
               else
               {
                  if(!_loc12_.ignored)
                  {
                     if(settings.getMemberByName)
                     {
                        _loc6_.push("\t\tthis." + _loc12_.name + " = <" + _loc13_ + ">(this.getChild(\"" + _loc12_.originalName + "\"));");
                     }
                     else
                     {
                        _loc6_.push("\t\tthis." + _loc12_.name + " = <" + _loc13_ + ">(this.getChildAt(" + _loc9_ + "));");
                     }
                  }
                  _loc9_++;
               }
               if(!_loc12_.ignored)
               {
                  _loc7_.push("\tpublic " + _loc12_.name + ":" + _loc13_ + ";");
                  if(_loc13_.indexOf(".") == -1)
                  {
                     _loc14_ = "import " + _loc13_ + " from \"./" + _loc13_ + "\";";
                     if(_loc8_.indexOf(_loc14_) == -1)
                     {
                        _loc8_.push(_loc14_);
                     }
                  }
               }
            }
            _loc3_.push("\t\tfgui.UIObjectFactory.setExtension(" + classInfo.encodedClassName + ".URL, " + classInfo.encodedClassName + ");");
            _loc4_.push("import " + classInfo.encodedClassName + " from \"./" + classInfo.encodedClassName + "\";");
            _loc1_["className"] = classInfo.encodedClassName;
            _loc1_["componentName"] = translateClassName(!!classInfo.customSuperClassName?classInfo.customSuperClassName:classInfo.superClassName);
            _loc1_["uiPath"] = "ui://" + publishData.pkg.id + classInfo.classId;
            _loc1_["uiResName"] = classInfo.className;
            _loc1_["createInstance"] = "\t\treturn <" + classInfo.encodedClassName + ">(fgui.UIPackage.createObject(\"" + publishData.pkg.name + "\",\"" + classInfo.className + "\"));";
            _loc1_["includeFiles"] = _loc8_.join("\n");
            _loc1_["variable"] = _loc7_.join("\n");
            _loc1_["content"] = _loc6_.join("\n");
            UtilsFile.saveString(new File(thisPackageFolder.nativePath + File.separator + classInfo.encodedClassName + ".ts"),FILE_MARK + "\n\n" + generate(_loc2_,_loc1_));
         }
         _loc5_ = thisPackageName + "Binder";
         _loc1_["className"] = _loc5_;
         _loc1_["bindContent"] = _loc3_.join("\n");
         _loc1_["includeFiles"] = _loc4_.join("\n");
         UtilsFile.saveString(new File(thisPackageFolder.nativePath + File.separator + _loc5_ + ".ts"),FILE_MARK + "\n\n" + generate(loadTemplate("CocosCreator","Binder"),_loc1_));
         _stepCallback.callOnSuccess();
      }
   }
}
