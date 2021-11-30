package fairygui.editor.dialogs
{
   import fairygui.GLabel;
   import fairygui.UIPackage;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.gui.EUIPackage;
   
   public class CreatePackageDialog extends WindowBase
   {
       
      
      private var _name:GLabel;
      
      public function CreatePackageDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","CreatePackageDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this._name = this.contentPane.getChild("n3").asLabel;
         this.contentPane.getChild("btnCreate").addClickListener(__actionHandler);
         this.contentPane.getChild("btnCancel").addClickListener(closeEventHandler);
      }
      
      override protected function onShown() : void
      {
         this._name.getTextField().requestFocus();
      }
      
      override protected function onHide() : void
      {
         _editorWindow.mainPanel.libPanel.self.requestFocus();
      }
      
      override public function actionHandler() : void
      {
         var _loc1_:EUIPackage = null;
         try
         {
            _loc1_ = _editorWindow.project.createPackage(this._name.text);
            _editorWindow.mainPanel.libPanel.updatePackages();
            _editorWindow.mainPanel.libPanel.highlightItem(_loc1_.rootItem);
            this.hide();
            return;
         }
         catch(err:Error)
         {
            _editorWindow.alertError(err);
            return;
         }
      }
   }
}
