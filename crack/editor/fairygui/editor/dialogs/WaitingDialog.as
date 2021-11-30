package fairygui.editor.dialogs
{
   import fairygui.UIPackage;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import flash.events.Event;
   
   public class WaitingDialog extends WindowBase
   {
       
      
      private var _cancelCallback:Function;
      
      public function WaitingDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","WaitingDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this.modal = true;
         contentPane.getChild("cancel").addClickListener(this.__clickCancel);
      }
      
      public function open(param1:String = null, param2:Function = null) : void
      {
         show();
         if(param1 == null)
         {
            contentPane.getChild("title").text = Consts.g.text102 + "...";
         }
         else
         {
            contentPane.getChild("title").text = param1;
         }
         contentPane.getChild("cancel").visible = param2 != null;
         this._cancelCallback = param2;
      }
      
      public function __clickCancel(param1:Event) : void
      {
         hide();
         var _loc2_:Function = this._cancelCallback;
         this._cancelCallback = null;
         if(_loc2_ != null)
         {
            _loc2_();
         }
      }
   }
}
