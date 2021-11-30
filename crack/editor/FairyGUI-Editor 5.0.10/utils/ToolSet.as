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
         var _loc4_:String = (param1 >> 8 & 255).toString(16);
         var _loc5_:String = (param1 & 255).toString(16);
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
         if(_loc5_.length == 1)
         {
            _loc5_ = "0" + _loc5_;
         }
         return "#" + _loc6_ + _loc3_ + _loc4_ + _loc5_;
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
      
      public static function decodeXML(param1:String) : String
      {
         var _loc7_:int = 0;
         var _loc8_:* = null;
         var _loc4_:int = 0;
         var _loc3_:int = param1.length;
         var _loc2_:* = "";
         var _loc5_:int = 0;
         var _loc6_:* = 0;
         while(true)
         {
            _loc6_ = int(param1.indexOf("&",_loc5_));
            if(_loc6_ == -1)
            {
               break;
            }
            _loc2_ = _loc2_ + param1.substr(_loc5_,_loc6_ - _loc5_);
            _loc5_ = _loc6_ + 1;
            _loc6_ = _loc5_;
            _loc7_ = Math.min(_loc3_,_loc6_ + 10);
            while(_loc6_ < _loc7_)
            {
               if(param1.charCodeAt(_loc6_) != 59)
               {
                  _loc6_++;
                  continue;
               }
               break;
            }
            if(_loc6_ < _loc7_ && _loc6_ > _loc5_)
            {
               _loc8_ = param1.substr(_loc5_,_loc6_ - _loc5_);
               _loc4_ = 0;
               if(_loc8_.charCodeAt(0) == 35)
               {
                  if(_loc8_.length > 1)
                  {
                     if(_loc8_[1] == "x")
                     {
                        _loc4_ = parseInt(_loc8_.substr(2),16);
                     }
                     else
                     {
                        _loc4_ = parseInt(_loc8_.substr(1));
                     }
                     _loc2_ = _loc2_ + String.fromCharCode(_loc4_);
                     _loc5_ = _loc6_ + 1;
                  }
                  else
                  {
                     _loc2_ = _loc2_ + "&";
                  }
               }
               else
               {
                  var _loc9_:* = _loc8_;
                  if("amp" !== _loc9_)
                  {
                     if("apos" !== _loc9_)
                     {
                        if("gt" !== _loc9_)
                        {
                           if("lt" !== _loc9_)
                           {
                              if("nbsp" !== _loc9_)
                              {
                                 if("quot" === _loc9_)
                                 {
                                    _loc4_ = 34;
                                 }
                              }
                              else
                              {
                                 _loc4_ = 32;
                              }
                           }
                           else
                           {
                              _loc4_ = 60;
                           }
                        }
                        else
                        {
                           _loc4_ = 62;
                        }
                     }
                     else
                     {
                        _loc4_ = 39;
                     }
                  }
                  else
                  {
                     _loc4_ = 38;
                  }
                  if(_loc4_ > 0)
                  {
                     _loc2_ = _loc2_ + String.fromCharCode(_loc4_);
                     _loc5_ = _loc6_ + 1;
                  }
                  else
                  {
                     _loc2_ = _loc2_ + "&";
                  }
               }
            }
            else
            {
               _loc2_ = _loc2_ + "&";
            }
         }
         _loc2_ = _loc2_ + param1.substr(_loc5_);
         return _loc2_;
      }
      
      public static function scaleBitmapWith9Grid(param1:BitmapData, param2:Rectangle, param3:int, param4:int, param5:Boolean = false, param6:int = 0) : BitmapData
      {
         var _loc14_:* = null;
         var _loc16_:* = null;
         var _loc17_:Number = NaN;
         var _loc9_:* = null;
         var _loc11_:* = null;
         var _loc15_:int = 0;
         var _loc18_:int = 0;
         var _loc10_:int = 0;
         var _loc13_:* = null;
         if(param3 == 0 || param4 == 0)
         {
            return new BitmapData(1,1,param1.transparent,0);
         }
         var _loc8_:BitmapData = new BitmapData(param3,param4,param1.transparent,0);
         var _loc12_:Array = [0,param2.top,param2.bottom,param1.height];
         var _loc19_:Array = [0,param2.left,param2.right,param1.width];
         if(param4 >= param1.height - param2.height)
         {
            _loc14_ = [0,param2.top,param4 - (param1.height - param2.bottom),param4];
         }
         else
         {
            _loc17_ = param2.top / (param1.height - param2.bottom);
            _loc17_ = param4 * _loc17_ / (1 + _loc17_);
            _loc14_ = [0,_loc17_,_loc17_,param4];
         }
         if(param3 >= param1.width - param2.width)
         {
            _loc16_ = [0,param2.left,param3 - (param1.width - param2.right),param3];
         }
         else
         {
            _loc17_ = param2.left / (param1.width - param2.right);
            _loc17_ = param3 * _loc17_ / (1 + _loc17_);
            _loc16_ = [0,_loc17_,_loc17_,param3];
         }
         var _loc7_:Matrix = new Matrix();
         _loc15_ = 0;
         while(_loc15_ < 3)
         {
            _loc18_ = 0;
            while(_loc18_ < 3)
            {
               _loc9_ = new Rectangle(_loc19_[_loc15_],_loc12_[_loc18_],_loc19_[_loc15_ + 1] - _loc19_[_loc15_],_loc12_[_loc18_ + 1] - _loc12_[_loc18_]);
               _loc11_ = new Rectangle(_loc16_[_loc15_],_loc14_[_loc18_],_loc16_[_loc15_ + 1] - _loc16_[_loc15_],_loc14_[_loc18_ + 1] - _loc14_[_loc18_]);
               _loc10_ = tileIndice[_loc18_ * 3 + _loc15_];
               if(_loc10_ != -1 && (param6 & 1 << _loc10_) != 0)
               {
                  _loc13_ = tileBitmap(param1,_loc9_,_loc11_.width,_loc11_.height);
                  _loc8_.copyPixels(_loc13_,_loc13_.rect,_loc11_.topLeft);
                  _loc13_.dispose();
               }
               else
               {
                  _loc7_.identity();
                  _loc7_.a = _loc11_.width / _loc9_.width;
                  _loc7_.d = _loc11_.height / _loc9_.height;
                  _loc7_.tx = _loc11_.x - _loc9_.x * _loc7_.a;
                  _loc7_.ty = _loc11_.y - _loc9_.y * _loc7_.d;
                  _loc8_.draw(param1,_loc7_,null,null,_loc11_,param5);
               }
               _loc18_++;
            }
            _loc15_++;
         }
         return _loc8_;
      }
      
      public static function tileBitmap(param1:BitmapData, param2:Rectangle, param3:int, param4:int) : BitmapData
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(param3 == 0 || param4 == 0)
         {
            return new BitmapData(1,1,param1.transparent,0);
         }
         var _loc5_:BitmapData = new BitmapData(param3,param4,param1.transparent,0);
         var _loc9_:int = Math.ceil(param3 / param2.width);
         var _loc10_:int = Math.ceil(param4 / param2.height);
         var _loc6_:Point = new Point();
         _loc7_ = 0;
         while(_loc7_ < _loc9_)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc10_)
            {
               _loc6_.x = _loc7_ * param2.width;
               _loc6_.y = _loc8_ * param2.height;
               _loc5_.copyPixels(param1,param2,_loc6_);
               _loc8_++;
            }
            _loc7_++;
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
         if(isNaN(param1) || param1 < param2)
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
         if(isNaN(param1))
         {
            param1 = 0;
         }
         else if(param1 > 1)
         {
            param1 = 1;
         }
         else if(param1 < 0)
         {
            param1 = 0;
         }
         return param1;
      }
      
      public static function lerp(param1:Number, param2:Number, param3:Number) : Number
      {
         return param1 + param3 * (param2 - param1);
      }
      
      public static function distance(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return Math.sqrt(Math.pow(param1 - param3,2) + Math.pow(param2 - param4,2));
      }
      
      public static function repeat(param1:Number, param2:Number) : Number
      {
         return param1 - Math.floor(param1 / param2) * param2;
      }
      
      public static function pointLineDistance(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Boolean) : Number
      {
         var _loc9_:* = NaN;
         var _loc10_:* = NaN;
         var _loc11_:Number = param5 - param3;
         var _loc13_:Number = param6 - param4;
         var _loc8_:Number = _loc11_ * _loc11_ + _loc13_ * _loc13_;
         var _loc12_:Number = ((param1 - param3) * _loc11_ + (param2 - param4) * _loc13_) / _loc8_;
         if(!param7)
         {
            _loc9_ = Number(param3 + _loc12_ * _loc11_);
            _loc10_ = Number(param4 + _loc12_ * _loc13_);
         }
         else if(_loc8_ != 0)
         {
            if(_loc12_ < 0)
            {
               _loc9_ = param3;
               _loc10_ = param4;
            }
            else if(_loc12_ > 1)
            {
               _loc9_ = param5;
               _loc10_ = param6;
            }
            else
            {
               _loc9_ = Number(param3 + _loc12_ * _loc11_);
               _loc10_ = Number(param4 + _loc12_ * _loc13_);
            }
         }
         else
         {
            _loc9_ = param3;
            _loc10_ = param4;
         }
         _loc11_ = param1 - _loc9_;
         _loc13_ = param2 - _loc10_;
         return Math.sqrt(_loc11_ * _loc11_ + _loc13_ * _loc13_);
      }
   }
}
