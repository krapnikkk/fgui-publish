package fairygui.editor.props_ext
{
   import fairygui.editor.EditorWindow;
   import fairygui.editor.props.PropsPanel;
   
   public class LabelPropsPanel2 extends PropsPanel
   {
       
      
      public function LabelPropsPanel2(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
         _isExtention = true;
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
      }
   }
}
