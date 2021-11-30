package fairygui.editor.utils
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
         this.reset();
      }
      
      public static function create(param1:Number, param2:Number, param3:Number, param4:Number) : ColorMatrix
      {
         var _loc5_:ColorMatrix = new ColorMatrix();
         _loc5_.adjustColor(param1,param2,param3,param4);
         return _loc5_;
      }
      
      public function reset() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < LENGTH)
         {
            this[_loc1_] = IDENTITY_MATRIX[_loc1_];
            _loc1_++;
         }
      }
      
      public function invert() : void
      {
         this.multiplyMatrix([-1,0,0,0,255,0,-1,0,0,255,0,0,-1,0,255,0,0,0,1,0]);
      }
      
      public function adjustColor(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         this.adjustHue(param4);
         this.adjustContrast(param2);
         this.adjustBrightness(param1);
         this.adjustSaturation(param3);
      }
      
      public function adjustBrightness(param1:Number) : void
      {
         param1 = this.cleanValue(param1,1) * 255;
         this.multiplyMatrix([1,0,0,0,param1,0,1,0,0,param1,0,0,1,0,param1,0,0,0,1,0]);
      }
      
      public function adjustContrast(param1:Number) : void
      {
         param1 = this.cleanValue(param1,1);
         var _loc3_:Number = param1 + 1;
         var _loc2_:Number = 128 * (1 - _loc3_);
         this.multiplyMatrix([_loc3_,0,0,0,_loc2_,0,_loc3_,0,0,_loc2_,0,0,_loc3_,0,_loc2_,0,0,0,1,0]);
      }
      
      public function adjustSaturation(param1:Number) : void
      {
         param1 = this.cleanValue(param1,1);
         param1 = param1 + 1;
         var _loc5_:Number = 1 - param1;
         var _loc3_:Number = _loc5_ * 0.299;
         var _loc4_:Number = _loc5_ * 0.587;
         var _loc2_:Number = _loc5_ * 0.114;
         this.multiplyMatrix([_loc3_ + param1,_loc4_,_loc2_,0,0,_loc3_,_loc4_ + param1,_loc2_,0,0,_loc3_,_loc4_,_loc2_ + param1,0,0,0,0,0,1,0]);
      }
      
      public function adjustHue(param1:Number) : void
      {
         param1 = this.cleanValue(param1,1);
         param1 = param1 * 3.14159265358979;
         var _loc3_:Number = Math.cos(param1);
         var _loc2_:Number = Math.sin(param1);
         this.multiplyMatrix([0.299 + _loc3_ * (1 - 0.299) + _loc2_ * -0.299,0.587 + _loc3_ * -0.587 + _loc2_ * -0.587,0.114 + _loc3_ * -0.114 + _loc2_ * (1 - 0.114),0,0,0.299 + _loc3_ * -0.299 + _loc2_ * 0.143,0.587 + _loc3_ * (1 - 0.587) + _loc2_ * 0.14,0.114 + _loc3_ * -0.114 + _loc2_ * -0.283,0,0,0.299 + _loc3_ * -0.299 + _loc2_ * -0.701,0.587 + _loc3_ * -0.587 + _loc2_ * 0.587,0.114 + _loc3_ * (1 - 0.114) + _loc2_ * 0.114,0,0,0,0,0,1,0]);
      }
      
      public function concat(param1:Array) : void
      {
         if(param1.length != LENGTH)
         {
            return;
         }
         this.multiplyMatrix(param1);
      }
      
      public function clone() : ColorMatrix
      {
         var _loc1_:ColorMatrix = new ColorMatrix();
         _loc1_.copyMatrix(this);
         return _loc1_;
      }
      
      protected function copyMatrix(param1:Array) : void
      {
         var _loc3_:Number = LENGTH;
         var _loc2_:uint = 0;
         while(_loc2_ < _loc3_)
         {
            this[_loc2_] = param1[_loc2_];
            _loc2_++;
         }
      }
      
      protected function multiplyMatrix(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc5_:Array = [];
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < 4)
         {
            _loc2_ = 0;
            while(_loc2_ < 5)
            {
               _loc5_[_loc3_ + _loc2_] = param1[_loc3_] * this[_loc2_] + param1[_loc3_ + 1] * this[_loc2_ + 5] + param1[_loc3_ + 2] * this[_loc2_ + 10] + param1[_loc3_ + 3] * this[_loc2_ + 15] + (_loc2_ == 4?param1[_loc3_ + 4]:0);
               _loc2_++;
            }
            _loc3_ = _loc3_ + 5;
            _loc4_++;
         }
         this.copyMatrix(_loc5_);
      }
      
      protected function cleanValue(param1:Number, param2:Number) : Number
      {
         return Math.min(param2,Math.max(-param2,param1));
      }
   }
}
