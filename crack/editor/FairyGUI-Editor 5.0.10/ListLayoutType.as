package fairygui
{
   public class ListLayoutType
   {
      
      public static const SingleColumn:int = 0;
      
      public static const SingleRow:int = 1;
      
      public static const FlowHorizontal:int = 2;
      
      public static const FlowVertical:int = 3;
      
      public static const Pagination:int = 4;
       
      
      public function ListLayoutType()
      {
         super();
      }
      
      public static function parse(param1:String) : int
      {
         var _loc2_:* = param1;
         if("column" !== _loc2_)
         {
            if("row" !== _loc2_)
            {
               if("flow_hz" !== _loc2_)
               {
                  if("flow_vt" !== _loc2_)
                  {
                     if("pagination" !== _loc2_)
                     {
                        return 0;
                     }
                     return 4;
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
