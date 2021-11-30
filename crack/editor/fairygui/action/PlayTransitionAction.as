package fairygui.action
{
   import fairygui.Controller;
   import fairygui.Transition;
   
   public class PlayTransitionAction extends ControllerAction
   {
       
      
      public var transitionName:String;
      
      public var repeat:int;
      
      public var delay:Number;
      
      public var stopOnExit:Boolean;
      
      private var _currentTransition:Transition;
      
      public function PlayTransitionAction()
      {
         super();
         repeat = 1;
         delay = 0;
      }
      
      override protected function enter(param1:Controller) : void
      {
         var _loc2_:Transition = param1.parent.getTransition(transitionName);
         if(_loc2_)
         {
            if(_currentTransition && _currentTransition.playing)
            {
               _loc2_.changeRepeat(repeat);
            }
            else
            {
               _loc2_.play(null,null,repeat,delay);
            }
            _currentTransition = _loc2_;
         }
      }
      
      override protected function leave(param1:Controller) : void
      {
         if(stopOnExit && _currentTransition)
         {
            _currentTransition.stop();
            _currentTransition = null;
         }
      }
      
      override public function setup(param1:XML) : void
      {
         var _loc2_:* = null;
         super.setup(param1);
         transitionName = param1.@transition;
         _loc2_ = param1.@repeat;
         if(_loc2_)
         {
            repeat = parseInt(_loc2_);
         }
         _loc2_ = param1.@delay;
         if(_loc2_)
         {
            delay = parseFloat(_loc2_);
         }
         _loc2_ = param1.@stopOnExit;
         stopOnExit = _loc2_ == "true";
      }
   }
}
