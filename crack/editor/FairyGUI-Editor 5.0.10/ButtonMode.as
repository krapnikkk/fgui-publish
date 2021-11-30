package fairygui
{
   public class ButtonMode
   {
      
      public static const Common:int = 0;
      
      public static const Check:int = 1;
      
      public static const Radio:int = 2;
       
      
      public function ButtonMode()
      {
         super();
      }
      
      public static function parse(param1:String) : int
      {
         var _loc2_:* = param1;
         if("Common" !== _loc2_)
         {
            if("Check" !== _loc2_)
            {
               if("Radio" !== _loc2_)
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
