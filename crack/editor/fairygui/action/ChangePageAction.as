package fairygui.action
{
   import fairygui.Controller;
   import fairygui.GComponent;
   
   public class ChangePageAction extends ControllerAction
   {
       
      
      public var objectId:String;
      
      public var controllerName:String;
      
      public var targetPage:String;
      
      public function ChangePageAction()
      {
         super();
      }
      
      override protected function enter(param1:Controller) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         if(!controllerName)
         {
            return;
         }
         if(objectId)
         {
            _loc2_ = param1.parent.getChildById(objectId) as GComponent;
         }
         else
         {
            _loc2_ = param1.parent;
         }
         if(_loc2_)
         {
            _loc3_ = _loc2_.getController(controllerName);
            if(_loc3_ && _loc3_ != param1 && !_loc3_.changing)
            {
               _loc3_.selectedPageId = targetPage;
            }
         }
      }
      
      override public function setup(param1:XML) : void
      {
         super.setup(param1);
         objectId = param1.@objectId;
         controllerName = param1.@controller;
         targetPage = param1.@targetPage;
      }
   }
}
