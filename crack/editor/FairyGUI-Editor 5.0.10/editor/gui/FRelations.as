package fairygui.editor.gui
{
   import fairygui.utils.XData;
   import fairygui.utils.XDataEnumerator;
   
   public class FRelations
   {
       
      
      private var _owner:FObject;
      
      private var _items:Vector.<FRelationItem>;
      
      private var _widthLocked:Boolean;
      
      private var _heightLocked:Boolean;
      
      public var handling:FObject;
      
      public function FRelations(param1:FObject)
      {
         super();
         this._owner = param1;
         this._items = new Vector.<FRelationItem>();
      }
      
      public function get widthLocked() : Boolean
      {
         return this._widthLocked;
      }
      
      public function get heightLocked() : Boolean
      {
         return this._heightLocked;
      }
      
      public function addItem(param1:FObject, param2:int, param3:Boolean = false) : FRelationItem
      {
         var _loc4_:FRelationItem = this.getItem(param1);
         if(!_loc4_)
         {
            _loc4_ = new FRelationItem(this._owner);
            _loc4_.target = param1;
            if(param2 != -1)
            {
               _loc4_.addDef(param2,param3,false);
            }
            this._items.push(_loc4_);
            return _loc4_;
         }
         if(param2 != -1)
         {
            _loc4_.addDef(param2,param3);
         }
         return _loc4_;
      }
      
      public function addItem2(param1:FObject, param2:String) : FRelationItem
      {
         var _loc3_:FRelationItem = this.getItem(param1);
         if(!_loc3_)
         {
            _loc3_ = new FRelationItem(this._owner);
            _loc3_.target = param1;
            this._items.push(_loc3_);
         }
         _loc3_.addDefs(param2);
         return _loc3_;
      }
      
      public function removeItem(param1:FRelationItem) : void
      {
         var _loc2_:int = this._items.indexOf(param1);
         param1.dispose();
         this._items.splice(_loc2_,1);
      }
      
      public function replaceItem(param1:int, param2:FObject, param3:String) : void
      {
         var _loc4_:FRelationItem = this._items[param1];
         _loc4_.set(param2,param3,false);
      }
      
      public function get items() : Vector.<FRelationItem>
      {
         return this._items;
      }
      
      public function getItem(param1:FObject) : FRelationItem
      {
         var _loc2_:int = this._items.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._items[_loc3_].target == param1)
            {
               return this._items[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function hasTarget(param1:FObject) : Boolean
      {
         var _loc2_:int = this._items.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._items[_loc3_].target == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function removeTarget(param1:FObject) : void
      {
         var _loc3_:int = 0;
         var _loc4_:FRelationItem = null;
         var _loc2_:int = this._items.length;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._items[_loc3_];
            if(_loc4_.target == param1)
            {
               _loc4_.dispose();
               this._items.splice(_loc3_,1);
               _loc2_--;
            }
            else
            {
               _loc3_++;
            }
         }
      }
      
      public function replaceTarget(param1:FObject, param2:FObject) : void
      {
         var _loc3_:int = this._items.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this._items[_loc4_].target == param1)
            {
               this._items[_loc4_].target = param2;
            }
            _loc4_++;
         }
      }
      
      public function onOwnerSizeChanged(param1:Number, param2:Number, param3:Boolean) : void
      {
         var _loc4_:FRelationItem = null;
         if(this._items.length == 0)
         {
            return;
         }
         for each(_loc4_ in this._items)
         {
            _loc4_.applySelfSizeChanged(param1,param2,param3);
         }
      }
      
      public function reset() : void
      {
         var _loc1_:int = this._items.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this._items[_loc2_].dispose();
            _loc2_++;
         }
         this._items.length = 0;
         this._widthLocked = false;
         this._heightLocked = false;
      }
      
      public function get isEmpty() : Boolean
      {
         return this._items.length == 0;
      }
      
      public function read(param1:XData, param2:Boolean = false) : void
      {
         var _loc4_:String = null;
         var _loc5_:FObject = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:FRelationItem = null;
         var _loc9_:XData = null;
         var _loc10_:Boolean = false;
         var _loc11_:String = null;
         if(param2)
         {
            this.reset();
         }
         else
         {
            _loc6_ = this._items.length;
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc8_ = this._items[_loc7_];
               if(!_loc8_.readOnly)
               {
                  _loc8_.dispose();
                  this._items.splice(_loc7_,1);
                  _loc6_--;
               }
               else
               {
                  _loc7_++;
               }
            }
         }
         var _loc3_:XDataEnumerator = param1.getEnumerator("relation");
         if(param2)
         {
            this._widthLocked = false;
            this._heightLocked = false;
         }
         while(_loc3_.moveNext())
         {
            _loc9_ = _loc3_.current;
            _loc4_ = _loc9_.getAttribute("target");
            if(param2)
            {
               _loc5_ = FComponent(this._owner).getChildById(_loc4_);
            }
            else if(this._owner._parent)
            {
               if(_loc4_)
               {
                  _loc5_ = this._owner._parent.getChildById(_loc4_);
               }
               else
               {
                  _loc5_ = this._owner._parent;
               }
            }
            if(_loc5_)
            {
               _loc10_ = param2 && !FObjectFlags.isDocRoot(this._owner._flags);
               _loc11_ = _loc9_.getAttribute("sidePair");
               _loc8_ = this.getItem(_loc5_);
               if(!_loc8_)
               {
                  _loc8_ = new FRelationItem(this._owner);
                  _loc8_.set(_loc5_,_loc11_,_loc10_);
                  this._items.push(_loc8_);
               }
               else
               {
                  _loc8_.addDefs(_loc11_,false);
               }
               if(_loc10_)
               {
                  this._widthLocked = _loc8_.containsWidthRelated;
                  this._heightLocked = _loc8_.containsHeightRelated;
               }
            }
         }
      }
      
      public function write(param1:XData = null) : XData
      {
         var _loc2_:FRelationItem = null;
         var _loc3_:XData = null;
         if(!param1)
         {
            param1 = XData.create("relations");
         }
         var _loc4_:int = this._items.length;
         var _loc5_:Boolean = FObjectFlags.isDocRoot(this._owner._flags);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc2_ = this._items[_loc6_];
            if(!(!_loc5_ && _loc2_.readOnly))
            {
               _loc3_ = XData.create("relation");
               if(_loc2_.target == this._owner._parent)
               {
                  _loc3_.setAttribute("target","");
               }
               else
               {
                  _loc3_.setAttribute("target",_loc2_.target._id);
               }
               _loc3_.setAttribute("sidePair",_loc2_.desc);
               param1.appendChild(_loc3_);
            }
            _loc6_++;
         }
         return param1;
      }
   }
}
