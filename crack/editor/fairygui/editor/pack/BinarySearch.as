package fairygui.editor.pack
{
   public class BinarySearch
   {
       
      
      public var min:int;
      
      public var max:int;
      
      public var fuzziness:int;
      
      public var low:int;
      
      public var high:int;
      
      public var current:int;
      
      public var pot:Boolean;
      
      public function BinarySearch(param1:int, param2:int, param3:int, param4:Boolean)
      {
         super();
         this.pot = param4;
         this.fuzziness = !!param4?0:int(param3);
         this.min = !!param4?int(Math.log(MaxRectsPacker.getNextPowerOfTwo(param1)) / Math.log(2)):int(param1);
         this.max = !!param4?int(Math.log(MaxRectsPacker.getNextPowerOfTwo(param2)) / Math.log(2)):int(param2);
      }
      
      public function reset() : int
      {
         this.low = this.min;
         this.high = this.max;
         this.current = this.low + this.high >>> 1;
         return !!this.pot?int(Math.pow(2,this.current)):int(this.current);
      }
      
      public function next(param1:Boolean) : int
      {
         if(this.low >= this.high)
         {
            return -1;
         }
         if(param1)
         {
            this.low = this.current + 1;
         }
         else
         {
            this.high = this.current - 1;
         }
         this.current = this.low + this.high >>> 1;
         if(Math.abs(this.low - this.high) < this.fuzziness)
         {
            return -1;
         }
         return !!this.pot?int(Math.pow(2,this.current)):int(this.current);
      }
   }
}
