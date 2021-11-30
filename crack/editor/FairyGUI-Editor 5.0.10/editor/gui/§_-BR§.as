package fairygui.editor.gui
{
   import fairygui.event.GTouchEvent;
   import fairygui.event.StateChangeEvent;
   import flash.events.Event;
   
   public class §_-BR§ extends FTreeNode
   {
      
      private static var helperIntList:Vector.<int> = new Vector.<int>();
       
      
      public var treeNodeRender:Function;
      
      public var treeNodeWillExpand:Function;
      
      private var _list:FList;
      
      private var _indent:int;
      
      var _expandedStatusInEvt:Boolean;
      
      public function §_-BR§(param1:FList)
      {
         super(true);
         this._list = param1;
         this._indent = 15;
         setTree(this);
         expanded = true;
      }
      
      public final function get indent() : int
      {
         return this._indent;
      }
      
      public final function set indent(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:FComponent = null;
         var _loc5_:FTreeNode = null;
         var _loc6_:FObject = null;
         if(this._indent != param1)
         {
            this._indent = param1;
            _loc2_ = this._list.numChildren;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = this._list.getChildAt(_loc3_) as FComponent;
               if(_loc4_)
               {
                  _loc5_ = _loc4_._treeNode;
                  if(_loc5_)
                  {
                     _loc6_ = _loc4_.getChild("indent");
                     if(_loc6_)
                     {
                        _loc6_.width = (_loc5_.level - 1) * this._indent;
                     }
                  }
               }
               _loc3_++;
            }
         }
      }
      
      public function getSelectedNode() : FTreeNode
      {
         if(this._list.selectedIndex != -1)
         {
            return this._list.getChildAt(this._list.selectedIndex)._treeNode;
         }
         return null;
      }
      
      public function getSelectedNodes(param1:Vector.<FTreeNode> = null) : Vector.<FTreeNode>
      {
         var _loc5_:FTreeNode = null;
         if(param1 == null)
         {
            param1 = new Vector.<FTreeNode>();
         }
         helperIntList.length = 0;
         this._list.getSelection(helperIntList);
         var _loc2_:int = helperIntList.length;
         var _loc3_:Vector.<FTreeNode> = new Vector.<FTreeNode>();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = this._list.getChildAt(helperIntList[_loc4_])._treeNode;
            _loc3_.push(_loc5_);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function selectNode(param1:FTreeNode, param2:Boolean = false) : void
      {
         var _loc3_:FTreeNode = param1.parent;
         while(_loc3_ != null && _loc3_ != this)
         {
            _loc3_.expanded = true;
            _loc3_ = _loc3_.parent;
         }
         if(!param1._cell)
         {
            return;
         }
         this._list.addSelection(this._list.getChildIndex(param1._cell),param2);
      }
      
      public function unselectNode(param1:FTreeNode) : void
      {
         if(!param1._cell)
         {
            return;
         }
         this._list.removeSelection(this._list.getChildIndex(param1._cell));
      }
      
      public function §_-LW§(param1:FTreeNode) : int
      {
         return this._list.getChildIndex(param1._cell);
      }
      
      public function §_-1n§(param1:FTreeNode) : void
      {
         if(param1._cell == null)
         {
            return;
         }
         if(this.treeNodeRender != null)
         {
            this.treeNodeRender(param1,param1._cell);
         }
      }
      
      public function §_-Ll§(param1:Vector.<FTreeNode>) : void
      {
         var _loc4_:FTreeNode = null;
         var _loc2_:int = param1.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1[_loc3_];
            if(_loc4_._cell == null)
            {
               return;
            }
            if(this.treeNodeRender != null)
            {
               this.treeNodeRender(_loc4_,_loc4_._cell);
            }
            _loc3_++;
         }
      }
      
      public function expandAll(param1:FTreeNode = null) : void
      {
         var _loc4_:FTreeNode = null;
         if(param1 == null)
         {
            param1 = this;
         }
         param1.expanded = true;
         var _loc2_:int = param1.numChildren;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.getChildAt(_loc3_);
            if(_loc4_.isFolder)
            {
               this.expandAll(_loc4_);
            }
            _loc3_++;
         }
      }
      
      public function collapseAll(param1:FTreeNode = null) : void
      {
         var _loc4_:FTreeNode = null;
         if(param1 == null)
         {
            param1 = this;
         }
         if(param1 != this)
         {
            param1.expanded = false;
         }
         var _loc2_:int = param1.numChildren;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.getChildAt(_loc3_);
            if(_loc4_.isFolder)
            {
               this.collapseAll(_loc4_);
            }
            _loc3_++;
         }
      }
      
      public function createCell(param1:FTreeNode) : void
      {
         var _loc3_:FObject = null;
         var _loc2_:String = param1._resURL;
         if(!_loc2_)
         {
            _loc2_ = this._list.defaultItem;
         }
         if(!_loc2_)
         {
            return;
         }
         var _loc4_:FPackageItem = this._list._pkg.project.getItemByURL(_loc2_);
         if(_loc4_ == null)
         {
            _loc3_ = FObjectFactory.createObject2(this._list._pkg,"component",MissingInfo.create2(this._list._pkg,_loc2_),this._list._flags & 255);
         }
         else
         {
            _loc3_ = FObjectFactory.createObject(_loc4_,this._list._flags & 255);
            if(!_loc3_ is FComponent)
            {
               _loc3_.dispose();
               _loc3_ = FObjectFactory.createObject2(this._list._pkg,"component",null,this._list._flags & 255);
            }
         }
         var _loc5_:FComponent = _loc3_ as FComponent;
         _loc3_._treeNode = param1;
         param1._cell = _loc5_;
         var _loc6_:FObject = _loc5_.getChild("indent");
         if(_loc6_ != null)
         {
            _loc6_.width = (param1.level - 1) * this._indent;
         }
         var _loc7_:FController = _loc5_.getController("expanded");
         if(_loc7_)
         {
            _loc7_.addEventListener(StateChangeEvent.CHANGED,this.__expandedStateChanged);
            _loc7_.selectedIndex = !!param1.expanded?1:0;
         }
         _loc5_.addEventListener(GTouchEvent.BEGIN,this.__cellMouseDown);
         _loc7_ = _loc5_.getController("leaf");
         if(_loc7_)
         {
            _loc7_.selectedIndex = !!param1.isFolder?0:1;
         }
         if(this.treeNodeRender != null)
         {
            this.treeNodeRender(param1,_loc5_);
         }
      }
      
      function afterInserted(param1:FTreeNode) : void
      {
         if(!param1._cell)
         {
            this.createCell(param1);
         }
         var _loc2_:int = this.getInsertIndexForNode(param1);
         this._list.addChildAt(param1._cell,_loc2_);
         if(this.treeNodeRender != null)
         {
            this.treeNodeRender(param1,param1._cell);
         }
         if(param1.isFolder && param1.expanded)
         {
            this.checkChildren(param1,_loc2_);
         }
      }
      
      private function getInsertIndexForNode(param1:FTreeNode) : int
      {
         var _loc7_:FTreeNode = null;
         var _loc2_:FTreeNode = param1.getPrevSibling();
         if(_loc2_ == null)
         {
            _loc2_ = param1.parent;
         }
         var _loc3_:int = this._list.getChildIndex(_loc2_._cell) + 1;
         var _loc4_:int = param1.level;
         var _loc5_:int = this._list.numChildren;
         var _loc6_:int = _loc3_;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = this._list.getChildAt(_loc6_)._treeNode;
            if(_loc7_.level <= _loc4_)
            {
               break;
            }
            _loc3_++;
            _loc6_++;
         }
         return _loc3_;
      }
      
      function afterRemoved(param1:FTreeNode) : void
      {
         this.removeNode(param1);
      }
      
      function afterExpanded(param1:FTreeNode) : void
      {
         if(param1 == this)
         {
            this.checkChildren(this,0);
            return;
         }
         if(this.treeNodeWillExpand != null)
         {
            this.treeNodeWillExpand(param1,true);
         }
         if(param1._cell == null)
         {
            return;
         }
         if(this.treeNodeRender != null)
         {
            this.treeNodeRender(param1,param1._cell);
         }
         var _loc2_:FController = param1._cell.getController("expanded");
         if(_loc2_)
         {
            _loc2_.selectedIndex = 1;
         }
         if(param1._cell.parent != null)
         {
            this.checkChildren(param1,this._list.getChildIndex(param1._cell));
         }
      }
      
      function afterCollapsed(param1:FTreeNode) : void
      {
         if(param1 == this)
         {
            this.checkChildren(this,0);
            return;
         }
         if(this.treeNodeWillExpand != null)
         {
            this.treeNodeWillExpand(param1,false);
         }
         if(param1._cell == null)
         {
            return;
         }
         if(this.treeNodeRender != null)
         {
            this.treeNodeRender(param1,param1._cell);
         }
         var _loc2_:FController = param1._cell.getController("expanded");
         if(_loc2_)
         {
            _loc2_.selectedIndex = 0;
         }
         if(param1._cell.parent != null)
         {
            this.hideFolderNode(param1);
         }
      }
      
      function afterMoved(param1:FTreeNode) : void
      {
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc7_:FObject = null;
         var _loc2_:int = this._list.getChildIndex(param1._cell);
         if(param1.isFolder)
         {
            _loc3_ = this.getFolderEndIndex(_loc2_,param1.level);
         }
         else
         {
            _loc3_ = _loc2_ + 1;
         }
         var _loc4_:int = this.getInsertIndexForNode(param1);
         var _loc6_:int = _loc3_ - _loc2_;
         if(_loc4_ < _loc2_)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc7_ = this._list.getChildAt(_loc2_ + _loc5_);
               this._list.setChildIndex(_loc7_,_loc4_ + _loc5_);
               _loc5_++;
            }
         }
         else
         {
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc7_ = this._list.getChildAt(_loc2_);
               this._list.setChildIndex(_loc7_,_loc4_);
               _loc5_++;
            }
         }
      }
      
      private function getFolderEndIndex(param1:int, param2:int) : int
      {
         var _loc5_:FTreeNode = null;
         var _loc3_:int = this._list.numChildren;
         var _loc4_:int = param1 + 1;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._list.getChildAt(_loc4_)._treeNode;
            if(_loc5_.level <= param2)
            {
               return _loc4_;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function checkChildren(param1:FTreeNode, param2:int) : int
      {
         var _loc5_:FTreeNode = null;
         var _loc3_:int = param1.numChildren;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            param2++;
            _loc5_ = param1.getChildAt(_loc4_);
            if(_loc5_._cell == null)
            {
               this.createCell(_loc5_);
            }
            if(!_loc5_._cell.parent)
            {
               this._list.addChildAt(_loc5_._cell,param2);
            }
            if(_loc5_.isFolder && _loc5_.expanded)
            {
               param2 = this.checkChildren(_loc5_,param2);
            }
            _loc4_++;
         }
         return param2;
      }
      
      private function hideFolderNode(param1:FTreeNode) : void
      {
         var _loc4_:FTreeNode = null;
         var _loc2_:int = param1.numChildren;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.getChildAt(_loc3_);
            if(_loc4_._cell && _loc4_._cell.parent != null)
            {
               this._list.removeChild(_loc4_._cell);
            }
            if(_loc4_.isFolder && _loc4_.expanded)
            {
               this.hideFolderNode(_loc4_);
            }
            _loc3_++;
         }
      }
      
      private function removeNode(param1:FTreeNode) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:FTreeNode = null;
         if(param1._cell != null)
         {
            if(param1._cell.parent != null)
            {
               this._list.removeChild(param1._cell);
            }
            param1._cell.dispose();
            param1._cell._treeNode = null;
            param1._cell = null;
         }
         if(param1.isFolder)
         {
            _loc2_ = param1.numChildren;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = param1.getChildAt(_loc3_);
               this.removeNode(_loc4_);
               _loc3_++;
            }
         }
      }
      
      private function __cellMouseDown(param1:Event) : void
      {
         var _loc2_:FTreeNode = param1.currentTarget._treeNode;
         this._expandedStatusInEvt = _loc2_.expanded;
      }
      
      private function __expandedStateChanged(param1:Event) : void
      {
         var _loc2_:FController = FController(param1.currentTarget);
         var _loc3_:FTreeNode = _loc2_.parent._treeNode;
         _loc3_.expanded = _loc2_.selectedIndex == 1;
      }
   }
}
