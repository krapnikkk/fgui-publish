package fairygui.editor.dialogs
{
   import fairygui.UIPackage;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   
   public class CropQueryDialog extends WindowBase
   {
       
      
      private var _callback:Function;
      
      public function CropQueryDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","CropQueryDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this.modal = true;
         this.contentPane.getChild("n1").addClickListener(__actionHandler);
      }
      
      override protected function onHide() : void
      {
         super.onHide();
         if(this._callback != null)
         {
            this._callback(null);
            this._callback = null;
         }
      }
      
      public function open(param1:Function) : void
      {
         this._callback = param1;
         show();
      }
      
      override public function actionHandler() : void
      {
         var _loc1_:Function = this._callback;
         this._callback = null;
         hide();
      }
   }
}
