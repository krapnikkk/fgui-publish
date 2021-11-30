package fairygui
{
   public class GTreeNode
   {
       
      
      private var _data:Object;
      
      private var _parent:GTreeNode;
      
      private var _children:Vector.<GTreeNode>;
      
      private var _expanded:Boolean;
      
      private var _level:int;
      
      private var _tree:GTree;
      
      var _cell:GComponent;
      
      var _resURL:String;
      
      public function GTreeNode(param1:Boolean, param2:String = null)
      {
         super();
         _resURL = param2;
         if(param1)
         {
            _children = new Vector.<GTreeNode>();
         }
      }
      
      public final function set expanded(param1:Boolean) : void
      {
         if(_children == null)
         {
            return;
         }
         if(_expanded != param1)
         {
            _expanded = param1;
            if(_tree != null)
            {
               if(_expanded)
               {
                  _tree.afterExpanded(this);
               }
               else
               {
                  _tree.afterCollapsed(this);
               }
            }
         }
      }
      
      public final function get expanded() : Boolean
      {
         return _expanded;
      }
      
      public final function get isFolder() : Boolean
      {
         return _children != null;
      }
      
      public final function get parent() : GTreeNode
      {
         return _parent;
      }
      
      public final function set data(param1:Object) : void
      {
         _data = param1;
      }
      
      public final function get data() : Object
      {
         return _data;
      }
      
      public final function get text() : String
      {
         if(_cell != null)
         {
            return _cell.text;
         }
         return null;
      }
      
      public final function set text(param1:String) : void
      {
         if(_cell != null)
         {
            _cell.text = param1;
         }
      }
      
      public final function get icon() : String
      {
         if(_cell != null)
         {
            return _cell.icon;
         }
         return null;
      }
      
      public final function set icon(param1:String) : void
      {
         if(_cell != null)
         {
            _cell.icon = param1;
         }
      }
      
      public final function get cell() : GComponent
      {
         return _cell;
      }
      
      public final function get level() : int
      {
         return _level;
      }
      
      function setLevel(param1:int) : void
      {
         _level = param1;
      }
      
      public function addChild(param1:GTreeNode) : GTreeNode
      {
         addChildAt(param1,_children.length);
         return param1;
      }
      
      public function addChildAt(param1:GTreeNode, param2:int) : GTreeNode
      {
         var _loc4_:int = 0;
         if(!param1)
         {
            throw new Error("child is null");
         }
         var _loc3_:int = _children.length;
         if(param2 >= 0 && param2 <= _loc3_)
         {
            if(param1._parent == this)
            {
               setChildIndex(param1,param2);
            }
            else
            {
               if(param1._parent)
               {
                  param1._parent.removeChild(param1);
               }
               _loc4_ = _children.length;
               if(param2 == _loc4_)
               {
                  _children.push(param1);
               }
               else
               {
                  _children.splice(param2,0,param1);
               }
               param1._parent = this;
               param1._level = this._level + 1;
               param1.setTree(_tree);
               if(_tree != null && this == _tree.rootNode || this._cell != null && this._cell.parent != null && _expanded)
               {
                  _tree.afterInserted(param1);
               }
            }
            return param1;
         }
         throw new RangeError("Invalid child index");
      }
      
      public function removeChild(param1:GTreeNode) : GTreeNode
      {
         var _loc2_:int = _children.indexOf(param1);
         if(_loc2_ != -1)
         {
            removeChildAt(_loc2_);
         }
         return param1;
      }
      
      public function removeChildAt(param1:int) : GTreeNode
      {
         var _loc2_:* = null;
         if(param1 >= 0 && param1 < numChildren)
         {
            _loc2_ = _children[param1];
            _children.splice(param1,1);
            _loc2_._parent = null;
            if(_tree != null)
            {
               _loc2_.setTree(null);
               _tree.afterRemoved(_loc2_);
            }
            return _loc2_;
         }
         throw new RangeError("Invalid child index");
      }
      
      public function removeChildren(param1:int = 0, param2:int = -1) : void
      {
         var _loc3_:* = 0;
         if(param2 < 0 || param2 >= numChildren)
         {
            param2 = numChildren - 1;
         }
         _loc3_ = param1;
         while(_loc3_ <= param2)
         {
            removeChildAt(param1);
            _loc3_++;
         }
      }
      
      public function getChildAt(param1:int) : GTreeNode
      {
         if(param1 >= 0 && param1 < numChildren)
         {
            return _children[param1];
         }
         throw new RangeError("Invalid child index");
      }
      
      public function getChildIndex(param1:GTreeNode) : int
      {
         return _children.indexOf(param1);
      }
      
      public function getPrevSibling() : GTreeNode
      {
         if(_parent == null)
         {
            return null;
         }
         var _loc1_:int = _parent._children.indexOf(this);
         if(_loc1_ <= 0)
         {
            return null;
         }
         return _parent._children[_loc1_ - 1];
      }
      
      public function getNextSibling() : GTreeNode
      {
         if(_parent == null)
         {
            return null;
         }
         var _loc1_:int = _parent._children.indexOf(this);
         if(_loc1_ < 0 || _loc1_ >= _parent._children.length - 1)
         {
            return null;
         }
         return _parent._children[_loc1_ + 1];
      }
      
      public function setChildIndex(param1:GTreeNode, param2:int) : void
      {
         var _loc4_:int = _children.indexOf(param1);
         if(_loc4_ == -1)
         {
            throw new ArgumentError("Not a child of this container");
         }
         var _loc3_:int = _children.length;
         if(param2 < 0)
         {
            param2 = 0;
         }
         else if(param2 > _loc3_)
         {
            param2 = _loc3_;
         }
         if(_loc4_ == param2)
         {
            return;
         }
         _children.splice(_loc4_,1);
         _children.splice(param2,0,param1);
         if(_tree != null && this == _tree.rootNode || this._cell != null && this._cell.parent != null && _expanded)
         {
            _tree.afterMoved(param1);
         }
      }
      
      public function swapChildren(param1:GTreeNode, param2:GTreeNode) : void
      {
         var _loc3_:int = _children.indexOf(param1);
         var _loc4_:int = _children.indexOf(param2);
         if(_loc3_ == -1 || _loc4_ == -1)
         {
            throw new ArgumentError("Not a child of this container");
         }
         swapChildrenAt(_loc3_,_loc4_);
      }
      
      public function swapChildrenAt(param1:int, param2:int) : void
      {
         var _loc4_:GTreeNode = _children[param1];
         var _loc3_:GTreeNode = _children[param2];
         setChildIndex(_loc4_,param2);
         setChildIndex(_loc3_,param1);
      }
      
      public final function get numChildren() : int
      {
         return _children.length;
      }
      
      public function expandToRoot() : void
      {
         var _loc1_:* = this;
         while(_loc1_)
         {
            _loc1_.expanded = true;
            _loc1_ = _loc1_.parent;
         }
      }
      
      public final function get tree() : GTree
      {
         return _tree;
      }
      
      function setTree(param1:GTree) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:* = null;
         _tree = param1;
         if(_tree != null && _tree.treeNodeWillExpand != null && _expanded)
         {
            _tree.treeNodeWillExpand(this,true);
         }
         if(_children != null)
         {
            _loc3_ = _children.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc2_ = _children[_loc4_];
               _loc2_._level = _level + 1;
               _loc2_.setTree(param1);
               _loc4_++;
            }
         }
      }
   }
}
