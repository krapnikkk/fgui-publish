package fairygui.editor.dialogs
{
   import fairygui.GButton;
   import fairygui.GList;
   import fairygui.UIPackage;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.gui.EGComboBox;
   import fairygui.editor.plugin.PlugInInfo;
   import flash.filesystem.File;
   
   public class PlugInManageDialog extends WindowBase
   {
       
      
      private var _comboBox:EGComboBox;
      
      private var _itemList:GList;
      
      public function PlugInManageDialog(param1:EditorWindow)
      {
         param1 = param1;
         var win:EditorWindow = param1;
         super();
         _editorWindow = win;
         this.contentPane = UIPackage.createObject("Builder","PlugInManageDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this._itemList = contentPane.getChild("n19").asList;
         contentPane.getChild("n14").addClickListener(closeEventHandler);
         contentPane.getChild("n41").addClickListener(function():void
         {
            _editorWindow.showWaiting();
            _editorWindow.plugInManager.load(function():void
            {
               _editorWindow.closeWaiting();
               updateList();
            });
         });
         contentPane.getChild("n28").addClickListener(function():void
         {
            var _loc1_:File = new File("app:/plugins");
            if(!_loc1_.exists)
            {
               _loc1_.createDirectory();
            }
            _loc1_.openWithDefaultApplication();
         });
         this.updateList();
      }
      
      private function updateList() : void
      {
         var _loc1_:PlugInInfo = null;
         this._itemList.removeChildrenToPool();
         var _loc3_:int = 0;
         var _loc2_:* = _editorWindow.plugInManager.allPlugins;
         for each(_loc1_ in _editorWindow.plugInManager.allPlugins)
         {
            this.addItem(_loc1_.name,"");
         }
      }
      
      private function addItem(param1:String, param2:String) : void
      {
         var _loc3_:GButton = this._itemList.addItemFromPool().asButton;
         _loc3_.getChild("text").text = param1;
         _loc3_.getChild("value").text = param2;
      }
   }
}
