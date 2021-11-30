package fairygui
{
   public class LoaderFillType
   {
      
      public static const None:int = 0;
      
      public static const Scale:int = 1;
      
      public static const ScaleMatchHeight:int = 2;
      
      public static const ScaleMatchWidth:int = 3;
      
      public static const ScaleFree:int = 4;
      
      public static const ScaleNoBorder:int = 5;
       
      
      public function LoaderFillType()
      {
         super();
      }
      
      public static function parse(param1:String) : int
      {
         var _loc2_:* = param1;
         if("none" !== _loc2_)
         {
            if("scale" !== _loc2_)
            {
               if("scaleMatchHeight" !== _loc2_)
               {
                  if("scaleMatchWidth" !== _loc2_)
                  {
                     if("scaleFree" !== _loc2_)
                     {
                        if("scaleNoBorder" !== _loc2_)
                        {
                           return 0;
                        }
                        return 5;
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
