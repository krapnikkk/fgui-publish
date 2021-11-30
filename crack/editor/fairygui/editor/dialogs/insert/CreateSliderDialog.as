package fairygui.editor.dialogs.insert
{
   import fairygui.Controller;
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
   
   public class CreateSliderDialog extends WindowBase
   {
       
      
      private var _pkg:EUIPackage;
      
      private var _path:String;
      
      private var _c1:Controller;
      
      private var _c4:Controller;
      
      public function CreateSliderDialog(param1:EditorWindow)
      {
         var _loc2_:GComboBox = null;
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","CreateSliderDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         contentPane.getChild("n13").asLabel.editable = false;
         this._c1 = contentPane.getController("c1");
         this._c4 = contentPane.getController("c4");
         _loc2_ = contentPane.getChild("titleType").asComboBox;
         _loc2_.items = [Consts.g.text139,Consts.g.text128,Consts.g.text129,Consts.g.text130,Consts.g.text131];
         _loc2_.values = ["none","percent","valueAndmax","value","max"];
         _loc2_.selectedIndex = 0;
         this.contentPane.getChild("n18").addClickListener(this.__next);
         this.contentPane.getChild("n63").addClickListener(this.__prev);
         this.contentPane.getChild("n6").addClickListener(this.__action);
         this.contentPane.getChild("n14").addClickListener(this.__browse);
         this.contentPane.getChild("n7").addClickListener(closeEventHandler);
      }
      
      override protected function onShown() : void
      {
         this._pkg = _editorWindow.mainPanel.getActivePackage();
         contentPane.getChild("n3").text = this._pkg.getSequenceName("Slider");
         this._path = _editorWindow.mainPanel.libPanel.pkgsPanel.getSelectedFolderInPackage(this._pkg).id;
         this.__selectFolder(this._path);
         contentPane.getChild("n38").text = null;
         contentPane.getChild("n84").text = null;
         contentPane.getChild("n75").text = null;
         contentPane.getChild("n76").text = null;
         contentPane.getChild("n77").text = null;
         contentPane.getChild("n78").text = null;
         this._c1.selectedIndex = 0;
      }
      
      override protected function onHide() : void
      {
         _editorWindow.mainPanel.libPanel.self.requestFocus();
      }
      
      override public function actionHandler() : void
      {
         if(this._c1.selectedIndex == 3)
         {
            this.__action(null);
         }
         else
         {
            this.__next(null);
         }
      }
      
      private function __next(param1:Event) : void
      {
         this._c1.selectedIndex++;
      }
      
      private function __prev(param1:Event) : void
      {
         this._c1.selectedIndex--;
      }
      
      private function __action(param1:Event) : void
      {
         var _loc2_:Array = null;
         var _loc4_:EPackageItem = null;
         var _loc3_:* = param1;
         try
         {
            _loc2_ = [contentPane.getChild("n75").text,contentPane.getChild("n76").text,contentPane.getChild("n77").text,contentPane.getChild("n78").text];
            _loc4_ = ComponentTemplates.createNewSlider(this._pkg,contentPane.getChild("n3").text,this._c4.selectedIndex,contentPane.getChild("n38").text,contentPane.getChild("n84").text,_loc2_,contentPane.getChild("titleType").asComboBox.value,this._path);
            _editorWindow.mainPanel.openItem(_loc4_);
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
