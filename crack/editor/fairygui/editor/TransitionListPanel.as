package fairygui.editor
{
   import fairygui.GButton;
   import fairygui.GComponent;
   import fairygui.GList;
   import fairygui.GObject;
   import fairygui.editor.gui.EGComponent;
   import fairygui.editor.gui.ETransition;
   import fairygui.event.ItemEvent;
   import fairygui.utils.GTimers;
   import flash.events.Event;
   
   public class TransitionListPanel
   {
       
      
      public var self:GComponent;
      
      private var _list:GList;
      
      private var _object:EGComponent;
      
      private var _editable:Boolean;
      
      private var _addButton:GObject;
      
      private var _editorWindow:EditorWindow;
      
      public function TransitionListPanel(param1:EditorWindow, param2:GComponent, param3:Boolean)
      {
         super();
         this.self = param2;
         this._editorWindow = param1;
         this._editable = param3;
         this._addButton = this.self.getChild("n5");
         this._addButton.addClickListener(this.__clickCreate);
         this._addButton.visible = param3;
         this.self.getChild("exit").addClickListener(this.__clickExit);
         this._list = this.self.getChild("n1").asList;
         this._list.addSizeChangeCallback(this.__listSizeChanged);
         this._list.addEventListener("itemClick",this.__clickItem);
         this._list.removeChildrenToPool();
         this._list.height = 0;
      }
      
      public function update(param1:EGComponent) : void
      {
         var _loc5_:ETransition = null;
         var _loc4_:GButton = null;
         this._object = param1;
         this.clear();
         if(this._object == null || this._object.transitions.isEmpty)
         {
            if(!this._editable)
            {
               this._list.height = 0;
            }
            return;
         }
         var _loc8_:ComDocument = this._editorWindow.activeComDocument;
         var _loc6_:Vector.<ETransition> = EGComponent(this._object).transitions.items;
         var _loc7_:int = _loc6_.length;
         var _loc2_:* = -1;
         var _loc3_:int = 0;
         while(_loc3_ < _loc7_)
         {
            _loc5_ = _loc6_[_loc3_];
            _loc4_ = this._list.addItemFromPool().asButton;
            _loc4_.title = _loc5_.name;
            _loc4_.data = _loc5_;
            if(_loc5_ == _loc8_.editingTransition)
            {
               _loc2_ = _loc3_;
            }
            _loc3_++;
         }
         this._list.selectedIndex = _loc2_;
         this._list.resizeToFit();
      }
      
      public function clear() : void
      {
         this._list.removeChildrenToPool();
         this.self.getChild("exit").visible = this._editable && this._editorWindow.mainPanel.editPanel.timelinePanel.self.visible;
         if(this._editorWindow.mainPanel.editPanel.activeDocument is ComDocument)
         {
            this._list.height = this._list.initHeight;
         }
         else
         {
            this._list.height = 0;
         }
      }
      
      private function __clickItem(param1:ItemEvent) : void
      {
         var _loc2_:ETransition = ETransition(param1.itemObject.data);
         if(this._editable)
         {
            this._editorWindow.activeComDocument.startEditingTransition(_loc2_);
         }
         else
         {
            this._editorWindow.mainPanel.testPanel.playTransition(_loc2_);
         }
         if(!this._editable)
         {
            GTimers.inst.add(100,1,this.resetSelection);
         }
      }
      
      private function resetSelection() : void
      {
         this._list.selectedIndex = -1;
      }
      
      private function __clickCreate(param1:Event) : void
      {
         var _loc5_:ComDocument = this._editorWindow.activeComDocument;
         var _loc3_:XML = EGComponent(this._object).transitions.toXML(false);
         var _loc4_:ETransition = EGComponent(this._object).transitions.addItem();
         var _loc2_:XML = EGComponent(this._object).transitions.toXML(false);
         _loc5_.actionHistory.action_transitionsChanged(this._object,_loc3_,_loc2_);
         _loc5_.setModified();
         _loc5_.startEditingTransition(_loc4_);
      }
      
      private function __clickExit(param1:Event) : void
      {
         this._editorWindow.activeComDocument.finishEditingTransition();
      }
      
      private function __listSizeChanged() : void
      {
         GTimers.inst.callLater(this.__resizeList);
      }
      
      private function __resizeList() : void
      {
         if(this._list.height > 0)
         {
            if(this._editorWindow.mainPanel.editPanel.activeDocument)
            {
               this._list.resizeToFit(2147483647,23);
            }
         }
      }
   }
}
