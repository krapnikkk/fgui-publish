package fairygui.editor.props
{
   import fairygui.GComboBox;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.dialogs.ProjectSettingsDialog;
   import fairygui.editor.gui.EGComponent;
   import flash.events.Event;
   
   public class ScrollPropsPanel extends SubPropsPanel
   {
       
      
      public function ScrollPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc1_:EGComponent = EGComponent(_object);
         getChild("scrollBarOnLeft").asButton.selected = _loc1_.scrollBarOnLeft;
         getChild("scrollSnapping").asButton.selected = _loc1_.scrollSnapping;
         getChild("scrollBarInDemand").asButton.selected = _loc1_.scrollBarInDemand;
         getChild("scrollPageMode").asButton.selected = _loc1_.scrollPageMode;
         getChild("scrollBarDisplay").asComboBox.value = _loc1_.scrollBarDisplay;
         getChild("scrollTouchEffect").asComboBox.value = _loc1_.scrollTouchEffect;
         getChild("scrollBounceBackEffect").asComboBox.value = _loc1_.scrollBounceBackEffect;
         getChild("scrollBarMarginLeft").text = "" + _loc1_.scrollBarMargin.left;
         getChild("scrollBarMarginRight").text = "" + _loc1_.scrollBarMargin.right;
         getChild("scrollBarMarginTop").text = "" + _loc1_.scrollBarMargin.top;
         getChild("scrollBarMarginBottom").text = "" + _loc1_.scrollBarMargin.bottom;
         getChild("inertiaDisabled").asButton.selected = _loc1_.inertiaDisabled;
         getChild("maskDisabled").asButton.selected = _loc1_.maskDisabled;
         getChild("vtScrollBarRes").text = _loc1_.vtScrollBarRes;
         getChild("hzScrollBarRes").text = _loc1_.hzScrollBarRes;
         getChild("headerRes").text = _loc1_.headerRes;
         getChild("footerRes").text = _loc1_.footerRes;
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         var _loc2_:GComboBox = null;
         super.constructFromXML(param1);
         _loc2_ = getChild("scrollBarDisplay").asComboBox;
         _loc2_.items = [Consts.g.text138,Consts.g.text91,Consts.g.text92,Consts.g.text93];
         _loc2_.values = ["default","visible","auto","hidden"];
         _loc2_ = getChild("scrollBounceBackEffect").asComboBox;
         _loc2_.items = [Consts.g.text284,Consts.g.text285,Consts.g.text286];
         _loc2_.values = ["default","enabled","disabled"];
         _loc2_ = getChild("scrollTouchEffect").asComboBox;
         _loc2_.items = [Consts.g.text284,Consts.g.text285,Consts.g.text286];
         _loc2_.values = ["default","enabled","disabled"];
         getChild("globalSettings").addClickListener(this.__globalSetting);
      }
      
      private function __globalSetting(param1:Event) : void
      {
         ProjectSettingsDialog(EditorWindow.getInstance(this).getDialog(ProjectSettingsDialog)).openScrollBarSettings();
      }
   }
}
