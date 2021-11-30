package fairygui.editor.dialogs.insert
{
   import fairygui.UIPackage;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.dialogs.ChooseFolderDialog;
   import fairygui.editor.gui.ComponentTemplates;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIPackage;
   import flash.events.Event;
   
   public class CreatePopupMenuDialog extends WindowBase
   {
       
      
      private var _pkg:EUIPackage;
      
      private var _path:String;
      
      public function CreatePopupMenuDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","CreatePopupMenuDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         contentPane.getChild("n13").asLabel.editable = false;
         this.contentPane.getChild("n6").addClickListener(__actionHandler);
         this.contentPane.getChild("n14").addClickListener(this.__browse);
         this.contentPane.getChild("n7").addClickListener(closeEventHandler);
      }
      
      override protected function onShown() : void
      {
         this._pkg = _editorWindow.mainPanel.getActivePackage();
         contentPane.getChild("n3").text = this._pkg.getSequenceName("PopupMenu");
         this._path = _editorWindow.mainPanel.libPanel.pkgsPanel.getSelectedFolderInPackage(this._pkg).id;
         this.__selectFolder(this._path);
         contentPane.getChild("n38").text = null;
         contentPane.getChild("n97").text = null;
         contentPane.getChild("n98").text = null;
         contentPane.getChild("n99").text = null;
         contentPane.getChild("n100").text = null;
      }
      
      override protected function onHide() : void
      {
         _editorWindow.mainPanel.libPanel.self.requestFocus();
      }
      
      override public function actionHandler() : void
      {
         var _loc1_:Array = null;
         var _loc2_:EPackageItem = null;
         try
         {
            _loc1_ = [contentPane.getChild("n97").text,contentPane.getChild("n98").text,contentPane.getChild("n99").text,contentPane.getChild("n100").text];
            _loc2_ = ComponentTemplates.createNewPopupMenu(this._pkg,contentPane.getChild("n3").text,contentPane.getChild("n38").text,_loc1_,this._path);
            _editorWindow.mainPanel.openItem(_loc2_);
            this.hide();
            return;
         }
         catch(err:Error)
         {
            _editorWindow.alertError(err);
            return;
         }
      }
      
      private function __browse(param1:Event) : void
      {
         ChooseFolderDialog(_editorWindow.getDialog(ChooseFolderDialog)).open(this._pkg,this._path,this.__selectFolder);
      }
      
      private function __selectFolder(param1:String) : void
      {
         this._path = param1;
         contentPane.getChild("n13").text = "/" + this._pkg.name + this._path;
      }
   }
}
