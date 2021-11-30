package fairygui.editor.extui
{
   import fairygui.GObject;
   import fairygui.PopupMenu;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.gui.EGComponent;
   import fairygui.editor.gui.ETransition;
   import fairygui.event.ItemEvent;
   
   public class SelectTransitionMenu
   {
       
      
      private var _menu:PopupMenu;
      
      private var _input:GObject;
      
      private var _editorWindow:EditorWindow;
      
      public function SelectTransitionMenu(param1:EditorWindow)
      {
         super();
         this._editorWindow = param1;
         this._menu = new PopupMenu("ui://Basic/PopupMenu2");
         this._menu.visibleItemCount = 20;
      }
      
      public function show(param1:GObject, param2:EGComponent, param3:GObject = null) : void
      {
         var _loc7_:ETransition = null;
         var _loc6_:GObject = null;
         this._menu.clearItems();
         this._menu.addItem(Consts.g.text331,this.__selectTrans).name = "";
         var _loc8_:Vector.<ETransition> = param2.transitions.items;
         var _loc4_:int = _loc8_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc7_ = _loc8_[_loc5_];
            _loc6_ = this._menu.addItem(_loc7_.name,this.__selectTrans);
            _loc6_.name = _loc7_.name;
            _loc5_++;
         }
         this._input = param1;
         if(param3 == null)
         {
            param3 = param1;
         }
         this._menu.contentPane.width = param3.width;
         this._menu.show(param3);
      }
      
      private function __selectTrans(param1:ItemEvent) : void
      {
         this._menu.hide();
         this._input.text = param1.itemObject.name;
         this._input.dispatchEvent(new SubmitEvent("__submit"));
      }
   }
}
