package fairygui
{
   public class OverflowType
   {
      
      public static const Visible:int = 0;
      
      public static const Hidden:int = 1;
      
      public static const Scroll:int = 2;
      
      public static const Scale:int = 3;
      
      public static const ScaleFree:int = 4;
       
      
      public function OverflowType()
      {
         super();
      }
      
      public static function parse(param1:String) : int
      {
         var _loc2_:* = param1;
         if("visible" !== _loc2_)
         {
            if("hidden" !== _loc2_)
            {
               if("scroll" !== _loc2_)
               {
                  if("scale" !== _loc2_)
                  {
                     if("scaleFree" !== _loc2_)
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
