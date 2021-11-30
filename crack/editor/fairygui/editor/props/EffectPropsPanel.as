package fairygui.editor.props
{
   import fairygui.GButton;
   import fairygui.GComboBox;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   
   public class EffectPropsPanel extends PropsPanel
   {
       
      
      private var _blenMode:GComboBox;
      
      private var _filter:GComboBox;
      
      private var _filterEditBtn:GButton;
      
      public function EffectPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
         this._blenMode = getChild("blendMode").asComboBox;
         this._blenMode.items = ["Normal","None","Add","Multiply","Screen"];
         this._blenMode.values = ["normal","none","add","multiply","screen"];
         this._filter = getChild("filter").asComboBox;
         this._filter.items = [Consts.g.text139,Consts.g.text288];
         this._filter.values = ["none","color"];
         this._filterEditBtn = getChild("filterEdit").asButton;
         initSubPropsButton(this._filterEditBtn,"filterProps");
      }
      
      override protected function setObjectToUI() : void
      {
         this._blenMode.value = _object.blendMode;
         this._filter.value = _object.filter;
         this._filterEditBtn.visible = _object.filter != "none";
      }
   }
}
