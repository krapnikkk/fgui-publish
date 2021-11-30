package fairygui.editor.props_ext
{
   import fairygui.GComboBox;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.gui.EGComponent;
   import fairygui.editor.gui.EGProgressBar;
   import fairygui.editor.props.PropsPanel;
   
   public class ProgressBarPropsPanel2 extends PropsPanel
   {
       
      
      public function ProgressBarPropsPanel2(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
         _isExtention = true;
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         var _loc2_:GComboBox = null;
         super.constructFromXML(param1);
         _loc2_ = getChild("titleType").asComboBox;
         _loc2_.items = [Consts.g.text128,Consts.g.text129,Consts.g.text130,Consts.g.text131];
         _loc2_.values = ["percent","valueAndmax","value","max"];
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc1_:EGProgressBar = EGProgressBar(EGComponent(_object).extention);
         getChild("titleType").asComboBox.value = _loc1_.titleType;
         getChild("reverse").asButton.selected = _loc1_.reverse;
      }
   }
}
