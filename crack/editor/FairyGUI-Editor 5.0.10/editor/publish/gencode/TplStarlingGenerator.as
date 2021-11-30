package fairygui.editor.publish.gencode
{
   import fairygui.utils.UtilsFile;
   import flash.filesystem.File;
   
   public class TplStarlingGenerator extends GenerateCodeBase
   {
       
      
      public function TplStarlingGenerator()
      {
         super();
      }
      
      override public function run() : void
      {
         var _loc4_:* = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Object = null;
         init(["as"]);
         var _loc1_:Object = {};
         _loc1_["packageName"] = thisPackagePath;
         _loc1_["thisPackageName"] = thisPackageName;
         _loc1_["uiPkgName"] = publishData.pkg.name;
         var _loc2_:String = loadTemplate("Starling","Component");
         var _loc3_:Array = [];
         for each(classInfo in sortedClasses)
         {
            _loc5_ = [];
            _loc6_ = [];
            _loc7_ = 0;
            _loc8_ = 0;
            _loc9_ = 0;
            for each(_loc10_ in classInfo.members)
            {
               if(_loc10_.type == "Controller")
               {
                  if(!_loc10_.ignored)
                  {
                     if(settings.getMemberByName)
                     {
                        _loc5_.push("\t\t\t" + _loc10_.name + " = this.getController(\"" + _loc10_.originalName + "\");");
                     }
                     else
                     {
                        _loc5_.push("\t\t\t" + _loc10_.name + " = this.getControllerAt(" + _loc8_ + ");");
                     }
                  }
                  _loc8_++;
               }
               else if(_loc10_.type == "Transition")
               {
                  if(!_loc10_.ignored)
                  {
                     if(settings.getMemberByName)
                     {
                        _loc5_.push("\t\t\t" + _loc10_.name + " = this.getTransition(\"" + _loc10_.originalName + "\");");
                     }
                     else
                     {
                        _loc5_.push("\t\t\t" + _loc10_.name + " = this.getTransitionAt(" + _loc9_ + ");");
                     }
                  }
                  _loc9_++;
               }
               else
               {
                  if(!_loc10_.ignored)
                  {
                     if(settings.getMemberByName)
                     {
                        _loc5_.push("\t\t\t" + _loc10_.name + " = " + _loc10_.type + "(this.getChild(\"" + _loc10_.originalName + "\"));");
                     }
                     else
                     {
                        _loc5_.push("\t\t\t" + _loc10_.name + " = " + _loc10_.type + "(this.getChildAt(" + _loc7_ + "));");
                     }
                  }
                  _loc7_++;
               }
               if(!_loc10_.ignored)
               {
                  _loc6_.push("\t\tpublic var " + _loc10_.name + ":" + _loc10_.type + ";");
               }
            }
            _loc3_.push("\t\t\tUIObjectFactory.setPackageItemExtension(" + classInfo.encodedClassName + ".URL, " + classInfo.encodedClassName + ");");
            _loc1_["className"] = classInfo.encodedClassName;
            _loc1_["componentName"] = translateClassName(!!classInfo.customSuperClassName?classInfo.customSuperClassName:classInfo.superClassName);
            _loc1_["uiPath"] = "ui://" + publishData.pkg.id + classInfo.classId;
            _loc1_["uiResName"] = classInfo.className;
            _loc1_["createInstance"] = "\t\t\treturn " + classInfo.encodedClassName + "(UIPackage.createObject(\"" + publishData.pkg.name + "\",\"" + classInfo.className + "\"));";
            _loc1_["variable"] = _loc6_.join("\n");
            _loc1_["content"] = _loc5_.join("\n");
            UtilsFile.saveString(new File(thisPackageFolder.nativePath + File.separator + classInfo.encodedClassName + ".as"),FILE_MARK + "\n\n" + generate(_loc2_,_loc1_));
         }
         _loc4_ = thisPackageName + "Binder";
         _loc1_["className"] = _loc4_;
         _loc1_["bindContent"] = _loc3_.join("\n");
         UtilsFile.saveString(new File(thisPackageFolder.nativePath + File.separator + _loc4_ + ".as"),FILE_MARK + "\n\n" + generate(loadTemplate("Starling","Binder"),_loc1_));
         _stepCallback.callOnSuccess();
      }
   }
}
