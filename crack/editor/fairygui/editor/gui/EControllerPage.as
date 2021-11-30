package fairygui.editor.gui
{
   public class EControllerPage
   {
       
      
      public var id:String;
      
      public var name:String;
      
      public function EControllerPage()
      {
         super();
      }
      
      public function copyFrom(param1:EControllerPage) : void
      {
         this.id = param1.id;
         this.name = param1.name;
      }
   }
}
