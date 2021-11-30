package fairygui.editor.props
{
   import fairygui.GButton;
   import fairygui.GComboBox;
   import fairygui.GObject;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.dialogs.ChooseFontDialog;
   import fairygui.editor.extui.ColorInput;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.extui.ResourceInput;
   import fairygui.editor.gui.EGTextField;
   import flash.events.Event;
   
   public class TextPropsPanel extends PropsPanel
   {
       
      
      private var _inputEditBtn:GButton;
      
      public function TextPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         param1 = param1;
         var cb:GComboBox = null;
         var xml:XML = param1;
         super.constructFromXML(xml);
         with(NumericInput(getChild("leading")))
         {
            
            min = int.MIN_VALUE;
         }
         with(NumericInput(getChild("letterSpacing")))
         {
            
            min = int.MIN_VALUE;
         }
         with(NumericInput(getChild("shadowX")))
         {
            
            min = int.MIN_VALUE;
         }
         with(NumericInput(getChild("shadowY")))
         {
            
            min = int.MIN_VALUE;
         }
         cb = getChild("align").asComboBox;
         cb.items = [Consts.g.text153,Consts.g.text154,Consts.g.text155];
         cb.values = ["left","center","right"];
         cb = getChild("verticalAlign").asComboBox;
         cb.items = [Consts.g.text156,Consts.g.text157,Consts.g.text158];
         cb.values = ["top","middle","bottom"];
         cb = getChild("autoSize").asComboBox;
         cb.items = [Consts.g.text139,Consts.g.text168,Consts.g.text169,Consts.g.text304];
         cb.values = ["none","both","height","shrink"];
         ColorInput(getChild("color")).showAlpha = false;
         ColorInput(getChild("strokeColor")).showAlpha = false;
         getChild("fontSizePreset").addClickListener(this.__clickSizePreset);
         getChild("chooseFont").addClickListener(this.__clickChooseFont);
         ResourceInput(getChild("font")).isFontInput = true;
         this._inputEditBtn = getChild("inputEdit").asButton;
         initSubPropsButton(this._inputEditBtn,"textInputProps");
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc1_:EGTextField = EGTextField(_object);
         getChild("text").text = _loc1_.text;
         getChild("font").text = _loc1_.font;
         getChild("fontSize").text = "" + _loc1_.fontSize;
         getChild("ubbEnabled").asButton.selected = _loc1_.ubbEnabled;
         ColorInput(getChild("color")).argb = _loc1_.color;
         getChild("autoSize").asComboBox.value = _loc1_.autoSize;
         getChild("align").asComboBox.value = _loc1_.align;
         getChild("verticalAlign").asComboBox.value = _loc1_.verticalAlign;
         getChild("leading").text = "" + _loc1_.leading;
         getChild("letterSpacing").text = "" + _loc1_.letterSpacing;
         getChild("underline").asButton.selected = _loc1_.underline;
         getChild("italic").asButton.selected = _loc1_.italic;
         getChild("bold").asButton.selected = _loc1_.bold;
         getChild("input").asButton.selected = _loc1_.input;
         getChild("singleLine").asButton.selected = _loc1_.singleLine;
         getChild("stroke").asButton.selected = _loc1_.stroke;
         ColorInput(getChild("strokeColor")).argb = _loc1_.strokeColor;
         getChild("strokeSize").text = "" + _loc1_.strokeSize;
         getChild("shadow").asButton.selected = _loc1_.shadow;
         NumericInput(getChild("shadowX")).value = _loc1_.shadowX;
         NumericInput(getChild("shadowY")).value = _loc1_.shadowY;
         this._inputEditBtn.visible = _loc1_.input;
      }
      
      private function __clickSizePreset(param1:Event) : void
      {
         param1.stopPropagation();
         _editorWindow.fontSizePresetMenu.show(NumericInput(getChild("fontSize")),GObject(param1.currentTarget));
      }
      
      private function __clickChooseFont(param1:Event) : void
      {
         ChooseFontDialog(_editorWindow.getDialog(ChooseFontDialog)).open(this.__selectFont);
      }
      
      private function __selectFont(param1:String) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = _objects.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = _objects[_loc2_];
            _loc3_.setProperty("font",param1);
            _loc2_++;
         }
         this.setObjectToUI();
      }
   }
}
