package fairygui.editor
{
   public interface IDocument
   {
       
      
      function activate() : void;
      
      function deactivate() : void;
      
      function save() : void;
      
      function refresh() : void;
      
      function release() : void;
      
      function get uid() : String;
      
      function get isModified() : Boolean;
   }
}
