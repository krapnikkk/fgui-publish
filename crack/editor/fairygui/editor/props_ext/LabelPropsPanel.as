package fairygui.editor.props_ext
{
   import fairygui.GButton;
   import fairygui.GObject;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.ColorInput;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.EGComponent;
   import fairygui.editor.gui.EGLabel;
   import fairygui.editor.props.PropsPanel;
   import flash.events.Event;
   
   public class LabelPropsPanel extends PropsPanel
   {
       
      
      private var _inputEditBtn:GButton;
      
      public function LabelPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
         _isExtention = true;
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
         this._inputEditBtn = getChild("inputEdit").asButton;
         initSubPropsButton(this._inputEditBtn,"textInputProps");
         getChild("fontSizePreset").addClickListener(this.__clickSizePreset);
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc1_:EGLabel = EGLabel(EGComponent(_object).extention);
         getChild("title").text = _loc1_.title;
         getChild("icon").text = _loc1_.icon;
         ColorInput(getChild("titleColor")).argb = _loc1_.titleColor;
         getChild("titleColorSet").asButton.selected = _loc1_.titleColorSet;
         getChild("titleColor").enabled = _loc1_.titleColorSet;
         NumericInput(getChild("titleFontSize")).value = _loc1_.titleFontSize;
         getChild("titleFontSizeSet").asButton.selected = _loc1_.titleFontSizeSet;
         var _loc2_:* = _loc1_.titleFontSizeSet;
         getChild("fontSizePreset").enabled = _loc2_;
         getChild("titleFontSize").enabled = _loc2_;
         this._inputEditBtn.visible = _loc1_.input;
         fillControllerSettingsList();
      }
      
      private function __clickSizePreset(param1:Event) : void
      {
         param1.stopPropagation();
         _editorWindow.fontSizePresetMenu.show(NumericInput(getChild("titleFontSize")),GObject(param1.currentTarget));
      }
   }
}
