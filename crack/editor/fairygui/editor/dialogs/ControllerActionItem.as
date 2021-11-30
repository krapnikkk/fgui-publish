package fairygui.editor.dialogs
{
   import fairygui.GComponent;
   import fairygui.GList;
   import fairygui.GObject;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.gui.EController;
   import fairygui.editor.gui.EControllerAction;
   import fairygui.editor.props.ControllerActionPropsPanel;
   import fairygui.editor.props.PropsPanel;
   import fairygui.editor.utils.UtilsStr;
   import flash.events.Event;
   
   public class ControllerActionItem extends GComponent
   {
       
      
      private var _action:EControllerAction;
      
      public function ControllerActionItem()
      {
         super();
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
         getChild("edit").addClickListener(this.__editAction);
         getChild("delete").addClickListener(this.__deleteAction);
         getChild("fromPage").addClickListener(this.__selectFromPage);
         getChild("toPage").addClickListener(this.__selectToPage);
         getChild("transitionName").addClickListener(this.__selectTrans);
         getChild("controllerName").addClickListener(this.__selectController);
         getChild("targetPage").addClickListener(this.__selectTargetPage);
      }
      
      public function setAction(param1:EControllerAction) : void
      {
         this._action = param1;
         this.setObjectToUI();
      }
      
      public function setObjectToUI() : void
      {
         var _loc1_:EController = null;
         var _loc3_:EditorWindow = EditorWindow.getInstance(this);
         var _loc2_:EController = ControllerEditDialog(_loc3_.getDialog(ControllerEditDialog)).editingController;
         getChild("fromPage").text = _loc2_.getNamesByIds(this._action.fromPage,Consts.g.text172);
         getChild("toPage").text = _loc2_.getNamesByIds(this._action.toPage,Consts.g.text172);
         getController("type").selectedPage = this._action.type;
         if(this._action.type == "play_transition")
         {
            getChild("transitionName").text = UtilsStr.readableString(this._action.transitionName);
         }
         else
         {
            getChild("controllerName").text = UtilsStr.readableString(this._action.getFullControllerName(_loc2_.parent));
            _loc1_ = this._action.getControllerObj(_loc2_.parent);
            if(_loc1_ && _loc1_.parent)
            {
               getChild("targetPage").text = _loc1_.getNameById(this._action.targetPage,Consts.g.text331);
            }
            else
            {
               getChild("targetPage").text = Consts.g.text331;
            }
         }
      }
      
      private function __editAction(param1:Event) : void
      {
         var _loc2_:ControllerActionPropsPanel = null;
         var _loc3_:EditorWindow = EditorWindow.getInstance(this);
         if(this._action.type == "play_transition")
         {
            _loc2_ = _loc3_.mainPanel.propsPanelList.playTransActionProps;
         }
         _loc3_.groot.togglePopup(_loc2_,GObject(param1.currentTarget),null,true);
         _loc2_.update(this._action);
      }
      
      private function __deleteAction(param1:Event) : void
      {
         var _loc3_:EditorWindow = EditorWindow.getInstance(this);
         var _loc2_:EController = ControllerEditDialog(_loc3_.getDialog(ControllerEditDialog)).editingController;
         _loc2_.removeAction(this._action);
         GList(parent).removeChildToPool(this);
      }
      
      private function __selectFromPage(param1:Event) : void
      {
         var _loc3_:EditorWindow = EditorWindow.getInstance(this);
         var _loc2_:EController = ControllerEditDialog(_loc3_.getDialog(ControllerEditDialog)).editingController;
         _loc3_.selectMultiplePageMenu.show(_loc2_,this._action.fromPage,this.__pagesChanged1,GObject(param1.currentTarget));
      }
      
      private function __selectToPage(param1:Event) : void
      {
         var _loc3_:EditorWindow = EditorWindow.getInstance(this);
         var _loc2_:EController = ControllerEditDialog(_loc3_.getDialog(ControllerEditDialog)).editingController;
         _loc3_.selectMultiplePageMenu.show(_loc2_,this._action.toPage,this.__pagesChanged2,GObject(param1.currentTarget));
      }
      
      private function __pagesChanged1(param1:Array) : void
      {
         this._action.fromPage = param1;
         this.setObjectToUI();
      }
      
      private function __pagesChanged2(param1:Array) : void
      {
         this._action.toPage = param1;
         this.setObjectToUI();
      }
      
      private function __selectTrans(param1:Event) : void
      {
         var _loc3_:EditorWindow = EditorWindow.getInstance(this);
         var _loc2_:EController = ControllerEditDialog(_loc3_.getDialog(ControllerEditDialog)).editingController;
         _loc3_.selectTransitionMenu.show(GObject(param1.currentTarget),_loc2_.parent);
      }
      
      private function __selectController(param1:Event) : void
      {
         var _loc3_:EditorWindow = EditorWindow.getInstance(this);
         var _loc2_:EController = ControllerEditDialog(_loc3_.getDialog(ControllerEditDialog)).editingController;
         _loc3_.selectControllerMenu.show(GObject(param1.currentTarget),_loc2_.parent,true);
      }
      
      private function __selectTargetPage(param1:Event) : void
      {
         var _loc3_:EditorWindow = EditorWindow.getInstance(this);
         var _loc2_:EController = ControllerEditDialog(_loc3_.getDialog(ControllerEditDialog)).editingController;
         _loc3_.selectPageMenu.show(GObject(param1.currentTarget),this._action.getControllerObj(_loc2_.parent));
      }
      
      protected function __propChanged(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc4_:GObject = GObject(param1.currentTarget);
         var _loc2_:String = _loc4_.name;
         if(!this._action.hasOwnProperty(_loc2_))
         {
            return;
         }
         if(_loc2_ == "controllerName")
         {
            _loc3_ = _loc4_.text.indexOf(".");
            if(_loc3_ == -1)
            {
               this._action.objectId = null;
               this._action.controllerName = _loc4_.text;
            }
            else
            {
               this._action.objectId = _loc4_.text.substr(0,_loc3_);
               this._action.controllerName = _loc4_.text.substr(_loc3_ + 1);
            }
         }
         else
         {
            PropsPanel.setTargetProperty(this._action,_loc4_,_loc2_);
         }
         this.setObjectToUI();
      }
   }
}
