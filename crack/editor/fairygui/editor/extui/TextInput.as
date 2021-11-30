package fairygui.editor.extui
{
   import fairygui.GLabel;
   import flash.events.Event;
   
   public class TextInput extends GLabel
   {
       
      
      private var savedText:String;
      
      public function TextInput()
      {
         super();
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
         this._titleObject.addEventListener("focusIn",this.__focusIn);
         this._titleObject.addEventListener("focusOut",this.__focusOut);
      }
      
      private function __focusIn(param1:Event) : void
      {
         this.savedText = this.text;
      }
      
      private function __focusOut(param1:Event) : void
      {
         if(this.savedText != this.text)
         {
            this.dispatchEvent(new SubmitEvent("__submit"));
         }
         this.savedText = null;
      }
   }
}
