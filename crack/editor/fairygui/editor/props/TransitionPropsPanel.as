package fairygui.editor.props
{
   import fairygui.editor.ComDocument;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.EGObject;
   import fairygui.editor.gui.ETransition;
   import flash.events.Event;
   
   public class TransitionPropsPanel extends PropsPanel
   {
       
      
      public function TransitionPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
         _isTransition = true;
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         param1 = param1;
         var xml:XML = param1;
         super.constructFromXML(xml);
         NumericInput(getChild("autoPlayRepeat")).min = -1;
         with(NumericInput(getChild("autoPlayDelay")))
         {
            
            step = 0.001;
            fractionDigits = 3;
         }
         getChild("name").asLabel.getTextField().asTextInput.disableIME = true;
         getChild("delete").addClickListener(this.__clickDelete);
         getChild("duplicate").addClickListener(this.__clickDuplicate);
      }
      
      override public function update(param1:Vector.<EGObject>) : void
      {
         var _loc2_:ComDocument = _editorWindow.activeComDocument;
         getChild("name").text = _loc2_.editingTransition.name;
         getChild("ignoreDisplayController").asButton.selected = _loc2_.editingTransition.ignoreDisplayController;
         getChild("autoPlay").asButton.selected = _loc2_.editingTransition.autoPlay;
         NumericInput(getChild("autoPlayRepeat")).value = _loc2_.editingTransition.autoPlayRepeat;
         NumericInput(getChild("autoPlayDelay")).value = _loc2_.editingTransition.autoPlayDelay;
         getChild("autoStop").asButton.selected = _loc2_.editingTransition.autoStop;
         getChild("autoStopAtEnd").asComboBox.value = !!_loc2_.editingTransition.autoStopAtEnd?"true":"false";
      }
      
      private function __clickDelete(param1:Event) : void
      {
         var _loc5_:ComDocument = _editorWindow.activeComDocument;
         var _loc3_:ETransition = _loc5_.editingTransition;
         var _loc4_:XML = _loc5_.editingContent.transitions.toXML(false);
         _loc5_.editingContent.transitions.removeItem(_loc3_);
         var _loc2_:XML = _loc5_.editingContent.transitions.toXML(false);
         _loc5_.finishEditingTransition();
         _loc5_.actionHistory.action_transitionsChanged(_loc5_.editingContent,_loc4_,_loc2_);
         _loc5_.setModified();
      }
      
      private function __clickDuplicate(param1:Event) : void
      {
         var _loc6_:ComDocument = _editorWindow.activeComDocument;
         var _loc4_:XML = _loc6_.editingContent.transitions.toXML(false);
         var _loc5_:ETransition = _loc6_.editingContent.transitions.addItem();
         var _loc2_:XML = _loc6_.editingTransition.toXML(false);
         _loc2_.@name = _loc5_.name;
         _loc5_.fromXML(_loc2_);
         var _loc3_:XML = _loc6_.editingContent.transitions.toXML(false);
         _loc6_.finishEditingTransition();
         _loc6_.actionHistory.action_transitionsChanged(_loc6_.editingContent,_loc4_,_loc3_);
         _loc6_.setModified();
      }
   }
}
