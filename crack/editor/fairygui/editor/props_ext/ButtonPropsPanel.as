package fairygui.editor.props_ext
{
   import fairygui.GObject;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.ColorInput;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.EGButton;
   import fairygui.editor.gui.EGComponent;
   import fairygui.editor.props.PropsPanel;
   import fairygui.editor.utils.UtilsStr;
   import flash.events.Event;
   
   public class ButtonPropsPanel extends PropsPanel
   {
       
      
      public function ButtonPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
         _isExtention = true;
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
         NumericInput(getChild("volume")).max = 100;
         getChild("soundSet").addEventListener("stateChanged",this.__soundSetChanged);
         getChild("soundVolumeSet").addEventListener("stateChanged",this.__soundSetChanged);
         getChild("fontSizePreset").addClickListener(this.__clickSizePreset);
         getChild("controller").addClickListener(this.__selectController);
         getChild("page").addClickListener(this.__selectPage);
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc1_:EGButton = EGButton(EGComponent(_object).extention);
         if(_loc1_.mode == "Check")
         {
            this.title = Consts.g.text125;
         }
         else if(_loc1_.mode == "Radio")
         {
            this.title = Consts.g.text126;
         }
         else
         {
            this.title = Consts.g.text127;
         }
         getChild("selected").asButton.selected = _loc1_.selected;
         getChild("title").text = _loc1_.title;
         getChild("icon").text = _loc1_.icon;
         getChild("selectedTitle").text = _loc1_.selectedTitle;
         getChild("selectedIcon").text = _loc1_.selectedIcon;
         ColorInput(getChild("titleColor")).argb = _loc1_.titleColor;
         getChild("titleColorSet").asButton.selected = _loc1_.titleColorSet;
         getChild("titleColor").enabled = _loc1_.titleColorSet;
         NumericInput(getChild("titleFontSize")).value = _loc1_.titleFontSize;
         getChild("titleFontSizeSet").asButton.selected = _loc1_.titleFontSizeSet;
         var _loc2_:* = _loc1_.titleFontSizeSet;
         getChild("fontSizePreset").enabled = _loc2_;
         getChild("titleFontSize").enabled = _loc2_;
         getChild("soundSet").asButton.selected = _loc1_.soundSet;
         getChild("soundVolumeSet").asButton.selected = _loc1_.soundVolumeSet;
         getChild("sound").text = _loc1_.sound;
         getChild("volume").text = "" + _loc1_.volume;
         this.__soundSetChanged(null);
         getChild("controller").text = UtilsStr.readableString(_loc1_.controller);
         if(_loc1_.controllerObj && _loc1_.controllerObj.parent)
         {
            getChild("page").text = _loc1_.controllerObj.getNameById(_loc1_.page,Consts.g.text331);
         }
         else
         {
            getChild("page").text = Consts.g.text331;
         }
         fillControllerSettingsList();
      }
      
      private function __soundSetChanged(param1:Event) : void
      {
         getChild("sound").enabled = getChild("soundSet").asButton.selected;
         getChild("volume").enabled = getChild("soundVolumeSet").asButton.selected;
      }
      
      private function __clickSizePreset(param1:Event) : void
      {
         param1.stopPropagation();
         _editorWindow.fontSizePresetMenu.show(NumericInput(getChild("titleFontSize")),GObject(param1.currentTarget));
      }
      
      private function __selectController(param1:Event) : void
      {
         _editorWindow.selectControllerMenu.show(GObject(param1.currentTarget),_object.parent);
      }
      
      private function __selectPage(param1:Event) : void
      {
         _editorWindow.selectPageMenu.show(GObject(param1.currentTarget),EGButton(EGComponent(_object).extention).controllerObj);
      }
   }
}
