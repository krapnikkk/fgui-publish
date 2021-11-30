package fairygui.utils
{
   public class UtilsColor
   {
       
      
      public function UtilsColor()
      {
         super();
      }
      
      public static function RGBtoHSB(param1:int, param2:int, param3:int) : Object
      {
         var _loc4_:Object = new Object();
         var _loc5_:Number = Math.max(param1,param2,param3);
         var _loc6_:Number = Math.min(param1,param2,param3);
         _loc4_.s = _loc5_ != 0?(_loc5_ - _loc6_) / _loc5_ * 100:0;
         _loc4_.b = _loc5_ / 255 * 100;
         if(_loc4_.s == 0)
         {
            _loc4_.h = 0;
         }
         else
         {
            switch(_loc5_)
            {
               case param1:
                  _loc4_.h = (param2 - param3) / (_loc5_ - _loc6_) * 60 + 0;
                  break;
               case param2:
                  _loc4_.h = (param3 - param1) / (_loc5_ - _loc6_) * 60 + 120;
                  break;
               case param3:
                  _loc4_.h = (param1 - param2) / (_loc5_ - _loc6_) * 60 + 240;
            }
         }
         _loc4_.h = Math.min(360,Math.max(0,_loc4_.h));
         _loc4_.s = Math.min(100,Math.max(0,_loc4_.s));
         _loc4_.b = Math.min(100,Math.max(0,_loc4_.b));
         return _loc4_;
      }
      
      public static function HSBtoRGB(param1:int, param2:int, param3:int) : Object
      {
         var _loc7_:Number = NaN;
         var _loc4_:Object = new Object();
         var _loc5_:Number = param3 * 0.01 * 255;
         var _loc6_:Number = _loc5_ * (1 - param2 * 0.01);
         if(param1 == 360)
         {
            param1 = 0;
         }
         if(param2 == 0)
         {
            _loc4_.r = _loc4_.g = _loc4_.b = param3 * (255 * 0.01);
         }
         else
         {
            _loc7_ = Math.floor(param1 / 60);
            switch(_loc7_)
            {
               case 0:
                  _loc4_.r = _loc5_;
                  _loc4_.g = _loc6_ + param1 * (_loc5_ - _loc6_) / 60;
                  _loc4_.b = _loc6_;
                  break;
               case 1:
                  _loc4_.r = _loc5_ - (param1 - 60) * (_loc5_ - _loc6_) / 60;
                  _loc4_.g = _loc5_;
                  _loc4_.b = _loc6_;
                  break;
               case 2:
                  _loc4_.r = _loc6_;
                  _loc4_.g = _loc5_;
                  _loc4_.b = _loc6_ + (param1 - 120) * (_loc5_ - _loc6_) / 60;
                  break;
               case 3:
                  _loc4_.r = _loc6_;
                  _loc4_.g = _loc5_ - (param1 - 180) * (_loc5_ - _loc6_) / 60;
                  _loc4_.b = _loc5_;
                  break;
               case 4:
                  _loc4_.r = _loc6_ + (param1 - 240) * (_loc5_ - _loc6_) / 60;
                  _loc4_.g = _loc6_;
                  _loc4_.b = _loc5_;
                  break;
               case 5:
                  _loc4_.r = _loc5_;
                  _loc4_.g = _loc6_;
                  _loc4_.b = _loc5_ - (param1 - 300) * (_loc5_ - _loc6_) / 60;
                  break;
               case 6:
                  _loc4_.r = _loc5_;
                  _loc4_.g = _loc6_ + param1 * (_loc5_ - _loc6_) / 60;
                  _loc4_.b = _loc6_;
            }
            _loc4_.r = Math.min(255,Math.max(0,_loc4_.r));
            _loc4_.g = Math.min(255,Math.max(0,_loc4_.g));
            _loc4_.b = Math.min(255,Math.max(0,_loc4_.b));
         }
         return _loc4_;
      }
   }
}
