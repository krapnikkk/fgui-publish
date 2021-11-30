package fairygui.tween
{
   public class TweenValue
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var z:Number;
      
      public var w:Number;
      
      public function TweenValue()
      {
         super();
         w = 0;
         z = 0;
         y = 0;
         x = 0;
      }
      
      public function get color() : uint
      {
         return (uint(w) << 24) + (uint(x) << 16) + (uint(y) << 8) + uint(z);
      }
      
      public function set color(param1:uint) : void
      {
         x = (param1 & 16711680) >> 16;
         y = (param1 & 65280) >> 8;
         z = param1 & 255;
         w = (param1 & 4278190080) >> 24;
      }
      
      public function getField(param1:int) : Number
      {
         switch(int(param1))
         {
            case 0:
               return x;
            case 1:
               return y;
            case 2:
               return z;
            case 3:
               return w;
         }
      }
      
      public function setField(param1:int, param2:Number) : void
      {
         switch(int(param1))
         {
            case 0:
               x = param2;
               break;
            case 1:
               y = param2;
               break;
            case 2:
               z = param2;
               break;
            case 3:
               w = param2;
         }
      }
      
      public function setZero() : void
      {
         w = 0;
         z = 0;
         y = 0;
         x = 0;
      }
   }
}
