package fairygui
{
   public class ScrollType
   {
      
      public static const Horizontal:int = 0;
      
      public static const Vertical:int = 1;
      
      public static const Both:int = 2;
       
      
      public function ScrollType()
      {
         super();
      }
      
      public static function parse(param1:String) : int
      {
         var _loc2_:* = param1;
         if("horizontal" !== _loc2_)
         {
            if("vertical" !== _loc2_)
            {
               if("both" !== _loc2_)
               {
                  return 1;
               }
               return 2;
            }
            return 1;
         }
         return 0;
      }
   }
}
