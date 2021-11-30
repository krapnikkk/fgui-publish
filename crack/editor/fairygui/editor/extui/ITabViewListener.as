package fairygui.editor.extui
{
   public interface ITabViewListener
   {
       
      
      function tabChanged(param1:TabItem) : void;
      
      function tabWillClose(param1:TabItem) : Boolean;
      
      function tabClosed(param1:TabItem) : void;
   }
}
