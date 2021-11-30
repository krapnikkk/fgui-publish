package fairygui.editor.publish.exporter
{
   import fairygui.editor.publish.§_-4n§;
   import fairygui.editor.publish.taskRun;
   import fairygui.editor.settings.GlobalPublishSettings;
   import fairygui.utils.UtilsFile;
   import fairygui.utils.UtilsStr;
   import flash.filesystem.File;
   import flash.utils.ByteArray;
   import riaidea.utils.zip.ZipArchive;
   import riaidea.utils.zip.ZipConstants;
   
   public class ExporterBase extends taskRun
   {
       
      
      public function ExporterBase()
      {
         super();
      }
      
      protected function exportZipDesc(param1:File) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = undefined;
         var _loc5_:String = null;
         var _loc6_:ZipArchive = null;
         var _loc2_:Array = [];
         for(_loc3_ in publishData.outputDesc)
         {
            _loc2_.push(_loc3_);
         }
         _loc2_.sort();
         _loc6_ = new ZipArchive();
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = publishData.outputDesc[_loc3_];
            if(_loc4_ is XML)
            {
               _loc5_ = (_loc4_ as XML).toXMLString();
            }
            else
            {
               _loc5_ = String(_loc4_);
            }
            _loc6_.addFileFromString(_loc3_,_loc5_);
         }
         UtilsFile.saveBytes(param1,_loc6_.output(ZipConstants.STORED));
      }
      
      protected function exportPlainTextDesc(param1:File) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = undefined;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:ByteArray = null;
         var _loc2_:Array = [];
         for(_loc3_ in publishData.outputDesc)
         {
            _loc2_.push(_loc3_);
         }
         _loc2_.sort();
         _loc6_ = [];
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = publishData.outputDesc[_loc3_];
            if(_loc4_ is XML)
            {
               _loc5_ = (_loc4_ as XML).toXMLString();
            }
            else
            {
               _loc5_ = String(_loc4_);
            }
            _loc6_.push(_loc3_);
            _loc6_.push("|");
            _loc6_.push("" + _loc5_.length);
            _loc6_.push("|");
            _loc6_.push(_loc5_);
         }
         _loc7_ = new ByteArray();
         _loc7_.writeUTFBytes(_loc6_.join(""));
         UtilsFile.saveBytes(param1,_loc7_);
      }
      
      protected function exportBinaryDesc(param1:File, param2:Boolean = false) : void
      {
         var _loc3_:§_-4n§ = new §_-4n§();
         var _loc4_:ByteArray = _loc3_.encode(publishData,param2);
         UtilsFile.saveBytes(param1,_loc4_);
      }
      
      protected function exportResFiles(param1:String) : void
      {
         var _loc2_:* = null;
         var _loc3_:File = null;
         var _loc4_:ByteArray = null;
         for(_loc2_ in publishData.outputRes)
         {
            _loc3_ = new File(param1 + _loc2_);
            _loc4_ = publishData.outputRes[_loc2_];
            UtilsFile.saveBytes(_loc3_,_loc4_);
         }
      }
      
      protected function exportSpritsAndHiTest(param1:String) : void
      {
         var _loc2_:File = new File(param1 + "sprites.bytes");
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeUTFBytes(publishData.sprites);
         UtilsFile.saveBytes(_loc2_,_loc3_);
         if(publishData.hitTestData.length > 0)
         {
            _loc2_ = new File(param1 + "hittest.bytes");
            UtilsFile.saveBytes(_loc2_,publishData.hitTestData);
         }
      }
      
      protected function clearOldResFiles(param1:File) : void
      {
         var file:File = null;
         var nn:String = null;
         var part:String = null;
         var ext:String = null;
         var isRes:Boolean = false;
         var folder:File = param1;
         var gsettings:GlobalPublishSettings = GlobalPublishSettings(publishData.project.getSettings("publish"));
         var files:Array = folder.getDirectoryListing();
         var connector:String = !!gsettings.binaryFormat?"_":"@";
         var checkStr:String = publishData.fileName + connector;
         var i:int = 0;
         while(i < files.length)
         {
            file = files[i];
            if(UtilsStr.startsWith(file.name,checkStr))
            {
               if(file.extension != "meta")
               {
                  nn = file.name;
                  part = nn.substring(checkStr.length);
                  if(!(part == "fui.bytes" || part == "sprites.bytes" || part == "hittest.bytes"))
                  {
                     ext = UtilsStr.getFileExt(nn);
                     isRes = UtilsStr.startsWith(part,"atlas") && (ext == "png" || ext == "jpg") || ext == "mp3" || ext == "ogg" || ext == "wav";
                     if(isRes)
                     {
                        if(!publishData.outputRes[part])
                        {
                           try
                           {
                              file.deleteFile();
                              file = new File(file.nativePath + ".meta");
                              if(file.exists)
                              {
                                 file.deleteFile();
                              }
                           }
                           catch(err:Error)
                           {
                              _stepCallback.msgs.length = 0;
                              publishData.project.editor.consoleView.logError(null,err);
                              _stepCallback.addMsg("Unable to delete file \'" + nn + "\'");
                              _stepCallback.callOnFailImmediately();
                              return;
                           }
                        }
                     }
                  }
               }
            }
            i++;
         }
      }
   }
}
