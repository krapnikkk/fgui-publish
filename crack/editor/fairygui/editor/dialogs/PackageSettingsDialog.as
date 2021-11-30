package fairygui.editor.dialogs
{
   import fairygui.GComboBox;
   import fairygui.UIPackage;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.EUIPackage;
   
   public class PackageSettingsDialog extends WindowBase
   {
       
      
      private var _pkg:EUIPackage;
      
      public function PackageSettingsDialog(param1:EditorWindow)
      {
         var _loc2_:GComboBox = null;
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","PackageSettingsDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         _loc2_ = contentPane.getChild("compressPNG").asComboBox;
         _loc2_.items = [Consts.g.text162,Consts.g.text161];
         _loc2_.values = ["yes","no"];
         this.contentPane.getChild("ok").addClickListener(__actionHandler);
         this.contentPane.getChild("cancel").addClickListener(closeEventHandler);
      }
      
      override protected function onShown() : void
      {
         this._pkg = _editorWindow.mainPanel.getActivePackage();
         this._pkg.ensureOpen();
         this.frame.text = this._pkg.name;
         contentPane.getChild("packageName").text = this._pkg.name;
         NumericInput(contentPane.getChild("jpegQuality")).value = this._pkg.jpegQuality;
         contentPane.getChild("compressPNG").asComboBox.value = !!this._pkg.compressPNG?"yes":"no";
         contentPane.getController("c2").selectedIndex = !!this._pkg.project.usingAtlas?1:0;
      }
      
      override public function actionHandler() : void
      {
         this._pkg.renameItem(this._pkg.rootItem,contentPane.getChild("packageName").text,false);
         this._pkg.compressPNG = contentPane.getChild("compressPNG").asComboBox.value == "yes";
         this._pkg.jpegQuality = NumericInput(contentPane.getChild("jpegQuality")).value;
         this._pkg.save();
         this.hide();
      }
      
      private function __updateJpegQualityComplete() : void
      {
         this._pkg.save();
         _editorWindow.closeWaiting();
         this.hide();
         _editorWindow.mainPanel.editPanel.refreshDocument();
      }
   }
}
