package fairygui.editor.extui
{
   import fairygui.GComponent;
   import fairygui.GObject;
   import fairygui.PopupMenu;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.gui.EController;
   import fairygui.editor.gui.EControllerPage;
   import fairygui.event.ItemEvent;
   
   public class SelectPageMenu
   {
       
      
      private var _menu:PopupMenu;
      
      private var _input:GObject;
      
      private var _editorWindow:EditorWindow;
      
      public function SelectPageMenu(param1:EditorWindow)
      {
         super();
         this._editorWindow = param1;
         this._menu = new PopupMenu("ui://Basic/PopupMenu2");
         this._menu.visibleItemCount = 20;
      }
      
      public function show(param1:GObject, param2:EController, param3:GObject = null) : void
      {
         var _loc8_:Vector.<EControllerPage> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc7_:EControllerPage = null;
         var _loc6_:GComponent = null;
         this._menu.clearItems();
         this._menu.addItem(Consts.g.text331,this.__selectPage).name = "";
         if(param2 != null)
         {
            _loc8_ = param2.getPages();
            _loc4_ = _loc8_.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc7_ = _loc8_[_loc5_];
               _loc6_ = this._menu.addItem("" + _loc5_ + (!!_loc7_.name?":" + _loc7_.name:""),this.__selectPage).asCom;
               _loc6_.name = _loc7_.id;
               _loc5_++;
            }
         }
         this._input = param1;
         if(param3 == null)
         {
            param3 = param1;
         }
         this._menu.contentPane.width = param3.width;
         this._menu.show(param3);
      }
      
      private function __selectPage(param1:ItemEvent) : void
      {
         this._input.text = param1.itemObject.name;
         this._input.dispatchEvent(new SubmitEvent("__submit"));
      }
   }
}
