package fairygui.editor.props
{
   import fairygui.GComboBox;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.EGComponent;
   import fairygui.editor.gui.EGTextField;
   
   public class TextInputPropsPanel extends SubPropsPanel
   {
       
      
      public function TextInputPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc1_:Object = null;
         if(_object is EGTextField)
         {
            _loc1_ = _object;
            _isExtention = false;
         }
         else
         {
            _loc1_ = EGComponent(_object).extention;
            _isExtention = true;
         }
         getChild("promptText").text = _loc1_.promptText;
         getChild("restrict").text = _loc1_.restrict;
         NumericInput(getChild("maxLength")).value = _loc1_.maxLength;
         getChild("keyboardType").asComboBox.value = _loc1_.keyboardType;
         getChild("password").asButton.selected = _loc1_.password;
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
         var _loc2_:GComboBox = getChild("keyboardType").asComboBox;
         _loc2_.items = [Consts.g.text138,Consts.g.text292,Consts.g.text293,Consts.g.text294,Consts.g.text295,Consts.g.text296];
         _loc2_.values = ["","1","2","3","4","5"];
      }
   }
}
