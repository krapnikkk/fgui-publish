package fairygui
{
   public class PageOption
   {
       
      
      private var _controller:Controller;
      
      private var _id:String;
      
      public function PageOption()
      {
         super();
      }
      
      public function set controller(param1:Controller) : void
      {
         _controller = param1;
      }
      
      public function set index(param1:int) : void
      {
         _id = _controller.getPageId(param1);
      }
      
      public function set name(param1:String) : void
      {
         _id = _controller.getPageIdByName(param1);
      }
      
      public function get index() : int
      {
         if(_id)
         {
            return _controller.getPageIndexById(_id);
         }
         return -1;
      }
      
      public function get name() : String
      {
         if(_id)
         {
            return _controller.getPageNameById(_id);
         }
         return null;
      }
      
      public function clear() : void
      {
         _id = null;
      }
      
      public function set id(param1:String) : void
      {
         _id = param1;
      }
      
      public function get id() : String
      {
         return _id;
      }
   }
}
