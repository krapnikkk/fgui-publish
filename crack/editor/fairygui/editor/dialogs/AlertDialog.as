package fairygui.editor.dialogs
{
   import fairygui.GRoot;
   import fairygui.UIPackage;
   import fairygui.editor.WindowBase;
   
   public class AlertDialog extends WindowBase
   {
       
      
      public function AlertDialog()
      {
         super();
         this.contentPane = UIPackage.createObject("Builder","AlertDialog").asCom;
         this.modal = true;
         this.contentPane.removeRelation(this,24);
         contentPane.getChild("n1").addClickListener(closeEventHandler);
      }
      
      public function open(param1:GRoot, param2:String, param3:Function = null) : void
      {
         showOn(param1);
         this.frame.text = ClassEditor.defaultWindowTitle;
         if(param2 == null)
         {
            param2 = "";
         }
         else
         {
            param2 = param2.replace(/\r\n/g,"\n");
            param2 = param2.replace(/\r/g,"\n");
         }
         this.contentPane.getChild("n2").text = param2;
         this.data = param3;
         this.setSize(contentPane.width,contentPane.height);
         this.centerOn(param1,true);
      }
      
      override protected function doShowAnimation() : void
      {
         this.onShown();
      }
      
      override public function actionHandler() : void
      {
         this.hide();
      }
      
      override protected function onHide() : void
      {
         super.onHide();
         if(this.data != null)
         {
            this.data();
         }
      }
   }
}
