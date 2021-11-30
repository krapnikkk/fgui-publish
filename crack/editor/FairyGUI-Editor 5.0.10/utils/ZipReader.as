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
         var _loc7_:int = 0;
         var _loc3_:* = 0;
         var _loc6_:* = null;
         var _loc8_:int = 0;
         var _loc5_:* = null;
         var _loc4_:* = null;
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.endian = "littleEndian";
         _stream.position = _stream.length - 22;
         _stream.readBytes(_loc1_,0,22);
         _loc1_.position = 10;
         var _loc2_:int = _loc1_.readUnsignedShort();
         _loc1_.position = 16;
         _stream.position = _loc1_.readUnsignedInt();
         _loc1_.length = 0;
         _loc7_ = 0;
         while(_loc7_ < _loc2_)
         {
            _stream.readBytes(_loc1_,0,46);
            _loc1_.position = 28;
            _loc3_ = uint(_loc1_.readUnsignedShort());
            _loc6_ = _stream.readUTFBytes(_loc3_);
            _loc8_ = _stream.position + _loc1_.readUnsignedShort() + _loc1_.readUnsignedShort();
            _loc5_ = _loc6_.charAt(_loc6_.length - 1);
            if(_loc5_ == "/" || _loc5_ == "\\")
            {
               _stream.position = _loc8_;
            }
            else
            {
               _loc6_ = _loc6_.replace(/\\/g,"/");
               _loc4_ = new ZipEntry();
               _loc4_.name = _loc6_;
               _loc1_.position = 10;
               _loc4_.compress = _loc1_.readUnsignedShort();
               _loc1_.position = 16;
               _loc4_.crc = _loc1_.readUnsignedInt();
               _loc4_.size = _loc1_.readUnsignedInt();
               _loc4_.sourceSize = _loc1_.readUnsignedInt();
               _loc1_.position = 42;
               _loc4_.offset = _loc1_.readUnsignedInt();
               _stream.position = _loc4_.offset;
               _stream.readBytes(_loc1_,0,30);
               _loc1_.position = 26;
               _loc4_.offset = _loc4_.offset + (_loc1_.readUnsignedShort() + _loc1_.readUnsignedShort() + 30);
               _stream.position = _loc8_;
               _entries[_loc6_] = _loc4_;
            }
            _loc7_++;
         }
      }
      
      public function getEntryData(param1:String) : ByteArray
      {
         var _loc2_:ZipEntry = _entries[param1];
         if(!_loc2_)
         {
            return null;
         }
         var _loc3_:ByteArray = new ByteArray();
         if(!_loc2_.size)
         {
            return _loc3_;
         }
         _stream.position = _loc2_.offset;
         _stream.readBytes(_loc3_,0,_loc2_.size);
         if(_loc2_.compress)
         {
            _loc3_.inflate();
         }
         return _loc3_;
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
