package fairygui.editor.props
{
   import fairygui.GButton;
   import fairygui.GComboBox;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.NumericInput;
   
   public class FillPropsPanel extends SubPropsPanel
   {
       
      
      private var _fillOriginItems:Object;
      
      private var _fillOrigin:GComboBox;
      
      private var _fillClockwise:GButton;
      
      public function FillPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc2_:Object = _object;
         var _loc1_:Array = this._fillOriginItems[_loc2_.fillMethod];
         this._fillOrigin.items = _loc1_[0];
         this._fillOrigin.values = _loc1_[1];
         this._fillOrigin.selectedIndex = _loc2_.fillOrigin;
         this._fillClockwise.enabled = _loc2_.fillMethod != "hz" && _loc2_.fillMethod != "vt";
         this._fillClockwise.selected = this._fillClockwise.enabled && _loc2_.fillClockwise;
         NumericInput(getChild("fillAmount")).value = _loc2_.fillAmount;
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         param1 = param1;
         var xml:XML = param1;
         super.constructFromXML(xml);
         with(NumericInput(getChild("fillAmount")))
         {
            
            max = 100;
         }
         this._fillOriginItems = {
            "hz":[[Consts.g.text274,Consts.g.text275],["0","1"]],
            "vt":[[Consts.g.text276,Consts.g.text277],["0","1"]],
            "radial90":[[Consts.g.text278,Consts.g.text280,Consts.g.text279,Consts.g.text281],["0","1","2","3"]],
            "radial180":[[Consts.g.text276,Consts.g.text277,Consts.g.text274,Consts.g.text275],["0","1","2","3"]],
            "radial360":[[Consts.g.text276,Consts.g.text277,Consts.g.text274,Consts.g.text275],["0","1","2","3"]]
         };
         this._fillOrigin = getChild("fillOrigin").asComboBox;
         this._fillClockwise = getChild("fillClockwise").asButton;
      }
   }
}
