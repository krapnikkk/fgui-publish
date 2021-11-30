package fairygui.editor.publish.exporter
{
   import fairygui.editor.settings.GlobalPublishSettings;
   import flash.filesystem.File;
   
   public class GeneralExporter extends ExporterBase
   {
       
      
      public function GeneralExporter()
      {
         super();
      }
      
      override public function run() : void
      {
         var _loc3_:String = null;
         var _loc1_:GlobalPublishSettings = GlobalPublishSettings(publishData.project.getSettings("publish"));
         var _loc2_:File = new File(publishData.path + "/" + publishData.fileName + "." + publishData.fileExtension);
         if(_loc1_.binaryFormat)
         {
            exportBinaryDesc(_loc2_);
         }
         else
         {
            exportZipDesc(_loc2_);
         }
         if(!publishData.exportDescOnly)
         {
            clearOldResFiles(_loc2_.parent);
            _loc3_ = publishData.path + "/" + publishData.fileName + (!!_loc1_.binaryFormat?"_":"@");
            exportResFiles(_loc3_);
            if(!_loc1_.binaryFormat)
            {
               exportSpritsAndHiTest(_loc3_);
            }
         }
         _stepCallback.callOnSuccess();
      }
   }
}
