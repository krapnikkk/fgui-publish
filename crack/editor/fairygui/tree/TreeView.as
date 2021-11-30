package fairygui.tree
{
   import fairygui.GButton;
   import fairygui.GList;
   import fairygui.GObject;
   import fairygui.event.ItemEvent;
   import flash.events.Event;
   
   public class TreeView
   {
       
      
      private var _list:GList;
      
      private var _root:TreeNode;
      
      private var _listener:ITreeListener;
      
      private var _indent:int;
      
      public function TreeView(param1:GList)
      {
         super();
         _list = param1;
         _list.removeChildrenToPool();
         _list.addEventListener("itemClick",__clickItem);
         _root = new TreeNode(true);
         _root.setTree(this);
         _root.setCell(_list);
         _root.expanded = true;
         _indent = 15;
      }
      
      public final function get list() : GList
      {
         return _list;
      }
      
      public final function get root() : TreeNode
      {
         return _root;
      }
      
      public final function get indent() : int
      {
         return _indent;
      }
      
      public final function set indent(param1:int) : void
      {
         _indent = param1;
      }
      
      public final function get listener() : ITreeListener
      {
         return _listener;
      }
      
      public final function set listener(param1:ITreeListener) : void
      {
         _listener = param1;
      }
      
      public function getSelectedNode() : TreeNode
      {
         if(_list.selectedIndex != -1)
         {
            return TreeNode(_list.getChildAt(_list.selectedIndex).data);
         }
         return null;
      }
      
      public function getSelection() : Vector.<TreeNode>
      {
         var _loc5_:int = 0;
         var _loc2_:* = null;
         var _loc4_:Vector.<int> = _list.getSelection();
         var _loc3_:int = _loc4_.length;
         var _loc1_:Vector.<TreeNode> = new Vector.<TreeNode>();
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            _loc2_ = TreeNode(_list.getChildAt(_loc4_[_loc5_]).data);
            _loc1_.push(_loc2_);
            _loc5_++;
         }
         return _loc1_;
      }
      
      public function addSelection(param1:TreeNode, param2:Boolean = false) : void
      {
         var _loc3_:TreeNode = param1.parent;
         while(_loc3_ != null && _loc3_ != _root)
         {
            _loc3_.expanded = true;
            _loc3_ = _loc3_.parent;
         }
         if(!param1.cell)
         {
            return;
         }
         _list.addSelection(_list.getChildIndex(param1.cell),param2);
      }
      
      public function removeSelection(param1:TreeNode) : void
      {
         if(!param1.cell)
         {
            return;
         }
         _list.removeSelection(_list.getChildIndex(param1.cell));
      }
      
      public function clearSelection() : void
      {
         _list.clearSelection();
      }
      
      public function getNodeIndex(param1:TreeNode) : int
      {
         return _list.getChildIndex(param1.cell);
      }
      
      public function updateNode(param1:TreeNode) : void
      {
         if(param1.cell == null)
         {
            return;
         }
         _listener.treeNodeRender(param1,param1.cell);
      }
      
      public function updateNodes(param1:Vector.<TreeNode>) : void
      {
         var _loc4_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = param1.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1[_loc4_];
            if(_loc2_.cell == null)
            {
               return;
            }
            _listener.treeNodeRender(_loc2_,_loc2_.cell);
            _loc4_++;
         }
      }
      
      public function expandAll(param1:TreeNode) : void
      {
         var _loc4_:int = 0;
         var _loc2_:* = null;
         param1.expanded = true;
         var _loc3_:int = param1.numChildren;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1.getChildAt(_loc4_);
            if(_loc2_.isFolder)
            {
               expandAll(_loc2_);
            }
            _loc4_++;
         }
      }
      
      public function collapseAll(param1:TreeNode) : void
      {
         var _loc4_:int = 0;
         var _loc2_:* = null;
         if(param1 != _root)
         {
            param1.expanded = false;
         }
         var _loc3_:int = param1.numChildren;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1.getChildAt(_loc4_);
            if(_loc2_.isFolder)
            {
               collapseAll(_loc2_);
            }
            _loc4_++;
         }
      }
      
      private function createCell(param1:TreeNode) : void
      {
         param1.setCell(_listener.treeNodeCreateCell(param1));
         param1.cell.data = param1;
         var _loc2_:GObject = param1.cell.getChild("indent");
         if(_loc2_ != null)
         {
            _loc2_.width = (param1.level - 1) * _indent;
         }
         var _loc3_:GButton = GButton(param1.cell.getChild("expandButton"));
         if(_loc3_)
         {
            if(param1.isFolder)
            {
               _loc3_.visible = true;
               _loc3_.addClickListener(__clickExpandButton);
               _loc3_.data = param1;
               _loc3_.selected = param1.expanded;
            }
            else
            {
               _loc3_.visible = false;
            }
         }
         _listener.treeNodeRender(param1,param1.cell);
      }
      
      function afterInserted(param1:TreeNode) : void
      {
         createCell(param1);
         var _loc2_:int = getInsertIndexForNode(param1);
         _list.addChildAt(param1.cell,_loc2_);
         _listener.treeNodeRender(param1,param1.cell);
         if(param1.isFolder && param1.expanded)
         {
            checkChildren(param1,_loc2_);
         }
      }
      
      private function getInsertIndexForNode(param1:TreeNode) : int
      {
         var _loc5_:* = 0;
         var _loc3_:* = null;
         var _loc7_:TreeNode = param1.getPrevSibling();
         if(_loc7_ == null)
         {
            _loc7_ = param1.parent;
         }
         var _loc6_:int = _list.getChildIndex(_loc7_.cell) + 1;
         var _loc4_:int = param1.level;
         var _loc2_:int = _list.numChildren;
         _loc5_ = _loc6_;
         while(_loc5_ < _loc2_)
         {
            _loc3_ = TreeNode(_list.getChildAt(_loc5_).data);
            if(_loc3_.level > _loc4_)
            {
               _loc6_++;
               _loc5_++;
               continue;
            }
            break;
         }
         return _loc6_;
      }
      
      function afterRemoved(param1:TreeNode) : void
      {
         removeNode(param1);
      }
      
      function afterExpanded(param1:TreeNode) : void
      {
         var _loc2_:* = null;
         if(param1 != _root)
         {
            _listener.treeNodeWillExpand(param1,true);
         }
         if(param1.cell == null)
         {
            return;
         }
         if(param1 != _root)
         {
            _listener.treeNodeRender(param1,param1.cell);
            _loc2_ = GButton(param1.cell.getChild("expandButton"));
            if(_loc2_)
            {
               _loc2_.selected = true;
            }
         }
         if(param1.cell.parent != null)
         {
            checkChildren(param1,_list.getChildIndex(param1.cell));
         }
      }
      
      function afterCollapsed(param1:TreeNode) : void
      {
         var _loc2_:* = null;
         if(param1 != _root)
         {
            _listener.treeNodeWillExpand(param1,false);
         }
         if(param1.cell == null)
         {
            return;
         }
         if(param1 != _root)
         {
            _listener.treeNodeRender(param1,param1.cell);
            _loc2_ = GButton(param1.cell.getChild("expandButton"));
            if(_loc2_)
            {
               _loc2_.selected = false;
            }
         }
         if(param1.cell.parent != null)
         {
            hideFolderNode(param1);
         }
      }
      
      function afterMoved(param1:TreeNode) : void
      {
         if(!param1.isFolder)
         {
            _list.removeChild(param1.cell);
         }
         else
         {
            hideFolderNode(param1);
         }
         var _loc2_:int = getInsertIndexForNode(param1);
         _list.addChildAt(param1.cell,_loc2_);
         if(param1.isFolder && param1.expanded)
         {
            checkChildren(param1,_loc2_);
         }
      }
      
      private function checkChildren(param1:TreeNode, param2:int) : int
      {
         var _loc5_:int = 0;
         var _loc3_:* = null;
         var _loc4_:int = param1.numChildren;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            param2++;
            _loc3_ = param1.getChildAt(_loc5_);
            if(_loc3_.cell == null)
            {
               createCell(_loc3_);
            }
            if(!_loc3_.cell.parent)
            {
               _list.addChildAt(_loc3_.cell,param2);
            }
            if(_loc3_.isFolder && _loc3_.expanded)
            {
               param2 = checkChildren(_loc3_,param2);
            }
            _loc5_++;
         }
         return param2;
      }
      
      private function hideFolderNode(param1:TreeNode) : void
      {
         var _loc4_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = param1.numChildren;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1.getChildAt(_loc4_);
            if(_loc2_.cell && _loc2_.cell.parent != null)
            {
               _list.removeChild(_loc2_.cell);
            }
            if(_loc2_.isFolder && _loc2_.expanded)
            {
               hideFolderNode(_loc2_);
            }
            _loc4_++;
         }
      }
      
      private function removeNode(param1:TreeNode) : void
      {
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         var _loc3_:* = null;
         if(param1.cell != null)
         {
            if(param1.cell.parent != null)
            {
               _list.removeChild(param1.cell);
            }
            _list.returnToPool(param1.cell);
            param1.cell.data = null;
            param1.setCell(null);
         }
         if(param1.isFolder)
         {
            _loc2_ = param1.numChildren;
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc3_ = param1.getChildAt(_loc4_);
               removeNode(_loc3_);
               _loc4_++;
            }
         }
      }
      
      private function __clickExpandButton(param1:Event) : void
      {
         var _loc3_:Number = NaN;
         param1.stopPropagation();
         var _loc4_:GButton = GButton(param1.currentTarget);
         var _loc2_:TreeNode = TreeNode(_loc4_.parent.data);
         if(_list.scrollPane != null)
         {
            _loc3_ = _list.scrollPane.posY;
            if(_loc4_.selected)
            {
               _loc2_.expanded = true;
            }
            else
            {
               _loc2_.expanded = false;
            }
            _list.scrollPane.posY = _loc3_;
            _list.scrollPane.scrollToView(_loc2_.cell);
         }
         else if(_loc4_.selected)
         {
            _loc2_.expanded = true;
         }
         else
         {
            _loc2_.expanded = false;
         }
      }
      
      private function __clickItem(param1:ItemEvent) : void
      {
         var _loc3_:Number = NaN;
         if(_list.scrollPane != null)
         {
            _loc3_ = _list.scrollPane.posY;
         }
         var _loc2_:TreeNode = TreeNode(param1.itemObject.data);
         _listener.treeNodeClick(_loc2_,param1);
         if(_list.scrollPane != null)
         {
            _list.scrollPane.posY = _loc3_;
            if(_loc2_.cell)
            {
               _list.scrollPane.scrollToView(_loc2_.cell);
            }
         }
      }
   }
}
