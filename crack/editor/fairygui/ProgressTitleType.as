package fairygui
{
   public class ProgressTitleType
   {
      
      public static const Percent:int = 0;
      
      public static const ValueAndMax:int = 1;
      
      public static const Value:int = 2;
      
      public static const Max:int = 3;
       
      
      public function ProgressTitleType()
      {
         super();
      }
      
      public static function parse(param1:String) : int
      {
         var _loc2_:* = param1;
         if("percent" !== _loc2_)
         {
            if("valueAndmax" !== _loc2_)
            {
               if("value" !== _loc2_)
               {
                  if("max" !== _loc2_)
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
