package fairygui.editor
{
   import com.greensock.TweenLite;
   import com.greensock.easing.BackOut;
   import fairygui.Window;
   import flash.events.Event;
   
   public class WindowBase extends Window
   {
       
      
      protected var _editorWindow:EditorWindow;
      
      public function WindowBase()
      {
         super();
      }
      
      override public final function show() : void
      {
         if(this._editorWindow)
         {
            this._editorWindow.groot.showWindow(this);
         }
         else
         {
            super.show();
         }
      }
      
      override protected function doShowAnimation() : void
      {
         this.setPivot(0.5,0.5);
         this.scaleX = 0.7;
         this.scaleY = 0.7;
         TweenLite.to(this,0.1,{
            "scaleX":1,
            "scaleY":1,
            "ease":BackOut.ease,
            "onComplete":this.__tweenComplete1
         });
      }
      
      override protected function onHide() : void
      {
      }
      
      private function __tweenComplete1() : void
      {
         this.setPivot(0,0);
         this.onShown();
      }
      
      protected function __actionHandler(param1:Event) : void
      {
         this.actionHandler();
      }
      
      public function actionHandler() : void
      {
      }
      
      public function cancelHandler() : void
      {
         this.hide();
      }
   }
}
