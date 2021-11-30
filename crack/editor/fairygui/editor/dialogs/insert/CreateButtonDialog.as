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
   import flash.geom.Point;
   
   public class CreateButtonDialog extends WindowBase
   {
       
      
      private var _pkg:EUIPackage;
      
      private var _path:String;
      
      public function CreateButtonDialog(param1:EditorWindow)
      {
         var _loc2_:GComboBox = null;
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","CreateButtonDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         _loc2_ = contentPane.getChild("mode").asComboBox;
         _loc2_.items = [Consts.g.text127,Consts.g.text125,Consts.g.text126];
         _loc2_.values = ["Common","Check","Radio"];
         _loc2_.selectedIndex = 0;
         contentPane.getChild("n19").text = "200";
         contentPane.getChild("n21").text = "100";
         contentPane.getChild("n16").asLabel.editable = false;
         this.contentPane.getChild("n13").addClickListener(__actionHandler);
         this.contentPane.getChild("n17").addClickListener(this.__browse);
         this.contentPane.getChild("n14").addClickListener(closeEventHandler);
      }
      
      override protected function onShown() : void
      {
         this._pkg = _editorWindow.mainPanel.getActivePackage();
         contentPane.getChild("n2").text = this._pkg.getSequenceName("Button");
         contentPane.getChild("n7").text = null;
         contentPane.getChild("n8").text = null;
         contentPane.getChild("n9").text = null;
         contentPane.getChild("n10").text = null;
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
            _loc1_ = ComponentTemplates.createNewButton(this._pkg,contentPane.getChild("n2").text,"Button",contentPane.getChild("mode").asComboBox.value,[contentPane.getChild("n7").text,contentPane.getChild("n8").text,contentPane.getChild("n9").text,contentPane.getChild("n10").text],contentPane.getController("c1").selectedIndex == 0?null:new Point(parseInt(contentPane.getChild("n19").text),parseInt(contentPane.getChild("n21").text)),false,true,contentPane.getChild("n11").asButton.selected,contentPane.getChild("n12").asButton.selected,false,this._path);
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
         contentPane.getChild("n16").text = "/" + this._pkg.name + this._path;
      }
   }
}
