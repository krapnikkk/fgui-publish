package fairygui.editor.dialogs
{
   import com.greensock.TweenLite;
   import com.greensock.easing.EaseLookup;
   import fairygui.UIPackage;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   
   public class PromptDialog extends WindowBase
   {
       
      
      public function PromptDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","PromptDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
      }
      
      public function open(param1:String) : void
      {
         show();
         this.alpha = 1;
         contentPane.getChild("title").text = param1;
         TweenLite.to(this,2,{
            "alpha":0.2,
            "onComplete":this._tweenComplete,
            "ease":EaseLookup.find("Linear.easeNone")
         });
      }
      
      private function _tweenComplete() : void
      {
         hide();
      }
   }
}
