package fairygui.tween
{
   public class EaseManager
   {
      
      private static const _PiOver2:Number = 1.5707963267948966;
      
      private static const _TwoPi:Number = 6.283185307179586;
       
      
      public function EaseManager()
      {
         super();
      }
      
      public static function evaluate(param1:int, param2:Number, param3:Number, param4:Number, param5:Number) : Number
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc9_:* = param1;
         if(0 !== _loc9_)
         {
            if(1 !== _loc9_)
            {
               if(2 !== _loc9_)
               {
                  if(3 !== _loc9_)
                  {
                     if(4 !== _loc9_)
                     {
                        if(5 !== _loc9_)
                        {
                           if(6 !== _loc9_)
                           {
                              if(7 !== _loc9_)
                              {
                                 if(8 !== _loc9_)
                                 {
                                    if(9 !== _loc9_)
                                    {
                                       if(10 !== _loc9_)
                                       {
                                          if(11 !== _loc9_)
                                          {
                                             if(12 !== _loc9_)
                                             {
                                                if(13 !== _loc9_)
                                                {
                                                   if(14 !== _loc9_)
                                                   {
                                                      if(15 !== _loc9_)
                                                      {
                                                         if(16 !== _loc9_)
                                                         {
                                                            if(17 !== _loc9_)
                                                            {
                                                               if(18 !== _loc9_)
                                                               {
                                                                  if(19 !== _loc9_)
                                                                  {
                                                                     if(20 !== _loc9_)
                                                                     {
                                                                        if(21 !== _loc9_)
                                                                        {
                                                                           if(22 !== _loc9_)
                                                                           {
                                                                              if(23 !== _loc9_)
                                                                              {
                                                                                 if(24 !== _loc9_)
                                                                                 {
                                                                                    if(25 !== _loc9_)
                                                                                    {
                                                                                       if(26 !== _loc9_)
                                                                                       {
                                                                                          if(27 !== _loc9_)
                                                                                          {
                                                                                             if(28 !== _loc9_)
                                                                                             {
                                                                                                if(29 !== _loc9_)
                                                                                                {
                                                                                                   if(30 !== _loc9_)
                                                                                                   {
                                                                                                      param2 = param2 / param3;
                                                                                                      return -(param2 / param3) * (param2 - 2);
                                                                                                   }
                                                                                                   return Bounce.easeInOut(param2,param3);
                                                                                                }
                                                                                                return Bounce.easeOut(param2,param3);
                                                                                             }
                                                                                             return Bounce.easeIn(param2,param3);
                                                                                          }
                                                                                          param2 = param2 / (param3 * 0.5);
                                                                                          if(param2 / (param3 * 0.5) < 1)
                                                                                          {
                                                                                             param4 = Number(param4 * 1.525);
                                                                                             return 0.5 * (param2 * param2 * ((param4 * 1.525 + 1) * param2 - param4));
                                                                                          }
                                                                                          param2 = param2 - 2;
                                                                                          param4 = Number(param4 * 1.525);
                                                                                          return 0.5 * ((param2 - 2) * param2 * ((param4 * 1.525 + 1) * param2 + param4) + 2);
                                                                                       }
                                                                                       param2 = param2 / param3 - 1;
                                                                                       return (param2 / param3 - 1) * param2 * ((param4 + 1) * param2 + param4) + 1;
                                                                                    }
                                                                                    param2 = param2 / param3;
                                                                                    return param2 / param3 * param2 * ((param4 + 1) * param2 - param4);
                                                                                 }
                                                                                 if(param2 == 0)
                                                                                 {
                                                                                    return 0;
                                                                                 }
                                                                                 param2 = param2 / (param3 * 0.5);
                                                                                 if(param2 / (param3 * 0.5) == 2)
                                                                                 {
                                                                                    return 1;
                                                                                 }
                                                                                 if(param5 == 0)
                                                                                 {
                                                                                    param5 = param3 * 0.45;
                                                                                 }
                                                                                 if(param4 < 1)
                                                                                 {
                                                                                    param4 = 1;
                                                                                    _loc6_ = param5 / 4;
                                                                                 }
                                                                                 else
                                                                                 {
                                                                                    _loc6_ = param5 / 6.28318530717959 * Math.asin(1 / param4);
                                                                                 }
                                                                                 if(param2 < 1)
                                                                                 {
                                                                                    return -0.5 * (param4 * Math.pow(2,10 * --param2) * Math.sin((param2 * param3 - _loc6_) * 6.28318530717959 / param5));
                                                                                 }
                                                                                 return param4 * Math.pow(2,-10 * --param2) * Math.sin((param2 * param3 - _loc6_) * 6.28318530717959 / param5) * 0.5 + 1;
                                                                              }
                                                                              if(param2 == 0)
                                                                              {
                                                                                 return 0;
                                                                              }
                                                                              param2 = param2 / param3;
                                                                              if(param2 / param3 == 1)
                                                                              {
                                                                                 return 1;
                                                                              }
                                                                              if(param5 == 0)
                                                                              {
                                                                                 param5 = param3 * 0.3;
                                                                              }
                                                                              if(param4 < 1)
                                                                              {
                                                                                 param4 = 1;
                                                                                 _loc8_ = param5 / 4;
                                                                              }
                                                                              else
                                                                              {
                                                                                 _loc8_ = param5 / 6.28318530717959 * Math.asin(1 / param4);
                                                                              }
                                                                              return param4 * Math.pow(2,-10 * param2) * Math.sin((param2 * param3 - _loc8_) * 6.28318530717959 / param5) + 1;
                                                                           }
                                                                           if(param2 == 0)
                                                                           {
                                                                              return 0;
                                                                           }
                                                                           param2 = param2 / param3;
                                                                           if(param2 / param3 == 1)
                                                                           {
                                                                              return 1;
                                                                           }
                                                                           if(param5 == 0)
                                                                           {
                                                                              param5 = param3 * 0.3;
                                                                           }
                                                                           if(param4 < 1)
                                                                           {
                                                                              param4 = 1;
                                                                              _loc7_ = param5 / 4;
                                                                           }
                                                                           else
                                                                           {
                                                                              _loc7_ = param5 / 6.28318530717959 * Math.asin(1 / param4);
                                                                           }
                                                                           return -(param4 * Math.pow(2,10 * --param2) * Math.sin((param2 * param3 - _loc7_) * 6.28318530717959 / param5));
                                                                        }
                                                                        param2 = param2 / (param3 * 0.5);
                                                                        if(param2 / (param3 * 0.5) < 1)
                                                                        {
                                                                           return -0.5 * (Math.sqrt(1 - param2 * param2) - 1);
                                                                        }
                                                                        param2 = param2 - 2;
                                                                        return 0.5 * (Math.sqrt(1 - (param2 - 2) * param2) + 1);
                                                                     }
                                                                     param2 = param2 / param3 - 1;
                                                                     return Math.sqrt(1 - (param2 / param3 - 1) * param2);
                                                                  }
                                                                  param2 = param2 / param3;
                                                                  return -(Math.sqrt(1 - param2 / param3 * param2) - 1);
                                                               }
                                                               if(param2 == 0)
                                                               {
                                                                  return 0;
                                                               }
                                                               if(param2 == param3)
                                                               {
                                                                  return 1;
                                                               }
                                                               param2 = param2 / (param3 * 0.5);
                                                               if(param2 / (param3 * 0.5) < 1)
                                                               {
                                                                  return 0.5 * Math.pow(2,10 * (param2 - 1));
                                                               }
                                                               param2--;
                                                               return 0.5 * (-Math.pow(2,-10 * param2) + 2);
                                                            }
                                                            if(param2 == param3)
                                                            {
                                                               return 1;
                                                            }
                                                            return -Math.pow(2,-10 * param2 / param3) + 1;
                                                         }
                                                         return param2 == 0?0:Number(Math.pow(2,10 * (param2 / param3 - 1)));
                                                      }
                                                      param2 = param2 / (param3 * 0.5);
                                                      if(param2 / (param3 * 0.5) < 1)
                                                      {
                                                         return 0.5 * param2 * param2 * param2 * param2 * param2;
                                                      }
                                                      param2 = param2 - 2;
                                                      return 0.5 * ((param2 - 2) * param2 * param2 * param2 * param2 + 2);
                                                   }
                                                   param2 = param2 / param3 - 1;
                                                   return (param2 / param3 - 1) * param2 * param2 * param2 * param2 + 1;
                                                }
                                                param2 = param2 / param3;
                                                return param2 / param3 * param2 * param2 * param2 * param2;
                                             }
                                             param2 = param2 / (param3 * 0.5);
                                             if(param2 / (param3 * 0.5) < 1)
                                             {
                                                return 0.5 * param2 * param2 * param2 * param2;
                                             }
                                             param2 = param2 - 2;
                                             return -0.5 * ((param2 - 2) * param2 * param2 * param2 - 2);
                                          }
                                          param2 = param2 / param3 - 1;
                                          return -((param2 / param3 - 1) * param2 * param2 * param2 - 1);
                                       }
                                       param2 = param2 / param3;
                                       return param2 / param3 * param2 * param2 * param2;
                                    }
                                    param2 = param2 / (param3 * 0.5);
                                    if(param2 / (param3 * 0.5) < 1)
                                    {
                                       return 0.5 * param2 * param2 * param2;
                                    }
                                    param2 = param2 - 2;
                                    return 0.5 * ((param2 - 2) * param2 * param2 + 2);
                                 }
                                 param2 = param2 / param3 - 1;
                                 return (param2 / param3 - 1) * param2 * param2 + 1;
                              }
                              param2 = param2 / param3;
                              return param2 / param3 * param2 * param2;
                           }
                           param2 = param2 / (param3 * 0.5);
                           if(param2 / (param3 * 0.5) < 1)
                           {
                              return 0.5 * param2 * param2;
                           }
                           param2--;
                           return -0.5 * (param2 * (param2 - 2) - 1);
                        }
                        param2 = param2 / param3;
                        return -(param2 / param3) * (param2 - 2);
                     }
                     param2 = param2 / param3;
                     return param2 / param3 * param2;
                  }
                  return -0.5 * (Math.cos(3.14159265358979 * param2 / param3) - 1);
               }
               return Math.sin(param2 / param3 * 1.5707963267949);
            }
            return -Math.cos(param2 / param3 * 1.5707963267949) + 1;
         }
         return param2 / param3;
      }
   }
}

class Bounce
{
    
   
   function Bounce()
   {
      super();
   }
   
   public static function easeIn(param1:Number, param2:Number) : Number
   {
      return 1 - easeOut(param2 - param1,param2);
   }
   
   public static function easeOut(param1:Number, param2:Number) : Number
   {
      param1 = param1 / param2;
      if(param1 / param2 < 0.363636363636364)
      {
         return 7.5625 * param1 * param1;
      }
      if(param1 < 0.727272727272727)
      {
         param1 = param1 - 0.545454545454545;
         return 7.5625 * (param1 - 0.545454545454545) * param1 + 0.75;
      }
      if(param1 < 0.909090909090909)
      {
         param1 = param1 - 0.818181818181818;
         return 7.5625 * (param1 - 0.818181818181818) * param1 + 0.9375;
      }
      param1 = param1 - 0.954545454545455;
      return 7.5625 * (param1 - 0.954545454545455) * param1 + 0.984375;
   }
   
   public static function easeInOut(param1:Number, param2:Number) : Number
   {
      if(param1 < param2 * 0.5)
      {
         return easeIn(param1 * 2,param2) * 0.5;
      }
      return easeOut(param1 * 2 - param2,param2) * 0.5 + 0.5;
   }
}
