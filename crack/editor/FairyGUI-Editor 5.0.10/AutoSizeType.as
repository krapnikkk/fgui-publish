package fairygui
{
   public class AutoSizeType
   {
      
      public static const None:int = 0;
      
      public static const Both:int = 1;
      
      public static const Height:int = 2;
      
      public static const Shrink:int = 3;
       
      
      public function AutoSizeType()
      {
         super();
      }
      
      public static function parse(param1:String) : int
      {
         var _loc2_:* = param1;
         if("none" !== _loc2_)
         {
            if("both" !== _loc2_)
            {
               if("height" !== _loc2_)
               {
                  if("shrink" !== _loc2_)
                  {
                     return 0;
                  }
                  return 3;
               }
               return 2;
            }
            return 1;
         }
         return 0;
      }
   }
}
