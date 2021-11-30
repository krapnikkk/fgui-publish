package fairygui.editor.gui
{
   public class FControllerPage
   {
       
      
      public var id:String;
      
      public var name:String;
      
      public var remark:String;
      
      public function FControllerPage()
      {
         super();
      }
      
      public function copyFrom(param1:FControllerPage) : void
      {
         this.id = param1.id;
         this.name = param1.name;
         this.remark = param1.remark;
      }
   }
}
