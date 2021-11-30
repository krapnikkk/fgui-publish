package fairygui.editor.props_ext
{
   import fairygui.editor.EditorWindow;
   import fairygui.editor.gui.EGComboBox;
   import fairygui.editor.gui.EGComponent;
   import fairygui.editor.props.PropsPanel;
   
   public class ComboBoxPropsPanel2 extends PropsPanel
   {
       
      
      public function ComboBoxPropsPanel2(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
         _isExtention = true;
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc1_:EGComboBox = EGComboBox(EGComponent(_object).extention);
         getChild("dropdown").text = _loc1_.dropdown;
      }
   }
}
