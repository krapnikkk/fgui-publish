package fairygui
{
   public class ListSelectionMode
   {
      
      public static const Single:int = 0;
      
      public static const Multiple:int = 1;
      
      public static const Multiple_SingleClick:int = 2;
      
      public static const None:int = 3;
       
      
      public function ListSelectionMode()
      {
         super();
      }
      
      public static function parse(param1:String) : int
      {
         var _loc2_:* = param1;
         if("single" !== _loc2_)
         {
            if("multiple" !== _loc2_)
            {
               if("multipleSingleClick" !== _loc2_)
               {
                  if("none" !== _loc2_)
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
