package fairygui.utils
{
   import flash.utils.ByteArray;
   
   public class ZipReader
   {
       
      
      private var _stream:ByteArray;
      
      private var _entries:Object;
      
      public function ZipReader(param1:ByteArray)
      {
         super();
         _stream = param1;
         _stream.endian = "littleEndian";
         _entries = {};
         readEntries();
      }
      
      public function get entries() : Object
      {
         return _entries;
      }
      
      private function readEntries() : void
      {
         var _loc8_:int = 0;
         var _loc5_:* = 0;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc1_:* = null;
         var _loc2_:* = null;
         _stream.position = _stream.length - 22;
         var _loc7_:ByteArray = new ByteArray();
         _loc7_.endian = "littleEndian";
         _stream.readBytes(_loc7_,0,22);
         _loc7_.position = 10;
         var _loc6_:int = _loc7_.readUnsignedShort();
         _loc7_.position = 16;
         _stream.position = _loc7_.readUnsignedInt();
         _loc7_.length = 0;
         _loc8_ = 0;
         while(_loc8_ < _loc6_)
         {
            _stream.readBytes(_loc7_,0,46);
            _loc7_.position = 28;
            _loc5_ = uint(_loc7_.readUnsignedShort());
            _loc3_ = _stream.readUTFBytes(_loc5_);
            _loc4_ = _loc7_.readUnsignedShort() + _loc7_.readUnsignedShort();
            _stream.position = _stream.position + _loc4_;
            _loc1_ = _loc3_.charAt(_loc3_.length - 1);
            if(!(_loc1_ == "/" || _loc1_ == "\\"))
            {
               _loc3_ = _loc3_.replace(/\\/g,"/");
               _loc2_ = new ZipEntry();
               _loc2_.name = _loc3_;
               _loc7_.position = 10;
               _loc2_.compress = _loc7_.readUnsignedShort();
               _loc7_.position = 16;
               _loc2_.crc = _loc7_.readUnsignedInt();
               _loc2_.size = _loc7_.readUnsignedInt();
               _loc2_.sourceSize = _loc7_.readUnsignedInt();
               _loc7_.position = 42;
               _loc2_.offset = _loc7_.readUnsignedInt() + 30 + _loc5_;
               _entries[_loc3_] = _loc2_;
            }
            _loc8_++;
         }
      }
      
      public function getEntryData(param1:String) : ByteArray
      {
         var _loc3_:ZipEntry = _entries[param1];
         if(!_loc3_)
         {
            return null;
         }
         var _loc2_:ByteArray = new ByteArray();
         if(!_loc3_.size)
         {
            return _loc2_;
         }
         _stream.position = _loc3_.offset;
         _stream.readBytes(_loc2_,0,_loc3_.size);
         if(_loc3_.compress)
         {
            _loc2_.inflate();
         }
         return _loc2_;
      }
   }
}

class ZipEntry
{
    
   
   public var name:String;
   
   public var offset:uint;
   
   public var size:uint;
   
   public var sourceSize:uint;
   
   public var compress:int;
   
   public var crc:uint;
   
   function ZipEntry()
   {
      super();
   }
}
