package fairygui.editor.publish.gencode
{
   import fairygui.editor.utils.UtilsFile;
   import flash.filesystem.File;
   
   public class GenCSharp extends GenerateCodeBase
   {
       
      
      public function GenCSharp()
      {
         super();
      }
      
      override public function run() : void
      {
         init("cs");
         loadTemplate("CSharp");
      }
      
      override protected function createFile(param1:*) : void
      {
         var _loc9_:* = null;
         var _loc10_:String = null;
         var _loc2_:Array = null;
         var _loc4_:Array = null;
         var _loc8_:String = null;
         var _loc7_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:Object = null;
         var _loc11_:Array = [];
         var _loc15_:int = 0;
         var _loc14_:* = sortedClasses;
         for each(classInfo in sortedClasses)
         {
            _loc2_ = [];
            _loc4_ = [];
            _loc8_ = param1["Component"];
            _loc8_ = _loc8_.replace("{packageName}",thisPackagePath);
            _loc8_ = _loc8_.split("{className}").join(classInfo.encodedClassName);
            _loc8_ = _loc8_.replace("{componentName}",!!classInfo.customSuperClassName?classInfo.customSuperClassName:classInfo.superClassName);
            _loc8_ = _loc8_.replace("{uiPath}","ui://" + publishData.targetUIPackage.id + classInfo.classId);
            _loc8_ = _loc8_.replace("{createInstance}","\t\t\treturn (" + classInfo.encodedClassName + ")UIPackage.CreateObject(\"" + publishData.targetUIPackage.name + "\",\"" + classInfo.className + "\");");
            _loc8_ = _loc8_.split("{uiPkgName}").join(publishData.targetUIPackage.name);
            _loc8_ = _loc8_.split("{uiResName}").join(classInfo.className);
            _loc7_ = 0;
            _loc6_ = 0;
            _loc3_ = 0;
            var _loc13_:int = 0;
            var _loc12_:* = classInfo.members;
            for each(_loc5_ in classInfo.members)
            {
               if(_loc5_.type == "Controller")
               {
                  if(!_loc5_.ignored)
                  {
                     if(settings.getMemberByName)
                     {
                        _loc2_.push("\t\t\t" + _loc5_.name + " = this.GetController(\"" + _loc5_.originalName + "\");");
                     }
                     else
                     {
                        _loc2_.push("\t\t\t" + _loc5_.name + " = this.GetControllerAt(" + _loc6_ + ");");
                     }
                  }
                  _loc6_++;
               }
               else if(_loc5_.type == "Transition")
               {
                  if(!_loc5_.ignored)
                  {
                     if(settings.getMemberByName)
                     {
                        _loc2_.push("\t\t\t" + _loc5_.name + " = this.GetTransition(\"" + _loc5_.originalName + "\");");
                     }
                     else
                     {
                        _loc2_.push("\t\t\t" + _loc5_.name + " = this.GetTransitionAt(" + _loc3_ + ");");
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
                        _loc2_.push("\t\t\t" + _loc5_.name + " = (" + _loc5_.type + ")this.GetChild(\"" + _loc5_.originalName + "\");");
                     }
                     else
                     {
                        _loc2_.push("\t\t\t" + _loc5_.name + " = (" + _loc5_.type + ")this.GetChildAt(" + _loc7_ + ");");
                     }
                  }
                  _loc7_++;
               }
               if(!_loc5_.ignored)
               {
                  _loc4_.push("\t\tpublic " + _loc5_.type + " " + _loc5_.name + ";");
               }
            }
            _loc8_ = _loc8_.replace("{variable}",_loc4_.join("\r\n"));
            _loc8_ = _loc8_.replace("{content}",_loc2_.join("\r\n"));
            _loc11_.push("\t\t\tUIObjectFactory.SetPackageItemExtension(" + classInfo.encodedClassName + ".URL, typeof(" + classInfo.encodedClassName + "));");
            UtilsFile.saveString(new File(thisPackageFolder.nativePath + File.separator + classInfo.encodedClassName + ".cs"),"/** This is an automatically generated class by FairyGUI. Please do not modify it. **/\n\n" + _loc8_);
         }
         _loc9_ = thisPackageName + "Binder";
         _loc10_ = param1["Binder"];
         _loc10_ = _loc10_.replace("{packageName}",thisPackagePath);
         _loc10_ = _loc10_.split("{className}").join(_loc9_);
         _loc10_ = _loc10_.replace("{bindContent}",_loc11_.join("\r\n"));
         UtilsFile.saveString(new File(thisPackageFolder.nativePath + File.separator + _loc9_ + ".cs"),"/** This is an automatically generated class by FairyGUI. Please do not modify it. **/\n\n" + _loc10_);
         stepCallback.callOnSuccess();
      }
   }
}
