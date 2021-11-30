package fairygui
{
   public class GroupLayoutType
   {
      
      public static const None:int = 0;
      
      public static const Horizontal:int = 1;
      
      public static const Vertical:int = 2;
       
      
      public function GroupLayoutType()
      {
         super();
      }
      
      public static function parse(param1:String) : int
      {
         var _loc2_:* = param1;
         if("none" !== _loc2_)
         {
            if("hz" !== _loc2_)
            {
               if("vt" !== _loc2_)
               {
                  return 0;
               }
               return 2;
            }
            return 1;
         }
         return 0;
      }
   }
}
