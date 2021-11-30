package fairygui.editor.utils
{
   public class UtilsColor
   {
       
      
      public function UtilsColor()
      {
         super();
      }
      
      public static function RGBtoHSB(param1:int, param2:int, param3:int) : Object
      {
         var _loc6_:Object = {};
         var _loc4_:Number = Math.max(param1,param2,param3);
         var _loc5_:Number = Math.min(param1,param2,param3);
         _loc6_.s = _loc4_ != 0?(_loc4_ - _loc5_) / _loc4_ * 100:0;
         _loc6_.b = _loc4_ / 255 * 100;
         if(_loc6_.s == 0)
         {
            _loc6_.h = 0;
         }
         else
         {
            var _loc7_:* = _loc4_;
            if(param1 !== _loc7_)
            {
               if(param2 !== _loc7_)
               {
                  if(param3 === _loc7_)
                  {
                     _loc6_.h = (param1 - param2) / (_loc4_ - _loc5_) * 60 + 240;
                  }
               }
               else
               {
                  _loc6_.h = (param3 - param1) / (_loc4_ - _loc5_) * 60 + 120;
               }
            }
            else
            {
               _loc6_.h = (param2 - param3) / (_loc4_ - _loc5_) * 60 + 0;
            }
         }
         _loc6_.h = Math.min(360,Math.max(0,_loc6_.h));
         _loc6_.s = Math.min(100,Math.max(0,_loc6_.s));
         _loc6_.b = Math.min(100,Math.max(0,_loc6_.b));
         return _loc6_;
      }
      
      public static function HSBtoRGB(param1:int, param2:int, param3:int) : Object
      {
         var _loc6_:Number = NaN;
         var _loc7_:Object = {};
         var _loc4_:Number = param3 * 0.01 * 255;
         var _loc5_:Number = _loc4_ * (1 - param2 * 0.01);
         if(param1 == 360)
         {
            param1 = 0;
         }
         if(param2 == 0)
         {
            var _loc8_:* = param3 * 2.55;
            _loc7_.b = _loc8_;
            _loc8_ = _loc8_;
            _loc7_.g = _loc8_;
            _loc7_.r = _loc8_;
         }
         else
         {
            _loc6_ = Math.floor(param1 / 60);
            _loc8_ = _loc6_;
            if(0 !== _loc8_)
            {
               if(1 !== _loc8_)
               {
                  if(2 !== _loc8_)
                  {
                     if(3 !== _loc8_)
                     {
                        if(4 !== _loc8_)
                        {
                           if(5 !== _loc8_)
                           {
                              if(6 === _loc8_)
                              {
                                 _loc7_.r = _loc4_;
                                 _loc7_.g = _loc5_ + param1 * (_loc4_ - _loc5_) / 60;
                                 _loc7_.b = _loc5_;
                              }
                           }
                           else
                           {
                              _loc7_.r = _loc4_;
                              _loc7_.g = _loc5_;
                              _loc7_.b = _loc4_ - (param1 - 300) * (_loc4_ - _loc5_) / 60;
                           }
                        }
                        else
                        {
                           _loc7_.r = _loc5_ + (param1 - 240) * (_loc4_ - _loc5_) / 60;
                           _loc7_.g = _loc5_;
                           _loc7_.b = _loc4_;
                        }
                     }
                     else
                     {
                        _loc7_.r = _loc5_;
                        _loc7_.g = _loc4_ - (param1 - 180) * (_loc4_ - _loc5_) / 60;
                        _loc7_.b = _loc4_;
                     }
                  }
                  else
                  {
                     _loc7_.r = _loc5_;
                     _loc7_.g = _loc4_;
                     _loc7_.b = _loc5_ + (param1 - 120) * (_loc4_ - _loc5_) / 60;
                  }
               }
               else
               {
                  _loc7_.r = _loc4_ - (param1 - 60) * (_loc4_ - _loc5_) / 60;
                  _loc7_.g = _loc4_;
                  _loc7_.b = _loc5_;
               }
            }
            else
            {
               _loc7_.r = _loc4_;
               _loc7_.g = _loc5_ + param1 * (_loc4_ - _loc5_) / 60;
               _loc7_.b = _loc5_;
            }
            _loc7_.r = Math.min(255,Math.max(0,_loc7_.r));
            _loc7_.g = Math.min(255,Math.max(0,_loc7_.g));
            _loc7_.b = Math.min(255,Math.max(0,_loc7_.b));
         }
         return _loc7_;
      }
   }
}
