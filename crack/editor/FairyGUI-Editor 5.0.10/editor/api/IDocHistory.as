package fairygui.editor.api
{
   public interface IDocHistory
   {
       
      
      function canUndo() : Boolean;
      
      function canRedo() : Boolean;
      
      function undo() : Boolean;
      
      function redo() : Boolean;
      
      function add(param1:IDocHistoryItem) : void;
      
      function getPendingList() : Vector.<IDocHistoryItem>;
      
      function get processing() : Boolean;
   }
}
