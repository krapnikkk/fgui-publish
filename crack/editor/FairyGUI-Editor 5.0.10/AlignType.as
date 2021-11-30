package fairygui
{
   public class AlignType
   {
      
      public static const Left:int = 0;
      
      public static const Center:int = 1;
      
      public static const Right:int = 2;
       
      
      public function AlignType()
      {
         super();
      }
      
      public static function parse(param1:String) : int
      {
         var _loc2_:* = param1;
         if("left" !== _loc2_)
         {
            if("center" !== _loc2_)
            {
               if("right" !== _loc2_)
               {
                  return 0;
               }
               return 2;
            }
            return 1;
         }
         return 0;
      }
      
      public static function toString(param1:int) : String
      {
         return param1 == 0?"left":param1 == 1?"center":"right";
      }
   }
}
