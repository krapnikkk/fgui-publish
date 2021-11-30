package fairygui.utils
{
   import flash.utils.ByteArray;
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
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         RuntimeErrorUtil.m_loaded = true;
         for each(_loc2_ in param1.error)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = unescape(_loc2_.toString());
            RuntimeErrorUtil.m_errors[_loc3_] = _loc4_;
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
         var _loc3_:ByteArray = null;
         var _loc4_:String = null;
         if(!RuntimeErrorUtil.m_loaded)
         {
            _loc3_ = new ERROR_DATA();
            _loc4_ = _loc3_.readUTFBytes(_loc3_.length);
            _loc3_.clear();
            RuntimeErrorUtil.loadFromXML(new XML(_loc4_));
         }
         var _loc2_:String = RuntimeErrorUtil.m_errors[param1];
         _loc2_ = _loc2_ != null?_loc2_:"Error #" + param1;
         return _loc2_;
      }
   }
}
