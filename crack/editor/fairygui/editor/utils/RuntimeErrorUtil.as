package fairygui.editor.utils
{
   import flash.utils.Dictionary;
   
   public class RuntimeErrorUtil
   {
      
      private static var m_errors:Dictionary = new Dictionary();
      
      private static var m_loaded:Boolean;
      
      private static var ERROR_DATA:Class = RuntimeErrorUtil_ERROR_DATA;
       
      
      public function RuntimeErrorUtil()
      {
         super();
      }
      
      public static function loadFromXML(param1:XML) : void
      {
         var _loc4_:XML = null;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         RuntimeErrorUtil.m_loaded = true;
         var _loc6_:int = 0;
         var _loc5_:* = param1.error;
         for each(_loc4_ in param1.error)
         {
            _loc2_ = _loc4_.@id;
            _loc3_ = unescape(_loc4_.toString());
            RuntimeErrorUtil.m_errors[_loc2_] = _loc3_;
         }
      }
      
      public static function toString(param1:Error) : String
      {
         if(param1.errorID)
         {
            return RuntimeErrorUtil.toStringFromID(param1.errorID);
         }
         return param1.message;
      }
      
      public static function toStringFromID(param1:int) : String
      {
         if(!RuntimeErrorUtil.m_loaded)
         {
            RuntimeErrorUtil.loadFromXML(ERROR_DATA.data);
         }
         var _loc2_:String = RuntimeErrorUtil.m_errors[param1];
         _loc2_ = _loc2_ != null?_loc2_:"Error #" + param1;
         return _loc2_;
      }
   }
}
