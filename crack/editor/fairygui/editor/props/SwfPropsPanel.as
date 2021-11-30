package fairygui.editor.props
{
   import fairygui.editor.EditorWindow;
   import fairygui.editor.gui.EGSwfObject;
   
   public class SwfPropsPanel extends PropsPanel
   {
       
      
      public function SwfPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc1_:EGSwfObject = EGSwfObject(_object);
         getChild("playing").asButton.selected = _loc1_.playing;
         getChild("frame").text = "" + _loc1_.frame;
      }
   }
}
