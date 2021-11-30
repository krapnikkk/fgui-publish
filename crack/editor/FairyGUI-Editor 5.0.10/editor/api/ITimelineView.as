package fairygui.editor.api
{
   import fairygui.editor.gui.FTransitionItem;
   
   public interface ITimelineView
   {
       
      
      function refresh(param1:FTransitionItem = null) : void;
      
      function selectKeyFrame(param1:FTransitionItem) : void;
      
      function getSelection() : FTransitionItem;
   }
}
