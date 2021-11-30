package fairygui.editor.props
{
   import fairygui.GComboBox;
   import fairygui.GObject;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.EGGroup;
   import fairygui.editor.gui.EGObject;
   import fairygui.editor.utils.UtilsStr;
   import flash.events.Event;
   
   public class GroupPropsPanel extends PropsPanel
   {
       
      
      public function GroupPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         param1 = param1;
         var cb:GComboBox = null;
         var xml:XML = param1;
         super.constructFromXML(xml);
         with(NumericInput(getChild("lineGap")))
         {
            
            min = int.MIN_VALUE;
         }
         with(NumericInput(getChild("columnGap")))
         {
            
            min = int.MIN_VALUE;
         }
         NumericInput(getChild("x")).min = -2147483648;
         NumericInput(getChild("y")).min = -2147483648;
         getChild("name").asLabel.getTextField().asTextInput.disableIME = true;
         getChild("name").addEventListener("__submit",this.__nameChanged,false,1);
         getController("c1").addEventListener("stateChanged",this.__groupTypeChanged);
         cb = getChild("layout").asComboBox;
         cb.items = [Consts.g.text139,Consts.g.text332,Consts.g.text333];
         cb.values = ["none","hz","vt"];
      }
      
      override public function update(param1:Vector.<EGObject>) : void
      {
         if(_object)
         {
            _object.statusDispatcher.removeListener(1,this.updateOutline);
            _object.statusDispatcher.removeListener(2,this.updateOutline);
         }
         super.update(param1);
         if(param1.length == 1)
         {
            _object.statusDispatcher.addListener(1,this.updateOutline);
            _object.statusDispatcher.addListener(2,this.updateOutline);
         }
      }
      
      override protected function setObjectToUI() : void
      {
         this.updateOutline();
         this.updateEtc();
      }
      
      private function updateOutline() : void
      {
         getChild("x").text = "" + _object.x;
         getChild("y").text = "" + _object.y;
         getChild("width").text = "" + _object.width;
         getChild("height").text = "" + _object.height;
      }
      
      private function updateEtc() : void
      {
         var _loc1_:EGGroup = EGGroup(_object);
         getChild("name").text = _object.name;
         getChild("invisible").asButton.selected = _object.invisible;
         getController("c1").setSelectedIndex(!!_loc1_.advanced?1:0);
         getChild("layout").asComboBox.value = _loc1_.layout;
         NumericInput(getChild("lineGap")).value = _loc1_.lineGap;
         NumericInput(getChild("columnGap")).value = _loc1_.columnGap;
      }
      
      private function __groupTypeChanged(param1:Event) : void
      {
         var _loc3_:EGGroup = null;
         var _loc4_:int = _objects.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = EGGroup(_objects[_loc2_]);
            if(getController("c1").selectedIndex == 1)
            {
               _loc3_.setProperty("advanced",true);
            }
            else
            {
               _loc3_.setProperty("advanced",false);
            }
            if(_loc3_.rangeEditor)
            {
               _loc3_.rangeEditor.synEditorRange();
            }
            _loc2_++;
         }
         _editorWindow.mainPanel.propsPanelList.refresh();
      }
      
      private function __nameChanged(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:EGObject = null;
         var _loc4_:String = null;
         param1.stopImmediatePropagation();
         var _loc8_:GObject = GObject(param1.currentTarget);
         var _loc6_:String = _loc8_.text;
         var _loc7_:int = _loc6_.indexOf("#");
         if(_loc7_ == -1)
         {
            _loc2_ = _objects.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc5_ = _objects[_loc3_];
               _loc5_.setProperty("name",_loc6_);
               _editorWindow.mainPanel.childrenPanel.update(_loc5_);
               _loc3_++;
            }
         }
         else
         {
            _loc6_ = _loc6_.replace(/\#/g,"{0}");
            _loc2_ = _objects.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc5_ = _objects[_loc3_];
               _loc4_ = UtilsStr.formatString(_loc6_,_loc3_);
               _loc5_.setProperty("name",_loc4_);
               _editorWindow.mainPanel.childrenPanel.update(_loc5_);
               _loc3_++;
            }
         }
         getChild("name").text = _object.name;
      }
   }
}
