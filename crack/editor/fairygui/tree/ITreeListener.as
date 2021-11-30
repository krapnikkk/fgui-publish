package fairygui.tree
{
   import fairygui.GComponent;
   import fairygui.event.ItemEvent;
   
   public interface ITreeListener
   {
       
      
      function treeNodeCreateCell(param1:TreeNode) : GComponent;
      
      function treeNodeRender(param1:TreeNode, param2:GComponent) : void;
      
      function treeNodeWillExpand(param1:TreeNode, param2:Boolean) : void;
      
      function treeNodeClick(param1:TreeNode, param2:ItemEvent) : void;
   }
}
