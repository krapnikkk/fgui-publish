package fairygui.utils
{
   public dynamic class ColorMatrix extends Array
   {
      
      private static const IDENTITY_MATRIX:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
      
      private static const LENGTH:Number = IDENTITY_MATRIX.length;
      
      private static const LUMA_R:Number = 0.299;
      
      private static const LUMA_G:Number = 0.587;
      
      private static const LUMA_B:Number = 0.114;
       
      
      public function ColorMatrix()
      {
         super();
         reset();
      }
      
      public static function create(param1:Number, param2:Number, param3:Number, param4:Number) : ColorMatrix
      {
         var _loc5_:ColorMatrix = new ColorMatrix();
         _loc5_.adjustColor(param1,param2,param3,param4);
         return _loc5_;
      }
      
      public function reset() : void
      {
         var _loc1_:* = 0;
         _loc1_ = uint(0);
         while(_loc1_ < LENGTH)
         {
            this[_loc1_] = IDENTITY_MATRIX[_loc1_];
            _loc1_++;
         }
      }
      
      public function invert() : void
      {
         multiplyMatrix([-1,0,0,0,255,0,-1,0,0,255,0,0,-1,0,255,0,0,0,1,0]);
      }
      
      public function adjustColor(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         adjustHue(param4);
         adjustContrast(param2);
         adjustBrightness(param1);
         adjustSaturation(param3);
      }
      
      public function adjustBrightness(param1:Number) : void
      {
         param1 = cleanValue(param1,1) * 255;
         multiplyMatrix([1,0,0,0,param1,0,1,0,0,param1,0,0,1,0,param1,0,0,0,1,0]);
      }
      
      public function adjustContrast(param1:Number) : void
      {
         param1 = cleanValue(param1,1);
         var _loc2_:Number = param1 + 1;
         var _loc3_:Number = 128 * (1 - _loc2_);
         multiplyMatrix([_loc2_,0,0,0,_loc3_,0,_loc2_,0,0,_loc3_,0,0,_loc2_,0,_loc3_,0,0,0,1,0]);
      }
      
      public function adjustSaturation(param1:Number) : void
      {
         param1 = cleanValue(param1,1);
         param1 = param1 + 1;
         var _loc3_:Number = 1 - param1;
         var _loc4_:Number = _loc3_ * 0.299;
         var _loc2_:Number = _loc3_ * 0.587;
         var _loc5_:Number = _loc3_ * 0.114;
         multiplyMatrix([_loc4_ + param1,_loc2_,_loc5_,0,0,_loc4_,_loc2_ + param1,_loc5_,0,0,_loc4_,_loc2_,_loc5_ + param1,0,0,0,0,0,1,0]);
      }
      
      public function adjustHue(param1:Number) : void
      {
         param1 = cleanValue(param1,1);
         param1 = param1 * 3.14159265358979;
         var _loc2_:Number = Math.cos(param1);
         var _loc3_:Number = Math.sin(param1);
         multiplyMatrix([0.299 + _loc2_ * (1 - 0.299) + _loc3_ * -0.299,0.587 + _loc2_ * -0.587 + _loc3_ * -0.587,0.114 + _loc2_ * -0.114 + _loc3_ * (1 - 0.114),0,0,0.299 + _loc2_ * -0.299 + _loc3_ * 0.143,0.587 + _loc2_ * (1 - 0.587) + _loc3_ * 0.14,0.114 + _loc2_ * -0.114 + _loc3_ * -0.283,0,0,0.299 + _loc2_ * -0.299 + _loc3_ * -0.701,0.587 + _loc2_ * -0.587 + _loc3_ * 0.587,0.114 + _loc2_ * (1 - 0.114) + _loc3_ * 0.114,0,0,0,0,0,1,0]);
      }
      
      public function concat(param1:Array) : void
      {
         if(param1.length != LENGTH)
         {
            return;
         }
         multiplyMatrix(param1);
      }
      
      public function clone() : ColorMatrix
      {
         var _loc1_:ColorMatrix = new ColorMatrix();
         _loc1_.copyMatrix(this);
         return _loc1_;
      }
      
      protected function copyMatrix(param1:Array) : void
      {
         var _loc3_:* = 0;
         var _loc2_:Number = LENGTH;
         _loc3_ = uint(0);
         while(_loc3_ < _loc2_)
         {
            this[_loc3_] = param1[_loc3_];
            _loc3_++;
         }
      }
      
      protected function multiplyMatrix(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:Array = [];
         var _loc5_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < 4)
         {
            _loc4_ = 0;
            while(_loc4_ < 5)
            {
               _loc2_[_loc5_ + _loc4_] = param1[_loc5_] * this[_loc4_] + param1[_loc5_ + 1] * this[_loc4_ + 5] + param1[_loc5_ + 2] * this[_loc4_ + 10] + param1[_loc5_ + 3] * this[_loc4_ + 15] + (_loc4_ == 4?param1[_loc5_ + 4]:0);
               _loc4_++;
            }
            _loc5_ = _loc5_ + 5;
            _loc3_++;
         }
         copyMatrix(_loc2_);
      }
      
      protected function cleanValue(param1:Number, param2:Number) : Number
      {
         return Math.min(param2,Math.max(-param2,param1));
      }
   }
}
