package fairygui.gears
{
   import fairygui.tween.GTweener;
   
   public class GearTweenConfig
   {
       
      
      public var tween:Boolean;
      
      public var easeType:int;
      
      public var duration:Number;
      
      public var delay:Number;
      
      var _tweener:GTweener;
      
      var _displayLockToken:uint;
      
      public function GearTweenConfig()
      {
         super();
         tween = true;
         easeType = 5;
         duration = 0.3;
         delay = 0;
         _displayLockToken = 0;
      }
   }
}
