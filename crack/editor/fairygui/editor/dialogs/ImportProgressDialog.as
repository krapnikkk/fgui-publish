package fairygui.editor.dialogs
{
   import fairygui.GProgressBar;
   import fairygui.GTextField;
   import fairygui.UIPackage;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   
   public class ImportProgressDialog extends WindowBase
   {
       
      
      public var progressBar:GProgressBar;
      
      public var messageText:GTextField;
      
      public function ImportProgressDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","ImportProgressDialog").asCom;
         this.modal = true;
         this.centerOn(_editorWindow.groot,true);
         this.progressBar = contentPane.getChild("n8").asProgress;
         this.messageText = contentPane.getChild("n9").asTextField;
         contentPane.getChild("btnCancel").addClickListener(closeEventHandler);
      }
      
      override protected function onShown() : void
      {
         this.progressBar.value = 0;
      }
   }
}
