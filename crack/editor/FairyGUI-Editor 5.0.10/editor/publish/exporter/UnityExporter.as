package fairygui.editor.publish.exporter
{
   import fairygui.editor.settings.GlobalPublishSettings;
   import fairygui.utils.UtilsFile;
   import flash.filesystem.File;
   import flash.utils.ByteArray;
   
   public class UnityExporter extends ExporterBase
   {
       
      
      public function UnityExporter()
      {
         super();
      }
      
      override public function run() : void
      {
         var _loc2_:File = null;
         var _loc3_:String = null;
         var _loc4_:* = null;
         var _loc5_:File = null;
         var _loc6_:ByteArray = null;
         var _loc1_:GlobalPublishSettings = GlobalPublishSettings(publishData.project.getSettings("publish"));
         if(!_loc1_.binaryFormat)
         {
            _loc2_ = new File(publishData.path + "/" + publishData.fileName + "." + publishData.fileExtension);
         }
         else
         {
            _loc2_ = new File(publishData.path + "/" + publishData.fileName + "_fui." + publishData.fileExtension);
         }
         if(_loc1_.binaryFormat)
         {
            exportBinaryDesc(_loc2_);
         }
         else
         {
            exportPlainTextDesc(_loc2_);
         }
         if(!publishData.exportDescOnly)
         {
            clearOldResFiles(_loc2_.parent);
            _loc3_ = publishData.path + "/" + publishData.fileName + (!!_loc1_.binaryFormat?"_":"@");
            for(_loc4_ in publishData.outputRes)
            {
               _loc5_ = new File(_loc3_ + _loc4_);
               _loc6_ = publishData.outputRes[_loc4_];
               UtilsFile.saveBytes(_loc5_,_loc6_);
            }
            if(!_loc1_.binaryFormat)
            {
               exportSpritsAndHiTest(_loc3_);
            }
         }
         _stepCallback.callOnSuccess();
      }
   }
}
