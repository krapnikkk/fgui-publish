package fairygui.editor.dialogs
{
   import fairygui.GList;
   import fairygui.GObject;
   import fairygui.PopupMenu;
   import fairygui.UIPackage;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.gui.EController;
   import fairygui.editor.gui.EControllerAction;
   import fairygui.editor.gui.EControllerPage;
   import fairygui.editor.gui.EGComponent;
   import fairygui.event.ItemEvent;
   import flash.events.Event;
   
   public class ControllerEditDialog extends WindowBase
   {
       
      
      private var _sourceController:EController;
      
      private var _controller:EController;
      
      private var _pageList:GList;
      
      private var _buttonMenu:PopupMenu;
      
      private var _actionList:GList;
      
      private var _actionMenu:PopupMenu;
      
      public function ControllerEditDialog(param1:EditorWindow)
      {
         param1 = param1;
         var win:EditorWindow = param1;
         super();
         _editorWindow = win;
         this.contentPane = UIPackage.createObject("Builder","ControllerEditDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this._controller = new EController();
         this._pageList = contentPane.getChild("pageList").asList;
         contentPane.getChild("save").addClickListener(this.__save);
         contentPane.getChild("cancel").addClickListener(closeEventHandler);
         this._actionList = contentPane.getChild("actionList").asList;
         contentPane.getChild("name").asLabel.getTextField().asTextInput.disableIME = true;
         this._buttonMenu = new PopupMenu();
         this._buttonMenu.contentPane.width = 350;
         this._buttonMenu.addItem("up/down/over/selectedOver",this.__setButtonPages);
         this._buttonMenu.addItem("up/down",this.__setButtonPages);
         this._buttonMenu.addItem("up/down/over/selectedOver/disabled/selectedDisabled",this.__setButtonPages);
         this._buttonMenu.addItem("up/down/disabled/selectedDisabled",this.__setButtonPages);
         this._actionMenu = new PopupMenu();
         this._actionMenu.addItem(Consts.g.text337,function():void
         {
            addAction("play_transition");
         });
         this._actionMenu.addItem(Consts.g.text338,function():void
         {
            addAction("change_page");
         });
         contentPane.getChild("addPage").addClickListener(function():void
         {
            addPage("");
         });
         contentPane.getChild("removePage").addClickListener(this.__removePage);
         contentPane.getChild("moveUp").addClickListener(this.__moveUp);
         contentPane.getChild("moveDown").addClickListener(this.__moveDown);
         contentPane.getChild("buttonTemplate").addClickListener(function(param1:Event):void
         {
            _buttonMenu.show(GObject(param1.target));
         });
         contentPane.getChild("deleteController").addClickListener(this.__deleteController);
         contentPane.getChild("addAction").addClickListener(function(param1:Event):void
         {
            _actionMenu.show(GObject(param1.target));
         });
      }
      
      public function open(param1:EController) : void
      {
         var _loc7_:EGComponent = null;
         var _loc2_:int = 0;
         var _loc3_:EControllerPage = null;
         var _loc5_:ControllerPageItem = null;
         var _loc4_:ControllerActionItem = null;
         show();
         this._sourceController = param1;
         if(this._sourceController == null)
         {
            this.frame.text = Consts.g.text65;
            this._controller.parent = _editorWindow.activeComDocument.editingContent;
            this._controller.reset();
            _loc7_ = _editorWindow.activeComDocument.editingContent;
            _loc2_ = 1;
            while(_loc7_.getController("c" + _loc2_) != null)
            {
               _loc2_++;
            }
            this._controller.name = "c" + _loc2_;
         }
         else
         {
            this.frame.text = Consts.g.text66;
            this._controller.parent = param1.parent;
            this._controller.copyFrom(this._sourceController);
         }
         contentPane.getChild("name").text = this._controller.name;
         contentPane.getChild("alias").text = this._controller.alias;
         contentPane.getChild("autoRadioGroupDepth").asButton.selected = this._controller.autoRadioGroupDepth;
         contentPane.getChild("exported").asButton.selected = this._controller.exported;
         contentPane.getChild("deleteController").visible = this._sourceController != null;
         this._pageList.removeChildrenToPool();
         var _loc8_:Vector.<EControllerPage> = this._controller.getPages();
         _loc2_ = 0;
         while(_loc2_ < _loc8_.length)
         {
            _loc3_ = _loc8_[_loc2_];
            _loc5_ = ControllerPageItem(this._pageList.addItemFromPool());
            _loc5_.setIndex(_loc2_);
            _loc5_.setPage(_loc3_);
            _loc2_++;
         }
         this._actionList.removeChildrenToPool();
         var _loc6_:Vector.<EControllerAction> = this._controller.getActions();
         _loc2_ = 0;
         while(_loc2_ < _loc6_.length)
         {
            _loc4_ = ControllerActionItem(this._actionList.addItemFromPool());
            _loc4_.setAction(_loc6_[_loc2_]);
            _loc2_++;
         }
         contentPane.getController("c1").selectedIndex = this._actionList.numChildren > 0?1:0;
      }
      
      override protected function onHide() : void
      {
         _editorWindow.mainPanel.editPanel.self.requestFocus();
      }
      
      public function get editingController() : EController
      {
         return this._controller;
      }
      
      private function addPage(param1:String) : void
      {
         var _loc3_:EControllerPage = this._controller.addPage(param1);
         var _loc2_:ControllerPageItem = ControllerPageItem(this._pageList.addItemFromPool());
         _loc2_.setIndex(this._pageList.numChildren - 1);
         _loc2_.setPage(_loc3_);
         this._pageList.scrollPane.scrollBottom();
      }
      
      private function addAction(param1:String) : void
      {
         var _loc3_:EControllerAction = this._controller.addAction(param1);
         var _loc2_:ControllerActionItem = ControllerActionItem(this._actionList.addItemFromPool());
         _loc2_.setAction(_loc3_);
         this._actionList.scrollPane.scrollBottom();
         contentPane.getController("c1").selectedIndex = 1;
      }
      
      private function __save(param1:Event) : void
      {
         var _loc5_:EController = null;
         var _loc6_:XML = null;
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         this._controller.name = contentPane.getChild("name").text;
         this._controller.alias = contentPane.getChild("alias").text;
         this._controller.autoRadioGroupDepth = contentPane.getChild("autoRadioGroupDepth").asButton.selected;
         this._controller.exported = contentPane.getChild("exported").asButton.selected;
         var _loc7_:EGComponent = _editorWindow.activeComDocument.editingContent;
         if(!this._sourceController)
         {
            _loc5_ = new EController();
            _loc5_.copyFrom(this._controller);
            _loc7_.addController(_loc5_,false);
            _editorWindow.activeComDocument.actionHistory.action_controllerAdd(_loc5_);
            _loc7_.applyController(_loc5_);
            _editorWindow.mainPanel.editPanel.updateControllerPanel();
         }
         else
         {
            _loc6_ = this._sourceController.toXML();
            _loc2_ = this._controller.toXML();
            _loc3_ = _loc6_.toXMLString();
            _loc4_ = _loc2_.toXMLString();
            if(_loc3_ != _loc4_)
            {
               this._sourceController.copyFrom(this._controller);
               _editorWindow.activeComDocument.actionHistory.action_controllerChanged(this._controller,_loc6_,_loc2_);
               _loc7_.applyController(this._sourceController);
            }
            _editorWindow.mainPanel.editPanel.updateControllerPanel(this._sourceController);
         }
         _editorWindow.mainPanel.propsPanelList.refresh();
         this.hide();
      }
      
      private function __setButtonPages(param1:ItemEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = param1.itemObject.text.split("/");
         contentPane.getChild("name").text = "button";
         var _loc5_:int = 0;
         var _loc4_:* = _loc3_;
         for each(_loc2_ in _loc3_)
         {
            if(!this._controller.hasPageName(_loc2_))
            {
               this.addPage(_loc2_);
            }
         }
      }
      
      private function __removePage(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = 0;
         var _loc4_:int = this._pageList.selectedIndex;
         if(_loc4_ != -1)
         {
            this._controller.removePageAt(_loc4_);
            this._pageList.removeChildToPoolAt(_loc4_);
            if(_loc4_ >= this._pageList.numChildren)
            {
               _loc4_ = this._pageList.numChildren - 1;
            }
            this._pageList.selectedIndex = _loc4_;
            _loc2_ = this._pageList.numChildren;
            if(_loc2_ > 0)
            {
               _loc3_ = _loc4_;
               while(_loc3_ < _loc2_)
               {
                  ControllerPageItem(this._pageList.getChildAt(_loc3_)).setIndex(_loc3_);
                  _loc3_++;
               }
            }
         }
      }
      
      private function __moveUp(param1:Event) : void
      {
         var _loc2_:ControllerPageItem = null;
         var _loc3_:ControllerPageItem = null;
         var _loc4_:int = this._pageList.selectedIndex;
         if(_loc4_ > 0)
         {
            this._controller.swapPage(_loc4_,_loc4_ - 1);
            _loc2_ = ControllerPageItem(this._pageList.getChildAt(_loc4_));
            _loc3_ = ControllerPageItem(this._pageList.getChildAt(_loc4_ - 1));
            this._pageList.swapChildrenAt(_loc4_,_loc4_ - 1);
            _loc2_.setIndex(_loc4_ - 1);
            _loc3_.setIndex(_loc4_);
            this._pageList.selectedIndex = _loc4_ - 1;
         }
      }
      
      private function __moveDown(param1:Event) : void
      {
         var _loc2_:ControllerPageItem = null;
         var _loc3_:ControllerPageItem = null;
         var _loc4_:int = this._pageList.selectedIndex;
         if(_loc4_ < this._pageList.numChildren - 1)
         {
            this._controller.swapPage(_loc4_,_loc4_ + 1);
            _loc2_ = ControllerPageItem(this._pageList.getChildAt(_loc4_));
            _loc3_ = ControllerPageItem(this._pageList.getChildAt(_loc4_ + 1));
            this._pageList.swapChildrenAt(_loc4_,_loc4_ + 1);
            _loc2_.setIndex(_loc4_ + 1);
            _loc3_.setIndex(_loc4_);
            this._pageList.selectedIndex = _loc4_ + 1;
         }
      }
      
      private function __deleteController(param1:Event) : void
      {
         param1 = param1;
         var evt:Event = param1;
         _editorWindow.confirm(Consts.g.text237,function():void
         {
            _editorWindow.activeComDocument.actionHistory.action_controllerRemove(_sourceController);
            _controller.parent.removeController(_sourceController);
            _editorWindow.mainPanel.editPanel.updateControllerPanel();
            _editorWindow.mainPanel.propsPanelList.refresh();
            hide();
         });
      }
   }
}
