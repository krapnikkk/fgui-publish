package fairygui.editor.extui
{
   import fairygui.GButton;
   import fairygui.editor.EditorWindow;
   import flash.events.Event;
   
   public class LinkButton extends GButton
   {
       
      
      public function LinkButton()
      {
         super();
         this.addEventListener("addedToStage",this.__addedToStage);
      }
      
      private function __addedToStage(param1:Event) : void
      {
         this.removeEventListener("addedToStage",this.__addedToStage);
         EditorWindow.getInstance(this).cursorManager.setCursorForObject(this.displayObject,CursorManager.FINGER);
      }
   }
}
