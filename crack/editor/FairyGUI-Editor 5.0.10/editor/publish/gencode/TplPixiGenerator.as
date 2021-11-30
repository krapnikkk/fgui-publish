package fairygui.editor.publish.gencode
{
   import fairygui.utils.UtilsFile;
   import flash.filesystem.File;
   
   public class TplPixiGenerator extends GenerateCodeBase
   {
       
      
      public function TplPixiGenerator()
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
         var _loc11_:String = null;
         init(["ts"]);
         var _loc1_:Object = {};
         _loc1_["packageName"] = thisPackagePath;
         _loc1_["thisPackageName"] = thisPackageName;
         _loc1_["uiPkgName"] = publishData.pkg.name;
         var _loc2_:String = loadTemplate("Pixi","Component");
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
               _loc11_ = translateClassName(_loc10_.type);
               if(_loc10_.type == "Controller")
               {
                  if(!_loc10_.ignored)
                  {
                     if(settings.getMemberByName)
                     {
                        _loc5_.push("\t\t\tthis." + _loc10_.name + " = this.getController(\"" + _loc10_.originalName + "\");");
                     }
                     else
                     {
                        _loc5_.push("\t\t\tthis." + _loc10_.name + " = this.getControllerAt(" + _loc8_ + ");");
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
                        _loc5_.push("\t\t\tthis." + _loc10_.name + " = this.getTransition(\"" + _loc10_.originalName + "\");");
                     }
                     else
                     {
                        _loc5_.push("\t\t\tthis." + _loc10_.name + " = this.getTransitionAt(" + _loc9_ + ");");
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
                        _loc5_.push("\t\t\tthis." + _loc10_.name + " = this.getChild(\"" + _loc10_.originalName + "\") as " + _loc11_ + ";");
                     }
                     else
                     {
                        _loc5_.push("\t\t\tthis." + _loc10_.name + " = this.getChildAt(" + _loc7_ + ") as " + _loc11_ + ";");
                     }
                  }
                  _loc7_++;
               }
               if(!_loc10_.ignored)
               {
                  _loc6_.push("\t\tpublic " + _loc10_.name + ":" + _loc11_ + ";");
               }
            }
            _loc3_.push("\t\t\tfgui.UIObjectFactory.setPackageItemExtension(" + classInfo.encodedClassName + ".URL, " + classInfo.encodedClassName + ");");
            _loc1_["className"] = classInfo.encodedClassName;
            _loc1_["componentName"] = translateClassName(!!classInfo.customSuperClassName?classInfo.customSuperClassName:classInfo.superClassName);
            _loc1_["uiPath"] = "ui://" + publishData.pkg.id + classInfo.classId;
            _loc1_["uiResName"] = classInfo.className;
            _loc1_["createInstance"] = "\t\t\treturn fgui.UIPackage.createObject(\"" + publishData.pkg.name + "\", \"" + classInfo.className + "\") as " + classInfo.encodedClassName + ";";
            _loc1_["variable"] = _loc6_.join("\n");
            _loc1_["content"] = _loc5_.join("\n");
            UtilsFile.saveString(new File(thisPackageFolder.nativePath + File.separator + classInfo.encodedClassName + ".ts"),FILE_MARK + "\n\n" + generate(_loc2_,_loc1_));
         }
         _loc4_ = thisPackageName + "Binder";
         _loc1_["className"] = _loc4_;
         _loc1_["bindContent"] = _loc3_.join("\n");
         UtilsFile.saveString(new File(thisPackageFolder.nativePath + File.separator + _loc4_ + ".ts"),FILE_MARK + "\n\n" + generate(loadTemplate("Pixi","Binder"),_loc1_));
         _stepCallback.callOnSuccess();
      }
   }
}
