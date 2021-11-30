package fairygui.editor.utils
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
         var _loc5_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc7_:* = "";
         var _loc6_:Number = param1.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc6_)
         {
            _loc5_ = param1.charAt(_loc2_);
            var _loc8_:* = _loc5_;
            if("\"" !== _loc8_)
            {
               if("\\" !== _loc8_)
               {
                  if("\b" !== _loc8_)
                  {
                     if("\f" !== _loc8_)
                     {
                        if("\n" !== _loc8_)
                        {
                           if("\r" !== _loc8_)
                           {
                              if("\t" !== _loc8_)
                              {
                                 if(_loc5_ < " ")
                                 {
                                    _loc3_ = _loc5_.charCodeAt(0).toString(16);
                                    _loc4_ = _loc3_.length == 2?"00":"000";
                                    _loc7_ = _loc7_ + ("\\u" + _loc4_ + _loc3_);
                                 }
                                 else
                                 {
                                    _loc7_ = _loc7_ + _loc5_;
                                 }
                              }
                              else
                              {
                                 _loc7_ = _loc7_ + "\\t";
                              }
                           }
                           else
                           {
                              _loc7_ = _loc7_ + "\\r";
                           }
                        }
                        else
                        {
                           _loc7_ = _loc7_ + "\\n";
                        }
                     }
                     else
                     {
                        _loc7_ = _loc7_ + "\\f";
                     }
                  }
                  else
                  {
                     _loc7_ = _loc7_ + "\\b";
                  }
               }
               else
               {
                  _loc7_ = _loc7_ + "\\\\";
               }
            }
            else
            {
               _loc7_ = _loc7_ + "\\\"";
            }
            _loc2_++;
         }
         return "\"" + _loc7_ + "\"";
      }
      
      private static function arrayToString(param1:Array) : String
      {
         var _loc3_:* = "";
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if(_loc3_.length > 0)
            {
               _loc3_ = _loc3_ + ",";
            }
            _loc3_ = _loc3_ + convertToString(param1[_loc2_]);
            _loc2_++;
         }
         return "[" + _loc3_ + "]";
      }
      
      private static function objectToString(param1:Object) : String
      {
         var _loc9_:String = null;
         var _loc11_:int = 0;
         var _loc5_:String = null;
         var _loc7_:Object = null;
         var _loc10_:* = null;
         var _loc3_:XML = null;
         var _loc8_:* = param1;
         level = Number(level) + 1;
         var _loc6_:Array = [];
         var _loc2_:Array = [];
         var _loc4_:XML = describeType(_loc8_);
         if(_loc4_.@name.toString() == "Object")
         {
            var _loc13_:int = 0;
            var _loc12_:* = _loc8_;
            for(_loc10_ in _loc8_)
            {
               _loc6_.push(_loc10_);
            }
            _loc6_.sort();
            var _loc15_:int = 0;
            var _loc14_:* = _loc6_;
            for each(_loc10_ in _loc6_)
            {
               _loc7_ = _loc8_[_loc10_];
               if(!(_loc7_ is Function))
               {
                  _loc2_.push(escapeString(_loc10_) + ":" + convertToString(_loc7_));
               }
            }
         }
         else
         {
            var _loc19_:int = 0;
            var _loc16_:* = _loc4_..*;
            var _loc17_:int = 0;
            _loc12_ = new XMLList("");
            var _loc18_:* = _loc4_..*.(name() == "variable" || name() == "accessor");
            for each(_loc3_ in _loc4_..*.(name() == "variable" || name() == "accessor"))
            {
               _loc6_.push(_loc3_.@name.toString());
            }
            _loc6_.sort();
            var _loc21_:int = 0;
            var _loc20_:* = _loc6_;
            for each(_loc10_ in _loc6_)
            {
               _loc2_.push(escapeString(_loc10_) + ":" + convertToString(_loc10_));
            }
         }
         _loc9_ = "";
         _loc11_ = 0;
         while(_loc11_ < level - 1)
         {
            _loc9_ = _loc9_ + "\t";
            _loc11_++;
         }
         if(_loc2_.length > 0)
         {
            _loc5_ = _loc9_ + "\t" + _loc2_.join(",\n" + _loc9_ + "\t");
         }
         else
         {
            _loc5_ = "";
         }
         _loc5_ = "{\n" + _loc5_ + "\n" + _loc9_ + "}";
         level = Number(level) - 1;
         return _loc5_;
      }
   }
}
