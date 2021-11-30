package fairygui.editor.publish.gencode
{
   import fairygui.editor.publish.PublishStep;
   import fairygui.editor.settings.GlobalPublishSettings;
   import fairygui.editor.utils.PinYinUtil;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   import flash.filesystem.File;
   
   public class GenerateCodeBase extends PublishStep
   {
       
      
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
      
      protected function init(param1:String) : void
      {
         var _loc3_:String = null;
         var _loc7_:File = null;
         var _loc6_:Array = null;
         var _loc2_:File = null;
         var _loc5_:String = null;
         var _loc4_:* = param1;
         this.settings = publishData._project.settingsCenter.publish;
         try
         {
            _loc3_ = this.settings.codePath;
            _loc3_ = UtilsStr.formatStringByName(_loc3_,publishData._project.customProperties);
            _loc7_ = new File(publishData.project.basePath).resolvePath(_loc3_);
            if(!_loc7_.exists)
            {
               _loc7_.createDirectory();
            }
            else if(!_loc7_.isDirectory)
            {
               stepCallback.addMsg("Invalid code path!");
               stepCallback.callOnFail();
               return;
            }
         }
         catch(err:Error)
         {
            stepCallback.addMsg("Invalid code path!");
            stepCallback.callOnFail();
            return;
         }
         this.thisPackageName = PinYinUtil.toPinyin(publishData.targetUIPackage.name,false,false,false);
         this.thisPackageFolder = new File(_loc7_.nativePath + File.separator + this.thisPackageName);
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
            _loc6_ = this.thisPackageFolder.getDirectoryListing();
            var _loc11_:int = 0;
            var _loc10_:* = _loc6_;
            for each(_loc2_ in _loc6_)
            {
               if(!(_loc2_.isDirectory || _loc2_.extension != _loc4_))
               {
                  _loc5_ = UtilsFile.loadString(_loc2_);
                  if(UtilsStr.startsWith(_loc5_,"/** This is an automatically generated class by FairyGUI. Please do not modify it. **/"))
                  {
                     UtilsFile.deleteFile(_loc2_);
                  }
               }
            }
         }
         else
         {
            this.thisPackageFolder.createDirectory();
         }
         GenCodeUtils.prepare(publishData);
         var _loc13_:int = 0;
         var _loc12_:* = publishData.outputClasses;
         for each(this.classInfo in publishData.outputClasses)
         {
            if(!this.classInfo.ignored)
            {
               this.sortedClasses.push(this.classInfo);
            }
         }
         this.sortedClasses.sortOn("classId");
      }
      
      protected function loadTemplate(param1:String) : void
      {
         var _loc2_:Object = null;
         var _loc3_:File = new File(publishData.project.basePath + "/template/" + param1);
         if(_loc3_.exists)
         {
            _loc2_ = this.loadTemplate2(_loc3_);
            if(_loc2_["Binder"] && _loc2_["Component"])
            {
               this.createFile(_loc2_);
               return;
            }
         }
         _loc3_ = File.applicationDirectory.resolvePath("template/" + param1);
         _loc2_ = this.loadTemplate2(_loc3_);
         this.createFile(_loc2_);
      }
      
      private function loadTemplate2(param1:File) : Object
      {
         var _loc4_:File = null;
         var _loc2_:String = null;
         var _loc5_:Array = param1.getDirectoryListing();
         var _loc3_:Object = {};
         var _loc7_:int = 0;
         var _loc6_:* = _loc5_;
         for each(_loc4_ in _loc5_)
         {
            if(_loc4_.extension == "template")
            {
               _loc2_ = _loc4_.name.replace(".template","");
               _loc3_[_loc2_] = UtilsFile.loadString(_loc4_);
            }
         }
         return _loc3_;
      }
      
      protected function createFile(param1:*) : void
      {
         throw new Error("子类需实例化此方法GenerateCodeBase:createFile");
      }
   }
}
