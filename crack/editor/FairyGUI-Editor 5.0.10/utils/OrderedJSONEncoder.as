package fairygui.utils
{
   import flash.utils.describeType;
   
   public class OrderedJSONEncoder
   {
      
      private static var level:int;
       
      
      public function OrderedJSONEncoder()
      {
         super();
      }
      
      public static function encode(param1:*) : String
      {
         level = 0;
         return convertToString(param1);
      }
      
      private static function convertToString(param1:*) : String
      {
         if(param1 is String)
         {
            return escapeString(param1 as String);
         }
         if(param1 is Number)
         {
            return !!isFinite(param1 as Number)?param1.toString():"null";
         }
         if(param1 is Boolean)
         {
            return !!param1?"true":"false";
         }
         if(param1 is Array)
         {
            return arrayToString(param1 as Array);
         }
         if(param1 is Object && param1 != null)
         {
            return objectToString(param1);
         }
         return "null";
      }
      
      private static function escapeString(param1:String) : String
      {
         var _loc3_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc2_:* = "";
         var _loc4_:Number = param1.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = param1.charAt(_loc5_);
            switch(_loc3_)
            {
               case "\"":
                  _loc2_ = _loc2_ + "\\\"";
                  break;
               case "\\":
                  _loc2_ = _loc2_ + "\\\\";
                  break;
               case "\b":
                  _loc2_ = _loc2_ + "\\b";
                  break;
               case "\f":
                  _loc2_ = _loc2_ + "\\f";
                  break;
               case "\n":
                  _loc2_ = _loc2_ + "\\n";
                  break;
               case "\r":
                  _loc2_ = _loc2_ + "\\r";
                  break;
               case "\t":
                  _loc2_ = _loc2_ + "\\t";
                  break;
               default:
                  if(_loc3_ < " ")
                  {
                     _loc6_ = _loc3_.charCodeAt(0).toString(16);
                     _loc7_ = _loc6_.length == 2?"00":"000";
                     _loc2_ = _loc2_ + ("\\u" + _loc7_ + _loc6_);
                  }
                  else
                  {
                     _loc2_ = _loc2_ + _loc3_;
                  }
            }
            _loc5_++;
         }
         return "\"" + _loc2_ + "\"";
      }
      
      private static function arrayToString(param1:Array) : String
      {
         var _loc2_:* = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(_loc2_.length > 0)
            {
               _loc2_ = _loc2_ + ",";
            }
            _loc2_ = _loc2_ + convertToString(param1[_loc3_]);
            _loc3_++;
         }
         return "[" + _loc2_ + "]";
      }
      
      private static function objectToString(param1:Object) : String
      {
         var padding:String = null;
         var i:int = 0;
         var str:String = null;
         var value:Object = null;
         var key:String = null;
         var v:XML = null;
         var o:Object = param1;
         level++;
         var keys:Array = [];
         var result:Array = [];
         var classInfo:XML = describeType(o);
         if(classInfo.@name.toString() == "Object")
         {
            for(key in o)
            {
               keys.push(key);
            }
            keys.sort();
            for each(key in keys)
            {
               value = o[key];
               if(!(value is Function))
               {
                  result.push(escapeString(key) + ":" + convertToString(value));
               }
            }
         }
         else
         {
            for each(v in classInfo..§*§.(name() == "variable" || name() == "accessor"))
            {
               keys.push(v.@name.toString());
            }
            keys.sort();
            for each(key in keys)
            {
               result.push(escapeString(key) + ":" + convertToString(key));
            }
         }
         padding = "";
         i = 0;
         while(i < level - 1)
         {
            padding = padding + "\t";
            i++;
         }
         if(result.length > 0)
         {
            str = padding + "\t" + result.join(",\n" + padding + "\t");
         }
         else
         {
            str = "";
         }
         str = "{\n" + str + "\n" + padding + "}";
         level--;
         return str;
      }
   }
}
