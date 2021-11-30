package fairygui
{
   public class ChildrenRenderOrder
   {
      
      public static const Ascent:int = 0;
      
      public static const Descent:int = 1;
      
      public static const Arch:int = 2;
       
      
      public function ChildrenRenderOrder()
      {
         super();
      }
      
      public static function parse(param1:String) : int
      {
         var _loc2_:* = param1;
         if("ascent" !== _loc2_)
         {
            if("descent" !== _loc2_)
            {
               if("arch" !== _loc2_)
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
