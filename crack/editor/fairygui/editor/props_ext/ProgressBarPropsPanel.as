package fairygui.editor.props_ext
{
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.EGComponent;
   import fairygui.editor.gui.EGProgressBar;
   import fairygui.editor.props.PropsPanel;
   
   public class ProgressBarPropsPanel extends PropsPanel
   {
       
      
      public function ProgressBarPropsPanel(param1:EditorWindow, param2:String)
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
         var _loc1_:EGProgressBar = EGProgressBar(EGComponent(_object).extention);
         getChild("value").text = "" + _loc1_.value;
         getChild("max").text = "" + _loc1_.max;
         NumericInput(getChild("value")).max = _loc1_.max;
         fillControllerSettingsList();
      }
   }
}
