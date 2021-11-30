package fairygui.editor.dialogs
{
   import fairygui.Controller;
   import fairygui.UIPackage;
   import fairygui.editor.ComDocument;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import flash.events.Event;
   
   public class CustomArrangeDialog extends WindowBase
   {
       
      
      private var _c1:Controller;
      
      public function CustomArrangeDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","CustomArrangeDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this._c1 = contentPane.getController("c1");
         this._c1.addEventListener("stateChanged",this.__typeChanged);
         contentPane.getChild("n21").addClickListener(this.__action);
         contentPane.getChild("n40").addClickListener(this.__apply);
         contentPane.getChild("n23").addClickListener(closeEventHandler);
      }
      
      override protected function onShown() : void
      {
         this.__typeChanged(null);
      }
      
      override protected function onHide() : void
      {
         _editorWindow.mainPanel.editPanel.self.requestFocus();
      }
      
      private function __action(param1:Event) : void
      {
         this.__apply(null);
         this.hide();
      }
      
      private function __apply(param1:Event) : void
      {
         var _loc2_:ComDocument = _editorWindow.activeComDocument;
         if(_loc2_ != null)
         {
            _loc2_.doArrangeCustom(this._c1.selectedIndex,parseInt(contentPane.getChild("n39").text),parseInt(contentPane.getChild("n38").text),parseInt(contentPane.getChild("n37").text));
         }
      }
      
      private function __typeChanged(param1:Event) : void
      {
         var _loc2_:ComDocument = _editorWindow.activeComDocument;
         contentPane.getChild("n37").text = "" + _loc2_.getSelectionHGap();
         contentPane.getChild("n38").text = "" + _loc2_.getSelectionVGap();
         contentPane.getChild("n39").text = "" + _loc2_.getSelectionCols();
         switch(int(this._c1.selectedIndex))
         {
            case 0:
               contentPane.getChild("n37").enabled = true;
               contentPane.getChild("n38").enabled = false;
               contentPane.getChild("n39").enabled = false;
               break;
            case 1:
               contentPane.getChild("n37").enabled = false;
               contentPane.getChild("n38").enabled = true;
               contentPane.getChild("n39").enabled = false;
               break;
            case 2:
               contentPane.getChild("n37").enabled = true;
               contentPane.getChild("n38").enabled = true;
               contentPane.getChild("n39").enabled = true;
         }
      }
   }
}
