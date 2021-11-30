package fairygui.editor.dialogs
{
   import fairygui.GButton;
   import fairygui.GObject;
   import fairygui.editor.gui.EControllerPage;
   import flash.events.Event;
   
   public class ControllerPageItem extends GButton
   {
       
      
      private var _page:EControllerPage;
      
      public function ControllerPageItem()
      {
         super();
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
         getChild("name").addEventListener("__submit",this.__propChanged);
      }
      
      public function setIndex(param1:int) : void
      {
         getChild("index").text = "" + param1;
      }
      
      public function setPage(param1:EControllerPage) : void
      {
         this._page = param1;
         this.setObjectToUI();
      }
      
      public function setObjectToUI() : void
      {
         getChild("name").text = this._page.name;
      }
      
      protected function __propChanged(param1:Event) : void
      {
         var _loc2_:GObject = GObject(param1.currentTarget);
         this._page.name = _loc2_.text;
      }
   }
}
