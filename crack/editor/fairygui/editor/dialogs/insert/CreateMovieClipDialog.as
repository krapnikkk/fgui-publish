package fairygui.editor.dialogs.insert
{
   import fairygui.GLabel;
   import fairygui.UIPackage;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.dialogs.ChooseFolderDialog;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIPackage;
   import flash.events.Event;
   
   public class CreateMovieClipDialog extends WindowBase
   {
       
      
      private var _pkg:EUIPackage;
      
      private var _path:String;
      
      private var _name:GLabel;
      
      public function CreateMovieClipDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","CreateMovieClipDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this._name = this.contentPane.getChild("n3").asLabel;
         this.contentPane.getChild("btnCreate").addClickListener(__actionHandler);
         this.contentPane.getChild("n10").addClickListener(this.__browse);
         this.contentPane.getChild("btnCancel").addClickListener(closeEventHandler);
      }
      
      override protected function onShown() : void
      {
         this._pkg = _editorWindow.mainPanel.getActivePackage();
         this._name.text = this._pkg.getSequenceName("MovieClip");
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
            _loc1_ = this._pkg.createNewMovieClip(this._name.text,this._path);
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
         contentPane.getChild("n9").text = "/" + this._pkg.name + this._path;
      }
   }
}
