package fairygui
{
   public class PackageItemType
   {
      
      public static const Image:int = 0;
      
      public static const Swf:int = 1;
      
      public static const MovieClip:int = 2;
      
      public static const Sound:int = 3;
      
      public static const Component:int = 4;
      
      public static const Misc:int = 5;
      
      public static const Font:int = 6;
       
      
      public function PackageItemType()
      {
         super();
      }
      
      public static function parseType(param1:String) : int
      {
         var _loc2_:* = param1;
         if("image" !== _loc2_)
         {
            if("movieclip" !== _loc2_)
            {
               if("sound" !== _loc2_)
               {
                  if("component" !== _loc2_)
                  {
                     if("swf" !== _loc2_)
                     {
                        if("font" !== _loc2_)
                        {
                           return 5;
                        }
                        return 6;
                     }
                     return 1;
                  }
                  return 4;
               }
               return 3;
            }
            return 2;
         }
         return 0;
      }
   }
}
