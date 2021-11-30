package fairygui.tween
{
   public class GTween
   {
       
      
      public function GTween()
      {
         super();
      }
      
      public static function to(param1:Number, param2:Number, param3:Number) : GTweener
      {
         return TweenManager.createTween()._to(param1,param2,param3);
      }
      
      public static function to2(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : GTweener
      {
         return TweenManager.createTween()._to2(param1,param2,param3,param4,param5);
      }
      
      public static function to3(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : GTweener
      {
         return TweenManager.createTween()._to3(param1,param2,param3,param4,param5,param6,param7);
      }
      
      public static function to4(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number) : GTweener
      {
         return TweenManager.createTween()._to4(param1,param2,param3,param4,param5,param6,param7,param8,param9);
      }
      
      public static function toColor(param1:uint, param2:uint, param3:Number) : GTweener
      {
         return TweenManager.createTween()._toColor(param1,param2,param3);
      }
      
      public static function delayedCall(param1:Number) : GTweener
      {
         return TweenManager.createTween().setDelay(param1);
      }
      
      public static function shake(param1:Number, param2:Number, param3:Number, param4:Number) : GTweener
      {
         return TweenManager.createTween()._shake(param1,param2,param3,param4);
      }
      
      public static function isTweening(param1:Object, param2:Object) : Boolean
      {
         return TweenManager.isTweening(param1,param2);
      }
      
      public static function kill(param1:Object, param2:Boolean = false, param3:Object = null) : void
      {
         TweenManager.killTweens(param1,param2,null);
      }
      
      public static function getTween(param1:Object, param2:Object = null) : GTweener
      {
         return TweenManager.getTween(param1,param2);
      }
   }
}
