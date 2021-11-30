package fairygui.editor.props
{
   import fairygui.GComboBox;
   import fairygui.GObject;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.gear.EGearBase;
   import flash.events.Event;
   
   public class TweenPropsPanel extends SubPropsPanel
   {
       
      
      private var _gear:EGearBase;
      
      private var actionComboBox:GComboBox;
      
      public function TweenPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      public function update2(param1:EGearBase) : void
      {
         this._gear = param1;
         this.setObjectToUI();
      }
      
      override protected function setObjectToUI() : void
      {
         NumericInput(getChild("duration")).value = this._gear.duration;
         NumericInput(getChild("delay")).value = this._gear.delay;
         getChild("easeType").asComboBox.value = this._gear.easeType;
         getChild("easeInOutType").asComboBox.value = this._gear.easeInOutType;
         getChild("easeInOutType").visible = this._gear.easeType != "Linear";
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
         var _loc4_:GComboBox = getChild("easeType").asComboBox;
         _loc4_.items = Consts.easeType;
         _loc4_.values = Consts.easeType;
         _loc4_.addEventListener("stateChanged",this.__easeTypeChanged);
         _loc4_ = getChild("easeInOutType").asComboBox;
         _loc4_.items = Consts.easeInOutType;
         _loc4_.values = Consts.easeInOutType;
         var _loc2_:NumericInput = NumericInput(getChild("duration"));
         _loc2_.step = 0.1;
         _loc2_.fractionDigits = 2;
         var _loc3_:NumericInput = NumericInput(getChild("delay"));
         _loc3_.step = 0.1;
         _loc3_.fractionDigits = 2;
      }
      
      override protected function __propChanged(param1:Event) : void
      {
         var _loc3_:GObject = GObject(param1.currentTarget);
         var _loc2_:String = _loc3_.name;
         if(!this._gear.hasOwnProperty(_loc2_))
         {
            return;
         }
         PropsPanel.setTargetProperty(this._gear,_loc3_,_loc2_);
         this.setObjectToUI();
      }
      
      private function __easeTypeChanged(param1:Event) : void
      {
         getChild("easeInOutType").visible = getChild("easeType").asComboBox.value != "Linear";
      }
   }
}
