package fairygui.editor.props
{
   import fairygui.GComponent;
   import fairygui.GObject;
   import fairygui.UIPackage;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.gui.EControllerAction;
   import flash.events.Event;
   
   public class ControllerActionPropsPanel extends GComponent
   {
       
      
      protected var _action:EControllerAction;
      
      protected var _editorWindow:EditorWindow;
      
      public function ControllerActionPropsPanel(param1:EditorWindow, param2:String)
      {
         super();
         this._editorWindow = param1;
         UIPackage.createObject("Builder",param2,this);
      }
      
      public function update(param1:EControllerAction) : void
      {
         this._action = param1;
         this.setObjectToUI();
      }
      
      protected function setObjectToUI() : void
      {
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         var _loc3_:GObject = null;
         super.constructFromXML(param1);
         var _loc4_:int = numChildren;
         var _loc2_:int = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = getChildAt(_loc2_);
            _loc3_.addEventListener("stateChanged",this.__propChanged);
            _loc3_.addEventListener("__submit",this.__propChanged);
            _loc2_++;
         }
      }
      
      protected function __propChanged(param1:Event) : void
      {
         var _loc3_:GObject = GObject(param1.currentTarget);
         var _loc2_:String = _loc3_.name;
         if(!this._action.hasOwnProperty(_loc2_))
         {
            return;
         }
         PropsPanel.setTargetProperty(this._action,_loc3_,_loc2_);
         this.setObjectToUI();
      }
   }
}
