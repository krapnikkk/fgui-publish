package fairygui
{
   public class VertAlignType
   {
      
      public static const Top:int = 0;
      
      public static const Middle:int = 1;
      
      public static const Bottom:int = 2;
       
      
      public function VertAlignType()
      {
         super();
      }
      
      public static function parse(param1:String) : int
      {
         var _loc2_:* = param1;
         if("top" !== _loc2_)
         {
            if("middle" !== _loc2_)
            {
               if("bottom" !== _loc2_)
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
