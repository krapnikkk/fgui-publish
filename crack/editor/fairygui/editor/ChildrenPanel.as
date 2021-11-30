package fairygui.editor
{
   import fairygui.GButton;
   import fairygui.GComponent;
   import fairygui.GObject;
   import fairygui.GTextField;
   import fairygui.UIPackage;
   import fairygui.editor.extui.DropEvent;
   import fairygui.editor.extui.Icons;
   import fairygui.editor.gui.EGComponent;
   import fairygui.editor.gui.EGGroup;
   import fairygui.editor.gui.EGObject;
   import fairygui.event.DragEvent;
   import fairygui.event.ItemEvent;
   import fairygui.tree.ITreeListener;
   import fairygui.tree.TreeNode;
   import fairygui.tree.TreeView;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   
   public class ChildrenPanel implements ITreeListener
   {
       
      
      public var self:GComponent;
      
      private var _editorWindow:EditorWindow;
      
      private var _treeView:TreeView;
      
      private var _treeItemUrl:String;
      
      private var _titleBar:GButton;
      
      private var _savedHeight:int;
      
      private var _findInput:GTextField;
      
      private var _updating:Boolean;
      
      private var _settingSelection:Boolean;
      
      public function ChildrenPanel(param1:EditorWindow, param2:GComponent)
      {
         super();
         this.self = param2;
         this._editorWindow = param1;
         this._treeView = new TreeView(this.self.getChild("list").asList);
         this._treeView.listener = this;
         this._treeItemUrl = UIPackage.getItemURL("Builder","ChildrenPanel_item");
         var _loc3_:GComponent = this.self.getChild("n22").asCom;
         _loc3_.getChild("status").addClickListener(this.__clickEyeAll);
         _loc3_.getChild("lock").addClickListener(this.__clickLockAll);
         _loc3_.getChild("expand").asButton.addEventListener("stateChanged",this.__clickCollpaseAll);
         this._findInput = _loc3_.getChild("findInput").asTextField;
         this._findInput.addEventListener("keyDown",this.__keyDown);
         _loc3_.getChild("btnFind").addClickListener(this.__clickFind);
         this.self.addEventListener("__drop",this.__drop);
         this._titleBar = this.self.getChild("titleBar").asButton;
         this._titleBar.addEventListener("stateChanged",this.__expandStateChanged);
      }
      
      public function update(param1:EGObject) : void
      {
         var _loc9_:ComDocument = null;
         var _loc7_:EGComponent = null;
         var _loc8_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc6_:TreeNode = null;
         var _loc5_:Array = null;
         var _loc4_:GObject = null;
         this._updating = true;
         if(param1 == null)
         {
            this._treeView.root.removeChildren();
            _loc9_ = this._editorWindow.activeComDocument;
            if(_loc9_ == null)
            {
               return;
            }
            _loc7_ = _loc9_.editingContent;
            _loc8_ = {"toplevel":[this._treeView.root]};
            _loc2_ = _loc7_.numChildren;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               param1 = _loc7_.getChildAt(_loc3_);
               if(param1 is EGGroup)
               {
                  _loc6_ = new TreeNode(true);
                  _loc6_.expanded = !EGGroup(param1).displayCollapsed;
                  _loc6_.data = param1;
                  _loc8_[param1.id] = [_loc6_];
               }
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               param1 = _loc7_.getChildAt(_loc3_);
               if(param1.groupInst == null)
               {
                  _loc8_.toplevel.push(param1);
               }
               else
               {
                  _loc5_ = _loc8_[param1.groupId];
                  if(_loc5_)
                  {
                     _loc5_.push(param1);
                  }
                  else
                  {
                     _loc8_.toplevel.push(param1);
                  }
               }
               _loc3_++;
            }
            this.addGroupChildren(_loc8_,"toplevel");
         }
         else
         {
            _loc2_ = this._treeView.list.numChildren;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = this._treeView.list.getChildAt(_loc3_);
               if(_loc4_.name == param1.id)
               {
                  this._treeView.updateNode(TreeNode(_loc4_.data));
                  break;
               }
               _loc3_++;
            }
         }
         this._updating = false;
      }
      
      public function syncSelection() : void
      {
         var _loc1_:GObject = null;
         var _loc2_:TreeNode = null;
         var _loc3_:EGObject = null;
         if(this._settingSelection)
         {
            return;
         }
         this._settingSelection = true;
         var _loc7_:ComDocument = this._editorWindow.activeComDocument;
         if(_loc7_ == null)
         {
            return;
         }
         var _loc6_:Vector.<EGObject> = _loc7_.getSelections();
         this._treeView.clearSelection();
         var _loc4_:int = this._treeView.list.numChildren;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc1_ = this._treeView.list.getChildAt(_loc5_);
            _loc2_ = TreeNode(_loc1_.data);
            _loc3_ = EGObject(_loc2_.data);
            if(_loc6_.indexOf(_loc3_) != -1)
            {
               this._treeView.addSelection(_loc2_,true);
            }
            else
            {
               this._treeView.removeSelection(_loc2_);
            }
            _loc5_++;
         }
         this._settingSelection = false;
      }
      
      private function addGroupChildren(param1:Object, param2:String) : void
      {
         var _loc6_:EGObject = null;
         var _loc5_:TreeNode = null;
         var _loc7_:Array = param1[param2];
         var _loc8_:int = _loc7_.length;
         var _loc3_:TreeNode = _loc7_[0];
         var _loc4_:int = 1;
         while(_loc4_ < _loc8_)
         {
            _loc6_ = _loc7_[_loc4_];
            if(!(_loc6_ is EGGroup))
            {
               _loc5_ = new TreeNode(false);
               _loc5_.data = _loc6_;
               _loc3_.addChild(_loc5_);
            }
            else
            {
               _loc3_.addChild(param1[_loc6_.id][0]);
               this.addGroupChildren(param1,_loc6_.id);
            }
            _loc4_++;
         }
      }
      
      private function findNode(param1:TreeNode, param2:EGObject) : TreeNode
      {
         var _loc3_:TreeNode = null;
         var _loc4_:TreeNode = null;
         var _loc5_:int = param1.numChildren;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc3_ = param1.getChildAt(_loc6_);
            if(_loc3_.data == param2)
            {
               return _loc3_;
            }
            if(_loc3_.isFolder)
            {
               _loc4_ = this.findNode(_loc3_,param2);
               if(_loc4_)
               {
                  return _loc4_;
               }
            }
            _loc6_++;
         }
         return null;
      }
      
      public function treeNodeCreateCell(param1:TreeNode) : GComponent
      {
         var _loc4_:GButton = this._treeView.list.getFromPool(this._treeItemUrl).asButton;
         _loc4_.draggable = true;
         _loc4_.addEventListener("startDrag",this.__dragNodeStart);
         var _loc2_:GButton = _loc4_.getChild("status").asButton;
         _loc2_.changeStateOnClick = false;
         _loc2_.addEventListener("beginGTouch",this.__statusMouseDown);
         var _loc3_:GButton = _loc4_.getChild("lock").asButton;
         _loc3_.changeStateOnClick = false;
         _loc3_.addEventListener("beginGTouch",this.__lockMouseDown);
         return _loc4_;
      }
      
      public function treeNodeRender(param1:TreeNode, param2:GComponent) : void
      {
         var _loc4_:GButton = param2.asButton;
         _loc4_.name = param1.data.id;
         _loc4_.title = param1.data.toString();
         _loc4_.icon = Icons.all[param1.data.objectType];
         _loc4_.data = param1;
         var _loc5_:GButton = _loc4_.getChild("status").asButton;
         _loc5_.selected = param1.data.hideByEditor;
         var _loc3_:GButton = _loc4_.getChild("lock").asButton;
         _loc3_.selected = param1.data.locked;
      }
      
      public function treeNodeWillExpand(param1:TreeNode, param2:Boolean) : void
      {
         var _loc4_:ComDocument = null;
         if(this._updating)
         {
            return;
         }
         var _loc3_:EGGroup = param1.data as EGGroup;
         if(_loc3_ != null)
         {
            _loc3_.displayCollapsed = !_loc3_.displayCollapsed;
            _loc4_ = this._editorWindow.activeComDocument;
            if(_loc4_ != null)
            {
               _loc4_.setModified();
            }
         }
      }
      
      public function treeNodeClick(param1:TreeNode, param2:ItemEvent) : void
      {
         var _loc3_:Vector.<TreeNode> = null;
         var _loc4_:EGObject = null;
         var _loc5_:ComDocument = this._editorWindow.activeComDocument;
         if(_loc5_ == null)
         {
            return;
         }
         var _loc6_:EGObject = EGObject(param1.data);
         if(_loc6_ != null && _loc6_.parent != null)
         {
            this._settingSelection = true;
            _loc3_ = this._treeView.getSelection();
            if(_loc3_.length == 1 || !(this._editorWindow.groot.shiftKeyDown || this._editorWindow.groot.ctrlKeyDown) && !param2.rightButton)
            {
               _loc5_.openAndSetSelection(_loc6_);
            }
            else
            {
               if(this._editorWindow.groot.ctrlKeyDown)
               {
                  _loc5_.removeSelection(_loc6_);
               }
               var _loc8_:int = 0;
               var _loc7_:* = _loc3_;
               for each(param1 in _loc3_)
               {
                  _loc4_ = EGObject(param1.data);
                  if(_loc4_.groupInst == _loc5_.openedGroup)
                  {
                     if(!_loc5_.inSelection(_loc4_))
                     {
                        _loc5_.addSelection(_loc4_);
                     }
                  }
                  else
                  {
                     this._treeView.list.removeSelection(this._treeView.getNodeIndex(param1));
                  }
               }
            }
            this._settingSelection = false;
            if(param2)
            {
               if(param2.rightButton)
               {
                  _loc5_.showContextMenu();
               }
               else if(param2.clickCount == 2)
               {
                  _loc5_.openChild(_loc6_);
               }
            }
         }
      }
      
      private function __dragNodeStart(param1:DragEvent) : void
      {
         var _loc2_:TreeNode = null;
         var _loc3_:EGObject = null;
         param1.preventDefault();
         var _loc6_:ComDocument = this._editorWindow.activeComDocument;
         if(_loc6_ == null)
         {
            return;
         }
         if(_loc6_.isSelectingObject)
         {
            return;
         }
         var _loc4_:GButton = GButton(param1.currentTarget);
         if(!_loc4_.selected)
         {
            this._treeView.clearSelection();
            _loc2_ = TreeNode(_loc4_.data);
            _loc3_ = EGObject(_loc2_.data);
            this._treeView.addSelection(_loc2_);
            _loc6_.openAndSetSelection(_loc3_);
         }
         else
         {
            _loc2_ = this._treeView.getSelectedNode();
            _loc3_ = EGObject(_loc2_.data);
            if(!_loc6_.inSelection(_loc3_))
            {
               this._settingSelection = true;
               if(_loc3_.groupInst != _loc6_.openedGroup)
               {
                  _loc6_.openAndSetSelection(_loc3_);
               }
               else
               {
                  _loc6_.addSelection(_loc3_);
               }
               this._settingSelection = false;
               this.syncSelection();
            }
         }
         var _loc5_:Vector.<TreeNode> = this._treeView.getSelection();
         this._editorWindow.dragManager.startDrag(this,_loc5_);
      }
      
      private function __added(param1:Event) : void
      {
         this.update(null);
      }
      
      private function __statusMouseDown(param1:Event) : void
      {
         param1.stopPropagation();
         var _loc6_:GButton = GButton(param1.currentTarget.parent);
         var _loc4_:GButton = _loc6_.getChild("status").asButton;
         _loc4_.selected = !_loc4_.selected;
         var _loc5_:ComDocument = this._editorWindow.activeComDocument;
         if(_loc5_ == null)
         {
            return;
         }
         var _loc2_:EGComponent = _loc5_.editingContent;
         var _loc3_:EGObject = _loc2_.getChildById(_loc6_.name);
         if(_loc3_ != null)
         {
            _loc3_.hideByEditor = _loc4_.selected;
            _loc5_.setModified();
         }
         _loc2_.updateDisplayList();
      }
      
      private function __lockMouseDown(param1:Event) : void
      {
         param1.stopPropagation();
         var _loc6_:GButton = GButton(param1.currentTarget.parent);
         var _loc4_:GButton = _loc6_.getChild("lock").asButton;
         _loc4_.selected = !_loc4_.selected;
         var _loc5_:ComDocument = this._editorWindow.activeComDocument;
         if(_loc5_ == null)
         {
            return;
         }
         var _loc2_:EGComponent = _loc5_.editingContent;
         var _loc3_:EGObject = _loc2_.getChildById(_loc6_.name);
         if(_loc3_ != null)
         {
            _loc3_.locked = _loc4_.selected;
            _loc5_.setModified();
         }
      }
      
      private function __clickEyeAll(param1:Event) : void
      {
         var _loc6_:EGObject = null;
         var _loc5_:GButton = null;
         var _loc4_:GButton = null;
         var _loc9_:ComDocument = this._editorWindow.activeComDocument;
         if(_loc9_ == null)
         {
            return;
         }
         var _loc7_:EGComponent = _loc9_.editingContent;
         var _loc8_:Boolean = false;
         var _loc2_:int = _loc7_.numChildren;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc6_ = _loc7_.getChildAt(_loc3_);
            if(_loc6_.hideByEditor)
            {
               _loc6_.hideByEditor = false;
               _loc8_ = true;
            }
            _loc3_++;
         }
         if(_loc8_)
         {
            _loc2_ = this._treeView.list.numChildren;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc5_ = this._treeView.list.getChildAt(_loc3_).asButton;
               _loc4_ = _loc5_.getChild("status").asButton;
               _loc4_.selected = false;
               _loc3_++;
            }
            _loc9_.setModified();
            _loc7_.updateDisplayList();
         }
      }
      
      private function __clickLockAll(param1:Event) : void
      {
         var _loc6_:EGObject = null;
         var _loc5_:GButton = null;
         var _loc4_:GButton = null;
         var _loc9_:ComDocument = this._editorWindow.activeComDocument;
         if(_loc9_ == null)
         {
            return;
         }
         var _loc7_:EGComponent = _loc9_.editingContent;
         var _loc8_:Boolean = false;
         var _loc2_:int = _loc7_.numChildren;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc6_ = _loc7_.getChildAt(_loc3_);
            if(_loc6_.locked)
            {
               _loc6_.locked = false;
               _loc8_ = true;
            }
            _loc3_++;
         }
         if(_loc8_)
         {
            _loc2_ = this._treeView.list.numChildren;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc5_ = this._treeView.list.getChildAt(_loc3_).asButton;
               _loc4_ = _loc5_.getChild("lock").asButton;
               _loc4_.selected = false;
               _loc3_++;
            }
            _loc9_.setModified();
         }
      }
      
      private function __clickCollpaseAll(param1:Event) : void
      {
         var _loc4_:EGObject = null;
         var _loc8_:ComDocument = this._editorWindow.activeComDocument;
         if(_loc8_ == null)
         {
            return;
         }
         var _loc6_:EGComponent = _loc8_.editingContent;
         var _loc7_:Boolean = false;
         var _loc2_:Boolean = param1.currentTarget.selected;
         var _loc3_:int = _loc6_.numChildren;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = _loc6_.getChildAt(_loc5_);
            if(_loc4_ is EGGroup)
            {
               if(EGGroup(_loc4_).displayCollapsed != _loc2_)
               {
                  EGGroup(_loc4_).displayCollapsed = _loc2_;
                  _loc7_ = true;
               }
            }
            _loc5_++;
         }
         if(_loc7_)
         {
            this._updating = true;
            if(_loc2_)
            {
               this._treeView.collapseAll(this._treeView.root);
            }
            else
            {
               this._treeView.expandAll(this._treeView.root);
            }
            this._updating = false;
            _loc8_.setModified();
         }
      }
      
      private function __drop(param1:DropEvent) : void
      {
         var _loc2_:EGObject = null;
         if(!(param1.source is ChildrenPanel))
         {
            return;
         }
         var _loc5_:ComDocument = this._editorWindow.activeComDocument;
         if(_loc5_ == null)
         {
            return;
         }
         if(_loc5_.editingTransition != null)
         {
            return;
         }
         var _loc3_:EGComponent = _loc5_.editingContent;
         var _loc4_:GObject = this._treeView.list.getItemNear(this.self.displayObject.stage.mouseX,this.self.displayObject.stage.mouseY);
         if(_loc4_ == null)
         {
            _loc2_ = _loc3_.getChildAt(_loc3_.numChildren - 1);
         }
         else
         {
            _loc2_ = _loc3_.getChildById(_loc4_.name);
         }
         if(_loc2_ != null)
         {
            _loc5_.moveCrossGroups(_loc2_);
         }
      }
      
      private function __expandStateChanged(param1:Event) : void
      {
         if(this._titleBar.selected)
         {
            this._savedHeight = this.self.height;
            this.self.height = this._titleBar.height;
            this.self.y = this.self.y + this._savedHeight - this._titleBar.height;
            this._editorWindow.mainPanel.libPanelResizerV.visible = false;
         }
         else
         {
            this.self.height = this._savedHeight;
            this.self.y = this.self.y - (this.self.height - this._titleBar.height);
            this._editorWindow.mainPanel.libPanelResizerV.visible = true;
         }
      }
      
      public function getCorrectResizerPos() : int
      {
         if(this._titleBar.selected)
         {
            return this._editorWindow.mainPanel.libPanelResizerV.y - (this._savedHeight - this._titleBar.height);
         }
         return this._editorWindow.mainPanel.libPanelResizerV.y;
      }
      
      private function __clickFind(param1:Event) : void
      {
         var _loc5_:EGObject = null;
         var _loc4_:TreeNode = null;
         var _loc8_:String = this._findInput.text.toLowerCase();
         if(_loc8_.length == 0)
         {
            this._editorWindow.stage.focus = this._findInput.displayObject as TextField;
            return;
         }
         var _loc6_:ComDocument = this._editorWindow.activeComDocument;
         if(_loc6_ == null)
         {
            return;
         }
         var _loc7_:EGComponent = _loc6_.editingContent;
         var _loc2_:int = _loc7_.numChildren;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc5_ = _loc7_.getChildAt(_loc3_);
            if(_loc5_.name.toLowerCase().indexOf(_loc8_) != -1)
            {
               _loc4_ = this.findNode(this._treeView.root,_loc5_);
               if(_loc4_)
               {
                  this._treeView.addSelection(_loc4_,true);
               }
               _loc6_.openAndSetSelection(_loc5_);
               return;
            }
            _loc3_++;
         }
      }
      
      private function __keyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            this.__clickFind(null);
         }
      }
   }
}
