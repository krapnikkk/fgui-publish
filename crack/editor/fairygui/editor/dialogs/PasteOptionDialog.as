package fairygui.editor.dialogs
{
   import fairygui.Controller;
   import fairygui.UIPackage;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   
   public class PasteOptionDialog extends WindowBase
   {
       
      
      private var _callback:Function;
      
      private var _overrideOption:Controller;
      
      public function PasteOptionDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","PasteOptionDialog").asCom;
         this.modal = true;
         this.centerOn(_editorWindow.groot,true);
         this._overrideOption = this.contentPane.getController("c1");
         this.contentPane.getChild("n3").addClickListener(__actionHandler);
         this.contentPane.getChild("n4").addClickListener(closeEventHandler);
      }
      
      public function open(param1:Function) : void
      {
         this._callback = param1;
         show();
      }
      
      override public function actionHandler() : void
      {
         this._callback(this._overrideOption.selectedIndex);
         this.hide();
      }
   }
}
