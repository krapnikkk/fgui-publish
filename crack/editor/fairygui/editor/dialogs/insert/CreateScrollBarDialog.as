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
   
   public class CreateScrollBarDialog extends WindowBase
   {
       
      
      private var _pkg:EUIPackage;
      
      private var _path:String;
      
      private var _c1:Controller;
      
      private var _c4:Controller;
      
      public function CreateScrollBarDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","CreateScrollBarDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this._c1 = contentPane.getController("c1");
         this._c4 = contentPane.getController("c4");
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
         contentPane.getChild("n3").text = this._pkg.getSequenceName("ScrollBar");
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
         if(this._c1.selectedIndex == 4)
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
         if(contentPane.getChild("n66").asButton.selected)
         {
            if(this._c1.selectedIndex == 0)
            {
               this._c1.selectedIndex = 2;
            }
            else
            {
               this._c1.selectedIndex++;
            }
         }
         else
         {
            this._c1.selectedIndex++;
         }
      }
      
      private function __prev(param1:Event) : void
      {
         if(contentPane.getChild("n66").asButton.selected)
         {
            if(this._c1.selectedIndex == 3)
            {
               this._c1.selectedIndex = 0;
            }
            else
            {
               this._c1.selectedIndex--;
            }
         }
         else
         {
            this._c1.selectedIndex--;
         }
      }
      
      private function __action(param1:Event) : void
      {
         var _loc4_:Array = null;
         var _loc3_:Array = null;
         var _loc6_:String = null;
         var _loc2_:Array = null;
         var _loc7_:EPackageItem = null;
         var _loc5_:* = param1;
         try
         {
            _loc4_ = [contentPane.getChild("n23").text,contentPane.getChild("n24").text,contentPane.getChild("n25").text,contentPane.getChild("n26").text];
            _loc3_ = [contentPane.getChild("n53").text,contentPane.getChild("n54").text,contentPane.getChild("n55").text,contentPane.getChild("n56").text];
            _loc6_ = contentPane.getChild("n38").text;
            _loc2_ = [contentPane.getChild("n75").text,contentPane.getChild("n76").text,contentPane.getChild("n77").text,contentPane.getChild("n78").text];
            _loc7_ = ComponentTemplates.createNewScrollBar(this._pkg,contentPane.getChild("n3").text,this._c4.selectedIndex,!contentPane.getChild("n66").asButton.selected,_loc4_,_loc3_,_loc6_,_loc2_,this._path);
            _editorWindow.mainPanel.openItem(_loc7_);
            this.hide();
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
