package fairygui.editor.props
{
   import fairygui.GComboBox;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.ColorInput;
   import fairygui.editor.gui.EGGraph;
   
   public class GraphPropsPanel extends PropsPanel
   {
       
      
      public function GraphPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         var _loc2_:GComboBox = null;
         super.constructFromXML(param1);
         _loc2_ = getChild("type").asComboBox;
         _loc2_.items = [Consts.g.text146,Consts.g.text147,Consts.g.text148];
         _loc2_.values = ["empty","rect","eclipse"];
         ColorInput(getChild("lineColor")).showAlpha = true;
         ColorInput(getChild("fillColor")).showAlpha = true;
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc1_:EGGraph = EGGraph(_object);
         getChild("type").asComboBox.value = _loc1_.type;
         ColorInput(getChild("lineColor")).argb = _loc1_.lineColor;
         getChild("lineSize").text = "" + _loc1_.lineSize;
         ColorInput(getChild("fillColor")).argb = _loc1_.fillColor;
         getChild("cornerRadius").text = _loc1_.cornerRadius;
      }
   }
}
