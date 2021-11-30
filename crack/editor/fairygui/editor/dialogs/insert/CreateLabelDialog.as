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
   
   public class CreateLabelDialog extends WindowBase
   {
       
      
      private var _pkg:EUIPackage;
      
      private var _path:String;
      
      public function CreateLabelDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","CreateLabelDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         contentPane.getChild("n8").text = "400";
         contentPane.getChild("n10").text = "400";
         contentPane.getChild("n13").asLabel.editable = false;
         this.contentPane.getChild("n6").addClickListener(__actionHandler);
         this.contentPane.getChild("n14").addClickListener(this.__browse);
         this.contentPane.getChild("n7").addClickListener(closeEventHandler);
      }
      
      override protected function onShown() : void
      {
         this._pkg = _editorWindow.mainPanel.getActivePackage();
         contentPane.getChild("n3").text = this._pkg.getSequenceName("Label");
         this._path = _editorWindow.mainPanel.libPanel.pkgsPanel.getSelectedFolderInPackage(this._pkg).id;
         this.__selectFolder(this._path);
      }
      
      override protected function onHide() : void
      {
         _editorWindow.mainPanel.libPanel.self.requestFocus();
      }
      
      override public function actionHandler() : void
      {
         var _loc1_:EPackageItem = null;
         try
         {
            _loc1_ = ComponentTemplates.createNewLabel(this._pkg,contentPane.getChild("n3").text,parseInt(contentPane.getChild("n8").text),parseInt(contentPane.getChild("n10").text),this._path);
            _editorWindow.mainPanel.openItem(_loc1_);
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
