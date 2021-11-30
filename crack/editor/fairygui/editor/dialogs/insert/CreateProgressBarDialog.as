package fairygui.editor.dialogs.insert
{
   import fairygui.GComboBox;
   import fairygui.UIPackage;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.dialogs.ChooseFolderDialog;
   import fairygui.editor.gui.ComponentTemplates;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIPackage;
   import flash.events.Event;
   
   public class CreateProgressBarDialog extends WindowBase
   {
       
      
      private var _pkg:EUIPackage;
      
      private var _path:String;
      
      public function CreateProgressBarDialog(param1:EditorWindow)
      {
         var _loc2_:GComboBox = null;
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","CreateProgressBarDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         contentPane.getChild("n13").asLabel.editable = false;
         _loc2_ = contentPane.getChild("titleType").asComboBox;
         _loc2_.items = [Consts.g.text139,Consts.g.text128,Consts.g.text129,Consts.g.text130,Consts.g.text131];
         _loc2_.values = ["none","percent","valueAndmax","value","max"];
         _loc2_.selectedIndex = 0;
         this.contentPane.getChild("n6").addClickListener(__actionHandler);
         this.contentPane.getChild("n14").addClickListener(this.__browse);
         this.contentPane.getChild("n7").addClickListener(closeEventHandler);
      }
      
      override protected function onShown() : void
      {
         this._pkg = _editorWindow.mainPanel.getActivePackage();
         contentPane.getChild("n3").text = this._pkg.getSequenceName("ProgressBar");
         this._path = _editorWindow.mainPanel.libPanel.pkgsPanel.getSelectedFolderInPackage(this._pkg).id;
         this.__selectFolder(this._path);
         contentPane.getChild("n38").text = null;
         contentPane.getChild("n83").text = null;
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
            _loc1_ = ComponentTemplates.createNewProgressBar(this._pkg,contentPane.getChild("n3").text,contentPane.getChild("n38").text,contentPane.getChild("n83").text,contentPane.getChild("titleType").asComboBox.value,contentPane.getChild("reverse").asButton.selected,this._path);
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
