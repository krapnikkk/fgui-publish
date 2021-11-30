package fairygui.editor.props_ext
{
   import fairygui.GComboBox;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.EGButton;
   import fairygui.editor.gui.EGComponent;
   import fairygui.editor.props.PropsPanel;
   
   public class ButtonPropsPanel2 extends PropsPanel
   {
       
      
      public function ButtonPropsPanel2(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
         _isExtention = true;
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         param1 = param1;
         var cb:GComboBox = null;
         var xml:XML = param1;
         super.constructFromXML(xml);
         cb = getChild("mode").asComboBox;
         cb.items = [Consts.g.text127,Consts.g.text125,Consts.g.text126];
         cb.values = ["Common","Check","Radio"];
         NumericInput(getChild("volume")).max = 100;
         cb = getChild("downEffect").asComboBox;
         cb.items = [Consts.g.text139,Consts.g.text282,Consts.g.text283];
         cb.values = ["none","dark","scale"];
         with(NumericInput(getChild("downEffectValue")))
         {
            
            min = 0;
            step = 0.05;
            fractionDigits = 2;
         }
      }
      
      override protected function setObjectToUI() : void
      {
         var ext:EGButton = EGButton(EGComponent(_object).extention);
         getChild("mode").asComboBox.value = ext.mode;
         getChild("sound").text = ext.sound;
         NumericInput(getChild("volume")).value = ext.volume;
         getChild("downEffect").asComboBox.value = ext.downEffect;
         with(NumericInput(getChild("downEffectValue")))
         {
            
            value = ext.downEffectValue;
            visible = ext.downEffect != "none";
         }
      }
   }
}
