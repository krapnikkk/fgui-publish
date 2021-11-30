package fairygui.editor.gui
{
   public class FTreeNode
   {
       
      
      private var _data:Object;
      
      private var _parent:FTreeNode;
      
      private var _children:Vector.<FTreeNode>;
      
      private var _expanded:Boolean;
      
      private var _level:int;
      
      private var _tree:§_-BR§;
      
      var _cell:FComponent;
      
      var _resURL:String;
      
      public function FTreeNode(param1:Boolean, param2:String = null)
      {
         super();
         this._resURL = param2;
         if(param1)
         {
            this._children = new Vector.<FTreeNode>();
         }
      }
      
      public final function set expanded(param1:Boolean) : void
      {
         if(this._children == null)
         {
            return;
         }
         if(this._expanded != param1)
         {
            this._expanded = param1;
            if(this._tree != null)
            {
               if(this._expanded)
               {
                  this._tree.afterExpanded(this);
               }
               else
               {
                  this._tree.afterCollapsed(this);
               }
            }
         }
      }
      
      public final function get expanded() : Boolean
      {
         return this._expanded;
      }
      
      public final function get isFolder() : Boolean
      {
         return this._children != null;
      }
      
      public final function get parent() : FTreeNode
      {
         return this._parent;
      }
      
      public final function set data(param1:Object) : void
      {
         this._data = param1;
      }
      
      public final function get data() : Object
      {
         return this._data;
      }
      
      public final function get text() : String
      {
         if(this._cell != null)
         {
            return this._cell.text;
         }
         return null;
      }
      
      public final function get cell() : FComponent
      {
         return this._cell;
      }
      
      public final function get level() : int
      {
         return this._level;
      }
      
      function setLevel(param1:int) : void
      {
         this._level = param1;
      }
      
      public function addChild(param1:FTreeNode) : FTreeNode
      {
         this.addChildAt(param1,this._children.length);
         return param1;
      }
      
      public function addChildAt(param1:FTreeNode, param2:int) : FTreeNode
      {
         var _loc4_:int = 0;
         if(!param1)
         {
            throw new Error("child is null");
         }
         var _loc3_:int = this._children.length;
         if(param2 >= 0 && param2 <= _loc3_)
         {
            if(param1._parent == this)
            {
               this.setChildIndex(param1,param2);
            }
            else
            {
               if(param1._parent)
               {
                  param1._parent.removeChild(param1);
               }
               _loc4_ = this._children.length;
               if(param2 == _loc4_)
               {
                  this._children.push(param1);
               }
               else
               {
                  this._children.splice(param2,0,param1);
               }
               param1._parent = this;
               param1._level = this._level + 1;
               param1.setTree(this._tree);
               if(this == this._tree || this._cell != null && this._cell.parent != null && this._expanded)
               {
                  this._tree.afterInserted(param1);
               }
            }
            return param1;
         }
         throw new RangeError("Invalid child index");
      }
      
      public function removeChild(param1:FTreeNode) : FTreeNode
      {
         var _loc2_:int = this._children.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.removeChildAt(_loc2_);
         }
         return param1;
      }
      
      public function removeChildAt(param1:int) : FTreeNode
      {
         var _loc2_:FTreeNode = null;
         if(param1 >= 0 && param1 < this.numChildren)
         {
            _loc2_ = this._children[param1];
            this._children.splice(param1,1);
            _loc2_._parent = null;
            if(this._tree != null)
            {
               _loc2_.setTree(null);
               this._tree.afterRemoved(_loc2_);
            }
            return _loc2_;
         }
         throw new RangeError("Invalid child index");
      }
      
      public function removeChildren(param1:int = 0, param2:int = -1) : void
      {
         if(param2 < 0 || param2 >= this.numChildren)
         {
            param2 = this.numChildren - 1;
         }
         var _loc3_:int = param1;
         while(_loc3_ <= param2)
         {
            this.removeChildAt(param1);
            _loc3_++;
         }
      }
      
      public function getChildAt(param1:int) : FTreeNode
      {
         if(param1 >= 0 && param1 < this.numChildren)
         {
            return this._children[param1];
         }
         throw new RangeError("Invalid child index");
      }
      
      public function getChildIndex(param1:FTreeNode) : int
      {
         return this._children.indexOf(param1);
      }
      
      public function getPrevSibling() : FTreeNode
      {
         if(this._parent == null)
         {
            return null;
         }
         var _loc1_:int = this._parent._children.indexOf(this);
         if(_loc1_ <= 0)
         {
            return null;
         }
         return this._parent._children[_loc1_ - 1];
      }
      
      public function getNextSibling() : FTreeNode
      {
         if(this._parent == null)
         {
            return null;
         }
         var _loc1_:int = this._parent._children.indexOf(this);
         if(_loc1_ < 0 || _loc1_ >= this._parent._children.length - 1)
         {
            return null;
         }
         return this._parent._children[_loc1_ + 1];
      }
      
      public function setChildIndex(param1:FTreeNode, param2:int) : void
      {
         var _loc3_:int = this._children.indexOf(param1);
         if(_loc3_ == -1)
         {
            throw new ArgumentError("Not a child of this container");
         }
         var _loc4_:int = this._children.length;
         if(param2 < 0)
         {
            param2 = 0;
         }
         else if(param2 > _loc4_)
         {
            param2 = _loc4_;
         }
         if(_loc3_ == param2)
         {
            return;
         }
         this._children.splice(_loc3_,1);
         this._children.splice(param2,0,param1);
         if(this._cell != null && this._cell.parent != null && this._expanded)
         {
            this._tree.afterMoved(param1);
         }
      }
      
      public function swapChildren(param1:FTreeNode, param2:FTreeNode) : void
      {
         var _loc3_:int = this._children.indexOf(param1);
         var _loc4_:int = this._children.indexOf(param2);
         if(_loc3_ == -1 || _loc4_ == -1)
         {
            throw new ArgumentError("Not a child of this container");
         }
         this.swapChildrenAt(_loc3_,_loc4_);
      }
      
      public function swapChildrenAt(param1:int, param2:int) : void
      {
         var _loc3_:FTreeNode = this._children[param1];
         var _loc4_:FTreeNode = this._children[param2];
         this.setChildIndex(_loc3_,param2);
         this.setChildIndex(_loc4_,param1);
      }
      
      public final function get numChildren() : int
      {
         return this._children.length;
      }
      
      public function expandToRoot() : void
      {
         var _loc1_:FTreeNode = this;
         while(_loc1_)
         {
            _loc1_.expanded = true;
            _loc1_ = _loc1_.parent;
         }
      }
      
      public final function get tree() : §_-BR§
      {
         return this._tree;
      }
      
      function setTree(param1:§_-BR§) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:FTreeNode = null;
         this._tree = param1;
         if(this._tree != null && this._tree.treeNodeWillExpand != null && this._expanded)
         {
            this._tree.treeNodeWillExpand(this,true);
         }
         if(this._children != null)
         {
            _loc2_ = this._children.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = this._children[_loc3_];
               _loc4_._level = this._level + 1;
               _loc4_.setTree(param1);
               _loc3_++;
            }
         }
      }
   }
}
