package fairygui.editor
{
   import fairygui.GButton;
   import fairygui.GComponent;
   import fairygui.GList;
   import fairygui.GObject;
   import fairygui.editor.dialogs.ControllerEditDialog;
   import fairygui.editor.gui.EController;
   import fairygui.editor.gui.EControllerPage;
   import fairygui.editor.gui.EGComponent;
   import fairygui.event.ItemEvent;
   import fairygui.utils.GTimers;
   
   public class ControllerPanel
   {
       
      
      public var self:GComponent;
      
      private var _list:GList;
      
      private var _object:EGComponent;
      
      private var _editable:Boolean;
      
      private var _addButton:GObject;
      
      private var _editorWindow:EditorWindow;
      
      public function ControllerPanel(param1:EditorWindow, param2:GComponent, param3:Boolean)
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         var win:EditorWindow = param1;
         var panel:GComponent = param2;
         var editable:Boolean = param3;
         super();
         this.self = panel;
         this._editorWindow = win;
         this._editable = editable;
         this._addButton = this.self.getChild("n5");
         this._addButton.addClickListener(function():void
         {
            ControllerEditDialog(_editorWindow.getDialog(ControllerEditDialog)).open(null);
         });
         this._addButton.visible = editable;
         this._list = this.self.getChild("n1").asList;
         this._list.addSizeChangeCallback(this.__listSizeChanged);
         this._list.addEventListener("itemClick",this.__clickItem);
         this._list.removeChildrenToPool();
         this._list.height = 0;
      }
      
      public function update(param1:EGComponent) : void
      {
         var _loc3_:EController = null;
         var _loc2_:GButton = null;
         if(this._editorWindow.mainPanel.editPanel.timelinePanel.self.visible)
         {
            this.self.visible = false;
            this._list.height = 0;
            return;
         }
         this.self.visible = true;
         this._object = param1;
         this.clear();
         if(this._object == null || this._object.controllers.length == 0)
         {
            return;
         }
         var _loc5_:int = 0;
         var _loc4_:* = this._object.controllers;
         for each(_loc3_ in this._object.controllers)
         {
            _loc2_ = this._list.addItemFromPool().asButton;
            _loc2_.name = _loc3_.name;
            _loc2_.title = _loc3_.name;
            this.setPages(_loc3_,_loc2_,-1);
         }
         this._list.resizeToFit();
      }
      
      public function refresh(param1:EController) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:GButton = null;
         if(param1.parent != this._object)
         {
            return;
         }
         var _loc6_:GComponent = this._list.getChild(param1.name) as GComponent;
         if(_loc6_ == null)
         {
            this.update(this._object);
         }
         else
         {
            _loc4_ = this._list.getChildIndex(_loc6_);
            _loc5_ = this._list.numChildren;
            _loc2_ = _loc4_ + 1;
            while(_loc2_ < _loc5_)
            {
               _loc3_ = this._list.getChildAt(_loc2_) as GButton;
               if(_loc3_.data)
               {
                  this._list.removeChildAt(_loc2_);
                  _loc5_--;
                  continue;
               }
               break;
            }
            this.setPages(param1,_loc6_,_loc2_);
            this._list.resizeToFit();
         }
      }
      
      public function updateSelection(param1:EController) : void
      {
         var _loc4_:GButton = null;
         if(param1.parent != this._object)
         {
            return;
         }
         var _loc7_:GComponent = this._list.getChild(param1.name) as GComponent;
         if(_loc7_ == null)
         {
            return;
         }
         var _loc5_:int = this._list.getChildIndex(_loc7_) + 1;
         var _loc6_:int = this._list.numChildren;
         var _loc2_:int = 0;
         var _loc3_:* = _loc5_;
         while(_loc3_ < _loc6_)
         {
            _loc4_ = this._list.getChildAt(_loc3_) as GButton;
            if(_loc4_.data)
            {
               if(_loc2_ == param1.selectedIndex)
               {
                  _loc4_.selected = true;
               }
               else
               {
                  _loc4_.selected = false;
               }
               _loc2_++;
               _loc3_++;
               continue;
            }
            break;
         }
      }
      
      public function clear() : void
      {
         this._list.removeChildrenToPool();
         if(this._editorWindow.mainPanel.editPanel.activeDocument is ComDocument)
         {
            this._list.height = 25;
         }
         else
         {
            this._list.height = 0;
         }
      }
      
      private function setPages(param1:EController, param2:GComponent, param3:int) : void
      {
         var _loc8_:GButton = null;
         var _loc6_:EControllerPage = null;
         var _loc4_:* = param3 < 0;
         var _loc5_:Vector.<EControllerPage> = param1.getPages();
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_.length)
         {
            if(_loc4_)
            {
               _loc8_ = this._list.addItemFromPool("ui://Builder/ControllerItem").asButton;
            }
            else
            {
               param3++;
               _loc8_ = this._list.addChildAt(this._list.getFromPool("ui://Builder/ControllerItem"),param3).asButton;
            }
            _loc6_ = _loc5_[_loc7_];
            if(_loc6_.name)
            {
               _loc8_.text = _loc7_ + ":" + _loc6_.name;
            }
            else
            {
               _loc8_.text = "" + _loc7_;
            }
            _loc8_.data = param2;
            _loc8_.selected = _loc7_ == param1.selectedIndex;
            _loc7_++;
         }
      }
      
      private function __clickItem(param1:ItemEvent) : void
      {
         var _loc9_:GComponent = null;
         var _loc10_:EController = null;
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         var _loc8_:int = 0;
         var _loc7_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:GComponent = null;
         var _loc5_:ComDocument = null;
         var _loc11_:GButton = param1.itemObject as GButton;
         if(_loc11_.data)
         {
            _loc11_.selected = true;
            _loc9_ = GComponent(_loc11_.data);
            _loc10_ = this._object.getController(_loc9_.name);
            _loc2_ = this._list.getChildIndex(_loc9_);
            _loc4_ = this._list.numChildren;
            _loc8_ = _loc10_.selectedIndex;
            _loc6_ = _loc2_ + 1;
            while(_loc6_ < _loc4_)
            {
               _loc3_ = this._list.getChildAt(_loc6_) as GButton;
               if(_loc3_.data)
               {
                  if(_loc3_ == _loc11_)
                  {
                     _loc7_ = _loc6_ - _loc2_ - 1;
                  }
                  else
                  {
                     GButton(_loc3_).selected = false;
                  }
                  _loc6_++;
                  continue;
               }
               break;
            }
            _loc10_.setSelectedIndex(_loc7_);
            if(this._editable)
            {
               _loc5_ = this._editorWindow.activeComDocument;
               _loc5_.actionHistory.action_controllerSwitched(_loc10_,_loc8_,_loc7_);
               _loc5_.onControllerSwitched(_loc10_);
            }
         }
         else
         {
            if(!this._editable)
            {
               return;
            }
            _loc10_ = this._object.getController(_loc11_.name);
            ControllerEditDialog(this._editorWindow.getDialog(ControllerEditDialog)).open(_loc10_);
         }
      }
      
      private function __listSizeChanged() : void
      {
         GTimers.inst.callLater(this.__resizeList);
      }
      
      private function __resizeList() : void
      {
         if(this._editorWindow.mainPanel.editPanel.activeDocument && !this._editorWindow.mainPanel.editPanel.timelinePanel.self.visible)
         {
            this._list.resizeToFit(2147483647,25);
         }
      }
   }
}
