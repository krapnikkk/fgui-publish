package fairygui.editor.props
{
   import fairygui.GComponent;
   import fairygui.GObject;
   import fairygui.UIPackage;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.gui.EGComponent;
   import fairygui.editor.gui.EGObject;
   import flash.events.Event;
   
   public class SubPropsPanel extends GComponent
   {
       
      
      protected var _isExtention:Boolean;
      
      protected var _objects:Vector.<EGObject>;
      
      protected var _object:EGObject;
      
      protected var _propChanged:Boolean;
      
      protected var _editorWindow:EditorWindow;
      
      public function SubPropsPanel(param1:EditorWindow, param2:String)
      {
         super();
         this._editorWindow = param1;
         UIPackage.createObject("Builder",param2,this);
      }
      
      public function update(param1:Vector.<EGObject>) : void
      {
         this._objects = param1;
         this._object = this._objects[0];
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
         this.addEventListener("removedFromStage",this.__removedFromStage);
      }
      
      protected function __propChanged(param1:Event) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         this._propChanged = true;
         var _loc6_:GObject = GObject(param1.currentTarget);
         var _loc4_:int = this._objects.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = this._objects[_loc5_];
            if(this._isExtention)
            {
               _loc2_ = EGComponent(_loc2_).extention;
            }
            _loc3_ = _loc6_.name;
            if(!_loc2_.hasOwnProperty(_loc3_))
            {
               return;
            }
            PropsPanel.setTargetProperty(_loc2_,_loc6_,_loc3_);
            _loc5_++;
         }
         this.setObjectToUI();
      }
      
      private function __removedFromStage(param1:Event) : void
      {
         if(this._propChanged)
         {
            this._propChanged = false;
            this._editorWindow.mainPanel.propsPanelList.refresh();
         }
      }
   }
}
