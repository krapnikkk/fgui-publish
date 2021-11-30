package fairygui.utils
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public class Utils
   {
      
      public static const RAD_TO_DEG:Number = 180 / Math.PI;
      
      public static const DEG_TO_RAD:Number = Math.PI / 180;
      
      private static var sHelperByteArray:ByteArray = new ByteArray();
      
      private static var tileIndice:Array = [-1,0,-1,2,4,3,-1,1,-1];
      
      private static var helperNumberArray:Vector.<Number> = new Vector.<Number>(4);
       
      
      public function Utils()
      {
         super();
      }
      
      public static function equalText(param1:*, param2:*) : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(param1 is Array || param2 is Array)
         {
            return false;
         }
         if(param1 != null)
         {
            _loc3_ = param1.toString();
         }
         else
         {
            _loc3_ = "";
         }
         if(param2 != null)
         {
            _loc4_ = param2.toString();
         }
         else
         {
            _loc4_ = "";
         }
         return _loc3_ == _loc4_;
      }
      
      public static function drawDashedRect(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:int) : void
      {
         drawDashedLine(param1,param2 + 0.5,param3 + 0.5,param2 + param4 - 0.5,param3 + 0.5,param6);
         drawDashedLine(param1,param2 + param4 - 0.5,param3 + 0.5,param2 + param4 - 0.5,param3 + param5 - 0.5,param6);
         drawDashedLine(param1,param2 + 0.5,param3 + 0.5,param2 + 0.5,param3 + param5 - 0.5,param6);
         drawDashedLine(param1,param2 + 0.5,param3 + param5 - 0.5,param2 + param4 - 0.5,param3 + param5 - 0.5,param6);
      }
      
      public static function drawDashedLine(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:int) : void
      {
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc7_:Number = param4 - param2;
         var _loc8_:Number = param5 - param3;
         var _loc9_:Number = Math.sqrt(_loc7_ * _loc7_ + _loc8_ * _loc8_);
         var _loc10_:int = Math.round((_loc9_ / param6 + 1) / 2);
         var _loc11_:Number = _loc7_ / (2 * _loc10_ - 1);
         var _loc12_:Number = _loc8_ / (2 * _loc10_ - 1);
         var _loc13_:uint = 0;
         while(_loc13_ < _loc10_)
         {
            _loc14_ = param2 + 2 * _loc13_ * _loc11_;
            _loc15_ = param3 + 2 * _loc13_ * _loc12_;
            _loc16_ = _loc14_ + _loc11_;
            _loc17_ = _loc15_ + _loc12_;
            param1.moveTo(_loc14_,_loc15_);
            param1.lineTo(_loc16_,_loc17_);
            _loc13_++;
         }
      }
      
      public static function getStringSortKey(param1:String) : String
      {
         var _loc5_:int = 0;
         param1 = param1.toLowerCase();
         sHelperByteArray.length = 0;
         sHelperByteArray.writeMultiByte(param1,"gb2312");
         var _loc2_:int = sHelperByteArray.length;
         sHelperByteArray.position = 0;
         var _loc3_:String = "";
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = sHelperByteArray[_loc4_];
            _loc3_ = _loc3_ + String.fromCharCode(_loc5_);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function scaleBitmapWith9Grid(param1:BitmapData, param2:Rectangle, param3:int, param4:int, param5:Boolean = false, param6:int = 0) : BitmapData
      {
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:Rectangle = null;
         var _loc13_:Rectangle = null;
         var _loc16_:Number = NaN;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:BitmapData = null;
         if(param3 == 0 || param4 == 0)
         {
            return new BitmapData(1,1,param1.transparent,0);
         }
         var _loc7_:BitmapData = new BitmapData(param3,param4,param1.transparent,0);
         var _loc8_:Array = [0,param2.top,param2.bottom,param1.height];
         var _loc9_:Array = [0,param2.left,param2.right,param1.width];
         if(param4 >= param1.height - param2.height)
         {
            _loc10_ = [0,param2.top,param4 - (param1.height - param2.bottom),param4];
         }
         else
         {
            _loc16_ = param2.top / (param1.height - param2.bottom);
            _loc16_ = param4 * _loc16_ / (1 + _loc16_);
            _loc10_ = [0,_loc16_,_loc16_,param4];
         }
         if(param3 >= param1.width - param2.width)
         {
            _loc11_ = [0,param2.left,param3 - (param1.width - param2.right),param3];
         }
         else
         {
            _loc16_ = param2.left / (param1.width - param2.right);
            _loc16_ = param3 * _loc16_ / (1 + _loc16_);
            _loc11_ = [0,_loc16_,_loc16_,param3];
         }
         var _loc14_:Matrix = new Matrix();
         var _loc15_:int = 0;
         while(_loc15_ < 3)
         {
            _loc17_ = 0;
            while(_loc17_ < 3)
            {
               _loc12_ = new Rectangle(_loc9_[_loc15_],_loc8_[_loc17_],_loc9_[_loc15_ + 1] - _loc9_[_loc15_],_loc8_[_loc17_ + 1] - _loc8_[_loc17_]);
               _loc13_ = new Rectangle(_loc11_[_loc15_],_loc10_[_loc17_],_loc11_[_loc15_ + 1] - _loc11_[_loc15_],_loc10_[_loc17_ + 1] - _loc10_[_loc17_]);
               _loc18_ = tileIndice[_loc17_ * 3 + _loc15_];
               if(_loc18_ != -1 && (param6 & 1 << _loc18_) != 0)
               {
                  _loc19_ = Utils.tileBitmap(param1,_loc12_,_loc13_.width,_loc13_.height,param5);
                  _loc7_.copyPixels(_loc19_,_loc19_.rect,_loc13_.topLeft);
                  _loc19_.dispose();
               }
               else
               {
                  _loc14_.identity();
                  _loc14_.a = _loc13_.width / _loc12_.width;
                  _loc14_.d = _loc13_.height / _loc12_.height;
                  _loc14_.tx = _loc13_.x - _loc12_.x * _loc14_.a;
                  _loc14_.ty = _loc13_.y - _loc12_.y * _loc14_.d;
                  _loc7_.draw(param1,_loc14_,null,null,_loc13_,param5);
               }
               _loc17_++;
            }
            _loc15_++;
         }
         return _loc7_;
      }
      
      public static function tileBitmap(param1:BitmapData, param2:Rectangle, param3:int, param4:int, param5:Boolean = false) : BitmapData
      {
         var _loc11_:int = 0;
         if(param3 == 0 || param4 == 0)
         {
            return new BitmapData(1,1,param1.transparent,0);
         }
         var _loc6_:BitmapData = new BitmapData(param3,param4,param1.transparent,0);
         var _loc7_:int = Math.ceil(param3 / param2.width);
         var _loc8_:int = Math.ceil(param4 / param2.height);
         var _loc9_:Point = new Point();
         var _loc10_:int = 0;
         while(_loc10_ < _loc7_)
         {
            _loc11_ = 0;
            while(_loc11_ < _loc8_)
            {
               _loc9_.x = _loc10_ * param2.width;
               _loc9_.y = _loc11_ * param2.height;
               _loc6_.copyPixels(param1,param2,_loc9_);
               _loc11_++;
            }
            _loc10_++;
         }
         return _loc6_;
      }
      
      public static function skew(param1:Matrix, param2:Number, param3:Number) : void
      {
         param2 = param2 * DEG_TO_RAD;
         param3 = param3 * DEG_TO_RAD;
         var _loc4_:Number = Math.sin(param2);
         var _loc5_:Number = Math.cos(param2);
         var _loc6_:Number = Math.sin(param3);
         var _loc7_:Number = Math.cos(param3);
         param1.setTo(param1.a * _loc7_ - param1.b * _loc4_,param1.a * _loc6_ + param1.b * _loc5_,param1.c * _loc7_ - param1.d * _loc4_,param1.c * _loc6_ + param1.d * _loc5_,param1.tx * _loc7_ - param1.ty * _loc4_,param1.tx * _loc6_ + param1.ty * _loc5_);
      }
      
      public static function prependSkew(param1:Matrix, param2:Number, param3:Number) : void
      {
         param2 = param2 * DEG_TO_RAD;
         param3 = param3 * DEG_TO_RAD;
         var _loc4_:Number = Math.sin(param2);
         var _loc5_:Number = Math.cos(param2);
         var _loc6_:Number = Math.sin(param3);
         var _loc7_:Number = Math.cos(param3);
         param1.setTo(param1.a * _loc7_ + param1.c * _loc6_,param1.b * _loc7_ + param1.d * _loc6_,param1.c * _loc5_ - param1.a * _loc4_,param1.d * _loc5_ - param1.b * _loc4_,param1.tx,param1.ty);
      }
      
      public static function genDevCode() : String
      {
         var _loc3_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            _loc3_ = Math.random() * 26;
            _loc1_ = _loc1_ + Math.pow(26,_loc2_) * (_loc3_ + 10);
            _loc2_++;
         }
         _loc1_ = _loc1_ + (int(Math.random() * 1000000) + int(Math.random() * 222640));
         return _loc1_.toString(36);
      }
      
      public static function getBoundsRect(param1:Vector.<Point>, param2:Rectangle) : Rectangle
      {
         if(!param2)
         {
            param2 = new Rectangle();
         }
         helperNumberArray[0] = helperNumberArray[2] = int.MAX_VALUE;
         helperNumberArray[1] = helperNumberArray[3] = int.MIN_VALUE;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _getBoundsRect(param1[_loc3_]);
            _loc3_++;
         }
         param2.setTo(helperNumberArray[0],helperNumberArray[2],helperNumberArray[1] - helperNumberArray[0],helperNumberArray[3] - helperNumberArray[2]);
         return param2;
      }
      
      private static function _getBoundsRect(param1:Point) : void
      {
         if(param1.x < helperNumberArray[0])
         {
            helperNumberArray[0] = param1.x;
         }
         if(param1.x > helperNumberArray[1])
         {
            helperNumberArray[1] = param1.x;
         }
         if(param1.y < helperNumberArray[2])
         {
            helperNumberArray[2] = param1.y;
         }
         if(param1.y > helperNumberArray[3])
         {
            helperNumberArray[3] = param1.y;
         }
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
      
      public static function getNextPowerOfTwo(param1:Number) : int
      {
         var _loc2_:* = 0;
         if(param1 is int && param1 > 0 && (param1 & param1 - 1) == 0)
         {
            return param1;
         }
         _loc2_ = 1;
         param1 = param1 - 1.0e-9;
         while(_loc2_ < param1)
         {
            _loc2_ = _loc2_ << 1;
         }
         return _loc2_;
      }
      
      public static function transformColor(param1:uint, param2:Number, param3:Number, param4:Number) : uint
      {
         return (int(((param1 & 16711680) >> 16) * param2) << 16) + (int(((param1 & 65280) >> 8) * param3) << 8) + int((param1 & 255) * param4);
      }
   }
}
