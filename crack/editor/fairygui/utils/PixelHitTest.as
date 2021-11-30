package fairygui.utils
{
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class PixelHitTest
   {
       
      
      private var _data:PixelHitTestData;
      
      public var offsetX:int;
      
      public var offsetY:int;
      
      private var _shape:Shape;
      
      public function PixelHitTest(param1:PixelHitTestData, param2:int = 0, param3:int = 0)
      {
         super();
         _data = param1;
         this.offsetX = param2;
         this.offsetY = param3;
      }
      
      public function createHitAreaSprite() : Sprite
      {
         var _loc1_:* = null;
         var _loc4_:* = undefined;
         var _loc2_:int = 0;
         var _loc6_:int = 0;
         var _loc9_:int = 0;
         var _loc3_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(_shape == null)
         {
            _shape = new Shape();
            _loc1_ = _shape.graphics;
            _loc1_.beginFill(0,0);
            _loc1_.lineStyle(0,0,0);
            _loc4_ = _data.pixels;
            _loc2_ = _loc4_.length;
            _loc6_ = _data.pixelWidth;
            _loc9_ = 0;
            while(_loc9_ < _loc2_)
            {
               _loc3_ = _loc4_[_loc9_];
               _loc7_ = 0;
               while(_loc7_ < 8)
               {
                  if((_loc3_ >> _loc7_ & 1) == 1)
                  {
                     _loc8_ = _loc9_ * 8 + _loc7_;
                     _loc1_.drawRect(_loc8_ % _loc6_,int(_loc8_ / _loc6_),1,1);
                  }
                  _loc7_++;
               }
               _loc9_++;
            }
            _loc1_.endFill();
         }
         var _loc5_:Sprite = new Sprite();
         _loc5_.mouseEnabled = false;
         _loc5_.x = offsetX;
         _loc5_.y = offsetY;
         _loc5_.graphics.copyFrom(_shape.graphics);
         var _loc10_:* = _data.scale;
         _loc5_.scaleY = _loc10_;
         _loc5_.scaleX = _loc10_;
         return _loc5_;
      }
   }
}
