package fairygui.editor.dialogs
{
   import fairygui.GRoot;
   import fairygui.UIPackage;
   import fairygui.editor.WindowBase;
   
   public class ConfirmDialog extends WindowBase
   {
       
      
      private var _callback:Function;
      
      public function ConfirmDialog()
      {
         super();
         this.contentPane = UIPackage.createObject("Builder","ConfirmDialog").asCom;
         this.modal = true;
         this.contentPane.removeRelation(this,24);
         this.contentPane.getChild("n1").addClickListener(__actionHandler);
         this.contentPane.getChild("n3").addClickListener(closeEventHandler);
      }
      
      public function open(param1:GRoot, param2:String, param3:Function) : void
      {
         showOn(param1);
         this.contentPane.getChild("n2").text = param2;
         this._callback = param3;
         this.setSize(contentPane.width,contentPane.height);
         this.centerOn(param1,true);
      }
      
      override public function actionHandler() : void
      {
         hide();
         var _loc1_:Function = this._callback;
         this._callback = null;
      }
   }
}
