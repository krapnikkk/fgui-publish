package fairygui.editor.utils
{
   import fairygui.editor.Consts;
   
   public class UtilsStr
   {
      
      private static const FIX:String = (int(Math.random() * 36)).toString(36).substr(0,1);
       
      
      public function UtilsStr()
      {
         super();
      }
      
      public static function getIdFromRid(param1:String) : String
      {
         var _loc2_:int = param1.indexOf("@");
         if(_loc2_ != -1)
         {
            return param1.substring(0,_loc2_);
         }
         return param1;
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
         var _loc5_:int = 0;
         var _loc3_:String = null;
         var _loc4_:int = param1.lastIndexOf("?");
         if(_loc4_ != -1)
         {
            _loc5_ = param1.lastIndexOf(".",_loc4_);
            if(_loc5_ != -1)
            {
               _loc3_ = param1.substring(_loc5_ + 1,_loc4_);
            }
            else
            {
               _loc3_ = "";
            }
         }
         else
         {
            _loc5_ = param1.lastIndexOf(".");
            if(_loc5_ != -1)
            {
               _loc3_ = param1.substr(_loc5_ + 1);
            }
            else
            {
               _loc3_ = "";
            }
         }
         if(!param2)
         {
            _loc3_ = _loc3_.toLowerCase();
         }
         return _loc3_;
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
      
      public static function padString(param1:String, param2:int) : String
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            if(param1.charCodeAt(_loc5_) > 19968 && param1.charCodeAt(_loc5_) < 40869)
            {
               _loc4_++;
            }
            _loc5_++;
         }
         if((int(param1.length + _loc4_)) / 2 < param2)
         {
            _loc3_ = (int(param1.length + _loc4_)) / 2;
            while(_loc3_ < param2)
            {
               param1 = param1 + "　";
               _loc3_++;
            }
         }
         return param1;
      }
      
      public static function trim(param1:String) : String
      {
         return trimLeft(trimRight(param1));
      }
      
      public static function trimLeft(param1:String) : String
      {
         var _loc3_:String = "";
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1.charAt(_loc2_);
            if(!(_loc3_ != " " && _loc3_ != "\n" && _loc3_ != "\r"))
            {
               _loc2_++;
               continue;
            }
            break;
         }
         return param1.substr(_loc2_);
      }
      
      public static function trimRight(param1:String) : String
      {
         var _loc3_:String = "";
         var _loc2_:int = param1.length - 1;
         while(_loc2_ >= 0)
         {
            _loc3_ = param1.charAt(_loc2_);
            if(!(_loc3_ != " " && _loc3_ != "\n" && _loc3_ != "\r"))
            {
               _loc2_--;
               continue;
            }
            break;
         }
         return param1.substring(0,_loc2_ + 1);
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
         var _loc2_:String = "0000" + (int(Math.random() * 1679616)).toString(36);
         var _loc1_:String = "000" + (int(Math.random() * 46656)).toString(36);
         return FIX + _loc2_.substr(_loc2_.length - 4) + _loc1_.substr(_loc1_.length - 3);
      }
      
      public static function convertToHtmlColor(param1:uint, param2:Boolean = false) : String
      {
         var _loc5_:String = null;
         if(param2)
         {
            _loc5_ = (param1 >> 24 & 255).toString(16);
         }
         else
         {
            _loc5_ = "";
         }
         var _loc6_:String = (param1 >> 16 & 255).toString(16);
         var _loc3_:String = (param1 >> 8 & 255).toString(16);
         var _loc4_:String = (param1 & 255).toString(16);
         if(_loc5_.length == 1)
         {
            _loc5_ = "0" + _loc5_;
         }
         if(_loc6_.length == 1)
         {
            _loc6_ = "0" + _loc6_;
         }
         if(_loc3_.length == 1)
         {
            _loc3_ = "0" + _loc3_;
         }
         if(_loc4_.length == 1)
         {
            _loc4_ = "0" + _loc4_;
         }
         return "#" + _loc5_ + _loc6_ + _loc3_ + _loc4_;
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
         var _loc4_:int = param1.length;
         var _loc2_:int = param1.length % 3;
         var _loc3_:* = "";
         _loc3_ = _loc3_ + param1.substring(0,_loc2_);
         while(_loc2_ < _loc4_)
         {
            if(_loc3_.length > 0)
            {
               _loc3_ = _loc3_ + ",";
            }
            _loc3_ = _loc3_ + param1.substr(_loc2_,3);
            _loc2_ = _loc2_ + 3;
         }
         return _loc3_;
      }
      
      public static function formatString(param1:String, ... rest) : String
      {
         param1 = param1;
         rest = rest;
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
         var _loc5_:int = 0;
         var _loc4_:* = param2;
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
         if(param1 < 1048576)
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
            _loc3_ = "" + param1 / 1048576;
            _loc4_ = _loc3_.lastIndexOf(".");
            if(_loc4_ < _loc3_.length - param2)
            {
               _loc3_ = _loc3_.substr(0,_loc4_ + param2);
            }
            _loc3_ = _loc3_ + "M";
         }
         return _loc3_;
      }
      
      public static function getBetweenBrakets(param1:String) : String
      {
         var _loc3_:int = param1.indexOf("(");
         var _loc2_:int = param1.indexOf(")");
         if(_loc3_ != -1 && _loc2_ != -1)
         {
            return param1.substring(_loc3_ + 1,_loc2_);
         }
         return null;
      }
      
      public static function getBetweenSymbol(param1:String, param2:String, param3:String) : String
      {
         var _loc4_:int = 0;
         var _loc5_:int = param1.indexOf(param2);
         if(_loc5_ != -1)
         {
            _loc5_ = _loc5_ + param2.length;
            _loc4_ = param1.indexOf(param3,_loc5_);
            if(_loc4_ != -1)
            {
               return param1.substring(_loc5_,_loc4_);
            }
         }
         return null;
      }
      
      public static function encodeHTML(param1:String) : String
      {
         if(!param1)
         {
            return "";
         }
         return param1.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/'/g,"&apos;");
      }
      
      public static function toFixed(param1:Number, param2:int = 2) : String
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         if(param2 == 0)
         {
            return param1.toFixed(0);
         }
         _loc4_ = param1.toFixed(param2);
         _loc5_ = _loc4_.length;
         _loc3_ = 1;
         while(_loc3_ <= param2)
         {
            if(_loc4_.charCodeAt(_loc5_ - _loc3_) == 48)
            {
               _loc3_++;
               continue;
            }
            break;
         }
         if(_loc3_ != 1)
         {
            if(_loc3_ > param2)
            {
               _loc4_ = _loc4_.substr(0,_loc5_ - _loc3_);
            }
            else
            {
               _loc4_ = _loc4_.substr(0,_loc5_ - _loc3_ + 1);
            }
         }
         return _loc4_;
      }
      
      public static function validateName(param1:String) : String
      {
         param1 = UtilsStr.trim(param1);
         if(param1.length == 0)
         {
            throw new Error(Consts.g.text197);
         }
         if(param1.search(/[\:\/\\\*\?<>\|]/) != -1)
         {
            throw new Error(Consts.g.text196);
         }
         return param1;
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
      
      public static function readableString(param1:String) : String
      {
         return !!param1?param1:Consts.g.text331;
      }
   }
}
