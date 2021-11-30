package fairygui.editor.props
{
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.EControllerAction;
   
   public class PlayTransActionPropsPanel extends ControllerActionPropsPanel
   {
       
      
      public function PlayTransActionPropsPanel(param1:EditorWindow, param2:String)
      {
         param1 = param1;
         param2 = param2;
         var win:EditorWindow = param1;
         var panelResource:String = param2;
         super(win,panelResource);
         NumericInput(getChild("repeat")).min = -1;
         with(NumericInput(getChild("delay")))
         {
            
            step = 0.001;
            fractionDigits = 3;
         }
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc1_:EControllerAction = EControllerAction(_action);
         NumericInput(getChild("repeat")).value = _loc1_.repeat;
         NumericInput(getChild("delay")).value = _loc1_.delay;
         getChild("stopOnExit").asButton.selected = _loc1_.stopOnExit;
      }
   }
}
