package fairygui.editor.dialogs.insert
{
   import fairygui.Controller;
   import fairygui.UIPackage;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.dialogs.ChooseFolderDialog;
   import fairygui.editor.gui.ComponentTemplates;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIPackage;
   import flash.events.Event;
   
   public class CreateComboBoxDialog extends WindowBase
   {
       
      
      private var _pkg:EUIPackage;
      
      private var _path:String;
      
      private var _c1:Controller;
      
      public function CreateComboBoxDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","CreateComboBoxDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this._c1 = contentPane.getController("c1");
         contentPane.getChild("n13").asLabel.editable = false;
         this.contentPane.getChild("n18").addClickListener(this.__next);
         this.contentPane.getChild("n63").addClickListener(this.__prev);
         this.contentPane.getChild("n6").addClickListener(this.__action);
         this.contentPane.getChild("n14").addClickListener(this.__browse);
         this.contentPane.getChild("n7").addClickListener(closeEventHandler);
      }
      
      override protected function onShown() : void
      {
         this._pkg = _editorWindow.mainPanel.getActivePackage();
         contentPane.getChild("n3").text = this._pkg.getSequenceName("ComboBox");
         this._path = _editorWindow.mainPanel.libPanel.pkgsPanel.getSelectedFolderInPackage(this._pkg).id;
         this.__selectFolder(this._path);
         contentPane.getChild("n23").text = null;
         contentPane.getChild("n24").text = null;
         contentPane.getChild("n25").text = null;
         contentPane.getChild("n26").text = null;
         contentPane.getChild("n38").text = null;
         contentPane.getChild("n53").text = null;
         contentPane.getChild("n54").text = null;
         contentPane.getChild("n55").text = null;
         contentPane.getChild("n56").text = null;
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
         var _loc6_:Array = null;
         var _loc4_:String = null;
         var _loc3_:Array = null;
         var _loc5_:EPackageItem = null;
         var _loc2_:* = param1;
         try
         {
            _loc6_ = [contentPane.getChild("n23").text,contentPane.getChild("n24").text,contentPane.getChild("n25").text,contentPane.getChild("n26").text];
            _loc4_ = contentPane.getChild("n38").text;
            _loc3_ = [contentPane.getChild("n53").text,contentPane.getChild("n54").text,contentPane.getChild("n55").text,contentPane.getChild("n56").text];
            _loc5_ = ComponentTemplates.createNewComboBox(this._pkg,contentPane.getChild("n3").text,_loc6_,_loc4_,_loc3_,this._path);
            _editorWindow.mainPanel.openItem(_loc5_);
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
