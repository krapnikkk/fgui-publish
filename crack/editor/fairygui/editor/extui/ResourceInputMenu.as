package fairygui.editor.extui
{
   import fairygui.GLabel;
   import fairygui.GObject;
   import fairygui.PopupMenu;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.event.ItemEvent;
   import flash.desktop.Clipboard;
   
   public class ResourceInputMenu
   {
       
      
      private var _menu:PopupMenu;
      
      private var _input:GLabel;
      
      private var _editorWindow:EditorWindow;
      
      public function ResourceInputMenu(param1:EditorWindow)
      {
         super();
         this._editorWindow = param1;
         this._menu = new PopupMenu();
         this._menu.addItem(Consts.g.text62,this.__showInLib);
         this._menu.addItem(Consts.g.text230,this.__open);
         this._menu.addItem(Consts.g.text63,this.__copyURL);
         this._menu.addItem(Consts.g.text64,this.__clear).name = "clear";
      }
      
      public function show(param1:GLabel, param2:GObject = null, param3:Boolean = true) : void
      {
         if(param2 == null)
         {
            param2 = param1;
         }
         this._input = param1;
         this._menu.setItemGrayed("clear",!param3);
         this._menu.show(param2);
      }
      
      private function __showInLib(param1:ItemEvent) : void
      {
         var _loc3_:String = this._input.text;
         if(!UtilsStr.startsWith(_loc3_,"ui://"))
         {
            return;
         }
         var _loc2_:EPackageItem = this._editorWindow.project.getItemByURL(_loc3_);
         if(_loc2_)
         {
            this._editorWindow.mainPanel.libPanel.highlightItem(_loc2_);
         }
      }
      
      private function __open(param1:ItemEvent) : void
      {
         var _loc2_:EPackageItem = null;
         var _loc3_:String = this._input.text;
         if(UtilsStr.startsWith(_loc3_,"ui://"))
         {
            _loc2_ = this._editorWindow.project.getItemByURL(_loc3_);
            if(_loc2_ != null)
            {
               this._editorWindow.mainPanel.openItem(_loc2_);
            }
         }
      }
      
      private function __copyURL(param1:ItemEvent) : void
      {
         var _loc2_:String = this._input.text;
         Clipboard.generalClipboard.setData("air:text",_loc2_);
      }
      
      private function __clear(param1:ItemEvent) : void
      {
         this._input.text = "";
         this._input.dispatchEvent(new SubmitEvent("__submit"));
      }
   }
}
