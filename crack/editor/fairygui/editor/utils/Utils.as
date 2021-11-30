package fairygui.editor.utils
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public class Utils
   {
      
      public static const RAD_TO_DEG:Number = 57.29577951308232;
      
      public static const DEG_TO_RAD:Number = 0.017453292519943295;
      
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
         drawDashedLine(param1,param2,param3,param2 + param4,param3,param6);
         drawDashedLine(param1,param2 + param4,param3,param2 + param4,param3 + param5,param6);
         drawDashedLine(param1,param2,param3,param2,param3 + param5,param6);
         drawDashedLine(param1,param2,param3 + param5,param2 + param4,param3 + param5,param6);
      }
      
      public static function drawDashedLine(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:int) : void
      {
         var _loc7_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc17_:Number = param4 - param2;
         var _loc15_:Number = param5 - param3;
         var _loc16_:Number = Math.sqrt(_loc17_ * _loc17_ + _loc15_ * _loc15_);
         var _loc9_:int = Math.round((_loc16_ / param6 + 1) / 2);
         var _loc10_:Number = _loc17_ / (2 * _loc9_ - 1);
         var _loc8_:Number = _loc15_ / (2 * _loc9_ - 1);
         var _loc11_:uint = 0;
         while(_loc11_ < _loc9_)
         {
            _loc7_ = param2 + 2 * _loc11_ * _loc10_;
            _loc13_ = param3 + 2 * _loc11_ * _loc8_;
            _loc14_ = _loc7_ + _loc10_;
            _loc12_ = _loc13_ + _loc8_;
            param1.moveTo(_loc7_,_loc13_);
            param1.lineTo(_loc14_,_loc12_);
            _loc11_++;
         }
      }
      
      public static function getStringSortKey(param1:String) : String
      {
         var _loc2_:int = 0;
         param1 = param1.toLowerCase();
         sHelperByteArray.length = 0;
         sHelperByteArray.writeMultiByte(param1,"gb2312");
         var _loc5_:int = sHelperByteArray.length;
         sHelperByteArray.position = 0;
         var _loc3_:String = "";
         var _loc4_:int = 0;
         while(_loc4_ < _loc5_)
         {
            _loc2_ = sHelperByteArray[_loc4_];
            _loc3_ = _loc3_ + String.fromCharCode(_loc2_);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function scaleBitmapWith9Grid(param1:BitmapData, param2:Rectangle, param3:int, param4:int, param5:Boolean = false, param6:int = 0) : BitmapData
      {
         var _loc8_:Array = null;
         var _loc10_:Array = null;
         var _loc9_:Rectangle = null;
         var _loc11_:Rectangle = null;
         var _loc15_:Number = NaN;
         var _loc13_:int = 0;
         var _loc12_:int = 0;
         var _loc19_:BitmapData = null;
         if(param3 == 0 || param4 == 0)
         {
            return new BitmapData(1,1,param1.transparent,0);
         }
         var _loc18_:BitmapData = new BitmapData(param3,param4,param1.transparent,0);
         var _loc17_:Array = [0,param2.top,param2.bottom,param1.height];
         var _loc16_:Array = [0,param2.left,param2.right,param1.width];
         if(param4 >= param1.height - param2.height)
         {
            _loc8_ = [0,param2.top,param4 - (param1.height - param2.bottom),param4];
         }
         else
         {
            _loc15_ = param2.top / (param1.height - param2.bottom);
            _loc15_ = param4 * _loc15_ / (1 + _loc15_);
            _loc8_ = [0,_loc15_,_loc15_,param4];
         }
         if(param3 >= param1.width - param2.width)
         {
            _loc10_ = [0,param2.left,param3 - (param1.width - param2.right),param3];
         }
         else
         {
            _loc15_ = param2.left / (param1.width - param2.right);
            _loc15_ = param3 * _loc15_ / (1 + _loc15_);
            _loc10_ = [0,_loc15_,_loc15_,param3];
         }
         var _loc7_:Matrix = new Matrix();
         var _loc14_:int = 0;
         while(_loc14_ < 3)
         {
            _loc13_ = 0;
            while(_loc13_ < 3)
            {
               _loc9_ = new Rectangle(_loc16_[_loc14_],_loc17_[_loc13_],_loc16_[_loc14_ + 1] - _loc16_[_loc14_],_loc17_[_loc13_ + 1] - _loc17_[_loc13_]);
               _loc11_ = new Rectangle(_loc10_[_loc14_],_loc8_[_loc13_],_loc10_[_loc14_ + 1] - _loc10_[_loc14_],_loc8_[_loc13_ + 1] - _loc8_[_loc13_]);
               _loc12_ = tileIndice[_loc13_ * 3 + _loc14_];
               if(_loc12_ != -1 && (param6 & 1 << _loc12_) != 0)
               {
                  _loc19_ = Utils.tileBitmap(param1,_loc9_,_loc11_.width,_loc11_.height,param5);
                  _loc18_.copyPixels(_loc19_,_loc19_.rect,_loc11_.topLeft);
                  _loc19_.dispose();
               }
               else
               {
                  _loc7_.identity();
                  _loc7_.a = _loc11_.width / _loc9_.width;
                  _loc7_.d = _loc11_.height / _loc9_.height;
                  _loc7_.tx = _loc11_.x - _loc9_.x * _loc7_.a;
                  _loc7_.ty = _loc11_.y - _loc9_.y * _loc7_.d;
                  _loc18_.draw(param1,_loc7_,null,null,_loc11_,param5);
               }
               _loc13_++;
            }
            _loc14_++;
         }
         return _loc18_;
      }
      
      public static function tileBitmap(param1:BitmapData, param2:Rectangle, param3:int, param4:int, param5:Boolean = false) : BitmapData
      {
         var _loc8_:int = 0;
         if(param3 == 0 || param4 == 0)
         {
            return new BitmapData(1,1,param1.transparent,0);
         }
         var _loc7_:BitmapData = new BitmapData(param3,param4,param1.transparent,0);
         var _loc11_:int = Math.ceil(param3 / param2.width);
         var _loc10_:int = Math.ceil(param4 / param2.height);
         var _loc9_:Point = new Point();
         var _loc6_:int = 0;
         while(_loc6_ < _loc11_)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc10_)
            {
               _loc9_.x = _loc6_ * param2.width;
               _loc9_.y = _loc8_ * param2.height;
               _loc7_.copyPixels(param1,param2,_loc9_);
               _loc8_++;
            }
            _loc6_++;
         }
         return _loc7_;
      }
      
      public static function skew(param1:Matrix, param2:Number, param3:Number) : void
      {
         param2 = param2 * 0.0174532925199433;
         param3 = param3 * 0.0174532925199433;
         var _loc7_:Number = Math.sin(param2);
         var _loc4_:Number = Math.cos(param2);
         var _loc5_:Number = Math.sin(param3);
         var _loc6_:Number = Math.cos(param3);
         param1.setTo(param1.a * _loc6_ - param1.b * _loc7_,param1.a * _loc5_ + param1.b * _loc4_,param1.c * _loc6_ - param1.d * _loc7_,param1.c * _loc5_ + param1.d * _loc4_,param1.tx * _loc6_ - param1.ty * _loc7_,param1.tx * _loc5_ + param1.ty * _loc4_);
      }
      
      public static function prependSkew(param1:Matrix, param2:Number, param3:Number) : void
      {
         param2 = param2 * 0.0174532925199433;
         param3 = param3 * 0.0174532925199433;
         var _loc7_:Number = Math.sin(param2);
         var _loc4_:Number = Math.cos(param2);
         var _loc5_:Number = Math.sin(param3);
         var _loc6_:Number = Math.cos(param3);
         param1.setTo(param1.a * _loc6_ + param1.c * _loc5_,param1.b * _loc6_ + param1.d * _loc5_,param1.c * _loc4_ - param1.a * _loc7_,param1.d * _loc4_ - param1.b * _loc7_,param1.tx,param1.ty);
      }
      
      public static function genDevCode() : String
      {
         var _loc1_:int = 0;
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            _loc1_ = Math.random() * 26;
            _loc3_ = _loc3_ + Math.pow(26,_loc2_) * (_loc1_ + 10);
            _loc2_++;
         }
         _loc3_ = _loc3_ + (int(Math.random() * 1000000) + int(Math.random() * 222640));
         return _loc3_.toString(36);
      }
      
      public static function getBoundsRect(param1:Vector.<Point>, param2:Rectangle) : Rectangle
      {
         if(!param2)
         {
            param2 = new Rectangle();
         }
         var _loc4_:int = 2147483647;
         helperNumberArray[2] = _loc4_;
         helperNumberArray[0] = _loc4_;
         _loc4_ = -2147483648;
         helperNumberArray[3] = _loc4_;
         helperNumberArray[1] = _loc4_;
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
   }
}
