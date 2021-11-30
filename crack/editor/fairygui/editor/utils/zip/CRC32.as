package fairygui.editor.utils.zip
{
   import flash.utils.ByteArray;
   
   public class CRC32
   {
      
      private static var crcTable:Array = makeCrcTable();
       
      
      public function CRC32()
      {
         super();
      }
      
      public static function getCRC32(param1:ByteArray, param2:int = 0, param3:int = 0) : uint
      {
         if(param2 >= param1.length)
         {
            param2 = param1.length;
         }
         if(param3 == 0)
         {
            param3 = param1.length - param2;
         }
         if(param3 + param2 > param1.length)
         {
            param3 = param1.length - param2;
         }
         var _loc5_:* = -1;
         var _loc4_:* = param2;
         while(_loc4_ < param3)
         {
            _loc5_ = int(crcTable[(_loc5_ ^ param1[_loc4_]) & 255]) ^ _loc5_ >>> 8;
            _loc4_++;
         }
         return _loc5_ ^ 4294967295;
      }
      
      private static function makeCrcTable() : Array
      {
         var _loc3_:uint = 0;
         var _loc1_:int = 0;
         var _loc5_:int = -306674912;
         var _loc4_:Array = [];
         var _loc2_:int = 256;
         while(true)
         {
            _loc2_--;
            if(!_loc2_)
            {
               break;
            }
            _loc3_ = _loc2_;
            _loc1_ = 8;
            while(true)
            {
               _loc1_--;
               if(!_loc1_)
               {
                  break;
               }
               _loc3_ = !!(_loc3_ & 1)?uint(_loc3_ >>> 1 ^ _loc5_):uint(_loc3_ >>> 1);
            }
            _loc4_[_loc2_] = _loc3_;
         }
         return _loc4_;
      }
   }
}
