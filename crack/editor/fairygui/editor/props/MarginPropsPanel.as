package fairygui.editor.props
{
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.EGComponent;
   
   public class MarginPropsPanel extends SubPropsPanel
   {
       
      
      public function MarginPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc1_:EGComponent = EGComponent(_object);
         NumericInput(getChild("marginLeft")).value = _loc1_.margin.left;
         NumericInput(getChild("marginRight")).value = _loc1_.margin.right;
         NumericInput(getChild("marginTop")).value = _loc1_.margin.top;
         NumericInput(getChild("marginBottom")).value = _loc1_.margin.bottom;
         NumericInput(getChild("clipSoftnessX")).value = _loc1_.clipSoftnessX;
         NumericInput(getChild("clipSoftnessY")).value = _loc1_.clipSoftnessY;
      }
   }
}
