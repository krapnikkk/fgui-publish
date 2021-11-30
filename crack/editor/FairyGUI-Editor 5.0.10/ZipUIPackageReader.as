package fairygui
{
   import fairygui.utils.ZipReader;
   import flash.utils.ByteArray;
   
   public class ZipUIPackageReader implements IUIPackageReader
   {
       
      
      private var _desc:ZipReader;
      
      private var _files:ZipReader;
      
      public function ZipUIPackageReader(param1:ByteArray, param2:ByteArray)
      {
         super();
         _desc = new ZipReader(param1);
         if(param2 && param2.length)
         {
            _files = new ZipReader(param2);
         }
         else
         {
            _files = _desc;
         }
      }
      
      public function readDescFile(param1:String) : String
      {
         var _loc3_:ByteArray = _desc.getEntryData(param1);
         var _loc2_:String = _loc3_.readUTFBytes(_loc3_.length);
         _loc3_.clear();
         return _loc2_;
      }
      
      public function readResFile(param1:String) : ByteArray
      {
         return _files.getEntryData(param1);
      }
   }
}
