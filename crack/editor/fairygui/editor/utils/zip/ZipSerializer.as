package fairygui.editor.utils.zip
{
   import flash.utils.ByteArray;
   
   class ZipSerializer
   {
       
      
      private var stream:ByteArray;
      
      function ZipSerializer()
      {
         super();
      }
      
      public function serialize(param1:ZipArchive, param2:uint = 8) : ByteArray
      {
         var _loc3_:int = 0;
         var _loc6_:ZipFile = null;
         var _loc5_:ByteArray = null;
         if(param1.numFiles <= 0)
         {
            return null;
         }
         var _loc7_:ByteArray = new ByteArray();
         var _loc8_:ByteArray = new ByteArray();
         var _loc9_:String = "littleEndian";
         _loc8_.endian = _loc9_;
         _loc7_.endian = _loc9_;
         var _loc4_:int = 0;
         while(_loc4_ < param1.numFiles)
         {
            _loc6_ = param1.getFileAt(_loc4_);
            _loc5_ = this.serializeContent(_loc6_,param2);
            this.serializeFile(_loc7_,_loc6_,true);
            _loc7_.writeBytes(_loc5_);
            this.serializeFile(_loc8_,_loc6_,false,_loc3_);
            _loc3_ = _loc7_.position;
            _loc4_++;
         }
         _loc7_.writeBytes(_loc8_);
         this.serializeEnd(_loc7_,_loc3_,_loc7_.length - _loc3_,param1.numFiles);
         return _loc7_;
      }
      
      private function serializeFile(param1:ByteArray, param2:ZipFile, param3:Boolean = true, param4:uint = 0) : void
      {
         if(param3)
         {
            param1.writeUnsignedInt(67324752);
         }
         else
         {
            param1.writeUnsignedInt(33639248);
            param1.writeShort(param2._version);
         }
         param1.writeShort(param2._version);
         param1.writeShort(param2._flag);
         param1.writeShort(param2._compressionMethod);
         param1.writeUnsignedInt(1256736768);
         param1.writeUnsignedInt(param2._crc32);
         param1.writeUnsignedInt(param2._compressedSize);
         param1.writeUnsignedInt(param2._size);
         var _loc5_:ByteArray = new ByteArray();
         _loc5_.writeUTFBytes(param2._name);
         param1.writeShort(_loc5_.position);
         param1.writeShort(!!param2.hasExtra()?int(param2._extra.length):0);
         if(!param3)
         {
            param1.writeShort(!!param2._comment?int(param2._comment.length):0);
            param1.writeShort(0);
            param1.writeShort(0);
            param1.writeUnsignedInt(0);
            param1.writeUnsignedInt(param4);
         }
         param1.writeBytes(_loc5_);
         if(param2.hasExtra())
         {
            param1.writeBytes(param2._extra);
         }
         if(!param3 && param2._comment)
         {
            param1.writeUTFBytes(param2._comment);
         }
      }
      
      private function serializeContent(param1:ZipFile, param2:uint = 8) : ByteArray
      {
         var _loc4_:ByteArray = null;
         param1._compressionMethod = param2;
         param1._flag = 0;
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeBytes(param1.data);
         if(param2 == 8)
         {
            try
            {
               _loc3_.compress();
            }
            catch(e:Error)
            {
            }
            _loc4_ = new ByteArray();
            if(_loc3_.length - 6 > 0)
            {
               param1._compressedSize = _loc3_.length - 6;
               _loc4_.writeBytes(_loc3_,2,_loc3_.length - 6);
            }
            return _loc4_;
         }
         if(param2 == 0)
         {
            param1._compressedSize = _loc3_.length;
         }
         return _loc3_;
      }
      
      private function serializeEnd(param1:ByteArray, param2:uint, param3:uint, param4:uint) : void
      {
         param1.writeUnsignedInt(101010256);
         param1.writeShort(0);
         param1.writeShort(0);
         param1.writeShort(param4);
         param1.writeShort(param4);
         param1.writeUnsignedInt(param3);
         param1.writeUnsignedInt(param2);
         param1.writeShort(0);
      }
   }
}
