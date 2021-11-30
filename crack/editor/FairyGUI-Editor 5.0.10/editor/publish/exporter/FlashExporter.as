package fairygui.editor.publish.exporter
{
   import fairygui.utils.UtilsFile;
   import flash.filesystem.File;
   import flash.utils.ByteArray;
   import riaidea.utils.zip.ZipArchive;
   import riaidea.utils.zip.ZipConstants;
   
   public class FlashExporter extends ExporterBase
   {
       
      
      public function FlashExporter()
      {
         super();
      }
      
      override public function run() : void
      {
         var resFile:File = null;
         var fn:String = null;
         var descData:* = undefined;
         var str:String = null;
         var zipRes:ZipArchive = null;
         var ba:ByteArray = null;
         var descFile:File = new File(publishData.path + "/" + publishData.fileName + "." + publishData.fileExtension);
         resFile = new File(publishData.path + "/" + publishData.fileName + "@res." + publishData.fileExtension);
         var zip:ZipArchive = new ZipArchive();
         var toSort:Array = [];
         for(fn in publishData.outputDesc)
         {
            toSort.push(fn);
         }
         toSort.sort();
         for each(fn in toSort)
         {
            descData = publishData.outputDesc[fn];
            if(descData is XML)
            {
               str = (descData as XML).toXMLString();
            }
            else
            {
               str = String(descData);
            }
            zip.addFileFromString(fn,str);
         }
         if(!publishData.exportDescOnly)
         {
            if(publishData.singlePackage)
            {
               zipRes = zip;
            }
            else
            {
               zipRes = new ZipArchive();
            }
            toSort.length = 0;
            for(fn in publishData.outputRes)
            {
               toSort.push(fn);
            }
            toSort.sort();
            for each(fn in toSort)
            {
               zipRes.addFileFromBytes(fn,publishData.outputRes[fn]);
            }
            if(publishData.sprites != null)
            {
               zipRes.addFileFromString("sprites.bytes",publishData.sprites);
            }
            if(publishData.hitTestData.length > 0)
            {
               zipRes.addFileFromBytes("hittest.bytes",publishData.hitTestData);
            }
            if(!publishData.singlePackage)
            {
               ba = zipRes.output(ZipConstants.STORED);
               if(ba)
               {
                  UtilsFile.saveBytes(resFile,ba);
               }
               else
               {
                  ba = new ByteArray();
                  UtilsFile.saveBytes(resFile,ba);
               }
            }
            else
            {
               try
               {
                  if(resFile.exists)
                  {
                     resFile.deleteFile();
                  }
               }
               catch(err:Error)
               {
                  _stepCallback.msgs.length = 0;
                  publishData.project.editor.consoleView.logError(null,err);
                  _stepCallback.addMsg("Unable to delete file \'" + resFile.name + "\'");
                  _stepCallback.callOnFail();
                  return;
               }
            }
         }
         UtilsFile.saveBytes(descFile,zip.output(ZipConstants.DEFLATED));
         _stepCallback.callOnSuccess();
      }
   }
}
