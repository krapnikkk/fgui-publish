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
         var _loc3_:* = null;
         var _loc1_:* = undefined;
         var _loc5_:int = 0;
         var _loc4_:int = 0;
         var _loc7_:int = 0;
         var _loc9_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:int = 0;
         if(_shape == null)
         {
            _shape = new Shape();
            _loc3_ = _shape.graphics;
            _loc3_.beginFill(0,0);
            _loc3_.lineStyle(0,0,0);
            _loc1_ = _data.pixels;
            _loc5_ = _loc1_.length;
            _loc4_ = _data.pixelWidth;
            _loc7_ = 0;
            while(_loc7_ < _loc5_)
            {
               _loc9_ = _loc1_[_loc7_];
               _loc8_ = 0;
               while(_loc8_ < 8)
               {
                  if((_loc9_ >> _loc8_ & 1) == 1)
                  {
                     _loc2_ = _loc7_ * 8 + _loc8_;
                     _loc3_.drawRect(_loc2_ % _loc4_,int(_loc2_ / _loc4_),1,1);
                  }
                  _loc8_++;
               }
               _loc7_++;
            }
            _loc3_.endFill();
         }
         var _loc6_:Sprite = new Sprite();
         _loc6_.mouseEnabled = false;
         _loc6_.x = offsetX;
         _loc6_.y = offsetY;
         _loc6_.graphics.copyFrom(_shape.graphics);
         var _loc10_:* = _data.scale;
         _loc6_.scaleY = _loc10_;
         _loc6_.scaleX = _loc10_;
         return _loc6_;
      }
   }
}
