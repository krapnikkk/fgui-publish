package fairygui.editor.props_ext
{
   import fairygui.GComboBox;
   import fairygui.GObject;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.dialogs.ComboBoxEditDialog;
   import fairygui.editor.extui.ColorInput;
   import fairygui.editor.gui.EGComboBox;
   import fairygui.editor.gui.EGComponent;
   import fairygui.editor.props.PropsPanel;
   import fairygui.editor.utils.UtilsStr;
   import flash.events.Event;
   
   public class ComboBoxPropsPanel extends PropsPanel
   {
       
      
      public function ComboBoxPropsPanel(param1:EditorWindow, param2:String)
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
         cb = getChild("direction").asComboBox;
         cb.items = [Consts.g.text289,Consts.g.text290,Consts.g.text291];
         cb.values = ["auto","down","up"];
         getChild("selectionController").addClickListener(this.__selectController);
         getChild("n77").addClickListener(function(param1:Event):void
         {
            ComboBoxEditDialog(_editorWindow.getDialog(ComboBoxEditDialog)).open(EGComboBox(EGComponent(_object).extention));
         });
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc1_:EGComboBox = EGComboBox(EGComponent(_object).extention);
         getChild("title").text = _loc1_.title;
         ColorInput(getChild("titleColor")).argb = _loc1_.titleColor;
         getChild("titleColorSet").asButton.selected = _loc1_.titleColorSet;
         getChild("titleColor").enabled = _loc1_.titleColorSet;
         getChild("visibleItemCount").text = "" + _loc1_.visibleItemCount;
         getChild("direction").asComboBox.value = _loc1_.direction;
         getChild("selectionController").text = UtilsStr.readableString(_loc1_.selectionController);
         fillControllerSettingsList();
      }
      
      private function __selectController(param1:Event) : void
      {
         _editorWindow.selectControllerMenu.show(GObject(param1.currentTarget),_object.parent);
      }
   }
}
