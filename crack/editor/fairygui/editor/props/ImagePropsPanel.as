package fairygui.editor.props
{
   import fairygui.GButton;
   import fairygui.GComboBox;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.ColorInput;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.EGImage;
   
   public class ImagePropsPanel extends PropsPanel
   {
       
      
      private var _fillEditBtn:GButton;
      
      public function ImagePropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         var _loc2_:GComboBox = null;
         super.constructFromXML(param1);
         ColorInput(getChild("color")).showAlpha = false;
         NumericInput(getChild("brightness")).max = 255;
         _loc2_ = getChild("fillMethod").asComboBox;
         _loc2_.items = [Consts.g.text139,Consts.g.text268,Consts.g.text269,Consts.g.text270,Consts.g.text271,Consts.g.text272];
         _loc2_.values = ["none","hz","vt","radial90","radial180","radial360"];
         this._fillEditBtn = getChild("fillEdit").asButton;
         initSubPropsButton(this._fillEditBtn,"fillProps");
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc4_:EGImage = EGImage(_object);
         ColorInput(getChild("color")).argb = _loc4_.color;
         var _loc3_:* = _loc4_.color >> 16 & 255;
         var _loc1_:* = _loc4_.color >> 8 & 255;
         var _loc2_:* = _loc4_.color & 255;
         if(_loc3_ == _loc1_ && _loc1_ == _loc2_)
         {
            NumericInput(getChild("brightness")).value = _loc3_;
         }
         else
         {
            NumericInput(getChild("brightness")).value = 255;
         }
         getChild("flipHZ").asButton.selected = _loc4_.flip == "hz" || _loc4_.flip == "both";
         getChild("flipVT").asButton.selected = _loc4_.flip == "vt" || _loc4_.flip == "both";
         getChild("fillMethod").asComboBox.value = _loc4_.fillMethod;
         this._fillEditBtn.visible = _loc4_.fillMethod != "none";
      }
   }
}
