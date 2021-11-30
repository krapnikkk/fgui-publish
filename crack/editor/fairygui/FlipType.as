package fairygui
{
   public class FlipType
   {
      
      public static const None:int = 0;
      
      public static const Horizontal:int = 1;
      
      public static const Vertical:int = 2;
      
      public static const Both:int = 3;
       
      
      public function FlipType()
      {
         super();
      }
      
      public static function parse(param1:String) : int
      {
         var _loc2_:* = param1;
         if("hz" !== _loc2_)
         {
            if("vt" !== _loc2_)
            {
               if("both" !== _loc2_)
               {
                  return 0;
               }
               return 3;
            }
            return 2;
         }
         return 1;
      }
   }
}
