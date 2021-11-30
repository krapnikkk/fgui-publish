package fairygui.editor.props
{
   import fairygui.editor.EditorWindow;
   
   public class EtcPropsPanel extends PropsPanel
   {
       
      
      public function EtcPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
      }
      
      override protected function setObjectToUI() : void
      {
         getChild("tooltips").text = _object.tooltips;
      }
   }
}
