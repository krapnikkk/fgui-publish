package fairygui.editor.publish.exporter
{
   import fairygui.editor.settings.GlobalPublishSettings;
   import fairygui.utils.UtilsFile;
   import flash.filesystem.File;
   import flash.utils.ByteArray;
   import mx.utils.Base64Encoder;
   import riaidea.utils.zip.ZipArchive;
   import riaidea.utils.zip.ZipConstants;
   
   public class LayaExporter extends ExporterBase
   {
       
      
      public function LayaExporter()
      {
         super();
      }
      
      override public function run() : void
      {
         var _loc3_:* = null;
         var _loc4_:String = null;
         var _loc5_:ByteArray = null;
         var _loc6_:Array = null;
         var _loc7_:* = undefined;
         var _loc8_:Array = null;
         var _loc9_:Base64Encoder = null;
         var _loc10_:ZipArchive = null;
         var _loc11_:String = null;
         var _loc1_:GlobalPublishSettings = GlobalPublishSettings(publishData.project.getSettings("publish"));
         var _loc2_:File = new File(publishData.path + "/" + publishData.fileName + "." + publishData.fileExtension);
         if(_loc1_.binaryFormat)
         {
            exportBinaryDesc(_loc2_,_loc1_.compressDesc);
         }
         else
         {
            _loc6_ = [];
            for(_loc3_ in publishData.outputDesc)
            {
               _loc6_.push(_loc3_);
            }
            _loc6_.sort();
            if(_loc1_.compressDesc)
            {
               _loc8_ = [];
               for each(_loc3_ in _loc6_)
               {
                  _loc7_ = publishData.outputDesc[_loc3_];
                  if(_loc7_ is XML)
                  {
                     _loc4_ = (_loc7_ as XML).toXMLString();
                  }
                  else
                  {
                     _loc4_ = String(_loc7_);
                  }
                  _loc8_.push(_loc3_);
                  _loc8_.push("|");
                  _loc8_.push("" + _loc4_.length);
                  _loc8_.push("|");
                  _loc8_.push(_loc4_);
               }
               _loc8_.push("sprites.bytes");
               _loc8_.push("|");
               _loc8_.push("" + publishData.sprites.length);
               _loc8_.push("|");
               _loc8_.push(publishData.sprites);
               if(publishData.hitTestData.length > 0)
               {
                  _loc9_ = new Base64Encoder();
                  _loc9_.encodeBytes(publishData.hitTestData);
                  _loc4_ = _loc9_.toString().replace(/[\r\n]/g,"");
                  _loc8_.push("hittest.bytes");
                  _loc8_.push("|");
                  _loc8_.push("" + _loc4_.length);
                  _loc8_.push("|");
                  _loc8_.push(_loc4_);
               }
               _loc5_ = new ByteArray();
               _loc5_.writeUTFBytes(_loc8_.join(""));
               _loc5_.deflate();
               UtilsFile.saveBytes(_loc2_,_loc5_);
            }
            else
            {
               _loc10_ = new ZipArchive();
               for each(_loc3_ in _loc6_)
               {
                  _loc7_ = publishData.outputDesc[_loc3_];
                  if(_loc7_ is XML)
                  {
                     _loc4_ = (_loc7_ as XML).toXMLString();
                  }
                  else
                  {
                     _loc4_ = String(_loc7_);
                  }
                  _loc10_.addFileFromString(_loc3_,_loc4_);
               }
               if(publishData.hitTestData.length > 0)
               {
                  _loc9_ = new Base64Encoder();
                  _loc9_.encodeBytes(publishData.hitTestData);
                  _loc4_ = _loc9_.toString().replace(/[\r\n]/g,"");
                  _loc10_.addFileFromString("hittest.bytes",_loc4_);
               }
               _loc10_.addFileFromString("sprites.bytes",publishData.sprites);
               UtilsFile.saveBytes(_loc2_,_loc10_.output(ZipConstants.STORED));
            }
         }
         if(!publishData.exportDescOnly)
         {
            clearOldResFiles(_loc2_.parent);
            _loc11_ = publishData.path + "/" + publishData.fileName + (!!_loc1_.binaryFormat?"_":"@");
            exportResFiles(_loc11_);
         }
         _stepCallback.callOnSuccess();
      }
   }
}
