package fairygui
{
   import fairygui.event.ItemEvent;
   import flash.events.Event;
   
   public class GTree extends GList
   {
      
      private static var helperIntList:Vector.<int> = new Vector.<int>();
       
      
      public var treeNodeRender:Function;
      
      public var treeNodeWillExpand:Function;
      
      private var _indent:int;
      
      private var _clickToExpand:int;
      
      private var _rootNode:GTreeNode;
      
      private var _expandedStatusInEvt:Boolean;
      
      public function GTree()
      {
         super();
         _indent = 15;
         _rootNode = new GTreeNode(true);
         _rootNode.setTree(this);
         _rootNode.expanded = true;
      }
      
      public function get rootNode() : GTreeNode
      {
         return _rootNode;
      }
      
      public final function get indent() : int
      {
         return _indent;
      }
      
      public final function set indent(param1:int) : void
      {
         _indent = param1;
      }
      
      public final function get clickToExpand() : int
      {
         return _clickToExpand;
      }
      
      public final function set clickToExpand(param1:int) : void
      {
         _clickToExpand = param1;
      }
      
      public function getSelectedNode() : GTreeNode
      {
         if(this.selectedIndex != -1)
         {
            return this.getChildAt(this.selectedIndex)._treeNode;
         }
         return null;
      }
      
      public function getSelectedNodes(param1:Vector.<GTreeNode> = null) : Vector.<GTreeNode>
      {
         var _loc5_:int = 0;
         var _loc3_:* = null;
         if(param1 == null)
         {
            param1 = new Vector.<GTreeNode>();
         }
         helperIntList.length = 0;
         super.getSelection(helperIntList);
         var _loc4_:int = helperIntList.length;
         var _loc2_:Vector.<GTreeNode> = new Vector.<GTreeNode>();
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = this.getChildAt(helperIntList[_loc5_])._treeNode;
            _loc2_.push(_loc3_);
            _loc5_++;
         }
         return _loc2_;
      }
      
      public function selectNode(param1:GTreeNode, param2:Boolean = false) : void
      {
         var _loc3_:GTreeNode = param1.parent;
         while(_loc3_ != null && _loc3_ != _rootNode)
         {
            _loc3_.expanded = true;
            _loc3_ = _loc3_.parent;
         }
         if(!param1._cell)
         {
            return;
         }
         this.addSelection(this.getChildIndex(param1._cell),param2);
      }
      
      public function unselectNode(param1:GTreeNode) : void
      {
         if(!param1._cell)
         {
            return;
         }
         this.removeSelection(this.getChildIndex(param1._cell));
      }
      
      public function expandAll(param1:GTreeNode = null) : void
      {
         var _loc4_:int = 0;
         var _loc2_:* = null;
         if(param1 == null)
         {
            param1 = _rootNode;
         }
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
      
      public function collapseAll(param1:GTreeNode = null) : void
      {
         var _loc4_:int = 0;
         var _loc2_:* = null;
         if(param1 == null)
         {
            param1 = _rootNode;
         }
         if(param1 != _rootNode)
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
      
      private function createCell(param1:GTreeNode) : void
      {
         var _loc2_:* = null;
         var _loc4_:GComponent = getFromPool(param1._resURL) as GComponent;
         if(!_loc4_)
         {
            throw new Error("cannot create tree node object.");
         }
         _loc4_._treeNode = param1;
         param1._cell = _loc4_;
         var _loc3_:GObject = _loc4_.getChild("indent");
         if(_loc3_ != null)
         {
            _loc3_.width = (param1.level - 1) * _indent;
         }
         _loc2_ = _loc4_.getController("expanded");
         if(_loc2_)
         {
            _loc2_.addEventListener("stateChanged",__expandedStateChanged);
            _loc2_.selectedIndex = !!param1.expanded?1:0;
         }
         if(param1.isFolder)
         {
            _loc4_.addEventListener("beginGTouch",__cellMouseDown);
         }
         _loc2_ = _loc4_.getController("leaf");
         if(_loc2_)
         {
            _loc2_.selectedIndex = !!param1.isFolder?0:1;
         }
         if(treeNodeRender != null)
         {
            treeNodeRender(param1,_loc4_);
         }
      }
      
      function afterInserted(param1:GTreeNode) : void
      {
         if(!param1._cell)
         {
            createCell(param1);
         }
         var _loc2_:int = getInsertIndexForNode(param1);
         this.addChildAt(param1._cell,_loc2_);
         if(treeNodeRender != null)
         {
            treeNodeRender(param1,param1._cell);
         }
         if(param1.isFolder && param1.expanded)
         {
            checkChildren(param1,_loc2_);
         }
      }
      
      private function getInsertIndexForNode(param1:GTreeNode) : int
      {
         var _loc7_:* = 0;
         var _loc3_:* = null;
         var _loc2_:GTreeNode = param1.getPrevSibling();
         if(_loc2_ == null)
         {
            _loc2_ = param1.parent;
         }
         var _loc4_:int = this.getChildIndex(_loc2_._cell) + 1;
         var _loc5_:int = param1.level;
         var _loc6_:int = this.numChildren;
         _loc7_ = _loc4_;
         while(_loc7_ < _loc6_)
         {
            _loc3_ = this.getChildAt(_loc7_)._treeNode;
            if(_loc3_.level > _loc5_)
            {
               _loc4_++;
               _loc7_++;
               continue;
            }
            break;
         }
         return _loc4_;
      }
      
      function afterRemoved(param1:GTreeNode) : void
      {
         removeNode(param1);
      }
      
      function afterExpanded(param1:GTreeNode) : void
      {
         if(param1 == _rootNode)
         {
            checkChildren(_rootNode,0);
            return;
         }
         if(treeNodeWillExpand != null)
         {
            treeNodeWillExpand(param1,true);
         }
         if(param1._cell == null)
         {
            return;
         }
         if(treeNodeRender != null)
         {
            treeNodeRender(param1,param1._cell);
         }
         var _loc2_:Controller = param1._cell.getController("expanded");
         if(_loc2_)
         {
            _loc2_.selectedIndex = 1;
         }
         if(param1._cell.parent != null)
         {
            checkChildren(param1,this.getChildIndex(param1._cell));
         }
      }
      
      function afterCollapsed(param1:GTreeNode) : void
      {
         if(param1 == _rootNode)
         {
            checkChildren(_rootNode,0);
            return;
         }
         if(treeNodeWillExpand != null)
         {
            treeNodeWillExpand(param1,false);
         }
         if(param1._cell == null)
         {
            return;
         }
         if(treeNodeRender != null)
         {
            treeNodeRender(param1,param1._cell);
         }
         var _loc2_:Controller = param1._cell.getController("expanded");
         if(_loc2_)
         {
            _loc2_.selectedIndex = 0;
         }
         if(param1._cell.parent != null)
         {
            hideFolderNode(param1);
         }
      }
      
      function afterMoved(param1:GTreeNode) : void
      {
         var _loc3_:int = 0;
         var _loc7_:int = 0;
         var _loc4_:* = null;
         var _loc2_:int = this.getChildIndex(param1._cell);
         if(param1.isFolder)
         {
            _loc3_ = getFolderEndIndex(_loc2_,param1.level);
         }
         else
         {
            _loc3_ = _loc2_ + 1;
         }
         var _loc5_:int = getInsertIndexForNode(param1);
         var _loc6_:int = _loc3_ - _loc2_;
         if(_loc5_ < _loc2_)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc4_ = this.getChildAt(_loc2_ + _loc7_);
               this.setChildIndex(_loc4_,_loc5_ + _loc7_);
               _loc7_++;
            }
         }
         else
         {
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc4_ = this.getChildAt(_loc2_);
               this.setChildIndex(_loc4_,_loc5_);
               _loc7_++;
            }
         }
      }
      
      private function getFolderEndIndex(param1:int, param2:int) : int
      {
         var _loc5_:int = 0;
         var _loc3_:* = null;
         var _loc4_:int = this.numChildren;
         _loc5_ = param1 + 1;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = this.getChildAt(_loc5_)._treeNode;
            if(_loc3_.level <= param2)
            {
               return _loc5_;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      private function checkChildren(param1:GTreeNode, param2:int) : int
      {
         var _loc5_:int = 0;
         var _loc3_:* = null;
         var _loc4_:int = param1.numChildren;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            param2++;
            _loc3_ = param1.getChildAt(_loc5_);
            if(_loc3_._cell == null)
            {
               createCell(_loc3_);
            }
            if(!_loc3_._cell.parent)
            {
               this.addChildAt(_loc3_._cell,param2);
            }
            if(_loc3_.isFolder && _loc3_.expanded)
            {
               param2 = checkChildren(_loc3_,param2);
            }
            _loc5_++;
         }
         return param2;
      }
      
      private function hideFolderNode(param1:GTreeNode) : void
      {
         var _loc4_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = param1.numChildren;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1.getChildAt(_loc4_);
            if(_loc2_._cell && _loc2_._cell.parent != null)
            {
               this.removeChild(_loc2_._cell);
            }
            if(_loc2_.isFolder && _loc2_.expanded)
            {
               hideFolderNode(_loc2_);
            }
            _loc4_++;
         }
      }
      
      private function removeNode(param1:GTreeNode) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:* = null;
         if(param1._cell != null)
         {
            if(param1._cell.parent != null)
            {
               this.removeChild(param1._cell);
            }
            this.returnToPool(param1._cell);
            param1._cell._treeNode = null;
            param1._cell = null;
         }
         if(param1.isFolder)
         {
            _loc3_ = param1.numChildren;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc2_ = param1.getChildAt(_loc4_);
               removeNode(_loc2_);
               _loc4_++;
            }
         }
      }
      
      private function __cellMouseDown(param1:Event) : void
      {
         var _loc2_:GTreeNode = param1.currentTarget._treeNode;
         _expandedStatusInEvt = _loc2_.expanded;
      }
      
      private function __expandedStateChanged(param1:Event) : void
      {
         var _loc2_:Controller = Controller(param1.currentTarget);
         var _loc3_:GTreeNode = _loc2_.parent._treeNode;
         _loc3_.expanded = _loc2_.selectedIndex == 1;
      }
      
      override protected function dispatchItemEvent(param1:ItemEvent) : void
      {
         var _loc2_:* = null;
         if(_clickToExpand != 0 && !param1.rightButton)
         {
            _loc2_ = param1.itemObject._treeNode;
            if(_loc2_ && _expandedStatusInEvt == _loc2_.expanded)
            {
               if(_clickToExpand == 2)
               {
                  if(param1.clickCount == 2)
                  {
                     _loc2_.expanded = !_loc2_.expanded;
                  }
               }
               else
               {
                  _loc2_.expanded = !_loc2_.expanded;
               }
            }
         }
         super.dispatchItemEvent(param1);
      }
      
      override protected function readItems(param1:XML) : void
      {
         var _loc12_:* = null;
         var _loc3_:* = 0;
         var _loc6_:int = 0;
         var _loc11_:* = 0;
         var _loc5_:int = 0;
         var _loc13_:* = null;
         var _loc8_:* = null;
         var _loc10_:* = null;
         var _loc7_:* = 0;
         var _loc9_:String = param1.@indent;
         if(_loc9_)
         {
            _indent = parseInt(_loc9_);
         }
         _loc9_ = param1.@clickToExpand;
         if(_loc9_)
         {
            _clickToExpand = parseInt(_loc9_);
         }
         var _loc2_:XMLList = param1.item;
         var _loc4_:int = _loc2_.length();
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc13_ = _loc2_[_loc5_];
            _loc8_ = _loc13_.@url;
            if(_loc5_ == 0)
            {
               _loc3_ = int(parseInt(_loc13_.@level));
            }
            else
            {
               _loc3_ = _loc6_;
            }
            if(_loc5_ < _loc4_ - 1)
            {
               _loc6_ = parseInt(_loc2_[_loc5_ + 1].@level);
            }
            else
            {
               _loc6_ = 0;
            }
            _loc10_ = new GTreeNode(_loc6_ > _loc3_,_loc8_);
            _loc10_.expanded = true;
            if(_loc5_ == 0)
            {
               _rootNode.addChild(_loc10_);
            }
            else if(_loc3_ > _loc11_)
            {
               _loc12_.addChild(_loc10_);
            }
            else if(_loc3_ < _loc11_)
            {
               _loc7_ = _loc3_;
               while(_loc7_ <= _loc11_)
               {
                  _loc12_ = _loc12_.parent;
                  _loc7_++;
               }
               _loc12_.addChild(_loc10_);
            }
            else
            {
               _loc12_.parent.addChild(_loc10_);
            }
            _loc12_ = _loc10_;
            _loc11_ = _loc3_;
            setupItem(_loc13_,_loc10_.cell);
            _loc5_++;
         }
      }
   }
}
