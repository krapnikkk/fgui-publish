package fairygui.editor
{
   import fairygui.GButton;
   import fairygui.GComponent;
   import fairygui.GLoader;
   import fairygui.PopupMenu;
   import fairygui.editor.extui.EditableTreeItem;
   import fairygui.editor.extui.Icons;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIPackage;
   import fairygui.event.DragEvent;
   import fairygui.event.ItemEvent;
   import fairygui.tree.ITreeListener;
   import fairygui.tree.TreeNode;
   import fairygui.tree.TreeView;
   import flash.events.KeyboardEvent;
   
   public class FavortiesPanel implements ITreeListener
   {
       
      
      private var _editorWindow:EditorWindow;
      
      private var _parentPanel:GComponent;
      
      private var _treeView:TreeView;
      
      private var _menu:PopupMenu;
      
      private var _inited:Boolean;
      
      private var _active:Boolean;
      
      public function FavortiesPanel(param1:EditorWindow, param2:GComponent)
      {
         super();
         this._editorWindow = param1;
         this._parentPanel = param2;
         this._treeView = new TreeView(this._parentPanel.getChild("favorites").asList);
         this._treeView.listener = this;
         this._treeView.list.selectionMode = 1;
         this.createMenu();
      }
      
      private function createMenu() : void
      {
         this._menu = new PopupMenu();
         this._menu.contentPane.width = 210;
         this._menu.addItem(Consts.g.text62,this.__menuShowInLib);
         this._menu.addItem(Consts.g.text335,this.__menuDelete);
      }
      
      public function onShown() : void
      {
         if(!this._inited)
         {
            this._inited = true;
            this.updatePackages();
         }
      }
      
      public function setActive(param1:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:EditableTreeItem = null;
         if(this._active != param1)
         {
            this._active = param1;
            _loc4_ = this._treeView.list.numChildren;
            _loc2_ = 0;
            while(_loc2_ < _loc4_)
            {
               _loc3_ = EditableTreeItem(this._treeView.list.getChildAt(_loc2_));
               _loc3_.setActive(this._active);
               _loc2_++;
            }
         }
      }
      
      public function collapseAll() : void
      {
         this._treeView.collapseAll(this._treeView.root);
      }
      
      public function updatePackages() : void
      {
         var _loc2_:EPackageItem = null;
         var _loc1_:TreeNode = null;
         if(!this._inited)
         {
            return;
         }
         this._treeView.root.removeChildren();
         var _loc3_:Vector.<EPackageItem> = this._editorWindow.project.getPackageRootItems(null,true);
         var _loc5_:int = 0;
         var _loc4_:* = _loc3_;
         for each(_loc2_ in _loc3_)
         {
            _loc1_ = new TreeNode(true);
            _loc1_.data = _loc2_;
            this._treeView.root.addChild(_loc1_);
            _loc2_.owner.refreshFavoriteFlags(_loc2_);
            this.addFolderContent(_loc1_);
         }
         this._treeView.expandAll(this._treeView.root);
      }
      
      public function updatePackage(param1:EUIPackage) : void
      {
         var _loc4_:TreeNode = null;
         var _loc2_:EPackageItem = null;
         if(!this._inited)
         {
            return;
         }
         var _loc5_:int = this._treeView.root.numChildren;
         var _loc3_:int = 0;
         while(_loc3_ < _loc5_)
         {
            _loc4_ = this._treeView.root.getChildAt(_loc3_);
            _loc2_ = EPackageItem(_loc4_.data);
            if(_loc2_.owner == param1)
            {
               if(_loc2_.favorite)
               {
                  param1.refreshFavoriteFlags(_loc2_);
                  _loc4_.removeChildren();
                  this.addFolderContent(_loc4_);
                  this._treeView.expandAll(_loc4_);
               }
               else
               {
                  this._treeView.root.removeChildAt(_loc3_);
               }
               return;
            }
            _loc3_++;
         }
         this.updatePackages();
      }
      
      public function updateItem(param1:EPackageItem) : void
      {
         var _loc2_:TreeNode = this.findNode(this._treeView.root,param1);
         if(_loc2_)
         {
            this._treeView.updateNode(_loc2_);
         }
      }
      
      public function getSelectedItem() : EPackageItem
      {
         var _loc1_:EPackageItem = null;
         var _loc2_:TreeNode = this._treeView.getSelectedNode();
         if(_loc2_ != null)
         {
            _loc1_ = EPackageItem(_loc2_.data);
            return _loc1_;
         }
         return null;
      }
      
      public function handleKeyDownEvent(param1:KeyboardEvent) : void
      {
         var _loc7_:TreeNode = null;
         var _loc8_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:EPackageItem = null;
         var _loc6_:* = null;
         var _loc5_:int = 0;
         var _loc4_:TreeNode = null;
         var _loc9_:String = String.fromCharCode(param1.charCode).toLowerCase();
         if(!param1.ctrlKey && !param1.altKey && param1.charCode >= 48 && param1.charCode <= 122)
         {
            _loc7_ = this._treeView.getSelectedNode();
            if(!_loc7_)
            {
               _loc7_ = this._treeView.root.getChildAt(0);
            }
            if(_loc7_)
            {
               _loc8_ = _loc7_.parent.getChildIndex(_loc7_);
               _loc2_ = _loc7_.parent.numChildren;
               if(_loc2_ == 0)
               {
                  return;
               }
               _loc5_ = _loc8_ + 1;
               while(_loc5_ < _loc2_)
               {
                  _loc4_ = _loc7_.parent.getChildAt(_loc5_);
                  _loc3_ = EPackageItem(_loc4_.data);
                  if(_loc3_.firstLetter == _loc9_)
                  {
                     _loc6_ = _loc4_;
                     break;
                  }
                  _loc5_++;
               }
               if(!_loc6_)
               {
                  _loc5_ = 0;
                  while(_loc5_ < _loc8_)
                  {
                     _loc4_ = _loc7_.parent.getChildAt(_loc5_);
                     _loc3_ = EPackageItem(_loc4_.data);
                     if(_loc3_.firstLetter == _loc9_)
                     {
                        _loc6_ = _loc4_;
                        break;
                     }
                     _loc5_++;
                  }
               }
               if(_loc6_)
               {
                  this._treeView.clearSelection();
                  this._treeView.addSelection(_loc6_,true);
                  this._editorWindow.mainPanel.previewPanel.refresh();
               }
            }
         }
      }
      
      public function handleKeyUpEvent(param1:KeyboardEvent) : void
      {
      }
      
      public function handleArrowKey(param1:int, param2:Boolean, param3:Boolean) : void
      {
         this._treeView.list.handleArrowKey(param1);
         this._editorWindow.mainPanel.previewPanel.refresh();
      }
      
      private function findNode(param1:TreeNode, param2:EPackageItem) : TreeNode
      {
         var _loc3_:TreeNode = null;
         var _loc4_:EPackageItem = null;
         var _loc5_:int = param1.numChildren;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc3_ = param1.getChildAt(_loc6_);
            _loc4_ = EPackageItem(_loc3_.data);
            if(_loc4_ == param2)
            {
               return _loc3_;
            }
            if(_loc3_.isFolder)
            {
               _loc3_ = this.findNode(_loc3_,param2);
               if(_loc3_)
               {
                  return _loc3_;
               }
            }
            _loc6_++;
         }
         return null;
      }
      
      private function addFolderContent(param1:TreeNode) : void
      {
         var _loc4_:EPackageItem = null;
         var _loc2_:TreeNode = null;
         var _loc5_:EPackageItem = EPackageItem(param1.data);
         var _loc3_:Vector.<EPackageItem> = _loc5_.owner.getFavoriteItems(_loc5_);
         var _loc7_:int = 0;
         var _loc6_:* = _loc3_;
         for each(_loc4_ in _loc3_)
         {
            _loc2_ = new TreeNode(_loc4_.type == "folder");
            _loc2_.data = _loc4_;
            param1.addChild(_loc2_);
            if(_loc2_.isFolder)
            {
               this.addFolderContent(_loc2_);
            }
         }
      }
      
      public function treeNodeCreateCell(param1:TreeNode) : GComponent
      {
         var _loc2_:EditableTreeItem = EditableTreeItem(this._treeView.list.getFromPool());
         _loc2_.draggable = true;
         _loc2_.toggleClickCount = 0;
         _loc2_.addEventListener("startDrag",this.__dragNodeStart);
         _loc2_.setActive(this._active);
         return _loc2_;
      }
      
      public function treeNodeRender(param1:TreeNode, param2:GComponent) : void
      {
         var _loc4_:GButton = param2.asButton;
         var _loc5_:EPackageItem = param1.data as EPackageItem;
         _loc4_.title = _loc5_.name;
         var _loc3_:GLoader = param2.getChild("sign") as GLoader;
         if(param1.isFolder)
         {
            if(_loc5_.id == "/")
            {
               _loc4_.icon = Icons.all["package"];
            }
            else
            {
               _loc4_.icon = Icons.all.folder;
            }
            _loc3_.url = null;
         }
         else
         {
            _loc4_.icon = Icons.all[_loc5_.type];
            if(_loc5_.exported)
            {
               _loc3_.url = "ui://Builder/bullet_red";
            }
            else
            {
               _loc3_.url = null;
            }
         }
      }
      
      public function treeNodeWillExpand(param1:TreeNode, param2:Boolean) : void
      {
      }
      
      public function treeNodeClick(param1:TreeNode, param2:ItemEvent) : void
      {
         var _loc3_:EPackageItem = param1.data as EPackageItem;
         var _loc4_:* = _loc3_.type == "folder";
         if(param2.rightButton)
         {
            if(_loc3_.id != "/")
            {
               this._menu.show(this._editorWindow.groot);
            }
         }
         else if(!_loc4_)
         {
            if(param2.clickCount == 2)
            {
               this._editorWindow.mainPanel.openItem(_loc3_);
            }
         }
         else if(param2.clickCount == 2)
         {
            param1.expanded = !param1.expanded;
         }
         this._editorWindow.mainPanel.previewPanel.refresh();
      }
      
      private function getSelectionForDragging() : Array
      {
         var _loc4_:TreeNode = null;
         var _loc3_:EPackageItem = null;
         var _loc9_:Vector.<TreeNode> = this._treeView.getSelection();
         var _loc8_:int = _loc9_.length;
         var _loc6_:Array = [];
         var _loc7_:int = _loc9_[0].level;
         var _loc1_:EUIPackage = _loc9_[0].data.owner;
         var _loc2_:int = 2147483647;
         var _loc5_:int = 0;
         while(_loc5_ < _loc8_)
         {
            _loc4_ = _loc9_[_loc5_];
            if(_loc4_.level <= _loc2_)
            {
               _loc2_ = _loc4_.level;
               if(!(_loc4_.level < _loc7_ || _loc4_.data.owner != _loc1_))
               {
                  _loc3_ = EPackageItem(_loc4_.data);
                  _loc6_.push(_loc3_);
               }
            }
            _loc5_++;
         }
         return _loc6_;
      }
      
      private function __dragNodeStart(param1:DragEvent) : void
      {
         param1.preventDefault();
         var _loc2_:GButton = GButton(param1.currentTarget);
         if(!_loc2_.selected)
         {
            this._treeView.clearSelection();
            this._treeView.addSelection(TreeNode(_loc2_.data));
         }
         this._editorWindow.dragManager.startDrag(this._editorWindow.mainPanel.libPanel,this.getSelectionForDragging());
      }
      
      private function __menuShowInLib(param1:ItemEvent) : void
      {
         var _loc2_:TreeNode = this._treeView.getSelectedNode();
         if(_loc2_)
         {
            this._editorWindow.mainPanel.libPanel.highlightItem(EPackageItem(_loc2_.data));
         }
      }
      
      private function __menuDelete(param1:ItemEvent) : void
      {
         var _loc6_:EUIPackage = null;
         var _loc3_:TreeNode = null;
         var _loc4_:EPackageItem = null;
         var _loc7_:Vector.<TreeNode> = this._treeView.getSelection();
         if(_loc7_.length == 0)
         {
            return;
         }
         var _loc5_:int = _loc7_.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc5_)
         {
            _loc3_ = _loc7_[_loc2_];
            _loc4_ = EPackageItem(_loc3_.data);
            if(!_loc6_)
            {
               _loc6_ = _loc4_.owner;
            }
            else if(_loc6_ != _loc4_.owner)
            {
               break;
            }
            if(_loc4_.type == "folder")
            {
               this.setChildrenFlag(_loc3_);
            }
            else
            {
               _loc4_.favorite = false;
            }
            _loc2_++;
         }
         _loc6_.save();
         this.updatePackage(_loc6_);
      }
      
      private function setChildrenFlag(param1:TreeNode) : void
      {
         var _loc4_:TreeNode = null;
         var _loc2_:EPackageItem = null;
         var _loc5_:int = param1.numChildren;
         var _loc3_:int = 0;
         while(_loc3_ < _loc5_)
         {
            _loc4_ = param1.getChildAt(_loc3_);
            _loc2_ = EPackageItem(_loc4_.data);
            if(_loc2_.type == "folder")
            {
               this.setChildrenFlag(_loc4_);
            }
            else
            {
               _loc2_.favorite = false;
            }
            _loc3_++;
         }
      }
   }
}
