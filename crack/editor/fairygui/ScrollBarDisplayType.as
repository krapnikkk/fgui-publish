package fairygui
{
   public class ScrollBarDisplayType
   {
      
      public static const Default:int = 0;
      
      public static const Visible:int = 1;
      
      public static const Auto:int = 2;
      
      public static const Hidden:int = 3;
       
      
      public function ScrollBarDisplayType()
      {
         super();
      }
      
      public static function parse(param1:String) : int
      {
         var _loc2_:* = param1;
         if("default" !== _loc2_)
         {
            if("visible" !== _loc2_)
            {
               if("auto" !== _loc2_)
               {
                  if("hidden" !== _loc2_)
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
