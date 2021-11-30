package fairygui.editor.props
{
   import fairygui.GButton;
   import fairygui.GComboBox;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.ColorInput;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.EGLoader;
   
   public class LoaderPropsPanel extends PropsPanel
   {
       
      
      private var _fillEditBtn:GButton;
      
      public function LoaderPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         var _loc2_:GComboBox = null;
         super.constructFromXML(param1);
         _loc2_ = getChild("align").asComboBox;
         _loc2_.items = [Consts.g.text153,Consts.g.text154,Consts.g.text155];
         _loc2_.values = ["left","center","right"];
         _loc2_ = getChild("verticalAlign").asComboBox;
         _loc2_.items = [Consts.g.text156,Consts.g.text157,Consts.g.text158];
         _loc2_.values = ["top","middle","bottom"];
         _loc2_ = getChild("fill").asComboBox;
         _loc2_.items = [Consts.g.text139,Consts.g.text159,Consts.g.text308,Consts.g.text309,Consts.g.text160];
         _loc2_.values = ["none","scale","scaleMatchHeight","scaleMatchWidth","scaleFree"];
         _loc2_ = getChild("autoSize").asComboBox;
         _loc2_.items = [Consts.g.text161,Consts.g.text162];
         _loc2_.values = ["false","true"];
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
         var _loc4_:EGLoader = EGLoader(_object);
         getChild("url").text = _loc4_.url;
         getChild("align").asComboBox.value = _loc4_.align;
         getChild("verticalAlign").asComboBox.value = _loc4_.verticalAlign;
         getChild("autoSize").asComboBox.value = !!_loc4_.autoSize?"true":"false";
         getChild("fill").asComboBox.value = _loc4_.fill;
         getChild("playing").asButton.selected = _loc4_.playing;
         getChild("frame").text = "" + _loc4_.frame;
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
         getChild("fillMethod").asComboBox.value = _loc4_.fillMethod;
         this._fillEditBtn.visible = _loc4_.fillMethod != "none";
      }
   }
}
