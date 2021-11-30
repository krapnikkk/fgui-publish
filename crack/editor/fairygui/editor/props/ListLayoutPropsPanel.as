package fairygui.editor.props
{
   import fairygui.editor.EditorWindow;
   import fairygui.editor.gui.EGList;
   
   public class ListLayoutPropsPanel extends SubPropsPanel
   {
       
      
      public function ListLayoutPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc1_:EGList = EGList(_object);
         getChild("autoResizeItem").asButton.selected = _loc1_.autoResizeItem;
      }
   }
}
