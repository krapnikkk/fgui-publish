package fairygui.action
{
   import fairygui.Controller;
   
   public class ControllerAction
   {
       
      
      public var fromPage:Array;
      
      public var toPage:Array;
      
      public function ControllerAction()
      {
         super();
      }
      
      public static function createAction(param1:String) : ControllerAction
      {
         var _loc2_:* = param1;
         if("play_transition" !== _loc2_)
         {
            if("change_page" !== _loc2_)
            {
               return null;
            }
            return new ChangePageAction();
         }
         return new PlayTransitionAction();
      }
      
      public function run(param1:Controller, param2:String, param3:String) : void
      {
         if((fromPage == null || fromPage.length == 0 || fromPage.indexOf(param2) != -1) && (toPage == null || toPage.length == 0 || toPage.indexOf(param3) != -1))
         {
            enter(param1);
         }
         else
         {
            leave(param1);
         }
      }
      
      protected function enter(param1:Controller) : void
      {
      }
      
      protected function leave(param1:Controller) : void
      {
      }
      
      public function setup(param1:XML) : void
      {
         var _loc2_:* = null;
         _loc2_ = param1.@fromPage;
         if(_loc2_)
         {
            fromPage = _loc2_.split(",");
         }
         _loc2_ = param1.@toPage;
         if(_loc2_)
         {
            toPage = _loc2_.split(",");
         }
      }
   }
}
