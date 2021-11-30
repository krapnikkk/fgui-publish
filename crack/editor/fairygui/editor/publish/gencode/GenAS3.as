package fairygui.editor.publish.gencode
{
   import fairygui.editor.utils.UtilsFile;
   import flash.filesystem.File;
   
   public class GenAS3 extends GenerateCodeBase
   {
       
      
      public function GenAS3()
      {
         super();
      }
      
      override public function run() : void
      {
         init("as");
         loadTemplate("AS3");
      }
      
      override protected function createFile(param1:*) : void
      {
         var _loc10_:Array = null;
         var _loc11_:* = null;
         var _loc2_:String = null;
         var _loc5_:Array = null;
         var _loc9_:Array = null;
         var _loc8_:String = null;
         var _loc7_:int = 0;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:Object = null;
         var _loc12_:String = publishData.project.type == "Layabox"?"Object":"XML";
         _loc10_ = [];
         var _loc16_:int = 0;
         var _loc15_:* = sortedClasses;
         for each(classInfo in sortedClasses)
         {
            _loc5_ = [];
            _loc9_ = [];
            _loc8_ = param1["Component"];
            _loc8_ = _loc8_.replace("{packageName}",thisPackagePath);
            _loc8_ = _loc8_.split("{className}").join(classInfo.encodedClassName);
            _loc8_ = _loc8_.replace("{componentName}",!!classInfo.customSuperClassName?classInfo.customSuperClassName:classInfo.superClassName);
            _loc8_ = _loc8_.replace("{uiPath}","ui://" + publishData.targetUIPackage.id + classInfo.classId);
            _loc8_ = _loc8_.replace("{createInstance}","\t\t\treturn " + classInfo.encodedClassName + "(UIPackage.createObject(\"" + publishData.targetUIPackage.name + "\",\"" + classInfo.className + "\"));");
            _loc8_ = _loc8_.replace("{xmlType}",_loc12_);
            _loc8_ = _loc8_.split("{uiPkgName}").join(publishData.targetUIPackage.name);
            _loc8_ = _loc8_.split("{uiResName}").join(classInfo.className);
            _loc7_ = 0;
            _loc4_ = 0;
            _loc6_ = 0;
            var _loc14_:int = 0;
            var _loc13_:* = classInfo.members;
            for each(_loc3_ in classInfo.members)
            {
               if(_loc3_.type == "Controller")
               {
                  if(!_loc3_.ignored)
                  {
                     if(settings.getMemberByName)
                     {
                        _loc5_.push("\t\t\t" + _loc3_.name + " = this.getController(\"" + _loc3_.originalName + "\");");
                     }
                     else
                     {
                        _loc5_.push("\t\t\t" + _loc3_.name + " = this.getControllerAt(" + _loc4_ + ");");
                     }
                  }
                  _loc4_++;
               }
               else if(_loc3_.type == "Transition")
               {
                  if(!_loc3_.ignored)
                  {
                     if(settings.getMemberByName)
                     {
                        _loc5_.push("\t\t\t" + _loc3_.name + " = this.getTransition(\"" + _loc3_.originalName + "\");");
                     }
                     else
                     {
                        _loc5_.push("\t\t\t" + _loc3_.name + " = this.getTransitionAt(" + _loc6_ + ");");
                     }
                  }
                  _loc6_++;
               }
               else
               {
                  if(!_loc3_.ignored)
                  {
                     if(settings.getMemberByName)
                     {
                        _loc5_.push("\t\t\t" + _loc3_.name + " = " + _loc3_.type + "(this.getChild(\"" + _loc3_.originalName + "\"));");
                     }
                     else
                     {
                        _loc5_.push("\t\t\t" + _loc3_.name + " = " + _loc3_.type + "(this.getChildAt(" + _loc7_ + "));");
                     }
                  }
                  _loc7_++;
               }
               if(!_loc3_.ignored)
               {
                  _loc9_.push("\t\tpublic var " + _loc3_.name + ":" + _loc3_.type + ";");
               }
            }
            _loc8_ = _loc8_.replace("{variable}",_loc9_.join("\r\n"));
            _loc8_ = _loc8_.replace("{content}",_loc5_.join("\r\n"));
            _loc10_.push("\t\t\tfairygui.UIObjectFactory.setPackageItemExtension(" + classInfo.encodedClassName + ".URL, " + classInfo.encodedClassName + ");");
            UtilsFile.saveString(new File(thisPackageFolder.nativePath + File.separator + classInfo.encodedClassName + ".as"),"/** This is an automatically generated class by FairyGUI. Please do not modify it. **/\n\n" + _loc8_);
         }
         _loc11_ = thisPackageName + "Binder";
         _loc2_ = param1["Binder"];
         _loc2_ = _loc2_.replace("{packageName}",thisPackagePath);
         _loc2_ = _loc2_.split("{className}").join(_loc11_);
         _loc2_ = _loc2_.replace("{bindContent}",_loc10_.join("\r\n"));
         UtilsFile.saveString(new File(thisPackageFolder.nativePath + File.separator + _loc11_ + ".as"),"/** This is an automatically generated class by FairyGUI. Please do not modify it. **/\n\n" + _loc2_);
         stepCallback.callOnSuccess();
      }
   }
}
