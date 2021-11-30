package fairygui.editor.dialogs
{
   import fairygui.UIPackage;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.utils.UtilsStr;
   
   public class ReplaceRefDialog extends WindowBase
   {
       
      
      private var _callback:Function;
      
      public function ReplaceRefDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","ReplaceRefDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this.contentPane.getChild("n1").addClickListener(__actionHandler);
         this.contentPane.getChild("n6").addClickListener(closeEventHandler);
      }
      
      public function open(param1:Function) : void
      {
         this._callback = param1;
         show();
      }
      
      override public function actionHandler() : void
      {
         var _loc1_:String = contentPane.getChild("n5").text;
         if(!UtilsStr.startsWith(_loc1_,"ui://"))
         {
            return;
         }
         this._callback(_loc1_);
         this.hide();
      }
   }
}
