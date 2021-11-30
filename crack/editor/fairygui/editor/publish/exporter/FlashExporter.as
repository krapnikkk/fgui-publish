package fairygui.editor.publish.exporter
{
   import fairygui.editor.publish.PublishStep;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.zip.ZipArchive;
   import flash.filesystem.File;
   import flash.utils.ByteArray;
   
   public class FlashExporter extends PublishStep
   {
       
      
      public function FlashExporter()
      {
         super();
      }
      
      override public function run() : void
      {
         var _loc5_:File = null;
         var _loc7_:* = null;
         var _loc4_:* = undefined;
         var _loc3_:String = null;
         var _loc6_:* = null;
         var _loc2_:ByteArray = null;
         var _loc9_:File = new File(publishData.filePath + "/" + publishData.fileName + "." + publishData.fileExtention);
         _loc5_ = new File(publishData.filePath + "/" + publishData.fileName + "@res." + publishData.fileExtention);
         var _loc1_:ZipArchive = new ZipArchive();
         var _loc8_:Array = [];
         var _loc11_:int = 0;
         for(_loc7_ in publishData.outputDesc)
         {
            _loc8_.push(_loc7_);
         }
         _loc8_.sort();
         var _loc13_:int = 0;
         var _loc12_:* = _loc8_;
         for each(_loc7_ in _loc8_)
         {
            _loc4_ = publishData.outputDesc[_loc7_];
            if(_loc4_ is XML)
            {
               _loc3_ = (_loc4_ as XML).toXMLString();
            }
            else
            {
               _loc3_ = String(_loc4_);
            }
            _loc1_.addFileFromString(_loc7_,_loc3_);
         }
         if(!publishData.exportDescOnly)
         {
            if(publishData.singlePackage)
            {
               _loc6_ = _loc1_;
            }
            else
            {
               _loc6_ = new ZipArchive();
            }
            _loc8_.length = 0;
            var _loc15_:int = 0;
            var _loc14_:* = publishData.outputRes;
            for(_loc7_ in publishData.outputRes)
            {
               _loc8_.push(_loc7_);
            }
            var _loc17_:int = 0;
            var _loc16_:* = _loc8_;
            for each(_loc7_ in _loc8_)
            {
               _loc6_.addFileFromBytes(_loc7_,publishData.outputRes[_loc7_]);
            }
            if(publishData.hitTestData.length > 0)
            {
               _loc6_.addFileFromBytes("hittest.bytes",publishData.hitTestData);
            }
            if(!publishData.singlePackage)
            {
               _loc2_ = _loc6_.output(0);
               if(_loc2_)
               {
                  UtilsFile.saveBytes(_loc5_,_loc2_);
               }
               else
               {
                  _loc2_ = new ByteArray();
                  UtilsFile.saveBytes(_loc5_,_loc2_);
               }
            }
            else
            {
               try
               {
                  if(_loc5_.exists)
                  {
                     _loc5_.deleteFile();
                  }
               }
               catch(err:Error)
               {
                  stepCallback.msgs.length = 0;
                  stepCallback.addMsg("Unable to delete file \'" + _loc5_.name + "\'");
                  stepCallback.callOnFail();
                  return;
               }
            }
         }
         UtilsFile.saveBytes(_loc9_,_loc1_.output(8));
         stepCallback.callOnSuccess();
      }
   }
}
