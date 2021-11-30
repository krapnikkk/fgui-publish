package fairygui.utils
{
   import flash.utils.ByteArray;
   
   public class PixelHitTestData
   {
       
      
      public var pixelWidth:int;
      
      public var scale:Number;
      
      public var pixels:Vector.<int>;
      
      public function PixelHitTestData()
      {
         super();
      }
      
      public function load(param1:ByteArray) : void
      {
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         param1.readInt();
         pixelWidth = param1.readInt();
         scale = param1.readByte();
         var _loc2_:int = param1.readInt();
         pixels = new Vector.<int>(_loc2_);
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = param1.readByte();
            if(_loc3_ < 0)
            {
               _loc3_ = _loc3_ + 256;
            }
            pixels[_loc4_] = _loc3_;
            _loc4_++;
         }
      }
   }
}
