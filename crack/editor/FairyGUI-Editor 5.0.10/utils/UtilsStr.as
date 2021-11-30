package fairygui.utils
{
   public class UtilsStr
   {
      
      private static const FIX:String = int(Math.random() * 36).toString(36).substr(0,1);
       
      
      public function UtilsStr()
      {
         super();
      }
      
      public static function getFileName(param1:String) : String
      {
         var _loc2_:int = param1.lastIndexOf("/");
         if(_loc2_ != -1)
         {
            param1 = param1.substr(_loc2_ + 1);
         }
         _loc2_ = param1.lastIndexOf("\\");
         if(_loc2_ != -1)
         {
            param1 = param1.substr(_loc2_ + 1);
         }
         _loc2_ = param1.lastIndexOf(".");
         if(_loc2_ != -1)
         {
            return param1.substring(0,_loc2_);
         }
         return param1;
      }
      
      public static function replaceFileName(param1:String, param2:String) : String
      {
         var _loc3_:String = getFileExt(param1,true);
         return param2 + (!!_loc3_?"." + _loc3_:"");
      }
      
      public static function getFileExt(param1:String, param2:Boolean = false) : String
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc3_:int = param1.lastIndexOf("?");
         if(_loc3_ != -1)
         {
            _loc4_ = param1.lastIndexOf(".",_loc3_);
            if(_loc4_ != -1)
            {
               _loc5_ = param1.substring(_loc4_ + 1,_loc3_);
            }
            else
            {
               _loc5_ = "";
            }
         }
         else
         {
            _loc4_ = param1.lastIndexOf(".");
            if(_loc4_ != -1)
            {
               _loc5_ = param1.substr(_loc4_ + 1);
            }
            else
            {
               _loc5_ = "";
            }
         }
         if(!param2)
         {
            _loc5_ = _loc5_.toLowerCase();
         }
         return _loc5_;
      }
      
      public static function removeFileExt(param1:String) : String
      {
         var _loc2_:int = param1.lastIndexOf(".");
         if(_loc2_ != -1)
         {
            return param1.substring(0,_loc2_);
         }
         return param1;
      }
      
      public static function replaceFileExt(param1:String, param2:String) : String
      {
         if(param2)
         {
            param2 = "." + param2;
         }
         var _loc3_:int = param1.lastIndexOf(".");
         if(_loc3_ != -1)
         {
            return param1.substring(0,_loc3_) + param2;
         }
         return param1 + param2;
      }
      
      public static function removeURLParam(param1:String) : String
      {
         var _loc2_:int = param1.lastIndexOf("?");
         if(_loc2_ != -1)
         {
            return param1.substr(0,_loc2_);
         }
         return param1;
      }
      
      public static function getFileFullName(param1:String) : String
      {
         var _loc2_:int = param1.lastIndexOf("/");
         if(_loc2_ != -1)
         {
            param1 = param1.substr(_loc2_ + 1);
         }
         _loc2_ = param1.lastIndexOf("\\");
         if(_loc2_ != -1)
         {
            param1 = param1.substr(_loc2_ + 1);
         }
         return param1;
      }
      
      public static function getFilePath(param1:String) : String
      {
         var _loc2_:int = param1.lastIndexOf("/");
         if(_loc2_ != -1)
         {
            param1 = param1.substring(0,_loc2_);
         }
         _loc2_ = param1.lastIndexOf("\\");
         if(_loc2_ != -1)
         {
            param1 = param1.substring(0,_loc2_);
         }
         return param1;
      }
      
      public static function padString(param1:String, param2:int, param3:String) : String
      {
         var _loc4_:int = param1.length;
         var _loc5_:int = _loc4_;
         while(_loc5_ < param2)
         {
            param1 = param3 + param1;
            _loc5_++;
         }
         return param1;
      }
      
      public static function trim(param1:String) : String
      {
         return trimLeft(trimRight(param1));
      }
      
      public static function trimLeft(param1:String) : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = param1.charCodeAt(_loc3_);
            if(_loc2_ != 32 && _loc2_ != 9 && _loc2_ != 13 && _loc2_ != 10)
            {
               break;
            }
            _loc3_++;
         }
         return param1.substr(_loc3_);
      }
      
      public static function trimRight(param1:String) : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = param1.length - 1;
         while(_loc3_ >= 0)
         {
            _loc2_ = param1.charCodeAt(_loc3_);
            if(_loc2_ != 32 && _loc2_ != 9 && _loc2_ != 13 && _loc2_ != 10)
            {
               break;
            }
            _loc3_--;
         }
         return param1.substring(0,_loc3_ + 1);
      }
      
      public static function startsWith(param1:String, param2:String, param3:Boolean = false) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         if(param1.length < param2.length)
         {
            return false;
         }
         param1 = param1.substring(0,param2.length);
         if(!param3)
         {
            return param1 == param2;
         }
         return param1.toLowerCase() == param2.toLowerCase();
      }
      
      public static function endsWith(param1:String, param2:String, param3:Boolean = false) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         if(param1.length < param2.length)
         {
            return false;
         }
         param1 = param1.substring(param1.length - param2.length);
         if(!param3)
         {
            return param1 == param2;
         }
         return param1.toLowerCase() == param2.toLowerCase();
      }
      
      public static function generateUID() : String
      {
         var _loc1_:String = "0000" + int(Math.random() * 1679616).toString(36);
         var _loc2_:String = "000" + int(Math.random() * 46656).toString(36);
         return FIX + _loc1_.substr(_loc1_.length - 4) + _loc2_.substr(_loc2_.length - 3);
      }
      
      public static function convertToHtmlColor(param1:uint, param2:Boolean = false) : String
      {
         var _loc3_:String = null;
         if(param2)
         {
            _loc3_ = (param1 >> 24 & 255).toString(16);
         }
         else
         {
            _loc3_ = "";
         }
         var _loc4_:String = (param1 >> 16 & 255).toString(16);
         var _loc5_:String = (param1 >> 8 & 255).toString(16);
         var _loc6_:String = (param1 & 255).toString(16);
         if(_loc3_.length == 1)
         {
            _loc3_ = "0" + _loc3_;
         }
         if(_loc4_.length == 1)
         {
            _loc4_ = "0" + _loc4_;
         }
         if(_loc5_.length == 1)
         {
            _loc5_ = "0" + _loc5_;
         }
         if(_loc6_.length == 1)
         {
            _loc6_ = "0" + _loc6_;
         }
         return "#" + _loc3_ + _loc4_ + _loc5_ + _loc6_;
      }
      
      public static function convertFromHtmlColor(param1:String, param2:Boolean = false) : uint
      {
         if(param1 == null || param1.length < 1 || param1.charAt(0) != "#")
         {
            return 0;
         }
         if(param1.length == 9)
         {
            return (parseInt(param1.substr(1,2),16) << 24) + parseInt(param1.substr(3),16);
         }
         if(param2)
         {
            return 4278190080 + parseInt(param1.substr(1),16);
         }
         return parseInt(param1.substr(1),16);
      }
      
      public static function formatPrice(param1:String) : String
      {
         if(!param1)
         {
            return "";
         }
         if(param1.length < 4)
         {
            return param1;
         }
         var _loc2_:int = param1.length;
         var _loc3_:int = param1.length % 3;
         var _loc4_:* = "";
         _loc4_ = _loc4_ + param1.substring(0,_loc3_);
         while(_loc3_ < _loc2_)
         {
            if(_loc4_.length > 0)
            {
               _loc4_ = _loc4_ + ",";
            }
            _loc4_ = _loc4_ + param1.substr(_loc3_,3);
            _loc3_ = _loc3_ + 3;
         }
         return _loc4_;
      }
      
      public static function formatString(param1:String, ... rest) : String
      {
         var format:String = param1;
         var params:Array = rest;
         if(params.length == 0)
         {
            return format;
         }
         var re:RegExp = /\{(\d+)\}/g;
         return format.replace(re,function():String
         {
            if(params[arguments[1]] == null)
            {
               throw new ArgumentError("argument missing " + arguments[1]);
            }
            return params[arguments[1]];
         });
      }
      
      public static function formatStringByName(param1:String, param2:Object) : String
      {
         var _loc3_:* = null;
         for(_loc3_ in param2)
         {
            param1 = param1.replace(new RegExp("\\{" + _loc3_ + "\\}","gm"),param2[_loc3_]);
         }
         return param1;
      }
      
      public static function getSizeName(param1:int, param2:int = 2) : String
      {
         var _loc3_:* = null;
         var _loc4_:int = 0;
         if(param1 < 1024)
         {
            return param1 + "B";
         }
         if(param2)
         {
            param2++;
         }
         if(param1 < 1024 * 1024)
         {
            _loc3_ = "" + param1 / 1024;
            _loc4_ = _loc3_.lastIndexOf(".");
            if(_loc4_ < _loc3_.length - param2)
            {
               _loc3_ = _loc3_.substr(0,_loc4_ + param2);
            }
            _loc3_ = _loc3_ + "K";
         }
         else
         {
            _loc3_ = "" + param1 / (1024 * 1024);
            _loc4_ = _loc3_.lastIndexOf(".");
            if(_loc4_ < _loc3_.length - param2)
            {
               _loc3_ = _loc3_.substr(0,_loc4_ + param2);
            }
            _loc3_ = _loc3_ + "M";
         }
         return _loc3_;
      }
      
      public static function encodeXML(param1:String) : String
      {
         if(!param1)
         {
            return "";
         }
         return param1.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/'/g,"&apos;");
      }
      
      public static function decodeXML(param1:String) : String
      {
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc2_:int = param1.length;
         var _loc3_:* = "";
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(true)
         {
            _loc5_ = param1.indexOf("&",_loc4_);
            if(_loc5_ == -1)
            {
               break;
            }
            _loc3_ = _loc3_ + param1.substr(_loc4_,_loc5_ - _loc4_);
            _loc4_ = _loc5_ + 1;
            _loc5_ = _loc4_;
            _loc6_ = Math.min(_loc2_,_loc5_ + 10);
            while(_loc5_ < _loc6_)
            {
               if(param1.charCodeAt(_loc5_) == 59)
               {
                  break;
               }
               _loc5_++;
            }
            if(_loc5_ < _loc6_ && _loc5_ > _loc4_)
            {
               _loc7_ = param1.substr(_loc4_,_loc5_ - _loc4_);
               _loc8_ = 0;
               if(_loc7_.charCodeAt(0) == 35)
               {
                  if(_loc7_.length > 1)
                  {
                     if(_loc7_[1] == "x")
                     {
                        _loc8_ = parseInt(_loc7_.substr(2),16);
                     }
                     else
                     {
                        _loc8_ = parseInt(_loc7_.substr(1));
                     }
                     _loc3_ = _loc3_ + String.fromCharCode(_loc8_);
                     _loc4_ = _loc5_ + 1;
                  }
                  else
                  {
                     _loc3_ = _loc3_ + "&";
                  }
               }
               else
               {
                  switch(_loc7_)
                  {
                     case "amp":
                        _loc8_ = 38;
                        break;
                     case "apos":
                        _loc8_ = 39;
                        break;
                     case "gt":
                        _loc8_ = 62;
                        break;
                     case "lt":
                        _loc8_ = 60;
                        break;
                     case "nbsp":
                        _loc8_ = 32;
                        break;
                     case "quot":
                        _loc8_ = 34;
                  }
                  if(_loc8_ > 0)
                  {
                     _loc3_ = _loc3_ + String.fromCharCode(_loc8_);
                     _loc4_ = _loc5_ + 1;
                  }
                  else
                  {
                     _loc3_ = _loc3_ + "&";
                  }
               }
            }
            else
            {
               _loc3_ = _loc3_ + "&";
            }
         }
         _loc3_ = _loc3_ + param1.substr(_loc4_);
         return _loc3_;
      }
      
      public static function toFixed(param1:Number, param2:int = 2) : String
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param2 == 0)
         {
            return param1.toFixed(0);
         }
         _loc3_ = param1.toFixed(param2);
         _loc4_ = _loc3_.length;
         _loc5_ = 1;
         while(_loc5_ <= param2)
         {
            if(_loc3_.charCodeAt(_loc4_ - _loc5_) != 48)
            {
               break;
            }
            _loc5_++;
         }
         if(_loc5_ != 1)
         {
            if(_loc5_ > param2)
            {
               _loc3_ = _loc3_.substr(0,_loc4_ - _loc5_);
            }
            else
            {
               _loc3_ = _loc3_.substr(0,_loc4_ - _loc5_ + 1);
            }
         }
         return _loc3_;
      }
      
      public static function getNameFromId(param1:String) : String
      {
         var _loc2_:int = param1.indexOf("_");
         if(_loc2_ != -1)
         {
            return param1.substring(0,_loc2_);
         }
         return param1;
      }
   }
}
