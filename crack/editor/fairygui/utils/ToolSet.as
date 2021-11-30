package fairygui.utils
{
   import fairygui.GObject;
   import fairygui.display.UIDisplayObject;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Stage;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ToolSet
   {
      
      public static var GRAY_FILTERS:Array = [new ColorMatrixFilter([0.299,0.587,0.114,0,0,0.299,0.587,0.114,0,0,0.299,0.587,0.114,0,0,0,0,0,1,0])];
      
      public static const RAD_TO_DEG:Number = 57.29577951308232;
      
      public static const DEG_TO_RAD:Number = 0.017453292519943295;
      
      public static var defaultUBBParser:UBBParser = new UBBParser();
      
      private static var tileIndice:Array = [-1,0,-1,2,4,3,-1,1,-1];
       
      
      public function ToolSet()
      {
         super();
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
      
      public static function trim(param1:String) : String
      {
         return trimLeft(trimRight(param1));
      }
      
      public static function trimLeft(param1:String) : String
      {
         var _loc3_:int = 0;
         var _loc2_:String = "";
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = param1.charAt(_loc3_);
            if(!(_loc2_ != " " && _loc2_ != "\n" && _loc2_ != "\r"))
            {
               _loc3_++;
               continue;
            }
            break;
         }
         return param1.substr(_loc3_);
      }
      
      public static function trimRight(param1:String) : String
      {
         var _loc3_:int = 0;
         var _loc2_:String = "";
         _loc3_ = param1.length - 1;
         while(_loc3_ >= 0)
         {
            _loc2_ = param1.charAt(_loc3_);
            if(!(_loc2_ != " " && _loc2_ != "\n" && _loc2_ != "\r"))
            {
               _loc3_--;
               continue;
            }
            break;
         }
         return param1.substring(0,_loc3_ + 1);
      }
      
      public static function convertToHtmlColor(param1:uint, param2:Boolean = false) : String
      {
         var _loc6_:* = null;
         if(param2)
         {
            _loc6_ = (param1 >> 24 & 255).toString(16);
         }
         else
         {
            _loc6_ = "";
         }
         var _loc3_:String = (param1 >> 16 & 255).toString(16);
         var _loc5_:String = (param1 >> 8 & 255).toString(16);
         var _loc4_:String = (param1 & 255).toString(16);
         if(_loc6_.length == 1)
         {
            _loc6_ = "0" + _loc6_;
         }
         if(_loc3_.length == 1)
         {
            _loc3_ = "0" + _loc3_;
         }
         if(_loc5_.length == 1)
         {
            _loc5_ = "0" + _loc5_;
         }
         if(_loc4_.length == 1)
         {
            _loc4_ = "0" + _loc4_;
         }
         return "#" + _loc6_ + _loc3_ + _loc5_ + _loc4_;
      }
      
      public static function convertFromHtmlColor(param1:String, param2:Boolean = false) : uint
      {
         if(param1.length < 1)
         {
            return 0;
         }
         if(param1.charAt(0) == "#")
         {
            param1 = param1.substr(1);
         }
         if(param1.length == 8)
         {
            return (parseInt(param1.substr(0,2),16) << 24) + parseInt(param1.substr(2),16);
         }
         if(param2)
         {
            return 4278190080 + parseInt(param1,16);
         }
         return parseInt(param1,16);
      }
      
      public static function encodeHTML(param1:String) : String
      {
         if(!param1)
         {
            return "";
         }
         return param1.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/'/g,"&apos;");
      }
      
      public static function parseUBB(param1:String) : String
      {
         return defaultUBBParser.parse(param1);
      }
      
      public static function scaleBitmapWith9Grid(param1:BitmapData, param2:Rectangle, param3:int, param4:int, param5:Boolean = false, param6:int = 0) : BitmapData
      {
         var _loc15_:* = null;
         var _loc19_:* = null;
         var _loc18_:Number = NaN;
         var _loc9_:* = null;
         var _loc14_:* = null;
         var _loc11_:int = 0;
         var _loc10_:int = 0;
         var _loc12_:int = 0;
         var _loc17_:* = null;
         if(param3 == 0 || param4 == 0)
         {
            return new BitmapData(1,1,param1.transparent,0);
         }
         var _loc16_:BitmapData = new BitmapData(param3,param4,param1.transparent,0);
         var _loc13_:Array = [0,param2.top,param2.bottom,param1.height];
         var _loc7_:Array = [0,param2.left,param2.right,param1.width];
         if(param4 >= param1.height - param2.height)
         {
            _loc15_ = [0,param2.top,param4 - (param1.height - param2.bottom),param4];
         }
         else
         {
            _loc18_ = param2.top / (param1.height - param2.bottom);
            _loc18_ = param4 * _loc18_ / (1 + _loc18_);
            _loc15_ = [0,_loc18_,_loc18_,param4];
         }
         if(param3 >= param1.width - param2.width)
         {
            _loc19_ = [0,param2.left,param3 - (param1.width - param2.right),param3];
         }
         else
         {
            _loc18_ = param2.left / (param1.width - param2.right);
            _loc18_ = param3 * _loc18_ / (1 + _loc18_);
            _loc19_ = [0,_loc18_,_loc18_,param3];
         }
         var _loc8_:Matrix = new Matrix();
         _loc11_ = 0;
         while(_loc11_ < 3)
         {
            _loc10_ = 0;
            while(_loc10_ < 3)
            {
               _loc9_ = new Rectangle(_loc7_[_loc11_],_loc13_[_loc10_],_loc7_[_loc11_ + 1] - _loc7_[_loc11_],_loc13_[_loc10_ + 1] - _loc13_[_loc10_]);
               _loc14_ = new Rectangle(_loc19_[_loc11_],_loc15_[_loc10_],_loc19_[_loc11_ + 1] - _loc19_[_loc11_],_loc15_[_loc10_ + 1] - _loc15_[_loc10_]);
               _loc12_ = tileIndice[_loc10_ * 3 + _loc11_];
               if(_loc12_ != -1 && (param6 & 1 << _loc12_) != 0)
               {
                  _loc17_ = tileBitmap(param1,_loc9_,_loc14_.width,_loc14_.height);
                  _loc16_.copyPixels(_loc17_,_loc17_.rect,_loc14_.topLeft);
                  _loc17_.dispose();
               }
               else
               {
                  _loc8_.identity();
                  _loc8_.a = _loc14_.width / _loc9_.width;
                  _loc8_.d = _loc14_.height / _loc9_.height;
                  _loc8_.tx = _loc14_.x - _loc9_.x * _loc8_.a;
                  _loc8_.ty = _loc14_.y - _loc9_.y * _loc8_.d;
                  _loc16_.draw(param1,_loc8_,null,null,_loc14_,param5);
               }
               _loc10_++;
            }
            _loc11_++;
         }
         return _loc16_;
      }
      
      public static function tileBitmap(param1:BitmapData, param2:Rectangle, param3:int, param4:int) : BitmapData
      {
         var _loc10_:int = 0;
         var _loc8_:int = 0;
         if(param3 == 0 || param4 == 0)
         {
            return new BitmapData(1,1,param1.transparent,0);
         }
         var _loc5_:BitmapData = new BitmapData(param3,Math.abs(param4),param1.transparent,0);
         var _loc9_:int = Math.ceil(param3 / param2.width);
         var _loc7_:int = Math.ceil(param4 / param2.height);
         var _loc6_:Point = new Point();
         _loc10_ = 0;
         while(_loc10_ < _loc9_)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc6_.x = _loc10_ * param2.width;
               _loc6_.y = _loc8_ * param2.height;
               _loc5_.copyPixels(param1,param2,_loc6_);
               _loc8_++;
            }
            _loc10_++;
         }
         return _loc5_;
      }
      
      public static function displayObjectToGObject(param1:DisplayObject) : GObject
      {
         while(param1 != null && !(param1 is Stage))
         {
            if(param1 is UIDisplayObject)
            {
               return UIDisplayObject(param1).owner;
            }
            param1 = param1.parent;
         }
         return null;
      }
      
      public static function clamp(param1:Number, param2:Number, param3:Number) : Number
      {
         if(param1 < param2)
         {
            param1 = param2;
         }
         else if(param1 > param3)
         {
            param1 = param3;
         }
         return param1;
      }
      
      public static function clamp01(param1:Number) : Number
      {
         if(param1 > 1)
         {
            param1 = 1;
         }
         else if(param1 < 0)
         {
            param1 = 0;
         }
         return param1;
      }
   }
}
