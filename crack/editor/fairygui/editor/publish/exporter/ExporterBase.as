package fairygui.editor.publish.exporter
{
   import fairygui.editor.Consts;
   import fairygui.editor.publish.BinaryEncoder;
   import fairygui.editor.publish.PublishStep;
   import fairygui.editor.settings.GlobalPublishSettings;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.editor.utils.zip.ZipArchive;
   import flash.filesystem.File;
   import flash.utils.ByteArray;
   
   public class ExporterBase extends PublishStep
   {
       
      
      public function ExporterBase()
      {
         super();
      }
      
      protected function exportZipDesc(param1:File) : void
      {
         var _loc4_:* = null;
         var _loc5_:* = undefined;
         var _loc2_:String = null;
         var _loc3_:ZipArchive = null;
         var _loc6_:Array = [];
         var _loc8_:int = 0;
         var _loc7_:* = publishData.outputDesc;
         for(_loc4_ in publishData.outputDesc)
         {
            _loc6_.push(_loc4_);
         }
         _loc6_.sort();
         _loc3_ = new ZipArchive();
         var _loc10_:int = 0;
         var _loc9_:* = _loc6_;
         for each(_loc4_ in _loc6_)
         {
            _loc5_ = publishData.outputDesc[_loc4_];
            if(_loc5_ is XML)
            {
               _loc2_ = (_loc5_ as XML).toXMLString();
            }
            else
            {
               _loc2_ = String(_loc5_);
            }
            _loc3_.addFileFromString(_loc4_,_loc2_);
         }
         UtilsFile.saveBytes(param1,_loc3_.output(0));
      }
      
      protected function exportPlainTextDesc(param1:File) : void
      {
         var _loc5_:* = null;
         var _loc6_:* = undefined;
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:ByteArray = null;
         var _loc7_:Array = [];
         var _loc9_:int = 0;
         var _loc8_:* = publishData.outputDesc;
         for(_loc5_ in publishData.outputDesc)
         {
            _loc7_.push(_loc5_);
         }
         _loc7_.sort();
         _loc3_ = [];
         var _loc11_:int = 0;
         var _loc10_:* = _loc7_;
         for each(_loc5_ in _loc7_)
         {
            _loc6_ = publishData.outputDesc[_loc5_];
            if(_loc6_ is XML)
            {
               _loc2_ = (_loc6_ as XML).toXMLString();
            }
            else
            {
               _loc2_ = String(_loc6_);
            }
            _loc3_.push(_loc5_);
            _loc3_.push("|");
            _loc3_.push("" + _loc2_.length);
            _loc3_.push("|");
            _loc3_.push(_loc2_);
         }
         _loc4_ = new ByteArray();
         _loc4_.writeUTFBytes(_loc3_.join(""));
         UtilsFile.saveBytes(param1,_loc4_);
      }
      
      protected function exportBinaryDesc(param1:File, param2:Boolean = false) : void
      {
         var _loc3_:BinaryEncoder = new BinaryEncoder();
         var _loc4_:ByteArray = _loc3_.encode(publishData,param2);
         UtilsFile.saveBytes(param1,_loc4_);
      }
      
      protected function exportResFiles(param1:String) : void
      {
         var _loc4_:* = null;
         var _loc2_:File = null;
         var _loc3_:ByteArray = null;
         var _loc6_:int = 0;
         var _loc5_:* = publishData.outputRes;
         for(_loc4_ in publishData.outputRes)
         {
            _loc2_ = new File(param1 + _loc4_);
            _loc3_ = publishData.outputRes[_loc4_];
            UtilsFile.saveBytes(_loc2_,_loc3_);
         }
      }
      
      protected function exportSpritsAndHiTest(param1:String) : void
      {
         var _loc3_:File = new File(param1 + "sprites.bytes");
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(publishData.sprites);
         UtilsFile.saveBytes(_loc3_,_loc2_);
         if(publishData.hitTestData.length > 0)
         {
            _loc3_ = new File(param1 + "hittest.bytes");
            UtilsFile.saveBytes(_loc3_,publishData.hitTestData);
         }
      }
      
      protected function clearOldResFiles(param1:File) : void
      {
         var _loc4_:File = null;
         var _loc6_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc8_:Boolean = false;
         var _loc2_:* = param1;
         var _loc5_:GlobalPublishSettings = publishData._project.settingsCenter.publish;
         var _loc3_:Array = _loc2_.getDirectoryListing();
         var _loc7_:String = !!_loc5_.binaryFormat?"_":"@";
         var _loc12_:String = publishData.fileName + _loc7_;
         var _loc11_:int = 0;
         while(_loc11_ < _loc3_.length)
         {
            _loc4_ = _loc3_[_loc11_];
            if(UtilsStr.startsWith(_loc4_.name,_loc12_))
            {
               if(_loc4_.extension != "meta")
               {
                  _loc6_ = _loc4_.name;
                  _loc9_ = _loc6_.substring(_loc12_.length);
                  if(!(_loc9_ == "fui.bytes" || _loc9_ == "sprites.bytes" || _loc9_ == "hittest.bytes"))
                  {
                     _loc10_ = UtilsStr.getFileExt(_loc6_);
                     _loc8_ = UtilsStr.startsWith(_loc9_,"atlas") && (_loc10_ == "png" || _loc10_ == "jpg") || Consts.supportedSoundFormats.indexOf(_loc10_) != -1;
                     if(_loc8_)
                     {
                        if(!publishData.outputRes[_loc9_])
                        {
                           try
                           {
                              _loc4_.deleteFile();
                              _loc4_ = new File(_loc4_.nativePath + ".meta");
                              if(_loc4_.exists)
                              {
                                 _loc4_.deleteFile();
                              }
                           }
                           catch(err:Error)
                           {
                              stepCallback.msgs.length = 0;
                              stepCallback.addMsg("Unable to delete file \'" + _loc6_ + "\'");
                              stepCallback.callOnFailImmediately();
                              return;
                           }
                        }
                     }
                  }
               }
            }
            _loc11_++;
         }
      }
   }
}
