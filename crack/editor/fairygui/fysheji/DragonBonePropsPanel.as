package fairygui.fysheji
{
   import fairygui.GComboBox;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.props.PropsPanel;
   import flash.events.Event;
   
   public class DragonBonePropsPanel extends PropsPanel
   {
       
      
      public function DragonBonePropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2,"Fysheji");
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
      }
      
      private function __focusOut(param1:Event) : void
      {
         this._object.setProperty("frame",getChild("frame").text);
      }
      
      private function __actionChanged(param1:Event) : void
      {
         this._object.setProperty("aniName",getChild("actionComboBox").asComboBox.text);
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc1_:Boolean = false;
         var _loc3_:int = 0;
         var _loc2_:EGDragonBone = EGDragonBone(_object);
         this.getChild("frame").text = "" + _loc2_.frame;
         this.getChild("playing").asButton.selected = _loc2_.playing;
         this.getChild("frame").addEventListener("focusOut",this.__focusOut);
         this.getChild("actionComboBox").addEventListener("stateChanged",this.__actionChanged,false,1);
         if(_loc2_._basebone.actionsName.length > 0)
         {
            getChild("actionComboBox").asComboBox.items = _loc2_._basebone.actionsName;
            _loc1_ = false;
            _loc3_ = 0;
            while(_loc3_ < _loc2_._basebone.actionsName.length)
            {
               if(_loc2_.aniName == _loc2_._basebone.actionsName[_loc3_])
               {
                  _loc1_ = true;
               }
               _loc3_++;
            }
            if(!_loc1_)
            {
               _loc2_.aniName = _loc2_._basebone.actionsName[0];
            }
            getChild("actionComboBox").asComboBox.text = _loc2_.aniName;
            getChild("actionComboBox").asComboBox.addEventListener("stateChanged",this.__pageChanged);
         }
         _loc2_._basebone.setPlay(_loc2_.playing,_loc2_.frame);
      }
      
      private function __pageChanged(param1:Event) : void
      {
         var _loc2_:GComboBox = GComboBox(param1.currentTarget);
         this._object.setProperty("aniName",_loc2_.items[_loc2_.selectedIndex]);
      }
   }
}
